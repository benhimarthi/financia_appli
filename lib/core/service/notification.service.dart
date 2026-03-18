import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/notifications/data/data_source/notification.data.service.dart';
import '../../features/notifications/data/models/app.notification.dart';
import '../../main.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await _localNotif.initialize(
     settings: initSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleRedirection(payload.payload);
      },
    );

    // Request permissions
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
    }

    // Subscribe to topic
    await FirebaseMessaging.instance.subscribeToTopic("services_updates");

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });

    // Background / user click
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleRedirection(message.data['serviceId']);
    });

    // App terminated click
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      handleRedirection(initialMessage.data['serviceId']);
    }

    // Device token handling
    String? token = await FirebaseMessaging.instance.getToken();
    await saveDeviceToken(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveDeviceToken);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final notificationService = NotificationDataService(
      FirebaseAuth.instance.currentUser!.uid,
    );
    final notification = message.notification;
    if (notification != null) {
      print("########################## ${message.data.entries}");
      final appNotification = AppNotification(
        id:
            message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: notification.title ?? '',
        body: notification.body ?? '',
        createdAt: DateTime.now(),
        serviceId: message.data['serviceId'],
      );

      // Save to Firestore
      if (appNotification.title != "New Service Added!") {
        notificationService.addNotification(appNotification);
      }
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotif.show(
      //DateTime.now().millisecondsSinceEpoch ~/ 1000,
      //message.notification?.title ?? "",
      //message.notification?.body ?? "",
      notificationDetails: details,
      payload: message.data['serviceId'],
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  static Future<void> saveDeviceToken(String? token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || token == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("tokens")
        .doc(token)
        .set({
          "token": token,
          "createdAt": FieldValue.serverTimestamp(),
          "platform": Platform.operatingSystem,
        });
  }

  static void handleRedirection(String? serviceId) {
    if (serviceId == null) return;
    // Navigate to specific service screen
    //navigatorKey.currentState?.pushNamed('/service', arguments: serviceId);
    print("Navigate to service: $serviceId");
  }

  static Future<void> sendTopicNotification(Map<String, dynamic> data) async {
    final callable = FirebaseFunctions.instance.httpsCallable("notifyTopic");
    await callable.call({
      "topic": "services_updates",
      "title": data['name'],
      "body": data['description'],
      "data": {'serviceId': data['id']},
    });
  }

  static Future<void> sendUserNotification(String userId) async {
    final callable = FirebaseFunctions.instance.httpsCallable("notifyUser");
    await callable.call({
      "userId": userId,
      "title": "Personal Update",
      "body": "A service is ready for you",
      "data": {"serviceId": "12345"},
    });
  }
}
