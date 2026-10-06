import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
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

  // PM-DEC-405(App Review 3.1.2): 구독 구매 화면은 두 판 모두 구매 복원 · 이용약관 · 개인정보를
  // 보여야 한다. 기본판(/paywall/max)에서 빠져 있던 것을 막는다 · 한도판은 회귀 확인.
  for (final variant in PaywallVariant.values) {
    testWidgets('$variant — 구매 복원 · 이용약관 · 개인정보 링크가 있다', (tester) async {
      tester.view.physicalSize = const Size(375, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PaywallScreen(variant: variant),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 32));
      for (final label in ['Restore purchases', 'Terms', 'Privacy']) {
        expect(find.text(label), findsOneWidget, reason: '$variant 에 「$label」 이 없다');
      }
    });
  }

  testWidgets('F078 — 스토어가 체험 오퍼를 준 경우에만 「7 days free」 (주기별)', (tester) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    Future<void> pumpWith(List<IapProduct> products) async {
      await tester.pumpWidget(ProviderScope(
        key: UniqueKey(),
        overrides: [
          storePricesProvider.overrideWith((ref) async => products),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PaywallScreen(variant: PaywallVariant.max),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 32));
    }

    IapProduct sub(String id, {required bool trial}) => IapProduct(
        id: id,
        type: IapProductType.subscription,
        localizedPrice: r'$1',
        freeTrial: trial);

    // 월간만 체험 자격.
    await pumpWith([
      sub(IapProductIds.maxMonthly, trial: true),
      sub(IapProductIds.maxYearly, trial: false),
    ]);
    expect(find.textContaining('7 days free, then'), findsOneWidget);
    await tester.ensureVisible(find.text('Annual'));
    await tester.tap(find.text('Annual'));
    await tester.pump();
    expect(find.textContaining('7 days free'), findsNothing);
    expect(find.textContaining('per year · cancel anytime'), findsOneWidget);

    // 연간 체험 자격.
    await pumpWith([sub(IapProductIds.maxYearly, trial: true)]);
    await tester.ensureVisible(find.text('Annual'));
    await tester.tap(find.text('Annual'));
    await tester.pump();
    expect(find.textContaining('7 days free, then'), findsOneWidget);
    expect(find.textContaining('per year · cancel anytime'), findsOneWidget);

    // 자격 없음(스토어 모름 포함) — 체험 문구 없음.
    await pumpWith(const []);
    expect(find.textContaining('7 days free'), findsNothing);
  });
}
