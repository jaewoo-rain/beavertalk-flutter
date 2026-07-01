import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/icons/brand_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/molecules/password_eye_toggle.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Auth — signup. Figma `screen/auth_signup` (`2117:19739`).
///
/// A simple form (email + password + confirm). "Sign up" calls
/// `signup(email, password)` which auto-logs in; the AuthGate then routes to
/// onboarding (language → name → reason) since `onboardingCompleted` is false.
///
/// The "Log in" prompt pops back to the login flow.
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

  bool _obscurePassword = true; // password field hidden by default
  bool _obscureConfirm = true; // confirm field hidden by default
  bool _submitting = false; // signup in progress
  String? _error;

  /// Password length rule shown beneath the password field (8–16 chars).
  String? get _passwordError {
    if (_password.isEmpty) return null;
    if (_password.length < 8 || _password.length > 16) {
      // TODO(i18n): localize
      return 'Password must be 8–16 characters.';
    }
    return null;
  }

  /// Confirm-match rule shown beneath the confirm field.
  String? get _confirmError {
    if (_passwordConfirm.isEmpty) return null;
    // TODO(i18n): localize
    if (_passwordConfirm != _password) return "Passwords don't match.";
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
      // TODO(i18n): localize
      setState(() => _error = 'Please check your input.');
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
      // Clear any stale cached profile so the AuthGate refetches members/me
      // fresh. This runs before the AuthGate's (next-frame) rebuild, so a
      // previous member's "home" can't flash before the new user's onboarding
      // (QA 5).
      ref.invalidate(myProfileProvider);
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

  /// Social sign-up is not wired yet (mock placeholder).
  void _socialSignup() {
    // TODO: wire social sign-up (Kakao / Google / Apple).
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          // TODO(i18n): localize
          Gnb.main(title: 'Sign up', onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Email ───────────────────────────────────────────────
                  // TODO(i18n): localize
                  const _FieldLabel('Email'),
                  const SizedBox(height: AppSpacing.s8),
                  InputField(
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    // TODO(i18n): localize
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    leftIcon: const MailIcon(
                        size: 20, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  // ── Password ────────────────────────────────────────────
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
                  _ErrorText(_passwordError),
                  const SizedBox(height: AppSpacing.s20),
                  // ── Password confirm ────────────────────────────────────
                  // TODO(i18n): localize
                  const _FieldLabel('Confirm password'),
                  const SizedBox(height: AppSpacing.s8),
                  InputField(
                    value: _passwordConfirm,
                    onChanged: (v) => setState(() => _passwordConfirm = v),
                    // TODO(i18n): localize
                    hintText: 'Re-enter your password',
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
                  // ── Server / validation error ───────────────────────────
                  _ErrorText(_error),
                  const SizedBox(height: AppSpacing.s32),
                  // ── Signup (auto-logs in; AuthGate routes to onboarding) ─
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    // TODO(i18n): localize
                    text: _submitting ? 'Signing up...' : 'Sign up',
                    disabled: _submitting || !_canSubmit,
                    onPressed: _signup,
                  ),
                  const SizedBox(height: AppSpacing.s48),
                  // ── Social sign-up row (Kakao / Google / Apple) ─────────
                  _SocialButtonRow(onPressed: _socialSignup),
                  const SizedBox(height: AppSpacing.s24),
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

/// Inline error helper line shown beneath a field; renders nothing when [text]
/// is null.
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

/// Three equal-width social sign-up buttons (Kakao / Google / Apple),
/// matching the Figma `screen/auth_signup` footer row.
class _SocialButtonRow extends StatelessWidget {
  const _SocialButtonRow({required this.onPressed});

  /// Tapped on any social button (all mocked for now).
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

/// "Already have an account? Log in" inline prompt.
class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLogin});

  /// Tapped when "Log in" is pressed.
  final VoidCallback onLogin;

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
          'Already have an account?',
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onLogin,
          child: Text(
            // TODO(i18n): localize
            'Log in',
            style: AppType.label1.sb.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
