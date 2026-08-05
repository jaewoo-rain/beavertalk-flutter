import '../../domain/entities/member.dart';

/// Wire model for `MemberRead` (snake_case). Stays inside the data layer.
class MemberDto {
  const MemberDto({
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

  final int memberId;
  final String? email;
  final String? name;
  final String? language;
  final String? targetLanguage;
  final String? loginMethod;
  final bool? isAutoPayment;
  final int? speakCountryId;
  final int? characterId;
  final bool onboardingCompleted;
  final List<String>? reasons;

  /// `MemberRead.created_at` — present since the endpoint shipped.
  final DateTime? createdAt;

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    final rawReasons = json['reasons'];
    return MemberDto(
      memberId: json['member_id'] as int,
      email: json['email'] as String?,
      name: json['name'] as String?,
      language: json['language'] as String?,
      targetLanguage: json['target_language'] as String?,
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
    );
  }

  /// Converts to the domain entity.
  Member toEntity() => Member(
        memberId: memberId,
        email: email,
        name: name,
        language: language,
        targetLanguage: targetLanguage,
        loginMethod: loginMethod,
        isAutoPayment: isAutoPayment,
        speakCountryId: speakCountryId,
        characterId: characterId,
        onboardingCompleted: onboardingCompleted,
        reasons: reasons,
        createdAt: createdAt,
      );
}
