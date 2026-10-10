import '../../../../core/format/money.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_state.dart';
import '../../domain/subscription_status_resolver.dart';

/// Wire model for the proposed `GET /subscriptions/status` — the member-level
/// status endpoint of `docs/2026-08-03_1844_서버제안_구독상태_스키마확장.md` §2-1.
///
/// This is written **ahead of the server**: the endpoint does not exist yet.
/// The client calls it, treats 404 as "old server" and falls back to inferring
/// status from the row list. The moment the server ships it, the app switches
/// over with no client release.
class SubscriptionStatusDto {
  const SubscriptionStatusDto({
    required this.state,
    this.plan,
    this.subscribeId,
    this.price,
    this.startDate,
    this.endDate,
    this.retryingUntil,
    this.pausedSince,
    this.billingPeriod,
    this.productId,
    this.isTrial,
    this.trialEndsAt,
  });

  /// One of the eight snake_case state names, verbatim from the wire.
  final String state;

  /// `pro` | `max`, null on `free`/`expired`.
  final String? plan;

  final int? subscribeId;
  final Object? price;
  final String? startDate;
  final String? endDate;
  final String? retryingUntil;
  final String? pausedSince;

  /// §22-⑤⑦(서버 552b485) — `monthly` · `yearly`. 구서버·누락이면 null.
  final String? billingPeriod;
  final String? productId;

  /// 필드가 없으면(구서버) null — false 와 가른다(모름 ≠ 체험 아님).
  final bool? isTrial;
  final String? trialEndsAt;

  factory SubscriptionStatusDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusDto(
      state: json['state'] as String? ?? '',
      plan: json['plan'] as String?,
      subscribeId: (json['subscribe_id'] as num?)?.toInt(),
      price: json['price'],
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      retryingUntil: json['retrying_until'] as String?,
      pausedSince: json['paused_since'] as String?,
      billingPeriod: json['billing_period'] as String?,
      productId: json['product_id'] as String?,
      isTrial: json['is_trial'] as bool?,
      trialEndsAt: json['trial_ends_at'] as String?,
    );
  }

  static const _states = {
    'free': SubscriptionState.free,
    'trial': SubscriptionState.trial,
    'active_pro': SubscriptionState.activePro,
    'active_max': SubscriptionState.activeMax,
    // 서버 `premium` 브랜치(09-23)는 active_pro·active_max 를 이 하나로 합쳤다. 앱에서는
    // 09-22 단일 티어 이후 Max 가 곧 Premium 이라 같은 값에 대응시킨다. 옛 두 키는 구서버
    // 호환으로 남긴다 — 빼면 배포 순서에 따라 결제자가 행 목록 추론(=Pro)으로 떨어진다.
    'active_premium': SubscriptionState.activeMax,
    'grace': SubscriptionState.grace,
    'on_hold': SubscriptionState.onHold,
    'ending': SubscriptionState.ending,
    'expired': SubscriptionState.expired,
  };

  /// The domain status, or **null when [state] is not a known wire name**.
  ///
  /// Null tells the caller to fall back to row-list inference. Swallowing an
  /// unknown state as `free` would silently strip a paying member of access the
  /// day the server adds a ninth state; refusing to parse keeps that mistake
  /// impossible.
  SubscriptionStatus? toStatus() {
    final parsed = _states[state];
    if (parsed == null) return null;

    final tier = switch (plan) {
      'premium' || 'max' => SubscriptionTier.max,
      'pro' => SubscriptionTier.pro,
      // No plan on the wire: fall back to what the state alone implies, and to
      // Pro for the states that retain an unknown paid plan.
      _ => parsed.impliedTier ?? SubscriptionTier.pro,
    };

    DateTime? date(String? s) =>
        s == null ? null : DateTime.tryParse(s)?.toLocal();

    final end = date(endDate);
    final id = subscribeId;
    final trialEnds = date(trialEndsAt);
    // 스토어 체험(IAP 무료체험)은 서버가 `active_premium` + `is_trial` 로 준다. 앱에는 체험
    // 상태가 이미 있다(배지 · 「Free until」 · 체험 해지 시트) — 그 상태로 그린다(§22-⑦).
    // 해지 예약(ending)·결제 문제 등 다른 상태는 그대로 둔다.
    // ⛔ 체험 종료일이 지났으면 체험이 아니다 — 첫 결제로 넘어간 뒤에도 서버가 체험으로
    //   주면 「Free until · First payment」 가 남았다(09-28 실기기 · 서버 갱신 미반영).
    final trialOver = trialEnds != null && trialEnds.isBefore(DateTime.now());
    final shown = switch (parsed) {
      SubscriptionState.activeMax when isTrial == true && !trialOver =>
        SubscriptionState.trial,
      SubscriptionState.trial when trialOver => SubscriptionState.activeMax,
      _ => parsed,
    };

    return SubscriptionStatus(
      state: shown,
      annual: switch (billingPeriod) {
        'yearly' => true,
        'monthly' => false,
        _ => null,
      },
      isTrial: isTrial,
      trialEndsAt: trialEnds,
      tier: tier,
      // 체험 중이면 「Free until {date}」 가 체험 종료일이어야 한다.
      expiresAt: shown == SubscriptionState.trial ? (trialEnds ?? end) : end,
      retryingUntil: date(retryingUntil),
      pausedSince: date(pausedSince),
      // The backing row, reconstructed so `settings.dart` and the cancel path
      // keep working: they read `source.id` / `endDate` / `price`.
      source: id == null
          ? null
          : Subscription(
              id: id,
              startDate: date(startDate),
              endDate: end,
              price: price == null ? null : parseMoneyMinor(price!),
              isActivate: switch (parsed) {
                SubscriptionState.activePro ||
                SubscriptionState.activeMax ||
                SubscriptionState.trial ||
                SubscriptionState.grace ||
                SubscriptionState.onHold =>
                  true,
                SubscriptionState.ending => false,
                _ => null,
              },
            ),
      // The whole point of the endpoint: the plan is read, not assumed —
      // unless the server left `plan` out, in which case honesty stands.
      isPlanInferred: plan == null && parsed != SubscriptionState.free &&
          parsed != SubscriptionState.expired,
    );
  }
}
