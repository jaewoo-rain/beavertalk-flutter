import 'package:flutter/foundation.dart';
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
import '../../features/bookmark/presentation/providers/bookmark_providers.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/incoming_call/services/lockscreen_call_service.dart';
import '../../features/normalcall/domain/entities/call_allowance.dart';
import '../../features/normalcall/domain/entities/call_hint.dart';
import '../../features/normalcall/presentation/avatar_view.dart';
import '../../features/normalcall/presentation/cascade_experiment.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/presentation/sync_avatar.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/data/speech_cache.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../overlays/subscription_overlays.dart';
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

  /// 구간 시트가 떠 있는가 — 중복 표시 방어.
  ///
  /// `ref.listen` 은 빌드마다 다시 걸리고 상태도 여러 번 흐르므로, 이게 없으면
  /// [CallPhase.awaitingContinue] 하나에 시트가 여러 장 쌓인다.
  bool _segmentSheetOpen = false;

  /// turn_id of the hint the learner has revealed (peek → full). Ephemeral: a
  /// new hint carries a new turn_id, so the card auto-collapses.
  String? _revealedTurnId;

  /// Currently shown suggestion index in the revealed hint; reset per new hint.
  int _suggestionIndex = 0;

  /// 담아 본 힌트 → 서버 문장 id. 키는 [_hintKey].
  ///
  /// 힌트에는 문장 id 가 없다 — 서버가 힌트 시점에 DB 를 안 건드리기 때문이다
  /// ([HintExample] 참고). 🔖 를 **처음** 누를 때 `POST /sentences/from-hint` 가 문장을
  /// 만들어 주고, 그 뒤로는 기존 즐겨찾기와 **완전히 같은 행**이라 토글도 같은 길
  /// (`PATCH /sentences/{id}/bookmark`)로 간다.
  final Map<String, int> _hintSentenceIds = <String, int>{};

  /// 담기·토글이 나가 있는 힌트(키). 연타 방어이자, 아직 id 가 없는 **첫 담기 동안의
  /// 낙관적 채움** 근거다 — 그 순간엔 채움을 판단할 id 자체가 없다.
  final Set<String> _hintBookmarkInFlight = <String>{};

  /// 힌트 담기의 신원 — 서버의 중복 판정과 같은 기준(통화 + 한국어 문장)으로 맞춘다.
  /// 어긋나면 앱은 새 문장으로 알고 서버는 재사용해서, 글리프와 서버가 갈린다.
  static String _hintKey(int callId, String korean) => '$callId|${korean.trim()}';

  /// Standard-pronunciation player for hint examples.
  ///
  /// ⚠ 통화 중 오디오 클라이언트가 **셋**이 된다 — 마이크(FlutterSoundRecorder),
  /// 바바 재생(flutter_pcm_sound), 그리고 이것. 에코 되먹임(열린 마이크가 이 재생을
  /// 사용자 발화로 듣는 것)과 안드로이드 오디오 세션 충돌은 **실기기 통화에서만
  /// 갈린다.** 지금은 마이크 뮤트 같은 방어를 넣지 않았다 — 통화 흐름을 건드리는
  /// 일이라 증상을 보고 정한다.
  final ReviewAudioPlayer _hintPlayer = ReviewAudioPlayer();

  /// 합성 요청이 나가 있는 문장(캐시 키) — 두 번째 탭이 왕복을 중복시키는 것을 막는다.
  /// 합성은 요금이 나가므로 중복 요청은 그냥 돈이 새는 것이다.
  final Set<String> _hintSpeechInFlight = <String>{};

  @override
  void dispose() {
    // 통화가 끝나도 플레이어가 열려 있으면 오디오 세션을 계속 붙들고 있다.
    _hintPlayer.dispose();
    super.dispose();
  }

  /// 힌트 예시를 **캐릭터 목소리로** 읽어준다 — `POST /tts/speech` (백엔드 규약
  /// 2026-09-04). 힌트 예시는 서버 DB 에 행이 없어 `sentence_id` 가 없으므로,
  /// 분석 화면이 쓰는 `POST /sentences/{id}/tts` 는 여기서 쓸 수 없다.
  ///
  /// 응답은 **mp3 바이트 그 자체**다(URL 이 아니다). 받은 바이트는 캐시에 넣는다 —
  /// 합성은 부를 때마다 요금이 나가고, 같은 예시를 다시 누르는 일이 잦다.
  ///
  /// [characterId] 는 **요청에 싣지 않는다** — 목소리는 서버가 회원 정보로 정한다.
  /// 그런데도 받아 두는 이유는 **캐시 키**로 쓰기 위해서다: 캐릭터를 바꾸면 같은 문장도
  /// 다른 목소리로 와야 하는데, 텍스트만 키로 쓰면 예전 목소리가 계속 재생된다.
  ///
  /// 실패는 전부 안내로 폴백한다. 특히 **503 은 백엔드의 외부 TTS 가 안 되는 상태**이며
  /// (레포지토리가 null 로 내린다) 앱 잘못이 아니다 — 통화는 그대로 간다.
  Future<void> _playHintExample(HintExample ex, int? characterId) async {
    final l10n = AppLocalizations.of(context);
    final text = ex.korean.trim();
    if (text.isEmpty) return;

    final cache = ref.read(speechCacheProvider);
    final key = SpeechCache.keyFor(text, characterId);
    final cached = cache.get(key);
    if (cached != null) {
      await _playHintBytes(cached, l10n);
      return;
    }

    if (!_hintSpeechInFlight.add(key)) return;
    Uint8List? bytes;
    try {
      bytes = await ref.read(reviewRepositoryProvider).speech(text);
    } catch (_) {
      bytes = null; // 전송 실패·기타 오류 — "아직 준비 안 됨"으로 보고한다.
    } finally {
      _hintSpeechInFlight.remove(key);
    }
    if (!mounted) return;
    if (bytes == null || bytes.isEmpty) {
      _snack(l10n.standardAudioNotReady);
      return;
    }
    cache.put(key, bytes);
    await _playHintBytes(bytes, l10n);
  }

  Future<void> _playHintBytes(Uint8List bytes, AppLocalizations l10n) async {
    try {
      await _hintPlayer.playMp3Bytes(bytes);
    } catch (_) {
      if (mounted) _snack(l10n.standardAudioPlayError);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// 힌트 예시를 즐겨찾기에 담거나 뺀다 — **두 단계**다.
  ///
  /// 1. **처음 담을 때**: 힌트에는 문장 id 가 없으므로 `POST /sentences/from-hint` 가
  ///    이 순간 문장을 만든다. 응답 문장은 이미 담긴 상태(`is_bookmarked=true`)다.
  ///    ⛔ **같은 힌트를 다시 담아도 에러가 아니다** — 서버가 같은 행을 재사용해 200 에
  ///      같은 id 를 준다. 그래서 실패 처리하지 않는다.
  /// 2. **그 뒤**: 만들어진 문장은 기존 즐겨찾기와 **완전히 같은 행**이라
  ///    `analysis.dart:_toggleBookmark` 와 같은 길로 토글한다(낙관적 반영 + 실패 복구).
  ///
  /// [callId] 는 이 통화의 서버 id. 없으면(연결 전·구버전 서버) 담을 수 없다 —
  /// 버튼을 숨기는 대신 **이유를 말한다**([_playHintExample] 과 같은 원칙).
  Future<void> _toggleHintBookmark(HintExample ex, int? callId) async {
    final l10n = AppLocalizations.of(context);
    final korean = ex.korean.trim();
    if (callId == null || korean.isEmpty) {
      _snack(l10n.saveSentenceFailed);
      return;
    }
    final key = _hintKey(callId, korean);
    if (!_hintBookmarkInFlight.add(key)) return;
    setState(() {}); // 첫 담기 동안 글리프를 미리 채운다(아직 id 가 없다).

    try {
      final known = _hintSentenceIds[key];
      if (known != null) {
        // ── 이미 담아 본 문장 — 평범한 즐겨찾기 토글 ──
        final willSave = !bookmarkedSentenceIds.value.contains(known);
        toggleBookmark(known); // optimistic local flip
        try {
          await ref
              .read(bookmarkToggleControllerProvider.notifier)
              .toggleBookmark(known, willSave);
        } catch (_) {
          toggleBookmark(known); // revert
          if (mounted) _snack(l10n.saveSentenceFailed);
        }
        return;
      }

      // ── 처음 담는다 — 이 순간 서버가 문장을 만든다 ──
      // ⚠ 서버가 native 를 1자 이상 필수로 받는다. 비어 있으면 422 가 될 뿐이라
      //   왕복하지 않고 여기서 이유를 말한다.
      final native = ex.native.trim();
      if (native.isEmpty) {
        _snack(l10n.saveSentenceFailed);
        return;
      }
      final saved = await ref.read(bookmarkRepositoryProvider).saveHintSentence(
            callId: callId,
            korean: korean,
            native: native,
          );
      _hintSentenceIds[key] = saved.sentenceId;
      setBookmark(saved.sentenceId, saved.isBookmarked);
      // 보관함은 서버 목록을 다시 읽어야 이 문장이 보인다.
      ref.invalidate(bookmarkListProvider);
    } catch (_) {
      if (mounted) _snack(l10n.saveSentenceFailed);
    } finally {
      _hintBookmarkInFlight.remove(key);
      if (mounted) setState(() {});
    }
  }

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

  /// 5분 구간이 끝났을 때 뜨는 시트 — 무료는 구독 유도, 유료는 「Keep going?」.
  ///
  /// 어느 시트인지는 [CallState.paidCallTime] 이 가른다. **화면이 구독 상태를 따로
  /// 읽지 않는 이유**는, 그러면 판정이 두 벌이 되어 컨트롤러가 계산한 상한
  /// (5분/15분)과 화면이 그리는 시트가 어긋날 수 있기 때문이다. 판정은 통화 시작
  /// 시점에 컨트롤러가 한 번 하고, 화면은 그 결과를 그린다.
  Future<void> _showSegmentSheet(
    CallState s, {
    required String characterName,
    required ImageProvider? avatarImage,
  }) async {
    if (_navigated || _segmentSheetOpen) return;
    _segmentSheetOpen = true;
    final notifier = ref.read(normalCallControllerProvider.notifier);

    // 시트가 닫혔는데 아무 것도 안 골랐다면(시스템 뒤로가기 등) 통화를 끝낸다.
    // 안 그러면 소리도 없고 화면도 안 바뀌는 상태에 갇힌다.
    var decided = false;
    final used = s.segmentsUsed;
    final limit = CallAllowance.limitFor(paidAccess: s.paidCallTime);

    try {
      await showSubscriptionOverlay(
        context,
        s.paidCallTime
            ? SubscriptionOverlay.keepGoing
            : SubscriptionOverlay.freeCallEnded,
        characterName: characterName,
        avatar: avatarImage == null
            ? null
            : Image(image: avatarImage, fit: BoxFit.cover),
        // 「5:00 of 5:00 used」 — 무료 시트에만 쓰인다.
        usage: (
          used: _clock(CallAllowance.segment.inSeconds * used),
          limit: _clock(limit.inSeconds),
        ),
        onContinue: () {
          decided = true;
          notifier.continueCall();
        },
        onEndCall: () {
          decided = true;
          notifier.hangUp();
        },
        // 결제 퍼널을 **이 화면 위에 얹는다.** 통화를 끊지도, 화면을 떠나지도 않는다.
        //
        // 시트 카피가 「Subscribe and keep talking」이라 결제가 끝나면 **대화가
        // 이어져야 한다.** 그러려면 두 가지가 살아 있어야 한다:
        //   1. [CallPhase.awaitingContinue] — [NormalCallController.continueCall] 의 입장권
        //   2. [CallState.callId] — 다음 구간의 `continues_call_id`. 서버가 이 id 로
        //      앞 구간을 요약해 주입하므로, 끊어 버리면 **비버가 방금 한 얘기를 잊는다**
        // 예전처럼 `hangUp()` 을 먼저 부르면 둘 다 사라진다.
        //
        // ⛔ `pushReplacement` 를 쓰지 마라 — 통화 화면이 스택에서 빠지면 결제 뒤
        //   돌아올 자리가 없어 홈으로 떨어진다(사장님 리포트의 그 증상).
        //
        // ⛔ `_navigated` 를 올리지 않는다. 이 화면은 **떠나지 않으므로** 요약 이동
        //   리스너를 재울 이유가 없고, 재우면 이어서 진짜로 끊었을 때 요약으로 못 간다.
        //
        // 결제 성공이면 `purchase_flow` 가 성공 화면 대신 이 화면까지 팝해 주고,
        // 취소·실패면 페이월이 그냥 pop 된다 — **두 경로 모두 이 await 로 돌아온다.**
        // 어느 쪽이었는지는 [NormalCallController.resumeAfterPaywall] 이 구독 상태를
        // 다시 읽어 판정한다(이어가기 / 통화 종료).
        onSubscribe: () async {
          decided = true;
          await Navigator.of(context, rootNavigator: true)
              .pushNamed(Routes.paywallProLimit, arguments: 'call');
          if (!mounted) return;
          final resumed = await notifier.resumeAfterPaywall();
          if (!mounted || !resumed) return;
          // 결제 성공 화면을 건너뛰었으므로(그 시안의 CTA 는 「Start a call」이라 통화
          // 중엔 성립하지 않는다) **결제됐다는 사실만** 통화 위에 얹어 알린다.
          // 기존 키를 재사용한다 — 새 문구를 만들면 30개 로케일이 따라와야 한다.
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context).successProTitle)));
        },
      );
      if (!decided) await notifier.hangUp();
    } finally {
      _segmentSheetOpen = false;
    }
  }

  /// `초 → m:ss` — 시트의 사용량 줄(`5:00 of 5:00 used`)에 쓴다.
  static String _clock(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

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
    // 힌트를 담으려면 이 통화의 서버 id 가 필요하다(`POST /sentences/from-hint`).
    // 상태는 문자열로 들고 있고 서버는 int 를 받는다 — 다른 자리와 같은 방식으로 판다.
    // 연결 전에는 null 이고, 그때는 담기가 "저장하지 못했어요"로 폴백한다.
    final hintCallId = int.tryParse(
      ref.watch(normalCallControllerProvider.select((s) => s.callId)) ?? '',
    );
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
      // ⛔ **그 상태로 진입할 때만** 띄운다. `next.phase == awaitingContinue` 만 보면
      //   결정을 기다리는 **동안의 다른 상태 변화**에도 시트가 다시 열린다 —
      //   [NormalCallController.resumeAfterPaywall] 이 결제 확인 후 `paidCallTime` 을
      //   굳히는 순간이 정확히 그렇다(phase 는 아직 `awaitingContinue`). 그러면
      //   결제하고 돌아온 사람 앞에 시트가 **다시** 뜬다 — 그것도 `paidCallTime` 이
      //   이제 true 라 무료 시트가 아니라 「Keep going?」 이, 방금 재개한 통화 위로.
      //   `_segmentSheetOpen` 은 이걸 못 막는다 — 그 시점엔 이미 false 로 풀려 있다.
      if (next.phase == CallPhase.awaitingContinue &&
          prev?.phase != CallPhase.awaitingContinue) {
        _showSegmentSheet(
          next,
          characterName: selectedChar?.name ?? '',
          avatarImage: partnerImage,
        );
      } else if (next.phase == CallPhase.ended) {
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
                              // The bookmark glyph fills/empties from the shared
                              // store, so it also reflects a save made elsewhere
                              // for the same sentence.
                              ValueListenableBuilder<Set<int>>(
                                valueListenable: bookmarkedSentenceIds,
                                builder: (context, saved, _) {
                                  // Same clamp HintCard applies internally, so
                                  // the glyph always belongs to the example on
                                  // screen.
                                  final ex = hint.examples[_suggestionIndex
                                      .clamp(0, hint.examples.length - 1)];
                                  // 힌트에는 문장 id 가 없다 — 담은 뒤에야 생긴다.
                                  // 그래서 채움은 두 근거를 본다: 이미 담아 본
                                  // 문장의 서버 id, 그리고 **첫 담기가 나가 있는
                                  // 동안**의 낙관적 채움(그땐 id 자체가 없다).
                                  final key = hintCallId == null
                                      ? null
                                      : _hintKey(hintCallId, ex.korean);
                                  final savedId =
                                      key == null ? null : _hintSentenceIds[key];
                                  final isSaved = savedId != null
                                      ? saved.contains(savedId)
                                      : key != null &&
                                          _hintBookmarkInFlight.contains(key);
                                  return HintCard(
                                    examples: hint.examples,
                                    revealed: _revealedTurnId == hint.turnId,
                                    index: _suggestionIndex,
                                    bookmarked: isSaved,
                                    // 둘 다 **항상** 넘긴다. 부를 수 없는 상태면
                                    // 버튼을 없애는 게 아니라 이유를 말한다.
                                    onSpeak: () =>
                                        _playHintExample(ex, characterId),
                                    onBookmarkTap: () =>
                                        _toggleHintBookmark(ex, hintCallId),
                                    onReveal: () {
                                      setState(
                                          () => _revealedTurnId = hint.turnId);
                                      ref
                                          .read(
                                            normalCallControllerProvider
                                                .notifier,
                                          )
                                          .sendHintUsed(hint.turnId);
                                    },
                                    onCycle: () => setState(
                                      () => _suggestionIndex =
                                          (_suggestionIndex + 1) %
                                          hint.examples.length,
                                    ),
                                  );
                                },
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

    return Semantics(
      button: true,
      toggled: muted,
      label: semanticLabel,
      child: Material(
        color: muted ? c.accentBackgroundRed : Colors.transparent,
        shape: CircleBorder(
          side: muted ? BorderSide.none : BorderSide(color: c.lineNeutral),
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
                    AppIcons.mic(size: _iconSize, color: glyph),
                    if (muted)
                      CustomPaint(
                        size: const Size.square(_iconSize),
                        painter: _SlashPainter(color: glyph),
                      ),
                  ],
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
  const _SlashPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // 좌하 → 우상. 마이크 글리프를 가로지른다.
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.82),
      Offset(size.width * 0.82, size.height * 0.18),
      p,
    );
  }

  @override
  bool shouldRepaint(_SlashPainter old) => old.color != color;
}
