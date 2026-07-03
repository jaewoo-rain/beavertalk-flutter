import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/navigation.dart';
import '../../../../core/error/app_exception.dart';
import 'auth_providers.dart';
import 'my_profile_provider.dart';

/// High-level auth state the UI (AuthGate) switches on.
enum AuthStatus {
  /// Boot in progress — we don't yet know if a session exists.
  unknown,

  /// A Supabase session is present; the user is treated as logged in.
  authenticated,

  /// No valid session — show the login flow.
  unauthenticated,
}

/// Owns the [AuthStatus] and exposes auth actions backed by Supabase Auth.
///
/// The Supabase SDK persists + auto-refreshes the session; this controller
/// mirrors that into [AuthStatus] (via [bootstrap] + an `onAuthStateChange`
/// subscription) so the AuthGate routes correctly. A 401 anywhere routes back
/// here via [onSessionExpired].
final authControllerProvider =
    NotifierProvider<AuthController, AuthStatus>(AuthController.new);

class AuthController extends Notifier<AuthStatus> {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  AuthStatus build() => AuthStatus.unknown;

  /// On app start: reflect the persisted Supabase session into the gate, and
  /// subscribe once to auth-state changes so session expiry/refresh-failure or
  /// a refresh-restored session flips the gate automatically.
  Future<void> bootstrap() async {
    _subscribeOnce();
    state = _client.auth.currentSession != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  bool _subscribed = false;

  /// Wires the Supabase auth stream to [AuthStatus] (idempotent).
  void _subscribeOnce() {
    if (_subscribed) return;
    _subscribed = true;
    final sub = _client.auth.onAuthStateChange.listen((data) {
      switch (data.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
          if (state != AuthStatus.authenticated) {
            state = AuthStatus.authenticated;
          }
        case AuthChangeEvent.signedOut:
          ref.invalidate(myProfileProvider);
          if (state != AuthStatus.unauthenticated) {
            state = AuthStatus.unauthenticated;
          }
        default:
          break;
      }
    });
    ref.onDispose(sub.cancel);
  }

  /// Email/password login via Supabase. Throws [AppException] on failure
  /// (caller shows it); on success flips state to authenticated.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      state = AuthStatus.authenticated;
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.login);
    }
  }

  /// Creates an account via Supabase.
  ///
  /// - If a session is returned (dev path with "Confirm email" OFF) → flips to
  ///   authenticated and the AuthGate routes into onboarding.
  /// - If no session is returned (email confirmation required) → throws an
  ///   [UnauthorizedFailure] telling the user to confirm their email; the gate
  ///   stays on the login flow.
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      if (res.session != null) {
        state = AuthStatus.authenticated;
        return;
      }
      // No session → email confirmation is required by the project settings.
      throw const UnauthorizedFailure('이메일로 전송된 인증을 완료해주세요.');
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.signup);
    }
  }

  /// Saves onboarding data (`POST /members/me/onboarding`). Throws on failure.
  /// The caller invalidates [myProfileProvider] so the AuthGate re-routes.
  Future<void> submitOnboarding({
    String? name,
    String? language,
    List<String>? reasons,
  }) async {
    await ref.read(authRepositoryProvider).submitOnboarding(
          name: name,
          language: language,
          reasons: reasons,
        );
  }

  /// Requests a password-recovery code email (Supabase recovery OTP — a 6-digit
  /// code, not a link). Returns a user-facing confirmation message.
  Future<String> requestPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return '인증 코드를 이메일로 전송했어요.';
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.reset);
    }
  }

  /// Step 1 of the two-step reset: verifies the emailed 6-digit recovery [code]
  /// (Supabase recovery OTP). On success Supabase establishes a temporary
  /// recovery session on the client, which [updatePassword] then uses to set
  /// the new password (no token needs threading between screens). Throws on a
  /// wrong/expired code.
  Future<void> verifyRecoveryCode({
    required String email,
    required String code,
  }) async {
    try {
      await _client.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.recovery,
      );
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.reset);
    }
  }

  /// Step 2 of the two-step reset: sets [newPassword] for the user signed in by
  /// [verifyRecoveryCode]'s recovery session. Returns a user-facing
  /// confirmation message. Throws if the recovery session is missing/expired.
  Future<String> updatePassword({required String newPassword}) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      return '비밀번호가 재설정되었어요.';
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.reset);
    }
  }

  /// Social login (Google/Kakao). Not configured yet — see TODO below.
  Future<void> socialLogin({
    required String loginMethod,
    required String token,
  }) async {
    // TODO(auth): wire OAuth once providers are configured in Supabase, e.g.
    //   await _client.auth.signInWithOAuth(OAuthProvider.google);
    // The deleted `/auth/social` backend endpoint is intentionally NOT called.
    throw const UnknownFailure('소셜 로그인은 아직 준비 중이에요.');
  }

  /// Explicit logout — signs out of Supabase, drops the cached profile, shows
  /// login. The `onAuthStateChange` listener also flips the gate, but we set it
  /// here too for immediacy.
  Future<void> logout() async {
    await _client.auth.signOut();
    ref.invalidate(myProfileProvider);
    state = AuthStatus.unauthenticated;
    _popToRoot();
  }

  /// Called by the auth interceptor on a 401. Best-effort sign-out, drops the
  /// cached profile, and marks the session expired so AuthGate shows login
  /// (prevents the next user briefly seeing stale member info).
  void onSessionExpired() {
    // Best-effort: don't await (interceptor callback is sync); errors ignored.
    _client.auth.signOut().ignore();
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

  /// Maps a Supabase [AuthException] to the app's typed [AppException] with a
  /// Korean message, matching the previous backend error semantics.
  AppException _mapAuthException(
    AuthException e, {
    required _AuthContext context,
  }) {
    final raw = e.message.toLowerCase();
    // Already-registered email on signup → conflict.
    if (context == _AuthContext.signup &&
        (raw.contains('already registered') ||
            raw.contains('already been registered') ||
            raw.contains('user already') ||
            e.code == 'user_already_exists')) {
      return const ConflictFailure('이미 가입된 이메일입니다.');
    }
    // Wrong credentials on login.
    if (context == _AuthContext.login &&
        (raw.contains('invalid login') ||
            raw.contains('invalid credentials') ||
            e.code == 'invalid_credentials')) {
      return const UnauthorizedFailure('이메일 또는 비밀번호가 올바르지 않아요.');
    }
    // Wrong/expired recovery code.
    if (context == _AuthContext.reset &&
        (raw.contains('token has expired') ||
            raw.contains('invalid') ||
            e.code == 'otp_expired')) {
      return const ValidationFailure('인증 코드가 올바르지 않거나 만료되었어요.');
    }
    // Fallback: surface Supabase's message.
    return UnknownFailure(e.message);
  }
}

/// Discriminates which call produced an [AuthException] so the mapper can pick
/// the right Korean message.
enum _AuthContext { login, signup, reset }
