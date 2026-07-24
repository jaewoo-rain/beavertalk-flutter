import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/normalcall/presentation/avatar_view.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/presentation/video_avatar.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Live call — Figma `workspace / call_main_facetime` (`3965:16099`).
///
/// A FaceTime-style full-screen call: a dark background, a status header
/// (connected dot + character name + live `mm:ss` timer), a large full-width
/// avatar feed (the live talking [BeaverAvatar] for rigged characters, else the
/// static portrait), the beaver's live subtitle, and a red hang-up button.
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
  /// FaceTime call surface is always dark (Figma `#181A20`), independent of the
  /// app light/dark theme — a call is an immersive, fixed-dark screen.
  static const Color _bg = Color(0xFF181A20);

  /// Connected-status dot (Figma Brand/Primary `#00FFB2`).
  static const Color _connectedDot = Color(0xFF00FFB2);

  /// Subtle text (Figma Text&Icons/Subtle `#B0B0B0`).
  static const Color _subtle = Color(0xFFB0B0B0);

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
    final l10n = AppLocalizations.of(context);
    await showDialogBasic<void>(
      context,
      title: l10n.freeCallEndingTitle,
      description: l10n.freeCallEndingBody,
      variant: DialogBasicVariant.twoVertical,
      primary: DialogAction(
        label: l10n.subscribe,
        onPressed: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.pushNamed(context, Routes.payment);
        },
      ),
      secondary: DialogAction(
        label: l10n.endCall,
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
    final l10n = AppLocalizations.of(context);
    final elapsed = ref.watch(
      normalCallControllerProvider.select((s) => s.elapsedSec),
    );
    // Beaver's live line (server `output_transcript`, accumulated per turn).
    final beaverSubtitle = ref.watch(
      normalCallControllerProvider.select((s) => s.beaverSubtitle),
    );
    // Selected character → name + avatar (resolved from the catalog).
    final characterId = ref.watch(myProfileProvider).valueOrNull?.characterId;
    final selectedChar = ref.watch(selectedCharacterProvider);
    final selectedCharUrl = selectedChar?.imageUrl;
    final partnerImage = (selectedCharUrl != null && selectedCharUrl.isNotEmpty)
        ? NetworkImage(selectedCharUrl) as ImageProvider
        : characterImage(characterId);
    // Characters with a generated talking-avatar sprite set get the live rigged
    // avatar (lip-sync + expression); others fall back to their static portrait.
    final callNotifier = ref.read(normalCallControllerProvider.notifier);
    final avatarDir = avatarAssetDirFor(
      characterId,
      selectedChar?.name ?? characterName(characterId),
    );

    // Navigate to wrap-up when the call ends (hangUp or server call_ended).
    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      if (next.phase == CallPhase.ended) {
        _goFinish(next.callId, next.elapsedSec, next.baselineCallId);
      } else if (next.phase == CallPhase.error) {
        if (_navigated) return;
        _navigated = true;
        final msg = next.errorMsg ?? l10n.callEnded;
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
        background: _bg,
        statusVariant: StatusBarVariant.whiteTransparent,
        homeVariant: HomeIndicatorVariant.whiteTransparent,
        body: Column(
          children: [
            // Status header — connected dot + name + live timer (Figma top).
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: AppSpacing.s12),
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
                          color: _connectedDot,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Text(
                        'Connected',
                        style: AppType.label1.r.copyWith(color: _subtle),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    selectedChar?.name ?? characterName(characterId),
                    style: AppType.body1.sb.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    _formatted(elapsed),
                    style: AppType.label1.r.copyWith(color: _subtle),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            // Avatar band — a full-width, contained "video feed" (Figma `image
            // 1`: a bounded band with dark space above and below, not a
            // full-height fill). The neural talking clips play here.
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              child: avatarDir != null
                  ? VideoAvatar(
                      assetDir: avatarDir,
                      speaking: callNotifier.avatarSpeaking,
                      // Until the neural clips load (or for characters that ship
                      // only sprites) fall back to the rigged avatar.
                      fallback: BeaverAvatar(
                        assetDir: avatarDir,
                        level: callNotifier.avatarLevel,
                        speaking: callNotifier.avatarSpeaking,
                        emotion: callNotifier.avatarEmotion,
                        shape: callNotifier.avatarShape,
                      ),
                    )
                  : Image(image: partnerImage, fit: BoxFit.cover),
            ),
            const Spacer(flex: 1),
            // Subtitle — beaver's live line (Figma bold white). The translation
            // line below it in the design has no server field yet, so only the
            // real line renders (no fabricated text).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Text(
                beaverSubtitle,
                textAlign: TextAlign.center,
                style:
                    AppType.body1.sb.copyWith(color: Colors.white, height: 1.5),
              ),
            ),
            const Spacer(flex: 3),
            // End-call button — red 60px circular hang-up (Figma `#FA2838`).
            Center(
              child: Semantics(
                button: true,
                label: l10n.endCall,
                child: Material(
                  color: const Color(0xFFFA2838),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _confirmEnd,
                    child: SizedBox(
                      width: AppSpacing.s60,
                      height: AppSpacing.s60,
                      child: Center(
                        child: AppIcons.callEnd(size: 32, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }
}
