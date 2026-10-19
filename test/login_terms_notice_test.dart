// 로그인 약관 안내(PM-DEC-818·827·837 · 10-19 사용자 지시 「아래에 내려」) — 화면 맨 아래(가입 안내 밑)에
// 스크롤 밖에 고정한다 — 계속하면 동의한 것으로 보므로 스크롤 없이 전체 문구가 보여야 한다(375×812).

import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_controller.dart';
import 'package:beavertalk/features/auth/presentation/providers/language_sheet_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/auth/login.dart';
import 'package:beavertalk/screens/auth/terms_notice.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:beavertalk/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Unauthed extends AuthController {
  @override
  AuthStatus build() => AuthStatus.unauthenticated;

  @override
  Future<void> bootstrap() async {}
}

class _Shown extends LanguageSheetShownNotifier {
  @override
  bool build() => true;
}

Future<void> _pump(WidgetTester tester, Locale locale, [Size size = const Size(375, 812)]) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      authControllerProvider.overrideWith(_Unauthed.new),
      languageSheetShownProvider.overrideWith(_Shown.new),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(fontFamily: kFontFamily, extensions: const [AppColorTokens.light]),
      home: const LoginScreen(),
    ),
  ));
  await tester.pump(const Duration(milliseconds: 50));
}

// 높이 단언은 실제 글꼴로 해야 한다 — 기본 시험 글꼴(Ahem)은 글자가 넓어 en 안내가 여러 줄로 부푼다.
Future<void> _fonts() async {
  final loader = FontLoader(kFontFamily);
  for (final w in const ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(rootBundle.load('assets/fonts/Pretendard-$w.otf'));
  }
  await loader.load();
}

void main() {
  setUpAll(_fonts);
  for (final (locale, size) in const [
    (Locale('ko'), Size(375, 812)), (Locale('en'), Size(375, 812)),
    (Locale('ko'), Size(360, 640)), (Locale('en'), Size(360, 640)),
    (Locale('en'), Size(411, 810)), // 실기기 R3CNB0E8VWN(411×882dp − 상태바·내비)
  ]) {
    testWidgets('${locale.languageCode} ${size.width.toInt()}×${size.height.toInt()}: 안내가 스크롤 영역 아래 고정 · 화면 안에 전부 보임', (tester) async {
      await _pump(tester, locale, size);
      final notice = tester.getRect(find.byType(TermsNotice));
      final scroll = tester.getRect(find.byType(SingleChildScrollView));
      expect(find.descendant(of: find.byType(SingleChildScrollView), matching: find.byType(TermsNotice)),
          findsNothing);
      expect(notice.top, greaterThanOrEqualTo(scroll.bottom));
      // 회원가입 줄도 스크롤 밖 바닥에 고정 — 작은 화면에서도 스크롤 없이 보인다(10-19 사용자 확정).
      final l10n = AppLocalizations.of(tester.element(find.byType(LoginScreen)));
      final signup = tester.getRect(find.text(l10n.signUp));
      expect(signup.top, greaterThanOrEqualTo(scroll.bottom));
      expect(signup.bottom, lessThan(notice.top));
      // 이메일 버튼은 고정 영역 위에서 잘리지 않는다 — 작은 화면은 스크롤로 전체에 닿는다(PM-DEC-848).
      final email = find.text(l10n.loginContinueWithEmail);
      if (size.height >= 800) {
        expect(tester.getRect(find.ancestor(of: email, matching: find.byType(Button)).first).bottom,
            lessThanOrEqualTo(scroll.bottom));
      } else {
        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -1000));
        await tester.pump();
      }
      expect(tester.getRect(find.ancestor(of: email, matching: find.byType(Button)).first).bottom,
          lessThanOrEqualTo(scroll.bottom));
      expect(notice.top, greaterThanOrEqualTo(0));
      expect(notice.bottom, lessThanOrEqualTo(size.height));
    });
  }

  testWidgets('문구: 계속하면 동의한 것으로 봄 · 「다음 화면」 언급 없음', (tester) async {
    await _pump(tester, const Locale('ko'));
    final l10n = AppLocalizations.of(tester.element(find.byType(LoginScreen)));
    final ko = '${l10n.loginTermsNoticePrefix}${l10n.termsOfService}${l10n.loginTermsNoticeAnd}'
        '${l10n.privacyPolicy}${l10n.loginTermsNoticeSuffix}';
    expect(ko, '계속하면 이용약관과 개인정보처리방침에 동의하게 됩니다.');
  });
}
