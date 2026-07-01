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
import '../../theme/app_spacing.dart';
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
  /// Avatar ring — the dark muted teal sampled from Figma `screen/call_main`
  /// (`2296:26242`, ~`#143E38`). The brighter `green700` used before rendered
  /// as an over-saturated green glow (QA: "아이콘 이상한 그라데이션").
  static const Color _avatarRing = Color(0xFF163A33);

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

  /// Advances to the wrap-up screen, carrying the analyzable call id, the final
  /// call duration (seconds), and the pre-call [baselineCallId] so a manually
  /// ended call (no `call_ended`/id) can recover its id from `GET /calls`.
  void _goFinish(String? callId, int elapsedSec, int? baselineCallId) {
    if (_navigated) return;
    _navigated = true;
    Navigator.pushReplacementNamed(
      context,
      Routes.callFinish,
      arguments: (
        callId: callId,
        elapsedSec: elapsedSec,
        baselineCallId: baselineCallId,
      ),
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
        _goFinish(next.callId, next.elapsedSec, next.baselineCallId);
      } else if (next.phase == CallPhase.error) {
        if (_navigated) return;
        _navigated = true;
        final msg = next.errorMsg ?? '통화가 종료되었습니다.';
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.s12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: AppSpacing.s8,
                        height: AppSpacing.s8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Text(
                        'Connected',
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    mockPartnerName,
                    style: AppType.body1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppSpacing.s4),
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
                  width: AppSpacing.s140,
                  height: AppSpacing.s140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _avatarRing, // ring (Figma dark teal)
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: AppSpacing.s120,
                    height: AppSpacing.s120,
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
            // Beaver's live subtitle (server `output_transcript`). Shown only
            // when a real line has arrived — no hardcoded placeholder, so a fake
            // line never appears mid-call (QA: "통화 시 beaver의 자막 오류"). The
            // earlier English translation line was a stub with no server field
            // and has been removed (QA: "아래 자막 삭제").
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s32, AppSpacing.s16, AppSpacing.s32, AppSpacing.s24),
              child: Text(
                beaverSubtitle,
                textAlign: TextAlign.center,
                style: AppType.body1.sb.copyWith(color: AppColors.text),
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
                    color: AppColors.accentRed,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _confirmEnd,
                      child: SizedBox(
                        width: AppSpacing.s60,
                        height: AppSpacing.s60,
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
