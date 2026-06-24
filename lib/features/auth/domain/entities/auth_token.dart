/// A JWT access token returned by login/social endpoints. Pure Dart.
class AuthToken {
  const AuthToken({
    required this.accessToken,
    this.tokenType = 'bearer',
  });

  /// The bearer JWT to send as `Authorization: Bearer <accessToken>`.
  final String accessToken;

  /// Token scheme; the backend always returns `bearer`.
  final String tokenType;
}
