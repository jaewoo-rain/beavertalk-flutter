import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// P2 — the eight state screens (spec §4-1) and the billing list (spec §5).
///
/// Every state is injected through `subscriptionStatusProvider` — the same
/// override path the demo hub uses — which is completion criterion 1: all
/// eight render from mock data with no server involved.
void main() {
  final expiry = DateTime(2026, 6, 20);

  SubscriptionStatus status(
    SubscriptionState state, {
    SubscriptionTier? tier,
  }) =>
      SubscriptionStatus(
        state: state,
        tier: tier ??
            state.impliedTier ??
            SubscriptionTier.pro,
        expiresAt: expiry,
        retryingUntil: DateTime(2026, 6, 25),
        pausedSince: DateTime(2026, 6, 26),
      );

  Future<void> pump(WidgetTester tester, SubscriptionStatus s) async {
    await tester.binding.setSurfaceSize(const Size(375, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [subscriptionStatusProvider.overrideWithValue(s)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: SubscriptionManageScreen(),
        ),
      ),
    );
  }

  const manageStates = [
    SubscriptionState.free,
    SubscriptionState.trial,
    SubscriptionState.activePro,
    SubscriptionState.activeMax,
    SubscriptionState.grace,
    SubscriptionState.onHold,
    SubscriptionState.ending,
  ];

  group('criterion 1 — all eight states render from mock data', () {
    testWidgets('plan-card identity per state', (tester) async {
      const expectations = {
        SubscriptionState.free: ('Free', 'Current'),
        SubscriptionState.trial: ('Max trial', 'Trial'),
        SubscriptionState.activePro: ('Pro', 'Renewing'),
        SubscriptionState.activeMax: ('Max', 'Renewing'),
        SubscriptionState.grace: ('Pro', 'Past due'),
        SubscriptionState.onHold: ('Pro', 'Paused'),
        SubscriptionState.ending: ('Pro', 'Canceling'),
      };
      for (final e in expectations.entries) {
        await pump(tester, status(e.key));
        final (title, badge) = e.value;
        expect(find.text(title), findsWidgets, reason: '${e.key} title');
        expect(find.text(badge), findsOneWidget, reason: '${e.key} badge');
      }
    });

    testWidgets('expired renders the trial_expired notice instead',
        (tester) async {
      await pump(tester, status(SubscriptionState.expired));
      expect(find.text('Your Max trial ended'), findsOneWidget);
      expect(find.text('You are on Free now'), findsOneWidget);
      expect(find.text('See plans'), findsOneWidget);
      // A notice, not a manage surface: no billing groups (spec §4-1).
      expect(find.text('Plan & purchases'), findsNothing);
      expect(find.text('In the store'), findsNothing);
    });
  });

  group('criterion 2 — the billing list is 7 rows / 2 groups in every state',
      () {
    testWidgets('row labels differ only in slots ① and ⑦', (tester) async {
      for (final state in manageStates) {
        await pump(tester, status(state));

        // Fixed rows, present in every state — never hidden (spec §5-1).
        for (final label in [
          'Buy a character',
          'Restore purchases',
          'Payment history',
          'Manage in the store',
          'Refund help',
        ]) {
          expect(find.text(label), findsOneWidget, reason: '$state / $label');
        }

        // Slot ①.
        final paid = state == SubscriptionState.activePro ||
            state == SubscriptionState.activeMax;
        expect(find.text(paid ? 'Change plan' : 'Compare all plans'),
            findsOneWidget,
            reason: '$state slot ①');

        // Slot ⑦.
        expect(
          find.text(state == SubscriptionState.ending
              ? 'Resubscribe'
              : 'Cancel subscription'),
          findsOneWidget,
          reason: '$state slot ⑦',
        );

        // Both group titles present.
        expect(find.text('Plan & purchases'), findsOneWidget);
        expect(find.text('In the store'), findsOneWidget);
      }
    });
  });

  group('criterion 3 — the last row of every card draws no divider', () {
    // Both cards hold four rows now. The store group gained `Redeem a code`
    // when the real IAP rail landed: a console-issued discount is only
    // spendable if the binary already ships somewhere to spend it, so the row
    // has to exist before submission rather than after the first campaign.
    // ☞ Figma still draws three store rows — the canvas trails the code here.
    testWidgets('two 4-row cards carry 3 + 3 hairlines', (tester) async {
      for (final state in manageStates) {
        await pump(tester, status(state));
        final hairlines = tester
            .widgetList<Container>(find.byType(Container))
            .map((w) => w.decoration)
            .whereType<BoxDecoration>()
            .where((d) =>
                d.border is Border && (d.border as Border).bottom.width == 0.5)
            .length;
        expect(hairlines, 6,
            reason:
                '$state: each 4-row card → 3 dividers (spec §5-6)');
      }
    });
  });

  group('banners (spec §6-1, measured)', () {
    testWidgets('danger banner appears on grace and hold only',
        (tester) async {
      for (final state in manageStates) {
        await pump(tester, status(state));
        final failed = find.text("We couldn't take the payment");
        final paused = find.text('Your plan is paused');
        switch (state) {
          case SubscriptionState.grace:
            expect(failed, findsOneWidget, reason: '$state');
          case SubscriptionState.onHold:
            expect(paused, findsOneWidget, reason: '$state');
          default:
            expect(failed, findsNothing, reason: '$state');
            expect(paused, findsNothing, reason: '$state');
        }
      }
    });

    testWidgets('upsell banner follows the measured originals',
        (tester) async {
      for (final state in manageStates) {
        await pump(tester, status(state));
        final pro = find.text('Go unlimited with Pro');
        final max = find.text('Turn on video with Max');
        final annual = find.text('Switch to annual');
        switch (state) {
          case SubscriptionState.free:
            expect(pro, findsOneWidget, reason: '$state');
          case SubscriptionState.activePro:
          case SubscriptionState.grace:
          case SubscriptionState.ending:
            expect(max, findsOneWidget, reason: '$state');
          case SubscriptionState.activeMax:
            expect(annual, findsOneWidget, reason: '$state');
          default:
            // Trial (measured: none, despite spec §6-1's table — flagged) and
            // hold (payment recovery first).
            expect(pro, findsNothing, reason: '$state');
            expect(max, findsNothing, reason: '$state');
            expect(annual, findsNothing, reason: '$state');
        }
      }
    });
  });

  group('plan-card data rows', () {
    testWidgets('each state pairs its measured label with the right date',
        (tester) async {
      await pump(tester, status(SubscriptionState.activePro));
      expect(find.text('Next payment'), findsOneWidget);
      expect(find.text('Jun 20, 2026'), findsOneWidget);

      await pump(tester, status(SubscriptionState.grace));
      expect(find.text('Retrying until'), findsOneWidget);
      expect(find.text('Jun 25, 2026'), findsOneWidget,
          reason: 'server value, not locally computed (spec §11-3)');

      await pump(tester, status(SubscriptionState.onHold));
      expect(find.text('Paused since'), findsOneWidget);
      expect(find.text('Jun 26, 2026'), findsOneWidget);

      await pump(tester, status(SubscriptionState.ending));
      expect(find.text('Pro ends'), findsOneWidget);

      await pump(tester, status(SubscriptionState.trial));
      expect(find.text('First payment'), findsOneWidget);
      expect(find.text('Free until Jun 20, 2026'), findsOneWidget);

      await pump(tester, status(SubscriptionState.free));
      expect(find.text("Today's calls"), findsOneWidget);
      expect(find.text('0 of 1 used'), findsOneWidget);
    });
  });

  group('footnotes (measured copy)', () {
    testWidgets('state-specific notes appear where measured', (tester) async {
      await pump(tester, status(SubscriptionState.free));
      expect(
          find.text(
              'Already subscribed on another device? Restore brings it back on this one.'),
          findsOneWidget);

      await pump(tester, status(SubscriptionState.grace));
      expect(
          find.text(
              'Benefits keep running through the grace period. Cancellation is never intercepted in the app.'),
          findsOneWidget);

      await pump(tester, status(SubscriptionState.ending));
      expect(
          find.text(
              'Your plan is set to end. Benefits run until Jun 20, then you move to Free. You can resubscribe any time.'),
          findsOneWidget);

      // Max carries the store-handled line but not the fair-use line.
      await pump(tester, status(SubscriptionState.activeMax));
      expect(
          find.text(
              'Payment method, plan changes, and cancellation are handled by the store.'),
          findsOneWidget);
      expect(find.text('Unlimited use is subject to our fair use policy.'),
          findsNothing);
    });
  });
}
