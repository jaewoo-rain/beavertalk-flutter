/// The single payment rail — work order v2 §4-1.
///
/// v1 shipped a `BillingRail` abstraction with a store lane and an in-house PG
/// lane. v2 killed it: selling app-consumed digital goods outside IAP is a
/// review rejection (App Store 3.1.1, Play billing policy), so **characters
/// are non-consumable IAP** and there is exactly one rail. With one rail, a
/// rail abstraction is dead weight — what remains is the *product type*.
library;

import 'dart:async';

/// The two product shapes the store sells for us.
enum IapProductType {
  /// Auto-renewing subscription (Pro / Max, monthly / yearly).
  subscription,

  /// One-time, owned forever — a character. Never expires, survives
  /// subscription lapse, and **must** be returned by [IapService.restore]
  /// (v2 completion criterion 11).
  nonConsumable,
}

/// Provisional product ids — **the id scheme is an open decision** (v2 §7-4,
/// owner: 대표). One place to change when the real catalog is registered.
abstract final class IapProductIds {
  static const proMonthly = 'bt_pro_monthly';
  static const proYearly = 'bt_pro_yearly';
  static const maxMonthly = 'bt_max_monthly';
  static const maxYearly = 'bt_max_yearly';

  /// Character products carry the character's **immutable slug** as a suffix
  /// (`character.product_key` on the server), never the database id.
  ///
  /// A store product id can never be changed once registered. `character_id`
  /// differs between dev and prod (prod 2·9·10·11 / dev 2·3·4·5), so a receipt
  /// bought in one environment would resolve to a different character in the
  /// other; the display name is a marketing asset and may be rewritten. The
  /// slug is decoupled from both.
  static String character(String productKey) => 'bt_character_$productKey';

  static const subscriptions = {proMonthly, proYearly, maxMonthly, maxYearly};
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

  /// The store's localized display price (`$12.90`). **Always displayed
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
    this.transactionId,
    this.purchaseToken,
  });

  /// Which product.
  final String productId;

  /// Which shape of product.
  final IapProductType type;

  /// Outcome so far.
  final IapPurchaseState state;

  /// Store error payload on [IapPurchaseState.failed].
  final Object? error;

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
        localizedPrice: r'$12.90'),
    IapProduct(
        id: IapProductIds.proYearly,
        type: IapProductType.subscription,
        localizedPrice: r'$100.00'),
    IapProduct(
        id: IapProductIds.maxMonthly,
        type: IapProductType.subscription,
        localizedPrice: r'$19.90'),
    IapProduct(
        id: IapProductIds.maxYearly,
        type: IapProductType.subscription,
        localizedPrice: r'$159.00'),
  ];

  final List<IapProduct> _catalog;
  final List<IapPurchase> _owned;

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
