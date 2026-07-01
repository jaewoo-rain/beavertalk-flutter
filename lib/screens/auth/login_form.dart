import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/checkbox.dart';
import '../../components/icons/app_icons.dart';
import '../../components/icons/brand_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/molecules/password_eye_toggle.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Auth — email/password login form. Figma `screen/auth_login_form`
/// (`2117:19780`).
///
/// A [Gnb.main] titled "Log in" (back arrow pops), labelled email and password
/// [InputField]s, a "Remember me" checkbox row with a "Forgot password?" link,
/// the primary "Log in" button, the social sign-in button row, and a sign-up
/// prompt.
///
/// Real backend: "Log in" calls [AuthController.login]; on success the
/// [AuthGate] swaps to home, so we just pop the form. Failures show the inline
/// error. The find-password link routes to [Routes.passwordMethod]; "Sign up"
/// routes to [Routes.signup].
class LoginFormScreen extends ConsumerStatefulWidget {
  /// Creates the email login form screen.
  const LoginFormScreen({super.key});

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  String _email = '';
  String _password = '';
  bool _obscurePassword = true; // password hidden by default
  bool _saveId = false;
  bool _submitting = false;
  String? _error;

  /// Calls the real login endpoint. On success the AuthGate shows home; we pop
  /// the form. On failure the message is shown inline.
  Future<void> _login() async {
    if (_submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: _email.trim(), password: _password);
      if (!mounted) return;
      // AuthGate is now authenticated; leave this pushed form behind.
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Social login is not wired yet → opens the signup flow placeholder.
  void _socialLogin() => Navigator.pushNamed(context, Routes.signup);

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
          // TODO(i18n): localize
          Gnb.main(title: 'Log in', onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Email field ─────────────────────────────────────────
                  // TODO(i18n): localize
                  const _FieldLabel('Email'),
                  const SizedBox(height: AppSpacing.s8),
                  InputField(
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    // TODO(i18n): localize
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    leftIcon:
                        const MailIcon(size: 20, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  // ── Password field ──────────────────────────────────────
                  // TODO(i18n): localize
                  const _FieldLabel('Password'),
                  const SizedBox(height: AppSpacing.s8),
                  InputField(
                    value: _password,
                    onChanged: (v) => setState(() => _password = v),
                    // TODO(i18n): localize
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    leftIcon:
                        AppIcons.lock(size: 20, color: AppColors.textSecondary),
                    rightIcon: PasswordEyeToggle(
                      obscured: _obscurePassword,
                      onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  // ── Save-id checkbox + find-password link ───────────────
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // DS checkbox box only; label rendered externally so it
                        // keeps the Figma grey (AppCheckbox forces a white label).
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCheckbox(
                              value: _saveId,
                              onChanged: (v) => setState(() => _saveId = v),
                              size: AppCheckboxSize.size20,
                            ),
                            const SizedBox(width: AppSpacing.s8),
                            GestureDetector(
                              onTap: () => setState(() => _saveId = !_saveId),
                              child: Text(
                                // TODO(i18n): localize
                                'Remember me',
                                style: AppType.label1.r
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: _findPassword,
                            child: Text(
                              // TODO(i18n): localize
                              'Forgot password?',
                              textAlign: TextAlign.right,
                              style: AppType.label1.r
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Inline error (login failure) ────────────────────────
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.s20),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.s4),
                      child: Text(
                        _error!,
                        style: AppType.label2.r
                            .copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s60),
                  // ── Login (primary) ─────────────────────────────────────
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    // TODO(i18n): localize
                    text: _submitting ? 'Logging in...' : 'Log in',
                    disabled: _submitting,
                    onPressed: _login,
                  ),
                  const SizedBox(height: AppSpacing.s48),
                  // ── Social sign-in row ──────────────────────────────────
                  _SocialButtonRow(onPressed: _socialLogin),
                  const SizedBox(height: AppSpacing.s24),
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
      padding: const EdgeInsets.only(left: AppSpacing.s8),
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
        const SizedBox(width: AppSpacing.s12),
        social(const GoogleIcon(size: 24)),
        const SizedBox(width: AppSpacing.s12),
        social(const AppleIcon(size: 24, color: AppColors.text)),
      ],
    );
  }
}

/// "Don't have an account? Sign up" inline prompt.
class _SignupPrompt extends StatelessWidget {
  const _SignupPrompt({required this.onSignup});

  /// Tapped when "Sign up" is pressed.
  final VoidCallback onSignup;

  @override
  Widget build(BuildContext context) {
    // Wrap so the prompt + action can flow onto a second line if localized
    // text grows.
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6, // Figma 6px gap (no AppSpacing token)
      children: [
        Text(
          // TODO(i18n): localize
          "Don't have an account?",
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onSignup,
          child: Text(
            // TODO(i18n): localize
            'Sign up',
            style: AppType.label1.sb.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
