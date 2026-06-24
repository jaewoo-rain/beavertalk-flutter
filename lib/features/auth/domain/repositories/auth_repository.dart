import '../entities/auth_token.dart';
import '../entities/member.dart';

/// Auth capabilities the app depends on. Implemented in the data layer.
///
/// All methods return entities and throw [AppException] on failure
/// (see `core/error/app_exception.dart`). No dio/JSON leaks through here.
abstract interface class AuthRepository {
  /// Email/password login (OAuth2 form). Persists the token on success.
  Future<AuthToken> login({
    required String email,
    required String password,
  });

  /// Creates an account and returns the new member.
  Future<Member> signup({
    required String email,
    required String password,
    String? language,
    String? loginMethod,
    String? uniqueValue,
    int? speakCountryId,
    int? characterId,
  });

  /// Social login (Kakao/Google/Apple). Persists the token on success.
  Future<AuthToken> socialLogin({
    required String loginMethod,
    required String token,
  });

  /// Requests a password-reset email. Returns the server message.
  Future<String> requestPasswordReset({required String email});

  /// Confirms a password reset with the emailed token. Returns the message.
  Future<String> confirmPasswordReset({
    required String token,
    required String newPassword,
  });

  /// Fetches the currently authenticated member (`GET /members/me`).
  Future<Member> getMe();
}
