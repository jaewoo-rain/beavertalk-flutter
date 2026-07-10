import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Network error — Figma `screen/network_error` (`2117:20406`).
///
/// A centered error illustration (📡 stand-in for the Figma 3D asset — mock),
/// a "연결에 실패했어요" heading + sub copy. The bottom is the Figma
/// `two-button-row`: a secondary "홈으로" (returns to [Routes.home]) and a
/// primary "다시 시도" (pops back to retry).
class NetworkErrorScreen extends StatelessWidget {
  /// Creates the network error screen.
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      homeVariant: HomeIndicatorVariant.subTransparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Error illustration — Figma 3D asset (`281:20345`).
                          Image.asset(
                            'assets/images/error_3d.png',
                            width: AppSpacing.s100,
                            height: AppSpacing.s100,
                          ),
                          const SizedBox(height: AppSpacing.s20),
                          Text(
                            l10n.connectionFailedTitle,
                            textAlign: TextAlign.center,
                            style: AppType.heading2.sb,
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            l10n.connectionFailedBody,
                            textAlign: TextAlign.center,
                            style: AppType.label1.r
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, AppSpacing.s12, AppSpacing.s20, AppSpacing.s24),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    type: BtnType.secondaryOutline,
                    size: BtnSize.s60,
                    text: l10n.goHome,
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(Routes.home, (r) => false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.retry,
                    onPressed: () => Navigator.maybePop(context),
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
