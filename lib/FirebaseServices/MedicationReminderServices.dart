import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    // 🔹 Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // use your local tz

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettingIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingIos,
    );

    await notificationPlugin.initialize(initSettings);

    // iOS & Android 13+ permissions
    await notificationPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  Future<void> scheduleReminder(
    String title,
    String body,
    tz.TZDateTime scheduledDate,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Medicine Reminders',
      channelDescription: 'Channel for medicine reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    // const details = NotificationDetails(android: androidDetails);

    await notificationPlugin.zonedSchedule(
      0,
      'Medicine Reminder',
      'Time to take your medicine',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleFirebaseReminders(String userId) async {
    await initNotification(); // ✅ Ensure initialized

    final reminders =
        await fireStore
            .collection('patients')
            .doc(userId)
            .collection("reminders")
            .doc('default')
            .collection('medicine')
            .get();

    for (var doc in reminders.docs) {
      var data = doc.data();

      String medicineName = data['pillName'];
      String description = data['desc'];

      DateTime normalDateTime = (data['time'] as Timestamp).toDate();
      tz.TZDateTime tzDateTime = tz.TZDateTime.from(normalDateTime, tz.local);

      await scheduleReminder(medicineName, description, tzDateTime);
    }
  }
}
