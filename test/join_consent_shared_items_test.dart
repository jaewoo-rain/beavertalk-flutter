// 반 참여 동의 화면 — **모국어는 선생님에게 공유되고, 국적은 공유되지 않는다.**
//
// PM-DEC-542(U9): 교사가 학습자 모국어로 숙제 번역을 보므로 모국어를 공개한다.
// 국적은 계속 비공개다. 항목이 어느 목록에 있는지를 화면 위치로 확인한다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/join_consent.dart';

Future<void> _pump(WidgetTester tester, Locale locale) async {
  tester.view.physicalSize = const Size(390, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const JoinConsentScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in const [Locale('ko'), Locale('en')]) {
    testWidgets('${locale.languageCode}: 모국어는 공유, 국적은 비공유', (tester) async {
      await _pump(tester, locale);
      final l10n = lookupAppLocalizations(locale);

      final notSharedTop = tester
          .getTopLeft(find.text(l10n.hwJoinConsentNotSharedHeading))
          .dy;
      final sharedTop = tester
          .getTopLeft(find.text(l10n.hwJoinConsentSharedHeading))
          .dy;

      final language = tester.getTopLeft(find.text(l10n.hwJoinConsentShared5));
      expect(language.dy, greaterThan(sharedTop));
      expect(language.dy, lessThan(notSharedTop));

      // 참여일·최근 접속일도 공유 목록에 있다(콘솔 명단·CSV 열 · 09 대조표).
      final joined = tester.getTopLeft(find.text(l10n.hwJoinConsentShared6));
      expect(joined.dy, greaterThan(sharedTop));
      expect(joined.dy, lessThan(notSharedTop));

      final nationality = tester.getTopLeft(
        find.text(l10n.hwJoinConsentNotShared3),
      );
      expect(nationality.dy, greaterThan(notSharedTop));

      // 비공유 항목에 모국어가 남아 있지 않다.
      expect(l10n.hwJoinConsentNotShared3, l10n.nationalityLabel);
      expect(l10n.hwJoinConsentShared5, l10n.nativeLanguageLabel);
      // '반 이름'(반의 이름)으로 읽히던 오역을 고쳤다.
      if (locale.languageCode == 'en') {
        expect(l10n.hwJoinConsentShared1, isNot(contains('Class name')));
      }
    });
  }
}
