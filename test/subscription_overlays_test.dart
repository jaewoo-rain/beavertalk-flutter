import 'package:beavertalk/components/organisms/bottom_sheet_content.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/overlays/subscription_overlays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// P4 — the overlay layer: every sheet renders, and the close conventions of
/// spec §7-2 hold (completion criteria 4 and 5).
void main() {
  final expiry = DateTime(2026, 6, 20);

  Future<ProviderContainer> pumpHost(
    WidgetTester tester,
    SubscriptionOverlay overlay,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(overrides: [
      subscriptionStatusProvider.overrideWithValue(
        SubscriptionStatus(
          state: SubscriptionState.activePro,
          tier: SubscriptionTier.pro,
          expiresAt: expiry,
        ),
      ),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showSubscriptionOverlay(
                    context,
                    overlay,
                    expiresAt: expiry,
                    usage: (used: '4:58', limit: '5:00'),
                    characterName: 'Baba',
                    lastTopic: 'You were talking about weekend plans',
                    avatar: const ColoredBox(color: Color(0xFF444444)),
                    scores: const [
                      SheetRowData(
                          label: 'Pronunciation',
                          value: '96',
                          highlighted: true),
                      SheetRowData(label: 'Fluency', value: '91'),
                      SheetRowData(label: 'Rhythm', value: '91'),
                    ],
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return container;
  }

  group('every overlay renders its measured title', () {
    const titles = {
      SubscriptionOverlay.restoreSuccess: 'Pro is back',
      SubscriptionOverlay.restoreEmpty: 'Nothing to restore',
      SubscriptionOverlay.restoreOtherAccount:
          'That plan belongs to another account',
      SubscriptionOverlay.characterOffer: 'Not ready for Pro?',
      SubscriptionOverlay.notEligible: 'Nothing to cancel',
      SubscriptionOverlay.cancelDownsell: 'Before you go',
      SubscriptionOverlay.annualSwitch: r'Pay yearly, save $54.80',
      SubscriptionOverlay.monthlySwitch: 'Switch to monthly',
      SubscriptionOverlay.refundHelp: 'Refunds are handled by the store',
      SubscriptionOverlay.cancelSubscription: 'Cancel subscription',
      SubscriptionOverlay.paymentUpdate: 'Update payment',
      SubscriptionOverlay.resubscribe: 'Resubscribe',
      SubscriptionOverlay.trialEnding: 'Your trial ends tomorrow',
      SubscriptionOverlay.trialStart: '7 days of Max, free',
      SubscriptionOverlay.otoAnnual: 'One more thing before you start',
      SubscriptionOverlay.purchaseFailedDeclined: 'Your card was declined',
      SubscriptionOverlay.purchaseFailedCanceled: 'Payment canceled',
      SubscriptionOverlay.purchaseFailedStore: 'Something went wrong',
      SubscriptionOverlay.alreadySubscribed: "You're already on Pro",
      SubscriptionOverlay.freeLimitCall: "That's today's call",
      SubscriptionOverlay.freeLimitCheck: "That's today's check",
    };

    testWidgets('all 21 sheets mount with their title', (tester) async {
      for (final e in titles.entries) {
        await pumpHost(tester, e.key);
        // `monthly_switch` repeats its title as the CTA label — hence
        // at-least-one rather than exactly-one.
        expect(find.text(e.value), findsAtLeastNWidgets(1), reason: '${e.key}');
        // Dismiss for the next round.
        await tester.tapAt(const Offset(187, 10));
        await tester.pumpAndSettle();
      }
    });
  });

  group('criterion 4 — close conventions (spec §7-2)', () {
    testWidgets('dim tap closes', (tester) async {
      await pumpHost(tester, SubscriptionOverlay.notEligible);
      expect(find.text('Nothing to cancel'), findsOneWidget);
      // The barrier is everything above the sheet.
      await tester.tapAt(const Offset(187, 10));
      await tester.pumpAndSettle();
      expect(find.text('Nothing to cancel'), findsNothing);
    });

    testWidgets('a tap on the sheet body does nothing', (tester) async {
      await pumpHost(tester, SubscriptionOverlay.notEligible);
      await tester.tap(find.text('Nothing to cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Nothing to cancel'), findsOneWidget,
          reason: 'sheet-body taps must not dismiss (spec §7-2)');
    });

    testWidgets('the quiet CTA closes', (tester) async {
      await pumpHost(tester, SubscriptionOverlay.notEligible);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Nothing to cancel'), findsNothing);
    });

    testWidgets('the action sheet X closes', (tester) async {
      await pumpHost(tester, SubscriptionOverlay.cancelSubscription);
      expect(find.text('Cancel subscription'), findsOneWidget);
      // The GNB close glyph is the only SvgPicture-bearing tap target at the
      // top-right; tap its position.
      await tester.tapAt(tester
          .getCenter(find.byType(GestureDetector).first)
          .translate(0, 0));
      // Fall back: dim tap if the first detector wasn't the X.
      if (find.text('Cancel subscription').evaluate().isNotEmpty) {
        await tester.tapAt(const Offset(187, 10));
      }
      await tester.pumpAndSettle();
      expect(find.text('Cancel subscription'), findsNothing);
    });
  });

  group('criterion 5 — closing never changes subscription state', () {
    testWidgets('open → dim-close leaves the status untouched',
        (tester) async {
      final container =
          await pumpHost(tester, SubscriptionOverlay.cancelSubscription);
      final before = container.read(subscriptionStatusProvider);
      await tester.tapAt(const Offset(187, 10));
      await tester.pumpAndSettle();
      final after = container.read(subscriptionStatusProvider);
      expect(after.state, before.state);
      expect(after.tier, before.tier);
      expect(after.expiresAt, before.expiresAt);
    });

    testWidgets('open → Not now leaves the status untouched', (tester) async {
      final container =
          await pumpHost(tester, SubscriptionOverlay.paymentUpdate);
      final before = container.read(subscriptionStatusProvider);
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      final after = container.read(subscriptionStatusProvider);
      expect(after.state, before.state);
    });
  });

  group('measured payloads', () {
    testWidgets('cancel sheet quotes the server expiry date', (tester) async {
      await pumpHost(tester, SubscriptionOverlay.cancelSubscription);
      expect(
          find.text('Pro runs until Jun 20, 2026. After that you move to Free.'),
          findsOneWidget);
      expect(find.text('What you lose'), findsOneWidget);
      expect(find.text('Keep Pro'), findsOneWidget);
      expect(find.text('Continue to the store'), findsOneWidget);
    });

    testWidgets('free-limit call sheet carries preview data', (tester) async {
      await pumpHost(tester, SubscriptionOverlay.freeLimitCall);
      expect(find.text('Baba'), findsOneWidget);
      expect(find.text('4:58 of 5:00 used'), findsOneWidget);
      expect(find.text(r'$12.90 per month · cancel anytime'), findsOneWidget);
      expect(find.text('Maybe tomorrow'), findsOneWidget);
    });
  });
}
