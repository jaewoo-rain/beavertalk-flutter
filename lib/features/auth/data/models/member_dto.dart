import '../../domain/entities/member.dart';

/// Wire model for `MemberRead` (snake_case). Stays inside the data layer.
class MemberDto {
  const MemberDto({
    required this.memberId,
    this.email,
    this.name,
    this.language,
    this.targetLanguage,
    this.actualNationality,
    this.nativeLanguage,
    this.loginMethod,
    this.isAutoPayment,
    this.speakCountryId,
    this.characterId,
    this.onboardingCompleted = false,
    this.reasons,
    this.createdAt,
    this.consentRequired = false,
    this.consentVersions = const {},
  });

  final int memberId;
  final String? email;
  final String? name;
  final String? language;
  final String? targetLanguage;

  /// `MemberRead.actual_nationality`(ISO · 2026-10-10). 구서버는 키가 없다 → null.
  final String? actualNationality;

  /// `MemberRead.native_language`(ISO 639-1 · 2026-10-12). 구서버는 키가 없다 → null.
  final String? nativeLanguage;
  final String? loginMethod;
  final bool? isAutoPayment;
  final int? speakCountryId;
  final int? characterId;
  final bool onboardingCompleted;
  final List<String>? reasons;

  /// `MemberRead.created_at` — present since the endpoint shipped.
  final DateTime? createdAt;

  /// `MemberRead.consent_required`(PM-DEC-735·736). 구서버는 키가 없다 → false.
  final bool consentRequired;

  /// `MemberRead.consent_versions` — 항목 코드 → 현행 문서 버전. 구서버는 키가 없다 → 빈 맵.
  final Map<String, String> consentVersions;

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    final rawReasons = json['reasons'];
    final rawVersions = json['consent_versions'];
    return MemberDto(
      memberId: json['member_id'] as int,
      email: json['email'] as String?,
      name: json['name'] as String?,
      language: json['language'] as String?,
      targetLanguage: json['target_language'] as String?,
      actualNationality: json['actual_nationality'] as String?,
      nativeLanguage: json['native_language'] as String?,
      loginMethod: json['login_method'] as String?,
      isAutoPayment: json['is_auto_payment'] as bool?,
      speakCountryId: json['speak_country_id'] as int?,
      characterId: json['character_id'] as int?,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      reasons: rawReasons is List
          ? rawReasons.map((e) => e.toString()).toList()
          : null,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '')
          ?.toLocal(),
      consentRequired: json['consent_required'] as bool? ?? false,
      consentVersions: rawVersions is Map
          ? {
              for (final e in rawVersions.entries)
                e.key.toString(): e.value.toString(),
            }
          : const {},
    );
  }

  /// Converts to the domain entity.
  Member toEntity() => Member(
        memberId: memberId,
        email: email,
        name: name,
        language: language,
        targetLanguage: targetLanguage,
        actualNationality: actualNationality,
        nativeLanguage: nativeLanguage,
        loginMethod: loginMethod,
        isAutoPayment: isAutoPayment,
        speakCountryId: speakCountryId,
        characterId: characterId,
        onboardingCompleted: onboardingCompleted,
        reasons: reasons,
        createdAt: createdAt,
        consentRequired: consentRequired,
        consentVersions: consentVersions,
      );
}
