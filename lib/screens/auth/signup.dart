import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Auth — signup screen. Figma `screen/auth_signup` (`2117:19739`).
///
/// A [Gnb.main] titled "가입하기" (back arrow pops), labelled email / password /
/// password-confirm [InputField]s (with inline mock validation copy), the
/// primary "회원가입" button, the social sign-up button row, and a 로그인 prompt.
///
/// No backend: both the "회원가입" button and any social sign-up assume success
/// and continue to onboarding ([Routes.onboardingName]); the "로그인" prompt
/// pops back to the login flow.
class SignupScreen extends StatefulWidget {
  /// Creates the signup screen.
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';

  /// Password length rule shown beneath the password field (8–16 chars).
  String? get _passwordError {
    if (_password.isEmpty) return null;
    if (_password.length < 8 || _password.length > 16) {
      return '비밀번호는 8~16자를 입력해주세요';
    }
    return null;
  }

  /// Confirm-match rule shown beneath the confirm field.
  String? get _confirmError {
    if (_passwordConfirm.isEmpty) return null;
    if (_passwordConfirm != _password) return '비밀번호가 일치하지 않아요';
    return null;
  }

  /// Mocked signup — continues to onboarding regardless of input.
  void _signup() => Navigator.pushNamed(context, Routes.onboardingName);

  /// Social signup is mocked as success → onboarding.
  void _socialSignup() => Navigator.pushNamed(context, Routes.onboardingName);

  /// Returns to the login flow.
  void _goLogin() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '가입하기', onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Email ───────────────────────────────────────────────
                  const _FieldLabel('이메일'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    hintText: '이메일을 입력해주세요',
                    keyboardType: TextInputType.emailAddress,
                    leftIcon: const Icon(Icons.mail_outline),
                  ),
                  const SizedBox(height: 20),
                  // ── Password ────────────────────────────────────────────
                  const _FieldLabel('비밀번호'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _password,
                    onChanged: (v) => setState(() => _password = v),
                    hintText: '비밀번호를 입력해주세요',
                    obscureText: true,
                    leftIcon: const Icon(Icons.lock_outline),
                  ),
                  _ErrorText(_passwordError),
                  const SizedBox(height: 20),
                  // ── Password confirm ────────────────────────────────────
                  const _FieldLabel('비밀번호 재확인'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _passwordConfirm,
                    onChanged: (v) => setState(() => _passwordConfirm = v),
                    hintText: '비밀번호를 재입력해주세요',
                    obscureText: true,
                    leftIcon: const Icon(Icons.lock_outline),
                  ),
                  _ErrorText(_confirmError),
                  const SizedBox(height: 32),
                  // ── Signup (primary) ────────────────────────────────────
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '회원가입',
                    onPressed: _signup,
                  ),
                  const SizedBox(height: 48),
                  // ── Social sign-up row ──────────────────────────────────
                  _SocialButtonRow(onPressed: _socialSignup),
                  const SizedBox(height: 24),
                  // ── Login prompt ────────────────────────────────────────
                  Center(child: _LoginPrompt(onLogin: _goLogin)),
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

/// Inline error helper line shown beneath a field; renders nothing when [text]
/// is null.
class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        text!,
        style: AppType.label2.r.copyWith(color: AppColors.error),
      ),
    );
  }
}

/// Three equal-width social sign-up buttons (Kakao / Google / Apple).
class _SocialButtonRow extends StatelessWidget {
  const _SocialButtonRow({required this.onPressed});

  /// Tapped on any social button (all mocked as success).
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget social(IconData icon) => Expanded(
          child: Button(
            type: BtnType.secondaryOutline,
            size: BtnSize.s60,
            text: '',
            leftIcon: Icon(icon),
            onPressed: onPressed,
          ),
        );
    return Row(
      children: [
        social(Icons.chat_bubble),
        const SizedBox(width: 12),
        social(Icons.g_mobiledata),
        const SizedBox(width: 12),
        social(Icons.apple),
      ],
    );
  }
}

/// "이미 계정이 있으신가요? 로그인" inline prompt.
class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLogin});

  /// Tapped when "로그인" is pressed.
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '이미 계정이 있으신가요?',
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onLogin,
          child: Text(
            '로그인',
            style: AppType.label1.sb.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
