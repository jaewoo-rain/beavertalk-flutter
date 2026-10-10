import 'package:beavertalk/features/legal/legal_urls.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/i18n_data_screens.dart';

/// 설정 Support — 약관 언어 분기(QA F018) · Contact Us 메일(QA F012/F021).
void main() {
  group('약관·처리방침 URL — UI 언어로 고른다', () {
    test('한국어는 한국어판, 그 밖은 영문판', () {
      expect(pickLegalUrl('ko', ko: 'K', en: 'E'), 'K');
      expect(pickLegalUrl('en', ko: 'K', en: 'E'), 'E');
      expect(pickLegalUrl('ja', ko: 'K', en: 'E'), 'E');
    });

    test('영문판이 아직 비었으면 한국어판으로 폴백', () {
      expect(pickLegalUrl('en', ko: 'K', en: ''), 'K');
    });

    test('영문판이 실제로 걸려 있다 — 한국어 외 언어는 한국어판과 다른 주소', () {
      expect(termsOfUseUrlFor('ko'), kTermsOfUseUrl);
      expect(privacyPolicyUrlFor('ko'), kPrivacyPolicyUrl);
      expect(termsOfUseUrlFor('en'), isNot(kTermsOfUseUrl));
      expect(privacyPolicyUrlFor('vi'), isNot(kPrivacyPolicyUrl));
      expect(termsOfUseUrlFor('en'), termsOfUseUrlFor('ja'));
    });

    test('약관은 언제나 앱판(노션) — 웹판 주소로 새지 않는다', () {
      for (final lang in ['ko', 'en', 'vi']) {
        expect(termsOfUseUrlFor(lang), isNot(contains('beavertalk.im/terms')));
        expect(termsOfUseUrlFor(lang), startsWith('https://'));
        expect(privacyPolicyUrlFor(lang), startsWith('https://'));
      }
    });
  });

  group('Contact Us', () {
    test('메일 주소 · 제목에 빌드 — 공백이 + 로 새지 않는다', () {
      final uri = contactMailUri(version: 'v1.0.0 (43)');
      expect(uri.scheme, 'mailto');
      expect(uri.path, 'contact@beavertalk.im');
      expect(uri.toString(), contains('subject=%5BBeaverTalk%5D%20v1.0.0%20(43)'));
      expect(uri.toString(), isNot(contains('+')));
      expect(contactMailUri().toString(), endsWith('subject=%5BBeaverTalk%5D'));
    });

    testWidgets('행이 눌린다 — 전엔 화살표만 있고 무반응이었다', (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(360, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: settingsDataHost(premium: true),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 32));
      final node = tester.getSemantics(find.text('Contact Us'));
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });
  });
}
