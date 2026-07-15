/// A purchasable call-partner character (catalog view). Pure Dart — no
/// Flutter/dio/JSON knowledge. Prices are integer KRW.
class Character {
  const Character({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.effectivePrice,
    required this.isOwned,
    this.description,
    this.voiceUrl,
    this.tags = const [],
  });

  /// Server primary key (`character_id`).
  final int id;

  /// Display name.
  final String name;

  /// Optional avatar URL; UI falls back to a static asset when null.
  final String? imageUrl;

  /// List price in KRW (0 means free).
  final int price;

  /// Currently effective price in KRW (lower than [price] when discounted).
  final int effectivePrice;

  /// Whether the current member already owns this character.
  final bool isOwned;

  /// Card description.
  ///
  /// Present on the **list** response too, not just the detail one — the server
  /// includes it on `CharacterSummary` specifically so a card can render its
  /// description and voice sample from one `GET /characters` (its schema
  /// docstring calls this out as avoiding an N+1 of per-card detail fetches).
  final String? description;

  /// Preview voice sample URL (`voice_url`), for the "샘플 목소리 듣기" card.
  final String? voiceUrl;

  /// Voice/personality tag chips (e.g. Warm / Calm / Soft). Server sends `[]`
  /// rather than null when a character has none.
  final List<String> tags;

  /// True when a discount is active ([effectivePrice] below [price]).
  bool get hasDiscount => effectivePrice < price;

  /// True when the character is free (list price 0).
  bool get isFree => price <= 0;
}

/// What `POST /characters/{id}/purchase` returns: the ownership row plus the
/// payment it created (both in one transaction server-side).
class PurchaseResult {
  const PurchaseResult({
    required this.characterId,
    this.purchasePrice,
    this.purchaseDate,
    required this.paymentId,
    this.paidPrice,
    this.paymentDate,
    this.paymentDescription,
  });

  final int characterId;
  final int? purchasePrice;
  final DateTime? purchaseDate;

  /// The payment row written alongside the purchase — it shows up in
  /// `GET /payments` immediately, so the history cache must be invalidated.
  final int paymentId;

  /// Amount actually charged. This is the **truth**, not the price the client
  /// displayed: the server recomputes it from the active discount window, which
  /// can close between listing and buying.
  final int? paidPrice;

  final DateTime? paymentDate;
  final String? paymentDescription;
}

/// A character the member already owns. Pure Dart.
class OwnedCharacter {
  const OwnedCharacter({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.voiceUrl,
    this.tags = const [],
    this.purchasePrice,
    this.purchaseDate,
  });

  /// Server primary key (`character_id`).
  final int id;

  /// Display name.
  final String name;

  /// Optional avatar URL; UI falls back to a static asset when null.
  final String? imageUrl;

  /// Card description — `OwnedCharacterOut` carries it, same as the catalog.
  final String? description;

  /// Preview voice sample URL (`voice_url`).
  final String? voiceUrl;

  /// Voice/personality tag chips; `[]` when the character has none.
  final List<String> tags;

  /// Price paid in KRW, when recorded.
  final int? purchasePrice;

  /// When the character was acquired, when recorded.
  final DateTime? purchaseDate;
}
