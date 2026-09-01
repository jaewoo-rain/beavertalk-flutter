import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/call_toggle_button.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/atoms/speaking_equalizer.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/molecules/hint_card.dart';
import '../../components/organisms/bottom_sheet.dart' show SheetAction;
import '../../components/organisms/bottom_sheet_content.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/incoming_call/services/lockscreen_call_service.dart';
import '../../features/normalcall/presentation/avatar_assets.dart';
import '../../features/normalcall/presentation/cascade_experiment.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/data/call_quota_mock.dart';
import '../../features/normalcall/presentation/sync_avatar.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
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

/// Free·Pro 의 원형 스틸 아바타 지름(Figma 120).
const double _stillAvatarSize = 120;

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

  /// 5분 시트를 이번 구간에서 이미 띄웠는가.
  ///
  /// 경과시간은 매초 올라오므로 조건만으로 열면 **초마다 다시 뜬다**. 「이어가기」를
  /// 누르면 다음 구간을 위해 [_limitShownAtSec] 를 갱신한다.
  int? _limitShownAtSec;

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

  /// 종료 확인 다이얼로그 — 「통화를 끝낼까요?」.
  ///
  /// ## 2026-08-18 — 구독 유도가 여기서 빠졌다
  ///
  /// 예전엔 이 자리에 `freeCallEndingTitle` + 구독 버튼이 떴다. 즉 **끊으려는 사람에게
  /// 결제를 권하는** 화면이었다. 구독 유도는 5분 한도에 걸렸을 때의 시트가 맡고, 여기는
  /// 「정말 끊을 거냐」만 묻는다.
  ///
  /// 본문이 하루 1회 차감을 알린다 — 무료 한도가 **1일 1통화**라 지금 끊으면 오늘은
  /// 다시 못 건다. 그 사실을 끊기 전에 보여 주는 것이 이 다이얼로그의 존재 이유다.
  Future<void> _confirmEnd() async {
    final l10n = AppLocalizations.of(context);
    await showDialogBasic<void>(
      context,
      title: l10n.callExitTitle,
      description: l10n.callExitSubtitle,
      variant: DialogBasicVariant.twoVertical,
      primary: DialogAction(
        label: l10n.callExitKeep,
        onPressed: () => Navigator.of(context).pop(),
      ),
      secondary: DialogAction(
        label: l10n.callExitConfirm,
        onPressed: () {
          Navigator.of(context).pop();
          ref.read(normalCallControllerProvider.notifier).hangUp();
        },
      ),
    );
  }

  /// 통화 구간 시트 — **이어갈 수 있느냐**로 갈린다. 플랜으로 직접 가르지 않는다.
  ///
  /// | 시점 | 문구 | 1차 버튼 |
  /// |---|---|---|
  /// | 상한 미만(확인) | 더 이어갈까요? | 계속 통화하기 |
  /// | 상한 도달 | 무료 통화가 끝났어요 | 구독하고 계속 대화하기 |
  ///
  /// 무료는 상한이 5분이라 첫 시트가 곧 종료 시트다. 유료는 상한이 15분이라
  /// 5·10분에 확인만 받고, 15분에 닿으면 같은 자리에서 종료로 바뀐다.
  ///
  /// ⚠ **오디오를 멈추지 않는다** — 아직 못 한다. 서버가 5분에 세션을 붙들어 주는지
  /// 확인되지 않았고(서버질문지 B-5·B-7), 클라가 임의로 끊으면 유료 사용자의 통화가
  /// 사라진다. 지금은 **묻기만** 한다.
  ///
  /// ⚠ 한도 판정은 서버 권위다. 이 시트는 경과시간으로 **띄우기만** 하고, 실제로
  /// 끊는 것은 서버의 `call_ended` 다.
  Future<void> _showLimitSheet(int atSec) async {
    final l10n = AppLocalizations.of(context);
    final quota = ref.read(callQuotaProvider);
    // 「이어갈 수 있는가」가 갈림돌이다. 상한에 닿았으면 유료여도 못 이어간다.
    final canContinue = !quota.isCeiling(atSec);
    final notifier = ref.read(normalCallControllerProvider.notifier);
    setState(() => _limitShownAtSec = atSec);

    // 시트를 읽는 동안 업링크와 경과시간을 멈춘다. 비버 재생은 그대로 둔다.
    notifier.setSessionPaused(true);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetCtx) => BottomSheetContent(
        title: canContinue ? l10n.callKeepGoingTitle : l10n.callFreeEndedTitle,
        body: canContinue ? l10n.callKeepGoingSubtitle : l10n.freePlanCallLimit,
        primaryAction: SheetAction(
          label: canContinue ? l10n.callExitKeep : l10n.callFreeEndedCta,
          onPressed: () {
            Navigator.of(sheetCtx).pop();
            if (canContinue) return;
            // 상한에 닿았으면 이 통화는 여기서 끝이다. 페이월로 보내기 **전에**
            // 끊는다 — 안 끊으면 결제 화면을 보는 내내 세션이 살아 있다.
            notifier.hangUp();
            // v2 §2-3 ④ — 파는 것은 페이월, 사는 것은 OS 결제 시트다.
            Navigator.pushNamed(context, Routes.paywallPro);
          },
        ),
        secondaryAction: SheetAction(
          label: l10n.endCall,
          onPressed: () {
            Navigator.of(sheetCtx).pop();
            notifier.hangUp();
          },
        ),
      ),
    );

    if (!mounted) return;
    // 상한에 닿았는데도 아직 살아 있다면 **클라가 끊는다.**
    //
    // 서버가 끊는 것이 진짜 한도지만, 서버가 안 끊으면 세션이 무한정 돈다.
    // 이중 안전장치다(2026-08-18 결정 Q3=②).
    final phase = ref.read(normalCallControllerProvider).phase;
    if (!canContinue && phase == CallPhase.inCall) {
      notifier.hangUp();
      return;
    }
    notifier.setSessionPaused(false);
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
    final micMuted = ref.watch(
      normalCallControllerProvider.select((s) => s.micMuted),
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
      // 상한과 확인 시점은 **다른 축**이다(CallQuota 문서 참조).
      //
      //   무료   상한 5분  → 5분에 업셀 시트. 계속할 수 없다
      //   유료   상한 15분 → 5·10분에 확인 시트. 15분은 서버가 끊는다
      //
      // 경과시간은 매초 오므로 **같은 초에 두 번 열지 않게** 막는다.
      final q = ref.read(callQuotaProvider);
      if (next.phase == CallPhase.inCall &&
          _limitShownAtSec != next.elapsedSec &&
          (q.isCheckIn(next.elapsedSec) || q.isCeiling(next.elapsedSec))) {
        _showLimitSheet(next.elapsedSec);
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
    // 격리 실험: 캐스케이드는 **순정으로 벗겨서** 먼저 돌린다(라이브는 제품 그대로).
    // 판정은 CascadeExperiment.enabledFor 한 곳에서만 — 릴리즈에서는 항상 켬이다.
    final channel =
        ref.watch(normalCallControllerProvider.select((s) => s.channel));
    final showHint = hintOn &&
        hint != null &&
        CascadeExperiment.enabledFor(channel, CascadeExperiment.hints);
    final showAvatarVideo = !kDisableAvatarVideo &&
        CascadeExperiment.enabledFor(channel, CascadeExperiment.avatarVideo);
    // Max 만 영상 아바타를 받는다. 상태 조회가 아직 안 왔거나 실패하면 무료로
    // 떨어져 원형 스틸이 된다 — 제한 쪽으로 기우는 폴백이라 유료 기능이 새지 않는다.
    //
    // ⚠ [SubscriptionStatus.isPlanInferred] 를 같이 보지 않는 이유:
    //   그 플래그는 「tier 를 읽은 게 아니라 **가정**했다」는 뜻이고, 리졸버의 가정은
    //   언제나 **Pro** 다(서버 와이어에 plan 필드가 없어서다). 즉 가정으로 max 가 되는
    //   경로가 없다 — 가정은 늘 제한 쪽으로 떨어진다. 여기서 `!isPlanInferred` 를
    //   덧붙이면 **서버가 확인해 준 Max 사용자까지** 스틸로 내려가 없던 손해가 생긴다.
    //   Max 를 **부여**하는 판단이 아니라 **표현**을 고르는 자리라 tier 로 충분하다.
    final avatarIsVideo =
        ref.watch(subscriptionStatusProvider).tier == SubscriptionTier.max;

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
            ContentColumn(
              gutter: 10,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
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
                      // 아바타 — **플랜이 표현을 가른다**(Figma 04_통화).
                      //
                      //   Max      전폭 16:9 영상 밴드
                      //   Free/Pro 원형 스틸 120
                      //
                      // 영상 아바타는 Max 의 값어치다. 예전엔 이 분기가 없어서
                      // 무료 사용자도 전폭 영상을 봤다 — 설계와 달랐다.
                      //
                      // ⚠ [showAvatarVideo] 와 혼동하지 마라. 그건 안드로이드
                      //   오디오 끊김 격리 실험용 디버그 플래그이지 플랜이 아니다.
                      //   둘 다 참이어야 영상이 나간다.
                      if (!avatarIsVideo)
                        _CircularStill(
                          size: _stillAvatarSize,
                          level: callNotifier.avatarLevel,
                          child: _partnerStill(partnerImage),
                        )
                      else
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _avatarMaxWidth,
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRect(
                              child: avatarDir != null && showAvatarVideo
                                  ? SyncAvatar(
                                      assetDir: avatarDir,
                                      level: callNotifier.avatarLevel,
                                      speaking: callNotifier.avatarSpeaking,
                                      emotion: callNotifier.avatarEmotion,
                                      idleKind: callNotifier.avatarIdleKind,
                                      // [계측] 화면은 그대로다 — 영상 쪽에서 일어난
                                      // 일을 통화 계측 스트림에 얹기만 한다.
                                      onDiag: callNotifier.onAvatarDiag,
                                      // 정적 이미지다. SyncAvatar 가 idle·talk
                                      // 클립을 여는 동안(안드로이드 100~300ms)
                                      // 이걸 보여 준다.
                                      //
                                      // 예전엔 여기에 스프라이트 렌더러를 물려
                                      // 놓아, 통화를 열 때마다 **은퇴한 렌더러의
                                      // 얼굴**이 몇백 ms 스쳤다 — 다른 아바타로
                                      // 보였다. 그 렌더러는 2026-08-31 에 자산째
                                      // 지웠다(53.2MB).
                                      //
                                      // 아래 kDisableAvatarVideo 경로도 같은 정적
                                      // 이미지를 쓰므로 둘이 어긋나지 않는다.
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
            ContentColumn(
              gutter: AppSpacing.s32,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
              child: Column(
                children: [
                  // 힌트·자막은 **두 모드에서 같다** — 같은 기능, 같은 자리.
                  // 통로에 따라 달라지는 것은 그 오른쪽의 마이크와 중앙 버튼뿐이다.
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
                      const SizedBox(width: AppSpacing.s8),
                      _MicToggleButton(
                        muted: micMuted,
                        semanticLabel:
                            micMuted ? l10n.callMicUnmute : l10n.callMicMute,
                        onChanged: (m) => ref
                            .read(normalCallControllerProvider.notifier)
                            .setMicMuted(m),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  Semantics(
                    button: true,
                    label: l10n.callExitConfirm,
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

/// 원형 스틸 아바타 — Free·Pro 의 아바타 표현.
///
/// Max 의 전폭 16:9 영상 밴드와 **같은 자리**에 놓이지만 모양이 다르다. 링은
/// 배경과 대비를 만들어 원이 어두운 화면에 묻히지 않게 한다(Figma).
///
/// ## 웅웅 퍼지는 헤일로
///
/// [level] 은 **비버 음성의 RMS** 다(`avatarLevel`). 비버가 말하는 동안 원 바깥으로
/// 두 겹의 파문이 퍼진다 — 정지 이미지라 「지금 말하는 중」을 알릴 다른 수단이 없다.
///
/// ⚠ 이 신호는 **재생 오디오**에서 온다. 그래서 음소거를 눌러도 계속 움직인다 —
/// 그게 맞다. 음소거는 내 목소리를 막는 것이지 비버를 멈추는 것이 아니다.
///
/// ⛔ [ValueListenableBuilder] 로 **헤일로만** 다시 그린다. 아바타 이미지까지 리빌드에
///   넣으면 초당 수십 번 디코딩이 돈다.
class _CircularStill extends StatelessWidget {
  const _CircularStill({
    required this.size,
    required this.child,
    this.level,
  });

  final double size;
  final Widget child;

  /// 비버 음성 레벨(0~1). null 이면 헤일로 없이 정지 상태로 그린다.
  final ValueListenable<double>? level;

  /// 헤일로가 최대로 퍼지는 폭. 이만큼을 미리 비워 둬야 퍼질 때 레이아웃이 안 밀린다.
  static const double _maxHalo = 28;

  @override
  Widget build(BuildContext context) {
    final ring = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.c.primaryHeavy, width: 4),
      ),
      child: ClipOval(child: child),
    );

    final lv = level;
    if (lv == null) return Center(child: ring);

    return Center(
      child: SizedBox(
        width: size + _maxHalo * 2,
        height: size + _maxHalo * 2,
        child: ValueListenableBuilder<double>(
          valueListenable: lv,
          builder: (context, raw, _) {
            final v = raw.clamp(0.0, 1.0);
            final c = context.c;
            return Stack(
              alignment: Alignment.center,
              children: [
                // 바깥 파문 — 크게 퍼지고 옅다.
                _halo(size + _maxHalo * 2 * v, c.primaryHeavy, 0.10 * v),
                // 안쪽 파문 — 링에 붙어 따라다닌다.
                _halo(size + _maxHalo * 1.1 * v, c.primaryHeavy, 0.18 * v),
                ring,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _halo(double d, Color color, double alpha) => AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: alpha),
        ),
      );
}

/// 마이크 음소거 토글 — **꺼진 상태를 표시하는** 버튼이다.
///
/// ## 왜 [CallToggleButton] 을 안 쓰나
///
/// 저 위젯은 「기능이 켜졌다」를 칠하는 물건이다. 힌트·자막은 꺼진 게 기본이라 그게 맞다.
/// 그런데 마이크는 **열린 게 기본**이다. 같은 규칙을 적용하면 평상시에 혼자 칠해져 있고,
/// 정작 알려야 할 음소거 상태가 「칠이 빠진」 모습이 된다 — 사용자는 그걸 못 읽는다.
///
/// 실기기에서 실제로 그렇게 나왔다(2026-08-18). 로그상 업링크는 정확히 끊겼는데
/// **사장님이 「음소거가 안 되는 것 같다」고 판단**했다. 기능이 아니라 표시의 문제였다.
///
/// ⇒ 뒤집는다. 평상시엔 힌트·자막과 **같은 빈 칩**이고, 음소거일 때만 칠하고 **사선을
///   긋는다.** 색만으로는 부족하다 — 비버가 계속 말하고 있어서 「소리가 나니까 안 꺼진
///   건가」로 읽히기 때문이다. 사선은 그 오독을 막는 유일한 신호다.
class _MicToggleButton extends StatelessWidget {
  const _MicToggleButton({
    required this.muted,
    required this.semanticLabel,
    required this.onChanged,
  });

  final bool muted;
  final String semanticLabel;

  /// 새 음소거 값으로 호출된다(누르면 반전).
  final ValueChanged<bool> onChanged;

  static const double _size = 40;
  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final glyph = muted ? c.staticWhite : c.labelNormal;

    // 음소거는 통화 중에 **잘못 읽히면 안 되는** 상태다. 채움·테두리·글리프가
    // 한 프레임에 갈리면 눌린 건지 화면이 튄 건지 구별이 안 된다. 사선은
    // 좌하 → 우상으로 **그어지듯** 들어와, 무엇이 방금 켜졌는지 눈이 따라간다.
    //
    // ⚠ 채움을 `muted ? red : transparent` 로 미리 접지 마라 — 끌 때 목표색이
    //   투명이 되어 보간이 투명→투명이 되고 채움만 한 프레임에 사라진다.
    //   테두리도 폭을 1 로 고정하고 색만 섞는다(`BorderSide.none` 은 폭 0 이다).
    return Semantics(
      button: true,
      toggled: muted,
      label: semanticLabel,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: muted ? 1 : 0),
        duration: AppMotion.medium,
        curve: AppMotion.toggle,
        builder: (context, t, _) => Material(
          color: Color.lerp(Colors.transparent, c.accentBackgroundRed, t),
          shape: CircleBorder(
            side: BorderSide(
              color: Color.lerp(c.lineNeutral, Colors.transparent, t)!,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onChanged(!muted),
            child: SizedBox(
              width: _size,
              height: _size,
              child: Center(
                child: SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppIcons.mic(
                        size: _iconSize,
                        color: Color.lerp(c.labelNormal, c.staticWhite, t)!,
                      ),
                      if (t > 0)
                        CustomPaint(
                          size: const Size.square(_iconSize),
                          painter: _SlashPainter(color: glyph, progress: t),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 음소거 사선. 아이콘 자산에 `mic-off` 가 없어 위에 긋는다.
class _SlashPainter extends CustomPainter {
  const _SlashPainter({required this.color, this.progress = 1});

  final Color color;

  /// 사선을 어디까지 그었는지(0..1). 켤 때 좌하에서 우상으로 그어진다.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // 좌하 → 우상. 마이크 글리프를 가로지른다.
    final start = Offset(size.width * 0.18, size.height * 0.82);
    final end = Offset(size.width * 0.82, size.height * 0.18);
    canvas.drawLine(start, Offset.lerp(start, end, progress)!, p);
  }

  @override
  bool shouldRepaint(_SlashPainter old) =>
      old.color != color || old.progress != progress;
}
