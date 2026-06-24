import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 2/5 — what should we call you.
///
/// Figma `screen/auth_login` (`2291:21281`). An [AppScaffold] with a
/// [GnbType.main2] progress bar (2/5), the title "당신을 어떻게 부를까요?" with a
/// subtitle, a labelled [InputField] for the name plus a helper line, and a
/// pinned primary [Button] ("다음으로") that is disabled until a name is entered.
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
            progress: const GnbProgress(current: 2, total: 5),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '당신을 어떻게 부를까요?',
                    style: AppType.title3.b.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI Tutor가 당신의 이름을 기억해요',
                    style: AppType.body1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '사용자의 이름',
                    style: AppType.body1.r.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 12),
                  InputField(
                    value: _name,
                    onChanged: (v) => setState(() => _name = v),
                    hintText: '이름을 입력해주세요',
                    onSubmitted: (_) {
                      if (_name.trim().isNotEmpty) _next();
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '실명이 아니어도 괜찮아요. 닉네임도 좋아요.',
                    style: AppType.body1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '다음으로',
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
