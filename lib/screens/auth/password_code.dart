import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/otp_input.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 1 (of the two-step verify → set-password flow): enter
/// the emailed 6-digit recovery code.
///
/// Figma `screen/auth_findpw_code` (`2117:19861`). Real backend: the email is
/// passed as the route argument; "Next" calls
/// [AuthController.verifyRecoveryCode] (Supabase `verifyOTP`, which establishes
/// a recovery session) → on success advances to [Routes.passwordNew] (where the
/// new password is set), forwarding the email for display. "Resend code"
/// re-requests a code.
class PasswordCodeScreen extends ConsumerStatefulWidget {
  /// Creates the password-code screen.
  const PasswordCodeScreen({super.key});

  @override
  ConsumerState<PasswordCodeScreen> createState() =>
      _PasswordCodeScreenState();
}

class _PasswordCodeScreenState extends ConsumerState<PasswordCodeScreen> {
  /// Total seconds in the entry window — Figma copy says "2 min" and the
  /// backend recovery-OTP expiry is also 2 min, so the timer mirrors it.
  static const int _windowSeconds = 120;

  String _email = '';
  String _code = '';
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

  bool get _canSubmit => _code.length == 6;

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

  /// Verifies the emailed code (step 1). On success a recovery session is
  /// established and we advance to the new-password screen.
  Future<void> _submit() async {
    if (_submitting || !_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .verifyRecoveryCode(email: _email, code: _code);
      if (!mounted) return;
      Navigator.of(context).pushNamed(Routes.passwordNew, arguments: _email);
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
            // TODO(i18n): localize
            title: 'Enter code',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20, AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    // TODO(i18n): localize
                    "We've sent a recovery code to your email. Enter it to "
                    'continue.',
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  OtpInput(
                    length: 6,
                    onChanged: (v) => setState(() => _code = v),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  Row(
                    children: [
                      // Wrap lets the prompt + resend flow to a second line if
                      // the localized text grows; the timer stays at the end.
                      Expanded(
                        child: Wrap(
                          spacing: 6, // Figma 6px gap (no AppSpacing token)
                          children: [
                            Text(
                              // TODO(i18n): localize
                              "Didn't get the code?",
                              style: AppType.label1.r
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: _resend,
                              child: Text(
                                // TODO(i18n): localize
                                'Resend code',
                                style: AppType.label1.sb
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Text(
                        _clock,
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  _ErrorText(_error),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      // TODO(i18n): localize
                      text: _submitting ? 'Verifying...' : 'Next',
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

/// Inline error helper line; renders nothing when [text] is null.
class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s8, left: AppSpacing.s4),
      child: Text(
        text!,
        style: AppType.label2.r.copyWith(color: AppColors.error),
      ),
    );
  }
}
