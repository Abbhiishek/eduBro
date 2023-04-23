import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sensei/core/failure.dart';
import 'package:sensei/core/type_defs.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/notification/repository/notification_repository.dart';
import 'package:sensei/models/notification_model.dart';

final userNotificationsProvider = StreamProvider((ref) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getUserNotications();
});

final getnotificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController;
});

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>(
  (ref) => NotificationController(
    notificationRepository: ref.watch(notificationRepositoryProvider),
    ref: ref,
  ),
);

class NotificationController extends StateNotifier<bool> {
  final NotificationRepository _notificationRepository;

  final Ref _ref;

  NotificationController({
    required NotificationRepository notificationRepository,
    required Ref ref,
  })  : _notificationRepository = notificationRepository,
        _ref = ref,
        super(false);

  /// *** Get all notifications for a user ***
  ///
  /// This will return a stream of list of notifications
  ///
  /// This will be used to show notifications in the notification screen

  Stream<List<NotificationModel>> getUserNotications() {
    final uid = _ref.read(userProvider)!.uid;
    return _notificationRepository.getUserNotications(uid);
  }

  /// *** Create a new notiifcation and add that notication id to user model for provider fectching ***
  ///
  /// This will return a void
  ///
  /// This will be used to create a new notification
  ///

  FutureVoid createNotification(NotificationModel notification) async {
    try {
      return await _notificationRepository.createNotification(notification);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** Delete a notification ***
  ///
  /// This will return a void
  ///
  /// This will be used to delete a notification

  FutureVoid deleteNotification(String notificationId) async {
    try {
      return await _notificationRepository.deleteNotification(notificationId);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** Delete all notifications ***
  ///
  /// This will return a void
  ///
  /// This will be used to delete all notifications
  ///

  FutureVoid deleteAllNotifications() async {
    try {
      return await _notificationRepository.deleteAllNotifications();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** Update a notification as isRead = true***
  ///
  /// This will return a void
  /// A notification is required as argument
  /// This will be used to update a notification

  FutureVoid setNotificationToRead(String notificationid) async {
    try {
      return await _notificationRepository
          .setNotificationToRead(notificationid);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Use this method to detect when a new notification or a schedule is created
}
