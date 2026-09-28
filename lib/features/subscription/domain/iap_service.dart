/// The single payment rail — work order v2 §4-1.
///
/// v1 shipped a `BillingRail` abstraction with a store lane and an in-house PG
/// lane. v2 killed it: selling app-consumed digital goods outside IAP is a
/// review rejection (App Store 3.1.1, Play billing policy), so **characters
/// are non-consumable IAP** and there is exactly one rail. With one rail, a
/// rail abstraction is dead weight — what remains is the *product type*.
library;

import 'dart:async';

import 'plan_prices.dart';

/// The two product shapes the store sells for us.
enum IapProductType {
  /// Auto-renewing subscription (Pro / Max, monthly / yearly).
  subscription,

  /// One-time, owned forever — a character. Never expires, survives
  /// subscription lapse, and **must** be returned by [IapService.restore]
  /// (v2 completion criterion 11).
  nonConsumable,
}

/// The confirmed store catalog — see
/// `docs/2026-08-04_2018_IAP_상품등록_ID체계_설계서.md` (v2 §7-4 closed).
///
/// These strings are what gets registered in App Store Connect and Play
/// Console. **A store product id can never be edited or reused**, not even
/// after deleting the product, so a typo here is permanent: change nothing
/// without changing the design doc first.
///
/// The character set is the intersection of both stores' rules — lowercase
/// letters, digits, `_` and `.`, at most 40 chars, first char lowercase.
/// Apple also allows hyphens and uppercase; Play does not, and one string has
/// to work on both.
abstract final class IapProductIds {
  /// Logical SKUs. On iOS these *are* the App Store product ids; on Android
  /// they are the composition of a subscription id and a base plan id (see
  /// [playIdsFor]).
  static const proMonthly = 'bt_pro_monthly';
  static const proYearly = 'bt_pro_yearly';
  static const maxMonthly = 'bt_max_monthly';
  static const maxYearly = 'bt_max_yearly';

  static const subscriptions = {proMonthly, proYearly, maxMonthly, maxYearly};

  /// Play 윈백 오퍼 — `bt_max_monthly` · 기본 플랜 `monthly` · 첫 달 50% × 1회(개발자 결정형 ·
  /// 09-28 `bt_max` 에서 새 구독으로 복제 · PM-DEC-121 ·
  /// targeting 없음 — Play 가 스스로 노출하지 않는다). 09-26 branch to dev 세션이 콘솔 API 로
  /// 생성·활성화(PM-DEC-049·050). iOS 윈백 오퍼는 애플이 자격 판정·노출해 앱 코드가 없다.
  static const playWinbackOfferId = 'winback-50-1m';

  /// 같은 오퍼의 태그. 오퍼 id 가 바뀌어도 태그로 찾는다.
  static const playWinbackOfferTag = 'winback';

  /// Play 7일 무료체험 오퍼 — `bt_max_monthly/monthly` · `bt_max_yearly/yearly` 둘 다(09-28 ACTIVE).
  /// Play 는 이 계정이 받을 자격이 있는 오퍼만 조회 결과에 싣는다. 그래서 결과에 있으면 자격이
  /// 있는 것이고, 앱은 그 오퍼 토큰으로 결제창을 연다 — 기본 플랜 토큰으로 열면 체험 없이 바로
  /// 청구된다(09-28 실결제 ₩33,000 즉시 청구).
  static const playTrialOfferId = 'trial-7d';

  /// 전환 구매가 교체할 수 있는 Play Premium 구독 — 현행 둘 + 레거시 `bt_max`(월간·연간 기본 플랜을
  /// 한 구독에 두던 시절 · PM-DEC-121 이전 결제). 전환 때 이 중 하나를 가지고 있으면 교체한다(F067).
  static const playPremiumSubscriptionIds = {
    'bt_max_monthly',
    'bt_max_yearly',
    'bt_max',
  };

