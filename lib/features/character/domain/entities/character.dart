/// A purchasable call-partner character (catalog view). Pure Dart — no
/// Flutter/dio/JSON knowledge. Prices are **USD cents** (see
/// `core/format/money.dart`) — `$10.00` is 1000, never 10.
class Character {
  const Character({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.effectivePrice,
    required this.isOwned,
    this.productKey,
    this.description,
    this.backgroundStory,
    this.voiceUrl,
    this.tags = const [],
    this.discountEndsAt,
  });

  /// Server primary key (`character_id`).
  final int id;

  /// Display name.
  final String name;

  /// Optional avatar URL; UI falls back to a static asset when null.
  final String? imageUrl;

  /// List price in USD cents (0 means free).
  final int price;

  /// Currently effective price in USD cents (below [price] when discounted).
  final int effectivePrice;

  /// Whether the current member already owns this character.
  final bool isOwned;

  /// The server's stable slug for this character (`product_key`).
  ///
  /// The store product id is built from this, never from [id]: store ids can
  /// never be edited or reused once registered, while a database primary key
  /// is free to change under a migration. It also means a character added
  /// server-side after this build shipped is still buyable — the app no longer
  /// has to carry a hand-written id table to know its slug.
  ///
  /// Null against a server that predates the field; the caller falls back to
  /// the built-in table.
  final String? productKey;

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
