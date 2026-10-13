// 워크북 정보 줄의 쪽수·단어 수 — 숫자가 화면에 보이므로 1개일 때 단수형이어야 한다.
//
// 빌드 63 까지는 '{count} pages' 라 1쪽이면 '1 pages' 가 나왔다(command center 64 지시).
// 단수·복수 꼴이 갈리는 언어만 ICU plural 로 바꿨다 — 나머지 언어는 숫자 뒤 명사가 변하지 않는다.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';

void main() {
  AppLocalizations l(String code) => lookupAppLocalizations(Locale(code));

  test('en: 1 page · 2 pages · 1 word · 40 words', () {
    expect(l('en').hwWorkbookPages(1), '1 page');
    expect(l('en').hwWorkbookPages(2), '2 pages');
    expect(l('en').hwWorkbookWords(1), '1 word');
    expect(l('en').hwWorkbookWords(40), '40 words');
  });

  test('fr 는 0·1 이 단수', () {
    expect(l('fr').hwWorkbookPages(0), '0 page');
    expect(l('fr').hwWorkbookPages(1), '1 page');
    expect(l('fr').hwWorkbookPages(2), '2 pages');
  });

  test('ru 단어 수는 one·few·many 로 갈린다', () {
    expect(l('ru').hwWorkbookWords(1), '1 слово');
    expect(l('ru').hwWorkbookWords(3), '3 слова');
    expect(l('ru').hwWorkbookWords(5), '5 слов');
    expect(l('ru').hwWorkbookWords(21), '21 слово');
  });

  test('ar 은 1·2·3~10·11~ 가 다르다', () {
    final ar = l('ar');
    expect(ar.hwWorkbookPages(1), 'صفحة واحدة');
    expect(ar.hwWorkbookPages(2), 'صفحتان');
    expect(ar.hwWorkbookPages(3), '3 صفحات');
    expect(ar.hwWorkbookPages(12), '12 صفحة');
  });

  test('모든 언어가 숫자를 그대로 보여 준다(2 이상)', () {
    for (final loc in AppLocalizations.supportedLocales) {
      final x = lookupAppLocalizations(loc);
      expect(x.hwWorkbookPages(12), contains('12'), reason: loc.toString());
      expect(x.hwWorkbookWords(40), contains('40'), reason: loc.toString());
    }
  });
}
