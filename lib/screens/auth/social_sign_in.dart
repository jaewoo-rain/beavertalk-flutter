import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../l10n/app_localizations.dart';

/// Web client id (public value) — the GCP `bt-dev-web-01` "Web application"
/// OAuth client. Used as the web GIS `clientId` and, on mobile, as the
/// `serverClientId` so the returned idToken's audience is this ID (which
/// Supabase validates against its Google provider "Client IDs" list). Must
/// stay identical here, in `web/index.html`, and in the Supabase dashboard.
const _googleClientId =
    '333511894671-mfss7vgjb3nmgl16jpo2e56bp6ne770e.apps.googleusercontent.com';

/// The four social sign-ins (Kakao · Google · Facebook · Apple), shared by the
/// login and signup screens.
///
/// Social accounts have no separate sign-up step: a first-time member lands
/// with `onboardingCompleted == false` and the AuthGate routes to onboarding.
/// So the signup screen's social row runs exactly the login handlers — it used
/// to call an empty stub and did nothing (09-29 iPhone build 46).
mixin SocialSignInMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Google Sign-In, configured per platform:
  /// - **web** → `clientId` = the web client (matches index.html), GIS flow.
  /// - **mobile** → `serverClientId` = the *web* client, so the returned
  ///   idToken's audience is the client Supabase validates; the Android OAuth
  ///   client (package + SHA-1) authorizes the request implicitly. iOS reads
  ///   its own client from `GIDClientID` in `ios/Runner/Info.plist`.
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _googleClientId : null,
    serverClientId: kIsWeb ? null : _googleClientId,
    scopes: const ['email', 'profile'],
  );

  StreamSubscription<GoogleSignInAccount?>? _googleSub;

  /// Whether each provider's flow is running — its button is disabled meanwhile.
  bool googleBusy = false;
  bool kakaoBusy = false;
  bool facebookBusy = false;
  bool appleBusy = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // A signed-in user (idToken populated) arrives on this stream after the
      // GIS button is pressed and consent is granted.
      _googleSub = _googleSignIn.onCurrentUserChanged.listen(_onGoogleUser);
      // Tries to restore a prior session without UI (no-op if none).
      unawaited(_googleSignIn.signInSilently());
    }
  }

  @override
  void dispose() {
    _googleSub?.cancel();
    super.dispose();
  }

  /// Every [AppException] that reaches here already carries translated copy —
  /// the auth controller maps Supabase errors through l10n and never passes
  /// their raw English text on (QA F017).
  void showSignInError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Exchanges the Google idToken for a Supabase session via
  /// `authController.signInWithGoogle` (→ `signInWithIdToken`).
  Future<void> _onGoogleUser(GoogleSignInAccount? account) async {
    if (account == null || googleBusy) return;
    final l10n = AppLocalizations.of(context);
    setState(() => googleBusy = true);
    try {
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw UnknownFailure(l10n.loginGoogleTokenError);
      }
      await ref
          .read(authControllerProvider.notifier)
          .signInWithGoogle(idToken: idToken, accessToken: auth.accessToken);
      // Success → AuthGate is authenticated and shows home; pop the auth flow.
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      showSignInError(e.message);
    } catch (_) {
      showSignInError(l10n.loginGoogleSignInFailed);
    } finally {
      if (mounted) setState(() => googleBusy = false);
    }
  }

  /// Starts the Google sign-in flow. On success the idToken is exchanged for
  /// our session by [_onGoogleUser].
  ///
  /// Note: on web, the idToken is delivered via the One Tap / button flow;
  /// `signIn()` triggers it but token availability depends on the GIS session.
  Future<void> googleSignIn() async {
    if (googleBusy) return;
    final l10n = AppLocalizations.of(context);
    try {
      if (!kIsWeb) {
        // google_sign_in 은 지난 로그인 계정을 기억해, signIn() 이 계정 선택창 없이 그 계정을
        // 바로 돌려준다. 앱 로그아웃은 Supabase 세션만 지워서 다른 구글 계정으로 바꿀 길이
        // 없었다(09-28 실기기). 매번 로컬 구글 세션을 지워 선택창을 띄운다 — disconnect 는
        // 권한까지 철회해 동의 화면이 다시 떠서 쓰지 않는다.
        try {
          await _googleSignIn.signOut();
        } catch (_) {}
      }
      final account = await _googleSignIn.signIn();
      // Web delivers the signed-in user via `onCurrentUserChanged` (wired in
      // initState); mobile returns it right here (null = the user cancelled).
      if (!kIsWeb && account != null) {
        await _onGoogleUser(account);
      }
    } on AppException catch (e) {
      showSignInError(e.message);
    } catch (_) {
      showSignInError(l10n.loginGoogleSignInFailed);
    }
  }

  /// Kakao sign-in via Supabase OAuth (external browser). Supabase has no Kakao
  /// native id_token path, so the session returns asynchronously through the
  /// deep link → `onAuthStateChange` → AuthGate re-routes; there is no
  /// navigation here. We only surface a launch failure.
  Future<void> kakaoSignIn() => _browserSignIn(
        busy: kakaoBusy,
        setBusy: (v) => kakaoBusy = v,
        run: () => ref.read(authControllerProvider.notifier).signInWithKakao(),
        failure: (l10n) => l10n.loginKakaoSignInFailed,
      );

  /// Facebook sign-in via Supabase OAuth (external browser) — identical shape to
  /// [kakaoSignIn].
  Future<void> facebookSignIn() => _browserSignIn(
        busy: facebookBusy,
        setBusy: (v) => facebookBusy = v,
        run: () =>
            ref.read(authControllerProvider.notifier).signInWithFacebook(),
        failure: (l10n) => l10n.loginFacebookSignInFailed,
      );

  /// Apple sign-in. On iOS the controller runs the native Sign in with Apple
  /// sheet and sets the session directly; on Android/web it opens Supabase
  /// browser OAuth and the session returns asynchronously via the deep link →
  /// `onAuthStateChange` → AuthGate. The controller branches per platform, so
  /// this handler stays identical for both — it only surfaces a failure.
  Future<void> appleSignIn() => _browserSignIn(
        busy: appleBusy,
        setBusy: (v) => appleBusy = v,
        run: () => ref.read(authControllerProvider.notifier).signInWithApple(),
        failure: (l10n) => l10n.loginAppleSignInFailed,
      );

  Future<void> _browserSignIn({
    required bool busy,
    required void Function(bool) setBusy,
    required Future<void> Function() run,
    required String Function(AppLocalizations) failure,
  }) async {
    if (busy) return;
    final l10n = AppLocalizations.of(context);
    setState(() => setBusy(true));
    try {
      await run();
    } on AppException catch (e) {
      showSignInError(e.message);
    } catch (_) {
      showSignInError(failure(l10n));
    } finally {
      if (mounted) setState(() => setBusy(false));
    }
  }
}
