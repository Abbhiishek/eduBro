import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sensei/core/constants/firebase_constants.dart';
import 'package:sensei/core/enums/enums.dart';
import 'package:sensei/core/failure.dart';
import 'package:sensei/core/type_defs.dart';
import 'package:sensei/models/post_model.dart';
import 'package:sensei/models/user_model.dart';
import '../../../core/providers/firebase_provider.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      // check if the username passed is already taken
      var userDoc = await _users.doc(user.uid).get();
      if (userDoc.exists) {
        var usernameDoc = await _users
            .where('username', isEqualTo: user.username)
            .where('uid', isNotEqualTo: user.uid)
            .get();
        if (usernameDoc.docs.isNotEmpty) {
          throw 'Username already taken!';
        }
      }
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // * Follow and Unfollow User

  FutureVoid followUser(UserModel user, String uid) async {
    try {
      _users.doc(uid).update({
        'followers': FieldValue.arrayUnion([user.uid]),
      });
      return right(_users.doc(user.uid).update({
        'following': FieldValue.arrayUnion([uid]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid unFollowUser(UserModel user, String uid) async {
    try {
      _users.doc(uid).update({
        'followers': FieldValue.arrayRemove([user.uid]),
      });
      return right(_users.doc(user.uid).update({
        'following': FieldValue.arrayRemove([uid]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
