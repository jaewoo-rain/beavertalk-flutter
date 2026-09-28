import 'dart:async';

import 'package:beavertalk/features/subscription/data/models/entitlement_dto.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:flutter/material.dart';
import 'package:beavertalk/features/subscription/data/store_iap_service.dart';
import 'package:beavertalk/features/subscription/domain/iap_service.dart';
import 'package:beavertalk/features/subscription/domain/plan_prices.dart';
import 'package:beavertalk/features/subscription/domain/repositories/purchase_repository.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

/// 09-28 실결제(Note20 · Premium 월간) 결함 2건.
///
/// 1. 7일 무료체험 미적용 — 결제창이 기본 플랜 토큰으로 열려 ₩33,000 즉시 청구.
/// 2. USD 고정 표시 — 스토어 현지가 채택이 레거시 `bt_pro` 까지 요구해 한 번도 안 됐다.

PricingPhaseWrapper _phase(int micros, String formatted,
        {String currency = 'KRW', String period = 'P1M'}) =>
    PricingPhaseWrapper(
      billingCycleCount: micros == 0 ? 1 : 0,
      billingPeriod: period,
      formattedPrice: formatted,
      priceAmountMicros: micros,
      priceCurrencyCode: currency,
      recurrenceMode: micros == 0
          ? RecurrenceMode.finiteRecurring
          : RecurrenceMode.infiniteRecurring,
    );

final _paid = _phase(33000000000, '₩33,000');

SubscriptionOfferDetailsWrapper _offer(String basePlan, String? offerId,
        List<PricingPhaseWrapper> phases, {List<String> tags = const []}) =>
    SubscriptionOfferDetailsWrapper(
      basePlanId: basePlan,
      offerId: offerId,
      offerTags: tags,
      offerIdToken: 'tok-$basePlan-${offerId ?? 'base'}',
      pricingPhases: phases,
    );

List<GooglePlayProductDetails> _sub(
        String id, List<SubscriptionOfferDetailsWrapper> offers) =>
    GooglePlayProductDetails.fromProductDetails(ProductDetailsWrapper(
      description: '',
      name: id,
      productId: id,
      productType: ProductType.subs,
      title: id,
      subscriptionOfferDetails: offers,
    ));

class _Store implements InAppPurchase {
  _Store(this.rows, {this.launches = true});

  final List<ProductDetails> rows;
  final bool launches;
  PurchaseParam? bought;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async =>
      ProductDetailsResponse(
        productDetails: [
          for (final r in rows)
            if (ids.contains(r.id)) r,
        ],
        notFoundIDs: const [],
      );

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    bought = purchaseParam;
    return launches;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AnnualIap extends MockIapService {
  _AnnualIap(this.annual);
  final bool? annual;
  @override
  Future<bool?> ownsAnnualPremium() async => annual;
}

class _Server implements PurchaseRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<EntitlementDto> entitlement() async => const EntitlementDto(isPro: false);
}

GooglePlayPurchaseDetails _owned(String productId,
        {PurchaseStateWrapper state = PurchaseStateWrapper.purchased}) =>
    GooglePlayPurchaseDetails.fromPurchase(PurchaseWrapper(
      orderId: 'GPA.$productId',
      packageName: 'im.beavertalk',
      purchaseTime: 0,
      purchaseToken: 'ptok-$productId',
      signature: '',
      products: [productId],
      isAutoRenewing: true,
      originalJson: '{}',
      isAcknowledged: true,
      purchaseState: state,
    )).single;

Future<GooglePlayPurchaseParam> _buy(List<ProductDetails> rows,
    {String sku = IapProductIds.maxMonthly,
    List<GooglePlayPurchaseDetails> owned = const []}) async {
  final store = _Store(rows);
  final iap = StoreIapService(
    server: _Server(),
    store: store,
    playOwnedPurchases: () async => owned,
  );
  final products = await iap.getProducts({sku});
  await iap.purchase(products.single);
  return store.bought! as GooglePlayPurchaseParam;
}

