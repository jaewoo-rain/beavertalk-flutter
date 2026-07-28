import '../entities/accent_breakdown.dart';
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

  /// Fetches the member's accent (nationality) breakdown from
  /// `GET /members/me/profile` (`speak_country`). Empty when not yet analyzed.
  Future<AccentBreakdown> getMyAccent();

  /// Deletes the current member's account (`DELETE /members/me`). Throws
  /// [AppException] on failure. The caller signs out of Supabase afterwards.
  Future<void> deleteAccount();

  /// Updates the member's UI [language] code (`PATCH /members/me`) and returns
  /// the updated member. Throws [AppException] on failure.
  Future<Member> updateLanguage(String language);

  /// Updates the language the member is **learning** (`PATCH /members/me`,
  /// server `target_language`) and returns the updated member.
  ///
  /// The server owns this value: the call socket reads `member.target_language`
  /// at call start instead of receiving it from the client, so this call is what
  /// actually changes which language the next call teaches.
  Future<Member> updateTargetLanguage(String targetLanguage);

  /// Sets the member's in-use call partner to [characterId]
  /// (`PATCH /members/me`) and returns the updated member.
  ///
  /// The server does not check ownership here — it writes whatever id it is
  /// given, so callers must only offer characters the member owns.
  /// Throws [AppException] on failure.
  Future<Member> updateCharacter(int characterId);
}
