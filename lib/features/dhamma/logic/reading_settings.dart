import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gatha text size, remembered between launches.
class ReadingSettings extends ChangeNotifier {
  static const _key = 'reading.textScale';
  static const min = 0.85;
  static const max = 1.6;
  static const step = 0.15;

  double scale = 1.0;

  bool get canShrink => scale > min + 0.001;
  bool get canGrow => scale < max - 0.001;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    scale = prefs.getDouble(_key) ?? 1.0;
    notifyListeners();
  }

  Future<void> change(int direction) async {
    scale = (scale + step * direction).clamp(min, max);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, scale);
  }
}
