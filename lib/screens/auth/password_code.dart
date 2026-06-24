import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/molecules/otp_input.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 2 — enter the emailed code + a new password.
///
/// Figma `screen/auth_findpw_code` (`2117:19861`). Real backend: the email is
/// passed as the route argument; "입력 완료" calls
/// `confirmPasswordReset(email, code, newPassword)` (the server validates the
/// code and sets the password together) → on success goes to
/// [Routes.passwordComplete]. "코드 재전송" re-requests a code.
class PasswordCodeScreen extends ConsumerStatefulWidget {
  /// Creates the password-code screen.
  const PasswordCodeScreen({super.key});

  @override
  ConsumerState<PasswordCodeScreen> createState() =>
      _PasswordCodeScreenState();
}

class _PasswordCodeScreenState extends ConsumerState<PasswordCodeScreen> {
  /// Total seconds in the entry window — Figma copy says "2분".
  static const int _windowSeconds = 120;

  String _email = '';
  String _code = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _submitting = false;
  String? _error;

  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restartCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String) _email = arg;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartCountdown() {
    _timer?.cancel();
    _remaining = _windowSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
        return;
      }
      setState(() => _remaining--);
    });
  }

  /// `m:ss` formatting of the remaining seconds.
  String get _clock {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String? get _passwordError {
    if (_password.isEmpty) return null;
    if (_password.length < 8 || _password.length > 16) {
      return '비밀번호는 8~16자를 입력해주세요';
    }
    return null;
  }

  String? get _confirmError {
    if (_passwordConfirm.isEmpty) return null;
    if (_passwordConfirm != _password) return '비밀번호가 일치하지 않아요';
    return null;
  }

  bool get _canSubmit =>
      _code.length == 4 &&
      _password.isNotEmpty &&
      _passwordConfirm.isNotEmpty &&
      _passwordError == null &&
      _confirmError == null;

  /// Re-requests a reset code for the same email.
  Future<void> _resend() async {
    if (_email.isEmpty) return;
    _restartCountdown();
    try {
      await ref
          .read(authControllerProvider.notifier)
          .requestPasswordReset(_email);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _submit() async {
    if (_submitting || !_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).confirmPasswordReset(
            email: _email,
            code: _code,
            newPassword: _password,
          );
      if (!mounted) return;
      Navigator.of(context).pushNamed(Routes.passwordComplete);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: '코드입력',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '복구 코드가 전송되었습니다. 전달 받은 코드를 입력하고\n'
                    '새 비밀번호를 설정해주세요.',
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  OtpInput(
                    length: 4,
                    onChanged: (v) => setState(() => _code = v),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        '코드를 못 받으셨나요?',
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _resend,
                        child: Text(
                          '코드 재전송',
                          style: AppType.label1.sb
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _clock,
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // ── New password ────────────────────────────────────────
                  const _Label('새 비밀번호'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _password,
                    onChanged: (v) => setState(() => _password = v),
                    hintText: '새 비밀번호를 입력해주세요',
                    obscureText: true,
                    leftIcon: const Icon(Icons.lock_outline),
                  ),
                  _ErrorText(_passwordError),
                  const SizedBox(height: 20),
                  const _Label('새 비밀번호 확인'),
                  const SizedBox(height: 8),
                  InputField(
                    value: _passwordConfirm,
                    onChanged: (v) => setState(() => _passwordConfirm = v),
                    hintText: '새 비밀번호를 재입력해주세요',
                    obscureText: true,
                    leftIcon: const Icon(Icons.lock_outline),
                  ),
                  _ErrorText(_confirmError),
                  _ErrorText(_error),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      text: _submitting ? '처리 중...' : '입력 완료',
                      disabled: _submitting || !_canSubmit,
                      onPressed: _submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A left-padded secondary field label.
class _Label extends StatelessWidget {
  const _Label(this.text);

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

/// Inline error helper line; renders nothing when [text] is null.
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
