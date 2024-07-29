import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class LocalNotifications {
  LocalNotifications._();
  static final LocalNotifications localNotifications = LocalNotifications._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
    const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          log("************");
          log("${response.payload}");
          log("************");
        });
  }
  Future<void> showSimpleNotification(
      {required String? title, required String? body}) async {
    await initLocalNotifications();

    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails("1", "Simple Notification Channel",
        priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        1, title ?? "Sample", body ?? "Dummy", notificationDetails,
        payload: "Sample Payload");
  }


}