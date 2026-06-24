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
  });

  final int characterId;
  final String name;
  final String? imageUrl;
  final int price;
  final int effectivePrice;
  final bool isOwned;
  final String? description;

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    return CharacterDto(
      characterId: json['character_id'] as int,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      price: parseKrw(json['price']),
      effectivePrice: parseKrw(json['effective_price']),
      isOwned: json['is_owned'] as bool? ?? false,
      description: json['description'] as String?,
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
      );
}

/// Wire model for `OwnedCharacterOut`. Stays in the data layer.
class OwnedCharacterDto {
  const OwnedCharacterDto({
    required this.characterId,
    required this.name,
    this.imageUrl,
    this.purchasePrice,
    this.purchaseDate,
  });

  final int characterId;
  final String name;
  final String? imageUrl;
  final int? purchasePrice;
  final String? purchaseDate;

  factory OwnedCharacterDto.fromJson(Map<String, dynamic> json) {
    return OwnedCharacterDto(
      characterId: json['character_id'] as int,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
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
        purchasePrice: purchasePrice,
        purchaseDate:
            purchaseDate == null ? null : DateTime.tryParse(purchaseDate!),
      );
}
