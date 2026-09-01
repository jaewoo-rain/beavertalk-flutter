import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../core/i18n/locale_controller.dart';
import '../../components/molecules/country_select.dart';
import '../../components/organisms/bottom_sheet_country_select.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Onboarding step 1/3 — native language picker. First onboarding step after
/// login/signup completes.
///
/// Figma `screen/onborading_language` (`2291:21265`). An [AppScaffold] with a
/// [GnbType.main2] progress bar (1/3), the prompt "What is your native
/// language?", a single-select [CountrySelect] list over [mockLanguages], and a
/// pinned primary [Button] ("Continue", disabled until a language is chosen).
/// Tapping it stores the language in the signup draft and pushes the name step
/// ([Routes.onboardingName], 2/3).
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
    // Stash the chosen native language for the onboarding submit, then advance
    // to the name step (2/3). `_next` is only reachable once a language is
    // selected (the Continue button is disabled otherwise).
    ref.read(signupDraftProvider.notifier).setLanguage(_selectedId!);
    // Switch the UI to the chosen language for the rest of onboarding.
    ref.read(localeControllerProvider.notifier).setLanguage(_selectedId!);
    Navigator.pushNamed(context, Routes.onboardingName);
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedId != null;
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 1, total: 3),
            // Team decision: back from the first onboarding step returns to the
            // sign-up screen (its form is preserved — see SignupScreen).
            onBack: () => Navigator.pushNamed(context, Routes.signup),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
                children: [
                  Text(
                    l10n.onboardingLanguageTitle,
                    style: AppType.title3.b.copyWith(color: context.c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  // Content data (language names) is kept as-is, not localized.
                  for (final lang in mockLanguages)
                    CountrySelect(
                      name: lang.name,
                      flag: countryFlag(lang.countryCode),
                      selected: _selectedId == lang.id,
                      onSelect: () => _select(lang.id),
                    ),
                ],
              ),
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: AppSpacing.s12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.continueLabel,
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