  /// [subscriptionId] 가 현행 Play 구독(주기별로 따로 만든 것)인가 — 레거시 `bt_max` 면 false.
  static bool subscriptionIdIsCurrent(String subscriptionId) =>
      _playIds.values.any((v) => v.subscriptionId == subscriptionId);

  /// Character product id, keyed by **slug** — never by the server's primary
  /// key. Store ids are permanent while database ids are not, and a bare
  /// integer tells nobody in the console or the payout report which character
  /// sold. Slugs match the asset folders under `assets/avatar/`.
  static String character(String slug) => 'bt_character_$slug';

  /// The three paid characters sold together (PM-DEC-142 · DEC-PR-05). A
  /// one-time product on both stores; granted by the server once §24 ships.
  static const characterBundle = 'bt_character_bundle';

  /// Server `character_id` → slug. **A fallback, not the source of truth.**
  ///
  /// The server now carries the slug itself as `character.product_key`
  /// (`CharacterDto.productKey`), and callers must prefer that: these ids are
  /// **prod-only** — dev numbers the same characters 2·3·4·5 — so resolving a
  /// purchase through this table off prod buys a *different* character than
  /// the one on screen. It stays for older servers that send no `product_key`
  /// and for [isFreeCharacter], which needs an id→slug answer before any
  /// character payload is in hand. Ids come from
  /// `character_copy_overrides.dart`, which carries the same mapping.
  static const characterSlugs = <int, String>{
    1: 'baba',
    2: 'bibi',
    9: 'popo',
    10: 'rara',
    11: 'dudu',
  };

  /// The characters every member gets without paying (대표 결정 2026-08-04).
  ///
  /// They are **not** registered as store products — there is nothing to
  /// charge for — which is why [characterFor] returns null for them. The Free
  /// plan already advertises this as "Basic characters included".
  static const freeCharacterSlugs = {'baba', 'bibi'};

  /// Whether this character is free for everyone.
  static bool isFreeCharacter(int serverId) =>
      freeCharacterSlugs.contains(characterSlugs[serverId]);

  /// Store product id for a character, preferring the server's own slug.
  ///
  /// [productKey] is `CharacterSummary.product_key`. It wins over the built-in
  /// table because the table only knows the characters that existed when this
  /// build shipped: a character added server-side afterwards has no row here,
  /// and [characterFor] would call it unbuyable when the store may well have
  /// the product.
  ///
  /// **The server sends a bare slug** — `popo`, `rara`, `dudu`, `baba`,
  /// `bibi`. Confirmed against the live API on 2026-08-24, so the prefix is
  /// this method's job.
  ///
  /// The already-qualified shape (`bt_character_popo`) is still tolerated, and
  /// deliberately so: prefixing a value that is already prefixed produces
  /// `bt_character_bt_character_popo`, and the store answers that with a
  /// silent absence rather than an error. The guard costs one comparison and
  /// removes a failure mode that would look like "the product vanished".
  ///
  /// Returns null for free characters and when nothing identifies the product.
  static String? characterForKey(String? productKey, int serverId) {
    final key = productKey?.trim();
    if (key == null || key.isEmpty) return characterFor(serverId);
    const prefix = 'bt_character_';
    final slug = key.startsWith(prefix) ? key.substring(prefix.length) : key;
    if (slug.isEmpty || freeCharacterSlugs.contains(slug)) return null;
    return character(slug);
  }

  /// Every character product that is actually sold.
  ///
  /// The free ones are excluded because they were never registered — asking
  /// the store for `bt_character_baba` returns nothing and would look like an
  /// outage rather than the deliberate absence it is.
  static Set<String> get soldCharacters => {
        for (final slug in characterSlugs.values)
          if (!freeCharacterSlugs.contains(slug)) character(slug),
      };

