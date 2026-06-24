import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/brand_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Auth — signup. Figma `screen/auth_signup` (`2117:19739`).
///
/// A simple form (email + password + confirm). "회원가입" calls
/// `signup(email, password)` which auto-logs in; the AuthGate then routes to
/// onboarding (language → name → reason) since `onboardingCompleted` is false.
///
/// The "로그인" prompt pops back to the login flow.
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

  bool _submitting = false; // signup 진행 중
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

  /// Conditions to enable the "회원가입" button.
  bool get _canSubmit =>
      _email.trim().isNotEmpty &&
      _password.isNotEmpty &&
      _passwordConfirm.isNotEmpty &&
      _passwordError == null &&
      _confirmError == null;

  /// Creates the account (auto-logs in). The AuthGate then sends the user into
  /// onboarding (language → name → reason).
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
      await ref
          .read(authControllerProvider.notifier)
          .signup(email: _email.trim(), password: _password);
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
                    leftIcon: const MailIcon(
                        size: 20, color: AppColors.textSecondary),
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
                  // ── Server / validation error ───────────────────────────
                  _ErrorText(_error),
                  const SizedBox(height: 32),
                  // ── Signup (auto-logs in; AuthGate routes to onboarding) ─
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: _submitting ? '가입 중...' : '회원가입',
                    disabled: _submitting || !_canSubmit,
                    onPressed: _signup,
                  ),
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
