/// 캐릭터가 **왜** 열려 있는가 (`unlock_source`).
///
/// 소유와 접근은 다른 축이다: [owned] 는 영구 구매(해지해도 남는다), [subscription]
/// 은 구독이 여는 것(해지하면 닫힌다). 서버는 둘 다 해당할 때 [owned] 로 답한다 —
/// 순서를 뒤집으면 이미 산 캐릭터까지 "해지하면 사라짐"으로 표시된다.
///
/// 잠긴 상태는 값이 아니라 `null` 이다 (`Character.unlockSource`).
enum CharacterUnlockSource {
  /// 영구 구매로 열림.
  owned,

  /// 구독(Max)으로 열림 — 구독이 끝나면 닫힌다.
  subscription,
}

/// A purchasable call-partner character (catalog view). Pure Dart — no
/// Flutter/dio/JSON knowledge. Prices are **USD cents** (see
/// `core/format/money.dart`) — `$10.00` is 1000, never 10.
class Character {
  const Character({
    required this.id,
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

  /// Server primary key (`character_id`).
  ///
  /// **Never build a store product id from this.** It differs between dev and
  /// prod (prod 2·9·10·11 / dev 2·3·4·5), so a receipt bought in one
  /// environment would resolve to a different character in the other. Use
  /// [productKey].
  final int id;

  /// Immutable slug behind the store product id (`bt_character_{productKey}`).
  ///
  /// A store product id can never be changed once registered, so it cannot
  /// hang off anything mutable. [name] is a marketing asset and may be
  /// rewritten; [id] is environment-specific. This field exists precisely so
  /// neither of those leaks into a permanent identifier.
  final String productKey;

  /// Display name.
  final String name;

  /// Optional avatar URL; UI falls back to a static asset when null.
  final String? imageUrl;

  /// List price in USD cents (0 means free).
  final int price;

  /// Currently effective price in USD cents (below [price] when discounted).
  final int effectivePrice;

  /// Whether the current member already owns this character.
  ///
  /// **영구 구매 여부만** 뜻한다. 지금 쓸 수 있는지는 [isUnlocked] 다 — 구독으로 열린
  /// 캐릭터는 여기가 `false` 인 채로 사용 가능하다. 둘을 합치면 "샀다"고 오해시킨 뒤
  /// 해지 때 뺏는 꼴이 되므로 서버가 일부러 나눠서 보낸다.
  final bool isOwned;

  /// Whether the member can use this character **right now** (`is_unlocked`).
  ///
  /// 선택 가능 여부는 [isOwned] 가 아니라 이 값으로 판단한다. `is_unlocked` 를 안 보내는
  /// 구버전 서버(현 prod)에서는 [isOwned] 로 폴백되므로 종전 동작이 유지된다.
  final bool isUnlocked;

  /// 무엇이 열어줬나 (`unlock_source`). 잠긴 캐릭터는 `null`.
  final CharacterUnlockSource? unlockSource;

  /// Card description.
  ///
  /// Present on the **list** response too, not just the detail one — the server
  /// includes it on `CharacterSummary` specifically so a card can render its
  /// description and voice sample from one `GET /characters` (its schema
  /// docstring calls this out as avoiding an N+1 of per-card detail fetches).
  final String? description;

  /// Long-form background story (`background_story`).
  ///
  /// A **different column** from [description]: the server splits the one-line
  /// catch-phrase ([description]) from the story paragraph, and the detail
  /// screen has a slot for each. Keep them apart — rendering the catch-phrase
  /// in the story slot leaves the story unread, which is what happened while
  /// this field was missing from the DTO.
  final String? backgroundStory;

  /// Preview voice sample URL (`voice_url`), for the "샘플 목소리 듣기" card.
  final String? voiceUrl;

  /// Voice/personality tag chips (e.g. Warm / Calm / Soft). Server sends `[]`
  /// rather than null when a character has none.
  final List<String> tags;

  /// When the active discount ends (`active_discount.end_time`, local time), or
  /// null when nothing is on sale. Drives the limited-time countdown.
  ///
  /// The server puts `active_discount` on the **list** response as well, for the
  /// same N+1 reason as [description] — the avatar screen must not fetch detail
  /// per card just to know a deadline.
  final DateTime? discountEndsAt;

  /// 구독으로만 열린 상태 — **쓸 수는 있지만 산 것은 아니다.**
  ///
  /// 이 상태의 화면 규칙: 선택 가능 / "Owned" 배지 금지 / 구매 CTA 유지. 마지막 항목이
  /// 중요하다 — Max 회원도 해지 후를 대비해 영구 구매를 할 수 있어야 하고, 서버가 그
  /// 흐름을 막지 않는다.
  bool get isSubscriptionUnlocked => isUnlocked && !isOwned;

  /// True when a discount is active ([effectivePrice] below [price]).
  bool get hasDiscount => effectivePrice < price;

  /// Discount rate in whole percent (e.g. 50 for `$10 → $5`), or null when not
  /// discounted / free. Rounded — the server sends prices, not a rate.
  int? get discountPercent {
    if (!hasDiscount || price <= 0) return null;
    return ((price - effectivePrice) / price * 100).round();
  }

  /// Time left on the discount, or null when there is no deadline. Negative
  /// durations are clamped away by the caller (an expired sale should not show).
  Duration? remainingDiscount(DateTime now) => discountEndsAt?.difference(now);

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
    this.backgroundStory,
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

  /// Long-form background story — `OwnedCharacterOut` carries it too. See
  /// [Character.backgroundStory] for why it is separate from [description].
  final String? backgroundStory;

  /// Preview voice sample URL (`voice_url`).
  final String? voiceUrl;

  /// Voice/personality tag chips; `[]` when the character has none.
  final List<String> tags;

  /// Price paid in USD cents, when recorded.
  final int? purchasePrice;

  /// When the character was acquired, when recorded.
  final DateTime? purchaseDate;
}