  /// Store product id for a server character id, or `null` when that character
  /// has no registered store product.
  ///
  /// Null covers two different situations, and callers that need to tell them
  /// apart should ask [isFreeCharacter] first:
  /// - **Free character** — deliberately not sold.
  /// - **Unknown character** — added server-side after this build shipped. No
  ///   slug here means no product was registered on the store either, so
  ///   inventing `bt_character_42` would only trade a clear failure for a
  ///   store lookup miss.
  static String? characterFor(int serverId) {
    final slug = characterSlugs[serverId];
    if (slug == null || freeCharacterSlugs.contains(slug)) return null;
    return character(slug);
  }

  /// Logical SKU → Play (subscription id, base plan id).
  ///
  /// The stores model subscriptions differently: Apple sells four products,
  /// Play sells two subscriptions with two base plans each. Play's purchase
  /// therefore reports `bt_pro`, and **the billing period lives only in the
  /// base plan id** — drop it and yearly silently reads as monthly, which is
  /// exactly the bug that already shipped once. This table is the single
  /// place that keeps the two halves together.
  static const _playIds =
      <String, ({String subscriptionId, String basePlanId})>{
    proMonthly: (subscriptionId: 'bt_pro', basePlanId: 'monthly'),
    proYearly: (subscriptionId: 'bt_pro', basePlanId: 'yearly'),
    // Premium 은 주기마다 **따로 만든 구독**이다(PM-DEC-121 · 09-28). 한 구독(`bt_max`)에
    // 기본 플랜 둘이던 때, 앱이 보내는 논리 SKU(`bt_max_monthly`)와 서버가 비교하는 구글
    // `lineItems[].productId`(`bt_max`)가 늘 달라 검증이 422 INVALID_RECEIPT 였다(실결제
    // 09-28 10:18). 구독 id 를 논리 SKU 와 같게 만들어 스토어 쪽에서 맞췄다. bt_pro_* 는 레거시라 그대로.
    maxMonthly: (subscriptionId: 'bt_max_monthly', basePlanId: 'monthly'),
    maxYearly: (subscriptionId: 'bt_max_yearly', basePlanId: 'yearly'),
  };

  /// Play identifiers for a logical subscription SKU, or `null` if unknown.
  static ({String subscriptionId, String basePlanId})? playIdsFor(
          String logicalSku) =>
      _playIds[logicalSku];

  /// Play identifiers → logical SKU, or `null` if the pair is not ours.
  ///
  /// Use this on every Android subscription purchase before reporting the
  /// product to the server (design doc §8): the server treats `product_id` as
  /// a logical SKU, and it must never be guessed from the subscription id
  /// alone.
  static String? logicalSkuFromPlay(String subscriptionId, String basePlanId) {
    for (final entry in _playIds.entries) {
      if (entry.value.subscriptionId == subscriptionId &&
          entry.value.basePlanId == basePlanId) {
        return entry.key;
      }
    }
    return null;
  }
}

/// A store product as the store describes it.
class IapProduct {
  /// Creates a product.
  const IapProduct({
    required this.id,
    required this.type,
    required this.localizedPrice,
    this.title,
    this.rawPrice = 0,
    this.currencyCode = '',
    this.freeTrial = false,
  });

  /// Whether the store offered this account the free-trial offer for this
  /// product. Play lists only offers the account is eligible for, so true
  /// means eligible; false means not eligible **or** the store cannot say
  /// (StoreKit) — the paywall then says nothing about a trial (3.1.2).
  final bool freeTrial;

  /// Logical SKU — `bt_pro_yearly`, `bt_character_popo`.
  ///
  /// On iOS this is the App Store product id verbatim. On Android it is the
  /// (subscription id, base plan id) pair collapsed by
  /// [IapProductIds.logicalSkuFromPlay]; Play itself never returns this
  /// string.
  final String id;

  /// Subscription or non-consumable.
  final IapProductType type;

  /// The store's localized display price (`$15.99`, `₩22,000`). **Always
  /// displayed verbatim** — v2 §6-4: the store is the price authority.
  ///
  /// This is also what makes a console-side discount visible without an app
  /// release. Schedule a price drop on App Store Connect and this string
  /// changes on its own; quote [PlanPrices] instead and the screen keeps
  /// showing full price while the member is charged less — a 3.1.2 mismatch
  /// in the other direction.
  final String localizedPrice;

