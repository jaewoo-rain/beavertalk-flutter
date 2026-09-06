import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
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
      setState(
          () => _error = AppLocalizations.of(context).passwordMethodEmailRequired);
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
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.passwordResetTitle,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: ContentColumn(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.passwordMethodDescription,
                      style: AppType.label1.r
                          .copyWith(color: context.c.labelNormal),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    InputField(
                      controller: _email,
                      hintText: l10n.emailAddressHint,
                      keyboardType: TextInputType.emailAddress,
                      leftIcon: AppIcons.mail(color: context.c.labelStrong),
                      onSubmitted: (_) => _send(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.s12),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: AppSpacing.s4),
                        child: Text(_error!,
                            style: AppType.label2.r
                                .copyWith(color: context.c.accentForegroundRed)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: _sending ? l10n.passwordMethodSending : l10n.passwordMethodSendEmail,
                disabled: _sending,
                onPressed: _send,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
