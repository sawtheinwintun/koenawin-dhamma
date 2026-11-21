import 'package:flutter/widgets.dart';

import '../data/koenawin_models.dart';
import '../data/progress_store.dart';
import 'reminder_service.dart';

enum KoeNaWinStatus { loading, notJoined, active, completed }

/// Holds the 81-day schedule and the user's progress, and applies the agreed rules:
/// start only on a Monday, a missed day resets everything, leaving deletes all records.
class KoeNaWinController extends ChangeNotifier with WidgetsBindingObserver {
  KoeNaWinController({
    required ProgressStore store,
    required Reminders reminders,
    Future<KoeNaWinData> Function()? loadData,
    DateTime Function()? clock,
  }) : _store = store,
       _reminders = reminders,
       _loadData = loadData ?? KoeNaWinData.load,
       _clock = clock ?? DateTime.now;

  final ProgressStore _store;
  final Reminders _reminders;
  final Future<KoeNaWinData> Function() _loadData;
  final DateTime Function() _clock;

  late KoeNaWinData data;
  Progress? _progress;
  KoeNaWinStatus status = KoeNaWinStatus.loading;

  /// Set when the last check found a missed day; the screen shows the warning, then calls [consumeMissed].
  int? missedDay;

  DateTime get today {
    final now = _clock();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> init() async {
    data = await _loadData();
    _progress = await _store.read();
    await _evaluate();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        status != KoeNaWinStatus.loading) {
      _evaluate();
    }
  }

  static int _daysBetween(DateTime a, DateTime b) => DateTime.utc(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

  /// Day number (1-based) that falls on today, or null when not joined.
  int? get todayNumber =>
      _progress == null ? null : _daysBetween(_progress!.startDate, today) + 1;

  KoeNaWinDay? get todayDay {
    final n = todayNumber;
    return n == null || n < 1 || n > KoeNaWinData.totalDays
        ? null
        : data.day(n);
  }

  bool get doneToday =>
      _progress != null && _progress!.lastCompletedDay == todayNumber;
  int get lastCompletedDay => _progress?.lastCompletedDay ?? 0;
  DateTime? get startDate => _progress?.startDate;
  DateTime? get endDate => _progress?.startDate.add(
    const Duration(days: KoeNaWinData.totalDays - 1),
  );
  bool get isMonday => today.weekday == DateTime.monday;

  Future<void> _evaluate() async {
    final p = _progress;
    if (p == null) {
      status = KoeNaWinStatus.notJoined;
    } else if (p.lastCompletedDay >= KoeNaWinData.totalDays) {
      status = KoeNaWinStatus.completed;
    } else if (todayNumber! > p.lastCompletedDay + 1) {
      // A day passed without being marked done.
      missedDay = p.lastCompletedDay + 1;
      await _reset();
      return;
    } else {
      status = KoeNaWinStatus.active;
    }
    notifyListeners();
  }

  Future<void> _reset() async {
    _progress = null;
    status = KoeNaWinStatus.notJoined;
    await _store.clear();
    await _reminders.cancelAll();
    notifyListeners();
  }

  /// Weekday of the missed day, for the warning sheet.
  int? missedWeekday() =>
      missedDay == null ? null : data.day(missedDay!).weekday;

  void consumeMissed() {
    missedDay = null;
    notifyListeners();
  }

  Future<void> _begin(int todayDayNumber) async {
    _progress = Progress(
      startDate: today.subtract(Duration(days: todayDayNumber - 1)),
      lastCompletedDay: todayDayNumber - 1,
    );
    await _store.write(_progress!);
    status = KoeNaWinStatus.active;
    notifyListeners();
    await _reminders.scheduleRemaining(
      startDate: _progress!.startDate,
      fromDay: todayDayNumber + 1,
      data: data,
    );
  }

  /// New joiner: only allowed on a Monday (the UI checks [isMonday] first).
  Future<void> startNew() {
    assert(isMonday);
    return _begin(1);
  }

  /// Days in [stage] the user may resume on: only those that fall on today's weekday.
  bool canResumeOn(KoeNaWinDay day) => day.weekday == today.weekday;

  /// Existing joiner: today is day [dayNumber]; earlier days count as done.
  Future<void> resumeAt(int dayNumber) {
    assert(canResumeOn(data.day(dayNumber)));
    return _begin(dayNumber);
  }

  Future<void> markTodayDone() async {
    final n = todayNumber;
    if (n == null || doneToday) return;
    _progress = _progress!.copyWith(lastCompletedDay: n);
    await _store.write(_progress!);
    if (n >= KoeNaWinData.totalDays) {
      status = KoeNaWinStatus.completed;
      await _reminders.cancelAll();
    }
    notifyListeners();
  }

  /// Leaving deletes all records.
  Future<void> leave() => _reset();

  /// After the completion screen: back to the start page.
  Future<void> acknowledgeCompletion() => _reset();
}
