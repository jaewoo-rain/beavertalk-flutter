import 'dart:convert' show utf8;
import 'dart:math' show Random;

import 'package:crypto/crypto.dart' show sha256;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 카카오 SDK는 Supabase와 여러 타입명(User/AuthApi 등)이 겹치므로 프리픽스로 import.
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

  /// 카카오 간편 로그인 → Supabase 세션 생성.
  ///
  /// 카카오톡이 설치돼 있으면 앱으로(간편 로그인), 아니면 카카오계정(웹)으로 로그인해
  /// OIDC `idToken`을 받고, 그대로 [SupabaseClient]의 `signInWithIdToken`에 넘겨
  /// 세션을 만든다(가이드의 OIDC 방식). 성공 시 상태를 authenticated로 올리며,
  /// `onAuthStateChange` 리스너도 함께 반영한다.
  ///
  /// 사용자가 로그인을 취소하면 조용히 반환한다(예외 없음). 그 외 실패는:
  /// - `idToken == null`(카카오 OIDC 미활성/openid scope 누락) → [UnknownFailure]
  /// - Supabase 인증 거부(audience 불일치 등) → [_mapAuthException]
  /// - 카카오 SDK 오류 → 원본 예외를 그대로 전파(호출부가 일반 메시지로 처리)
  Future<void> signInWithKakao() async {
    try {
      final token = await _kakaoAuthenticate();
      if (token == null) return; // 사용자가 취소 → 조용히 종료
      final idToken = token.idToken;
      if (idToken == null) {
        throw const UnknownFailure('카카오 로그인에 실패했어요. (OIDC 설정 확인 필요)');
      }
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.kakao,
        idToken: idToken,
        accessToken: token.accessToken,
      );
      state = AuthStatus.authenticated;
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.login);
    }
  }

  /// 카카오톡 앱 우선 로그인, 실패 시 카카오계정(웹) 폴백. 카카오톡 로그인 화면에서
  /// 사용자가 취소(뒤로가기)하면 폴백하지 않고 `null`을 반환한다.
  Future<kakao.OAuthToken?> _kakaoAuthenticate() async {
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        return await kakao.UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        // 사용자가 카카오톡 로그인을 취소 → 계정 로그인으로 밀지 않고 종료.
        if (e is PlatformException && e.code == 'CANCELED') return null;
        // 그 외(카톡 미로그인 등) → 카카오계정(웹) 로그인으로 폴백.
        return kakao.UserApi.instance.loginWithKakaoAccount();
      }
    }
    return kakao.UserApi.instance.loginWithKakaoAccount();
  }

  /// 구글 로그인의 Supabase 단계: UI(google_sign_in)에서 받은 [idToken]을
  /// `signInWithIdToken(provider: google)`에 넘겨 세션을 만든다. 토큰 획득은
  /// 웹/모바일 차이가 있어 UI(login.dart)가 담당하고, 여기서는 Supabase 세션
  /// 생성만 한다. [idToken]의 audience는 Supabase Google provider에 등록된
  /// 웹 클라이언트 ID여야 하므로, 모바일에서는 `serverClientId`로 발급해야 한다.
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

  /// 애플 간편 로그인 → Supabase 세션 생성 (iOS 네이티브).
  ///
  /// 리플레이 방지를 위해 raw nonce를 만들어 SHA-256 해시를 애플에 전달하고,
  /// 발급된 `identityToken`을 raw nonce와 함께 `signInWithIdToken(provider:
  /// apple)`에 넘긴다(Supabase 권장 패턴). 사용자가 취소하면 조용히 반환한다.
  ///
  /// 주의: Android에서는 별도의 Apple Service ID + 웹 리다이렉트(webAuthentication
  /// Options)가 필요하다. 이 구현은 iOS 네이티브 기준이며, Android에서 호출하면
  /// SDK가 예외를 던져 호출부가 일반 오류 메시지로 처리한다.
  Future<void> signInWithApple() async {
    final rawNonce = _generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      // 사용자가 취소 → 조용히 종료(에러 스낵바 없음).
      if (e.code == AuthorizationErrorCode.canceled) return;
      rethrow;
    }

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const UnknownFailure('애플 로그인에 실패했어요. (identityToken 없음)');
    }
    try {
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      state = AuthStatus.authenticated;
    } on AuthException catch (e) {
      throw _mapAuthException(e, context: _AuthContext.login);
    }
  }

  /// 애플 로그인 리플레이 방지용 raw nonce(16진수 문자열). 해시(SHA-256)는 애플에,
  /// 원문은 Supabase에 전달돼 idToken의 nonce 클레임과 대조된다.
  String _generateRawNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
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
