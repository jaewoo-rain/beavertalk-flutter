import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/navigation.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../mock/mock_data.dart' show clearBookmarks;
import '../../../alarm/presentation/providers/alarm_list_controller.dart';
import '../../../bookmark/presentation/providers/bookmark_providers.dart';
import '../../../character/presentation/providers/character_providers.dart';
import 'auth_providers.dart';
import 'my_profile_provider.dart';
import 'signup_draft_provider.dart';

/// Deep link Supabase OAuth (Kakao, and the Apple/Android fallback) redirects
/// back to after the browser consent step. Must be registered in three places:
/// `AndroidManifest.xml` (intent-filter), iOS `Info.plist` (CFBundleURLTypes),
/// and the Supabase dashboard → Authentication → URL Configuration → Redirect
/// URLs.
const kOAuthRedirect = 'im.beavertalk.beavertalk://login-callback';

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

  /// Drops every piece of user-scoped state so nothing survives into the next
  /// session. Call from EVERY sign-out path (explicit logout, account deletion,
  /// 401 expiry, and the `signedOut` event) and on sign-in as a belt-and-braces
  /// guard against state cached before the session existed.
  ///
  /// Only [myProfileProvider] used to be invalidated here. The rest of these are
  /// plain (non-autoDispose) providers, so their cached values outlived sign-out
  /// entirely — user A's alarms would still be in memory when user B signed in
  /// on the same device, and [InboundCallScheduler] reads that cache on a timer,
  /// so B's phone would ring with A's alarm and A's character.
  /// [callListProvider] is `.autoDispose` and needs no entry here.
  void _clearUserScopedState() {
    ref.invalidate(myProfileProvider);
    // A's alarms → B's ring (see above). Also clears a 401 cached pre-login.
    ref.invalidate(alarmListControllerProvider);
    // A's saved sentences would show in B's 보관 tab.
    ref.invalidate(bookmarkListProvider);
    // A's owned characters would show in B's avatar screen.
    ref.invalidate(ownedCharactersProvider);
    // A's language/name/reasons would prefill B's onboarding — the login screen
    // skips the language sheet when `language != null`, and the reason step
    // would open with A's answers already checked and Continue enabled.
    ref.invalidate(signupDraftProvider);
    // Top-level global, outside Riverpod — must be cleared by hand.
    clearBookmarks();
  }

  /// Wires the Supabase auth stream to [AuthStatus] (idempotent).
  void _subscribeOnce() {
    if (_subscribed) return;
    _subscribed = true;
    final sub = _client.auth.onAuthStateChange.listen((data) {
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          // Clear anything cached before this session existed. The alarm list in
          // particular can hold a 401 AsyncError from boot (the scheduler used to
          // fetch it with no session), which the alarm screen would then render
          // with no network call at all — leaving Retry as the only way out.
          _clearUserScopedState();
          if (state != AuthStatus.authenticated) {
            state = AuthStatus.authenticated;
          }
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
          // Same session — keep caches; only the gate state matters here.
          if (state != AuthStatus.authenticated) {
            state = AuthStatus.authenticated;
          }
        case AuthChangeEvent.signedOut:
          _clearUserScopedState();
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

  /// Google sign-in: exchanges a Google [idToken] (plus the optional
  /// [accessToken], which lets Supabase fetch the provider profile) for a
  /// Supabase session via `signInWithIdToken`.
  ///
  /// The token is obtained natively on mobile (`google_sign_in`, audience = the
  /// web `serverClientId`) or via GIS on web. No backend change is needed:
  /// Supabase issues the same JWT it does for email login, so `/members/me`
  /// and every other authed call keep working. A first-time social user lands
  /// with `onboardingCompleted == false`, so the AuthGate routes to onboarding.
  /// Throws [AppException] on failure (caller shows it).
  Future<void> signInWithGoogle({
    required String idToken,
    String? accessToken,
  }) async {
    try {
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      state = AuthStatus.authenticated;
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.login);
    }
  }

  /// Kakao sign-in via Supabase OAuth. Supabase has no Kakao *native* id_token
  /// path, so this opens Kakao's consent page in an external browser; on success
  /// the deep link [kOAuthRedirect] returns to the app and `onAuthStateChange`
  /// (wired in [_subscribeOnce]) flips the gate to authenticated — so, unlike the
  /// email/Google paths, this method does NOT set [state] itself and the caller
  /// needs no post-login navigation (the AuthGate re-routes on the event).
  ///
  /// Returns as soon as the browser is launched; the session arrives
  /// asynchronously. Throws [AppException] if the browser can't be launched.
  Future<void> signInWithKakao() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: kOAuthRedirect,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.login);
    }
  }

  /// Apple sign-in via Supabase OAuth (external browser) — the Android/web path.
  /// Apple has no Android native SDK, so this opens Apple's consent page in an
  /// external browser (Services ID `im.beavertalk.beavertalk` + the .p8-signed
  /// secret configured in Supabase); on success the deep link [kOAuthRedirect]
  /// returns to the app and `onAuthStateChange` flips the gate — so, like Kakao,
  /// this method does NOT set [state] and needs no post-login navigation.
  ///
  /// NOTE: the iOS *native* path (App ID `beavertalk.beavertalk.im` via
  /// `sign_in_with_apple` → `signInWithIdToken(OAuthProvider.apple, nonce: …)`)
  /// is future work — it needs an Xcode "Sign in with Apple" capability and a Mac
  /// build, so every platform uses this browser OAuth fallback for now.
  ///
  /// Returns as soon as the browser is launched. Throws [AppException] if the
  /// browser can't be launched.
  Future<void> signInWithApple() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: kOAuthRedirect,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.login);
    }
  }

  /// Explicit logout — signs out of Supabase, drops the cached profile, shows
  /// login. The `onAuthStateChange` listener also flips the gate, but we set it
  /// here too for immediacy.
  Future<void> logout() async {
    // signOut() clears the local session first, then revokes over the network —
    // so an offline tap still logs you out locally but throws afterwards. Letting
    // that throw escape skipped _popToRoot(), stranding the user on MyPage while
    // the root had already swapped to login: nothing appeared to happen, and the
    // un-awaited call surfaced as an unhandled async error. Local sign-out is
    // what the UI depends on, so a failed revoke must not abort the rest.
    try {
      await _client.auth.signOut();
    } catch (_) {
      // Ignored on purpose: the local session is gone either way.
    }
    _clearUserScopedState();
    state = AuthStatus.unauthenticated;
    _popToRoot();
  }

  /// Persists the member's UI [language] (`PATCH /members/me`) and refreshes the
  /// cached profile so the new value is reflected app-wide. Throws on failure.
  Future<void> updateLanguage(String language) async {
    await ref.read(authRepositoryProvider).updateLanguage(language);
    ref.invalidate(myProfileProvider);
  }

  /// Deletes the account: asks the backend to delete the member (`DELETE
  /// /members/me`), then signs out of Supabase and returns to login. Throws
  /// [AppException] on failure (caller shows it) — sign-out only runs after the
  /// backend delete succeeds, so a failed delete leaves the user logged in.
  ///
  /// NOTE(server): the backend must also delete the Supabase auth user (needs
  /// the admin/service key) — the client SDK cannot delete its own auth user.
  /// Without that, the same email can sign back in and be find-or-created again.
  Future<void> deleteAccount() async {
    await ref.read(authRepositoryProvider).deleteAccount();
    // The backend delete already succeeded — a failed network revoke must not
    // leave the user staring at a deleted account's UI. Same reasoning as logout().
    try {
      await _client.auth.signOut();
    } catch (_) {
      // Ignored on purpose: the local session is gone either way.
    }
    _clearUserScopedState();
    state = AuthStatus.unauthenticated;
    _popToRoot();
  }

  /// Called by the auth interceptor on a 401. Best-effort sign-out, drops the
  /// cached profile, and marks the session expired so AuthGate shows login
  /// (prevents the next user briefly seeing stale member info).
  void onSessionExpired() {
    // Best-effort: don't await (interceptor callback is sync); errors ignored.
    _client.auth.signOut().ignore();
    _clearUserScopedState();
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
