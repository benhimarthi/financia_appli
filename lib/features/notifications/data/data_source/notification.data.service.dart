import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app.notification.dart';

class NotificationDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId; // Or adminId if only admin can add notifications

  NotificationDataService(this.userId);

  CollectionReference get _notificationsRef =>
      _firestore.collection('users').doc(userId).collection('notifications');

  /// Add a new notification
  Future<void> addNotification(AppNotification notification) async {
    await _notificationsRef.doc(notification.id).set(notification.toMap());
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({'read': true});
  }

  /// Get all notifications (real-time)
  Stream<List<AppNotification>> getNotifications() {
    return _notificationsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => AppNotification.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.doc(notificationId).delete();
  }
}
