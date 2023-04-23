import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sensei/core/enums/enums.dart';
import 'package:sensei/core/failure.dart';
import 'package:sensei/core/providers/storage_repository_provider.dart';
import 'package:sensei/core/utlis.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/notification/repository/notification_repository.dart';
import 'package:sensei/features/user_profile/repository/user_profile_repository.dart';
import 'package:sensei/models/notification_model.dart';
import 'package:sensei/models/post_model.dart';
import 'package:sensei/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    notificationRepository: notificationRepository,
    ref: ref,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final NotificationRepository _notificationRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required NotificationRepository notificationRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _notificationRepository = notificationRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required String name,
    required String bio,
    required String username,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
        webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name, bio: bio, username: username);
    final res = await _userProfileRepository.editProfile(user);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void followUser(String uid) async {
    UserModel user = _ref.read(userProvider)!;
    Either<Failure, void> res;
    if (!user.following.contains(uid)) {
      res = await _userProfileRepository.followUser(user, uid);
    } else {
      res = await _userProfileRepository.unFollowUser(user, uid);
      _notificationRepository.createNotification(NotificationModel(
        id: const Uuid().v1(),
        isRead: false,
        type: 'follow',
        title: "${user.name} Follows you",
        body:
            "${user.name} started following you. Have a look at their profile",
        payload: {
          'follow': user.uid,
        },
        senderId: user.uid,
        receiverId: [uid],
        image: user.profilePic,
        createdAt: DateTime.now(),
      ));
    }
    // also check if the user has already upvoted the post or not to avoid sending multiple notifications

    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