  /// Store display name, when provided.
  final String? title;

  /// The same price as a number, in the store's currency. For comparisons
  /// (is this cheaper than list?), never for display — formatting is
  /// [localizedPrice]'s job.
  final double rawPrice;

  /// ISO-4217 code behind [rawPrice] (`USD`, `KRW`). Empty when unknown.
  final String currencyCode;
}

/// What happened to a purchase, delivered on [IapService.purchases].
enum IapPurchaseState {
  /// Store sheet is up / transaction in flight.
  pending,

  /// Paid and delivered.
  purchased,

  /// Came back via [IapService.restore].
  restored,

  /// The user dismissed the store sheet — `purchase_failed — 사용자 취소`.
  canceled,

  /// Declined card, store outage, … — the other two `purchase_failed` sheets.
  failed,
}

/// How long a purchase may sit in [IapPurchaseState.pending] before the screen
/// stops waiting and says so (QA F004).
///
/// Not zero: StoreKit reports every purchase as pending while its sheet is up
/// (`purchasing`), and a normal purchase resolves within seconds. A payment
/// still pending after this is a slow card, a cash payment or Ask to Buy — the
/// member must be able to leave; the rail delivers it whenever it completes.
const kPurchasePendingNoticeAfter = Duration(seconds: 8);

/// Why a [IapPurchaseState.failed] event failed — the screens pick their sheet
/// from this (QA F005 · F028 · 09-27).
///
/// Before this, every failure read as a declined card. But the store can take
/// the money and our server still not confirm it: telling that member
/// 「Your card was declined · Nothing was charged」 is false, and sends them to
/// change a card that worked.
enum IapFailure {
  /// The store itself failed — declined card, store outage. Nothing charged.
  store,

  /// The store took the payment; our server has not confirmed it yet (outage,
  /// timeout, `VERIFY_UNAVAILABLE`, unknown product). The receipt is kept and
  /// verified again on the next launch or by Restore.
  verifyPending,

  /// The store says the receipt is not valid (`INVALID_RECEIPT`). Retrying
  /// cannot change that, so the rail closes the transaction.
  rejected,

  /// The receipt already belongs to another BeaverTalk account
  /// (`RECEIPT_OWNED_BY_OTHER`).
  otherAccount,

  /// The store refused because this store account already has the product
  /// (Play `ITEM_ALREADY_OWNED`). Nothing was charged and no card was
  /// declined — the member is already subscribed.
  alreadyOwned,
}

/// Why `POST /purchases/verify` refused a receipt — the server's `detail.code`
/// (`domains/commerce/routers/purchases.py`). The message is for humans; this
/// is what the rail branches on.
enum IapVerifyRejection {
  /// 404 `UNKNOWN_PRODUCT` — the server does not know the product id.
  unknownProduct,

  /// 422 `INVALID_RECEIPT` — the store judged it invalid. Retrying is pointless.
  invalidReceipt,

  /// 409 `RECEIPT_OWNED_BY_OTHER` — used by another account.
  ownedByOther,

  /// 503 `VERIFY_UNAVAILABLE` — the store did not answer. Retry later.
  unavailable;

  /// The server's code string to this, or null for anything else.
  static IapVerifyRejection? fromCode(String? code) => switch (code) {
        'UNKNOWN_PRODUCT' => unknownProduct,
        'INVALID_RECEIPT' => invalidReceipt,
        'RECEIPT_OWNED_BY_OTHER' => ownedByOther,
        'VERIFY_UNAVAILABLE' => unavailable,
        _ => null,
      };
}

/// A verification refusal carrying the server's reason.
class IapVerifyException implements Exception {
  /// Creates the exception.
  const IapVerifyException(this.reason, [this.cause]);

  /// What the server said.
  final IapVerifyRejection reason;

  /// The underlying error, for logs.
  final Object? cause;

  @override
  String toString() => 'IapVerifyException($reason)';
}

