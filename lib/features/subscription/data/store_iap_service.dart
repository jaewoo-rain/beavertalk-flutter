import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

import '../domain/iap_service.dart';
import '../domain/repositories/purchase_repository.dart';
import 'models/entitlement_dto.dart';

/// The real rail — `in_app_purchase` in front, our server behind.
///
/// ## What "purchased" means here
///
/// This service does **not** forward the store's verdict straight to the UI.
/// A store `purchased` only says money moved; it says nothing about whether
/// our backend recorded the entitlement. So every paid receipt goes to
/// `POST /purchases/verify` first, and only a server grant is re-emitted as
/// [IapPurchaseState.purchased]. Screens above therefore keep their existing
/// meaning: the success screen means access actually exists.
///
/// ## Why `completePurchase` comes last
///
/// Finishing a transaction tells the store the goods were delivered and the
/// receipt stops being replayed. Doing that before the server grants would
/// throw away the only proof of payment on a network blip — the member is
/// charged and owns nothing, with nothing left to retry from. Held-open
/// transactions are re-delivered on the next launch, which is exactly the
/// retry we want.
class StoreIapService implements IapService {
  /// Wires the rail and starts listening immediately.
  ///
  /// Construct this early. The store replays interrupted transactions — a
  /// purchase that completed while the app was killed, a subscription renewed
  /// off-device — onto [InAppPurchase.purchaseStream] shortly after launch,
  /// and a listener attached later simply misses them.
  StoreIapService({
    required PurchaseRepository server,
    InAppPurchase? store,
    Future<List<GooglePlayPurchaseDetails>> Function()? playOwnedPurchases,
    Future<List<AppleTransaction>> Function()? appleTransactions,
    String? Function()? accountId,
  })  : _server = server,
        _accountId = accountId,
        _store = store ?? InAppPurchase.instance,
        _playOwned = playOwnedPurchases,
        _appleTransactions = appleTransactions {
    _storeSub = _store.purchaseStream.listen(
      _onStoreEvent,
      onError: _out.addError,
    );
  }

  /// Sandbox hint for the server.
  ///
  /// Debug builds are always sandbox. TestFlight and Play internal testing are
  /// release builds that still transact against sandbox, so they need the
  /// override — hence the dart-define rather than a bare [kDebugMode].
  static const _isSandbox =
      bool.fromEnvironment('IAP_SANDBOX', defaultValue: kDebugMode);

  final PurchaseRepository _server;
  final InAppPurchase _store;

  /// 테스트용 주입. 없으면 Play 의 `queryPastPurchases`(이 계정이 지금 가진 구매).
  final Future<List<GooglePlayPurchaseDetails>> Function()? _playOwned;

  /// 이 앱 회원의 난독화 계정 id(Play `obfuscatedAccountId`) — 로그인 회원 id 의 해시.
  ///
  /// 구매마다 싣고, 전환 구매는 **이 값이 같은 구매만** 교체한다. Play 의 보유 구매 조회는 앱
  /// 회원이 아니라 기기의 Play 계정 기준이라, 없으면 다른 회원(또는 이전 Play 계정)의 구독을
  /// 교체 대상으로 잡는다(09-28 실기기 · PM-DEC-137).
  final String? Function()? _accountId;

  /// 테스트용 주입. 없으면 StoreKit 2 `Transaction.all`.
  final Future<List<AppleTransaction>> Function()? _appleTransactions;

  final _out = StreamController<IapPurchase>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _storeSub;

  /// Logical SKU to what the store needs in order to sell it.
  final _catalog = <String, _StoreSku>{};

  /// Store product id to the logical SKU we last launched a purchase for.
  ///
  /// Android needs this. Play reports a subscription purchase as `bt_pro` and
  /// **drops the base plan**, so the billing period — the whole difference
  /// between monthly and yearly — is not in the purchase at all. For a
  /// purchase we started ourselves we still know which one we asked for.
  final _launched = <String, String>{};

  /// Store product ids whose last launched purchase used the trial offer.
  final _launchedTrial = <String>{};

  /// Receipts awaiting their store handshake, keyed by token, so a batched
  /// restore can finish the right transactions once the server accepts them.
  final _awaitingFinish = <String, PurchaseDetails>{};

  /// Non-null while [restore] is collecting, so restored receipts go out as
  /// one batch instead of one request each.
  List<IapPurchase>? _restoreBatch;

  @override
  Stream<IapPurchase> get purchases => _out.stream;

