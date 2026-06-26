import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/select_card.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 3/5 — why are you learning a language. Final onboarding step.
///
/// Figma `screen/auth_login` (`2291:21295`). A **multi-select** [SelectCard]
/// list over [mockReasons] and a pinned "Continue" button (enabled once at least
/// one reason is chosen).
///
/// "Continue" submits the whole onboarding draft (name/language/reasons) via
/// `submitOnboarding`, then invalidates `myProfileProvider` so the AuthGate —
/// seeing `onboardingCompleted == true` — shows home.
class OnboardingReasonScreen extends ConsumerStatefulWidget {
  /// Creates the learning-reason onboarding screen.
  const OnboardingReasonScreen({super.key});

  @override
  ConsumerState<OnboardingReasonScreen> createState() =>
      _OnboardingReasonScreenState();
}

class _OnboardingReasonScreenState
    extends ConsumerState<OnboardingReasonScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _next() async {
    final draft = ref.read(signupDraftProvider);
    if (draft.selectedReasonIds.isEmpty || _submitting) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).submitOnboarding(
            name: draft.name,
            language: draft.language,
            reasons: draft.reasons,
          );
      if (!mounted) return;
      // Refresh members/me → AuthGate now sees onboardingCompleted == true, so
      // the base view behind us becomes home. We surface the completion screen
      // on top (clearing the onboarding stack); its buttons then reveal home or
      // jump into the call flow.
      ref.invalidate(myProfileProvider);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.onboardingDone, (r) => r.isFirst);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(signupDraftProvider).selectedReasonIds;
    final bool canContinue = selected.isNotEmpty;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 3, total: 5),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing20,
                  AppSpacing.spacing24,
                  AppSpacing.spacing20,
                  AppSpacing.spacing24),
              children: [
                Text(
                  // TODO(i18n): localize
                  'Why are you learning a language?',
                  style: AppType.title3.b.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Text(
                  // TODO(i18n): localize
                  "We'll tailor your learning to your goals.",
                  style:
                      AppType.body1.r.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.spacing24),
                // Content data (reason title/description) is kept as-is.
                for (int i = 0; i < mockReasons.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.spacing12),
                  SelectCard(
                    title: mockReasons[i].title,
                    description: mockReasons[i].description,
                    icon: Text(
                      mockReasons[i].icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                    checked: selected.contains(mockReasons[i].id),
                    onChanged: (_) => ref
                        .read(signupDraftProvider.notifier)
                        .toggleReason(mockReasons[i].id),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.spacing16),
                  Text(_error!,
                      style:
                          AppType.label2.r.copyWith(color: AppColors.error)),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing12,
                AppSpacing.spacing20,
                AppSpacing.spacing12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                // TODO(i18n): localize
                text: _submitting ? 'Saving...' : 'Continue',
                disabled: !canContinue || _submitting,
                onPressed: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
