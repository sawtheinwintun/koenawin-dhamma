import 'dart:convert';

import 'package:flutter/services.dart';

/// A heading or a (possibly numbered) verse inside a gatha.
class GathaItem {
  const GathaItem({required this.isHeading, required this.text, this.number});

  factory GathaItem.fromJson(Map<String, dynamic> j) => GathaItem(
    isHeading: j['type'] == 'heading',
    text: j['text'] as String,
    number: j['number'] as int?,
  );

  final bool isHeading;
  final String text;
  final int? number;
}

class Gatha {
  const Gatha({required this.id, required this.title, required this.items});

  factory Gatha.fromJson(Map<String, dynamic> j) => Gatha(
    id: j['id'] as int,
    title: j['title'] as String,
    items: [
      for (final i in j['items'] as List)
        GathaItem.fromJson(i as Map<String, dynamic>),
    ],
  );

  final int id;
  final String title;
  final List<GathaItem> items;

  /// ခင်ပွန်းကြီး (၁၀) ပါး ကန်တော့နည်း is prose; every other gatha is Pali verse.
  bool get isProse => id == 7;

  /// Verse text with one pada per line. Myanmar has no spaces between words, so long lines
  /// would otherwise wrap in the middle of a word.
  String display(GathaItem item) =>
      isProse ? item.text : item.text.replaceAll('၊ ', '၊\n');

  static List<Gatha> parse(String json) => [
    for (final g in jsonDecode(json) as List)
      Gatha.fromJson(g as Map<String, dynamic>),
  ];

  static Future<List<Gatha>>? _cache;

  /// assets/data/gathas.json, generated from KoeNaWin.xlsx by tools/build_data.py.
  static Future<List<Gatha>> loadAll() =>
      _cache ??= rootBundle.loadString('assets/data/gathas.json').then(parse);
}
