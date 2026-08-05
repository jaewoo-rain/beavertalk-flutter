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

  /// Character product id, keyed by **slug** — never by the server's primary
  /// key. Store ids are permanent while database ids are not, and a bare
  /// integer tells nobody in the console or the payout report which character
  /// sold. Slugs match the asset folders under `assets/avatar/`.
  static String character(String slug) => 'bt_character_$slug';

  /// Server `character_id` → slug.
  ///
  /// A stopgap: the server has no stable `slug` field yet (design doc §4-5
  /// asks for one). The ids come from `character_copy_overrides.dart`, which
  /// carries the same server-key → character mapping.
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
    maxMonthly: (subscriptionId: 'bt_max', basePlanId: 'monthly'),
    maxYearly: (subscriptionId: 'bt_max', basePlanId: 'yearly'),
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
  });

  /// Store product id.
  final String id;

  /// Subscription or non-consumable.
  final IapProductType type;

  /// The store's localized display price (`$12.99`). **Always displayed
  /// verbatim** — v2 §6-4 forbids hardcoding character prices; the store is
  /// the price authority. Mock values stand in until the catalog exists.
  final String localizedPrice;

  /// Store display name, when provided.
  final String? title;
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

/// One purchase event.
class IapPurchase {
  /// Creates a purchase event.
  const IapPurchase({
    required this.productId,
    required this.type,
    required this.state,
    this.error,
  });

  /// Which product.
  final String productId;

  /// Which shape of product.
  final IapProductType type;

  /// Outcome so far.
  final IapPurchaseState state;

  /// Store error payload on [IapPurchaseState.failed].
  final Object? error;
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

  /// Replays ownership — **subscriptions and non-consumables both** (v2
  /// completion criterion 11: characters restore too). Results arrive on
  /// [purchases] as [IapPurchaseState.restored].
  Future<void> restore();

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
}

/// The stand-in rail until store products exist.
///
/// Deterministic and synchronous-ish so widget tests and the demo hub can
/// script it: [scriptedOutcome] decides what a purchase does, [owned] is what
/// a restore returns.
class MockIapService implements IapService {
  /// Creates a mock. [owned] is the set of products a restore replays.
  MockIapService({
    List<IapProduct> catalog = defaultCatalog,
    List<IapPurchase> owned = const [],
    this.scriptedOutcome = IapPurchaseState.purchased,
  })  : _catalog = catalog,
        _owned = List.of(owned);

  /// The demo catalog. Prices are mock stand-ins (design list prices) —
  /// replaced by store-localized values the moment the real SDK lands.
  static const defaultCatalog = [
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
  Future<void> restore() async {
    // Everything ever owned comes back — subscriptions AND characters.
    for (final p in _owned) {
      _controller.add(p);
    }
  }

  /// Closes the stream (tests).
  Future<void> dispose() => _controller.close();
}