  /// The store cannot answer this yet.
  ///
  /// `in_app_purchase` exposes no introductory-offer eligibility on either
  /// platform (StoreKit 2's `SK2SubscriptionInfo` carries promotional offers
  /// and the group id, but no per-account eligibility). False keeps the free
  /// trial line off the paywall, which is the safe side: telling a member who
  /// already spent their trial that the first week is free is a 3.1.2
  /// misstatement and an unexpected charge.
  @override
  bool get reportsIntroEligibility => false;

  @override
  Future<bool> isAvailable() => _store.isAvailable();

  @override
  Future<List<IapProduct>> getProducts(Set<String> ids) async {
    final response = await _store.queryProductDetails(_storeIdsFor(ids));
    if (response.error != null && response.productDetails.isEmpty) {
      throw StateError('store product query failed: ${response.error!.message}');
    }
    // Sandbox testing has no other window into this. A product that is simply
    // not registered comes back as a silent absence, which on screen looks
    // exactly like a fallback price — so without this line "the store never
    // answered" and "the store answered with list prices" are indistinguishable.
    assert(() {
      debugPrint('[iap] query -> found=${response.productDetails.map((p) => p.id).toList()} '
          'notFound=${response.notFoundIDs} err=${response.error?.message}');
      return true;
    }());
    final found = <String, IapProduct>{};
    for (final details in response.productDetails) {
      final sku = _logicalSkuOf(details);
      // Not ours, or a discounted Play offer we do not sell directly. Skipping
      // beats guessing: an unrecognised id here would become a purchase of
      // something nobody chose.
      if (sku == null || !ids.contains(sku) || found.containsKey(sku)) continue;
      final offer = _offerOf(details);
      _catalog[sku] = _StoreSku(
        details: details,
        offerToken: offer?.offerIdToken,
        // 체험 오퍼가 조회에 실렸으면 이 계정은 자격이 있다 — 새 구독은 그 토큰으로 연다.
        trialOfferToken: _trialTokenFor(details, response.productDetails),
      );
      // Play 의 `details.price` 는 첫 가격 단계다. 기본 플랜은 단계가 하나라 같지만, 청구되는
      // 금액은 언제나 마지막(반복) 단계라 그쪽을 읽는다.
      final recurring = offer?.pricingPhases.lastOrNull;
      found[sku] = IapProduct(
        id: sku,
        type: _typeOf(sku),
        localizedPrice: recurring?.formattedPrice ?? details.price,
        title: details.title,
        rawPrice: recurring == null
            ? details.rawPrice
            : recurring.priceAmountMicros / 1000000,
        currencyCode: recurring?.priceCurrencyCode ?? details.currencyCode,
        freeTrial: _catalog[sku]!.trialOfferToken != null,
      );
    }
    return found.values.toList();
  }

  /// [base] 와 같은 구독·기본 플랜 위의 무료체험 오퍼 토큰. 없으면 `null`.
  String? _trialTokenFor(ProductDetails base, List<ProductDetails> all) {
    final baseOffer = _offerOf(base);
    if (baseOffer == null) return null;
    final candidates = <SubscriptionOfferDetailsWrapper>[
      for (final d in all)
        if (d.id == base.id) ?_offerOf(d),
    ];
    final i = pickTrialOffer(
      [
        for (final o in candidates)
          (
            basePlanId: o.basePlanId,
            offerId: o.offerId,
            tags: o.offerTags,
            hasFreePhase: o.pricingPhases.any((p) => p.priceAmountMicros == 0),
          ),
      ],
      basePlanId: baseOffer.basePlanId,
    );
    return i == null ? null : candidates[i].offerIdToken;
  }

  /// 오퍼 목록에서 무료체험 오퍼의 자리 — [basePlanId] 위의, 윈백이 아니고 무료 단계를 가진 것.
  /// id 가 [IapProductIds.playTrialOfferId] 인 것을 먼저 고른다. 없으면 `null`.
  ///
  /// Play 는 자격 없는 오퍼(이미 체험을 쓴 계정의 체험 등)를 조회 결과에서 빼고 준다. 그래서
  /// 이 함수가 무엇을 고르면 그 계정은 자격이 있다.
  @visibleForTesting
  static int? pickTrialOffer(
    List<
            ({
              String basePlanId,
              String? offerId,
              List<String> tags,
              bool hasFreePhase,
            })>
        offers, {
    required String basePlanId,
  }) {
    int? free;
    for (var i = 0; i < offers.length; i++) {
      final o = offers[i];
      if (o.basePlanId != basePlanId || o.offerId == null) continue;
      if (o.offerId == IapProductIds.playWinbackOfferId ||
          o.tags.contains(IapProductIds.playWinbackOfferTag)) {
        continue;
      }
      if (o.offerId == IapProductIds.playTrialOfferId) return i;
      if (free == null && o.hasFreePhase) free = i;
    }
    return free;
  }

