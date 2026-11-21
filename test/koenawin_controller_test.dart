import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:koenawin_dhamma/features/koenawin/data/koenawin_models.dart';
import 'package:koenawin_dhamma/features/koenawin/data/progress_store.dart';
import 'package:koenawin_dhamma/features/koenawin/logic/koenawin_controller.dart';
import 'package:koenawin_dhamma/features/koenawin/logic/reminder_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeReminders implements Reminders {
  int scheduledFrom = 0;
  int cancels = 0;

  @override
  Future<void> scheduleRemaining({
    required DateTime startDate,
    required int fromDay,
    required KoeNaWinData data,
  }) async => scheduledFrom = fromDay;

  @override
  Future<void> cancelAll() async => cancels++;
}

final data = KoeNaWinData.parse(
  File('assets/data/koenawin_schedule.json').readAsStringSync(),
  File('assets/data/attributes.json').readAsStringSync(),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Monday 23 Nov 2026
  final monday = DateTime(2026, 11, 23);
  late DateTime now;
  late FakeReminders reminders;

  Future<KoeNaWinController> make() async {
    final c = KoeNaWinController(
      store: ProgressStore(),
      reminders: reminders,
      loadData: () async => data,
      clock: () => now,
    );
    await c.init();
    return c;
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    now = monday.add(const Duration(hours: 9));
    reminders = FakeReminders();
  });

  test('schedule data matches the Excel sheet', () {
    expect(data.days, hasLength(81));
    expect(data.day(1).weekday, DateTime.monday);
    expect(data.day(1).attribute.name, 'သမ္မာသမ္ဗုဒ္ဓေါ');
    expect(data.day(81).weekday, DateTime.thursday);
    for (final d in data.days) {
      expect(d.rounds, d.attribute.id);
      expect(d.vegetarian, d.dayInStage == 5);
    }
    expect(data.stages[1].vegetarianDay.weekday, DateTime.sunday);
  });

  test(
    'new joiner on Monday starts at day 1 and schedules reminders from day 2',
    () async {
      final c = await make();
      expect(c.status, KoeNaWinStatus.notJoined);
      expect(c.isMonday, isTrue);
      await c.startNew();
      expect(c.status, KoeNaWinStatus.active);
      expect(c.todayNumber, 1);
      expect(c.doneToday, isFalse);
      expect(reminders.scheduledFrom, 2);
      await c.markTodayDone();
      expect(c.doneToday, isTrue);
    },
  );

  test('progress survives a restart on the next day', () async {
    var c = await make();
    await c.startNew();
    await c.markTodayDone();
    now = now.add(const Duration(days: 1));
    c = await make();
    expect(c.status, KoeNaWinStatus.active);
    expect(c.todayNumber, 2);
    expect(c.todayDay!.attribute.name, 'ဘဂဝါ');
  });

  test('a missed day resets progress and reports the missed day', () async {
    var c = await make();
    await c.startNew();
    await c.markTodayDone();
    now = now.add(const Duration(days: 2)); // day 2 skipped
    c = await make();
    expect(c.missedDay, 2);
    expect(c.missedWeekday(), DateTime.tuesday);
    expect(c.status, KoeNaWinStatus.notJoined);
    expect(await ProgressStore().read(), isNull);
    expect(reminders.cancels, greaterThan(0));
  });

  test('existing joiner can only resume on a day matching today', () async {
    now = DateTime(2026, 11, 28, 9); // Saturday
    final c = await make();
    final stage2 = data.stages[1];
    final allowed = stage2.days
        .where(c.canResumeOn)
        .map((d) => d.number)
        .toList();
    expect(allowed, [13]); // stage 2, day 4 is a Saturday
    await c.resumeAt(13);
    expect(c.todayNumber, 13);
    expect(c.lastCompletedDay, 12);
    expect(c.startDate, DateTime(2026, 11, 16));
  });

  test('finishing day 81 completes, then acknowledging resets', () async {
    now = DateTime(2027, 2, 11, 9); // Thursday, day 81 for a 23 Nov start
    final c = await make();
    await c.resumeAt(81);
    await c.markTodayDone();
    expect(c.status, KoeNaWinStatus.completed);
    await c.acknowledgeCompletion();
    expect(c.status, KoeNaWinStatus.notJoined);
  });

  test('leaving deletes all records', () async {
    final c = await make();
    await c.startNew();
    await c.leave();
    expect(c.status, KoeNaWinStatus.notJoined);
    expect(await ProgressStore().read(), isNull);
  });
}
