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

  /// Whether [email] is free to register (`GET /auth/email/available`).
  Future<bool> checkEmailAvailable(String email);

  /// Sends a verification code to [email] (`POST /auth/email/send-code`).
  Future<void> sendEmailCode(String email);

  /// Verifies the emailed [code] (`POST /auth/email/verify-code`). Throws on
  /// a wrong code.
  Future<void> verifyEmailCode({required String email, required String code});

  /// Creates an account (`{email, password}`) and returns the new member.
  Future<Member> signup({
    required String email,
    required String password,
  });

  /// Saves onboarding data (`POST /members/me/onboarding`) and returns the
  /// updated member (with `onboardingCompleted == true`).
  Future<Member> submitOnboarding({
    String? name,
    String? language,
    List<String>? reasons,
  });

  /// Social login (Kakao/Google/Apple). Persists the token on success.
  Future<AuthToken> socialLogin({
    required String loginMethod,
    required String token,
  });

  /// Requests a password-reset code email. Returns the server message.
  Future<String> requestPasswordReset({required String email});

  /// Confirms a password reset with the emailed code + new password
  /// (`POST /auth/password-reset/confirm`). Returns the message.
  Future<String> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Fetches the currently authenticated member (`GET /members/me`).
  Future<Member> getMe();
}
