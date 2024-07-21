import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_launcher'),
    );
    await _notifications.initialize(initializationSettings);
  }

  static Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, {
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name', channelDescription: 'Birthday Reminder');

    await _notifications.show(0, title, body, NotificationDetails(android: androidNotificationDetails));
  }
}