  @override
  Future<void> purchase(IapProduct product) =>
      _buy(product, switching: false);

  @override
  Future<void> purchaseSwitch(IapProduct product) =>
      _buy(product, switching: true);

  Future<void> _buy(IapProduct product, {required bool switching}) async {
    var sku = _catalog[product.id];
    if (sku == null) {
      await getProducts({product.id});
      sku = _catalog[product.id];
    }
    if (sku == null) {
      // The store has no such product. Registered ids never vanish, so this is
      // a build pointing at the wrong bundle, or a product not yet approved.
      //
      // Thrown rather than pushed onto the stream: a stream `failed` is what a
      // *payment* failure looks like, and callers turn that into "your card was
      // declined". Nothing was declined here — nothing was ever offered — and
      // telling a member to update their payment method for a catalog gap
      // sends them to fix something that is not broken.
      throw StateError('product not found on store: ${product.id}');
    }
    final GooglePlayPurchaseDetails? replacing;
    if (!_isPlay || _typeOf(product.id) != IapProductType.subscription) {
      // iOS 는 같은 구독 그룹 안의 교체를 애플이 한다 — 앱이 넘길 교체 설정이 없다.
      replacing = null;
    } else if (switching) {
      // 전환은 교체할 구독을 확실히 알 때만 연다. 조회 오류·빈 목록·이 회원 것이 아닌 구독뿐이면
      // 결제창을 열지 않는다 — 교체 없이 열면 새 구독이 기존 구독과 나란히 청구되고, 남의 구독을
      // 교체하면 다른 계정의 구독을 끊는다(QA F083 · PM-DEC-137).
      final owned = await (_playOwned?.call() ?? _queryPlayOwned());
      replacing = pickReplacedSubscription(owned,
          targetId: sku.details.id, accountId: _currentAccountId());
      if (replacing == null) {
        throw StateError('no owned Premium to replace for ${product.id}');
      }
    } else {
      // 신규 구매는 교체하지 않는다(PM-DEC-137). 전환은 [purchaseSwitch] 만의 일이다 — 신규 경로가
      // 보유 구독을 찾아 교체를 붙이던 때, 기기에 남은 다른 Play 계정의 연간 구독이 새 회원의
      // 월간 결제를 CHARGE_FULL_PRICE 교체로 열었다(09-28 실기기).
      replacing = null;
    }
    _launched[sku.details.id] = product.id;
    final startsTrial = replacing == null &&
        sku.offerToken != null &&
        sku.trialOfferToken != null;
    if (startsTrial) {
      _launchedTrial.add(sku.details.id);
    } else {
      _launchedTrial.remove(sku.details.id);
    }
    // Subscriptions and characters both: `buyConsumable` is for goods that can
    // be bought again, and neither of ours can be. On Play this is also what
    // keeps a character un-consumed, which is how Play models "owned forever"
    // — it has no non-consumable product type of its own.
    final launched = await _store.buyNonConsumable(
        purchaseParam: _paramFor(sku, replacing: replacing));
    // 결제창을 못 열면 스토어는 예외 대신 false 만 돌려준다. 버리면 스트림에 아무것도 안 와서
    // 처리 화면 스피너가 멈춘다(QA F071). 예외로 올려 호출부의 「스토어 오류」 시트로 보낸다.
    if (!launched) {
      throw StateError('store could not launch the purchase: ${product.id}');
    }
  }

  @override
  Future<RestoreOutcome> restore() async {
    _restoreBatch = <IapPurchase>[];
    var storeFailed = false;
    try {
      await _store.restorePurchases();
      // The stream has no "that was all" signal, so give the platform a beat
      // to drain before closing the batch. Anything later still arrives — it
      // just takes the single-receipt path in [_deliver].
      await Future<void>.delayed(const Duration(milliseconds: 900));
    } catch (_) {
      storeFailed = true;
    }
    final batch = _restoreBatch ?? const <IapPurchase>[];
    _restoreBatch = null;
    if (batch.isEmpty) {
      return storeFailed ? RestoreOutcome.unavailable : RestoreOutcome.nothing;
    }
    return _submitRestore(batch);
  }

