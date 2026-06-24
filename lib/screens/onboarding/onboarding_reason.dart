import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/select_card.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 3/5 — why are you learning a language. Final onboarding step.
///
/// Figma `screen/auth_login` (`2291:21295`). A **multi-select** [SelectCard]
/// list over [mockReasons] and a pinned "다음으로" button (enabled once at least
/// one reason is chosen).
///
/// "다음으로" submits the whole onboarding draft (name/language/reasons) via
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
      // Refresh members/me → AuthGate now sees onboardingCompleted == true and
      // shows home; drop the onboarding stack.
      ref.invalidate(myProfileProvider);
      Navigator.of(context).popUntil((r) => r.isFirst);
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                Text(
                  '언어 학습을 하는 이유가 뭔가요?',
                  style: AppType.title3.b.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  '당신에게 필요한 학습을 진행할게요',
                  style:
                      AppType.body1.r.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                for (int i = 0; i < mockReasons.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
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
                  const SizedBox(height: 16),
                  Text(_error!,
                      style:
                          AppType.label2.r.copyWith(color: AppColors.error)),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: _submitting ? '저장 중...' : '다음으로',
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
