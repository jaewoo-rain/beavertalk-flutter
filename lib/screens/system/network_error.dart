import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// The network-error body — Figma `screen/network_error` (`3360:19658`).
///
/// A centered error illustration, the "연결에 실패했어요" heading and a reason
/// line, over the Figma `two-button-row`: a secondary 홈으로 and a primary
/// 다시 시도.
///
/// **This is a view, not a screen, because the failure it reports is usually
/// local to one region.** Every load failure in the app used to draw its own
/// inline block — eight different shapes across records, archive, alarms,
/// avatars, payments, analysis and the learning report. Routing all of them to
/// a pushed screen would have been worse than the fragmentation: a failed
/// 보관함 fetch would cover the tab bar, so the one thing the user could still
/// usefully do — switch to the other tab — would disappear along with the data.
/// So this drops into whatever box the caller gives it (typically the
/// `Expanded` under a GNB) and [onRetry] refetches in place.
/// [NetworkErrorScreen] wraps it for the cases that really are whole-screen.
///
/// **Two button layouts, and the design system already draws both.**
/// `Empty/Screen` variant `type=error` is a copy block over a *single* 다시 시도,
/// stacked inline; `screen/network_error` is the whole screen with a pinned
/// 홈으로 | 다시 시도 footer. Regional errors take the first: a tab body still
/// has its tabs and a GNB back arrow above it, so a 홈으로 would be the third
/// way out of a screen that already has two, and a screen-level pinned footer
/// inside a tab reads as if it belonged to the tab bar. [showHome] picks the
/// footer layout and defaults to the regional one.
class NetworkErrorView extends StatelessWidget {
  /// Creates the network-error body.
  const NetworkErrorView({
    super.key,
    required this.onRetry,
    this.message,
    this.onHome,
    this.showHome = false,
  });

  /// Refetches whatever failed, **without leaving the screen** — callers pass
  /// `ref.invalidate(theProvider)`.
  ///
  /// Nullable and `required` on purpose: some failures have nothing to retry
  /// (a learning report opened without a `callId` has no request to re-run).
  /// Passing null hides the retry button rather than offering one that cannot
  /// work, and 홈으로 widens to fill the row. Making it required forces that
  /// call to be a decision rather than an omission.
  final VoidCallback? onRetry;

  /// The server's reason for the failure, shown instead of the generic copy.
  /// Callers pass `e is AppException ? e.message : null`.
  final String? message;

  /// Overrides the 홈으로 destination. Defaults to unwinding to [Routes.home].
  /// Ignored unless [showHome].
  final VoidCallback? onHome;

  /// Whether to draw the whole-screen 홈으로 | 다시 시도 footer instead of the
  /// regional single-CTA layout. Only [NetworkErrorScreen] sets this.
  final bool showHome;

  void _goHome(BuildContext context) => Navigator.of(context)
      // Keep the AuthGate root ((r) => r.isFirst, not => false): AuthGate is
      // what swaps to login/home on auth changes, so removing it would strand
      // a later session-expiry with no redirect. Consistent with every other
      // "go home" in the app.
      .pushNamedAndRemoveUntil(Routes.home, (r) => r.isFirst);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
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
                          message ?? l10n.connectionFailedBody,
                          textAlign: TextAlign.center,
                          style: AppType.label1.r
                              .copyWith(color: context.c.labelNormal),
                        ),
                        // Regional: the CTA sits with the copy (Empty/Screen
                        // `type=error` stacks Copy + CTA at gap 20), not pinned
                        // to the bottom of whatever box this landed in.
                        if (!showHome && onRetry != null) ...[
                          const SizedBox(height: AppSpacing.s20),
                          // Full width (335 at 375), like the frame. The column
                          // centers its children, so without this the button
                          // would hug its label — and "Retry" is short enough
                          // that it reads as a chip rather than the screen's
                          // primary action.
                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              type: BtnType.primaryFill,
                              size: BtnSize.s60,
                              text: l10n.retry,
                              onPressed: onRetry,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showHome)
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
                    onPressed: onHome ?? () => _goHome(context),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      text: l10n.retry,
                      onPressed: onRetry,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Network error as a whole screen — [NetworkErrorView] on an [AppScaffold].
///
/// For failures that own the entire screen rather than one region. Registered
/// at [Routes.networkError]; retry pops back to whatever pushed it, since a
/// pushed error screen has no provider of its own to invalidate.
class NetworkErrorScreen extends StatelessWidget {
  /// Creates the network error screen.
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      homeVariant: HomeIndicatorVariant.subTransparent,
      body: NetworkErrorView(
        showHome: true,
        onRetry: () => Navigator.maybePop(context),
      ),
    );
  }
}
