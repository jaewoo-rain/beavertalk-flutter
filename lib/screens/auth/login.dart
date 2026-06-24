import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/brand_icons.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
// Conditional: the real GIS button on web, a no-op stub elsewhere. Keeps
// dart:js_interop (web-only) out of VM/mobile builds and tests.
import 'google_button_stub.dart'
    if (dart.library.js_interop) 'google_button_web.dart';

/// Web client id (public value) — must match the server's `GOOGLE_CLIENT_ID`.
const _googleClientId =
    '117133754675-ovpf9bvvm96e18d0089692k51bq75esk.apps.googleusercontent.com';

/// Auth — landing login screen. Figma `screen/auth_login` (`2117:19693`).
///
/// Brand block + social sign-in buttons + "또는" divider + 이메일 로그인 +
/// 회원가입 prompt.
///
/// **Google is real on web**: the GIS [gis_web.renderButton] yields an idToken
/// via [GoogleSignIn.onCurrentUserChanged], which we hand to
/// `authController.socialLogin('google', idToken)`; the AuthGate then shows
/// home. Kakao/Apple remain mocked for now.
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates the login landing screen.
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// Web Google Sign-In. `clientId` matches index.html + the server.
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _googleClientId,
    scopes: const ['email', 'profile'],
  );

  StreamSubscription<GoogleSignInAccount?>? _googleSub;
  bool _googleBusy = false;

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

  /// Exchanges the Google idToken for our JWT via `POST /auth/social`.
  Future<void> _onGoogleUser(GoogleSignInAccount? account) async {
    if (account == null || _googleBusy) return;
    setState(() => _googleBusy = true);
    try {
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const UnknownFailure('구글 로그인 토큰을 받지 못했어요');
      }
      await ref
          .read(authControllerProvider.notifier)
          .socialLogin(loginMethod: 'google', token: idToken);
      // Success → AuthGate is authenticated and shows home; pop the auth flow.
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('구글 로그인에 실패했어요');
    } finally {
      if (mounted) setState(() => _googleBusy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Kakao/Apple stay mocked for now → straight to home.
  void _socialLoginMock() => Navigator.pushNamed(context, Routes.home);

  /// Email login opens the dedicated email/password form.
  void _emailLogin() => Navigator.pushNamed(context, Routes.loginForm);

  /// Opens the signup flow.
  void _goSignup() => Navigator.pushNamed(context, Routes.signup);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Brand block: circular beaver avatar + wordmark ──────────
            const _LogoBlock(),
            const SizedBox(height: 60),
            // ── Social sign-in buttons ──────────────────────────────────
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: '카카오 로그인',
              leftIcon: const KakaoIcon(size: 24),
              onPressed: _socialLoginMock,
            ),
            const SizedBox(height: 16),
            // Google: real GIS button on web, mocked button elsewhere.
            _googleSlot(),
            const SizedBox(height: 16),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: '애플로 로그인',
              leftIcon: const AppleIcon(size: 24),
              onPressed: _socialLoginMock,
            ),
            const SizedBox(height: 16),
            // ── "또는" divider ──────────────────────────────────────────
            const _OrDivider(),
            const SizedBox(height: 16),
            // ── Email login (primary) ───────────────────────────────────
            Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: '이메일 로그인',
              leftIcon: const MailIcon(size: 24, color: AppColors.onPrimary),
              onPressed: _emailLogin,
            ),
            const SizedBox(height: 40),
            // ── Signup prompt + terms notice ────────────────────────────
            _SignupPrompt(onSignup: _goSignup),
          ],
        ),
      ),
    );
  }

  /// On web, renders the standard GIS sign-in button (the reliable idToken
  /// path). Off web, falls back to the styled mock button.
  Widget _googleSlot() {
    if (!kIsWeb) {
      return Button(
        type: BtnType.secondaryFill,
        size: BtnSize.s60,
        text: '구글로 로그인',
        leftIcon: const GoogleIcon(size: 24),
        onPressed: _socialLoginMock,
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        // GIS button has its own look (Google standard) — centered.
        Center(child: renderGoogleButton()),
        // Light overlay spinner while the token is being exchanged.
        if (_googleBusy)
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Circular beaver avatar (120px) over the "BeaverTalk" wordmark.
class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        const BeaverTalkLogo(width: 160, color: AppColors.text),
      ],
    );
  }
}

/// Horizontal "또는" divider — a centered label between two hairlines.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: AppColors.textTertiary),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '또는',
            style: AppType.caption1.r.copyWith(color: AppColors.textSecondary),
          ),
        ),
        line,
      ],
    );
  }
}

/// "아직 회원이 아니신가요? 회원가입" row plus the terms/privacy notice.
class _SignupPrompt extends StatelessWidget {
  const _SignupPrompt({required this.onSignup});

  /// Tapped when "회원가입" is pressed.
  final VoidCallback onSignup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '아직 회원이 아니신가요?',
              style:
                  AppType.label1.r.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onSignup,
              child: Text(
                '회원가입',
                style: AppType.label1.sb.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          '계속하면 Beavertalk의 서비스 약관에 동의하고 '
          '개인정보 보호정책을 읽었음을 인정한 것으로 간주합니다',
          textAlign: TextAlign.center,
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
