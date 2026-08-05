/// A BeaverTalk member. Pure Dart — no Flutter/dio/JSON knowledge.
class Member {
  const Member({
    required this.memberId,
    this.email,
    this.name,
    this.language,
    this.targetLanguage,
    this.loginMethod,
    this.isAutoPayment,
    this.speakCountryId,
    this.characterId,
    this.onboardingCompleted = false,
    this.reasons,
    this.createdAt,
  });

  /// Server primary key.
  final int memberId;

  /// Account email (null for some social accounts).
  final String? email;

  /// Display name / nickname (saved during onboarding).
  final String? name;

  /// Preferred UI language code, e.g. `en`.
  final String? language;

  /// The language the member is **learning** (server `target_language`, ISO
  /// 639-1). The server owns this — the call socket no longer sends it, it reads
  /// `member.target_language` at call start. Null only for pre-migration rows;
  /// the server falls back to `ko`.
  final String? targetLanguage;

  /// How the member signed in, e.g. `email`, `kakao`.
  final String? loginMethod;

  /// Whether auto-payment is enabled.
  final bool? isAutoPayment;

  /// Selected speaking-country id (accent target).
  final int? speakCountryId;

  /// Selected character id.
  final int? characterId;

  /// Whether the member finished onboarding (drives AuthGate routing).
  final bool onboardingCompleted;

  /// Learning reasons chosen during onboarding (e.g. `["travel"]`).
  final List<String>? reasons;

  /// When the account was created — the Account card's `Joined` row.
  ///
  /// The server has always sent this (`MemberRead.created_at`); the client
  /// simply never read it, which is why that row was missing.
  final DateTime? createdAt;
}
