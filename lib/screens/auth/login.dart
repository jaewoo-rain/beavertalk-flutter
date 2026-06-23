import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/brand_icons.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Auth — landing login screen. Figma `screen/auth_login` (`2117:19693`).
///
/// Shows the BeaverTalk brand block (circular beaver avatar + wordmark), three
/// social sign-in buttons (Kakao / Google / Apple, [BtnType.secondaryFill]), an
/// "또는" divider, the primary "이메일 로그인" button, and a 회원가입 prompt.
///
/// No backend: every social tap and the 이메일 로그인 → 폼 flow assume success.
/// Social/이메일 success lands on [Routes.home]; "이메일 로그인" routes to the
/// email form ([Routes.loginForm]); "회원가입" routes to [Routes.signup].
class LoginScreen extends StatefulWidget {
  /// Creates the login landing screen.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Social login is mocked as always-successful → straight to home.
  void _socialLogin() => Navigator.pushNamed(context, Routes.home);

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
              onPressed: _socialLogin,
            ),
            const SizedBox(height: 16),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: '구글로 로그인',
              leftIcon: const GoogleIcon(size: 24),
              onPressed: _socialLogin,
            ),
            const SizedBox(height: 16),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: '애플로 로그인',
              leftIcon: const AppleIcon(size: 24),
              onPressed: _socialLogin,
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
