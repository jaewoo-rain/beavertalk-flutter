import 'dart:async';

import 'package:beavertalk/app/routes.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:beavertalk/screens/plans/purchase_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Follow-up run (2026-08-04): the three ordered fixes, pinned as tests.
///
/// 1. Bought tier reaches the status merge (the "bought Max, shows Pro" bug).
/// 2. The paywall's leave guard intercepts back/X with the retention prompt.
/// 3. The purchase funnel honours the billing cycle (annual used to silently
///    buy monthly).
void main() {
  // ── 1. session entitlement merge ────────────────────────────────────────

  group('sessionEntitlement merge', () {
    ProviderContainer container({SubscriptionStatus? server}) {
      final c = ProviderContainer(overrides: [
        if (server != null)
          serverSubscriptionStatusProvider
              .overrideWith((ref) async => server),
      ]);
      addTearDown(c.dispose);
      return c;
    }

    test('buying Max lifts an inferred-Pro status to activeMax', () async {
      const server = SubscriptionStatus(
        state: SubscriptionState.activePro,
        tier: SubscriptionTier.pro,
        isPlanInferred: true,
      );
      final c = container(server: server);
      // Resolve the server future first, then record the purchase.
      await c.read(serverSubscriptionStatusProvider.future);
      c.read(sessionEntitlementProvider.notifier).state =
          SubscriptionTier.max;
      final status = c.read(subscriptionStatusProvider);
      expect(status.state, SubscriptionState.activeMax);
      expect(status.tier, SubscriptionTier.max);
    });

    test('an explicit server plan outranks the session record', () async {
      const server = SubscriptionStatus(
        state: SubscriptionState.activePro,
        tier: SubscriptionTier.pro,
        isPlanInferred: false, // the endpoint said "pro" out loud
      );
      final c = container(server: server);
      await c.read(serverSubscriptionStatusProvider.future);
      c.read(sessionEntitlementProvider.notifier).state =
          SubscriptionTier.max;
      final status = c.read(subscriptionStatusProvider);
      expect(status.state, SubscriptionState.activePro);
      expect(status.tier, SubscriptionTier.pro);
    });

    test('billing-trouble states keep their state, only the tier lifts',
        () async {
      const server = SubscriptionStatus(
        state: SubscriptionState.grace,
        tier: SubscriptionTier.pro,
        isPlanInferred: true,
      );
      final c = container(server: server);
      await c.read(serverSubscriptionStatusProvider.future);
      c.read(sessionEntitlementProvider.notifier).state =
          SubscriptionTier.max;
      final status = c.read(subscriptionStatusProvider);
      expect(status.state, SubscriptionState.grace);
      expect(status.tier, SubscriptionTier.max);
    });
  });

  // ── shared pump helpers ─────────────────────────────────────────────────

  Future<AppLocalizations> l10nOf(WidgetTester tester, Type screen) async =>
      AppLocalizations.of(tester.element(find.byType(screen)));

  // ── 2. paywall leave guard ──────────────────────────────────────────────

  group('paywall leave guard', () {
    Future<void> pumpPaywall(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const Scaffold(body: SizedBox()),
            routes: {
              '/paywall': (_) =>
                  const PaywallScreen(variant: PaywallVariant.pro),
            },
          ),
        ),
      );
      final nav = tester.state<NavigatorState>(find.byType(Navigator));
      unawaited(nav.pushNamed('/paywall'));
      await tester.pumpAndSettle();
    }

    testWidgets('X shows the retention prompt; "Keep looking" stays',
        (tester) async {
      await pumpPaywall(tester);
      final l10n = await l10nOf(tester, PaywallScreen);
      // The close glyph is the lone GestureDetector in the 56px GNB strip.
      await tester.tapAt(const Offset(34, 28));
      await tester.pumpAndSettle();
      expect(find.text(l10n.paywallLeaveTitle), findsOneWidget);
      await tester.tap(find.text(l10n.ctaKeepLooking));
      await tester.pumpAndSettle();
      expect(find.byType(PaywallScreen), findsOneWidget);
    });

    testWidgets('"Leave anyway" pops; a second back needs no prompt',
        (tester) async {
      await pumpPaywall(tester);
      final l10n = await l10nOf(tester, PaywallScreen);
      await tester.tapAt(const Offset(34, 28));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.ctaLeaveAnyway));
      await tester.pumpAndSettle();
      expect(find.byType(PaywallScreen), findsNothing);
    });
  });

  // ── 3. purchase cycle honoured ──────────────────────────────────────────

  group('purchase cycle', () {
    late List<String> boughtIds;
    late MockIapService iap;

    Future<void> pumpProcessing(WidgetTester tester, Object args) async {
      boughtIds = [];
      iap = _RecordingIapService(boughtIds);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [iapServiceProvider.overrideWithValue(iap)],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const Scaffold(body: SizedBox()),
            routes: {
              '/processing': (_) => const PurchaseProcessingScreen(),
              Routes.purchaseSuccessPro: (_) =>
                  const Scaffold(body: Text('success-pro')),
              Routes.purchaseSuccessMax: (_) =>
                  const Scaffold(body: Text('success-max')),
            },
          ),
        ),
      );
      final nav = tester.state<NavigatorState>(find.byType(Navigator));
      unawaited(nav.pushNamed('/processing', arguments: args));
      await tester.pumpAndSettle();
    }

    testWidgets('annual Pro request buys the yearly product', (tester) async {
      await pumpProcessing(
          tester, (tier: SubscriptionTier.pro, annual: true));
      expect(boughtIds, [IapProductIds.proYearly]);
      expect(find.text('success-pro'), findsOneWidget);
    });

    testWidgets('Max request lands on the Max success screen with its product',
        (tester) async {
      await pumpProcessing(
          tester, (tier: SubscriptionTier.max, annual: false));
      expect(boughtIds, [IapProductIds.maxMonthly]);
      expect(find.text('success-max'), findsOneWidget);
    });

    testWidgets('a bare tier argument still works and buys monthly',
        (tester) async {
      await pumpProcessing(tester, SubscriptionTier.pro);
      expect(boughtIds, [IapProductIds.proMonthly]);
      expect(find.text('success-pro'), findsOneWidget);
    });
  });

  // ── round 3 — settings: Account card + status-derived plan label ────────

  group('settings account card', () {
    Future<void> pumpSettings(
        WidgetTester tester, SubscriptionStatus status) async {
      await tester.binding.setSurfaceSize(const Size(375, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [subscriptionStatusProvider.overrideWithValue(status)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: MyPageSettingsScreen(),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('Account section renders with its rows', (tester) async {
      await pumpSettings(tester, SubscriptionStatus.none);
      final l10n = await l10nOf(tester, MyPageSettingsScreen);
      expect(find.text(l10n.accountSection), findsOneWidget);
      expect(find.text(l10n.nicknameLabel), findsOneWidget);
      expect(find.text(l10n.fieldEmailLabel), findsOneWidget);
    });

    testWidgets('Current plan reads the status — Max says Max',
        (tester) async {
      await pumpSettings(
        tester,
        const SubscriptionStatus(
          state: SubscriptionState.activeMax,
          tier: SubscriptionTier.max,
        ),
      );
      final l10n = await l10nOf(tester, MyPageSettingsScreen);
      expect(find.text(l10n.planMax), findsOneWidget);
      expect(find.text(l10n.planPro), findsNothing);
    });

    testWidgets('Free stays Free', (tester) async {
      await pumpSettings(tester, SubscriptionStatus.none);
      final l10n = await l10nOf(tester, MyPageSettingsScreen);
      expect(find.text(l10n.planFree), findsOneWidget);
    });
  });

  tallSweep();
}

// ── round 3 — fresh-eyes sweep ────────────────────────────────────────────

/// Tall-viewport overflow sweep for the P3 screens.
///
/// The main i18n sweep runs at 320×640 and its ListView never *builds* what
/// sits below the fold — that lazy build hid a 108px overflow in the paywall
/// footer even in English. This pass renders the same screens at 375×1600 so
/// every row lays out, across the locales the 320 sweep found wordiest.
void tallSweep() {
  const locales = [
    Locale('en'),
    Locale('fil'),
    Locale('hi'),
    Locale('id'),
    Locale('kk'),
    Locale('mn'),
    Locale('ru'),
    Locale('ur'),
  ];
  final screens = <String, Widget Function()>{
    'PaywallPro': () => const PaywallScreen(variant: PaywallVariant.pro),
    'PaywallProLimit': () =>
        const PaywallScreen(variant: PaywallVariant.proLimit),
    'PaywallMax': () => const PaywallScreen(variant: PaywallVariant.max),
  };

  testWidgets('no overflow below the fold @ 375×1600', (tester) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final overflows = <String>[];
    for (final locale in locales) {
      for (final entry in screens.entries) {
        final captured = <String>[];
        final prev = FlutterError.onError;
        FlutterError.onError = (details) {
          final s = details.toString();
          if (s.contains('overflowed')) captured.add(s.split('\n').first);
        };
        try {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                locale: locale,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: entry.value(),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 32));
        } finally {
          FlutterError.onError = prev;
        }
        tester.takeException();
        if (captured.isNotEmpty) {
          overflows
              .add('${locale.toLanguageTag()} · ${entry.key}: ${captured.first}');
        }
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
    expect(overflows, isEmpty, reason: overflows.join('\n'));
  });
}

/// A [MockIapService] that records which product ids get purchased.
class _RecordingIapService extends MockIapService {
  _RecordingIapService(this.bought);

  final List<String> bought;

  @override
  Future<void> purchase(IapProduct product) {
    bought.add(product.id);
    return super.purchase(product);
  }
}
