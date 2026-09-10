import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../domain/iap_service.dart';
import '../domain/repositories/purchase_repository.dart';

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
  })  : _server = server,
        _store = store ?? InAppPurchase.instance {
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
      _catalog[sku] =
          _StoreSku(details: details, offerToken: _offerTokenOf(details));
      found[sku] = IapProduct(
        id: sku,
        type: _typeOf(sku),
        localizedPrice: details.price,
        title: details.title,
        rawPrice: details.rawPrice,
        currencyCode: details.currencyCode,
      );
    }
    return found.values.toList();
  }

  @override
  Future<void> purchase(IapProduct product) async {
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
    _launched[sku.details.id] = product.id;
    // Subscriptions and characters both: `buyConsumable` is for goods that can
    // be bought again, and neither of ours can be. On Play this is also what
    // keeps a character un-consumed, which is how Play models "owned forever"
    // — it has no non-consumable product type of its own.
    await _store.buyNonConsumable(purchaseParam: _paramFor(sku));
  }

  @override
  Future<void> restore() async {
    _restoreBatch = <IapPurchase>[];
    try {
      await _store.restorePurchases();
      // The stream has no "that was all" signal, so give the platform a beat
      // to drain before closing the batch. Anything later still arrives — it
      // just takes the single-receipt path in [_deliver].
      await Future<void>.delayed(const Duration(milliseconds: 900));
    } finally {
      final batch = _restoreBatch ?? const <IapPurchase>[];
      _restoreBatch = null;
      if (batch.isNotEmpty) await _submitRestore(batch);
    }
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
          _out.add(_event(pd, IapPurchaseState.failed, error: pd.error));
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
      // Deliberately not finished: the receipt stays live and the store
      // re-delivers it next launch, which retries this verification for free.
      _out.add(_event(pd, IapPurchaseState.failed, error: e));
      return;
    }
    _finish(pd);
    _launched.remove(pd.productID);
    _out.add(purchase);
  }

  Future<void> _submitRestore(List<IapPurchase> batch) async {
    try {
      await _server.restore(batch);
    } catch (e) {
      for (final p in batch) {
        _awaitingFinish.remove(p.purchaseToken);
        _out.add(IapPurchase(
          productId: p.productId,
          type: p.type,
          state: IapPurchaseState.failed,
          error: e,
        ));
      }
      return;
    }
    for (final p in batch) {
      final pd = _awaitingFinish.remove(p.purchaseToken);
      if (pd != null) _finish(pd);
      _out.add(p);
    }
  }

  void _finish(PurchaseDetails pd) {
    if (pd.pendingCompletePurchase) unawaited(_store.completePurchase(pd));
  }

  IapPurchase _event(PurchaseDetails pd, IapPurchaseState state,
      {Object? error}) {
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
      // Play omits an order id on pending purchases; the token identifies the
      // transaction just as well and the server requires a non-empty value.
      transactionId:
          (pd.purchaseID?.isNotEmpty ?? false) ? pd.purchaseID! : token,
      purchaseToken: token,
      isSandbox: _isSandbox,
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

  String? _offerTokenOf(ProductDetails details) =>
      _offerOf(details)?.offerIdToken;

  SubscriptionOfferDetailsWrapper? _offerOf(ProductDetails details) {
    if (details is! GooglePlayProductDetails) return null;
    final index = details.subscriptionIndex;
    final offers = details.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) return null;
    return offers[index];
  }

  PurchaseParam _paramFor(_StoreSku sku) {
    if (sku.offerToken == null) {
      return PurchaseParam(productDetails: sku.details);
    }
    // Without the offer token Play falls back to the subscription's default
    // base plan — which is how an annual selection quietly billed monthly.
    return GooglePlayPurchaseParam(
      productDetails: sku.details,
      offerToken: sku.offerToken,
    );
  }
}

/// A store product plus what Play needs in order to charge the right base plan.
class _StoreSku {
  const _StoreSku({required this.details, this.offerToken});

  final ProductDetails details;
  final String? offerToken;
}