  @override
  Future<bool> presentOfferCodeRedemption() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      // Play redeems promo codes in the Play Store app, not through a sheet
      // the app can raise. Saying false lets the caller send the member there
      // instead of opening nothing.
      return false;
    }
    final addition =
        _store.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await addition.presentCodeRedemptionSheet();
    return true;
  }

  @override
  Future<bool> purchaseWinbackOffer() async {
    if (!_isPlay) return false;
    final ids = IapProductIds.playIdsFor(IapProductIds.maxMonthly);
    if (ids == null) return false;
    final ProductDetailsResponse response;
    try {
      response = await _store.queryProductDetails({ids.subscriptionId});
    } catch (_) {
      return false;
    }
    // Play 는 오퍼마다 ProductDetails 를 하나씩 준다(subscriptionIndex). 기본 플랜
    // 행(offerId 없음)은 [_logicalSkuOf] 가 SKU 로 잡고, 오퍼 행은 거기서 걸러진다 — 윈백은
    // 여기서만 찾는다.
    final candidates = <(ProductDetails, SubscriptionOfferDetailsWrapper)>[];
    for (final d in response.productDetails) {
      final offer = _offerOf(d);
      if (offer != null) candidates.add((d, offer));
    }
    final i = pickWinbackOffer(
      [
        for (final (_, o) in candidates)
          (basePlanId: o.basePlanId, offerId: o.offerId, tags: o.offerTags),
      ],
      basePlanId: ids.basePlanId,
    );
    if (i == null) return false;
    final (details, offer) = candidates[i];
    // Play 는 구매에 기본 플랜을 싣지 않는다 — 우리가 연 결제라 SKU 를 기억해 둔다.
    _launched[details.id] = IapProductIds.maxMonthly;
    // 윈백은 체험이 아니다 — 같은 세션에서 체험 결제창을 열었다 닫은 흔적이 남아 성공 화면이
    // 「7 days free」 라고 하지 않게 지운다(QA F090).
    _launchedTrial.remove(details.id);
    // 결제창을 못 열면 false — 호출부가 스토어 구독 화면으로 보낸다. 예전엔 true 를 돌려줘 처리
    // 화면 스피너가 멈췄다(QA F074).
    return _store.buyNonConsumable(
      purchaseParam: GooglePlayPurchaseParam(
        productDetails: details,
        // 윈백 재가입도 이 회원의 구매로 표시한다 — 없으면 요금 줄·연간 전환이 계속 막힌다(QA F089).
        applicationUserName: _storeAccountId(),
        offerToken: offer.offerIdToken,
      ),
    );
  }

  /// 오퍼 목록에서 윈백 오퍼의 자리 — [basePlanId] 위의, id 가
  /// [IapProductIds.playWinbackOfferId] 이거나 태그 [IapProductIds.playWinbackOfferTag] 를 단 것.
  /// id 가 맞는 것을 먼저 고른다. 없으면 `null`.
  @visibleForTesting
  static int? pickWinbackOffer(
    List<({String basePlanId, String? offerId, List<String> tags})> offers, {
    required String basePlanId,
  }) {
    int? tagged;
    for (var i = 0; i < offers.length; i++) {
      final o = offers[i];
      if (o.basePlanId != basePlanId || o.offerId == null) continue;
      if (o.offerId == IapProductIds.playWinbackOfferId) return i;
      if (tagged == null && o.tags.contains(IapProductIds.playWinbackOfferTag)) {
        tagged = i;
      }
    }
    return tagged;
  }

  /// Stops listening. The store keeps unfinished transactions; a new instance
  /// picks them up.
  Future<void> dispose() async {
    await _storeSub?.cancel();
    await _out.close();
  }

  // --------------------------------------------------------------- internals

  void _onStoreEvent(List<PurchaseDetails> events) {
    for (final pd in events) {
      switch (pd.status) {
        case PurchaseStatus.pending:
          _out.add(_event(pd, IapPurchaseState.pending));
        case PurchaseStatus.canceled:
          _finish(pd);
          _out.add(_event(pd, IapPurchaseState.canceled));
        case PurchaseStatus.error:
          _finish(pd);
          _out.add(_event(pd, IapPurchaseState.failed,
              error: pd.error, failure: storeFailureOf(pd.error)));
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          unawaited(_deliver(pd));
      }
    }
  }

  /// Server verification, then — and only then — the store handshake.
  Future<void> _deliver(PurchaseDetails pd) async {
    final restored = pd.status == PurchaseStatus.restored;
    final purchase = _event(
      pd,
      restored ? IapPurchaseState.restored : IapPurchaseState.purchased,
    );

    final batch = _restoreBatch;
    if (restored && batch != null) {
      batch.add(purchase);
      return;
    }

    try {
      await _server.verify(purchase);
    } catch (e) {
      final failure = verifyFailureOf(e);
      // Only a receipt no retry can fix is closed: the store judged it invalid,
      // or it already belongs to another account (granted and acknowledged
      // there). Everything else stays live — the store re-delivers it next
      // launch, which retries this verification for free, and on Play an
      // unacknowledged purchase our server never granted is refunded by
      // Google after three days instead of being kept (QA F028).
      if (failure == IapFailure.rejected || failure == IapFailure.otherAccount) {
        _finish(pd);
        _launched.remove(pd.productID);
      }
      _out.add(_event(pd, IapPurchaseState.failed, error: e, failure: failure));
      return;
    }
    _finish(pd);
    _launched.remove(pd.productID);
    _out.add(purchase);
  }

  /// Posts the replayed receipts and reads the server's verdict (QA F003).
  ///
  /// The server answers 200 even when it granted nothing (`restored` 0 ·
  /// `failed` N), and it counts a receipt that was **already** granted as
  /// neither — so the entitlement it returns is what says whether this account
  /// has something now.
  Future<RestoreOutcome> _submitRestore(List<IapPurchase> batch) async {
    final RestoreResultDto result;
    try {
      result = await _server.restore(batch);
    } catch (e) {
      // Unfinished on purpose, like a failed single verify: the store replays
      // them next time.
      for (final p in batch) {
        _awaitingFinish.remove(p.purchaseToken);
      }
      return RestoreOutcome.unavailable;
    }
    final outcome = restoreOutcomeOf(result, batch);
    for (final p in batch) {
      final pd = _awaitingFinish.remove(p.purchaseToken);
      if (!grantedByRestore(p, outcome, result.entitlement)) continue;
      if (pd != null) _finish(pd);
      _out.add(p);
    }
    return outcome;
  }

  /// 복원 묶음의 한 영수증을 `restored` 로 내보내고 거래를 닫아도 되는가 — 서버가 실제로 지급한 것만.
  ///
  /// 서버는 건별 판정 없이 개수(`restored`·`failed`)와 결과 권한만 준다(건별 사유는 서버 요청서 §22 ③).
  /// 예전에는 묶음이 하나라도 복원되면 전부 내보내서, 서버가 거절한 Premium 영수증이 캐릭터 복원과
  /// 함께 나가 세션이 Premium 으로 올라갔다(QA F068). 구독은 결과 권한이 Premium 일 때만 낸다.
  @visibleForTesting
  static bool grantedByRestore(
      IapPurchase p, RestoreOutcome outcome, EntitlementDto entitlement) {
    if (outcome != RestoreOutcome.restored &&
        outcome != RestoreOutcome.restoredCharacters) {
      return false;
    }
    if (p.type == IapProductType.subscription) return entitlement.isPro;
    // 묶음 영수증(kind "bundle", QA F103) — 서버는 유료 3종 중 없는 것만 지급한다(PM-DEC-170).
    // 지급이 끝나면 3종을 다 가진다. 그때 닫아야 iOS 에 끝나지 않은 거래가 남지 않는다.
    if (p.productId == IapProductIds.characterBundle) {
      return _ownsEverySoldCharacter(entitlement);
    }
    // 캐릭터는 결과 권한에 그 캐릭터가 있을 때만. 대응을 못 찾으면(표에 없는 id · dev 번호) 열어
    // 둔다 — 다음 실행 때 스토어가 다시 보내 단건 검증 경로가 판정한다(QA F070 · PM-DEC-119).
    return entitlement.ownedCharacterIds
        .any((id) => IapProductIds.characterFor(id) == p.productId);
  }

  /// The restore result to a [RestoreOutcome], split by **what was sent**.
  ///
  /// The server answers with counts and the resulting entitlement only (per-item
  /// reasons are server request §22 ③). The batch says which kinds went up, so:
  /// - a subscription receipt went up and the account is Premium → [restored];
  /// - a character / bundle receipt went up and that character is owned now →
  ///   [RestoreOutcome.restoredCharacters] — also when it was owned already
  ///   (already_granted counts in neither number);
  /// - receipts went up and nothing came of them → another account, worded for
  ///   the subscription when one was sent, otherwise for characters;
  /// - nothing went up → [RestoreOutcome.nothing].
  ///
  /// Free starters don't count as owned: the server marks Baba as owned at
  /// sign-up, so "owns a character" was true for every Free account (QA F003).
  @visibleForTesting
  static RestoreOutcome restoreOutcomeOf(
      RestoreResultDto r, List<IapPurchase> batch) {
    final subscriptionSent =
        batch.any((p) => p.type == IapProductType.subscription);
    final characterSent =
        batch.any((p) => p.type != IapProductType.subscription);
    if (subscriptionSent && r.entitlement.isPro) return RestoreOutcome.restored;
    final charactersBack = batch.any((p) =>
        p.type != IapProductType.subscription &&
        grantedByRestore(p, RestoreOutcome.restoredCharacters, r.entitlement));
    if (charactersBack) return RestoreOutcome.restoredCharacters;
    if (batch.isEmpty && r.restored == 0 && r.failed == 0) {
      return RestoreOutcome.nothing;
    }
    if (subscriptionSent) return RestoreOutcome.notThisAccount;
    if (characterSent) return RestoreOutcome.charactersNotThisAccount;
    return RestoreOutcome.nothing;
  }

  static bool _ownsEverySoldCharacter(EntitlementDto e) =>
      IapProductIds.soldCharacters.every((product) => e.ownedCharacterIds
          .any((id) => IapProductIds.characterFor(id) == product));

  /// A store-side purchase error to the reason the screens show. Play reports
  /// the billing response as the message (`BillingResponse.itemAlreadyOwned`);
  /// an already-owned product is not a declined card (09-28 device: a yearly
  /// switch read "Your card was declined").
  @visibleForTesting
  static IapFailure storeFailureOf(IAPError? error) {
    final text = '${error?.code} ${error?.message}'.toLowerCase();
    if (text.contains('itemalreadyowned') || text.contains('already_owned')) {
      return IapFailure.alreadyOwned;
    }
    return IapFailure.store;
  }

  /// A verification error to the reason the screens show.
  @visibleForTesting
  static IapFailure verifyFailureOf(Object e) => switch (e) {
        IapVerifyException(reason: IapVerifyRejection.invalidReceipt) =>
          IapFailure.rejected,
        IapVerifyException(reason: IapVerifyRejection.ownedByOther) =>
          IapFailure.otherAccount,
        // Unknown product is a server catalog gap, not a bad receipt: keep it
        // for the retry after the catalog is fixed.
        _ => IapFailure.verifyPending,
      };

  void _finish(PurchaseDetails pd) {
    if (pd.pendingCompletePurchase) unawaited(_store.completePurchase(pd));
  }

  IapPurchase _event(PurchaseDetails pd, IapPurchaseState state,
      {Object? error, IapFailure? failure}) {
    final token = pd.verificationData.serverVerificationData;
    final restored = state == IapPurchaseState.restored;
    if (restored) _awaitingFinish[token] = pd;
    // What we launched only labels what we launched.
    //
    // On Android every base plan of `bt_pro` reports the same product id, so
    // the remembered SKU is the *last thing this run asked to buy*. That is
    // the right answer for a purchase we started and the wrong one for a
    // restore: a member who bought monthly this session and then restores
    // would have their yearly receipt relabelled monthly. Restores therefore
    // send the raw store id and the server resolves the period from the
    // token, which is the only side that can.
    final sku = restored ? pd.productID : (_launched[pd.productID] ?? pd.productID);
    return IapPurchase(
      productId: sku,
      type: _typeOf(sku),
      state: state,
      error: error,
      failure: failure,
      // Play omits an order id on pending purchases; the token identifies the
      // transaction just as well and the server requires a non-empty value.
      transactionId:
          (pd.purchaseID?.isNotEmpty ?? false) ? pd.purchaseID! : token,
      purchaseToken: token,
      isSandbox: _isSandbox,
      startedTrial: !restored && _launchedTrial.contains(pd.productID),
    );
  }

  IapProductType _typeOf(String sku) =>
      IapProductIds.subscriptions.contains(sku)
          ? IapProductType.subscription
          : IapProductType.nonConsumable;

  /// Logical SKUs to the ids the store itself knows.
  ///
  /// Apple sells our four subscriptions as four products, so the sets match.
  /// Play sells two subscriptions with two base plans each, so four SKUs
  /// collapse to two query ids.
  Set<String> _storeIdsFor(Set<String> skus) {
    return {
      for (final sku in skus)
        if (_isPlay) IapProductIds.playIdsFor(sku)?.subscriptionId ?? sku
        else sku,
    };
  }

  static bool get _isPlay =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Store product to our logical SKU, or null when it is not one we sell.
  String? _logicalSkuOf(ProductDetails details) {
    final offer = _offerOf(details);
    if (offer == null) return details.id;
    // Only the plain base plan maps to a SKU. Discounted Play offers ride the
    // same base plan and are applied by the store, not chosen here.
    if (offer.offerId != null) return null;
    return IapProductIds.logicalSkuFromPlay(details.id, offer.basePlanId);
  }

  SubscriptionOfferDetailsWrapper? _offerOf(ProductDetails details) {
    if (details is! GooglePlayProductDetails) return null;
    final index = details.subscriptionIndex;
    final offers = details.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) return null;
    return offers[index];
  }

  PurchaseParam _paramFor(_StoreSku sku,
      {GooglePlayPurchaseDetails? replacing}) {
    final account = _storeAccountId();
    if (sku.offerToken == null) {
      return PurchaseParam(
          productDetails: sku.details, applicationUserName: account);
    }
    if (replacing != null) {
      // 월간↔연간 전환(QA F067 · PM-DEC-126). PM-DEC-121 로 둘이 서로 다른 Play 구독이라, 교체
      // 설정 없이 사면 기존 구독이 그대로 살아 이중 청구된다. CHARGE_FULL_PRICE — 새 구독 전액을
      // 바로 청구하고 기존 구독의 남은 가치는 새 구독 기간 연장으로 돌려준다. 전환은 새 고객이
      // 아니므로 체험 토큰을 쓰지 않는다(연간 체험이 월간 회원에게 열려 있어도).
      return GooglePlayPurchaseParam(
        productDetails: sku.details,
        applicationUserName: account,
        offerToken: sku.offerToken,
        changeSubscriptionParam: ChangeSubscriptionParam(
          oldPurchaseDetails: replacing,
          replacementMode: ReplacementMode.chargeFullPrice,
        ),
      );
    }
    // Without the offer token Play falls back to the subscription's default
    // base plan — which is how an annual selection quietly billed monthly.
    return GooglePlayPurchaseParam(
      productDetails: sku.details,
      applicationUserName: account,
      offerToken: sku.trialOfferToken ?? sku.offerToken,
    );
  }

  String? _currentAccountId() {
    try {
      final id = _accountId?.call();
      return (id == null || id.isEmpty) ? null : id;
    } catch (_) {
      return null;
    }
  }

  /// [_currentAccountId] in the shape this store accepts. Play takes the
  /// 64-char hex as `obfuscatedAccountId`; StoreKit 2's `appAccountToken` must
  /// be a UUID or the plugin drops it silently.
  String? _storeAccountId() {
    final id = _currentAccountId();
    if (id == null) return null;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? appleAccountToken(id)
        : id;
  }

  /// The member hash as a UUID for StoreKit's `appAccountToken`: the first 16
  /// bytes of the SHA-256, stamped version 5 / RFC 4122 variant (name-based,
  /// like UUIDv5). Derived from the same hash as Play's id, so neither store
  /// receives the Supabase user id itself — only a one-way value that the app
  /// can recompute to recognise its own member's purchases.
  @visibleForTesting
  static String appleAccountToken(String hexHash) {
    final b = [
      for (var i = 0; i < 32; i += 2)
        int.parse(hexHash.substring(i, i + 2), radix: 16),
    ];
    b[6] = (b[6] & 0x0f) | 0x50;
    b[8] = (b[8] & 0x3f) | 0x80;
    final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
        '${h.substring(16, 20)}-${h.substring(20)}';
  }

  @override
  Future<bool?> ownsAnnualPremium() async {
    if (kIsWeb) return null;
    if (defaultTargetPlatform == TargetPlatform.iOS) return _appleOwnsAnnual();
    if (!_isPlay) return null;
    final List<GooglePlayPurchaseDetails> owned;
    try {
      owned = await (_playOwned?.call() ?? _queryPlayOwned());
    } catch (_) {
      return null;
    }
    // 이 앱 회원의 구매만 본다 — 기기의 Play 계정에 남은 다른 회원의 구독으로 주기를 판단하면
    // 그 회원 것을 교체하는 전환 줄이 열린다(PM-DEC-137).
    final account = _currentAccountId();
    final premium = [
      for (final p in owned)
        if (p.status != PurchaseStatus.pending &&
            IapProductIds.playPremiumSubscriptionIds.contains(p.productID) &&
            belongsTo(p, account))
          p.productID,
    ];
    // 이 구글 계정에 Premium 이 없다 — 관리자 부여 · 다른 계정 · 다른 플랫폼 결제. 「월간」 으로
    // 보면 교체 대상 없이 두 번째 구독을 사게 된다(QA F072). 모름으로 두고 전환을 막는다.
    if (premium.isEmpty) return null;
    final yearlyId = IapProductIds.playIdsFor(IapProductIds.maxYearly)!.subscriptionId;
    if (premium.contains(yearlyId)) return true;
    // 레거시 `bt_max` 는 구매에 기본 플랜이 안 실려 주기를 모른다.
    if (premium.any((id) => !IapProductIds.subscriptionIdIsCurrent(id))) return null;
    return false;
  }

  /// iOS — 지금 유효한(만료 전) Premium 거래 중 가장 최근 것의 상품으로 주기를 본다.
  /// 같은 구독 그룹 안의 교체는 애플이 처리한다(업그레이드 즉시 · 다운그레이드는 갱신 때).
  Future<bool?> _appleOwnsAnnual() async {
    final List<AppleTransaction> all;
    try {
      all = await (_appleTransactions?.call() ?? _queryAppleTransactions());
    } catch (_) {
      return null;
    }
    return appleOwnsAnnual(all,
        now: DateTime.now(), accountToken: _storeAccountId());
  }

  static Future<List<AppleTransaction>> _queryAppleTransactions() async => [
        for (final t in await SK2Transaction.transactions())
          (
            productId: t.productId,
            expires: parseStoreKitDate(t.expirationDate),
            purchased: parseStoreKitDate(t.purchaseDate),
            account: t.appAccountToken,
          ),
      ];

  /// StoreKit 2 래퍼의 날짜 — epoch **밀리초 문자열**(`_secondsToMillisecondsSinceEpochString`).
  /// ISO 로 읽으면 늘 null 이라 iOS 월간 회원에게도 전환 줄이 숨겨졌다(QA F073).
  @visibleForTesting
  static DateTime? parseStoreKitDate(String? s) {
    if (s == null || s.isEmpty) return null;
    final ms = num.tryParse(s);
    if (ms != null) {
      return DateTime.fromMillisecondsSinceEpoch(ms.round(), isUtc: true);
    }
    return DateTime.tryParse(s);
  }

  /// [all] 에서 유효한 Premium 이 연간인가. 유효한 Premium 이 없으면 `null`(모름 — 버튼을 숨긴다).
  ///
  /// [accountToken] 회원의 거래만 본다 — Play 의 obfuscatedAccountId 대조와 같은 규칙(PM-DEC-138).
  /// 토큰이 없는 거래(이 대조 이전 구매)는 세지 않는다.
  @visibleForTesting
  static bool? appleOwnsAnnual(List<AppleTransaction> all,
      {required DateTime now, required String? accountToken}) {
    const premium = {IapProductIds.maxMonthly, IapProductIds.maxYearly};
    final live = [
      for (final t in all)
        if (accountToken != null &&
            t.account?.toLowerCase() == accountToken.toLowerCase() &&
            premium.contains(t.productId) &&
            t.expires != null &&
            t.expires!.isAfter(now))
          t,
    ]..sort((a, b) =>
        (b.purchased ?? DateTime(0)).compareTo(a.purchased ?? DateTime(0)));
    if (live.isEmpty) return null;
    return live.first.productId == IapProductIds.maxYearly;
  }

  Future<List<GooglePlayPurchaseDetails>> _queryPlayOwned() async {
    final response = await _store
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
        .queryPastPurchases();
    // 오류를 빈 목록으로 삼키면 「보유 없음」 과 구분이 안 된다(QA F083). 오류는 오류로 올린다.
    if (response.error != null) {
      throw StateError('owned purchase query failed: ${response.error!.message}');
    }
    return response.pastPurchases;
  }

  /// [p] 가 [account] 회원의 구매인가 — Play `obfuscatedAccountId` 대조. 회원 id 를 모르거나
  /// 구매에 id 가 없으면(이 대조 이전 구매) false 다. 남의 구독을 끊는 것보다 전환을 막는 편이
  /// 낫다(fail-closed · PM-DEC-137).
  @visibleForTesting
  static bool belongsTo(GooglePlayPurchaseDetails p, String? account) =>
      account != null &&
      p.billingClientPurchase.obfuscatedAccountId == account;

  /// [owned] 에서 교체할 Premium 구독 — [targetId] 가 아니고 결제가 끝났고 [accountId] 회원 것.
  @visibleForTesting
  static GooglePlayPurchaseDetails? pickReplacedSubscription(
    List<GooglePlayPurchaseDetails> owned, {
    required String targetId,
    required String? accountId,
  }) {
    for (final p in owned) {
      if (p.productID == targetId || p.status == PurchaseStatus.pending) {
        continue;
      }
      if (!belongsTo(p, accountId)) continue;
      if (IapProductIds.playPremiumSubscriptionIds.contains(p.productID)) {
        return p;
      }
    }
    return null;
  }
}

/// StoreKit 2 거래 중 주기 판단에 쓰는 것만.
typedef AppleTransaction = ({
  String productId,
  DateTime? expires,
  DateTime? purchased,
  String? account,
});

/// A store product plus what Play needs in order to charge the right base plan.
class _StoreSku {
  const _StoreSku(
      {required this.details, this.offerToken, this.trialOfferToken});

  final ProductDetails details;

  /// 기본 플랜 오퍼 토큰 — 체험 없이 바로 청구.
  final String? offerToken;

  /// 무료체험 오퍼 토큰 — 이 계정에 자격이 있을 때만(Play 가 조회에 실어 준 경우).
  final String? trialOfferToken;
}
