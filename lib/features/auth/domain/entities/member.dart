/// A BeaverTalk member. Pure Dart — no Flutter/dio/JSON knowledge.
class Member {
  const Member({
    required this.memberId,
    this.email,
    this.name,
    this.language,
    this.loginMethod,
    this.isAutoPayment,
    this.speakCountryId,
    this.characterId,
    this.onboardingCompleted = false,
    this.reasons,
  });

  /// Server primary key.
  final int memberId;

  /// Account email (null for some social accounts).
  final String? email;

  /// Display name / nickname (saved during onboarding).
  final String? name;

  /// Preferred UI language code, e.g. `en`.
  final String? language;

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
}
