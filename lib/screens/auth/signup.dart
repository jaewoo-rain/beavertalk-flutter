import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/brand_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Auth — signup screen. Figma `screen/auth_signup` (`2117:19739`).
///
/// A [Gnb.main] titled "가입하기" (back arrow pops), labelled email / password /
/// password-confirm [InputField]s (with inline mock validation copy), the
/// primary "회원가입" button, the social sign-up button row, and a 로그인 prompt.
///
/// Real backend: "회원가입" calls [AuthController.signup]; on success it
/// continues to onboarding ([Routes.onboardingName]). Validation/conflict
/// errors are shown inline. The "로그인" prompt pops back to the login flow.
class SignupScreen extends ConsumerStatefulWidget {
  /// Creates the signup screen.
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _submitting = false;
  String? _error;

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

  /// Whether the form passes local validation (non-empty + matching rules).
  bool get _canSubmit =>
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _passwordConfirm.isNotEmpty &&
      _passwordError == null &&
      _confirmError == null;

  /// Calls the real signup endpoint (which auto-logs in) on success.
  /// On success the AuthGate is authenticated and shows home, so we pop the
  /// auth stack back to it. Server errors are shown inline.
  Future<void> _signup() async {
    if (_submitting) return;
    if (!_canSubmit) {
      setState(() => _error = '입력값을 확인해주세요');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).signup(
            email: _email.trim(),
            password: _password,
            loginMethod: 'email',
          );
      if (!mounted) return;
      // Auto-login flipped AuthGate to authenticated; leave the auth flow.
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Social signup is not wired yet → continues to onboarding.
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
                    leftIcon:
                        const MailIcon(size: 20, color: AppColors.textSecondary),
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
                  // ── Server error (signup failure) ───────────────────────
                  _ErrorText(_error),
                  const SizedBox(height: 32),
                  // ── Signup (primary) ────────────────────────────────────
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: _submitting ? '가입 중...' : '회원가입',
                    disabled: _submitting,
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