/// What a restore came to — [IapService.restore] (QA F003 · 09-27).
///
/// Counting `restored` events was not enough: the server can refuse every
/// receipt and still answer 200, and the rail used to report the whole batch
/// as restored anyway — 「Premium is back」 with the plan still Free.
enum RestoreOutcome {
  /// Something is on this account now (newly granted or already there).
  restored,

  /// The store returned nothing to restore.
  nothing,

  /// The store returned receipts but the server granted none and the account
  /// has nothing — most often they belong to another BeaverTalk account.
  notThisAccount,

  /// The store or our server could not be reached.
  unavailable,
}

/// One purchase event.
class IapPurchase {
  /// Creates a purchase event.
  const IapPurchase({
    required this.productId,
    required this.type,
    required this.state,
    this.error,
    this.transactionId,
    this.purchaseToken,
    this.isSandbox = false,
    this.failure,
    this.startedTrial = false,
  });

  /// Whether this purchase was opened with the free-trial offer — the
  /// success screen then says what is charged after the trial, not today.
  /// Only the purchase this app launched can know; restores say false.
  final bool startedTrial;

  /// Which product — the logical SKU, not the raw store id.
  final String productId;

  /// Which shape of product.
  final IapProductType type;

  /// Outcome so far.
  ///
  /// ⚠ [IapPurchaseState.purchased] means **paid _and_ granted by our
  /// server**, not merely "the store took the money". The rail withholds the
  /// verdict until `POST /purchases/verify` answers, because a screen that
  /// celebrates on the store's word alone promises access the backend has not
  /// recorded.
  final IapPurchaseState state;

  /// Store error payload on [IapPurchaseState.failed].
  final Object? error;

  /// Why it failed, on [IapPurchaseState.failed]. Null reads as
  /// [IapFailure.store] (the rail's own store errors and the mock).
  final IapFailure? failure;

  /// iOS `originalTransactionId` / Android `orderId`.
  ///
  /// The server's idempotency key: the same receipt legitimately arrives more
  /// than once (network retry, app relaunch, restore), and this is what lets
  /// the server answer "already granted" instead of granting twice.
  final String? transactionId;

  /// iOS StoreKit2 `Transaction.jwsRepresentation` / Android `purchaseToken`.
  ///
  /// The part the **server** hands to Apple/Google. Without it the app's claim
  /// of "I paid" cannot be checked, which is exactly how store purchases get
  /// bypassed.
  final String? purchaseToken;

  /// Whether this carries enough to ask the server to verify.
  ///
  /// False on the mock rail, where no store transaction exists. Callers fall
  /// back to the legacy delivery path in that case rather than posting a
  /// receipt the server would (correctly) reject.
  bool get hasReceipt =>
      (transactionId?.isNotEmpty ?? false) &&
      (purchaseToken?.isNotEmpty ?? false);

  /// Whether the receipt came from a sandbox / test account. The server needs
  /// it to pick which store endpoint to verify against.
  final bool isSandbox;
}

/// The store billing seam every purchase UI talks to.
///
/// Screens depend on this interface only, so swapping the mock for the real
/// store SDK (once products are registered — v2 §7-4) touches one provider.
/// Server-side receipt validation is a server change and travels by proposal,
/// not by code here (R1, v2 §1-4).
abstract class IapService {
  /// Store metadata for [ids]. Unknown ids are silently absent, mirroring
  /// store SDK behaviour.
  Future<List<IapProduct>> getProducts(Set<String> ids);

  /// Starts the store purchase flow for [product]. The OS payment sheet takes
  /// over; the outcome arrives on [purchases]. No in-app checkout screen
  /// exists any more (v2 §2-3).
  Future<void> purchase(IapProduct product);

  /// Buys [product] **in place of** the Premium subscription the member
  /// already has — monthly ↔ yearly (QA F067 · F083).
  ///
  /// Unlike [purchase], this refuses to open a sheet it cannot make a
  /// replacement of: when the store cannot say which subscription is owned
  /// (query error, empty list), it throws instead of opening a second,
  /// parallel subscription. Never uses a free-trial offer.
  Future<void> purchaseSwitch(IapProduct product);

