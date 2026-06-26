import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Live call — Figma `screen/call_main` (`2117:19932`, dialog `2117:19956`).
///
/// A dark full-screen call view bound to [normalCallControllerProvider]: the
/// [beaverImage] avatar, the [mockPartnerName], the live `mm:ss` timer driven by
/// `CallState.elapsedSec`, and an end-call button.
///
/// End paths all funnel through `NormalCallController.hangUp()` (plan §8-2):
/// - the end-call dialog's "통화 종료",
/// - the system back gesture, intercepted by [PopScope].
/// When the controller reaches `ended` (via hangUp or the server's `call_ended`)
/// the screen advances to [Routes.callFinish] with the `callId` as arguments.
class CallScreen extends ConsumerStatefulWidget {
  /// Creates the live call screen.
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  bool _navigated = false;

  /// Formats whole [seconds] as `mm:ss`.
  String _formatted(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Opens the "free call ending" dialog with subscribe / end actions.
  Future<void> _confirmEnd() async {
    await showDialogBasic<void>(
      context,
      title: '무료 통화가 끝나가요',
      description: '구독하면 비버와 더 오래 대화할 수 있어요.',
      variant: DialogBasicVariant.twoVertical,
      primary: DialogAction(
        label: '구독하기',
        onPressed: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.pushNamed(context, Routes.payment);
        },
      ),
      secondary: DialogAction(
        label: '통화 종료',
        onPressed: () {
          Navigator.of(context).pop(); // close dialog
          ref.read(normalCallControllerProvider.notifier).hangUp();
        },
      ),
    );
  }

  /// Advances to the wrap-up screen, carrying the analyzable call id.
  void _goFinish(String? callId) {
    if (_navigated) return;
    _navigated = true;
    Navigator.pushReplacementNamed(
      context,
      Routes.callFinish,
      arguments: callId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = ref.watch(
      normalCallControllerProvider.select((s) => s.elapsedSec),
    );

    // Navigate to wrap-up when the call ends (hangUp or server call_ended).
    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      if (next.phase == CallPhase.ended) {
        _goFinish(next.callId);
      } else if (next.phase == CallPhase.error) {
        if (_navigated) return;
        _navigated = true;
        final msg = next.errorMsg ?? '통화가 종료되었습니다.';
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => false);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // §8-2: back gesture hangs up; navigation happens via the ended listener.
        ref.read(normalCallControllerProvider.notifier).hangUp();
      },
      child: AppScaffold(
        background: AppColors.bg,
        statusVariant: StatusBarVariant.whiteTransparent,
        homeVariant: HomeIndicatorVariant.whiteTransparent,
        body: Column(
          children: [
            // Avatar + name + timer, centered in the available space.
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface2,
                        image: DecorationImage(
                          image: beaverImage,
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary24,
                            blurRadius: 48,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      mockPartnerName,
                      style:
                          AppType.heading2.sb.copyWith(color: AppColors.text),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatted(elapsed),
                      style: AppType.title3.m
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            // End-call button.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: '통화 종료',
                  leftIcon: const Icon(Icons.call_end),
                  onPressed: _confirmEnd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
