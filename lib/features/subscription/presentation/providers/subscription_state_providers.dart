import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/store_iap_service.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_state.dart';
import '../../domain/iap_service.dart';
import '../../domain/plan_prices.dart';
import '../../domain/subscription_status_resolver.dart';
import 'purchase_providers.dart';
import 'subscription_providers.dart';

/// The resolver, injectable so tests can pin the clock.
final subscriptionStatusResolverProvider =
    Provider<SubscriptionStatusResolver>((ref) {
  return const SubscriptionStatusResolver();
});

/// The single billing seam — work order v2 §4-1.
///
/// v1's `BillingRail` (store lane / in-house lane) is gone: one rail, two
/// product types. The store rail is the real one; the mock stands in wherever
/// no store exists — web, desktop, widget tests, the demo hub.
///
/// **Not autoDispose, and read early.** The store replays transactions that
/// finished while the app was dead (a purchase interrupted mid-sheet, a
/// renewal charged off-device) onto its stream shortly after launch. The rail
/// has to already be listening, and it must not be torn down between screens —
/// disposing it mid-flight would drop a paid receipt on the floor.
final iapServiceProvider = Provider<IapService>((ref) {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.android)) {
    return MockIapService();
  }
  final service = StoreIapService(server: ref.watch(purchaseRepositoryProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// Pulls the store catalog once and makes it the price of record.
///
/// Watch this from any screen that quotes a price. Two things happen:
/// the query is kicked off, and the subtree rebuilds when it lands — which is
/// how child widgets that read [PlanPrices] statically pick the store's
/// numbers up without each one needing a `ref`.
///
/// Failure is not an error state here. A store that will not answer (offline,
/// simulator, a build whose products are not approved yet) leaves the list
/// prices in place, which is exactly what the screen would have shown anyway.
final storePricesProvider = FutureProvider<List<IapProduct>>((ref) async {
  final iap = ref.watch(iapServiceProvider);
  if (!await iap.isAvailable()) return const [];
  final products = await iap.getProducts({
    ...IapProductIds.subscriptions,
    ...IapProductIds.soldCharacters,
  });
  final byId = {for (final p in products) p.id: p};
  StorePrice? at(String id) {
    final p = byId[id];
    return p == null
        ? null
        : StorePrice(
            display: p.localizedPrice,
            raw: p.rawPrice,
            currencyCode: p.currencyCode,
          );
  }

  final proMonthly = at(IapProductIds.proMonthly);
  final proYearly = at(IapProductIds.proYearly);
  final maxMonthly = at(IapProductIds.maxMonthly);
  final maxYearly = at(IapProductIds.maxYearly);
  if (proMonthly != null &&
      proYearly != null &&
      maxMonthly != null &&
      maxYearly != null) {
    final characters = products
        .where((p) => p.type == IapProductType.nonConsumable && p.rawPrice > 0)
        .toList()
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    PlanPrices.adopt(
      proMonthly: proMonthly,
      proYearly: proYearly,
      maxMonthly: maxMonthly,
      maxYearly: maxYearly,
      characterFrom:
          characters.isEmpty ? null : at(characters.first.id),
    );
  }
  return products;
});

/// **The** subscription status — what every subscription screen reads.
///
/// autoDispose because it is per-member: non-autoDispose user-scoped providers
/// are what leaked user A's state into user B's session (see
/// `AuthController._clearUserScopedState`), and the same trap applies here.
///
/// Five of the eight states cannot be produced from the current API. To render
/// them — the demo hub, widget tests, completion criterion 1 — override this
/// provider rather than teaching the resolver to guess:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     subscriptionStatusProvider.overrideWith(
///       (ref) => const SubscriptionStatus(
///         state: SubscriptionState.grace,
///         tier: SubscriptionTier.pro,
///       ),
///     ),
///   ],
///   child: const BeaverTalkApp(),
/// )
/// ```
/// The server's own answer (`GET /subscriptions/status`), or null while it
/// loads / when the server predates the endpoint / when its state string is
/// unknown. autoDispose: per-member data.
final serverSubscriptionStatusProvider =
    FutureProvider.autoDispose<SubscriptionStatus?>((ref) {
  return ref.watch(subscriptionRepositoryProvider).fetchStatus();
});

final subscriptionStatusProvider =
    Provider.autoDispose<SubscriptionStatus>((ref) {
  final bought = ref.watch(sessionEntitlementProvider);

  // The server's verdict wins when it exists — the state machine's authority
  // is server-side (work order §1-5), and it is the only source that can say
  // trial / grace / on_hold / active_max at all.
  final server = ref.watch(serverSubscriptionStatusProvider).valueOrNull;
  if (server != null) return _applySessionEntitlement(server, bought);

  // Fallback: infer from the row list, exactly as before the endpoint existed.
  final subscriptions = ref.watch(subscriptionsProvider).valueOrNull;
  if (subscriptions == null) {
    return _applySessionEntitlement(SubscriptionStatus.none, bought);
  }
  return _applySessionEntitlement(
    ref.watch(subscriptionStatusResolverProvider).resolve(subscriptions),
    bought,
  );
});

/// The subscription tier bought on the IAP rail **in this session**, recorded
/// off the purchase stream by the processing screen.
///
/// Why this exists: nothing else can say Max today. The row list has no plan
/// field (the resolver assumes Pro — [SubscriptionStatus.isPlanInferred]), and
/// the mock rail never reaches the server at all. Without this record, buying
/// Max still rendered "Pro" on every screen. The server's *explicit* plan
/// (`isPlanInferred == false`) always outranks it — the moment receipts are
/// validated server-side this record becomes a no-op.
///
/// Not autoDispose: it must outlive the purchase funnel's screens. User-scoped
/// — cleared in `AuthController._clearUserScopedState` on account switch.
final sessionEntitlementProvider =
    StateProvider<SubscriptionTier?>((ref) => null);

/// Lifts [base] to what the member actually [bought] this session.
///
/// The server keeps authority over *billing trouble* (grace / hold / ending):
/// those states are kept and only the tier — which the server cannot know —
/// is corrected. States that merely lack the purchase (free / expired, and the
/// inferred-Pro actives) are promoted to the bought plan's active state.
SubscriptionStatus _applySessionEntitlement(
    SubscriptionStatus base, SubscriptionTier? bought) {
  if (bought == null) return base;
  // An explicit server plan on a paid state is the stronger truth.
  if (!base.isPlanInferred && base.tier != SubscriptionTier.free) return base;
  final state = bought == SubscriptionTier.max
      ? SubscriptionState.activeMax
      : SubscriptionState.activePro;
  return switch (base.state) {
    SubscriptionState.free ||
    SubscriptionState.expired ||
    SubscriptionState.activePro ||
    SubscriptionState.activeMax =>
      base.copyWith(state: state, tier: bought, isPlanInferred: false),
    _ => base.copyWith(tier: bought, isPlanInferred: false),
  };
}

/// The subscription record to treat as current, or null when none is live.
///
/// Moved here from `subscription_providers.dart` so that the "is it active?"
/// question has one answer. Behaviour is unchanged: the resolver's `activePro`
/// branch tests exactly what this used to — flag explicitly `true`, and either
/// no end date or one still in the future.
///
/// Null on [SubscriptionState.ending] as before. A cancelled-but-paid-up
/// subscription still grants access, but it is not what callers of *this*
/// provider mean; they want the row that is being billed. Screens that care
/// about retained access read [subscriptionStatusProvider] instead.
final currentSubscriptionProvider = Provider.autoDispose<Subscription?>((ref) {
  final status = ref.watch(subscriptionStatusProvider);
  return switch (status.state) {
    // Every state whose row is still the one being billed — including grace
    // and hold, where the store is retrying that same row.
    SubscriptionState.activePro ||
    SubscriptionState.activeMax ||
    SubscriptionState.trial ||
    SubscriptionState.grace ||
    SubscriptionState.onHold =>
      status.source,
    _ => null,
  };
});
