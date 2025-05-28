import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final StreamController<NotificationResponse> streamController =
      StreamController<NotificationResponse>.broadcast();
  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future init() async {
    tz.initializeTimeZones();
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void showDailyMorningNotification(DateTime scheduledTime) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'daily_morning_notification',
      'Daily Morning Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Good Morning!',
      'Time to start your day with healthy habits!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(android: android),
      payload: 'morning_notification',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void showDailyEveningNotification(DateTime scheduledTime) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'daily_evening_notification',
      'Daily Evening Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Good Evening!',
      'Time to wind down and relax.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(android: android),
      payload: 'evening_notification',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void scheduleToothbrushReplacementNotification(
      DateTime replacementDate) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'toothbrush_replacement_notification',
      'Toothbrush Replacement',
      importance: Importance.max,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      'Replace Toothbrush',
      'It\'s time to replace the toothbrush!',
      tz.TZDateTime.from(replacementDate, tz.local),
      const NotificationDetails(android: android),
      payload: 'toothbrush_replacement_notification',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void scheduleDentalVisitNotification(DateTime notificationDateTime) {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'dental_visit_notification',
      'Dental Visit',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails details = NotificationDetails(android: android);

    LocalNotificationService.flutterLocalNotificationsPlugin.zonedSchedule(
      4,
      'Dental Visit',
      'Don\'t forget your dental visit today!',
      tz.TZDateTime.from(notificationDateTime, tz.local),
      details,
      payload: 'dental_visit_notification',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void showDailySchduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'daily schduled notification',
      'id 4',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    var currentTime = tz.TZDateTime.now(tz.local);
    var scheduleTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      currentTime.hour,
      7,
    );
    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(hours: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      5,
      'Daily Schduled Notification',
      'body',
      scheduleTime,
      details,
      payload: 'zonedSchedule',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
