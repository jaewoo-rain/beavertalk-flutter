import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/call_toggle_button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/molecules/hint_card.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/normalcall/presentation/avatar_view.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/presentation/sync_avatar.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Live call — Figma `workspace / screen/call_main` (`3969:20656` and its
/// 자막/힌트 on·off variants).
///
/// A video call: a themed (Dark/Light) surface, a status header (connected dot +
/// character name + live timer), a full-width **16:9 avatar feed** (capped at
/// [_avatarMaxWidth]) playing the neural talking clips, the beaver's subtitle
/// (when subtitles are on), an in-call hint card (when hints are on and a hint
/// arrived), the hint/subtitle toggles, and a red hang-up button.
///
/// End paths all funnel through `NormalCallController.hangUp()` (plan §8-2):
/// the end-call dialog and the system back gesture ([PopScope]).
class CallScreen extends ConsumerStatefulWidget {
  /// Creates the live call screen.
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  /// Max width of the 16:9 avatar feed — full mobile width, capped on large
  /// screens so the video doesn't stretch edge-to-edge on tablets.
  static const double _avatarMaxWidth = 520;

  bool _navigated = false;

  /// turn_id of the hint the learner has revealed (peek → full). Ephemeral: a
  /// new hint carries a new turn_id, so the card auto-collapses.
  String? _revealedTurnId;

  /// Currently shown suggestion index in the revealed hint; reset per new hint.
  int _suggestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Catch up on a transition that landed before this screen mounted. `ref.listen`
    // only fires on *change*, so a call that ended during the route push would
    // otherwise strand the user on a frozen live-call screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final s = ref.read(normalCallControllerProvider);
      if (s.phase == CallPhase.ended) {
        _goFinish(s.callId, s.elapsedSec, s.baselineCallId);
      }
    });
  }

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
          Navigator.of(context).pop();
          Navigator.pushNamed(context, Routes.payment);
        },
      ),
      secondary: DialogAction(
        label: l10n.endCall,
        onPressed: () {
          Navigator.of(context).pop();
          ref.read(normalCallControllerProvider.notifier).hangUp();
        },
      ),
    );
  }

  /// Advances to the wrap-up screen, carrying the analyzable call id, the final
  /// duration, and the pre-call baseline so a manual hang-up can recover its id.
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
    final beaverSubtitle = ref.watch(
      normalCallControllerProvider.select((s) => s.beaverSubtitle),
    );
    final hint = ref.watch(normalCallControllerProvider.select((s) => s.hint));
    final subtitleOn =
        ref.watch(normalCallControllerProvider.select((s) => s.subtitleOn));
    final hintOn =
        ref.watch(normalCallControllerProvider.select((s) => s.hintOn));
    final characterId = ref.watch(myProfileProvider).valueOrNull?.characterId;
    final selectedChar = ref.watch(selectedCharacterProvider);
    final selectedCharUrl = selectedChar?.imageUrl;
    final partnerImage = (selectedCharUrl != null && selectedCharUrl.isNotEmpty)
        ? NetworkImage(selectedCharUrl) as ImageProvider
        : characterImage(characterId);
    final callNotifier = ref.read(normalCallControllerProvider.notifier);
    final avatarDir = avatarAssetDirFor(
      characterId,
      selectedChar?.name ?? characterName(characterId),
    );

    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      // A new hint (different turn_id) resets the ephemeral suggestion index.
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

    final showSubtitle = subtitleOn && beaverSubtitle.isNotEmpty;
    final showHint = hintOn && hint != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(normalCallControllerProvider.notifier).hangUp();
      },
      child: AppScaffold(
        background: context.c.backgroundNormalNormal,
        statusVariant: StatusBarVariant.whiteTransparent,
        homeVariant: HomeIndicatorVariant.whiteTransparent,
        body: Column(
          children: [
            // Header — connected dot + name + live timer.
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.c.primaryNormal,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Text('Connected',
                          style:
                              AppType.label1.r.copyWith(color: context.c.labelNormal)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    selectedChar?.name ?? characterName(characterId),
                    style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(_formatted(elapsed),
                      style:
                          AppType.label1.r.copyWith(color: context.c.labelNormal)),
                ],
              ),
            ),
            // Body — 16:9 avatar feed at the top, subtitle + hint pushed to the
            // bottom (Figma Body `justify-between`). The caption area is
            // bottom-aligned and scrollable so a long line + hint card can never
            // overflow the column on short screens.
            Expanded(
              child: Column(
                children: [
                  // 16:9 avatar feed — full width, capped at [_avatarMaxWidth].
                  Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: _avatarMaxWidth),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRect(
                          child: avatarDir != null
                              ? SyncAvatar(
                                  assetDir: avatarDir,
                                  level: callNotifier.avatarLevel,
                                  speaking: callNotifier.avatarSpeaking,
                                  emotion: callNotifier.avatarEmotion,
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
                      ),
                    ),
                  ),
                  // Subtitle + hint card — bottom-aligned, scrollable on
                  // overflow.
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.s32,
                            AppSpacing.s16, AppSpacing.s32, AppSpacing.s24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        if (showSubtitle)
                          Text(
                            beaverSubtitle,
                            textAlign: TextAlign.center,
                            style: AppType.body1.sb
                                .copyWith(color: context.c.labelStrong),
                          ),
                        if (showSubtitle && showHint)
                          const SizedBox(height: AppSpacing.s24),
                        if (showHint)
                          HintCard(
                            examples: hint.examples,
                            revealed: _revealedTurnId == hint.turnId,
                            index: _suggestionIndex,
                            onReveal: () {
                              setState(() => _revealedTurnId = hint.turnId);
                              ref
                                  .read(normalCallControllerProvider.notifier)
                                  .sendHintUsed(hint.turnId);
                            },
                            onCycle: () => setState(() => _suggestionIndex =
                                (_suggestionIndex + 1) % hint.examples.length),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer — hint/subtitle toggles + hang-up.
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s32, vertical: AppSpacing.s12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CallToggleButton(
                        icon: AppIcons.lightbulb,
                        active: hintOn,
                        activeFill: context.c.accentActive,
                        semanticLabel: 'Hint',
                        onChanged: (v) => ref
                            .read(normalCallControllerProvider.notifier)
                            .setHintOn(v),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      CallToggleButton(
                        icon: AppIcons.cc,
                        active: subtitleOn,
                        activeFill: context.c.backgroundNormalAlternative,
                        // The subtitle fill flips with the theme, so its glyph
                        // must too (a white glyph vanishes on Light).
                        activeGlyph: context.c.labelStrong,
                        semanticLabel: 'Subtitle',
                        onChanged: (v) => ref
                            .read(normalCallControllerProvider.notifier)
                            .setSubtitleOn(v),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  Semantics(
                    button: true,
                    label: l10n.endCall,
                    child: Material(
                      color: context.c.accentBackgroundRed,
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
                                size: 32, color: context.c.staticWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
