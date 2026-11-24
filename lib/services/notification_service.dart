import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await plugin.initialize(settings: settings);

    await plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'water_reminders',
        'Water Reminders',
        channelDescription: 'Water usage reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await plugin.show(
      id: 0,
      title: 'AquaTrack Reminder',
      body: 'Remember to track your water usage today!',
      notificationDetails: details,
    );
  }

  static Future<void> scheduleDaily(int hour, int minute) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'water_reminders',
        'Water Reminders',
        channelDescription: 'Daily water usage reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await plugin.zonedSchedule(
      id: 1,
      title: 'AquaTrack Reminder',
      body: 'Have you tracked your water usage today?',
      scheduledDate: scheduled,
      notificationDetails: details,
      androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelReminder() async {
    await plugin.cancel(id: 1);
  }
}