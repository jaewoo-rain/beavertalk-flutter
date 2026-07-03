import '../entities/member.dart';

/// Member capabilities the app depends on. Implemented in the data layer.
///
/// Authentication (login/signup/social/password-reset) is handled directly by
/// the Supabase SDK in `AuthController` and no longer flows through this
/// repository. What remains are the Bearer-protected member endpoints.
///
/// All methods return entities and throw [AppException] on failure
/// (see `core/error/app_exception.dart`). No dio/JSON leaks through here.
abstract interface class AuthRepository {
  /// Saves onboarding data (`POST /members/me/onboarding`) and returns the
  /// updated member (with `onboardingCompleted == true`).
  Future<Member> submitOnboarding({
    String? name,
    String? language,
    List<String>? reasons,
  });

  /// Fetches the currently authenticated member (`GET /members/me`).
  Future<Member> getMe();

  /// Deletes the current member's account (`DELETE /members/me`). Throws
  /// [AppException] on failure. The caller signs out of Supabase afterwards.
  Future<void> deleteAccount();

  /// Updates the member's UI [language] code (`PATCH /members/me`) and returns
  /// the updated member. Throws [AppException] on failure.
  Future<Member> updateLanguage(String language);
}
