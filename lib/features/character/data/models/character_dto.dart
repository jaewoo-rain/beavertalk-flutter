import '../../domain/entities/character.dart';

/// Parses a server Decimal string (e.g. `"4900.00"`) into integer KRW.
///
/// Tolerates int/double inputs too; returns 0 for null/garbage.
int parseKrw(Object? value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.round();
  final parsed = double.tryParse(value.toString());
  return parsed?.round() ?? 0;
}

/// Wire model for `CharacterSummary` / `CharacterDetail`. Stays in the data
/// layer; prices arrive as Decimal strings and are parsed to integer KRW.
class CharacterDto {
  const CharacterDto({
    required this.characterId,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.effectivePrice,
    required this.isOwned,
    this.description,
    this.voiceUrl,
    this.tags = const [],
  });

  final int characterId;
  final String name;
  final String? imageUrl;
  final int price;
  final int effectivePrice;
  final bool isOwned;
  final String? description;
  final String? voiceUrl;
  final List<String> tags;

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    return CharacterDto(
      characterId: json['character_id'] as int,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      price: parseKrw(json['price']),
      effectivePrice: parseKrw(json['effective_price']),
      isOwned: json['is_owned'] as bool? ?? false,
      description: json['description'] as String?,
      voiceUrl: json['voice_url'] as String?,
      // Server types this `list[str] = []` and always passes `c.tags or []`,
      // so it is never null — but tolerate it anyway.
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  /// Converts to the domain entity.
  Character toEntity() => Character(
        id: characterId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        effectivePrice: effectivePrice,
        isOwned: isOwned,
        description: description,
        voiceUrl: voiceUrl,
        tags: tags,
      );
}

/// Wire model for `PurchaseResponse` — `{member_character, payment}`.
///
/// Its nested `payment` is `PaymentOut`, a **different shape** from the
/// `PaymentItem` the history list returns (no `card_info`, no `category`), so
/// it is parsed here rather than reusing the payment feature's DTO.
class PurchaseResponseDto {
  const PurchaseResponseDto({
    required this.characterId,
    this.purchasePrice,
    this.purchaseDate,
    required this.paymentId,
    this.paidPrice,
    this.paymentDate,
    this.paymentDescription,
  });

  final int characterId;
  final Object? purchasePrice;
  final String? purchaseDate;
  final int paymentId;
  final Object? paidPrice;
  final String? paymentDate;
  final String? paymentDescription;

  factory PurchaseResponseDto.fromJson(Map<String, dynamic> json) {
    final mc = (json['member_character'] as Map<String, dynamic>?) ?? const {};
    final pay = (json['payment'] as Map<String, dynamic>?) ?? const {};
    return PurchaseResponseDto(
      characterId: (mc['character_id'] as num).toInt(),
      purchasePrice: mc['purchase_price'],
      purchaseDate: mc['purchase_date'] as String?,
      paymentId: (pay['payment_id'] as num).toInt(),
      paidPrice: pay['price'],
      paymentDate: pay['payment_date'] as String?,
      paymentDescription: pay['description'] as String?,
    );
  }

  PurchaseResult toEntity() => PurchaseResult(
        characterId: characterId,
        purchasePrice: purchasePrice == null ? null : parseKrw(purchasePrice),
        purchaseDate: purchaseDate == null
            ? null
            : DateTime.tryParse(purchaseDate!)?.toLocal(),
        paymentId: paymentId,
        paidPrice: paidPrice == null ? null : parseKrw(paidPrice),
        paymentDate: paymentDate == null
            ? null
            : DateTime.tryParse(paymentDate!)?.toLocal(),
        paymentDescription: paymentDescription,
      );
}

/// Wire model for `OwnedCharacterOut`. Stays in the data layer.
class OwnedCharacterDto {
  const OwnedCharacterDto({
    required this.characterId,
    required this.name,
    this.imageUrl,
    this.description,
    this.voiceUrl,
    this.tags = const [],
    this.purchasePrice,
    this.purchaseDate,
  });

  final int characterId;
  final String name;
  final String? imageUrl;
  final String? description;
  final String? voiceUrl;
  final List<String> tags;
  final int? purchasePrice;
  final String? purchaseDate;

  factory OwnedCharacterDto.fromJson(Map<String, dynamic> json) {
    return OwnedCharacterDto(
      characterId: json['character_id'] as int,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      voiceUrl: json['voice_url'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      purchasePrice:
          json['purchase_price'] == null ? null : parseKrw(json['purchase_price']),
      purchaseDate: json['purchase_date'] as String?,
    );
  }

  /// Converts to the domain entity.
  OwnedCharacter toEntity() => OwnedCharacter(
        id: characterId,
        name: name,
        imageUrl: imageUrl,
        description: description,
        voiceUrl: voiceUrl,
        tags: tags,
        purchasePrice: purchasePrice,
        purchaseDate:
            purchaseDate == null ? null : DateTime.tryParse(purchaseDate!),
      );
}
