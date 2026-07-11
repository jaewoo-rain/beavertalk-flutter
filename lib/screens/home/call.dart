import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/call_toggle_button.dart';
import '../../components/atoms/speaking_equalizer.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/molecules/hint_card.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../l10n/app_localizations.dart';
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

  /// turn_id of the hint the learner has revealed (peek → full). Ephemeral UI
  /// state: a new hint carries a new turn_id, so the card auto-collapses.
  String? _revealedTurnId;

  /// Currently shown suggestion index in the revealed hint; reset per new hint.
  int _suggestionIndex = 0;

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
    // Beaver's live line (real field). The translation line below has no server
    // field yet — see the AI-line block (stub).
    final beaverSubtitle = ref.watch(
      normalCallControllerProvider.select((s) => s.beaverSubtitle),
    );
    final hint = ref.watch(normalCallControllerProvider.select((s) => s.hint));
    final subtitleOn =
        ref.watch(normalCallControllerProvider.select((s) => s.subtitleOn));
    final hintOn =
        ref.watch(normalCallControllerProvider.select((s) => s.hintOn));
    // Selected character (member `character_id`) → partner name + avatar, so the
    // call shows the avatar the user picked (resolved from the catalog, not a
    // hardcoded id→name guess).
    final characterId =
        ref.watch(myProfileProvider).valueOrNull?.characterId;
    final selectedChar = ref.watch(selectedCharacterProvider);
    final selectedCharUrl = selectedChar?.imageUrl;
    final partnerImage = (selectedCharUrl != null && selectedCharUrl.isNotEmpty)
        ? NetworkImage(selectedCharUrl) as ImageProvider
        : characterImage(characterId);

    // Navigate to wrap-up when the call ends (hangUp or server call_ended).
    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      // A new hint (different turn_id) resets the ephemeral suggestion index;
      // the revealed flag auto-resets since _revealedTurnId won't match.
      if (prev?.hint?.turnId != next.hint?.turnId && _suggestionIndex != 0) {
        setState(() => _suggestionIndex = 0);
      }
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
                    selectedChar?.name ?? characterName(characterId),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface2,
                      image: DecorationImage(
                        image: partnerImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Caption zone: the beaver's live subtitle (server `output_transcript`)
            // when subtitles are on, else the speaking equalizer (Figma 자막on/off
            // variants). The subtitle shows only when a real line has arrived — no
            // hardcoded placeholder, so a fake line never appears mid-call
            // (QA: "통화 시 beaver의 자막 오류"; the stub translation line was removed).
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s32, AppSpacing.s16, AppSpacing.s32, 0),
              child: subtitleOn
                  ? Text(
                      beaverSubtitle,
                      textAlign: TextAlign.center,
                      style: AppType.body1.sb.copyWith(color: AppColors.text),
                    )
                  : const Center(child: SpeakingEqualizer()),
            ),
            // Hint card (Figma `card/hint`) — only when hints are enabled and a
            // hint has arrived (question turns only; may never arrive → no card).
            if (hintOn && hint != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s32, AppSpacing.s24, AppSpacing.s32, 0),
                child: HintCard(
                  examples: hint.examples,
                  revealed: _revealedTurnId == hint.turnId,
                  index: _suggestionIndex,
                  onReveal: () {
                    // First reveal only: mark it and signal the server exactly
                    // once (it downgrades this turn's learning evidence).
                    setState(() => _revealedTurnId = hint.turnId);
                    ref
                        .read(normalCallControllerProvider.notifier)
                        .sendHintUsed(hint.turnId);
                  },
                  onCycle: () => setState(() => _suggestionIndex =
                      (_suggestionIndex + 1) % hint.examples.length),
                  // btn/speak deferred: no in-call TTS source wired yet.
                ),
              ),
            // Hint / subtitle toggles (Figma `Frame 1707484597`, right-aligned).
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s32, AppSpacing.s24, AppSpacing.s32, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CallToggleButton(
                    icon: AppIcons.lightbulb,
                    active: hintOn,
                    activeFill: AppColors.hintAccent,
                    semanticLabel: 'Hint',
                    onChanged: (v) => ref
                        .read(normalCallControllerProvider.notifier)
                        .setHintOn(v),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  CallToggleButton(
                    icon: AppIcons.cc,
                    active: subtitleOn,
                    activeFill: AppColors.surface2,
                    semanticLabel: 'Subtitle',
                    onChanged: (v) => ref
                        .read(normalCallControllerProvider.notifier)
                        .setSubtitleOn(v),
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
                  label: l10n.endCall,
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
