/// Wire models for `/purchases/*` — the store-receipt half of the IAP rail.
///
/// The server is the single authority on what a member owns: it re-verifies
/// every receipt against Apple / Google directly, then answers with the
/// resulting entitlement. Nothing here decides anything; it only parses.
library;

/// `Entitlement` — what this member owns **right now**.
class EntitlementDto {
  const EntitlementDto({
    required this.isPro,
    this.proExpiresAt,
    this.ownedCharacterIds = const [],
  });

  /// The single truth for "is this member paid".
  ///
  /// ⚠ Do **not** re-derive this by comparing [proExpiresAt] to the device
  /// clock — the server says so explicitly. A tampered or merely wrong clock
  /// would hand out or revoke access on its own.
  final bool isPro;

  /// When the paid period ends. **Display only.**
  final DateTime? proExpiresAt;

  /// Server character ids the member owns for good.
  final List<int> ownedCharacterIds;

  factory EntitlementDto.fromJson(Map<String, dynamic> json) {
    return EntitlementDto(
      isPro: json['is_pro'] as bool? ?? false,
      proExpiresAt: _date(json['pro_expires_at']),
      ownedCharacterIds: (json['owned_character_ids'] as List<dynamic>?)
              ?.whereType<num>()
              .map((e) => e.toInt())
              .toList() ??
          const [],
    );
  }

  static DateTime? _date(Object? v) =>
      v is String && v.isNotEmpty ? DateTime.tryParse(v)?.toLocal() : null;
}

/// What kind of thing a receipt bought.
enum PurchaseKind {
  /// A character — one-time, owned forever.
  character,

  /// Pro or Max.
  subscription,

  /// The server named a kind this build does not know. Treated as delivered
  /// (the server already granted it) but not acted on locally.
  unknown,
}

/// `VerifyResponse` — a single receipt, accepted.
class VerifyResultDto {
  const VerifyResultDto({
    required this.productId,
    required this.kind,
    required this.entitlement,
    this.alreadyGranted = false,
    this.characterId,
  });

  /// The product the server recognised.
  final String productId;

  /// Character or subscription.
  final PurchaseKind kind;

  /// Whether this receipt had already been redeemed.
  ///
  /// **A success, not an error.** Retries, app relaunches and restores all
  /// resend the same receipt by design; the server is idempotent and says so
  /// here. Treating it as a failure is how a paid member gets told their
  /// purchase failed.
  final bool alreadyGranted;

  /// Which character, when [kind] is [PurchaseKind.character].
  final int? characterId;

  /// The member's entitlement after this grant.
  final EntitlementDto entitlement;

  factory VerifyResultDto.fromJson(Map<String, dynamic> json) {
    return VerifyResultDto(
      productId: json['product_id'] as String? ?? '',
      kind: switch (json['kind']) {
        'character' => PurchaseKind.character,
        'subscription' => PurchaseKind.subscription,
        _ => PurchaseKind.unknown,
      },
      alreadyGranted: json['already_granted'] as bool? ?? false,
      characterId: (json['character_id'] as num?)?.toInt(),
      entitlement: EntitlementDto.fromJson(
          (json['entitlement'] as Map<String, dynamic>?) ?? const {}),
    );
  }
}

/// `RestoreResponse` — a batch of receipts replayed after a reinstall.
class RestoreResultDto {
  const RestoreResultDto({
    required this.restored,
    required this.failed,
    required this.entitlement,
  });

  /// How many receipts were accepted.
  final int restored;

  /// How many were rejected. The call still returns 200 — a stale receipt
  /// among good ones must not lose the member the good ones.
  final int failed;

  /// The entitlement after the batch.
  final EntitlementDto entitlement;

  factory RestoreResultDto.fromJson(Map<String, dynamic> json) {
    return RestoreResultDto(
      restored: (json['restored'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      entitlement: EntitlementDto.fromJson(
          (json['entitlement'] as Map<String, dynamic>?) ?? const {}),
    );
  }
}
