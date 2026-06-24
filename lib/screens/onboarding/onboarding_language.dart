import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/country_select.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 1/5 — native language picker. Shown first, before login.
///
/// Figma `screen/auth_login` (`2291:21265`). Renders an [AppScaffold] with a
/// [GnbType.main2] progress bar (1/5), the prompt "What is your native
/// language?", a single-select [CountrySelect] list over [mockLanguages], and a
/// pinned primary [Button] ("다음으로") that is disabled until a language is
/// chosen. Tapping it stores the language in the signup draft; the [AuthGate]
/// then rebuilds into the login screen (no manual navigation).
class OnboardingLanguageScreen extends ConsumerStatefulWidget {
  /// Creates the language-selection onboarding screen.
  const OnboardingLanguageScreen({super.key});

  @override
  ConsumerState<OnboardingLanguageScreen> createState() =>
      _OnboardingLanguageScreenState();
}

class _OnboardingLanguageScreenState
    extends ConsumerState<OnboardingLanguageScreen> {
  /// Id of the currently selected language, or `null` when none is chosen.
  String? _selectedId;

  void _select(String id) => setState(() => _selectedId = id);

  void _next() {
    // Stash the chosen language for the onboarding submit (sent later). The
    // AuthGate watches the draft and rebuilds into the login screen — no manual
    // navigation needed here.
    if (_selectedId != null) {
      ref.read(signupDraftProvider.notifier).setLanguage(_selectedId!);
    }
  }

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
