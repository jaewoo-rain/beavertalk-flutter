import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Call connecting — Figma `screen/call_loading` (`2117:19923`).
///
/// A dark full-screen "연결 중..." state shown while the WebSocket connects and
/// the server prepares its automatic opening line. It renders the [beaverImage]
/// avatar, a spinner, and a status line, with a top-left close button.
///
/// On [initState] it calls `NormalCallController.start(characterId)` (no button —
/// the opening line is server-triggered, plan §8-3). The `characterId` arrives
/// as the route's `arguments` (set by home), defaulting to `1`. It then listens
/// to the controller: `inCall` → `pushReplacement(Routes.call)`; `error` →
/// guidance + back home. The close (X) hangs up and returns home (§8-2).
class CallLoadingScreen extends ConsumerStatefulWidget {
  /// Creates the call-connecting screen.
  const CallLoadingScreen({super.key});

  @override
  ConsumerState<CallLoadingScreen> createState() => _CallLoadingScreenState();
}

class _CallLoadingScreenState extends ConsumerState<CallLoadingScreen> {
  bool _navigated = false;

  /// `Frame 4` (`3360:19104`) — the spinner (32) + gap (12) + 연결 중's line
  /// box (24). This is the box the frame centres on the screen.
  static const double _groupHeight = AppSpacing.s32 + AppSpacing.s12 + 24;

  @override
  void initState() {
    super.initState();
    // Start after the first frame so route arguments are available and we can
    // safely read providers.
    WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
  }

  /// Reads the character id from route arguments and starts the call.
  void _begin() {
    final args = ModalRoute.of(context)?.settings.arguments;
    final characterId = args is int ? args : 1;
    ref.read(normalCallControllerProvider.notifier).start(characterId);
  }

  /// Cancels connecting and returns home.
  Future<void> _cancel() async {
    await ref.read(normalCallControllerProvider.notifier).hangUp();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // React to phase transitions.
    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      if (_navigated) return;
      if (next.phase == CallPhase.inCall) {
        _navigated = true;
        Navigator.pushReplacementNamed(context, Routes.call);
      } else if (next.phase == CallPhase.error) {
        _navigated = true;
        final msg = next.errorMsg ?? l10n.callConnectFailed;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);
      }
    });

    return AppScaffold(
      // `common/dark-&-white` (#111111), not `surface` — this screen is darker
      // than the rest of the app on purpose.
      background: AppColors.black,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Stack(
        children: [
          // The frame (`3360:19104`) centres **only** the spinner + 연결 중
          // group (`Frame 4`, 68 tall) and hangs the hint below it — centring
          // all three together, as this used to, pushes the spinner ~8.5px
          // above where the design puts it.
          Center(
            child: SizedBox(
              width: double.infinity,
              height: _groupHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: AppSpacing.s32,
                          height: AppSpacing.s32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.text),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          l10n.connecting,
                          style: AppType.body1.r.copyWith(color: AppColors.text),
                        ),
                      ],
                    ),
                  ),
                  // The frame pins this 9.5 below the group — a residue of
                  // absolute positioning against a half-pixel-centred box, so
                  // it rounds to the 8 token.
                  Positioned(
                    top: _groupHeight + AppSpacing.s8,
                    left: 0,
                    right: 0,
                    child: Text(
                      l10n.connectingHint,
                      textAlign: TextAlign.center,
                      style: AppType.label2.r
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Top-right close button → hang up + home (Figma GNB, 56 tall).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Semantics(
                      button: true,
                      label: l10n.close,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _cancel,
                        child:
                            AppIcons.close(size: 28, color: AppColors.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
