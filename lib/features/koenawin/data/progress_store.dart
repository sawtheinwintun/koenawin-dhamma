import 'package:shared_preferences/shared_preferences.dart';

/// Saved adhitthana progress: the date day 1 fell on and the last day marked done.
class Progress {
  const Progress({required this.startDate, required this.lastCompletedDay});

  final DateTime startDate;

  /// 0 when nothing is done yet, 81 when finished.
  final int lastCompletedDay;

  Progress copyWith({int? lastCompletedDay}) => Progress(
    startDate: startDate,
    lastCompletedDay: lastCompletedDay ?? this.lastCompletedDay,
  );
}

class ProgressStore {
  static const _startKey = 'koenawin.startDate';
  static const _doneKey = 'koenawin.lastCompletedDay';

  Future<Progress?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final start = prefs.getString(_startKey);
    if (start == null) return null;
    return Progress(
      startDate: DateTime.parse(start),
      lastCompletedDay: prefs.getInt(_doneKey) ?? 0,
    );
  }

  Future<void> write(Progress p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _startKey,
      p.startDate.toIso8601String().substring(0, 10),
    );
    await prefs.setInt(_doneKey, p.lastCompletedDay);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_startKey);
    await prefs.remove(_doneKey);
  }
}
