import 'package:beavertalk/core/store/store_subscription_link.dart';
import 'package:beavertalk/features/subscription/data/models/subscription_status_dto.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/domain/plan_prices.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// P0 domain layer — the state machine behind the subscription redesign.
///
/// Work order §4-1 stops for review here precisely because everything above it
/// depends on these answers: get slot ⑦ wrong and 42 screens send members to
/// the wrong cancellation flow.
void main() {
  // A fixed "now" so expiry boundaries are exact rather than racing the clock.
  final now = DateTime(2026, 8, 3, 12);
  final resolver = SubscriptionStatusResolver(now: () => now);

  Subscription sub({
    int id = 1,
    bool? isActivate,
    DateTime? endDate,
    int? price,
  }) =>
      Subscription(
        id: id,
        isActivate: isActivate,
        endDate: endDate,
        price: price,
      );

  group('resolver — states it can decide', () {
    test('no rows → free', () {
      final status = resolver.resolve(const []);
      expect(status.state, SubscriptionState.free);
      expect(status.tier, SubscriptionTier.free);
      expect(status.source, isNull);
    });

    test('active flag with a future end date → activePro', () {
      final status = resolver.resolve([
        sub(isActivate: true, endDate: now.add(const Duration(days: 30))),
      ]);
      expect(status.state, SubscriptionState.activePro);
      expect(status.grantsPaidAccess, isTrue);
    });

    test('active flag with no end date → activePro (open-ended)', () {
      final status = resolver.resolve([sub(isActivate: true)]);
      expect(status.state, SubscriptionState.activePro);
      expect(status.expiresAt, isNull);
    });

    test('cancelled but paid through → ending, and access is retained', () {
      final status = resolver.resolve([
        sub(isActivate: false, endDate: now.add(const Duration(days: 5))),
      ]);
      expect(status.state, SubscriptionState.ending);
      expect(status.grantsPaidAccess, isTrue,
          reason: 'ENDING keeps access until the paid term runs out');
    });

    test('rows exist but none live → expired', () {
      final status = resolver.resolve([
        sub(isActivate: false, endDate: now.subtract(const Duration(days: 1))),
      ]);
      expect(status.state, SubscriptionState.expired);
      expect(status.tier, SubscriptionTier.free);
    });

    test('null flag is treated as never-activated, not as active', () {
      final status = resolver.resolve([sub(endDate: null)]);
      expect(status.state, SubscriptionState.expired);
    });

    test('newest active row wins when several are active at once', () {
      // `POST /subscriptions` never checks for an existing row, so duplicates
      // are possible; the server returns newest first.
      final status = resolver.resolve([
        sub(id: 9, isActivate: true, endDate: now.add(const Duration(days: 1))),
        sub(id: 2, isActivate: true, endDate: now.add(const Duration(days: 9))),
      ]);
      expect(status.source?.id, 9);
    });
  });

  group('resolver — expiry boundary', () {
    test('one second before end date is still active', () {
      final status = resolver.resolve([
        sub(isActivate: true, endDate: now.add(const Duration(seconds: 1))),
      ]);
      expect(status.state, SubscriptionState.activePro);
    });

    test('exactly at the end date is no longer active', () {
      final status = resolver.resolve([sub(isActivate: true, endDate: now)]);
      expect(status.state, SubscriptionState.expired);
    });
  });

  group('resolver — what it refuses to guess', () {
    test('never invents trial, grace, onHold or activeMax', () {
      // The API carries no plan field, no trial flag and no billing-retry
      // state (spec §15-2). Any of these appearing here would mean the
      // resolver started guessing from `price` or dates.
      final undecidable = {
        SubscriptionState.trial,
        SubscriptionState.grace,
        SubscriptionState.onHold,
        SubscriptionState.activeMax,
      };
      final produced = <SubscriptionState>{};
      for (final rows in <List<Subscription>>[
        const [],
        [sub(isActivate: true)],
        [sub(isActivate: true, endDate: now.add(const Duration(days: 400)))],
        [sub(isActivate: false, endDate: now.add(const Duration(days: 5)))],
        [sub(isActivate: false, endDate: now.subtract(const Duration(days: 5)))],
        [sub(price: 1290)],
        [sub(isActivate: true, price: 1990)],
      ]) {
        produced.add(resolver.resolve(rows).state);
      }
      expect(produced.intersection(undecidable), isEmpty);
    });

    test('every paid status flags its tier as inferred', () {
      final status = resolver.resolve([sub(isActivate: true)]);
      expect(status.isPlanInferred, isTrue,
          reason: 'the server cannot distinguish Pro from Max yet');
    });
  });

  group('billing list — seven rows in every state (spec §5)', () {
    test('only ENDING relabels slot ⑦', () {
      for (final s in SubscriptionState.values) {
        expect(
          s.statusSlotLabel,
          s == SubscriptionState.ending
              ? BillingSlotLabel.resubscribe
              : BillingSlotLabel.cancelSubscription,
          reason: 'slot ⑦ label for $s',
        );
      }
    });

    test('slot ⑦ destinations follow spec §5-3', () {
      expect(SubscriptionState.free.statusSlotDestination,
          BillingDestination.notEligible);
      expect(SubscriptionState.trial.statusSlotDestination,
          BillingDestination.cancelDownsell);
      expect(SubscriptionState.ending.statusSlotDestination,
          BillingDestination.resubscribe);
      for (final s in [
        SubscriptionState.activePro,
        SubscriptionState.activeMax,
        SubscriptionState.grace,
        SubscriptionState.onHold,
        SubscriptionState.expired,
      ]) {
        expect(s.statusSlotDestination, BillingDestination.cancelSubscription,
            reason: 'slot ⑦ destination for $s');
      }
    });

    test('slot ① is Change plan only on a paid plan', () {
      for (final s in SubscriptionState.values) {
        final paid =
            s == SubscriptionState.activePro || s == SubscriptionState.activeMax;
        expect(
          s.planSlotLabel,
          paid
              ? BillingSlotLabel.changePlan
              : BillingSlotLabel.compareAllPlans,
          reason: 'slot ① label for $s',
        );
      }
      expect(SubscriptionState.activePro.planSlotDestination,
          BillingDestination.planChangeUpgrade);
      expect(SubscriptionState.activeMax.planSlotDestination,
          BillingDestination.planChangeDowngrade);
    });

    test('slot ③ shows "nothing to restore" only on Free', () {
      for (final s in SubscriptionState.values) {
        expect(
          s.restoreDestination,
          s == SubscriptionState.free
              ? BillingDestination.restoreEmpty
              : BillingDestination.restoreSuccess,
          reason: 'slot ③ for $s',
        );
      }
    });

    test('the list is rendered in every state but EXPIRED', () {
      for (final s in SubscriptionState.values) {
        expect(s.showsBillingList, s != SubscriptionState.expired,
            reason: 'billing list for $s');
      }
    });
  });

  group('banners and badges (spec §6-1)', () {
    test('upgrade banner is hidden on Max and ON_HOLD', () {
      expect(SubscriptionState.activeMax.showsUpgradeBanner, isFalse);
      expect(SubscriptionState.onHold.showsUpgradeBanner, isFalse,
          reason: 'payment must be restored before upselling');
      for (final s in [
        SubscriptionState.free,
        SubscriptionState.trial,
        SubscriptionState.activePro,
        SubscriptionState.grace,
        SubscriptionState.ending,
      ]) {
        expect(s.showsUpgradeBanner, isTrue, reason: 'upgrade banner for $s');
      }
    });

    test('payment-failure banner is GRACE and ON_HOLD only', () {
      for (final s in SubscriptionState.values) {
        final expected =
            s == SubscriptionState.grace || s == SubscriptionState.onHold;
        expect(s.showsPaymentFailureBanner, expected, reason: 'banner for $s');
      }
      expect(SubscriptionState.ending.showsPaymentFailureBanner, isFalse,
          reason: 'spec §16-4 removed the misplaced banner from ENDING');
    });

    test('badges match spec §6-1, and TRIAL is not Renewing', () {
      expect(SubscriptionState.trial.badge, SubscriptionBadge.trial);
      expect(SubscriptionState.ending.badge, SubscriptionBadge.canceling);
      expect(SubscriptionState.grace.badge, SubscriptionBadge.pastDue);
      expect(SubscriptionState.onHold.badge, SubscriptionBadge.paused);
      expect(SubscriptionState.free.badge, SubscriptionBadge.current);
      expect(SubscriptionState.activePro.badge, SubscriptionBadge.renewing);
      expect(SubscriptionState.activeMax.badge, SubscriptionBadge.renewing);
      expect(SubscriptionState.expired.badge, isNull);
    });

    test('ON_HOLD blocks access while GRACE keeps it', () {
      expect(SubscriptionState.grace.grantsPaidAccess, isTrue);
      expect(SubscriptionState.onHold.grantsPaidAccess, isFalse);
    });
  });

  group('store deep links (spec §15-1)', () {
    test('iOS needs no parameters', () {
      expect(StoreSubscriptionLink.appStore.toString(),
          'https://apps.apple.com/account/subscriptions');
    });

    test('Android falls back to the account page when no product id exists', () {
      expect(StoreSubscriptionLink.googlePlay().toString(),
          'https://play.google.com/store/account/subscriptions');
      expect(StoreSubscriptionLink.googlePlay(productId: '').toString(),
          'https://play.google.com/store/account/subscriptions');
    });

    test('Android deep-links to one product once an id exists', () {
      final uri = StoreSubscriptionLink.googlePlay(productId: 'pro_monthly');
      expect(uri.queryParameters['sku'], 'pro_monthly');
      expect(uri.queryParameters['package'], 'im.beavertalk.beavertalk');
    });

    test('package id matches android/app/build.gradle.kts', () {
      expect(StoreSubscriptionLink.androidPackage, 'im.beavertalk.beavertalk');
    });

    test('platform pick follows the running target', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(StoreSubscriptionLink.forCurrentPlatform(),
          StoreSubscriptionLink.appStore);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(StoreSubscriptionLink.forCurrentPlatform(),
          StoreSubscriptionLink.googlePlayAll);
    });
  });

  group('server status DTO (`GET /subscriptions/status`)', () {
    SubscriptionStatusDto dto(Map<String, dynamic> json) =>
        SubscriptionStatusDto.fromJson(json);

    test('all eight state names parse to their states', () {
      const names = {
        'free': SubscriptionState.free,
        'trial': SubscriptionState.trial,
        'active_pro': SubscriptionState.activePro,
        'active_max': SubscriptionState.activeMax,
        'grace': SubscriptionState.grace,
        'on_hold': SubscriptionState.onHold,
        'ending': SubscriptionState.ending,
        'expired': SubscriptionState.expired,
      };
      for (final e in names.entries) {
        expect(dto({'state': e.key}).toStatus()?.state, e.value,
            reason: e.key);
      }
    });

    test('an unknown state refuses to parse instead of guessing free', () {
      // A ninth server state must trigger the fallback, not silently strip a
      // paying member of access.
      expect(dto({'state': 'comped'}).toStatus(), isNull);
      expect(dto({}).toStatus(), isNull);
    });

    test('a server-sent plan is trusted, not inferred', () {
      final status =
          dto({'state': 'active_max', 'plan': 'max'}).toStatus()!;
      expect(status.tier, SubscriptionTier.max);
      expect(status.isPlanInferred, isFalse);
    });

    test('a paid state without a plan stays honest about inferring', () {
      final status = dto({'state': 'grace'}).toStatus()!;
      expect(status.tier, SubscriptionTier.pro);
      expect(status.isPlanInferred, isTrue);
    });

    test('grace carries the server retry date (spec §11-3: server value)', () {
      final status = dto({
        'state': 'grace',
        'plan': 'pro',
        'retrying_until': '2026-08-10T00:00:00+09:00',
      }).toStatus()!;
      expect(status.retryingUntil, isNotNull);
      expect(status.state.showsPaymentFailureBanner, isTrue);
    });

    test('the backing row survives for the cancel path', () {
      final status = dto({
        'state': 'active_pro',
        'plan': 'pro',
        'subscribe_id': 12,
        'price': '12.90',
        'end_date': '2026-09-01T00:00:00+09:00',
      }).toStatus()!;
      expect(status.source?.id, 12);
      expect(status.source?.price, 1290);
      expect(status.expiresAt, isNotNull);
    });
  });

  group('IapService (work order v2 §4-1 — single rail, two product types)',
      () {
    test('purchase resolves pending → purchased on the stream', () async {
      final iap = MockIapService();
      final events = <IapPurchase>[];
      final sub = iap.purchases.listen(events.add);
      addTearDown(() async {
        await sub.cancel();
        await iap.dispose();
      });

      final products = await iap.getProducts({IapProductIds.proMonthly});
      expect(products, hasLength(1));
      await iap.purchase(products.single);
      await Future<void>.delayed(Duration.zero);

      expect(events.map((e) => e.state).toList(),
          [IapPurchaseState.pending, IapPurchaseState.purchased]);
    });

    test('a canceled sheet reports canceled, never purchased', () async {
      final iap = MockIapService(scriptedOutcome: IapPurchaseState.canceled);
      final events = <IapPurchase>[];
      final sub = iap.purchases.listen(events.add);
      addTearDown(() async {
        await sub.cancel();
        await iap.dispose();
      });

      await iap.purchase(MockIapService.defaultCatalog.first);
      await Future<void>.delayed(Duration.zero);
      expect(events.last.state, IapPurchaseState.canceled);
      expect(events.any((e) => e.state == IapPurchaseState.purchased), isFalse);
    });

    test('restore replays subscriptions AND characters (criterion 11)',
        () async {
      // A member who owns a subscription and a bought character: restore must
      // return both — characters are non-consumable IAP now (v2 §0-1) and
      // outlive any subscription.
      final iap = MockIapService(owned: [
        const IapPurchase(
          productId: IapProductIds.proMonthly,
          type: IapProductType.subscription,
          state: IapPurchaseState.restored,
        ),
        IapPurchase(
          productId: IapProductIds.character('baba'),
          type: IapProductType.nonConsumable,
          state: IapPurchaseState.restored,
        ),
      ]);
      final events = <IapPurchase>[];
      final sub = iap.purchases.listen(events.add);
      addTearDown(() async {
        await sub.cancel();
        await iap.dispose();
      });

      await iap.restore();
      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(2));
      expect(events.map((e) => e.type).toSet(),
          {IapProductType.subscription, IapProductType.nonConsumable},
          reason: 'both product types restore — not subscriptions alone');
      expect(events.every((e) => e.state == IapPurchaseState.restored), isTrue);
    });

    test('unknown product ids are silently absent, like the store SDKs', () async {
      final iap = MockIapService();
      addTearDown(iap.dispose);
      final products =
          await iap.getProducts({IapProductIds.proMonthly, 'bt_nope'});
      expect(products.map((p) => p.id), [IapProductIds.proMonthly]);
    });
  });

  group('store catalog ids (design doc 2026-08-04 §4)', () {
    test('every id satisfies the two stores’ intersection of rules', () {
      // Play is the stricter store: lowercase, digits, `_` and `.` only,
      // first char lowercase, 40 chars max. Apple accepts a superset, so
      // passing Play's rule passes both — and an id can never be edited or
      // reused once registered.
      final pattern = RegExp(r'^[a-z][a-z0-9._]{0,39}$');
      final ids = <String>{
        ...IapProductIds.subscriptions,
        // Only the characters that actually get registered — the free ones
        // have no product.
        ...IapProductIds.characterSlugs.keys
            .map(IapProductIds.characterFor)
            .whereType<String>(),
        ...IapProductIds.subscriptions
            .map((sku) => IapProductIds.playIdsFor(sku)!.subscriptionId),
      };
      for (final id in ids) {
        expect(pattern.hasMatch(id), isTrue, reason: '$id breaks the rule');
        expect(id.length, lessThanOrEqualTo(40), reason: id);
      }
    });

    test('characters resolve by slug, and unknown server ids resolve to null',
        () {
      expect(IapProductIds.characterFor(9), 'bt_character_popo');
      expect(IapProductIds.characterFor(11), 'bt_character_dudu');
      // A character the server added after this build: no slug, no registered
      // store product. Null keeps us from inventing `bt_character_42`.
      expect(IapProductIds.characterFor(42), isNull);
    });

    test('derived prices still follow from the ones they are derived from', () {
      // `$154.80` once outlived the `$12.90` it was twelve months of. The
      // arithmetic is the only thing that says these four belong together, so
      // it is the thing worth asserting.
      int cents(String s) =>
          (double.parse(s.replaceAll(RegExp(r'[^0-9.]'), '')) * 100).round();

      expect(cents(PlanPrices.proYearlyAnchor), cents(PlanPrices.proMonthly) * 12,
          reason: 'the struck anchor is twelve months at the monthly rate');
      expect(
        cents(PlanPrices.proYearlySaved),
        cents(PlanPrices.proYearlyAnchor) - cents(PlanPrices.proYearly),
        reason: 'what annual saves is anchor minus annual',
      );
      // Per-month figures round to the cent, so allow the rounding but not a
      // stale number.
      expect((cents(PlanPrices.proYearly) / 12).round(),
          cents(PlanPrices.proYearlyPerMonth));
      expect((cents(PlanPrices.maxYearly) / 12).round(),
          cents(PlanPrices.maxYearlyPerMonth));
      // Anchors only make sense above the price they strike through.
      expect(cents(PlanPrices.maxMonthlyAnchor),
          greaterThan(cents(PlanPrices.maxMonthly)));
    });

    test('a rail that cannot check intro eligibility says so', () {
      // The trial line on the Max paywall hangs off this flag. A mock rail
      // claiming eligibility it cannot verify would put "7 days free" in front
      // of members who already spent their trial — 3.1.2 territory.
      final iap = MockIapService();
      addTearDown(iap.dispose);
      expect(iap.reportsIntroEligibility, isFalse);
    });

    test('the free characters are not sold', () {
      // Baba and Bibi ship with the Free plan (대표 결정 2026-08-04), so they
      // have no store product — selling them is the bug this guards against.
      for (final id in [1, 2]) {
        expect(IapProductIds.isFreeCharacter(id), isTrue, reason: 'id $id');
        expect(IapProductIds.characterFor(id), isNull, reason: 'id $id');
      }
      for (final id in [9, 10, 11]) {
        expect(IapProductIds.isFreeCharacter(id), isFalse, reason: 'id $id');
        expect(IapProductIds.characterFor(id), isNotNull, reason: 'id $id');
      }
      // Unknown ids are not free — they are unknown. Conflating the two would
      // hand out an unreleased character for nothing.
      expect(IapProductIds.isFreeCharacter(42), isFalse);
      expect(
        IapProductIds.characterSlugs.values
            .where((s) => !IapProductIds.freeCharacterSlugs.contains(s))
            .length,
        3,
        reason: 'three characters remain purchasable',
      );
    });

    test('Play ids round-trip without losing the billing period', () {
      // The regression this guards: Play reports `bt_pro` for both periods,
      // so yearly reads as monthly the moment the base plan id is dropped.
      for (final sku in IapProductIds.subscriptions) {
        final play = IapProductIds.playIdsFor(sku);
        expect(play, isNotNull, reason: '$sku has no Play mapping');
        expect(
          IapProductIds.logicalSkuFromPlay(
              play!.subscriptionId, play.basePlanId),
          sku,
        );
      }
      // Same subscription, different base plans — must not collapse.
      expect(IapProductIds.playIdsFor(IapProductIds.proMonthly)!.subscriptionId,
          IapProductIds.playIdsFor(IapProductIds.proYearly)!.subscriptionId);
      expect(IapProductIds.logicalSkuFromPlay('bt_pro', 'yearly'),
          IapProductIds.proYearly);
      expect(IapProductIds.logicalSkuFromPlay('bt_pro', 'weekly'), isNull);
    });
  });
}
