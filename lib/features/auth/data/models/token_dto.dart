import '../../domain/entities/auth_token.dart';

/// Wire model for `{access_token, token_type}`. Stays inside the data layer.
class TokenDto {
  const TokenDto({required this.accessToken, required this.tokenType});

  final String accessToken;
  final String tokenType;

  factory TokenDto.fromJson(Map<String, dynamic> json) {
    return TokenDto(
      accessToken: json['access_token'] as String,
      tokenType: (json['token_type'] as String?) ?? 'bearer',
    );
  }

  /// Converts to the domain entity.
  AuthToken toEntity() =>
      AuthToken(accessToken: accessToken, tokenType: tokenType);
}
