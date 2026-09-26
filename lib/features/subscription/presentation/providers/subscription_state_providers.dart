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

/// 티어를 **아직 모르는가** — 두 소스가 다 답하기 전인 구간.
///
/// [subscriptionStatusProvider] 는 이 구간을 [SubscriptionStatus.none] 으로
/// 뭉갠다. 그건 「모르면 제한 쪽」이라는 옳은 기본값이지만, **표현을 고르는
/// 자리에서는 거짓말이 된다** — 통화 화면이 Max 사용자에게 Free 의 원형 아바타를
/// 띄웠다가 응답이 오면 16:9 영상 밴드로 뒤바꿨다(2026-09-12 실기기 확인).
///
/// 그래서 **판정용이 아니라 표현용**이다. 무엇을 허용할지는 여전히
/// [subscriptionStatusProvider] 가 정한다 — 여기를 보고 기능을 열지 마라.
/// 「지금 그려도 되는가」만 묻는 자리다.
///
/// 두 소스 중 **하나라도** 답하면(성공이든 실패든) false 다. 둘 다 에러여도
/// 답은 답이므로 영영 로딩으로 남는 경로는 없다.
///
/// ⛔ **`isLoading` 으로 재지 마라 — 「모른다」와 「다시 물어보는 중」이 섞인다.**
///   결제가 끝나면 `serverSubscriptionStatusProvider` 를 invalidate 하는데
///   (`purchase_flow` · `subscription_overlays`), 그때 Riverpod 은 **이전 값을 들고
///   있는 채로** `isLoading` 을 다시 올린다. `isLoading` 을 보면 그 순간을 「모름」
///   으로 읽어, **통화 중 Max 를 결제한 사람의 아바타가 셔머로 사라졌다가** 돌아온다.
///   답을 한 번이라도 받았는지(`hasValue || hasError`)가 우리가 묻고 싶은 것이다.
final subscriptionTierUnknownProvider = Provider.autoDispose<bool>((ref) {
  final server = ref.watch(serverSubscriptionStatusProvider);
  final rows = ref.watch(subscriptionsProvider);
  bool answered(AsyncValue<Object?> v) => v.hasValue || v.hasError;
  return !answered(server) && !answered(rows);
});

/// 구독 상태를 **그려도 되는가** — 구독 관리·설정 Current Plan 이 읽는다(QA F014).
enum SubscriptionStatusAvailability {
  /// 서버 판정이나 행 목록 중 하나가 답했다(또는 이번 세션에 결제했다).
  known,

  /// 둘 다 아직 답하지 않았다.
  loading,

  /// 둘 다 실패했다(서버가 null 로 답하고 행 목록이 실패한 경우 포함).
  failed,
}

/// [subscriptionStatusProvider] 가 지금 **추측 없이** 답할 수 있는가.
///
/// [subscriptionStatusProvider] 는 모르는 동안을 [SubscriptionStatus.none](Free)으로
/// 뭉갠다 — 권한 판정에는 옳은 기본값이지만, 구독 관리 화면에서는 오프라인인 Premium
/// 회원에게 Free 카드와 업그레이드 배너를 보여 준다(QA F014). 그 화면은 이걸 먼저 보고
/// 로딩이면 자리표시, 실패면 다시 시도를 그린다.
///
/// [subscriptionTierUnknownProvider] 와 같은 이유로 `isLoading` 을 보지 않는다 —
/// 결제 뒤 invalidate 로 다시 묻는 동안에도 이전 값이 있으면 [known] 이다.
///
/// ⛔ 판정용이 아니다. 무엇을 허용할지는 여전히 [subscriptionStatusProvider] 가 정한다.
final subscriptionStatusAvailabilityProvider =
    Provider.autoDispose<SubscriptionStatusAvailability>((ref) {
  if (ref.watch(sessionEntitlementProvider) != null) {
    return SubscriptionStatusAvailability.known;
  }
  final server = ref.watch(serverSubscriptionStatusProvider);
  if (server.valueOrNull != null) return SubscriptionStatusAvailability.known;
  final rows = ref.watch(subscriptionsProvider);
  if (rows.hasValue) return SubscriptionStatusAvailability.known;
  // 서버가 답을 끝냈고(null = 구서버·모르는 상태 · 또는 실패) 행 목록도 실패했다.
  final serverDone = server.hasValue || server.hasError;
  return serverDone && rows.hasError
      ? SubscriptionStatusAvailability.failed
      : SubscriptionStatusAvailability.loading;
});

/// 구독 상태 두 소스를 다시 묻는다 — [SubscriptionStatusAvailability.failed] 의 다시 시도.
void retrySubscriptionStatus(WidgetRef ref) {
  ref.invalidate(serverSubscriptionStatusProvider);
  ref.invalidate(subscriptionsProvider);
}

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
