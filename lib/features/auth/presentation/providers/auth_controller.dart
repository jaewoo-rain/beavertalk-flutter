import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  /// Creates an account, then auto-logs in with the same credentials so the
  /// user doesn't have to re-enter them. Throws on failure.
  ///
  /// The signup endpoint returns the member only (no token), so we follow with
  /// [AuthRepository.login] which persists the JWT. If that follow-up login
  /// throws, the account is already created and the user can still log in
  /// manually — we re-throw so the screen surfaces the error.
  Future<void> signup({
    required String email,
    required String password,
    String? language,
    String? loginMethod,
  }) async {
    await _repo.signup(
      email: email,
      password: password,
      language: language,
      loginMethod: loginMethod,
    );
    // Account is created; chain a login to obtain and store the JWT.
    await _repo.login(email: email, password: password);
    state = AuthStatus.authenticated;
  }

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
  }

  /// Called by the auth interceptor on a 401 (token already cleared there).
  /// Drops the cached profile and marks the session expired so AuthGate shows
  /// login (prevents the next user briefly seeing stale member info).
  void onSessionExpired() {
    ref.invalidate(myProfileProvider);
    if (state != AuthStatus.unauthenticated) {
      state = AuthStatus.unauthenticated;
    }
  }
}
