import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../components/atoms/button.dart';

/// Onboarding — completion. Figma `screen/onborading_done` (`2291:21311`).
///
/// Reached after the final onboarding step ([OnboardingReasonScreen]) submits
/// the draft. A centered beaver avatar with a welcome heading + sub copy, and a
/// pinned two-button row: a secondary "Home" (drops to the now-onboarded home)
/// and a primary "Call now" (jumps straight into the call flow).
class OnboardingDoneScreen extends StatelessWidget {
  /// Creates the onboarding completion screen.
  const OnboardingDoneScreen({super.key});

  /// Reveals the home view behind this screen (AuthGate now shows home since
  /// onboarding is complete).
  void _goHome(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);

  /// Jumps straight into the call flow, clearing this screen from the stack.
  void _startCall(BuildContext context) => Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.callLoading, (r) => r.isFirst);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Beaver avatar — Figma 120px circle.
                  Container(
                    width: AppSpacing.s120,
                    height: AppSpacing.s120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: beaverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Figma: avatar → text frame gap = 20px (ds-space-screen-x).
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    l10n.onboardingDoneTitle,
                    textAlign: TextAlign.center,
                    style: AppType.heading2.sb.copyWith(color: context.c.labelStrong),
                  ),
                  // Figma: heading → sub copy gap = 8px (ds-space-xs).
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.onboardingDoneSubtitle,
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                ],
              ),
            ),
          ),
          // Figma `BottomSheet` two-button row: pt 12, px 20, gap 10.
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s12,
                AppSpacing.s20,
                AppSpacing.s12),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    type: BtnType.secondaryOutline,
                    size: BtnSize.s60,
                    text: l10n.home,
                    onPressed: () => _goHome(context),
                  ),
                ),
                const SizedBox(width: 10), // Figma 10px gap (no AppSpacing token)
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.callNow,
                    onPressed: () => _startCall(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