  /// Replays ownership — **subscriptions and non-consumables both** (v2
  /// completion criterion 11: characters restore too). Accepted receipts also
  /// arrive on [purchases] as [IapPurchaseState.restored]; the returned
  /// [RestoreOutcome] is what the result sheet is picked from.
  Future<RestoreOutcome> restore();

  /// Purchase outcomes, including restores.
  Stream<IapPurchase> get purchases;

  /// Whether this rail can say if the member may still take an introductory
  /// offer — the 7-day Max trial (대표 결정 2026-08-04).
  ///
  /// An introductory offer is **once per account per subscription group**, and
  /// only StoreKit / Play Billing knows whether this account already spent
  /// theirs. A rail that cannot answer must return `false`, and screens must
  /// then say nothing about a free trial: promising one to a member who
  /// already used it is an App Review 3.1.2 misstatement and an immediate
  /// charge they did not expect.
  ///
  /// This is deliberately a capability flag rather than a nullable answer —
  /// "I don't know" and "not eligible" lead to the same screen, and whoever
  /// wires a real SDK has to come here and say `true` on purpose.
  bool get reportsIntroEligibility;

  /// 이 계정이 스토어에서 **연간** Premium 을 가지고 있는가. `null` 은 모름(iOS · 레거시 `bt_max` ·
  /// 조회 실패) — 호출부가 다른 근거로 판단한다.
  ///
  /// 서버 구독 상태에는 결제 주기가 없다. 연간 회원에게 「Switch to yearly」 를 보이지 않으려면
  /// 스토어에 물어야 한다(QA F067 부수).
  Future<bool?> ownsAnnualPremium();

  /// Whether the device can transact at all — no store on this build, a
  /// signed-out account, or purchases restricted by parental controls.
  ///
  /// False is not an error: it means the paywall's buy button leads nowhere
  /// and should say so before taking a tap.
  Future<bool> isAvailable();

  /// Opens the store's offer-code redemption sheet, or returns false where the
  /// platform has none.
  ///
  /// This is the app-side half of every console-issued discount: codes can be
  /// generated at any time without review, but a member can only spend one if
  /// the app gives them somewhere to type it. Shipping the entry point in the
  /// binary is what keeps later discount campaigns off the review queue.
  Future<bool> presentOfferCodeRedemption();

  /// 윈백 오퍼(첫 달 50%)로 월간 Premium 결제창을 연다 — **안드로이드 전용**(PM-DEC-049).
  ///
  /// Play 는 이탈 구독자 할인을 스토어 구독 화면에서 자동으로 적용하지 않는다 — 스토어로 보내면
  /// 정가가 보인다. 그래서 앱이 오퍼 토큰([IapProductIds.playWinbackOfferId])을 붙여 결제창을
  /// 직접 연다. 결과는 [purchases] 에 월간 Premium([IapProductIds.maxMonthly])으로 온다.
  ///
  /// 못 열면(iOS · 스토어 조회 실패 · 오퍼 미등록·비활성) false — 호출부는 스토어 구독 화면으로
  /// 폴백한다. 대상 판정(이전 구독자)은 호출부 몫이다 — 앱은 만료된 회원에게만 이 길을 보인다.
  Future<bool> purchaseWinbackOffer();
}

/// 앱을 거쳐 여는 윈백 결제의 라우트 인자 — `PurchaseProcessingScreen` 이 이걸 받으면
/// [IapService.purchase] 대신 [IapService.purchaseWinbackOffer] 를 부른다.
class WinbackPurchase {
  /// The marker.
  const WinbackPurchase();
}

