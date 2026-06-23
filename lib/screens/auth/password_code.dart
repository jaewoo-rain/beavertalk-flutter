import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/otp_input.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 2 — enter the 4-digit verification code.
///
/// Figma `screen/auth_findpw_code` (`2117:19861`). A [GnbType.main] header
/// ("코드입력"), a guidance line, a local 4-box OTP field ([OtpInput]) with
/// auto-advance, a mock countdown / resend row, and a primary "입력 완료" button
/// that advances to [Routes.passwordComplete].
///
/// Mock only: any 4 digits are accepted; the countdown is cosmetic.
class PasswordCodeScreen extends StatefulWidget {
  /// Creates the password-code screen.
  const PasswordCodeScreen({super.key});

  @override
  State<PasswordCodeScreen> createState() => _PasswordCodeScreenState();
}

class _PasswordCodeScreenState extends State<PasswordCodeScreen> {
  /// Total seconds in the (mock) entry window — Figma copy says "2분".
  static const int _windowSeconds = 120;

  String _code = '';
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restartCountdown();
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

  bool get _complete => _code.length == 4;

  void _submit() {
    if (!_complete) return;
    Navigator.of(context).pushNamed(Routes.passwordComplete);
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
                    '복구 코드가 귀하에게 전송되었습니다.\n'
                    '전달 받은 코드를 2분 안에 입력 하셔야 합니다.',
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  OtpInput(
                    length: 4,
                    onChanged: (v) => setState(() => _code = v),
                    onCompleted: (_) => _submit(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Text(
                        '코드를 못 받으셨나요?',
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _restartCountdown,
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
                      text: '입력 완료',
                      disabled: !_complete,
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
