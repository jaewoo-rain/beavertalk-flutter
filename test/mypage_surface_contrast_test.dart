// Guards the MyPage analysis cards against the "child surface repaints its
// parent's colour" class of bug — the one that made the two CTAs invisible in
// Dark.
//
// Why a test instead of an on-device check: the only handset we verify on is a
// Galaxy S8 (Android 9 / API 28), and system dark mode did not exist before
// Android 10. Samsung's own night theme does not flip the framework's
// `uiMode` night flag, so `platformBrightness` — and therefore
// `themeMode: system` — can never resolve to dark there. Dark is simply not
// reachable on that device; it has to be asserted here.
//
// The failure this locks down: `backgroundNormalAlternative` and
// `backgroundSurfaceAlternative` are both #252932 in Dark and differ only in
// Light. A CTA painted with the former inside a card painted with the latter
// looks correct in Light and vanishes in Dark.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';

void main() {
  Future<void> pumpMyPage(WidgetTester tester, AppColorTokens tokens) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(extensions: [tokens]),
          home: const MyPageScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 32));
  }

  /// Fill actually painted by [button] — [Button] renders a [Material] whose
  /// `color` is the resolved token, so this is the colour on screen rather
  /// than the token we hoped it would pick.
  Color fillOf(WidgetTester tester, Element button) => tester
      .widget<Material>(
        find.descendant(
          of: find.byElementPredicate((e) => e == button),
          matching: find.byType(Material),
        ),
      )
      .color!;

  for (final (name, tokens) in <(String, AppColorTokens)>[
    ('dark', AppColorTokens.dark),
    ('light', AppColorTokens.light),
  ]) {
    testWidgets('MyPage CTAs stay distinct from the card in $name',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await pumpMyPage(tester, tokens);

      final buttons = find.byType(Button).evaluate().toList();
      // 레벨 테스트 다시하기 + 발음 학습하기 + 수업 카드(참여 코드 입력).
      // 수업 카드는 숙제 진입점이라 목록을 못 받아도 참여 전 모습으로 늘 그린다.
      expect(buttons, hasLength(3), reason: 'MyPage should render every CTA');

      for (final b in buttons) {
        expect(
          fillOf(tester, b),
          isNot(tokens.backgroundSurfaceAlternative),
          reason: 'A CTA painted in the card\'s own colour is invisible; '
              'this is exactly what secondaryFill did in Dark.',
        );
      }
    });
  }

  test('the two surface tokens really are indistinguishable in Dark', () {
    // The premise of the test above. If a future token edit pulls these apart,
    // the guard is no longer load-bearing and this test says so out loud.
    expect(
      AppColorTokens.dark.backgroundNormalAlternative,
      AppColorTokens.dark.backgroundSurfaceAlternative,
      reason: 'Dark collapses both to #252932 — that is why Light-only '
          'review cannot catch this bug.',
    );
    expect(
      AppColorTokens.light.backgroundNormalAlternative,
      isNot(AppColorTokens.light.backgroundSurfaceAlternative),
    );
  });
}
