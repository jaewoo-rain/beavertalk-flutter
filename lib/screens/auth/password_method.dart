import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 1 — enter the email to receive a reset code.
///
/// Figma `screen/auth_findpw_method` (`2117:19818`). Real backend: "Send email"
/// calls `requestPasswordReset(email)`; on success it advances to
/// [Routes.passwordCode] passing the email as the route argument.
class PasswordMethodScreen extends ConsumerStatefulWidget {
  /// Creates the password-method screen.
  const PasswordMethodScreen({super.key});

  @override
  ConsumerState<PasswordMethodScreen> createState() =>
      _PasswordMethodScreenState();
}

class _PasswordMethodScreenState extends ConsumerState<PasswordMethodScreen> {
  final TextEditingController _email = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending) return;
    final email = _email.text.trim();
    if (email.isEmpty) {
      // TODO(i18n): localize
      setState(() => _error = 'Enter your email');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .requestPasswordReset(email);
      if (!mounted) return;
      Navigator.of(context).pushNamed(Routes.passwordCode, arguments: email);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
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
            title: 'Reset password',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing20,
                  AppSpacing.spacing24,
                  AppSpacing.spacing20,
                  AppSpacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    // TODO(i18n): localize
                    "Enter the email address where you'd like to receive "
                    'the password reset code.',
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.spacing32),
                  InputField(
                    controller: _email,
                    // TODO(i18n): localize
                    hintText: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    leftIcon: const Icon(Icons.mail_outline),
                    onSubmitted: (_) => _send(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.spacing12),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.spacing4),
                      child: Text(_error!,
                          style: AppType.label2.r
                              .copyWith(color: AppColors.error)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20, 0, AppSpacing.spacing20, AppSpacing.spacing24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      // TODO(i18n): localize
                      text: _sending ? 'Sending...' : 'Send email',
                      disabled: _sending,
                      onPressed: _send,
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