/// 월간↔연간 전환 결제의 라우트 인자 — `PurchaseProcessingScreen` 이 이걸 받으면
/// [IapService.purchase] 대신 [IapService.purchaseSwitch] 를 부른다(QA F083). 재시도 시트도
/// 이 표시를 이어 받는다 — 재시도가 새 구독 구매로 바뀌면 이중 청구 입구가 다시 열린다.
class SwitchPurchase {
  /// [annual] 은 바꿔 갈 주기.
  const SwitchPurchase({required this.annual});

  /// Whether the target is the yearly plan.
  final bool annual;
}

/// The stand-in rail until store products exist.
///
/// Deterministic and synchronous-ish so widget tests and the demo hub can
/// script it: [scriptedOutcome] decides what a purchase does, [owned] is what
/// a restore returns.
class MockIapService implements IapService {
  /// Creates a mock. [owned] is the set of products a restore replays.
  MockIapService({
    List<IapProduct>? catalog,
    List<IapPurchase> owned = const [],
    this.scriptedOutcome = IapPurchaseState.purchased,
  })  : _catalog = catalog ?? defaultCatalog,
        _owned = List.of(owned);

  /// The demo catalog. Prices are whatever [PlanPrices] currently answers —
  /// the store's own values when a real rail has adopted them, list prices
  /// otherwise. **Not `const`**: prices are resolved at read time now, which
  /// is the whole point of the store being the authority.
  static final defaultCatalog = [
    IapProduct(
        id: IapProductIds.proMonthly,
        type: IapProductType.subscription,
        localizedPrice: PlanPrices.proMonthly),
    IapProduct(
        id: IapProductIds.proYearly,
        type: IapProductType.subscription,
        localizedPrice: PlanPrices.proYearly),
    IapProduct(
        id: IapProductIds.maxMonthly,
        type: IapProductType.subscription,
        localizedPrice: PlanPrices.maxMonthly),
    IapProduct(
        id: IapProductIds.maxYearly,
        type: IapProductType.subscription,
        localizedPrice: PlanPrices.maxYearly),
  ];

  final List<IapProduct> _catalog;
  final List<IapPurchase> _owned;

  /// The mock has no store behind it, so it cannot know. False keeps the
  /// trial line off every screen until a real rail lands.
  @override
  bool get reportsIntroEligibility => false;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> presentOfferCodeRedemption() async => false;

  /// 가짜 레일엔 스토어 오퍼가 없다 — 호출부가 스토어 화면으로 폴백한다.
  @override
  Future<bool> purchaseWinbackOffer() async => false;

  /// 가짜 레일은 결제 주기를 모른다.
  @override
  Future<bool?> ownsAnnualPremium() async => null;

  /// 가짜 레일엔 교체가 없다 — 같은 구매로 흉내 낸다.
  @override
  Future<void> purchaseSwitch(IapProduct product) => purchase(product);

  /// What the next [purchase] resolves to.
  IapPurchaseState scriptedOutcome;

  final _controller = StreamController<IapPurchase>.broadcast();

  @override
  Stream<IapPurchase> get purchases => _controller.stream;

  @override
  Future<List<IapProduct>> getProducts(Set<String> ids) async =>
      _catalog.where((p) => ids.contains(p.id)).toList();

  @override
  Future<void> purchase(IapProduct product) async {
    _controller.add(IapPurchase(
      productId: product.id,
      type: product.type,
      state: IapPurchaseState.pending,
    ));
    _controller.add(IapPurchase(
      productId: product.id,
      type: product.type,
      state: scriptedOutcome,
    ));
    if (scriptedOutcome == IapPurchaseState.purchased) {
      _owned.add(IapPurchase(
        productId: product.id,
        type: product.type,
        state: IapPurchaseState.restored,
      ));
    }
  }

  @override
  Future<RestoreOutcome> restore() async {
    // Everything ever owned comes back — subscriptions AND characters.
    for (final p in _owned) {
      _controller.add(p);
    }
    return _owned.isEmpty ? RestoreOutcome.nothing : RestoreOutcome.restored;
  }

  /// Closes the stream (tests).
  Future<void> dispose() => _controller.close();
}
