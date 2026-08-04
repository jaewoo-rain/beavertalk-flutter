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
  /// passed long ago still reports `true`. **Read it through
  /// `SubscriptionStatusResolver`, never on its own.**
  final bool? isActivate;

  // There used to be an `isCurrentlyActive` getter here that compared [endDate]
  // against `DateTime.now()`. It moved into `SubscriptionStatusResolver`
  // (work order §4-1-2).
  //
  // Two reasons it could not stay. The redesign turns one boolean into eight
  // states, and "active" is only one edge of that machine — a
  // cancelled-but-paid-up row is inactive by this flag yet still grants access.
  // And a getter that reads the wall clock cannot be tested at a boundary
  // without waiting for it; the resolver takes an injectable clock instead.
}
