/// A subscription record. Pure Dart — prices are whole currency units.
class Subscription {
  const Subscription({
    required this.id,
    this.startDate,
    this.endDate,
    this.price,
    this.isActivate,
  });

  /// Server primary key (`subscribe_id`).
  final int id;

  final DateTime? startDate;

  /// When Pro access lapses. Nullable — the server stores whatever the caller
  /// passed and never computes one, so an open-ended subscription has none.
  final DateTime? endDate;

  /// Charged amount, when recorded.
  final int? price;

  /// Server's active flag — **tri-state**: `true` / `false` / `null`.
  ///
  /// Only `POST /subscriptions` (→ true) and `.../cancel` (→ false) ever write
  /// it. Nothing on the server expires a subscription, so a row whose [endDate]
  /// passed long ago still reports `true`. Use [isCurrentlyActive], not this.
  final bool? isActivate;

  /// Whether this subscription is active *right now*.
  ///
  /// The server has no "current subscription" endpoint and never checks
  /// [endDate] against the clock, so expiry is enforced here:
  /// - flag not explicitly `true` (false **or null**) → inactive
  /// - no [endDate] → open-ended, active
  /// - otherwise active only until [endDate]
  bool get isCurrentlyActive {
    if (isActivate != true) return false;
    final end = endDate;
    if (end == null) return true;
    return end.isAfter(DateTime.now());
  }
}
