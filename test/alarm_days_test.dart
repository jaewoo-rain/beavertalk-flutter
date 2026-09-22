import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:beavertalk/components/organisms/bottom_sheet_alarm_settings.dart' show Meridiem;
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/alarm/alarm_days.dart';
import 'package:beavertalk/screens/alarm/alarm_models.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ko');
    await initializeDateFormatting('fr');
    await initializeDateFormatting('vi');
  });

  AlarmData data(int h24) {
    final d = AlarmData(hour: 12, minute: 5, meridiem: Meridiem.am, days: List.filled(7, false), characterId: 1);
    d.hour24 = h24;
    return d;
  }

  test('24시간 ↔ 12시간 왕복 — 자정·정오가 경계다', () {
    for (var h = 0; h < 24; h++) {
      expect(data(h).hour24, h, reason: '$h');
    }
    expect((data(0)..minute = 5).clock24, '0:05');
    expect(data(0).hour, 12);
    expect(data(0).meridiem, Meridiem.am);
    expect(data(12).hour, 12);
    expect(data(12).meridiem, Meridiem.pm);
  });

  testWidgets('요약 — 매일·평일·주말·반복 안 함·그 밖엔 월→일 약칭', (t) async {
    late AppLocalizations l10n;
    await t.pumpWidget(MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (c) {
        l10n = AppLocalizations.of(c);
        return const SizedBox();
      }),
    ));
    List<bool> on(Set<int> s) => [for (var i = 0; i < 7; i++) s.contains(i)];
    expect(AlarmDays.summary(on({0, 1, 2, 3, 4, 5, 6}), l10n, 'ko'), '매일');
    expect(AlarmDays.summary(on({1, 2, 3, 4, 5}), l10n, 'ko'), '평일');
    expect(AlarmDays.summary(on({0, 6}), l10n, 'ko'), '주말');
    expect(AlarmDays.summary(on({}), l10n, 'ko'), '반복 안 함');
    // 일요일이 데이터 0 번이어도 화면은 월요일부터 — 일은 맨 뒤.
    expect(AlarmDays.summary(on({0, 1, 3}), l10n, 'ko'), '월 · 수 · 일');
  });

  testWidgets('vi — 약칭 자체에 공백이 있다(Th 2). 요약에서 요일 경계가 보여야 한다', (t) async {
    late AppLocalizations l10n;
    await t.pumpWidget(MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (c) {
        l10n = AppLocalizations.of(c);
        return const SizedBox();
      }),
    ));
    final s = AlarmDays.summary(
        [false, true, true, false, false, false, true], l10n, 'vi');
    final labels = AlarmDays.shortLabels('vi');
    expect(labels[1].contains(' '), isTrue, reason: '전제: vi 약칭에 공백이 있다 ($labels)');
    expect(s.split(' · '), [labels[1], labels[2], labels[6]]);
  });

  test('약칭은 로케일을 따른다 — 한 글자로 줄이지 않는다(fr 가 겹치지 않는다)', () {
    final fr = AlarmDays.shortLabels('fr');
    expect(fr.toSet().length, 7, reason: 'L M M 처럼 겹치면 안 된다: $fr');
    expect(AlarmDays.shortLabels('ko')[1], '월');
  });
}
