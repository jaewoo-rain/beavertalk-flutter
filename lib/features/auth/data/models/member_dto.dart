import '../../domain/entities/member.dart';

/// Wire model for `MemberRead` (snake_case). Stays inside the data layer.
class MemberDto {
  const MemberDto({
    required this.memberId,
    this.email,
    this.language,
    this.loginMethod,
    this.isAutoPayment,
    this.speakCountryId,
    this.characterId,
  });

  final int memberId;
  final String? email;
  final String? language;
  final String? loginMethod;
  final bool? isAutoPayment;
  final int? speakCountryId;
  final int? characterId;

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
      memberId: json['member_id'] as int,
      email: json['email'] as String?,
      language: json['language'] as String?,
      loginMethod: json['login_method'] as String?,
      isAutoPayment: json['is_auto_payment'] as bool?,
      speakCountryId: json['speak_country_id'] as int?,
      characterId: json['character_id'] as int?,
    );
  }

  /// Converts to the domain entity.
  Member toEntity() => Member(
        memberId: memberId,
        email: email,
        language: language,
        loginMethod: loginMethod,
        isAutoPayment: isAutoPayment,
        speakCountryId: speakCountryId,
        characterId: characterId,
      );
}
