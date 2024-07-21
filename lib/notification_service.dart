import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notifications.initialize(
      initializationSettings,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id: id,
      channelId: 'birthday_channel',
      channelName: 'Birthday Reminders',
      channelDescription: 'Channel for birthday reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Birthday Reminder',
      title: title,
      body: body,
      when: scheduledDate.millisecondsSinceEpoch,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  static Future<void> cancelNotification({required int id}) async {
    await _notifications.cancel(id);
  }
}
