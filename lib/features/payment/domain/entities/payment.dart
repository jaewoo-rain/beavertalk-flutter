/// What a charge was for. Mirrors the server's `PaymentCategory`
/// (`Literal["subscribe", "character"]`).
enum PaymentCategory {
  /// A subscription charge (e.g. "프리미엄 구독(월간)").
  subscribe,

  /// A one-off character purchase.
  character,

  /// The server sent a category this client doesn't know (or null). Rendered
  /// like any other row — never dropped, so a new server category can't make
  /// charges silently vanish from the user's history.
  unknown;

  /// Parses the wire value; unrecognised/absent → [unknown].
  static PaymentCategory fromWire(String? value) => switch (value) {
        'subscribe' => PaymentCategory.subscribe,
        'character' => PaymentCategory.character,
        _ => PaymentCategory.unknown,
      };
}

/// Which tab the payment list is filtered to. Maps to the `type` query param
/// (`all` | `subscribe` | `character`).
enum PaymentFilter {
  all,
  subscribe,
  character;

  /// The `type=` value the server expects.
  String get wire => name;
}

/// One row of the payment history.
class Payment {
  const Payment({
    required this.id,
    this.date,
    this.description,
    this.cardInfo,
    required this.price,
    required this.category,
  });

  /// Server primary key (`payment_id`).
  final int id;

  /// When the charge happened (`payment_date`). Nullable on the wire; rows
  /// without one can't be month-grouped, so the screen buckets them separately.
  final DateTime? date;

  /// Human label, e.g. "프리미엄 구독(월간)". Server-authored, not localized.
  final String? description;

  /// Masked payment method, e.g. "신한카드 1234".
  final String? cardInfo;

  /// Amount in USD cents (server sends a Decimal; parsed via
  /// `parseMoneyMinor`). Absent on the wire → 0.
  final int price;

  final PaymentCategory category;
}

/// One page of payment history plus the month-to-date total.
class PaymentPage {
  const PaymentPage({
    required this.monthTotal,
    required this.items,
    required this.page,
    required this.size,
    required this.hasMore,
  });

  /// Total charged this calendar month.
  ///
  /// NOTE: the server computes this from `datetime.now(timezone.utc)` month
  /// start (`payment_service.py`), i.e. **UTC**, not KST. Around the month
  /// boundary it can disagree with what a Korean user considers "this month".
  final int monthTotal;

  final List<Payment> items;

  /// 1-based page index this result is for.
  final int page;

  /// Page size the server used.
  final int size;

  /// Whether another page exists after this one.
  final bool hasMore;
}
