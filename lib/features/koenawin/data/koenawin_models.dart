import 'dart:convert';

import 'package:flutter/services.dart';

const _weekdayIds = {
  'monday': DateTime.monday,
  'tuesday': DateTime.tuesday,
  'wednesday': DateTime.wednesday,
  'thursday': DateTime.thursday,
  'friday': DateTime.friday,
  'saturday': DateTime.saturday,
  'sunday': DateTime.sunday,
};

/// One of the nine Buddha attributes (ဂုဏ်တော်).
class Attribute {
  const Attribute({
    required this.id,
    required this.name,
    required this.meaning,
  });

  factory Attribute.fromJson(Map<String, dynamic> j) => Attribute(
    id: j['id'] as int,
    name: j['name'] as String,
    meaning: j['meaning'] as String,
  );

  final int id;
  final String name;
  final String meaning;
}

/// One day of the 81-day schedule.
class KoeNaWinDay {
  const KoeNaWinDay({
    required this.number,
    required this.stage,
    required this.dayInStage,
    required this.weekday,
    required this.attribute,
    required this.rounds,
    required this.vegetarian,
  });

  /// 1–81
  final int number;
  final int stage;
  final int dayInStage;

  /// DateTime.weekday value
  final int weekday;
  final Attribute attribute;
  final int rounds;
  final bool vegetarian;
}

class Stage {
  const Stage({required this.number, required this.name, required this.days});

  final int number;
  final String name;
  final List<KoeNaWinDay> days;

  KoeNaWinDay get vegetarianDay => days.firstWhere((d) => d.vegetarian);
}

/// Everything loaded from assets/data (generated from KoeNaWin.xlsx by tools/build_data.py).
class KoeNaWinData {
  const KoeNaWinData({required this.stages, required this.attributes});

  final List<Stage> stages;
  final List<Attribute> attributes;

  static const totalDays = 81;

  List<KoeNaWinDay> get days => [for (final s in stages) ...s.days];

  KoeNaWinDay day(int number) =>
      stages[(number - 1) ~/ 9].days[(number - 1) % 9];

  static KoeNaWinData parse(String scheduleJson, String attributesJson) {
    final attributes = [
      for (final a in jsonDecode(attributesJson) as List)
        Attribute.fromJson(a as Map<String, dynamic>),
    ];
    final byId = {for (final a in attributes) a.id: a};
    final schedule = jsonDecode(scheduleJson) as Map<String, dynamic>;
    final stages = [
      for (final s in schedule['stages'] as List)
        Stage(
          number: s['stage'] as int,
          name: s['name'] as String,
          days: [
            for (final d in s['days'] as List)
              KoeNaWinDay(
                number: d['day'] as int,
                stage: s['stage'] as int,
                dayInStage: d['dayInStage'] as int,
                weekday: _weekdayIds[d['weekday']]!,
                attribute: byId[d['attributeId']]!,
                rounds: d['rounds'] as int,
                vegetarian: d['vegetarian'] as bool,
              ),
          ],
        ),
    ];
    return KoeNaWinData(stages: stages, attributes: attributes);
  }

  static Future<KoeNaWinData> load() async => parse(
    await rootBundle.loadString('assets/data/koenawin_schedule.json'),
    await rootBundle.loadString('assets/data/attributes.json'),
  );
}
