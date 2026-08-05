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
    );
  }

  static const _states = {
    'free': SubscriptionState.free,
    'trial': SubscriptionState.trial,
    'active_pro': SubscriptionState.activePro,
    'active_max': SubscriptionState.activeMax,
    'grace': SubscriptionState.grace,
    'on_hold': SubscriptionState.onHold,
    'ending': SubscriptionState.ending,
    'expired': SubscriptionState.expired,
  };

  /// The domain status, or **null when [state] is not one of the eight names**.
  ///
  /// Null tells the caller to fall back to row-list inference. Swallowing an
  /// unknown state as `free` would silently strip a paying member of access the
  /// day the server adds a ninth state; refusing to parse keeps that mistake
  /// impossible.
  SubscriptionStatus? toStatus() {
    final parsed = _states[state];
    if (parsed == null) return null;

    final tier = switch (plan) {
      'max' => SubscriptionTier.max,
      'pro' => SubscriptionTier.pro,
      // No plan on the wire: fall back to what the state alone implies, and to
      // Pro for the states that retain an unknown paid plan.
      _ => parsed.impliedTier ?? SubscriptionTier.pro,
    };

    DateTime? date(String? s) =>
        s == null ? null : DateTime.tryParse(s)?.toLocal();

    final end = date(endDate);
    final id = subscribeId;

    return SubscriptionStatus(
      state: parsed,
      tier: tier,
      expiresAt: end,
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
