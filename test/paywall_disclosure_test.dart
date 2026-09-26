import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 페이월 결제 직전 고지 — 고른 주기를 따른다.
///
/// QA F040(09-26 · S2): 「연간」 을 골라도 CTA 아래 고지가 「월 $23.99 · 언제든 스토어에서 해지
/// 가능」 으로 남았다. 결제 직전 금액·주기 고지가 선택과 다르면 과금 고지 오류다(3.1.2).
void main() {
  testWidgets('월간 → 「per month」 · 연간을 고르면 「per year」', (tester) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PaywallScreen(variant: PaywallVariant.max),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 32));

    Finder caption(String unit) =>
        find.textContaining('$unit · cancel anytime in the store');
    expect(caption('per month'), findsOneWidget);
    expect(caption('per year'), findsNothing);

    await tester.ensureVisible(find.text('Annual'));
    await tester.tap(find.text('Annual'));
    await tester.pump();
    expect(caption('per year'), findsOneWidget);
    expect(caption('per month'), findsNothing);
  });
}
