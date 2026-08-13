import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/call_toggle_button.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/atoms/speaking_equalizer.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/molecules/hint_card.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/incoming_call/services/lockscreen_call_service.dart';
import '../../features/normalcall/presentation/avatar_view.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/presentation/sync_avatar.dart';
import '../../l10n/app_localizations.dart';
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

  /// Clearance between the avatar feed and the caption slot below it.
  ///
  /// Measured across all four Figma variants (`3969:20583`/`20610`/`20634`/
  /// `20656`), where it holds at ~70 whether the slot carries the subtitle or
  /// the equalizer. Not an [AppSpacing] step — the design uses the gap to park
  /// the feed at a fixed distance above the caption, so rounding it to s60/s72
  /// visibly moves the feed.
  static const double _feedToCaptionGap = 70;

  // DEBUG(audio-glitch): true면 아바타 비디오(SyncAvatar/ExoPlayer)를 끄고 정적 이미지만.
  //   기본은 false(아바타 ON) — 제품 그대로의 부하에서 재생이 버티는지가 판정 기준이다.
  //   아바타 OFF 로 두면 실제로 출시되지 않는 구성을 측정하게 되므로 격리 실험 때만 true.
  //   (재생 플러그인 로컬 패치본 적용 후 재검증: packages/flutter_pcm_sound)
  static const bool kDisableAvatarVideo = false;

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

  /// The partner's still image, or a skeleton while the catalog resolves.
  ///
  /// Fills the 16:9 avatar band either way, so the frame does not resize when
  /// the real image arrives.
  Widget _partnerStill(ImageProvider? image) {
    if (image != null) return Image(image: image, fit: BoxFit.cover);
    return const SkeletonShimmer(child: Skeleton.box(width: 1080, height: 607));
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
          // v2 §2-3 ④: the in-house checkout is gone — selling happens on
          // the paywall, buying on the OS payment sheet.
          Navigator.pushNamed(context, Routes.paywallPro);
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

  /// 통화가 끝나 이 화면을 떠난다.
  ///
  /// 잠금화면 통화였고 아직 잠겨 있으면 앱을 뒤로 보내고 [inApp] 은 실행하지 않는다.
  /// 그 상태에서 [inApp] 의 화면 전환을 하면 **잠금화면 위에 앱 화면이 남아 잠금 우회**가
  /// 된다. 잠금 통화가 아니었거나 사용자가 통화 중 잠금을 풀었으면 평소 흐름을 탄다.
  ///
  /// 뒤로 보낸 뒤에도 **화면 스택은 홈으로 되돌린다.** 통화 화면을 그대로 두면 나중에
  /// 사용자가 앱을 열었을 때 끝난 통화 화면이 멈춘 채로 남는다 — 타이머가 종료 시각에
  /// 멈춰 있고, 종료 버튼을 눌러도 이미 `ended` 라 아무 일도 일어나지 않는다. 이 전환은
  /// 앱이 이미 백그라운드라 사용자 눈에 보이지 않는다.
  ///
  /// 호출자가 `_navigated` 를 이미 세운 뒤에 부르므로 중복 진입은 여기서 다루지 않는다.
  Future<void> _leave(VoidCallback inApp) async {
    final backgrounded = await const LockscreenCallService().exitIfLocked();
    if (!mounted) return;
    // 끝난 통화의 상태를 소비 처리한다. 안 하면 phase 가 `ended` 로 남아, 다음에 통화를
    // 걸어도 call_loading 이 새 통화 대신 지난 통화의 요약 화면으로 보낸다.
    // 화면 전환 **전에** 부른다 — 전환 뒤에는 이 위젯이 dispose 되어 ref 를 쓸 수 없다.
    ref.read(normalCallControllerProvider.notifier).clearFinished();
    if (backgrounded) {
      Navigator.of(context).popUntil((r) => r.isFirst);
      return;
    }
    inApp();
  }

  /// Advances to the wrap-up screen, carrying the analyzable call id, the final
  /// duration, and the pre-call baseline so a manual hang-up can recover its id.
  void _goFinish(String? callId, int elapsedSec, int? baselineCallId) {
    if (_navigated) return;
    _navigated = true;
    _leave(
      () => Navigator.pushReplacementNamed(
        context,
        Routes.callFinish,
        arguments: (
          callId: callId,
          elapsedSec: elapsedSec,
          baselineCallId: baselineCallId,
        ),
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
    final subtitleOn = ref.watch(
      normalCallControllerProvider.select((s) => s.subtitleOn),
    );
    final hintOn = ref.watch(
      normalCallControllerProvider.select((s) => s.hintOn),
    );
    // 이 통화의 상대는 **서버가 정한다**(`call_started`). 예약전화는 알람마다
    // 캐릭터가 달라서, 대표 캐릭터로 그리면 대화 상대와 화면 얼굴이 어긋난다.
    // 도착 전(연결 중)·구버전 서버에서는 null 이라 대표 캐릭터로 폴백한다.
    final serverCharacterId = ref.watch(
      normalCallControllerProvider.select((s) => s.characterId),
    );
    final characterId = serverCharacterId ??
        ref.watch(myProfileProvider).valueOrNull?.characterId;
    final selectedChar = ref.watch(characterByIdProvider(characterId));
    final selectedCharUrl = selectedChar?.imageUrl;
    // Null until the catalog resolves. Deliberately NOT defaulted to
    // [characterImage]: that map answers an unmatched id with **Judi's**
    // picture (it predates the current server ids — 1 is Baba, not Bibi), so
    // the call opened on a different character's face. A skeleton is shown
    // instead until the real image is known.
    final partnerImage = (selectedCharUrl != null && selectedCharUrl.isNotEmpty)
        ? NetworkImage(selectedCharUrl) as ImageProvider
        : null;
    final callNotifier = ref.read(normalCallControllerProvider.notifier);
    final avatarDir = avatarAssetDirFor(
      characterId,
      selectedChar?.name,
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
        // 잠금화면 통화의 실패도 잠금화면으로 돌아가야 한다. 여기서 홈으로 보내면
        // 키가드 위에 홈 화면이 남는다(스낵바도 볼 사람이 없다).
        _leave(() {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(msg)));
          Navigator.of(context).popUntil((r) => r.isFirst);
        });
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
                horizontal: 10,
                vertical: AppSpacing.s12,
              ),
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
                      Text(
                        l10n.connected,
                        style: AppType.label1.r.copyWith(
                          color: context.c.labelNormal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    // Empty when neither the catalog nor the id map can name the
                    // partner. The id map used to answer any unknown id with
                    // "Bibi", so a Baba user watched the wrong name for the
                    // whole call; a blank line is the honest version.
                    selectedChar?.name ?? '',
                    style: AppType.body1.sb.copyWith(
                      color: context.c.labelStrong,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    _formatted(elapsed),
                    style: AppType.label1.r.copyWith(
                      color: context.c.labelNormal,
                    ),
                  ),
                ],
              ),
            ),
            // Body — the feed, the caption slot and the hint card are ONE
            // bottom-anchored block, not a feed pinned to the top with the rest
            // hanging below it.
            //
            // That is what the four Figma variants encode: the feed starts at
            // y=279 with hints off and y=140 with them on, i.e. the hint card
            // pushes the feed *up* by its own height rather than opening a gap
            // under a fixed feed. Scrollable so a long subtitle plus a card can
            // never overflow on a short screen.
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  // No horizontal padding here — the feed is full-bleed; only
                  // the caption block below is inset.
                  padding: const EdgeInsets.only(bottom: AppSpacing.s24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 16:9 avatar feed — full width, capped at [_avatarMaxWidth].
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _avatarMaxWidth,
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRect(
                              child: avatarDir != null && !kDisableAvatarVideo
                                  ? SyncAvatar(
                                      assetDir: avatarDir,
                                      level: callNotifier.avatarLevel,
                                      speaking: callNotifier.avatarSpeaking,
                                      emotion: callNotifier.avatarEmotion,
                                      idleKind: callNotifier.avatarIdleKind,
                                      // A still image, NOT [BeaverAvatar].
                                      //
                                      // SyncAvatar shows this while its idle/talk
                                      // clips initialize (~100–300ms on Android),
                                      // and BeaverAvatar is the sprite lip-sync
                                      // renderer that the video approach replaced.
                                      // Handing it back as the fallback meant every
                                      // call opened with a few hundred ms of the
                                      // retired renderer before the video took
                                      // over — visibly a different avatar.
                                      //
                                      // Same still the kDisableAvatarVideo path
                                      // below uses, so the two agree.
                                      fallback: _partnerStill(partnerImage),
                                    )
                                  : _partnerStill(partnerImage),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: _feedToCaptionGap),
                      // Caption slot + hint card.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // The slot carries the subtitle when subtitles are on
                            // and the 5-bar equalizer when they are off — the two
                            // never coexist in any Figma variant. Without the
                            // equalizer a subtitles-off call showed nothing at all
                            // here, so a silent beaver was indistinguishable from a
                            // stalled one.
                            if (showSubtitle)
                              Text(
                                beaverSubtitle,
                                textAlign: TextAlign.center,
                                style: AppType.body1.sb.copyWith(
                                  color: context.c.labelStrong,
                                ),
                              )
                            else
                              const SpeakingEqualizer(),
                            if (showHint) ...[
                              const SizedBox(height: AppSpacing.s24),
                              HintCard(
                                examples: hint.examples,
                                revealed: _revealedTurnId == hint.turnId,
                                index: _suggestionIndex,
                                onReveal: () {
                                  setState(() => _revealedTurnId = hint.turnId);
                                  ref
                                      .read(
                                        normalCallControllerProvider.notifier,
                                      )
                                      .sendHintUsed(hint.turnId);
                                },
                                onCycle: () => setState(
                                  () => _suggestionIndex =
                                      (_suggestionIndex + 1) %
                                      hint.examples.length,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer — hint/subtitle toggles + hang-up.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s32,
                vertical: AppSpacing.s12,
              ),
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
                              size: 32,
                              color: context.c.staticWhite,
                            ),
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
