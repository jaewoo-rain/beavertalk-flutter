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

  /// Optional long description (only from the detail endpoint).
  final String? description;

  /// True when a discount is active ([effectivePrice] below [price]).
  bool get hasDiscount => effectivePrice < price;

  /// True when the character is free (list price 0).
  bool get isFree => price <= 0;
}

/// A character the member already owns. Pure Dart.
class OwnedCharacter {
  const OwnedCharacter({
    required this.id,
    required this.name,
    this.imageUrl,
    this.purchasePrice,
    this.purchaseDate,
  });

  /// Server primary key (`character_id`).
  final int id;

  /// Display name.
  final String name;

  /// Optional avatar URL; UI falls back to a static asset when null.
  final String? imageUrl;

  /// Price paid in KRW, when recorded.
  final int? purchasePrice;

  /// When the character was acquired, when recorded.
  final DateTime? purchaseDate;
}
