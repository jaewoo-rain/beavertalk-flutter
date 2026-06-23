import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/select_card.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 3/5 — why are you learning a language.
///
/// Figma `screen/auth_login` (`2291:21295`). An [AppScaffold] with a
/// [GnbType.main2] progress bar (3/5), the title "언어 학습을 하는 이유가
/// 뭔가요?" with the subtitle "당신에게 필요한 학습을 진행할게요", a
/// single-select [SelectCard] list over [mockReasons], and a pinned primary
/// [Button] ("다음으로") that is disabled until a reason is chosen. Tapping it
/// navigates to [Routes.home].
class OnboardingReasonScreen extends StatefulWidget {
  /// Creates the learning-reason onboarding screen.
  const OnboardingReasonScreen({super.key});

  @override
  State<OnboardingReasonScreen> createState() => _OnboardingReasonScreenState();
}

class _OnboardingReasonScreenState extends State<OnboardingReasonScreen> {
  /// Id of the currently selected reason, or `null` when none is chosen.
  String? _selectedId;

  void _next() => Navigator.pushNamed(context, Routes.home);

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedId != null;

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
                    checked: _selectedId == mockReasons[i].id,
                    onChanged: (_) =>
                        setState(() => _selectedId = mockReasons[i].id),
                  ),
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
