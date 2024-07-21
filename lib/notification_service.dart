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
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name', channelDescription: 'Birthday Reminder');
    final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, {required int id}) async {
    await _notifications.cancel(id);
  }
}
