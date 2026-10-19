// 로그인 약관 안내(PM-DEC-818·827·837) — 계속하면 동의한 것으로 보므로, 간편 로그인 버튼 바로 위에
// 스크롤 없이 전체 문구가 보여야 한다(375×812).

import 'package:beavertalk/features/auth/presentation/providers/auth_controller.dart';
import 'package:beavertalk/features/auth/presentation/providers/language_sheet_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/auth/login.dart';
import 'package:beavertalk/screens/auth/terms_notice.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
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

Future<void> _pump(WidgetTester tester, Locale locale) async {
  tester.view.physicalSize = const Size(375, 812);
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
      theme: ThemeData(extensions: const [AppColorTokens.light]),
      home: const LoginScreen(),
    ),
  ));
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  for (final locale in const [Locale('ko'), Locale('en')]) {
    testWidgets('${locale.languageCode}: 안내가 간편 로그인 버튼 위 · 화면 안에 전부 보임', (tester) async {
      await _pump(tester, locale);
      final l10n = AppLocalizations.of(tester.element(find.byType(LoginScreen)));
      final notice = tester.getRect(find.byType(TermsNotice));
      final kakao = tester.getRect(find.text(l10n.loginContinueWithKakao));
      expect(notice.bottom, lessThan(kakao.top));
      expect(notice.top, greaterThanOrEqualTo(0));
      expect(notice.bottom, lessThanOrEqualTo(812));
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