Future<String?> _tokenFor(List<ProductDetails> rows) async =>
    (await _buy(rows)).offerToken;

final _yearlyRows = _sub('bt_max_yearly', [
  _offer('yearly', null, [_phase(259000000000, '₩259,000', period: 'P1Y')]),
  _offer('yearly', 'trial-7d', [
    _phase(0, 'Free', period: 'P1W'),
    _phase(259000000000, '₩259,000', period: 'P1Y'),
  ]),
]);

void main() {
  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    PlanPrices.reset();
  });

  group('결함 1 · 무료체험 오퍼 토큰', () {
    test('체험 오퍼가 조회에 실리면(자격 있음) 그 토큰으로 결제창을 연다', () async {
      final token = await _tokenFor(_sub('bt_max_monthly', [
        _offer('monthly', null, [_paid]),
        _offer('monthly', 'trial-7d', [_phase(0, 'Free', period: 'P1W'), _paid]),
      ]));
      expect(token, 'tok-monthly-trial-7d');
    });

    test('체험 오퍼가 없으면(자격 없음) 기본 플랜 토큰 — 윈백은 체험으로 쓰지 않는다', () async {
      final token = await _tokenFor(_sub('bt_max_monthly', [
        _offer('monthly', null, [_paid]),
        _offer('monthly', 'winback-50-1m',
            [_phase(16500000000, '₩16,500'), _paid],
            tags: ['winback']),
      ]));
      expect(token, 'tok-monthly-base');
    });

    test('표시 가격은 체험 행이 아니라 반복 청구 금액', () async {
      final iap = StoreIapService(
        server: _Server(),
        store: _Store(_sub('bt_max_monthly', [
          _offer('monthly', 'trial-7d', [_phase(0, 'Free', period: 'P1W'), _paid]),
          _offer('monthly', null, [_paid]),
        ])),
      );
      final p = (await iap.getProducts({IapProductIds.maxMonthly})).single;
      expect(p.localizedPrice, '₩33,000');
      expect(p.rawPrice, 33000);
      expect(p.currencyCode, 'KRW');
    });

    test('pickTrialOffer — id 우선 · 다른 기본 플랜 제외 · 무료 단계 대체', () {
      ({String basePlanId, String? offerId, List<String> tags, bool hasFreePhase})
          o(String b, String? id, {bool free = false, List<String> tags = const []}) =>
              (basePlanId: b, offerId: id, tags: tags, hasFreePhase: free);
      expect(
        StoreIapService.pickTrialOffer(
            [o('monthly', null), o('yearly', 'trial-7d', free: true)],
            basePlanId: 'monthly'),
        isNull,
      );
      expect(
        StoreIapService.pickTrialOffer(
            [o('monthly', 'intro', free: true), o('monthly', 'trial-7d', free: true)],
            basePlanId: 'monthly'),
        1,
      );
      expect(
        StoreIapService.pickTrialOffer(
            [o('monthly', 'other', free: true, tags: ['winback']), o('monthly', 'intro', free: true)],
            basePlanId: 'monthly'),
        1,
      );
    });
  });

  group('F067 · 월간↔연간 전환은 기존 구독을 교체한다(PM-DEC-126)', () {
    test('월간 보유 중 연간 구매 → CHARGE_FULL_PRICE 교체 · 체험 토큰 없음', () async {
      final param = await _buy(_yearlyRows,
          sku: IapProductIds.maxYearly, owned: [_owned('bt_max_monthly')]);
      expect(param.offerToken, 'tok-yearly-base');
      final change = param.changeSubscriptionParam!;
      expect(change.oldPurchaseDetails.productID, 'bt_max_monthly');
      expect(change.replacementMode, ReplacementMode.chargeFullPrice);
    });

    test('레거시 bt_max 보유도 교체 대상', () async {
      final param = await _buy(_yearlyRows,
          sku: IapProductIds.maxYearly, owned: [_owned('bt_max')]);
      expect(param.changeSubscriptionParam?.oldPurchaseDetails.productID, 'bt_max');
    });

    test('보유 구독이 없으면 교체 없이 새 구독 — 체험 토큰', () async {
      final param = await _buy(_yearlyRows, sku: IapProductIds.maxYearly);
      expect(param.changeSubscriptionParam, isNull);
      expect(param.offerToken, 'tok-yearly-trial-7d');
    });

    test('pickReplacedSubscription — 같은 상품·보류·Premium 아닌 것은 제외', () {
      expect(
        StoreIapService.pickReplacedSubscription([
          _owned('bt_max_yearly'),
          _owned('bt_max_monthly', state: PurchaseStateWrapper.pending),
          _owned('bt_character_cuty'),
        ], targetId: 'bt_max_yearly'),
        isNull,
      );
    });

    test('보유 조회가 실패하면 결제창은 그대로 연다(교체 없음)', () async {
      final store = _Store(_yearlyRows);
      final iap = StoreIapService(
        server: _Server(),
        store: store,
        playOwnedPurchases: () async => throw StateError('billing down'),
      );
      final p = (await iap.getProducts({IapProductIds.maxYearly})).single;
      await iap.purchase(p);
      expect((store.bought! as GooglePlayPurchaseParam).changeSubscriptionParam,
          isNull);
    });
  });

  group('F071 · 주기는 스토어 활성 구독으로 · 결제창 실패', () {
    Future<bool?> playAnnual(List<GooglePlayPurchaseDetails> owned) =>
        StoreIapService(
          server: _Server(),
          store: _Store(const []),
          playOwnedPurchases: () async => owned,
        ).ownsAnnualPremium();

    test('Android — 활성 구독 productId 로 월/연을 가른다', () async {
      expect(await playAnnual([_owned('bt_max_yearly')]), isTrue);
      expect(await playAnnual([_owned('bt_max_monthly')]), isFalse);
      expect(await playAnnual([_owned('bt_max')]), isNull, reason: '레거시는 주기를 모른다');
      expect(
        await StoreIapService(
          server: _Server(),
          store: _Store(const []),
          playOwnedPurchases: () async => throw StateError('down'),
        ).ownsAnnualPremium(),
        isNull,
      );
    });

    test('iOS — 유효한 Premium 거래 중 가장 최근 것', () {
      final now = DateTime(2026, 9, 28);
      AppleTransaction t(String id, int expDay, int buyDay) => (
            productId: id,
            expires: DateTime(2026, 9, expDay),
            purchased: DateTime(2026, 9, buyDay),
          );
      expect(
          StoreIapService.appleOwnsAnnual(
              [t('bt_max_monthly', 29, 1), t('bt_max_yearly', 30, 20)],
              now: now),
          isTrue);
      expect(
          StoreIapService.appleOwnsAnnual([t('bt_max_yearly', 27, 1)], now: now),
          isNull,
          reason: '만료된 것은 없는 것');
      expect(
          StoreIapService.appleOwnsAnnual([t('bt_max_monthly', 30, 1)], now: now),
          isFalse);
    });

    test('결제창을 못 열면(false) 예외 — 스피너가 멈추지 않는다', () async {
      final iap = StoreIapService(
        server: _Server(),
        store: _Store(_sub('bt_max_monthly', [_offer('monthly', null, [_paid])]),
            launches: false),
        playOwnedPurchases: () async => const [],
      );
      final p = (await iap.getProducts({IapProductIds.maxMonthly})).single;
      await expectLater(iap.purchase(p), throwsStateError);
    });

    test('전환 행은 스토어가 「월간」 이라고 답할 때만', () async {
      Future<bool> available(bool? annual) async {
        final c = ProviderContainer(overrides: [
          iapServiceProvider.overrideWithValue(_AnnualIap(annual)),
        ]);
        addTearDown(c.dispose);
        final sub = c.listen(annualSwitchAvailableProvider, (_, _) {});
        addTearDown(sub.close);
        return c.read(annualSwitchAvailableProvider.future);
      }

      expect(await available(false), isTrue);
      expect(await available(true), isFalse);
      expect(await available(null), isFalse, reason: '모르면 숨긴다');
    });
  });

  group('F068 · F070 · 복원은 서버가 지급한 것만 내보내고 닫는다', () {
    const sub = IapPurchase(
        productId: IapProductIds.maxMonthly,
        type: IapProductType.subscription,
        state: IapPurchaseState.restored);
    const rara = IapPurchase(
        productId: 'bt_character_rara',
        type: IapProductType.nonConsumable,
        state: IapPurchaseState.restored);

    test('Premium 이 아닌 결과면 구독 영수증은 안 나간다(캐릭터만 복원된 묶음)', () {
      const ent = EntitlementDto(isPro: false, ownedCharacterIds: [1, 10]);
      expect(StoreIapService.grantedByRestore(sub, RestoreOutcome.restored, ent),
          isFalse);
      expect(StoreIapService.grantedByRestore(rara, RestoreOutcome.restored, ent),
          isTrue);
    });

    test('권한에 없는 캐릭터는 닫지 않는다', () {
      const ent = EntitlementDto(isPro: true, ownedCharacterIds: [1]);
      expect(StoreIapService.grantedByRestore(sub, RestoreOutcome.restored, ent),
          isTrue);
      expect(StoreIapService.grantedByRestore(rara, RestoreOutcome.restored, ent),
          isFalse);
    });

    test('복원되지 않은 묶음은 아무것도', () {
      const ent = EntitlementDto(isPro: true, ownedCharacterIds: [10]);
      expect(
          StoreIapService.grantedByRestore(sub, RestoreOutcome.notThisAccount, ent),
          isFalse);
    });
  });

  group('결함 2 · 현지가', () {
    test('Premium 둘만 스토어가 답해도 현지가를 채택한다(bt_pro 없음)', () async {
      final store = _Store([
        ..._sub('bt_max_monthly', [_offer('monthly', null, [_paid])]),
        ..._sub('bt_max_yearly',
            [_offer('yearly', null, [_phase(259000000000, '₩259,000', period: 'P1Y')])]),
      ]);
      final container = ProviderContainer(overrides: [
        iapServiceProvider
            .overrideWithValue(StoreIapService(server: _Server(), store: store)),
      ]);
      addTearDown(container.dispose);
      await container.read(storePricesProvider.future);

      expect(PlanPrices.isStoreBacked, isTrue);
      expect(PlanPrices.maxMonthly, '₩33,000');
      expect(PlanPrices.maxYearly, '₩259,000');
      expect(PlanPrices.maxQuotedInUsd, isFalse);
      // Pro 는 스토어 값이 없으니 정가 그대로 — 다른 통화와 섞어 계산하지 않는다.
      expect(PlanPrices.proMonthly, r'$15.99');
      expect(PlanPrices.proYearlyAnchor, r'$191.88');
      expect(PlanPrices.maxYearlyAnchor, contains('₩'));
    });

    testWidgets('구독 관리 — 서버 USD 값보다 스토어 현지가', (tester) async {
      debugDefaultTargetPlatformOverride = null;
      PlanPrices.adopt(
        maxMonthly: const StorePrice(display: '₩33,000', raw: 33000, currencyCode: 'KRW'),
        maxYearly: const StorePrice(display: '₩259,000', raw: 259000, currencyCode: 'KRW'),
      );
      await tester.binding.setSurfaceSize(const Size(375, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(ProviderScope(
        overrides: [
          storePricesProvider.overrideWith((ref) async => const []),
          subscriptionStatusAvailabilityProvider
              .overrideWithValue(SubscriptionStatusAvailability.known),
          subscriptionStatusProvider.overrideWithValue(SubscriptionStatus(
            state: SubscriptionState.activeMax,
            tier: SubscriptionTier.max,
            expiresAt: DateTime(2026, 10, 28),
            source: const Subscription(id: 7, price: 2399, isActivate: true),
          )),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SubscriptionManageScreen(),
        ),
      ));
      await tester.pump();
      expect(find.textContaining('₩33,000 per month'), findsOneWidget);
      expect(find.textContaining(r'$23.99'), findsNothing);
    });
  });
}
