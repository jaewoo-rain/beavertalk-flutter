import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
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
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    // React to phase transitions.
    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      if (_navigated) return;
      if (next.phase == CallPhase.inCall) {
        _navigated = true;
        Navigator.pushReplacementNamed(context, Routes.call);
      } else if (next.phase == CallPhase.error) {
        _navigated = true;
        final msg = next.errorMsg ?? '통화 연결에 실패했습니다.';
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => false);
      }
    });

    return AppScaffold(
      background: AppColors.bg,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Stack(
        children: [
          // Centered avatar + spinner + status line.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface2,
                    image: DecorationImage(
                      image: beaverImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  mockPartnerName,
                  style: AppType.heading2.sb.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '연결 중...',
                  style: AppType.body1.r
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Top-left close button → hang up + home.
          Positioned(
            left: 8,
            top: 8,
            child: IconButton(
              onPressed: _cancel,
              icon: const Icon(Icons.close),
              color: AppColors.text,
              iconSize: 28,
              tooltip: '닫기',
            ),
          ),
        ],
      ),
    );
  }
}
