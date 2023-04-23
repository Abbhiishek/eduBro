import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sensei/core/constants/firebase_constants.dart';
import 'package:sensei/core/failure.dart';
import 'package:sensei/core/providers/firebase_provider.dart';
import 'package:sensei/core/type_defs.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/models/notification_model.dart';

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) => NotificationRepository(
          firestore: ref.watch(firestoreProvider),
        ));

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final _user =
      FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);

  final _notifications = FirebaseFirestore.instance
      .collection(FirebaseConstants.notificationsCollection);

  // *** Create a new notiifcation and add that notication id to user model for provider fectching ***
  FutureVoid createNotification(NotificationModel notification) async {
    try {
      return right(
          _notifications.doc(notification.body).set(notification.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** Delete a notification ***

  FutureVoid deleteNotification(String notificationId) async {
    try {
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** Delete all notifications ***

  FutureVoid deleteAllNotifications() async {
    try {
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** set  a notification  to isRead true***

  FutureVoid setNotificationToRead(String notificationId) async {
    try {
      return right(_notifications.doc(notificationId).update({
        'isRead': true,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** set all notifications to isRead true***

  FutureVoid setAllNotificationsToRead() async {
    try {
      return right(null);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// *** Get the list of notifications for the  user by its user id ***

  Stream<List<NotificationModel>> getUserNotications(String userId) {
    return _notifications
        .where('receiverId', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      List<NotificationModel> notifications = [];

      for (var doc in event.docs) {
        notifications.add(NotificationModel.fromMap(doc.data()));
      }

      return notifications;
    });
  }

  Stream<NotificationModel> getNotificationById(String notificationId) {
    return _notifications.doc(notificationId).snapshots().map((event) =>
        NotificationModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
