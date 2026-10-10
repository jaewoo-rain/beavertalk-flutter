import 'package:beavertalk/features/subscription/domain/plan_prices.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 남은판단 P12 — 페이월 둘째 줄 「튜터 1시간 $25 · Premium 한 달 {price}」.
///
/// $25 는 달러 고정 사실이라, Premium 가격이 USD 일 때만 그린다.
/// 원화 스토어에서 그리면 서로 다른 통화를 비교하는 문장이 된다.
void main() {
  StorePrice price(String display, double raw, String code) =>
      StorePrice(display: display, raw: raw, currencyCode: code);

  void adopt(String code, String monthly) => PlanPrices.adopt(
        proMonthly: price(monthly, 1, code),
        proYearly: price(monthly, 1, code),
        maxMonthly: price(monthly, 1, code),
        maxYearly: price(monthly, 1, code),
      );

  tearDown(PlanPrices.reset);

  Future<AppLocalizations> pump(WidgetTester tester, PaywallVariant v) async {
    await tester.binding.setSurfaceSize(const Size(375, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: PaywallScreen(variant: v),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return AppLocalizations.of(tester.element(find.byType(PaywallScreen)));
  }

  testWidgets('list fallback (USD) shows the tutor line', (tester) async {
    final l10n = await pump(tester, PaywallVariant.max);
    expect(find.text(l10n.paywallTutorCompare(r'$23.99')), findsOneWidget);
  });

  testWidgets('USD storefront quotes the store price', (tester) async {
    adopt('USD', r'$19.99');
    final l10n = await pump(tester, PaywallVariant.max);
    expect(find.text(l10n.paywallTutorCompare(r'$19.99')), findsOneWidget);
  });

  testWidgets('non-USD storefront hides the line', (tester) async {
    adopt('KRW', '₩33,000');
    await pump(tester, PaywallVariant.max);
    expect(find.textContaining(r'$25'), findsNothing);
  });

  testWidgets('limit paywall keeps its one-line header', (tester) async {
    await pump(tester, PaywallVariant.proLimit);
    expect(find.textContaining(r'$25'), findsNothing);
  });
}
