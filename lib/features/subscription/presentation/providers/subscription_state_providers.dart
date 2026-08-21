import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_state.dart';
import '../../domain/iap_service.dart';
import '../../domain/subscription_status_resolver.dart';
import 'subscription_providers.dart';

/// The resolver, injectable so tests can pin the clock.
final subscriptionStatusResolverProvider =
    Provider<SubscriptionStatusResolver>((ref) {
  return const SubscriptionStatusResolver();
});

/// The single billing seam — work order v2 §4-1.
///
/// v1's `BillingRail` (store lane / in-house lane) is gone: one rail, two
/// product types. [MockIapService] until store products are registered
/// (v2 §7-4); the real SDK implementation replaces this one provider and
/// nothing above it moves.
final iapServiceProvider = Provider<IapService>((ref) {
  return MockIapService();
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
  if (server != null) return applySessionEntitlement(server, bought);

  // Fallback: infer from the row list, exactly as before the endpoint existed.
  final subscriptions = ref.watch(subscriptionsProvider).valueOrNull;
  if (subscriptions == null) {
    return applySessionEntitlement(SubscriptionStatus.none, bought);
  }
  return applySessionEntitlement(
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
/// ⛔ **서버 상태를 직접 fetch 해서 판정하는 쪽은 반드시 이걸 통과시켜라.**
///   [MockIapService] 는 서버에 닿지 않아서, 방금 결제한 사람에게도 서버는 계속
///   `free` 라고 답한다. 이 보정을 건너뛰면 **결제한 사람이 무료로 판정된다** —
///   `NormalCallController._resolvePaidAccess` 가 정확히 그래서 결제 직후 통화를
///   끊었다. 그래서 private 이 아니라 공개다: 보정 규칙이 두 벌이 되면 안 된다.
///
/// The server keeps authority over *billing trouble* (grace / hold / ending):
/// those states are kept and only the tier — which the server cannot know —
/// is corrected. States that merely lack the purchase (free / expired, and the
/// inferred-Pro actives) are promoted to the bought plan's active state.
SubscriptionStatus applySessionEntitlement(
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
