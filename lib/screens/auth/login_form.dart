import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/brand_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Auth — email/password login form. Figma `screen/auth_login_form`
/// (`2117:19780`).
///
/// A [Gnb.main] titled "로그인" (back arrow pops), labelled email and password
/// [InputField]s, an "아이디 저장" checkbox row with a "아이디/비밀번호 찾기" link,
/// the primary "로그인" button, the social sign-in button row, and a 회원가입
/// prompt.
///
/// No backend: "로그인" assumes success → [Routes.home]; the find-password link
/// routes to [Routes.passwordMethod]; "회원가입" routes to [Routes.signup].
class LoginFormScreen extends StatefulWidget {
  /// Creates the email login form screen.
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  String _email = '';
  String _password = '';
  bool _saveId = false;

  /// Mocked login — always succeeds, lands on home.
  void _login() => Navigator.pushNamed(context, Routes.home);

  /// Social login is mocked as always-successful → home.
  void _socialLogin() => Navigator.pushNamed(context, Routes.home);

  /// Opens the find-password flow.
  void _findPassword() => Navigator.pushNamed(context, Routes.passwordMethod);

  /// Opens the signup flow.
  void _goSignup() => Navigator.pushNamed(context, Routes.signup);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '로그인', onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Email field ─────────────────────────────────────────
                  const _FieldLabel('이메일'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    hintText: '이메일을 입력해주세요',
                    keyboardType: TextInputType.emailAddress,
                    leftIcon:
                        const MailIcon(size: 20, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  // ── Password field ──────────────────────────────────────
                  const _FieldLabel('비밀번호'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _password,
                    onChanged: (v) => setState(() => _password = v),
                    hintText: '비밀번호를 입력해주세요',
                    obscureText: true,
                    leftIcon: const Icon(Icons.lock_outline),
                  ),
                  const SizedBox(height: 20),
                  // ── Save-id checkbox + find-password link ───────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => _saveId = !_saveId),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _saveId
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 22,
                                color: _saveId
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '아이디 저장',
                                style: AppType.label1.r
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _findPassword,
                          child: Text(
                            '아이디/비밀번호 찾기',
                            style: AppType.label1.r
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // ── Login (primary) ─────────────────────────────────────
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '로그인',
                    onPressed: _login,
                  ),
                  const SizedBox(height: 48),
                  // ── Social sign-in row ──────────────────────────────────
                  _SocialButtonRow(onPressed: _socialLogin),
                  const SizedBox(height: 24),
                  // ── Signup prompt ───────────────────────────────────────
                  Center(child: _SignupPrompt(onSignup: _goSignup)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A left-padded secondary field label (matches Figma's 8px inset).
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

/// Three equal-width social sign-in buttons (Kakao / Google / Apple).
class _SocialButtonRow extends StatelessWidget {
  const _SocialButtonRow({required this.onPressed});

  /// Tapped on any social button (all mocked as success).
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget social(Widget icon) => Expanded(
          child: Button(
            type: BtnType.secondaryOutline,
            size: BtnSize.s60,
            text: '',
            leftIcon: icon,
            onPressed: onPressed,
          ),
        );
    return Row(
      children: [
        social(const KakaoIcon(size: 24)),
        const SizedBox(width: 12),
        social(const GoogleIcon(size: 24)),
        const SizedBox(width: 12),
        social(const AppleIcon(size: 24, color: AppColors.textSecondary)),
      ],
    );
  }
}

/// "아직 회원이 아니신가요? 회원가입" inline prompt.
class _SignupPrompt extends StatelessWidget {
  const _SignupPrompt({required this.onSignup});

  /// Tapped when "회원가입" is pressed.
  final VoidCallback onSignup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '아직 회원이 아니신가요?',
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
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
    );
  }
}
