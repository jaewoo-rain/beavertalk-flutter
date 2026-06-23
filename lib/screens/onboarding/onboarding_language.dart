import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/country_select.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 1/5 — native language picker.
///
/// Figma `screen/auth_login` (`2291:21265`). Renders an [AppScaffold] with a
/// [GnbType.main2] progress bar (1/5), the prompt "What is your native
/// language?", a single-select [CountrySelect] list over [mockLanguages], and a
/// pinned primary [Button] ("다음으로") that is disabled until a language is
/// chosen. Tapping it navigates to [Routes.login].
class OnboardingLanguageScreen extends StatefulWidget {
  /// Creates the language-selection onboarding screen.
  const OnboardingLanguageScreen({super.key});

  @override
  State<OnboardingLanguageScreen> createState() =>
      _OnboardingLanguageScreenState();
}

class _OnboardingLanguageScreenState extends State<OnboardingLanguageScreen> {
  /// Id of the currently selected language, or `null` when none is chosen.
  String? _selectedId;

  void _select(String id) => setState(() => _selectedId = id);

  void _next() => Navigator.pushNamed(context, Routes.login);

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedId != null;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 1, total: 5),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                Text(
                  'What is your native language?',
                  style: AppType.title3.b.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 28),
                for (final lang in mockLanguages)
                  CountrySelect(
                    name: lang.name,
                    flag: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                    selected: _selectedId == lang.id,
                    onSelect: () => _select(lang.id),
                  ),
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
