import '../../../../core/format/money.dart';
import '../../domain/entities/character.dart';

/// Wire model for `CharacterSummary` / `CharacterDetail`. Stays in the data
/// layer; prices arrive as Decimal strings and are parsed to USD cents.
class CharacterDto {
  const CharacterDto({
    required this.characterId,
    required this.productKey,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.effectivePrice,
    required this.isOwned,
    required this.isUnlocked,
    this.unlockSource,
    this.description,
    this.backgroundStory,
    this.voiceUrl,
    this.tags = const [],
    this.discountEndsAt,
  });

  final int characterId;

  /// `product_key` — the immutable slug behind `bt_character_{key}`.
  ///
  /// Empty string on servers that predate the field; the purchase path checks
  /// for that rather than sending `bt_character_` to the store, which would be
  /// an unknown product.
  final String productKey;

  final String name;
  final String? imageUrl;
  final int price;
  final int effectivePrice;

  /// `is_owned` — 영구 구매 여부. 지금 쓸 수 있는지는 [isUnlocked] 다.
  final bool isOwned;

  /// `is_unlocked` — 지금 쓸 수 있는가. 이 키를 안 보내는 서버(현 prod)에서는
  /// [isOwned] 로 폴백한다.
  final bool isUnlocked;

  /// `unlock_source` — 무엇이 열어줬나. 잠겼거나 모르면 null.
  final CharacterUnlockSource? unlockSource;

  final String? description;
  final String? backgroundStory;
  final String? voiceUrl;
  final List<String> tags;

  /// When the active discount ends (`active_discount.end_time`), or null when
  /// nothing is on sale. Drives the limited-time countdown.
  final DateTime? discountEndsAt;

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    final owned = json['is_owned'] as bool? ?? false;
    // 소유(is_owned)와 접근(is_unlocked)은 **다른 축**이다. 서버는 Max 회원에게
    // member_character 행을 만들지 않는다 — 만들면 해지 후에도 영구 소유가 되어
    // 되돌릴 수 없기 때문. 그래서 "지금 쓸 수 있나"는 별도 필드로 온다.
    //
    // 키가 없으면 소유값으로 폴백한다: 이 필드를 모르는 구버전 서버(현 prod)에서는
    // 종전 동작(구매한 것만 열림)이 그대로 유지되고, 크래시하지 않는다.
    final unlocked = json['is_unlocked'] as bool? ?? owned;
    return CharacterDto(
      characterId: json['character_id'] as int,
      productKey: json['product_key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      price: parseMoneyMinor(json['price']),
      effectivePrice: parseMoneyMinor(json['effective_price']),
      isOwned: owned,
      isUnlocked: unlocked,
      unlockSource:
          _unlockSource(json['unlock_source'], owned: owned, unlocked: unlocked),
      description: json['description'] as String?,
      // `description` is a one-line catch-phrase; `background_story` is the
      // long-form story paragraph. They are separate server columns and the
      // detail screen has a separate slot for each — this key was previously
      // dropped, leaving the story slot empty and the catch-phrase rendered in
      // its place.
      backgroundStory: json['background_story'] as String?,
      voiceUrl: json['voice_url'] as String?,
      // Server types this `list[str] = []` and always passes `c.tags or []`,
      // so it is never null — but tolerate it anyway.
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      // 서버가 목록 응답(CharacterSummary)에도 active_discount 를 실어 준다 — 상세
      // 화면은 목록에서 눌러 들어가고 추가 조회를 하지 않으므로(N+1 회피), 카운트다운
      // 마감 시각이 여기 있어야 그릴 수 있다.
      discountEndsAt: _endsAt(json['active_discount']),
    );
  }

  /// `unlock_source` 문자열 → [CharacterUnlockSource]. 잠겼으면 null.
  ///
  /// 키가 없거나(구버전 서버) 모르는 값이면 아는 두 축에서 **파생**한다. 파생 규칙은
  /// 서버와 동일하게 **소유가 구독보다 우선**이다 — 뒤집으면 이미 산 캐릭터가 "해지하면
  /// 사라짐"으로 표시된다.
  static CharacterUnlockSource? _unlockSource(
    Object? raw, {
    required bool owned,
    required bool unlocked,
  }) {
    switch (raw) {
      case 'owned':
        return CharacterUnlockSource.owned;
      case 'subscription':
        return CharacterUnlockSource.subscription;
    }
    if (!unlocked) return null;
    return owned
        ? CharacterUnlockSource.owned
        : CharacterUnlockSource.subscription;
  }

  /// `active_discount.end_time` → 로컬 DateTime. 형태가 어긋나면 null(카운트다운 생략).
  static DateTime? _endsAt(Object? v) {
    if (v is! Map) return null;
    final raw = v['end_time'];
    if (raw is! String || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  /// Converts to the domain entity.
  Character toEntity() => Character(
        id: characterId,
        productKey: productKey,
        name: name,
        imageUrl: imageUrl,
        price: price,
        effectivePrice: effectivePrice,
        isOwned: isOwned,
        isUnlocked: isUnlocked,
        unlockSource: unlockSource,
        description: description,
        backgroundStory: backgroundStory,
        voiceUrl: voiceUrl,
        tags: tags,
        discountEndsAt: discountEndsAt,
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
        purchasePrice: purchasePrice == null ? null : parseMoneyMinor(purchasePrice),
        purchaseDate: purchaseDate == null
            ? null
            : DateTime.tryParse(purchaseDate!)?.toLocal(),
        paymentId: paymentId,
        paidPrice: paidPrice == null ? null : parseMoneyMinor(paidPrice),
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
    this.backgroundStory,
    this.voiceUrl,
    this.tags = const [],
    this.purchasePrice,
    this.purchaseDate,
  });

  final int characterId;
  final String name;
  final String? imageUrl;
  final String? description;
  final String? backgroundStory;
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
      // `OwnedCharacterOut` carries the story column too — same split as the
      // catalog response.
      backgroundStory: json['background_story'] as String?,
      voiceUrl: json['voice_url'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      purchasePrice:
          json['purchase_price'] == null ? null : parseMoneyMinor(json['purchase_price']),
      purchaseDate: json['purchase_date'] as String?,
    );
  }

  /// Converts to the domain entity.
  OwnedCharacter toEntity() => OwnedCharacter(
        id: characterId,
        name: name,
        imageUrl: imageUrl,
        description: description,
        backgroundStory: backgroundStory,
        voiceUrl: voiceUrl,
        tags: tags,
        purchasePrice: purchasePrice,
        purchaseDate:
            purchaseDate == null ? null : DateTime.tryParse(purchaseDate!),
      );
}
