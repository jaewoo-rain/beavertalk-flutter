import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../features/auth/presentation/providers/signup_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
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
  /// Length bounds, kept identical to `edit_nickname` — the same value is
  /// edited there, so the two screens must agree.
  static const _maxLength = 12;
  static const _minLength = 2;

  /// The current name text (controlled value for the [InputField]).
  String _name = '';

  void _next() {
    // Stash the nickname for the onboarding submit (sent later).
    ref.read(signupDraftProvider.notifier).setName(_name.trim());
    Navigator.pushNamed(context, Routes.onboardingReason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 2 자 하한은 `edit_nickname` 과 같다 — 여기서 1 자를 허용하면 나중에
    // 수정 화면에서 저장이 막히는 덫이 된다.
    final bool canContinue = _name.trim().length >= _minLength;

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
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
                    l10n.onboardingNameTitle,
                    style: AppType.title3.b.copyWith(color: context.c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.onboardingNameSubtitle,
                    style: AppType.body1.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    l10n.nameLabel,
                    style: AppType.body1.r.copyWith(color: context.c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  InputField(
                    value: _name,
                    onChanged: (v) => setState(() => _name = v),
                    hintText: l10n.nameHint,
                    // Same rule the nickname editor states and enforces
                    // (`edit_nickname`): English letters + digits, 2–12. This
                    // screen used to accept anything, so a member could set a
                    // name here that the editor would then refuse to save.
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    ],
                    maxLength: _maxLength,
                    onSubmitted: (_) {
                      if (canContinue) _next();
                    },
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.nicknameRule,
                    style: AppType.body1.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.nameHelper,
                    style: AppType.body1.r
                        .copyWith(color: context.c.labelNormal),
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
