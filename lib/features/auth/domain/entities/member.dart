/// A BeaverTalk member. Pure Dart — no Flutter/dio/JSON knowledge.
class Member {
  const Member({
    required this.memberId,
    this.email,
    this.language,
    this.loginMethod,
    this.isAutoPayment,
    this.speakCountryId,
    this.characterId,
  });

  /// Server primary key.
  final int memberId;

  /// Account email (null for some social accounts).
  final String? email;

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
}
