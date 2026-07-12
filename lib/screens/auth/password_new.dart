import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/molecules/password_eye_toggle.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 2 (of the two-step verify → set-password flow): set a
/// new password after the recovery code has been verified.
///
/// Reached from `password_code` once [AuthController.verifyRecoveryCode]
/// succeeds and establishes a recovery session; "Submit" calls
/// [AuthController.updatePassword] (which uses that active session — no token is
/// threaded between screens) → on success goes to [Routes.passwordComplete].
///
/// The email may be passed as the route argument for display only; the password
/// update relies on the recovery session, not the email.
class PasswordNewScreen extends ConsumerStatefulWidget {
  /// Creates the new-password screen.
  const PasswordNewScreen({super.key});

  @override
  ConsumerState<PasswordNewScreen> createState() => _PasswordNewScreenState();
}

class _PasswordNewScreenState extends ConsumerState<PasswordNewScreen> {
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _obscurePassword = true; // new password hidden by default
  bool _obscureConfirm = true; // confirm hidden by default
  bool _submitting = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String) _email = arg;
  }

  String? get _passwordError {
    if (_password.isEmpty) return null;
    if (_password.length < 8 || _password.length > 16) {
      return AppLocalizations.of(context).passwordLengthError;
    }
    return null;
  }

  String? get _confirmError {
    if (_passwordConfirm.isEmpty) return null;
    if (_passwordConfirm != _password) {
      return AppLocalizations.of(context).passwordsDoNotMatch;
    }
    return null;
  }

  bool get _canSubmit =>
      _password.isNotEmpty &&
      _passwordConfirm.isNotEmpty &&
      _passwordError == null &&
      _confirmError == null;

  Future<void> _submit() async {
    if (_submitting || !_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .updatePassword(newPassword: _password);
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
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.passwordNewTitle,
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
                    _email.isEmpty
                        ? l10n.passwordNewDescription
                        : l10n.passwordNewDescriptionEmail(_email),
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  // ── New password ────────────────────────────────────────
                  _Label(l10n.fieldNewPasswordLabel),
                  const SizedBox(height: AppSpacing.s8),
                  InputField(
                    value: _password,
                    onChanged: (v) => setState(() => _password = v),
                    hintText: l10n.newPasswordHint,
                    obscureText: _obscurePassword,
                    leftIcon:
                        AppIcons.lock(size: 20, color: AppColors.textSecondary),
                    rightIcon: PasswordEyeToggle(
                      obscured: _obscurePassword,
                      onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  _ErrorText(_passwordError),
                  const SizedBox(height: AppSpacing.s20),
                  _Label(l10n.fieldConfirmNewPasswordLabel),
                  const SizedBox(height: AppSpacing.s8),
                  InputField(
                    value: _passwordConfirm,
                    onChanged: (v) => setState(() => _passwordConfirm = v),
                    hintText: l10n.confirmNewPasswordHint,
                    obscureText: _obscureConfirm,
                    leftIcon:
                        AppIcons.lock(size: 20, color: AppColors.textSecondary),
                    rightIcon: PasswordEyeToggle(
                      obscured: _obscureConfirm,
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  _ErrorText(_confirmError),
                  _ErrorText(_error),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s24),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: _submitting ? l10n.passwordNewSubmitting : l10n.passwordNewSubmit,
                disabled: _submitting || !_canSubmit,
                onPressed: _submit,
              ),
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
      padding: const EdgeInsets.only(left: AppSpacing.s8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
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
      padding: const EdgeInsetsDirectional.only(
          top: AppSpacing.s8, start: AppSpacing.s4),
      child: Text(
        text!,
        style: AppType.label2.r.copyWith(color: AppColors.error),
      ),
    );
  }
}
