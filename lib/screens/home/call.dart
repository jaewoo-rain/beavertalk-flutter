import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/icons/app_icons.dart';
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
  /// Hang-up button fill — Figma `Accent/Foreground/Red` (`#E52222`), which has
  /// no [AppColors] token (app red is the softer `error #FF7070`).
  static const Color _endRed = Color(0xFFE52222);

  bool _navigated = false;

  /// Formats whole [seconds] as `hh:mm:ss` (Figma `00:00:01`).
  String _formatted(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
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
    // Beaver's live line (real field). The translation line below has no server
    // field yet — see the AI-line block (stub).
    final beaverSubtitle = ref.watch(
      normalCallControllerProvider.select((s) => s.beaverSubtitle),
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
        background: AppColors.surface,
        statusVariant: StatusBarVariant.whiteTransparent,
        homeVariant: HomeIndicatorVariant.whiteTransparent,
        body: Column(
          children: [
            // Status header — connected dot + name + live timer (Figma top).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Connected',
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mockPartnerName,
                    style: AppType.body1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatted(elapsed),
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            // Avatar (120) inside a teal ring (140), centered.
            Expanded(
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green700, // ring
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface2,
                      image: DecorationImage(
                        image: beaverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // AI utterance + translation (Figma bottom block).
            // NOTE(shell): the original line is wired to `beaverSubtitle` (real),
            // but there is NO server field for the translation yet — it is left
            // as a placeholder stub. TODO(server): add a translation field and
            // wire the second line below when the API provides it.
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    beaverSubtitle.isNotEmpty
                        ? beaverSubtitle
                        : '안녕하세요. 어디 가세요?', // placeholder until a turn arrives
                    textAlign: TextAlign.center,
                    style: AppType.body1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    // TODO(server): no translation field — placeholder stub.
                    '“Hello, Where are you going?”',
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            // End-call button — red 60px circular hang-up (Figma `2296:26249`).
            SizedBox(
              height: 96,
              child: Center(
                child: Semantics(
                  button: true,
                  label: '통화 종료',
                  child: Material(
                    color: _endRed,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _confirmEnd,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: AppIcons.callEnd(
                            size: 32,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
