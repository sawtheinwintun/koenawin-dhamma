import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:koenawin_dhamma/features/dhamma/data/gatha.dart';

void main() {
  final gathas = Gatha.parse(
    File('assets/data/gathas.json').readAsStringSync(),
  );

  test('all 14 gathas load with the Figma titles', () {
    expect(gathas, hasLength(14));
    expect(gathas.first.title, 'မေတ္တသုတ်');
    expect(gathas[12].title, 'နေထိုင်-ပညာ-စီးပွား');
    expect(gathas.every((g) => g.items.isNotEmpty), isTrue);
  });

  test('metta sutta has 12 numbered verses and a closing line', () {
    final metta = gathas.first;
    expect(metta.items.where((i) => i.number != null), hasLength(12));
    expect(metta.items.last.number, isNull);
  });

  test('section headings are kept', () {
    final headings = gathas[12].items
        .where((i) => i.isHeading)
        .map((i) => i.text);
    expect(headings, ['နေထိုင်ရေး', 'ပညာရေး', 'စီးပွားရေး']);
  });
}
