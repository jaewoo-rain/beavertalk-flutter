import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation.dart';
import '../../../../core/storage/token_store.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';
import 'my_profile_provider.dart';

/// High-level auth state the UI (AuthGate) switches on.
enum AuthStatus {
  /// Boot in progress — we don't yet know if a token exists.
  unknown,

  /// A token is present; the user is treated as logged in.
  authenticated,

  /// No valid token — show the login flow.
  unauthenticated,
}

/// Owns the [AuthStatus] and exposes auth actions. Login/signup mutate state
/// optimistically; a 401 anywhere routes back here via [onSessionExpired].
final authControllerProvider =
    NotifierProvider<AuthController, AuthStatus>(AuthController.new);

class AuthController extends Notifier<AuthStatus> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  TokenStore get _tokenStore => ref.read(tokenStoreProvider);

  @override
  AuthStatus build() => AuthStatus.unknown;

  /// On app start: optimistically authenticate if a token is stored. The first
  /// 401 (e.g. expired token) will bounce back to login via [onSessionExpired].
  Future<void> bootstrap() async {
    final token = await _tokenStore.read();
    state = (token != null && token.isNotEmpty)
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  /// Email/password login. Throws [AppException] on failure (caller shows it);
  /// on success flips state to authenticated.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _repo.login(email: email, password: password);
    state = AuthStatus.authenticated;
  }

  /// Whether [email] can be registered. Throws [AppException] on failure.
  Future<bool> checkEmail(String email) => _repo.checkEmailAvailable(email);

  /// Sends a verification code to [email]. Throws on failure.
  Future<void> sendCode(String email) => _repo.sendEmailCode(email);

  /// Verifies the emailed [code]. Throws on a wrong code.
  Future<void> verifyCode({required String email, required String code}) =>
      _repo.verifyEmailCode(email: email, code: code);

  /// Creates an account (`{email, password}`), then auto-logs in. Throws on
  /// failure.
  ///
  /// The signup endpoint returns the member only (no token), so we follow with
  /// [AuthRepository.login] which persists the JWT. The AuthGate then routes to
  /// onboarding or home based on `members/me.onboardingCompleted`.
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    await _repo.signup(email: email, password: password);
    // Account is created; chain a login to obtain and store the JWT.
    await _repo.login(email: email, password: password);
    state = AuthStatus.authenticated;
  }

  /// Saves onboarding data (`POST /members/me/onboarding`). Throws on failure.
  /// The caller invalidates [myProfileProvider] so the AuthGate re-routes.
  Future<void> submitOnboarding({
    String? name,
    String? language,
    List<String>? reasons,
  }) async {
    await _repo.submitOnboarding(
      name: name,
      language: language,
      reasons: reasons,
    );
  }

  /// Requests a password-reset code email. Returns the server message.
  Future<String> requestPasswordReset(String email) =>
      _repo.requestPasswordReset(email: email);

  /// Confirms a password reset with the emailed code + new password. Returns
  /// the server message. Throws on a wrong code.
  Future<String> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) =>
      _repo.confirmPasswordReset(
        email: email,
        code: code,
        newPassword: newPassword,
      );

  /// Social login. Flips state to authenticated on success. Throws on failure.
  Future<void> socialLogin({
    required String loginMethod,
    required String token,
  }) async {
    await _repo.socialLogin(loginMethod: loginMethod, token: token);
    state = AuthStatus.authenticated;
  }

  /// Explicit logout — clears the token, drops the cached profile, shows login.
  Future<void> logout() async {
    await _tokenStore.clear();
    ref.invalidate(myProfileProvider);
    state = AuthStatus.unauthenticated;
    _popToRoot();
  }

  /// Called by the auth interceptor on a 401 (token already cleared there).
  /// Drops the cached profile and marks the session expired so AuthGate shows
  /// login (prevents the next user briefly seeing stale member info).
  void onSessionExpired() {
    ref.invalidate(myProfileProvider);
    if (state != AuthStatus.unauthenticated) {
      state = AuthStatus.unauthenticated;
    }
    _popToRoot();
  }

  /// Clears any pushed routes so the (now unauthenticated) AuthGate root —
  /// which sits at the bottom of the stack — becomes visible immediately.
  void _popToRoot() {
    appNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
