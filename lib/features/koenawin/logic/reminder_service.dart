import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/utils/myanmar.dart';
import '../data/koenawin_models.dart';

abstract class Reminders {
  /// Schedules one reminder per remaining day, so each names that day's attribute.
  Future<void> scheduleRemaining({
    required DateTime startDate,
    required int fromDay,
    required KoeNaWinData data,
  });
  Future<void> cancelAll();
}

/// Daily 6:00 AM push notifications.
/// Android won't tell an app when the phone is first unlocked, so a fixed early time stands in for
/// "when the phone is switched on in the morning": the notification waits on the lock screen.
class NotificationReminders implements Reminders {
  static const hour = 6;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'koenawin_daily',
      'ကိုးနဝင်း နေ့စဉ်သတိပေးချက်',
      channelDescription:
          'ယနေ့ ဝင်ရမည့် ကိုးနဝင်းအဓိဋ္ဌာန်ကို မနက်တိုင်း သတိပေးပါသည်။',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  Future<void> _init() async {
    if (_ready) return;
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Yangon'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  @override
  Future<void> scheduleRemaining({
    required DateTime startDate,
    required int fromDay,
    required KoeNaWinData data,
  }) async {
    await _init();
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin.cancelAll();
    final now = tz.TZDateTime.now(tz.local);
    for (var n = fromDay; n <= KoeNaWinData.totalDays; n++) {
      final date = startDate.add(Duration(days: n - 1));
      final when = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
      );
      if (when.isBefore(now)) continue;
      final day = data.day(n);
      await _plugin.zonedSchedule(
        id: n,
        scheduledDate: when,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: 'ယနေ့ ကိုးနဝင်းအဓိဋ္ဌာန် (${Myanmar.digits(n)} ရက်မြောက်)',
        body:
            '${day.attribute.name} · ပုတီး (${Myanmar.digits(day.rounds)}) ပတ်'
            '${day.vegetarian ? ' · သက်သတ်လွတ်စားရမည့်နေ့' : ''}',
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
