import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 2/3 — what should we call you.
///
/// Figma `screen/auth_login` (`2291:21281`). An [AppScaffold] with a
/// [GnbType.main2] progress bar (2/3), the title "What should we call you?"
/// with a subtitle, a labelled [InputField] for the name plus a helper line, and
/// a pinned primary [Button] ("Continue") that is disabled until a name is
/// entered.
/// Tapping it navigates to [Routes.onboardingReason].
class OnboardingNameScreen extends ConsumerStatefulWidget {
  /// Creates the name onboarding screen.
  const OnboardingNameScreen({super.key});

  @override
  ConsumerState<OnboardingNameScreen> createState() =>
      _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends ConsumerState<OnboardingNameScreen> {
  /// The current name text (controlled value for the [InputField]).
  String _name = '';

  void _next() {
    // Stash the nickname for the onboarding submit (sent later).
    ref.read(signupDraftProvider.notifier).setName(_name.trim());
    Navigator.pushNamed(context, Routes.onboardingReason);
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _name.trim().isNotEmpty;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 2, total: 3),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20,
                  AppSpacing.s24,
                  AppSpacing.s20,
                  AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    // TODO(i18n): localize
                    'What should we call you?',
                    style: AppType.title3.b.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    // TODO(i18n): localize
                    'Your AI tutor will remember your name.',
                    style: AppType.body1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    // TODO(i18n): localize
                    'Your name',
                    style: AppType.body1.r.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  InputField(
                    value: _name,
                    onChanged: (v) => setState(() => _name = v),
                    // TODO(i18n): localize
                    hintText: 'Enter your name',
                    onSubmitted: (_) {
                      if (_name.trim().isNotEmpty) _next();
                    },
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    // TODO(i18n): localize
                    "It doesn't have to be your real name — a nickname works too.",
                    style: AppType.body1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s12,
                AppSpacing.s20,
                AppSpacing.s12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                // TODO(i18n): localize
                text: 'Continue',
                disabled: !canContinue,
                onPressed: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
