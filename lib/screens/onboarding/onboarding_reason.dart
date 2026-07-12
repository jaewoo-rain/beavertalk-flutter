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
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 3, total: 3),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20,
                  AppSpacing.s24,
                  AppSpacing.s20,
                  AppSpacing.s24),
              children: [
                Text(
                  l10n.onboardingReasonTitle,
                  style: AppType.title3.b.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.onboardingReasonSubtitle,
                  style:
                      AppType.body1.r.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.s24),
                // Reason copy is localized by id (the mock data holds Korean
                // fallbacks); the emoji icon stays as-is.
                for (int i = 0; i < mockReasons.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.s12),
                  SelectCard(
                    title: _reasonTitle(context, mockReasons[i].id) ??
                        mockReasons[i].title,
                    description: _reasonDesc(context, mockReasons[i].id) ??
                        mockReasons[i].description,
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
                  const SizedBox(height: AppSpacing.s16),
                  Text(_error!,
                      style:
                          AppType.label2.r.copyWith(color: AppColors.error)),
                ],
              ],
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
                text: _submitting ? l10n.savingLabel : l10n.continueLabel,
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

/// Localized title for a learning-reason [id]; null if unknown (caller falls
/// back to the mock's Korean copy). Keeps the reason list's ids as the single
/// source of truth while the display text is fully localized.
String? _reasonTitle(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  switch (id) {
    case 'travel':
      return l10n.reasonTravelTitle;
    case 'career':
      return l10n.reasonCareerTitle;
    case 'exam':
      return l10n.reasonExamTitle;
    case 'daily':
      return l10n.reasonDailyTitle;
    case 'friends':
      return l10n.reasonFriendsTitle;
    case 'brain':
      return l10n.reasonBrainTitle;
  }
  return null;
}

/// Localized description for a learning-reason [id]; null if unknown.
String? _reasonDesc(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  switch (id) {
    case 'travel':
      return l10n.reasonTravelDesc;
    case 'career':
      return l10n.reasonCareerDesc;
    case 'exam':
      return l10n.reasonExamDesc;
    case 'daily':
      return l10n.reasonDailyDesc;
    case 'friends':
      return l10n.reasonFriendsDesc;
    case 'brain':
      return l10n.reasonBrainDesc;
  }
  return null;
}
