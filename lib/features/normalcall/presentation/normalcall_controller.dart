import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart'
    show
        ValueNotifier,
        debugPrint,
        defaultTargetPlatform,
        kDebugMode,
        kIsWeb,
        TargetPlatform;
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding;
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/i18n/locale_controller.dart';
import '../../../core/network/ws_url.dart';
import '../../../l10n/app_localizations.dart';
import '../data/datasources/audio_route_probe.dart';
import '../data/datasources/pcm_playback_control.dart';
import '../domain/entities/call_channel.dart';
import '../domain/entities/call_hint.dart';
import '../domain/entities/playback_ledger.dart';
import 'avatar_emotion.dart';
import 'avatar_view.dart' show kIdleWait, kIdleListen, kIdleThink;
import 'normalcall_providers.dart';

/// `call_ended.call_id` 정규화 — **빈 값은 없는 것**이다.
///
/// 서버는 통화 행이 없을 때 null 이 아니라 **빈 문자열**을 보낸다
/// (`cascade_session.py:3198` — `ServerCallEnded(call_id=str(self._call_id or ""))`).
/// 그대로 받으면 "우리가 id 를 가졌다"가 되어 **통화 종료 화면의 복구 폴링이 안 돈다**
/// (`call_finish.dart` `_analyze()` 는 `callId == null` 일 때만 `_recoverCallId()` 를 부른다).
/// 즉 복구가 가장 필요한 경우에 정확히 복구가 죽는다 — null 보다 나쁘다.
///
/// ⭐ 통로로 가르지 않는다. 여기 한 자리에서 막으면 라이브 서버가 언젠가 같은 값을 보내도
/// 안 깨진다. 공백만 있는 값도 없는 것으로 본다(서버가 `" "` 를 보낼 이유는 없지만,
/// 이 함수의 계약은 "쓸 수 있는 id 인가"이지 "서버가 무엇을 보냈나"가 아니다).
String? normalizeCallId(Object? raw) {
  final s = raw?.toString().trim();
  return (s == null || s.isEmpty) ? null : s;
}

/// 테스트에서 [NormalCallController] 인스턴스 없이 라벨 매핑만 검사하기 위한 창구.
/// (구현은 컨트롤러 안의 `_emotionCode` 하나뿐이다 — 두 벌로 만들지 않는다.)
int emotionCodeForTest(String? raw) => NormalCallController.emotionCode(raw);

/// 통화 한 건의 **경계 판정용 요약 줄**.
///
/// ⛔ **통로를 인자로 받는다 — 필드를 읽지 않는다.** 실기기 첫 통화에서 이 줄이
/// `통로=live` 라고 **거짓을 말했다**(2026-08-12). 원인은 값이 아니라 **읽는 시점**이었다:
/// `_teardown` 이 통로를 기본값(live)으로 되돌린 **뒤에** 이 줄이 찍혔다.
/// 되돌리는 것 자체는 맞다(안 되돌리면 다음 통화가 게이팅 없이 열린다 — 자기-대화 루프).
///
/// ⭐ 그래서 "로그를 리셋 위로 옮긴다"로 안 고쳤다. 그건 **순서에 의존**하는 수리라
/// 다음에 누가 리셋을 재배치하면 같은 버그가 돌아온다. 값을 **인자로 넘기게** 만들고
/// 호출부가 함수 진입 시점에 붙잡아 두면 순서와 무관해진다.
///
/// ⚠ 원인을 가르려고 넣은 줄이 정확히 그 자리에서 거짓을 말하면, 그 줄이 없느니만 못하다.
String buildCallSummaryLine({
  required int sentences,
  required int pendingMarkers,
  required int oddFrames,
  required CallChannel channel,
  int hints = 0,
  int hintsDropped = 0,
}) =>
    '통화 요약: sentence=$sentences hint=$hints'
    '${hintsDropped > 0 ? '(버림 $hintsDropped)' : ''} '
    '미발화마커=$pendingMarkers odd_frames=$oddFrames 통로=${channel.name}';

/// 자막을 **틱당 몇 글자씩** 드러낼지. 봉투 틱 = 25ms(= 40틱/초).
///
/// ⭐ [spanTicks] 가 양수면 그건 **이 조각이 실제로 차지하는 오디오 길이**다(다음 마커가
/// 이미 대기 중이라 그 위치를 안다 — 마커는 오디오보다 먼저 도착한다). 그러면 추정이
/// 아니라 실제 길이에 맞춘다: 글자가 조각의 소리와 **정확히 같이 끝난다**.
///
/// 모를 때만(마지막 조각) 언어별 기본값을 쓴다. 근거는 실측 말하기 속도다:
///   한국어 6.3~8.5 자/초(중앙 7.7) → ≈0.19 자/틱
///   영어 19.6 자/초              → ≈0.49 자/틱
/// ⚠ 한글 1글자(음절)가 영문 3~4글자 소리다. 같은 속도를 쓰면 한글 자막이 소리보다 훨씬
///   먼저 끝난다 — 그래서 **한글이 섞여 있으면 느린 쪽**을 쓴다(섞인 조각은 한글이 시간을 지배한다).
double revealRatePerTick({
  required String text,
  int spanBytes = -1,
  double charsPerByte = 0,
}) {
  if (text.isEmpty) return 1.0;
  // 봉투 틱 = 25ms, 24kHz·16bit = 48,000 B/s → 틱당 1,200 B.
  const bytesPerTick = 1200;
  if (spanBytes > 0) {
    final ticks = spanBytes / bytesPerTick;
    if (ticks >= 1) return text.length / ticks;
  }
  if (charsPerByte > 0) {
    // ⭐ **짧은 쪽으로 편향한다**(계수 < 1). 비대칭이기 때문이다:
    //   짧게 잡으면 → 글자가 먼저 다 나오고 **가만히 있는다**(눈에 잘 안 띈다)
    //   길게 잡으면 → 다음 마커에서 남은 걸 **한 번에 쏟는다** = 지금 고치려는 그 점프
    final estBytes = text.length / charsPerByte;
    final ticks = estBytes / bytesPerTick * _revealShortBias;
    if (ticks >= 1) return text.length / ticks;
  }
  // 아무 재료도 없을 때(턴의 첫 구간이자 마지막 구간)만 언어별 실측 기본값.
  //   한국어 6.3~8.5 자/초(중앙 7.7) → ≈0.19 자/틱 · 영어 19.6 자/초 → ≈0.49 자/틱
  // ⚠ 한글 1글자(음절)가 영문 3~4글자 소리다 — 섞이면 한글이 시간을 지배하므로 느린 쪽.
  final hasHangul = RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(text);
  return hasHangul ? 0.19 : 0.49;
}

/// 추정 구간의 길이 편향 계수. 1 보다 작아야 **짧은 쪽**으로 틀린다.
const double _revealShortBias = 0.8;

/// 마이크가 **왜 닫혔는지** — 세 관문 중 무엇이 막았나.
///
/// 여는 데는 셋이 **전부** 필요하다: 통로가 캐스케이드 · 서버가 열라고 함 · AEC 스위치 켜짐.
/// ⚠ 이 문장이 없으면 "끼어들기가 안 된다"는 보고에서 **AEC 문제인지 서버 정책인지**
/// 구분이 안 된다 — 둘은 다음 행동이 완전히 다르다(에코 실측 vs 서버 설정).
String micGateReason({
  required bool channelGates,
  required bool serverMicAlwaysOpen,
  required bool aecOn,
}) {
  if (channelGates) return '라이브 통로 — 반이중 게이팅';
  if (!serverMicAlwaysOpen) return '서버 정책(ready.mic_always_open=false)';
  if (!aecOn) return 'AEC 스위치 꺼짐(ANDROID_VOICE_AUDIO) — 실측 전 안전장치';
  return '알 수 없음';
}

/// Lifecycle phases of a live normalcall session.
enum CallPhase {
  /// No active session (initial / after teardown).
  idle,

  /// WebSocket connecting + mic warming up, before the first `turn_start`.
  connecting,

  /// Live conversation in progress (beaver and/or user talking).
  inCall,

  /// Wind-down: `call_ended` received, draining the final audio before close.
  ending,

  /// Session finished cleanly; [CallState.callId] holds the analyzable id.
  ended,

  /// Connection/auth failure; [CallState.errorMsg] holds a reason.
  error,
}

/// Immutable snapshot of the current call, exposed to the UI.
class CallState {
  /// Creates a call-state snapshot.
  const CallState({
    this.phase = CallPhase.idle,
    this.elapsedSec = 0,
    this.callId,
    this.characterId,
    this.baselineCallId,
    this.beaverSubtitle = '',
    this.userSubtitle = '',
    this.errorMsg,
    this.hint,
    this.teachingPlan = const [],
    this.subtitleOn = true,
    this.hintOn = true,
    this.beaverPreparing = false,
  });

  /// Current lifecycle phase.
  final CallPhase phase;

  /// Elapsed call time in whole seconds (UI display only; server is the source
  /// of truth for actual call limits via `call_ended`).
  final int elapsedSec;

  /// Server call id, available once `call_ended` arrives. Pass to analysis.
  final String? callId;

  /// 서버가 정한 이 통화의 캐릭터(`call_started`). 통화 화면 아바타는 이걸 우선
  /// 쓴다 — 수신통화는 알람마다 캐릭터가 달라서 대표 캐릭터로 그리면 **대화 상대와
  /// 화면 얼굴이 어긋난다**. 도착 전(연결 중)이나 구버전 서버에서는 null 이고,
  /// 그때는 화면이 대표 캐릭터로 폴백한다.
  final int? characterId;

  /// Max existing `call_id` captured at call start, before the server creates
  /// this call's row. On a manual hang-up (no `call_ended`/[callId]), the
  /// wrap-up screen recovers the new id by polling `GET /calls` for an id
  /// greater than this baseline. Null when the pre-call fetch failed/none.
  final int? baselineCallId;

  /// Current beaver (assistant) subtitle line. Built up by accumulating the
  /// token deltas that arrive as `output_transcript`, and reset each `turn_start`.
  final String beaverSubtitle;

  /// Current user subtitle line. Built up by accumulating the token deltas that
  /// arrive as `input_transcript`, and reset each `turn_end` (before the user
  /// speaks again).
  final String userSubtitle;

  /// Human-readable error message when [phase] is [CallPhase.error].
  final String? errorMsg;

  /// Active dynamic hint for the current/last beaver question, or null when no
  /// hint is showing. Cleared on each `turn_start` and on `call_ended`.
  final HintData? hint;

  /// Today's teaching plan (pushed once at call start; may be empty). Stored for
  /// a future teaching-card screen — not rendered by `screen/call_main`.
  final List<TeachingItem> teachingPlan;

  /// Whether the subtitle (caption) is shown. When false the speaking
  /// equalizer replaces it. UI preference; resets to true each call.
  final bool subtitleOn;

  /// Whether the hint affordance is enabled. When false the hint card is hidden
  /// even if a hint has arrived. UI preference; resets to true each call.
  final bool hintOn;

  /// 서버가 대답을 만드는 중인가(`beaver_preparing`). **캐스케이드 통로 전용**이고
  /// 라이브에서는 항상 false 다.
  ///
  /// ⚠ 아직 그리는 UI 가 없다 — 설명되지 않는 침묵이 통화를 끊게 만들기 때문에 서버가
  /// 단계를 보내 주는데, 그걸 받을 자리를 먼저 만들어 둔다. `turn_start` 에서 내려간다
  /// (소리가 나기 시작하면 준비 중이 아니다).
  final bool beaverPreparing;

  /// Sentinel so [copyWith] can distinguish "leave [hint] unchanged" from
  /// "clear [hint] to null" — the `?? this.hint` idiom cannot express the latter.
  static const Object _keep = Object();

  /// Returns a copy with the given fields replaced. Pass `hint: null` to clear
  /// the active hint (the [_keep] sentinel preserves it when omitted).
  CallState copyWith({
    CallPhase? phase,
    int? elapsedSec,
    String? callId,
    int? characterId,
    int? baselineCallId,
    String? beaverSubtitle,
    String? userSubtitle,
    String? errorMsg,
    Object? hint = _keep,
    List<TeachingItem>? teachingPlan,
    bool? subtitleOn,
    bool? hintOn,
    bool? beaverPreparing,
  }) {
    return CallState(
      phase: phase ?? this.phase,
      elapsedSec: elapsedSec ?? this.elapsedSec,
      callId: callId ?? this.callId,
        characterId: characterId ?? this.characterId,
      baselineCallId: baselineCallId ?? this.baselineCallId,
      beaverSubtitle: beaverSubtitle ?? this.beaverSubtitle,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      errorMsg: errorMsg ?? this.errorMsg,
      hint: identical(hint, _keep) ? this.hint : hint as HintData?,
      teachingPlan: teachingPlan ?? this.teachingPlan,
      subtitleOn: subtitleOn ?? this.subtitleOn,
      hintOn: hintOn ?? this.hintOn,
      beaverPreparing: beaverPreparing ?? this.beaverPreparing,
    );
  }
}

/// App-scoped singleton owning the live normalcall pipeline: a single WebSocket,
/// the mic recorder (FlutterSoundRecorder, PCM 16k → server), and gapless native
/// playback (flutter_pcm_sound, callback-pull PCM 24k ← server). Device-only:
/// playback isn't available on web, where [start] fails cleanly (see the
/// `kIsWeb` guard).
///
/// Design guarantees (see plan §8):
/// - **No double socket (§8-1):** [start] is guarded against re-entry and against
///   active phases, and always runs [_teardown] *before* connecting
///   (teardown-first-then-connect), so two sockets are structurally impossible.
/// - **Leave = hang up (§8-2):** every exit path ([hangUp], `call_ended`, errors)
///   funnels through [_teardown]; screens add `PopScope`/lifecycle triggers.
/// - **Auto opening line (§8-3):** [start] sends `{type:start}` right after the
///   socket opens (no button); the first `turn_start` flips phase to `inCall`.
final normalCallControllerProvider =
    NotifierProvider<NormalCallController, CallState>(NormalCallController.new);

/// Notifier implementing the normalcall socket + audio pipeline.
class NormalCallController extends Notifier<CallState> {
  /// Translated strings for the user-facing failures this controller reports.
  ///
  /// There is no `BuildContext` here, so `AppLocalizations.of` is unavailable —
  /// which is why every `errorMsg` below used to be a Korean literal, shown to
  /// every user regardless of their language. gen-l10n emits a **synchronous**
  /// `lookupAppLocalizations(Locale)`, and the active locale already lives in
  /// [localeControllerProvider].
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeControllerProvider));

  // ── Avatar lip-sync signals (video-call avatar; see avatar_view.dart) ───────
  // Gemini Live returns raw PCM with no viseme timing, so the mouth is driven
  // from the audio envelope. These are published from the PCM *about to play*
  // (in [_onFeed] via [_takeArray]) — NOT from arrival time — because the
  // playback queue buffers seconds ahead, so arrival-time RMS would lead the
  // sound. In-memory only; consumed by [BeaverAvatar]. Additive: the audio
  // pipeline itself is unchanged.

  /// Live mouth-open level, 0 (closed) .. 1 (wide), from the RMS of the audio
  /// currently being fed to the player. ~10Hz; the widget smooths to 60fps.
  final ValueNotifier<double> avatarLevel = ValueNotifier<double>(0.0);

  /// True while the beaver is speaking (mirrors [_beaverAudioActive]).
  final ValueNotifier<bool> avatarSpeaking = ValueNotifier<bool>(false);

  /// Current avatar emotion code (0 neutral/smug, 1 happy, 2 surprised, 3 sad,
  /// 4 angry), classified from the beaver's streamed line so the face reacts to
  /// what it says. Reset to neutral each turn; set sticky within a turn.
  final ValueNotifier<int> avatarEmotion = ValueNotifier<int>(0);

  /// 비버가 말하지 않는 동안의 **대기 상태**([kIdleWait]·[kIdleListen]·[kIdleThink]).
  /// 아바타가 `idle` 슬롯에서 무엇을 재생할지 고른다.
  ///
  /// ★신호는 원래부터 있었다 — 사용자 발화는 `input_transcript`(서버가 인식한
  /// 사용자 말)로, 응답 대기는 `turn_end` 뒤 `turn_start` 전 구간으로 잡는다.
  /// 「마이크/유저턴 신호가 없어서 못 한다」는 옛 기록은 사실이 아니었다.
  final ValueNotifier<int> avatarIdleKind = ValueNotifier<int>(kIdleWait);

  /// 사용자 발화가 끊긴 뒤 [kIdleListen] 을 유지하는 시간.
  /// 문장 사이의 짧은 공백마다 끄덕임이 끊기면 오히려 산만하다.
  static const Duration _listenHold = Duration(milliseconds: 900);
  Timer? _listenTimer;

  /// 사용자가 말하는 중임을 알린다(`input_transcript` 델타마다 호출).
  /// 비버가 말하는 동안에는 무시한다 — 그때는 talk/emo 가 화면을 덮는다.
  void _markUserSpeaking() {
    if (avatarSpeaking.value) return;
    avatarIdleKind.value = kIdleListen;
    _listenTimer?.cancel();
    _listenTimer = Timer(_listenHold, () {
      // 말이 끊겼다 → 이제 서버가 답을 만드는 중이다.
      if (!avatarSpeaking.value) avatarIdleKind.value = kIdleThink;
    });
  }

  /// Mouth SHAPE, −1 (round "OO") .. 0 ("AH") .. +1 (wide "EE"), from the
  /// zero-crossing rate of the audio about to play (a cheap spectral-tilt proxy:
  /// high ZCR = front/fricative → wide, low ZCR = back vowel → round). Lets the
  /// mouth form vowel shapes instead of a generic open/close. The widget smooths
  /// it. Characters without EE/OO sprites simply ignore this.
  final ValueNotifier<double> avatarShape = ValueNotifier<double>(0.0);

  /// 표정 분류기. 어휘 사전·문장 분할·최소 유지 시간은 `avatar_emotion.dart` 에
  /// 있다 — 랩(`avatar_lab_main.dart`)과 단위 테스트가 **같은 코드**를 돌리기
  /// 위해서다. 유지 시간은 계측으로 고른 기본값(400ms)을 쓴다 — 근거는 그 파일의
  /// [SentenceEmotion] 주석.
  final SentenceEmotion _emo = SentenceEmotion();

  /// Sub-frame mouth envelope: one entry per [_envStepMs] of audio, queued as
  /// audio is handed to the player and drained in real time. A single RMS per
  /// ~200ms feed (≈5Hz) is far too coarse for syllables; this runs at 40Hz so
  /// the mouth lands on the actual speech.
  final List<double> _envQueue = <double>[];
  Timer? _envTimer;
  static const int _envStepMs = 25;

  // ── `sentence` 마커 (캐스케이드) ──────────────────────────────────────────
  //
  // 서버가 구간 오디오 **직전에 인밴드**로 자막·표정을 보낸다. 미리 안 보낸다.
  // ⛔ **도착 시점에 발화하면 안 된다.** 그 오디오는 아직 안 들린다 — 우리는 최대
  //   1.2초치를 앞당겨 엔진에 밀어 넣으므로, 도착 즉시 자막을 바꾸면 소리보다 그만큼
  //   앞서 간다. 그래서 입모양([_envQueue])과 **같은 큐에 위치로 꽂는다.**
  //   이게 이 봉투 큐가 존재하는 이유다.

  /// 지금까지 봉투 큐에 **넣은** 칸 수(누계). 마커는 도착 시점의 이 값을 위치로 잡는다.
  int _envAdded = 0;

  /// 지금까지 **소비된**(재생된 것으로 간주) 칸 수(누계). 캡으로 잘려 나간 분도 포함한다 —
  /// 안 그러면 그 뒤 마커가 영영 안 터진다.
  int _envPlayed = 0;

  /// 타자기 드러내기 — 지금까지 **붙은 전체 자막**과 그중 **드러낸 글자 수**.
  /// 화면에는 `_revealTarget.substring(0, _revealed)` 만 나간다.
  ///
  /// ⛔ 조각을 통째로 붙이면 자막이 2~5단어씩 **점프**한다(사장님 지적, 2026-08-12).
  ///   한 문장이 TTS 언어 분할로 2~3구간이라 그 점프가 문장 중간마다 일어난다.
  String _revealTarget = '';
  int _revealed = 0;
  double _revealAccum = 0;
  double _revealPerTick = 0.49;

  /// 이 턴에서 발화된 구간들의 **글자 수 / 서버 바이트** 누계 — 마지막 구간의 길이를
  /// 추정하는 재료다. 한 턴 안에서는 말하기 속도가 거의 일정하다.
  int _revealCharsSum = 0;
  int _revealBytesSum = 0;

  /// 아직 발화되지 않은 마커들. `at` 은 [_envPlayed] 가 그 값에 닿으면 터진다는 뜻.
  final List<({int at, String text, int emotion, int seq, int serverBytes})>
      _pendingMarkers = [];

  /// [계측] 이 통화에서 받은 `sentence` 마커 수. **0 이면 서버가 안 보낸 것**이고,
  /// 0 이 아닌데 화면이 비면 앱 문제다 — 첫 실기기 통화에서 그 경계를 가르는 값이다.
  int _sentenceCount = 0;

  /// [계측] 이 통화에서 **받아서 쓴** 힌트 / **버린** 힌트.
  ///
  /// ⭐ 서버도 `hint[turn=b4]: 3개` 를 찍는다 — 두 로그를 나란히 놓으면 **턴 단위로
  /// 대조**되어 "서버가 안 보냈나 / 우리가 버렸나"가 한눈에 갈린다. 그게 요약에 넣는 이유다.
  int _hintCount = 0;
  int _hintDropped = 0;

  /// 서버가 감정을 직접 준 적이 있는가. 있으면 키워드 추측기([_emo])의 결과를 쓰지 않는다.
  ///
  /// ⛔ 통로로 가르지 않는 이유: 진짜 판별 기준은 "캐스케이드냐"가 아니라 **"서버가
  ///   감정을 주느냐"** 다. 둘이 동시에 `avatarEmotion` 을 쓰면 어느 쪽이 이겼는지 모르게
  ///   되므로, 명시적인 값(서버)이 추측(키워드)을 이긴다.
  bool _serverEmotionSeen = false;

  /// Extra holdback on top of the engine's own depth, to cover the platform
  /// channel hop. Small on purpose: the avatar switches picture on this signal,
  /// and a picture that arrives a hair early reads as in-sync while a late one
  /// reads as broken.
  ///
  /// ⚠ 이것만으로 버티던 시절이 있었는데(고정 25ms), 그 전제는 "네이티브가 아주
  ///   조금만 앞서 문다" 였다. [_pump] 가 그 조금을 **1.2~2.5초**로 만들었으므로
  ///   이제 홀드백의 본체는 [_engineLevelFrames] 이고 이건 그 위의 여유분이다.
  ///   고정값으로 되돌리면 입이 소리보다 최대 2.5초 먼저 움직인다 — 로그엔 안 보이고
  ///   실기기에서 눈으로만 보인다.
  static const int _envLeadMs = 25;

  /// RMS below this (near-silence) closes the mouth outright.
  static const double _avatarRmsGate = 260;

  /// RMS mapped to a fully-open mouth (tuned for Gemini 24k speech).
  static const double _avatarRmsFull = 5200;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSub;

  FlutterSoundRecorder? _recorder;

  /// Native channel to force loudspeaker (speakerphone) routing during a call —
  /// see ios/Runner/AppDelegate.swift `beavertalk/audio`.
  static const MethodChannel _audioRouteChannel =
      MethodChannel('beavertalk/audio');

  /// Native CallKit state bridge — see ios/Runner/AppDelegate.swift
  /// `beavertalk/callkit`. Used to learn when CallKit has activated the call's
  /// audio session, without trusting the plugin's unbuffered event stream.
  static const MethodChannel _callkitChannel =
      MethodChannel('beavertalk/callkit');

  // ── Audio session ownership ───────────────────────────────────────────────
  // Two entry paths with different owners:
  // - home ("전화하기"): no CallKit call exists, so this controller configures AND
  //   activates the session itself.
  // - CallKit (scheduled inbound call): the system owns the call and its audio
  //   session. We must NOT setActive(true)/setActive(false) under it — the
  //   category is set natively before activation and CallKit does the rest.

  /// True while the current call's audio session belongs to CallKit.
  bool _callkitOwnedAudio = false;

  /// True when THIS controller called `setActive(true)` on the shared audio
  /// session — the ONLY condition under which teardown may deactivate it.
  ///
  /// Inferring it from [_callkitOwnedAudio] was a real bug: [_connect] runs
  /// teardown-before-connect BEFORE assigning that flag, so answering a CallKit
  /// call deactivated the session the system had just activated for it. The
  /// socket kept running (conversation visibly in progress) while playback and
  /// mic were both dead. Track what we actually did instead of deducing it.
  bool _weActivatedSession = false;

  /// True once the native in-call route observer has been started, so teardown
  /// only stops routing it actually started (same reasoning as above).
  bool _audioRoutingStarted = false;

  /// CallKit call UUID backing this session, when there is one. [hangUp] ends it
  /// so the lock-screen call UI disappears together with the conversation.
  String? _callUuid;

  /// Set by [onCallKitAudioReady] (the plugin's didActivate event). A zero-latency
  /// accelerator only — [_awaitCallKitAudio] treats the native flag as truth.
  bool _callkitAudioReady = false;

  /// Bounded wait for CallKit's didActivate before starting audio anyway.
  ///
  /// Polled tightly: every 100ms of waiting here is 100ms before the beaver can
  /// be heard, and the check is a cheap synchronous native flag read.
  static const Duration _callkitAudioTimeout = Duration(seconds: 10);
  static const Duration _callkitAudioPollInterval = Duration(milliseconds: 50);

  /// When this call's socket opened — used to attribute start-up latency.
  DateTime? _sessionStartedAt;

  /// True once the first inbound audio chunk of this call has arrived.
  bool _gotFirstAudio = false;
  StreamController<Uint8List>? _micController;
  StreamSubscription<Uint8List>? _micSub;

  // ── Gapless PCM playback (flutter_pcm_sound, callback-pull @ native 24kHz) ──
  // A byte queue holds inbound server PCM16; the plugin's feed callback pulls
  // from it. When the queue is empty we feed a short silence so the engine is
  // never starved into a stuck underflow churn — the root cause of the ~1-min
  // audio cutout with the old flutter_sound stream player.

  /// Inbound PCM16 byte queue (little-endian samples). Live bytes are
  /// `[_pcmHead, _pcmTail)`; an odd trailing byte simply stays until the next
  /// chunk completes its Int16 sample, so samples never split across chunks.
  ///
  /// Deliberately a [Uint8List] with explicit indices rather than a `List<int>`
  /// that gets `sublist`-compacted. The server bursts up to ~4.8s (≈230KB) at
  /// once, and the old shape paid a word-per-byte store plus a full-buffer copy
  /// **on the feed callback path** — the audio thread's deadline is the one place
  /// that allocation must not happen. Here a steady call never copies at all:
  /// indices reset to 0 whenever the queue drains.
  Uint8List _pcmQueue = Uint8List(_pcmQueueInitialBytes);

  /// Read offset — bytes before it are already fed.
  int _pcmHead = 0;

  /// Write offset — bytes at/after it are unwritten capacity.
  int _pcmTail = 0;

  /// Initial queue capacity (~5.4s at 24kHz PCM16), so the common case never
  /// grows. Growth doubles; the buffer is never shrunk during a call.
  static const int _pcmQueueInitialBytes = 1 << 18; // 256KB

  /// Times the queue ran dry while the beaver was still speaking — the Dart-side
  /// starve count. Debug logging only (see [_pump]); the authoritative view of
  /// whether the push loop is holding is the `PUMP:` line in [_startInflateLog].
  int _dbgStarveCount = 0;

  /// True once [FlutterPcmSound.setup] has run (guards teardown's release()).
  bool _pcmSetup = false;

  /// True while playback is live; gates the feed callback and enqueue so no
  /// audio work runs before setup or after teardown.
  bool _pcmActive = false;

  // Playback tuning (frames = samples; PCM16 mono → 2 bytes/frame @ 24kHz).
  static const int _playbackSampleRate = 24000;
  static const int _playbackChannels = 1;

  /// Backstop threshold for the plugin's feed callback (~400ms).
  ///
  /// Playback is no longer driven by this callback — [_startPushFeed] pushes on
  /// Dart's own clock (see [_pump]). The callback stays wired for two reasons:
  /// it re-anchors the engine-level estimate with a ground-truth number, and it
  /// recovers playback if the push timer ever falls behind. Kept low precisely
  /// so it *doesn't* fire in normal operation: with the push loop holding the
  /// engine at 1.2–2.5s, a callback at 400ms means something went wrong.
  ///
  /// Why the ping-pong had to go: the native playback thread posted its request
  /// through `mainThreadHandler` and the method channel, so the heartbeat of the
  /// playback path ran through the **Android main thread**. Every cushion this
  /// file has grown (200ms → 600ms → 1.5s) was buying time against a busy UI
  /// frame. Pushing from Dart takes the main thread out of the loop instead.
  static const int _feedThresholdFrames = 9600;

  /// How often [_pump] tops the engine up. Short enough that a missed tick is
  /// invisible against the 1.2s low-water mark below.
  static const Duration _pushInterval = Duration(milliseconds: 40);

  /// Engine low-water / target for **real audio**, in frames (~1.2s / ~2.5s).
  ///
  /// Below the low mark, [_pump] refills to the target; above it, the tick does
  /// nothing at all (no channel traffic). The gap between them is the budget for
  /// everything that can go wrong upstream — a stalled main thread, a slow tick,
  /// a Dart GC — and at 1.2s nothing measured on this project comes close.
  ///
  /// Costs no added latency: these bytes would have waited in [_pcmQueue]
  /// anyway; they just wait inside the engine instead.
  static const int _engineLowFrames = _playbackSampleRate * 1200 ~/ 1000;
  static const int _engineTargetFrames = _playbackSampleRate * 2500 ~/ 1000;

  /// Engine low-water / target for **silence**, in frames (~120ms / ~300ms).
  ///
  /// Deliberately far below the audio target: queued silence sits *in front of*
  /// the next real audio, so filling to 2.5s of it would add 2.5s to every reply.
  /// This only has to keep the AudioTrack out of the idle path (AudioFlinger
  /// `BUFFER TIMEOUT` → ~130ms to reactivate) and cover the platform round trip
  /// so the plugin never has to inject its own 20ms silence mid-stream.
  static const int _silenceLowFrames = _playbackSampleRate * 120 ~/ 1000;
  static const int _silenceTargetFrames = _playbackSampleRate * 300 ~/ 1000;

  /// Upper bound on one push (~1.5s of 24kHz PCM16), so a single feed can't
  /// hand the platform channel an unbounded array after a long buffering pause.
  static const int _feedChunkBytes = 72000;

  /// Jitter prebuffer (~900ms of PCM16): at the start of a beaver turn, hold real
  /// audio (feed silence) until this much is queued, so a gap in the server's
  /// delivery can't starve the engine into an audible gap ("voice 씹힘").
  ///
  /// Sized from a measured 5-minute call (19 dropouts, 5.63s of inserted silence).
  /// Every large dropout had the same shape: the server opens a beaver turn with
  /// one **471ms** chunk (`queue 22634B`, byte-identical across turns), then goes
  /// quiet for 0.7–1.4s while it generates, then sends the bulk (up to 4.8s at
  /// once). At the old 400ms the first chunk alone satisfied the gate, so playback
  /// started and ran dry 471ms later — every single turn. The cushion has to be
  /// bigger than that opening chunk or it buys nothing.
  /// ⚠ **통로마다 다르다.** 이 상수는 라이브(900ms) 기본값이자 필드 초기화용이고,
  /// 실제로 쓰는 값은 [_prebufferBytes] 다 — 통화가 열릴 때 [_channelMode] 를 따라간다.
  /// 근거는 [CallChannel.prebufferMs] 주석(두 서버가 오디오를 다른 모양으로 준다).
  static const int _prebufferLiveBytes = _playbackSampleRate * 2 * 900 ~/ 1000;

  /// 이번 통화의 지터 쿠션 하한(바이트). 통로가 정한다.
  int get _prebufferBytes =>
      _playbackSampleRate * 2 * _channelMode.prebufferMs ~/ 1000;

  /// Safety net for a *missed* `turn_end`: audio is queued, the cushion never
  /// fills, and nothing more arrives. Normally unused — a completed short
  /// utterance is released by the `_turnEnded` arm of the gate in [_onFeed], not
  /// by this timer, so this can be generous without delaying short replies.
  static const Duration _prebufferFlush = Duration(milliseconds: 1000);

  /// Adaptive jitter cushion, in bytes. Starts at [_prebufferBytes] and grows
  /// when a turn starves, shrinks back over turns that play clean.
  ///
  /// A fixed cushion cannot hold, because the server delivers a turn's audio at
  /// roughly **90% of realtime** (measured 2026-07-27: 91.9s of audio across
  /// 101.8s of beaver turns). A constant deficit means the cushion drains for as
  /// long as the turn runs, so what's needed scales with turn length, not with
  /// jitter — 900ms covers a 9s turn and nothing longer. Rather than tax every
  /// reply with a cushion sized for the worst turn, this tracks the deficit the
  /// call is actually showing.
  int _cushionBytes = _prebufferLiveBytes;

  /// Growth per starved turn (~150ms), ceiling (~1.2s), and decay per clean turn
  /// (~300ms).
  ///
  /// ⚠ 감쇠가 성장의 **2배**여야 한다. 처음엔 반대(+300/−150)로 뒀는데, 그러면
  /// 값이 통화 내내 단조 증가한다 — 이 쿠션은 모든 응답의 시작 지연에 그대로
  /// 더해지므로 5분 통화의 4분 지점에서 초반보다 눈에 띄게 굼떠진다(실기기 확인,
  /// 2026-08-02). 나쁜 구간이 지나면 되돌아오게 하려면 감쇠가 더 커야 한다.
  /// 시작값 [_prebufferBytes](900ms)는 건드리지 마라 — 그건 재생 안정화의 핵심이라
  /// 낮추면 끊김이 돌아온다.
  ///
  /// 상한 1.8s → 1.2s (2026-08-02 실측). 턴 계측으로 지연을 분해해 보니 재생 시작
  /// 지연 777ms 중 **684ms(88%)가 첫 오디오를 이미 받아둔 뒤 쿠션을 채우느라 기다린
  /// 시간**이었다(서버가 첫 청크를 주기까지는 중앙값 61ms 뿐). 그리고 같은 통화의
  /// 후반 225초는 쿠션이 1050~1200 으로 내려간 상태에서 **끊김 0건**이었다 —
  /// 끊김 5건은 전부 첫 66초에 몰렸고 그때 쿠션은 오히려 1050~1800 이었다.
  /// 즉 1.8s 까지 차오르는 구간은 지연만 더하고 끊김은 못 막았다.
  static const int _cushionStepBytes = _playbackSampleRate * 2 * 150 ~/ 1000;
  static const int _cushionMaxBytes = _playbackSampleRate * 2 * 1200 ~/ 1000;
  static const int _cushionDecayBytes = _playbackSampleRate * 2 * 300 ~/ 1000;

  /// True once the current turn has starved, so the cushion grows once per turn
  /// rather than once per feed callback, and a starved turn can't also decay.
  bool _turnStarved = false;

  /// Cushion required to *resume* after the queue ran dry mid-utterance.
  ///
  /// Separate from the turn-start cushion, which only guards a turn's first
  /// sample. Once [_playing] is set it short-circuits the gate in [_onFeed], so
  /// a starve mid-word used to resume on whatever scrap had arrived — measured
  /// at as little as 120ms — which starved again on the next jitter and again
  /// after that. That loop is the "라디오 신호 안 좋을 때처럼" texture: logs caught
  /// 10 of 27 playback starts below the cushion in a 2.5 minute call.
  ///
  /// Half the adaptive cushion, floored at 400ms (the holes measured were mostly
  /// ≤400ms) and capped at 1.2s so [_prebufferFlush] stays the real bound.
  int get _resumeCushionBytes {
    const floor = _playbackSampleRate * 2 * 400 ~/ 1000;
    const ceil = _playbackSampleRate * 2 * 1200 ~/ 1000;
    final half = _cushionBytes ~/ 2;
    return half < floor ? floor : (half > ceil ? ceil : half);
  }

  /// Settle after `release()` so the singleton native engine fully tears down
  /// before a rapid re-call re-runs `setup()` (the "끊고 바로 통화 시 voice 안 나옴"
  /// re-init race).
  static const Duration _releaseSettle = Duration(milliseconds: 120);

  /// Resync cap: a **runaway guard only**. A normal beaver turn arrives as a
  /// burst and legitimately buffers several seconds (played out over the turn),
  /// so this must be far above any real turn — otherwise resync would clip live
  /// speech and immediately starve. Set to ~60s; only true drift/leak trips it.
  static const int _maxQueueBytes = _playbackSampleRate * 2 * 60;

  /// Resync target after a drop (~45s buffered). Still huge — a drop here means
  /// something is badly wrong; normal turns never reach it.
  static const int _targetQueueBytes = _playbackSampleRate * 2 * 45;

  /// Cap for audio buffered BEFORE playback opens (~20s). The CallKit path opens
  /// the socket first on purpose, so a short pre-roll is normal; a long one means
  /// the audio stage is stuck and the oldest speech is no longer worth replaying.
  static const int _prerollMaxBytes = _playbackSampleRate * 2 * 20;

  /// Bytes currently queued (unfed).
  int get _queueLen => _pcmTail - _pcmHead;

  /// Last feed mode (true=silence, false=audio, null=unset), so [_log] reports
  /// only audio↔silence transitions instead of spamming every feed callback.
  bool? _lastFeedSilent;

  /// True while a feed is mid-flight (awaiting the native `feed`), so
  /// [_teardown] can wait for it before `release()` — a fresh call's `setup()`
  /// must not race a feed running against the old (releasing) engine. It is also
  /// the re-entrancy guard for [_pump]: the push timer and the backstop callback
  /// both call it, and two feeds in flight would double-count the engine level.
  bool _feeding = false;

  /// Drives [_pump] on Dart's own clock instead of waiting to be asked.
  Timer? _pushTimer;

  /// Last known engine queue depth (frames) and when it was known.
  ///
  /// The Android `feed` returns the depth after enqueue, and the backstop
  /// callback carries it too, so both re-anchor this with ground truth. Between
  /// those points [_engineLevelFrames] extrapolates: the engine consumes at
  /// exactly [_playbackSampleRate] (a blocking AudioTrack write never runs fast
  /// or slow), so elapsed time *is* the amount drained.
  int _engineAnchorFrames = 0;
  int _engineAnchorMs = 0;

  /// Estimated frames still queued inside the native engine.
  ///
  /// Floored at zero: once it hits bottom the engine pads with its own silence,
  /// so time past that point doesn't accumulate a debt to be paid back.
  int get _engineLevelFrames {
    final anchorMs = _engineAnchorMs;
    if (anchorMs == 0) return 0;
    final drained = (DateTime.now().millisecondsSinceEpoch - anchorMs) *
        _playbackSampleRate ~/
        1000;
    final level = _engineAnchorFrames - drained;
    return level > 0 ? level : 0;
  }

  /// Re-anchors the estimate after a feed. [atMs] is the time the feed was
  /// *sent*, not when the reply landed: the platform measured its depth
  /// somewhere in between, so anchoring at send time under-reports slightly,
  /// which errs toward feeding more rather than less.
  void _anchorEngine(int frames, int atMs) {
    _engineAnchorFrames = frames;
    _engineAnchorMs = atMs;
    if (frames < _engineMinFrames) _engineMinFrames = frames;
  }

  /// [계측] Lowest engine depth seen this call — the one number that says whether
  /// the push loop is holding. If this stays near [_engineLowFrames] the engine
  /// never came close to drying out, and any remaining glitch is upstream of us.
  int _engineMinFrames = 1 << 30;

  /// True once the jitter prebuffer has filled and real audio is draining. Reset
  /// whenever the queue actually empties — including mid-utterance — so the
  /// cushion is rebuilt rather than run down to nothing for the rest of the turn.
  /// Resuming instantly on a starve (the previous behaviour) traded one gap for a
  /// whole turn with no slack, which measured as repeated dropouts.
  bool _playing = false;

  /// Bounded flush for the prebuffer: if audio is queued but stays below
  /// [_prebufferBytes], start playing anyway so a short utterance never stalls.
  Timer? _prebufferFlushTimer;

  /// Wall-clock anchor for [_log]'s elapsed prefix — set when playback opens, so
  /// every line is stamped with "how far into this call". Without it the pipeline
  /// log has no timestamps at all and a glitch can't be located in time (the whole
  /// point of the "~76초에 음성이 튐" investigation).
  int? _logAnchorMs;

  /// When the queue went empty *while the beaver was still speaking* — i.e. the
  /// server stopped feeding us mid-utterance. Cleared (and reported) when real
  /// audio resumes, which yields the stall duration: the number that decides
  /// whether a client-side buffer can cover it at all.
  int? _starveAtMs;

  /// Set when [_prebufferFlush] gives up waiting for [_resumeCushionBytes], so a
  /// tail that never refills the cushion still plays instead of hanging.
  bool _resumeFlushed = false;

  /// Arrival time of the last inbound audio chunk, for the server-gap metric in
  /// [_feedPlayer]. Independent of playback and of the mic gate.
  int? _lastChunkAtMs;

  /// 마지막 **실오디오**가 스피커에서 끝날 것으로 보는 시각(벽시계 ms).
  ///
  /// [_pump] 가 실오디오를 밀 때마다 갱신한다. 무음 피드는 갱신하지 않는다.
  int _audioTailUntilMs = 0;

  /// 비버 음성이 **정말로** 다 나왔는가 — Dart 큐가 빈 것만으로는 알 수 없다.
  ///
  /// [_pump] 가 Dart 큐를 엔진으로 최대 2.5초 앞당겨 옮기므로, 큐가 비어도 스피커에서는
  /// 아직 나오는 중일 수 있다. 이걸 안 보면 세 가지가 깨진다:
  ///   ① 마이크가 비버 발화 중에 열려 스피커 소리를 되먹는다(반이중 게이트 무력화)
  ///   ② 작별 인사가 release() 에 잘린다(엔진 잔량이 통째로 버려진다)
  ///   ③ 위 둘이 겹쳐 "가끔 뚝 끊긴다"로만 보인다
  ///
  /// ⛔ `_engineLevelFrames <= 임계` 로 판정하지 마라 — 함정이다. [_pump] 의 무음
  ///   분기가 엔진을 **항상** 120~300ms 로 유지하므로, 임계를 300ms 이상 잡으면 무음을
  ///   오디오로 오판하고 300ms 미만으로 잡으면 게이트가 영영 안 열린다. 무음은 실오디오
  ///   *뒤에* 쌓이기 때문에 깊이로는 둘을 가를 수 없다 — 그래서 벽시계를 쓴다.
  ///
  /// 추정치다: 엔진 레벨 자체가 외삽이고 잔량 실측은 안드로이드만 준다. 게이트 판정에만
  /// 쓰고(±수백 ms 허용) 재생 타이밍에는 쓰지 않는다.
  bool get _audioDrained =>
      _queueLen < 2 &&
      DateTime.now().millisecondsSinceEpoch >= _audioTailUntilMs;

  /// Dev-only pipeline log (compiled out of release builds via [kDebugMode]).
  /// Prefixed with elapsed seconds since playback opened (`--` before that).
  void _log(String msg) {
    if (!kDebugMode) return;
    final anchor = _logAnchorMs;
    final at = anchor == null
        ? '--'
        : '${((DateTime.now().millisecondsSinceEpoch - anchor) / 1000).toStringAsFixed(1)}s';
    debugPrint('[call $at] $msg');
  }

  Timer? _elapsedTimer;

  /// Application-level keepalive: pings the server every [_keepaliveInterval] so
  /// the socket has periodic client→server traffic. Without it, a long beaver
  /// monologue (mic gated, no upstream bytes) lets a proxy/LB idle-timeout close
  /// the WS around ~1 min — the "1분 경과 시 voice 끊김" symptom.
  Timer? _keepaliveTimer;
  static const Duration _keepaliveInterval = Duration(seconds: 15);

  /// True once a close is expected (hang-up / `call_ended` / teardown) so the
  /// socket's `onDone` isn't mistaken for an unexpected mid-call drop.
  bool _expectClose = false;

  /// Re-entry guard for [start] (§8-1).
  bool _starting = false;

  /// Bumped by every [hangUp]/[_teardown]; [start] claims a generation and
  /// aborts if it changes across any await — so hanging up while `connecting`
  /// (e.g. the call-loading X) can't be silently overwritten by an in-flight
  /// start that keeps recording/playing after the UI has left (zombie call).
  int _gen = 0;

  /// Set after `call_ended` while draining the beaver's closing line before
  /// sending `playback_done` (§8-4).
  bool _drainScheduled = false;

  /// Stability timer for the closing drain: the queue must stay empty for a
  /// short window (no new audio) before the close completes, so the closing
  /// line isn't cut off. Reset whenever fresh audio arrives.
  Timer? _closingStableTimer;

  /// The `call_ended` drain fallback timer. Stored so it can be cancelled when a
  /// call finishes/tears down — otherwise a stray timer could fire against a
  /// later call.
  Timer? _closingFallbackTimer;

  /// Quiet window the queue must hold (empty) before the closing drain acks.
  static const Duration _closingStableDelay = Duration(milliseconds: 300);

  // ── Half-duplex mic gating (echo-loop prevention) ──────────────────────────
  // On speakerphone the AI's voice bleeds into the mic, gets sent back, is
  // transcribed as user speech, and the AI replies to itself → infinite loop.
  // Echo cancellation alone isn't enough, so while the beaver is speaking we
  // DROP mic frames instead of forwarding them. This is intentionally
  // half-duplex: the user cannot barge-in / interrupt the AI mid-sentence — an
  // accepted tradeoff to kill the self-talk loop.
  //
  // ── 통화 통로 (live ↔ cascade) ────────────────────────────────────────────

  /// 이번 통화가 붙은 통로. 소켓 주소와 마이크 정책이 여기서 같이 갈린다.
  ///
  /// **통화별 런타임 값이다.** 예전엔 컴파일 상수 하나여서 **한 APK 가 한 통로만**
  /// 됐다 — 두 통로를 같이 쓰려면 빌드를 두 벌 내야 했고, 되돌리는 데 스토어 심사가
  /// 꼈다. [CallChannel.defaultChannel] 이 `bool.fromEnvironment` 를 기본값 출처로
  /// 들고 있으므로 **아무도 인자를 안 주면 동작이 종전과 같다.**
  ///
  /// [_connect] 가 통화마다 새로 넣는다(초기 [_teardown] **뒤에**). 값의 출처는 지금은
  /// 호출부이고, 서버가 통화 시작 응답에 실어 주게 되면 그쪽으로 바뀐다.
  CallChannel _channelMode = CallChannel.defaultChannel;

  /// [Android] 통화 용도 오디오로 열지 여부 — 플랫폼 AEC 를 실제로 걸기 위한 스위치.
  ///
  /// **기본은 false = 종전 동작 그대로.** 켜면 세 곳이 한꺼번에 통화 경로로 넘어간다:
  ///   ① 재생 트랙 `USAGE_VOICE_COMMUNICATION`/`CONTENT_TYPE_SPEECH`
  ///   ② 녹음 소스 `AudioSource.voice_communication`
  ///   ③ `AudioManager.MODE_IN_COMMUNICATION` (+ 헤드셋 없으면 스피커폰 강제)
  ///
  /// ⚠ **셋 중 하나만 바꾸면 의미가 없다.** 플랫폼 AEC 는 "통화 다운링크를 참조해
  ///   업링크에서 뺀다"는 구조라, 재생만 통화 경로로 옮기고 녹음이 `DEFAULT` 로 남으면
  ///   참조할 짝이 안 생긴다. 그래서 세 곳이 같은 플래그를 본다.
  ///
  /// ⚠ 켜면 **볼륨 스트림이 미디어→통화로 넘어가고 기본 라우팅이 리시버로 빠지려 한다.**
  ///   그래서 기본을 끔으로 두고, 실기기에서 전/후를 재서 확인한 뒤에 켠다.
  ///   리그는 이 플래그와 무관하게 런타임으로 전/후를 전환한다([debugOpenPlayback]).
  static const bool _androidVoiceAudio =
      bool.fromEnvironment('ANDROID_VOICE_AUDIO');

  /// [_androidVoiceAudio] 로 실제로 모드를 켰는가. 켠 쪽만 되돌린다 — 우리가 안 켠
  /// 모드를 teardown 이 NORMAL 로 돌리면 시스템 통화(CallKit/수신전화)를 밟는다.
  bool _voiceModeSet = false;

  /// Count of mic frames actually forwarded to the socket (dev-log heartbeat).
  int _micFramesSent = 0;

  /// 서버로 **실제로 보낸** 마이크 PCM 누적 바이트. `route_change` 가 이 값을 싣는다.
  ///
  /// ⭐ ms 가 아니라 바이트인 이유는 `played_server_bytes` 와 **같다**: 마이크는
  /// PCM16/16kHz mono = **32,000 B/s 고정**이라 바이트↔ms 는 산수이고, 서버가 받은
  /// 바이트 수와 **정수로 대조**된다. 시각으로 보내면 어느 시계인지가 불분명하고
  /// 네트워크 지터·시계 오차가 낀다 — 서버는 이 판정을 오디오 시각으로 한다.
  int _uplinkBytes = 0;

  /// 마지막으로 서버에 알린 라우트. 같은 값을 반복해 보내지 않는다(콜백은 라우트가
  /// 안 바뀌는 사건에서도 온다 — 예: 볼륨 경로 변경).
  String _lastReportedRoute = '';

  /// 비버 오디오가 살아 있는가 — 턴이 열려 있거나 아직 스피커에서 나오는 중.
  ///
  /// ⚠ 이 플래그는 원래 세 가지를 겸직했다: ①마이크 게이트 ②재생 회계 ③아바타 UI.
  ///   barge-in 을 켜면 ①이 사라지는데, ②③은 그대로 필요하다. 그래서 **저장 필드는
  ///   하나로 두고 해석만 나눈다** — 마이크는 [_micGated] 를 보고, 재생 회계와 아바타는
  ///   이 필드를 직접 본다. 전이 지점을 복제해 두 플래그로 나누면 둘이 어긋나는 새 버그가
  ///   생긴다(전이 지점이 4곳: [_gateMic] / 행오버 / idle-ungate / [_teardown]).
  bool _beaverAudioActive = false;

  /// 마이크 프레임을 버릴 것인가 — 반이중 게이트의 **유일한** 판정.
  ///
  /// 마이크를 여는 데는 **세 조건이 전부** 필요하다. 하나라도 빠지면 종전대로 게이팅한다:
  ///   ① 통로가 캐스케이드다([CallChannel.gatesMic] == false)
  ///   ② **서버가 열라고 했다**([_serverMicAlwaysOpen], `ready.mic_always_open`)
  ///   ③ **플랫폼 AEC 가 실제로 켜져 있다**([_androidVoiceAudio])
  ///
  /// ②가 필요한 이유: 서버 값이 그쪽 에너지 게이트·barge-in 정책과 **한 몸**이다. 서버는
  /// 마이크가 닫힌 전제로 "들어온 소리는 에코"라고 판정하는데 클라가 열어 두면 두 쪽이 다른
  /// 세계를 가정한다. 그래서 **서버가 이긴다** — 서버가 false 면 캐스케이드여도 닫는다.
  ///
  /// ⛔ ③이 필요한 이유 — **서버가 true 를 보내도 우리가 거부한다.** 마이크 상시 개방이
  ///   안전한 유일한 조건은 플랫폼 AEC 가 실제로 걸리는 것이고, 그걸 켜는 스위치가
  ///   [_androidVoiceAudio](기본 꺼짐, 에코 실측 대기 중)다. AEC 없이 열면 비버가 자기
  ///   목소리에 끊긴다 — 실측 전례가 있다(call_id=855: 유저 턴의 절반이 비버 대사였다).
  ///   ⭐ 새 플래그를 만들지 않고 그 스위치를 재사용한다: 안전 조건과 스위치가 **같은 것**이라
  ///   둘로 나누면 한쪽만 켜진 상태가 생긴다. 실측이 끝나 그 스위치가 켜지면 여기도 같이 열린다.
  bool get _micGated {
    if (!_channelMode.gatesMic && _serverMicAlwaysOpen && _androidVoiceAudio) {
      return false;
    }
    return _beaverAudioActive;
  }

  // ── 서버가 준 세션 정책(`ready`) ─────────────────────────────────────────────
  // ⭐ **서버가 이긴다.** 이 값들은 서버의 에너지 게이트·barge-in 확인 정책과 한 몸이라,
  //   클라가 다르게 돌면 두 쪽이 다른 세계를 가정한다.
  // ⚠ 와이어는 **snake_case** 다(`cascade_protocol.py` + 서버 데모 HTML 로 확인).
  //   camelCase 로 읽으면 기능이 **조용히 아무 일도 안 한다** — 그래서 양쪽을 다 받는다.

  /// `ready.mic_always_open`. 도착 전에는 false = **닫혀 있다**(안전한 쪽).
  bool _serverMicAlwaysOpen = false;

  /// `ready.bargein_confirm` — 'immediate' | 'transcript'. 지금은 로그·상태로만 둔다.
  String _serverBargeinConfirm = '';

  /// `ready.turn_silence_ms` — 서버 자체 침묵 타이머. 지금은 로그·상태로만 둔다.
  int _serverTurnSilenceMs = 0;

  /// [계측] 홀수 길이로 도착한 바이너리 프레임 수 — **서버 불변식 I6 의 외부 감시자**다.
  ///
  /// 우리 바이트 큐는 홀수가 와도 다음 청크와 이어붙어 재생이 안 깨진다(구조적으로 안전).
  /// 그래서 **자연 신호가 없다** — 서버가 깨져도 우리는 모른다. 백엔드 회귀는 자기 코드만
  /// 보므로 실기기에서 다른 경로가 생기면 못 본다. **0 이 아니면 서버 버그다.**
  int _oddFrames = 0;

  // ── barge-in: 취소(audio_cancel) 처리 상태 ─────────────────────────────────

  /// `audio_cancel` 을 받은 뒤 **다음 `turn_start` 까지** 도착하는 바이너리를 버릴지.
  ///
  /// 서버 불변식이 이걸 안전하게 만든다: *서버는 비버 턴 밖에서 오디오를 보내지 않고,
  /// 모든 비버 턴은 반드시 `turn_start` 로 시작한다.* 따라서 이 구간에 도착하는
  /// 바이너리는 정의상 **취소된 턴의 잔여**뿐이다(WS 가 한 연결 내 순서를 보장한다).
  ///
  /// ⚠ 폐기는 [_onWsData] 에서 해야 한다. [_feedPlayerBody] 는 청크마다 [_gateMic] 을
  ///   부르므로, 거기까지 들여보내면 잔여 바이트가 게이트를 되닫고 턴 상태를 되살린다.
  bool _cancelledResidual = false;

  /// 서버가 알려준 현재 비버 턴 id. 진행도 회신에 실어 어느 턴인지 밝힌다.
  /// 비동기라 서버가 이미 다음 턴을 시작했을 수 있어, 없으면 아예 싣지 않는다.
  String? _currentTurnId;

  /// 엔진에 넣은 오디오의 출처 원장 — `played_server_bytes` 산출의 근거.
  /// 서버발 오디오와 **우리가 만든 무음 필러**를 갈라야 "실제로 들은 양"이 나온다.
  final PlaybackLedger _ledger = PlaybackLedger();

  /// [_clearPlayback] 이 돌 때마다 증가. **비동기 경합 차단용**이다.
  ///
  /// [_pump] 은 `await FlutterPcmSound.feed(...)` 로 플랫폼채널을 다녀오는데, 그 사이
  /// barge-in 이 들어와 재생을 비울 수 있다. 그때 피드가 돌아와 앵커와
  /// `_audioTailUntilMs` 를 갱신하면 **방금 리셋한 값을 취소된 턴의 값으로 되살린다.**
  /// [_pump] 은 await 전후로 이 값을 비교해 그 갱신을 건너뛴다.
  int _clearGen = 0;

  /// [계측] 직전 비버 턴이 열릴 때의 잔류 백로그(ms). 첫 턴은 -1.
  int _prevTurnBacklogMs = -1;

  /// [계측] 턴 경계 백로그가 연속으로 커진 횟수.
  ///
  /// 정상 버스트 백로그는 **턴 경계에서 반드시 0 으로 돌아온다** — 마이크 재개방 조건
  /// 자체가 오디오 배수 완료([_audioDrained])라서 그렇다. 반면 서버 송출량이 실시간
  /// 레이트를 넘으면(스트림 인플레이션) 백로그가 **턴 경계를 넘어 잔류하고 턴마다 커진다.**
  /// 그래서 이 연속 증가 횟수가 둘을 가르는 지표다. 60초 폭주 가드([_maxQueueBytes])는
  /// 이 구간을 표현하지 못한다 — 10초, 20초로 자라도 아무 말이 없다.
  int _backlogRiseStreak = 0;

  /// True once `turn_end` for the current beaver turn has arrived; the gate
  /// only clears after this *and* the playback queue has drained.
  bool _turnEnded = false;

  /// Hangover timer: after drain + turn_end, waits a short tail before
  /// ungating so the speaker's decaying audio isn't recaptured.
  Timer? _micGateTimer;

  /// Safety timer: if `turn_end` is missed, ungate once playback has been idle
  /// (no new audio, queue empty) for a short window so the mic can't deadlock.
  Timer? _gateSafetyTimer;

  /// Hangover delay after the beaver's audio finishes before re-opening the mic.
  static const Duration _micHangover = Duration(milliseconds: 300);

  /// Idle window after which a missed `turn_end` is assumed and the gate clears.
  static const Duration _gateSafetyWindow = Duration(milliseconds: 800);

  @override
  CallState build() {
    // App-scoped singleton: clean up if the provider container is disposed.
    ref.onDispose(() {
      unawaited(_teardown());
    });
    return const CallState();
  }

  /// Starts a live call from the home flow.
  ///
  /// **캐릭터를 넘기지 않는다** — 서버가 `member.character_id`(사용자가 고른 대표
  /// 캐릭터)로 정한다. 예전엔 여기로 id 를 받아 보냈는데, 호출부가 인자를 안 주면
  /// `call_loading` 이 1(BABA)로 폴백해 마이페이지·기록·온보딩완료에서 건 전화가
  /// 전부 BABA 로 갔다(prod 통화 701 건 중 421 건이 고른 캐릭터와 불일치).
  ///
  /// Re-entry safe (§8-1): returns immediately when already starting or when the
  /// phase is connecting/inCall/ending; otherwise runs [_teardown] first so any
  /// stale socket/recorder/player is closed before a fresh connection opens.
  /// After the socket opens it sends `{type:"start"}` once, which triggers the
  /// server's automatic opening line (§8-3).
  /// [inboundCallId] 는 **안드로이드 수신통화 전용**이다. 안드로이드는 accept 직후
  /// `endAllCalls()` 로 CallKit 을 정리하고 이 경로로 들어오므로 [startFromIncoming]
  /// 을 타지 않는데, 그래도 서버는 어느 알람의 전화인지 알아야 그 알람의 캐릭터로
  /// 연결한다. CallKit 세션은 이미 없으므로 callUuid(끊기용)와는 분리한다.
  ///
  /// [callChannel] 은 이 통화가 붙을 통로다. 안 주면 [CallChannel.defaultChannel] —
  /// 즉 **호출부를 안 고치면 동작이 종전과 같다.** 나중에 서버가 통화 시작 응답으로
  /// 내려주면 그 값을 여기로 넘긴다(필드 계약은 아직 없다).
  Future<void> start({String? inboundCallId, CallChannel? callChannel}) async {
    final ok = await _connect(
      callUuid: null,
      inboundCallId: inboundCallId,
      callkitOwnedAudio: false,
      callChannel: callChannel,
    );
    if (!ok) return;
    await _startAudio();
  }

  /// Starts a call answered through CallKit (a scheduled inbound call).
  ///
  /// Two stages, deliberately decoupled — the socket has nothing to do with audio:
  /// 1. [_connect] runs IMMEDIATELY at accept, so the server starts generating its
  ///    opening line while the audio session is still being handed over. Inbound
  ///    PCM queues up meanwhile (see [_feedPlayer]) instead of being dropped.
  /// 2. [_startAudio] runs once CallKit has activated the call's audio session,
  ///    then drains that queue. No fixed-delay guess.
  ///
  /// Coupling them is what made the lock-screen flow silent: the socket only
  /// opened after the call SCREEN was built, and the screen waited on a
  /// foreground state that never arrives while the device is locked.
  ///
  /// [callUuid] is the CallKit call this session belongs to; [hangUp] ends it so
  /// the lock-screen call UI disappears together with the conversation.
  ///
  /// 그 [callUuid] 는 **서버가 푸시로 내려준 통화 id** 이기도 하다. `start` 에
  /// `inbound_call_id` 로 되돌려주면 서버가 발송 로그로 알람을 되짚어 **그 알람의
  /// 캐릭터**로 통화를 연다 — 알람마다 캐릭터가 다를 수 있는데 대표 캐릭터 하나로는
  /// 표현할 수 없기 때문이다. 앱이 캐릭터를 고르는 게 아니라, 서버가 준 불투명한
  /// uuid 를 그대로 돌려줄 뿐이다.
  Future<void> startFromIncoming({String? callUuid, CallChannel? callChannel}) async {
    final ok = await _connect(
      callUuid: callUuid,
      inboundCallId: callUuid,
      callkitOwnedAudio: true,
      callChannel: callChannel,
    );
    if (!ok) return;
    final myGen = _gen;
    if (!await _awaitCallKitAudio()) {
      // Bounded fallback: better to open audio against a session that may not be
      // ready than to strand the user on a silent call forever.
      _log('CallKit audio-session signal missing → starting audio anyway');
    }
    if (myGen != _gen) return; // hung up while waiting
    await _startAudio();
  }

  /// The plugin's didActivate event (fast path). The native flag is the truth —
  /// this only removes the polling latency. See [_awaitCallKitAudio].
  void onCallKitAudioReady() => _callkitAudioReady = true;

  /// Stage 1 — open the WebSocket and trigger the server's opening line.
  ///
  /// Returns true when the socket is up and the caller should proceed to
  /// [_startAudio]. Never touches playback, the mic, or the audio session.
  Future<bool> _connect({
    required String? callUuid,
    required String? inboundCallId,
    required bool callkitOwnedAudio,
    CallChannel? callChannel,
  }) async {
    if (_starting) return false;
    final phase = state.phase;
    if (phase == CallPhase.connecting ||
        phase == CallPhase.inCall ||
        phase == CallPhase.ending) {
      return false;
    }
    _starting = true;
    try {
      // teardown-first-then-connect → two sockets are structurally impossible.
      await _teardown();
      // Claim this start's generation AFTER the initial teardown. A hangUp() at
      // any await below bumps _gen, so `_stale(myGen)` aborts this start cleanly.
      final myGen = ++_gen;
      // ⚠ 초기 [_teardown] **뒤에** 넣는다. teardown 이 통로를 기본값으로 되돌리므로
      //   앞에서 넣으면 방금 정한 값이 지워진다.
      _channelMode = callChannel ?? CallChannel.defaultChannel;
      _callkitOwnedAudio = callkitOwnedAudio;
      _callUuid = callUuid;
      _callkitAudioReady = false;
      _sessionStartedAt = DateTime.now();
      _gotFirstAudio = false;
      state = const CallState(phase: CallPhase.connecting);

      // Every failure below tears down with keepError so the error phase SURVIVES
      // for the UI to react to. A plain _teardown() resets the state to idle,
      // which silently swallows the message and leaves the loading screen
      // spinning forever with no callback ever arriving.
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token == null || token.isEmpty) {
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: _l10n.loginRequired,
        );
        await _teardown(keepError: true);
        return false;
      }

      // Playback is device-only (flutter_pcm_sound has no web support). Guard so
      // entering a call on web fails cleanly instead of crashing on a missing
      // platform channel. Mic/WS aren't opened either — the call is a no-op here.
      if (kIsWeb) {
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: _l10n.callWebNotSupported,
        );
        await _teardown(keepError: true);
        return false;
      }

      // Capture the baseline max call_id *before* the socket creates this call's
      // row, so a manual hang-up (which gets no `call_ended`) can recover the new
      // id later by polling for an id greater than this.
      //
      // NOT awaited. It is an HTTP round trip, and nothing until the wrap-up
      // screen needs it — but awaiting it here delayed the `start` frame, and
      // therefore the beaver's first word, by that request's entire latency.
      // Fire it alongside the socket instead. A failure just leaves the baseline
      // null and recovery degrades to "newest id".
      unawaited(_captureBaselineCallId(myGen));

      // Connect the WebSocket.
      _expectClose = false;
      // 통로에 따라 소켓 주소가 갈린다. 토큰은 둘 다 같다(서버가 둘 다 Supabase
      // 액세스 토큰을 `verify_token` 으로 본다).
      final url = callStreamWsUrl(
        token: token,
        cascade: _channelMode.isCascade,
      );
      // 통로를 매 연결마다 찍는다. 캐스케이드일 때는 **전제조건 상태까지** 같이 찍는다 —
      // 위험은 "운영 서버냐"가 아니라 "플랫폼 AEC 가 실제로 걸렸냐"다. 마이크가 상시
      // 열리므로 AEC 없이 고르면 비버가 자기 목소리에 끊긴다(call_id=855 전례).
      // ⚠ 게이트가 아니라 **정보**다. 막지 않는 이유는 [CallChannel] 문서 참조 —
      //   클라는 지금 붙은 백엔드가 운영인지 알 방법이 없다(실서비스도 ENV=test 다).
      _log(_channelMode.isCascade
          ? '연결 통로: cascade → ${_channelMode.wsPath} '
              '(마이크 상시개방 · Android 통화용 오디오=$_androidVoiceAudio)'
          : '연결 통로: live → ${_channelMode.wsPath}');
      final channel = WebSocketChannel.connect(Uri.parse(url));
      _channel = channel;
      _wsSub = channel.stream.listen(
        _onWsData,
        onDone: _onWsDone,
        onError: _onWsError,
        cancelOnError: false,
      );

      // §8-3: trigger the server's auto opening line (no button).
      //
      // (멀티랭귀지) target_language 는 **보내지 않는다** — 서버가 member.target_language
      // 를 읽어 그 언어의 코스(레벨테스트·체크판·레벨업)로 진행한다. 예전엔 여기서
      // SharedPreferences 값을 실어 보냈는데, 그 복원이 비동기라 **복원 전에 통화가
      // 시작되면 기본 'ko' 가 나갔다**(잠금화면 수신통화가 정확히 그 구간이다 —
      // 콜드스타트 → accept → 즉시 connect). 앱을 지우면 선택도 리셋됐고, 서버가 거는
      // 예약전화인데 언어는 클라가 정하는 모순도 있었다. 이제 DB 가 단일 소스다.
      //
      // (캐릭터) character_id 도 **보내지 않는다** — 같은 이유로 서버가 정한다.
      // 수신통화만 서버가 준 통화 id 를 `inbound_call_id` 로 되돌려주고, 서버가
      // 그걸로 알람을 되짚어 그 알람의 캐릭터를 쓴다. 홈에서 건 전화는 이 필드가
      // 없어 서버가 member.character_id 를 쓴다.
      _send({
        'type': 'start',
        'inbound_call_id': ?inboundCallId,
        // (barge-in) AEC 자기진단. 서버가 **세션마다** 끼어들기 확인 방식을 고르는 입력이다.
        'aec': await _aecHint(),
      });

      // Keepalive so an idle proxy/LB doesn't drop the socket mid-call.
      _startKeepalive();
      _log('socket connected (audio pending)');
      unawaited(_logNativeAudio('connect/socket-open'));
      return true;
    } catch (e) {
      state = state.copyWith(
        phase: CallPhase.error,
        errorMsg: _l10n.callConnectFailed,
      );
      await _teardown(keepError: true);
      return false;
    } finally {
      _starting = false;
    }
  }

  /// 세션 시작에 실을 AEC 자기진단(`start.aec`).
  ///
  /// 서버는 이걸로 **세션마다** barge-in 확인 방식을 고른다 — 이어폰은 음향 결합이
  /// 사실상 없어 즉시 끊어도 되지만, 스피커폰 + AEC 미적용이면 비버가 자기 목소리에
  /// 끊긴다. 전역 설정 하나로는 이 차이를 못 담는다.
  ///
  /// ## ⛔ 관측한 것만 싣는다. 정책은 서버 몫이다
  ///
  /// - **`hw`(플랫폼 AEC 가 실제로 걸렸다)를 실측 전에 주장하지 않는다.**
  ///   `AcousticEchoCanceler.create()` 가 호출된다는 것까지는 확인됐지만
  ///   (flutter_sound_core AAR), **불렸다와 걸렸다는 다르다** — 기기가 지원하지 않으면
  ///   조용히 실패한다. `hw` 는 서버에서 `immediate` 를 켜고, 그건 자기-대화 루프의
  ///   문을 여는 것이다. 에코 실측이 나온 뒤에 매핑을 확정한다.
  /// - **`immediate`/`transcript` 같은 정책을 클라가 요청하지 않는다.** "헤드셋이다"
  ///   까지만 말한다. 클라가 정책을 실어 보내기 시작하면 서버가 정책을 바꿔도 구버전
  ///   앱이 안 따라온다.
  /// - 라우트를 못 읽으면 필드를 **빼서** 보낸다(서버 기본 None). `speaker` 로 추측해
  ///   채우면 측정 실패와 스피커폰이 서버에서 같은 값이 된다.
  ///
  /// ## ⚠ 한계 두 가지
  ///
  /// ① **재생을 열기 전 시점의 스냅샷이다** — `start` 는 오디오보다 먼저 나가야 한다.
  ///   그래도 우리가 쓰는 유일한 구분(헤드셋이냐 아니냐)은 물리적 사실이라 재생 전에도
  ///   맞다. speaker/receiver 구분은 활성 라우트에 의존해 흔들릴 수 있는데, 그 둘은
  ///   어차피 똑같이 `unknown` 으로 떨어진다.
  /// ② **통화 도중 라우트가 바뀌면 서버에 알릴 방법이 없다.** 이어폰을 뽑으면
  ///   speaker 로 넘어가는데 서버는 세션 시작의 `headset` 을 계속 믿는다. 프로토콜에
  ///   세션 중 재통보가 없다(서버 주석도 P1 로 남겨 뒀다). 지금은 그대로 두되,
  ///   "이어폰 뽑고 에코가 터졌는데 왜 immediate 로 남아 있었나"는 여기가 원인이다.
  Future<Map<String, dynamic>> _aecHint() async {
    final route = await AudioRouteProbe.currentRoute();
    return <String, dynamic>{
      'mode': route == 'headset' ? 'headset' : 'unknown',
      if (route.isNotEmpty) 'route': route,
    };
  }

  /// 통화 **도중** 출력 라우트가 바뀌면 서버에 알린다(`route_change`).
  ///
  /// ## 왜 필요한가
  ///
  /// `start.aec` 는 **세션 시작 스냅샷**이다. 통화 중 이어폰을 뽑으면 서버는 계속
  /// `headset` 을 믿고 즉시 끊기 정책을 유지하는데, 실제로는 **스피커폰**(에코 최악)이다.
  /// 정확히 그 전이가 안 잡혀서 비버가 자기 목소리에 끊긴다.
  ///
  /// ## 페이로드가 `start.aec` 와 **같은 객체**인 이유
  ///
  /// 서버가 `_apply_aec_hint` 를 그대로 재사용할 수 있다. 필드를 새로 만들면 두 곳이
  /// 갈라지고, **갈라진 두 곳은 반드시 어긋난다.**
  ///
  /// ⛔ 정책(`immediate`/`transcript`)은 여전히 **클라가 요청하지 않는다.** "지금 헤드셋이다"
  ///   까지만 말한다. `hw` 도 실측 전까지 쓰지 않는다 — [_aecHint] 와 같은 규칙이다.
  Future<void> _onRouteChanged() async {
    final route = await AudioRouteProbe.currentRoute();
    // 콜백은 라우트가 안 바뀌는 사건에서도 온다. 같은 값을 반복해 보내면 서버가
    // 정책을 계속 다시 잡는다.
    if (route == _lastReportedRoute) return;
    _lastReportedRoute = route;
    _send({
      'type': 'route_change',
      'aec': <String, dynamic>{
        'mode': route == 'headset' ? 'headset' : 'unknown',
        if (route.isNotEmpty) 'route': route,
      },
      // ⭐ 시각이 아니라 **업링크 누적 바이트**다. 마이크는 PCM16/16kHz mono =
      //   32,000 B/s 고정이라 서버가 받은 바이트와 정수로 대조된다. 시각으로 보내면
      //   어느 시계인지 불분명하고 지터·시계 오차가 낀다(`played_server_bytes` 와 같은 논거).
      'uplink_bytes': _uplinkBytes,
    });
    _log('route_change → ${route.isEmpty ? '(못 읽음)' : route} '
        'uplink=${_uplinkBytes}B (=${_uplinkBytes ~/ 32}ms)');
  }

  /// Opens the native PCM playback engine and starts the push pump.
  ///
  /// Extracted from [_startAudio] so the debug cancel rig ([debugOpenPlayback])
  /// can bring up the exact same pipeline **without** a socket, mic, or audio
  /// session. Copy-pasting it there would have drifted: this block owns the
  /// per-call playback reset (cushion, ledger, barge-in flags), and a rig running
  /// against a stale copy of that reset would measure a pipeline the call never
  /// uses. Touches nothing outside playback.
  Future<void> _openPlayback({bool? voiceCallAudio}) async {
    // [AEC] 통화 용도로 열지. 리그만 인자로 덮어쓰고(리빌드 없이 전/후 측정), 통화
    // 경로는 컴파일 플래그를 따른다.
    final voice = voiceCallAudio ?? _androidVoiceAudio;
    if (voice && !kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // ⚠ setup() **전에** 모드를 세운다. AudioTrack 은 만들어지는 시점의 모드로
      //   라우팅이 정해지므로, 뒤에 바꾸면 이번 트랙에는 안 먹는다.
      final diag = await AudioRouteProbe.setVoiceCallMode(true);
      _voiceModeSet = true;
      _log('AEC: 통화 용도 오디오 ON → $diag');
    }

    // Open native gapless PCM playback at the server's 24kHz (no upsampling).
    // The feed callback pulls from [_pcmQueue]; silence keep-alive prevents the
    // underflow-churn stall that cut audio out after ~1 minute.
    //
    // NOTE: _pcmQueue/_pcmHead are NOT reset here. [_connect]'s teardown already
    // cleared them, and anything that arrived since is the server's opening line
    // waiting to be played — clearing it would silence exactly what we buffered.
    _pcmActive = false;
    _playing = false;
    await FlutterPcmSound.setLogLevel(LogLevel.error);
    await FlutterPcmSound.setup(
      sampleRate: _playbackSampleRate,
      channelCount: _playbackChannels,
      // MUST be passed — both defaults are wrong for a phone call:
      //
      // `iosAllowBackgroundAudio` defaults to FALSE, and the plugin's `feed`
      // handler then does this whenever the app is not active:
      //     if (!mIsAppActive && !mAllowBackgroundAudio) {
      //         [self.mSamples setLength:0];   // discards the audio
      //         result(@YES);                  // and reports SUCCESS
      //     }
      // i.e. every PCM chunk is silently thrown away the moment the screen
      // locks, with no error for us to see — the beaver went mute on the lock
      // screen and audio "came back" only when the app was reopened
      // (mIsAppActive flips on UIApplicationDidBecomeActive).
      //
      // `iosAudioCategory` defaults to `playback`, and setup() applies it with
      // setCategory: alone — no options, no mode — wiping playAndRecord +
      // allowBluetooth + defaultToSpeaker + voiceChat. `playback` has no input
      // at all. We re-assert the full category right after (routeToSpeaker),
      // but ask for the closest one so the window is harmless.
      iosAudioCategory: IosAudioCategory.playAndRecord,
      iosAllowBackgroundAudio: true,
      androidVoiceCallAudio: voice,
    );
    _pcmSetup = true;
    await FlutterPcmSound.setFeedThreshold(_feedThresholdFrames);
    FlutterPcmSound.setFeedCallback(_onFeed);
    _pcmActive = true;
    _lastFeedSilent = null;
    _envQueue.clear();
    // ⛔ 큐에 꽂아 둔 **미발화 마커**도 같이 버린다. 안 지우면 다음 턴에 지난 턴
    //   표정·자막이 뜬다(그 오디오는 이미 폐기됐다).
    _pendingMarkers.clear();
    // 진행 중이던 드러내기도 멈춘다 — 남은 글자가 새면 안 들은 말이 자막에 남는다.
    _resetReveal();
    _startEnvelope();
    _startEventLoopProbe(); // [계측] 청크 갭의 원인(서버 공백 vs 루프 블록) 판별용
    _startInflateLog(); // [계측] 무음 주입으로 스트림이 부풀어 백로그가 자라는지 판별용

    // Per-call playback state. The cushion in particular must not carry over:
    // a rough previous call must not tax this one.
    _logAnchorMs = DateTime.now().millisecondsSinceEpoch;
    _starveAtMs = null;
    _cushionBytes = _prebufferBytes;
    _turnStarved = false;
    _resumeFlushed = false;
    // barge-in 상태도 통화 스코프다: 이전 통화의 취소 구간이 살아 있으면 새 통화의
    // 첫 인사가 통째로 폐기된다.
    _cancelledResidual = false;
    _cancelledResidualBytes = 0;
    _currentTurnId = null;
    _ledger.reset();
    _prevTurnBacklogMs = -1;
    _backlogRiseStreak = 0;

    // Drive playback from Dart's own clock instead of the plugin's feed
    // callback. Note this also sidesteps FlutterPcmSound.start(), which only
    // kicks when the plugin's *static* `_needsStart` flag is true — and that
    // flag is NEVER reset by release()/setup(): the first call feeds audio →
    // sets it false → it stays false, so on the 2nd call start() no-ops and
    // playback never begins (the "재통화 시 음성 안 나옴" bug). Pumping ourselves
    // is independent of that stale flag and works on every call.
    // 통화 도중 라우트 전환을 서버에 알린다(`route_change`). 재생을 연 뒤에 건다 —
    // 그래야 첫 조회가 실제 통화 라우트를 본다(재생 전에는 세션이 아직 안 굳었다).
    _lastReportedRoute = await AudioRouteProbe.currentRoute();
    AudioRouteProbe.setRouteChangeListener(() => unawaited(_onRouteChanged()));
    _startPushFeed();
    unawaited(_pump()); // don't wait a tick to open the stream
    _log('playback started @ ${_playbackSampleRate}Hz '
        '(queued ${_queueLen}B waiting)');
  }

  /// Stage 2 — open playback and the mic, then drain whatever the server already
  /// sent while the audio session was being handed over.
  Future<void> _startAudio() async {
    final myGen = _gen;
    try {
      // 잠금화면에서 예약전화를 받으면 accept 직후엔 아직 잠금 해제/화면 전환 전이라,
      // **안드로이드는** 마이크 접근을 막는다. iOS는 CallKit이 통화 오디오 세션을
      // 소유하고 `audio` 백그라운드 모드가 있어 잠금 상태에서도 정상 동작하므로
      // 기다리지 않는다 — 기다리면 잠금 중엔 resumed에 영영 도달하지 않아 통화가
      // 통째로 멈춘다(잠금화면 무음의 직접 원인이었다).
      if (defaultTargetPlatform != TargetPlatform.iOS) {
        await _awaitForeground();
        if (myGen != _gen) return _abortStart();
      }

      // 마이크(음성) 권한 확인·요청. 이미 허용돼 있으면 즉시 통과하고, 아니면 시스템
      // 권한 팝업을 띄운다. 거부 상태면 마이크 없이는 대화가 불가하므로 안내하고 끝낸다
      // (소켓은 이미 열려 있으므로 반드시 teardown 한다).
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: micStatus.isPermanentlyDenied
              ? _l10n.micPermissionNeededBody
              : _l10n.micPermissionRequiredForCall,
        );
        await _teardown(keepError: true);
        return;
      }
      if (myGen != _gen) return _abortStart();

      // Route call audio like a loud media/Bluetooth CALL, not the quiet earpiece.
      // With no explicit session, the voice-processing recorder pins output to the
      // receiver at call volume and never picks AirPods. playAndRecord +
      // defaultToSpeaker + allowBluetooth sends it to the speaker / BT headset;
      // voiceChat keeps the echo canceller working. Best-effort: a failure here
      // shouldn't abort the call, just leave default routing.
      //
      // NO allowBluetoothA2DP: A2DP is an OUTPUT-only (music) profile with no mic.
      // Allowing it lets iOS route call output over A2DP, which breaks the BT mic
      // (HFP) path — the beaver is heard but the user's voice is not captured.
      // HFP (allowBluetooth) carries both mic and speaker for a two-way call.
      //
      // Activation has exactly ONE owner per call:
      // - home path: this controller.
      // - CallKit path: the system (didActivate) — the only way to get an active
      //   call audio session while the device is locked. The category is already
      //   set natively there (AppDelegate.configureCallAudioCategory), so we must
      //   not re-configure or re-activate underneath a live call.
      //
      // But VERIFY rather than assume: if CallKit's activation never happened
      // ([_awaitCallKitAudio] timed out), nobody has activated the session and it
      // is silent in BOTH directions while the socket runs on regardless. In that
      // case fall back to activating it ourselves.
      final systemOwnsActiveSession =
          _callkitOwnedAudio && await _isCallKitAudioActive();
      if (!systemOwnsActiveSession) {
        if (_callkitOwnedAudio) {
          _log('CallKit never activated the session → activating it ourselves');
        }
        try {
          final session = await AudioSession.instance;
          await session.configure(AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.defaultToSpeaker |
                    AVAudioSessionCategoryOptions.allowBluetooth,
            avAudioSessionMode: AVAudioSessionMode.voiceChat,
          ));
          await session.setActive(true);
          _weActivatedSession = true;
        } catch (e) {
          _log('audio session configure failed: $e');
        }
        if (myGen != _gen) return _abortStart();
      }
      await _logNativeAudio('startAudio/session-ready +${_elapsedSinceStartMs}ms');

      await _openPlayback();
      if (myGen != _gen) return _abortStart();

      // iOS: settle the category and select a Bluetooth headset input BEFORE
      // opening the recorder. The voice-processing (VoiceProcessingIO) unit binds
      // to whatever input is active at open time; setting the BT input only AFTER
      // _startMic leaves the unit pinned to the built-in mic and the user's voice
      // over AirPods is never captured. Doing it first is what makes the BT mic work.
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await _audioRouteChannel.invokeMethod<void>('routeToSpeaker');
          _audioRoutingStarted = true;
        } catch (_) {}
      }

      // Start streaming the mic to the server.
      await _startMic();
      if (myGen != _gen) return _abortStart();
      // The recorder can open successfully and still capture nothing when the
      // session/route was not settled yet — a silent failure with no exception.
      // Watch for it and re-open once.
      _armMicWatchdog();

      // Force the loudspeaker (speakerphone). flutter_sound's voice-processing
      // recorder just re-pinned the session to the earpiece(receiver), undoing
      // the defaultToSpeaker option; re-assert now that the mic is up. iOS-only,
      // best-effort; the native side keeps a headset/AirPods route if connected.
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await _audioRouteChannel.invokeMethod<void>('routeToSpeaker');
          _audioRoutingStarted = true;
        } catch (_) {}
      }
      await _logNativeAudio('startAudio/mic-up +${_elapsedSinceStartMs}ms');
    } catch (e) {
      state = state.copyWith(
        phase: CallPhase.error,
        errorMsg: _l10n.callConnectFailed,
      );
      await _teardown(keepError: true);
    }
  }

  /// Fetches the pre-call max `call_id` in the background (see [_connect]).
  /// Applied only if this call is still the current one.
  Future<void> _captureBaselineCallId(int myGen) async {
    try {
      final base = await ref.read(normalcallRepositoryProvider).latestCallId();
      if (myGen != _gen) return;
      state = state.copyWith(baselineCallId: base);
    } catch (_) {
      // Recovery degrades to "newest id".
    }
  }

  /// Milliseconds since this call's socket was opened — for latency logging.
  int get _elapsedSinceStartMs => _sessionStartedAt == null
      ? -1
      : DateTime.now().difference(_sessionStartedAt!).inMilliseconds;

  /// Asks the native side whether CallKit currently holds an ACTIVE call audio
  /// session (between didActivate and didDeactivate). False on non-iOS.
  Future<bool> _isCallKitAudioActive() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return false;
    if (_callkitAudioReady) return true;
    try {
      return await _callkitChannel
              .invokeMethod<bool>('isCallAudioSessionActive') ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Dumps the live audio-session state to the NATIVE log.
  ///
  /// [_log] is compiled out of release builds (`kDebugMode`), so a TestFlight run
  /// — the only place the lock-screen flow can be exercised — is otherwise
  /// completely blind. NSLog survives release and shows up in Console.app.
  Future<void> _logNativeAudio(String tag) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _audioRouteChannel
          .invokeMethod<void>('logAudioState', <String, dynamic>{'tag': tag});
    } catch (_) {}
  }

  /// Waits for CallKit to activate the call's audio session (didActivate).
  ///
  /// The plugin's event for this is as unbuffered as the accept event, so the
  /// NATIVE flag is the source of truth and [onCallKitAudioReady] merely removes
  /// the polling latency. Bounded — returns false on timeout so the caller can
  /// start audio anyway rather than waiting forever. Non-iOS returns immediately.
  Future<bool> _awaitCallKitAudio() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return true;
    final deadline = DateTime.now().add(_callkitAudioTimeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await _isCallKitAudioActive()) return true;
      await Future<void>.delayed(_callkitAudioPollInterval);
    }
    return false;
  }

  /// Aborts an in-flight [start] whose generation was superseded by a [hangUp]:
  /// tears down anything already opened. The phase was already set by the
  /// hangUp, so [_teardown] preserves it.
  Future<void> _abortStart() async {
    _log('start aborted — superseded by hang up');
    await _teardown();
  }

  /// User-initiated hang up: ends the CallKit call (if this session has one),
  /// closes the socket (the server finalizes the call in its `finally`) and tears
  /// the pipeline down (§8-2).
  ///
  /// Re-entrant by design: ending the CallKit call fires `ACTION_CALL_ENDED`,
  /// which the coordinator routes back here. [_hangingUp] absorbs that bounce.
  Future<void> hangUp() async {
    if (_hangingUp) return;
    _hangingUp = true;
    try {
      await _hangUp();
    } finally {
      _hangingUp = false;
    }
  }

  /// Re-entry guard for [hangUp] — see its doc.
  bool _hangingUp = false;

  /// 끝난 통화의 결과를 **소비했다**고 표시하고 [CallPhase.idle] 로 되돌린다.
  ///
  /// [_teardown] 은 `ended` 를 일부러 보존한다 — 요약 화면이 callId·통화 시간을 읽어야
  /// 하기 때문이다. 그런데 그 상태를 **아무도 되돌리지 않아서**, 한 번 통화가 끝나면
  /// phase 가 `ended` 로 남았다. `call_loading` 은 진입 시 phase 를 보고 분기하므로
  /// (`ended` → 요약 화면), 그 뒤로는 홈에서 전화하기를 눌러도 새 통화가 시작되지 않고
  /// 지난 통화의 요약 화면만 떴다. 앱을 껐다 켜야(= ProviderContainer 가 새로 생겨야)
  /// 다시 통화할 수 있었다.
  ///
  /// 그래서 결과를 다 쓴 화면이 떠날 때 이걸 호출한다. 요약 화면은 callId·통화 시간을
  /// 라우트 인자로 따로 받으므로, 넘어간 뒤에 상태를 비워도 표시에는 영향이 없다.
  ///
  /// **끝난 통화에만 적용된다.** 이미 다음 통화가 시작된 상태(connecting/inCall 등)면
  /// 아무 것도 하지 않는다 — 살아 있는 통화를 지워버리면 안 된다.
  void clearFinished() {
    if (state.phase == CallPhase.ended || state.phase == CallPhase.error) {
      state = const CallState();
    }
  }

  Future<void> _hangUp() async {
    // Invalidate any in-flight start() so it can't re-establish the pipeline
    // after we tear it down here.
    _gen++;
    _expectClose = true;
    if (state.phase == CallPhase.ended || state.phase == CallPhase.idle) {
      await _teardown();
      return;
    }
    final preservedCallId = state.callId;
    // Preserve the elapsed time too so the wrap-up screen can show the real call
    // duration ([_teardown] would otherwise reset it to 0).
    final preservedElapsed = state.elapsedSec;
    // Preserve the baseline so the wrap-up screen can recover the call id when
    // this was a manual hang-up (no `call_ended`, so [preservedCallId] is null).
    final preservedBaseline = state.baselineCallId;
    await _teardown();
    state = CallState(
      phase: CallPhase.ended,
      callId: preservedCallId,
      elapsedSec: preservedElapsed,
      baselineCallId: preservedBaseline,
    );
  }

  /// Opens the recorder and pipes its PCM16k stream straight to the socket.
  Future<void> _startMic() async {
    final controller = StreamController<Uint8List>();
    _micController = controller;
    _micSub = controller.stream.listen((bytes) {
      // Counted BEFORE the gate: this measures whether the recorder is capturing
      // at all, which is a different failure from "gated because the beaver is
      // speaking". [_armMicWatchdog] keys off it.
      _micFramesReceived++;
      // Half-duplex gate: while the beaver is speaking (or its audio tail is
      // still decaying), DROP the frame so the AI's voice picked up by the mic
      // is never echoed back to the server's STT (which caused the self-talk
      // loop on speakerphone). The recorder keeps running so the audio
      // session / AEC stays stable; we only skip forwarding.
      //
      // 캐스케이드 barge-in 에서는 [_micGated] 가 항상 false 라 이 줄이 통과된다 —
      // 마이크 상시 개방. 끼어들기 판정은 서버가 한다.
      if (_micGated) return;
      final ch = _channel;
      if (ch != null) {
        ch.sink.add(bytes);
        // ⭐ 업링크 누계 — `route_change.uplink_bytes` 의 기준값이다. **보낸 것만** 센다
        //   (게이팅으로 버린 프레임은 서버가 받지 못했으므로 서버 카운터와 어긋난다).
        _uplinkBytes += bytes.length;
        if (++_micFramesSent % 50 == 0) {
          _log('mic → sent $_micFramesSent frames (your voice flowing)');
        }
      }
    });

    // 마이크 열기 재시도: 잠금화면 accept 직후엔 (아직 잠금 해제/포그라운드 전환 중이거나)
    // 직전 CallKit 통화가 잡았던 오디오 세션(Android MODE_IN_COMMUNICATION·오디오 포커스)이
    // 아직 해제되기 전이라 AudioRecord 생성이 실패할 수 있다
    // ("AudioFlinger could not create record track, status: -1"). 잠깐 뒤 다시 열면 되는
    // 일시 실패라, 짧은 백오프로 재시도한다.
    // iOS: with a headset (AirPods/BT/wired) connected, DISABLE voice processing.
    // flutter_sound's voice processing (VoiceProcessingIO) refuses the Bluetooth
    // HFP mic on iOS, so the user's voice was never captured over AirPods. A plain
    // recorder follows the session route and uses the BT mic. Voice processing is
    // only needed for the loudspeaker case (echo cancellation) — no headset there.
    var useVoiceProcessing = true;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final headset = await _audioRouteChannel
            .invokeMethod<bool>('isHeadsetConnected');
        if (headset == true) useVoiceProcessing = false;
      } catch (_) {}
    }

    Object? lastError;
    for (var attempt = 1; attempt <= _micOpenMaxAttempts; attempt++) {
      final recorder = FlutterSoundRecorder();
      _recorder = recorder;
      try {
        await recorder.openRecorder();
        await recorder.startRecorder(
          toStream: controller.sink,
          codec: Codec.pcm16,
          sampleRate: 16000,
          numChannels: 1,
          enableVoiceProcessing: useVoiceProcessing,
          enableEchoCancellation: true,
          // [AEC] 녹음 소스. 기본(`defaultSource` = MediaRecorder.AudioSource.DEFAULT)
          // 은 **통화 경로가 아니다** — 플랫폼 AEC 는 통화 다운링크를 참조해 업링크에서
          // 빼는 구조라, 재생만 통화 경로로 옮기고 여기가 DEFAULT 로 남으면 참조할 짝이
          // 안 생겨 아무 효과가 없다. 재생 트랙과 **반드시 같은 플래그**를 본다.
          audioSource: _androidVoiceAudio &&
                  !kIsWeb &&
                  defaultTargetPlatform == TargetPlatform.android
              ? AudioSource.voice_communication
              : AudioSource.defaultSource,
        );
        if (attempt > 1) _log('mic opened on retry (attempt $attempt)');
        return; // 성공
      } catch (e) {
        lastError = e;
        _log('mic open failed ($attempt/$_micOpenMaxAttempts): $e');
        try {
          await recorder.closeRecorder();
        } catch (_) {}
        _recorder = null;
        if (attempt < _micOpenMaxAttempts) {
          await Future<void>.delayed(_micOpenRetryDelay);
        }
      }
    }
    throw Exception('마이크를 열 수 없습니다(재시도 $_micOpenMaxAttempts회 실패): $lastError');
  }

  // ── Mic capture watchdog ──────────────────────────────────────────────────
  // openRecorder()/startRecorder() can both succeed against a session that is
  // not actually usable yet and then deliver NOTHING — no exception, no retry,
  // just a call where the user is never heard. Detect it by the absence of
  // frames and re-open the recorder once.

  /// Frames the recorder produced (counted before the half-duplex gate).
  int _micFramesReceived = 0;
  Timer? _micWatchdogTimer;
  bool _micRestarted = false;

  /// How long a live recorder may produce nothing before it is presumed broken.
  /// Comfortably longer than the opening greeting's ramp-up.
  static const Duration _micWatchdogDelay = Duration(seconds: 6);

  /// Arms the one-shot capture watchdog (see [_micFramesReceived]).
  void _armMicWatchdog() {
    _micWatchdogTimer?.cancel();
    _micWatchdogTimer = Timer(_micWatchdogDelay, () async {
      _micWatchdogTimer = null;
      if (_micFramesReceived > 0 || _micRestarted) return;
      final phase = state.phase;
      if (phase != CallPhase.inCall && phase != CallPhase.connecting) return;
      _micRestarted = true; // one attempt only — never loop on a dead mic
      _log('mic captured nothing in ${_micWatchdogDelay.inSeconds}s → reopening');
      await _logNativeAudio('mic-watchdog/before-restart');
      final myGen = _gen;
      try {
        await _restartMic();
      } catch (e) {
        _log('mic reopen failed: $e');
        return;
      }
      if (myGen != _gen) return;
      await _logNativeAudio('mic-watchdog/after-restart');
    });
  }

  /// Closes the recorder and opens a fresh one, keeping the call otherwise live.
  Future<void> _restartMic() async {
    await _micSub?.cancel();
    _micSub = null;
    try {
      await _recorder?.stopRecorder();
    } catch (_) {}
    try {
      await _recorder?.closeRecorder();
    } catch (_) {}
    _recorder = null;
    await _micController?.close();
    _micController = null;
    await _startMic();
  }

  /// 마이크 열기 최대 재시도 횟수(오디오 세션 해제 지연/포그라운드 전환 흡수).
  static const int _micOpenMaxAttempts = 6;

  /// 마이크 열기 재시도 간격.
  static const Duration _micOpenRetryDelay = Duration(milliseconds: 400);

  /// 앱이 실제로 포그라운드(resumed) 될 때까지 대기한다(최대 [timeout]).
  ///
  /// 잠금화면에서 예약전화를 받으면 accept 직후엔 아직 잠금 해제/화면 전환 전이라,
  /// 안드로이드가 마이크 접근을 막고 오디오도 제대로 안 난다. 앱이 켜져 통화 화면으로
  /// 들어온 뒤(resumed)에 오디오를 시작해야 한다. 일반(홈→전화하기) 경로는 이미
  /// resumed라 즉시 통과한다. 타임아웃되면 그냥 진행한다(마이크 재시도가 흡수).
  Future<void> _awaitForeground({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    const interval = Duration(milliseconds: 200);
    final deadline = DateTime.now().add(timeout);
    while (
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      if (!DateTime.now().isBefore(deadline)) return;
      await Future<void>.delayed(interval);
    }
  }

  /// WebSocket data handler. Splits text (control JSON) from binary (PCM) (§8-7).
  void _onWsData(dynamic data) {
    if (data is String) {
      _handleControl(data);
    } else if (data is Uint8List) {
      _onWsAudio(data);
    } else if (data is List<int>) {
      _onWsAudio(Uint8List.fromList(data));
    }
  }

  /// 인바운드 오디오의 첫 관문 — **취소된 턴의 잔여를 여기서 버린다.**
  ///
  /// [_feedPlayer] 안쪽이 아니라 이 자리인 이유: [_feedPlayerBody] 는 청크마다
  /// [_gateMic] 을 호출해 턴을 "다시 연다"(`_beaverAudioActive=true`, `_turnEnded=false`).
  /// 큐를 비우는 것만으로는 그 뒤 도착분을 막지 못하므로, 진입 자체를 차단해야 한다.
  void _onWsAudio(Uint8List chunk) {
    // [계측] 홀수 길이 = **서버 불변식 I6 위반**. 우리 큐는 다음 청크와 이어붙어 재생이
    // 안 깨지므로 자연 신호가 없다 — 세지 않으면 아무도 모른다. 재생은 손대지 않는다.
    // 첫 1건만 로그로 튀우고(로그 폭발 방지) 총계는 진행도 회신에 실어 서버로 보낸다.
    if (chunk.length.isOdd) {
      _oddFrames++;
      if (_oddFrames == 1) {
        _log('⚠ 홀수 길이 오디오 프레임 도착(${chunk.length}B) — 서버 I6 위반이다. '
            '재생은 이어붙여 계속한다. 총계는 playback_progress.odd_frames 로 보낸다');
      }
    }
    if (_cancelledResidual) {
      _cancelledResidualBytes += chunk.length;
      return;
    }
    _feedPlayer(chunk);
  }

  /// [계측] 취소 후 버린 잔여 바이트. 서버 페이서가 취소에 얼마나 빨리 반응하는지가
  /// 이 숫자로 드러난다(클수록 서버가 늦게 멈춘 것).
  int _cancelledResidualBytes = 0;

  /// Enqueues an inbound PCM24k chunk onto [_pcmQueue]. The plugin's feed
  /// callback ([_onFeed]) drains it; here we only gate the mic, reset the
  /// closing-drain stability window, and cap the queue (resync).
  // [계측] 수신 처리 시간이 통화가 갈수록 무거워지는지(1분 후 악화 원인) 측정.
  int _fpLastUs = 0, _fpChunks = 0, _fpMicros = 0, _fpWinMs = 0, _fpMaxGapMs = 0;
  // [계측] 창당 수신 바이트 — 서버가 "느려진" 것과 "같은 양을 뭉텅이로 보낸" 것을 가른다.
  int _fpBytes = 0;

  // [계측] 이벤트 루프 지연 프로브. 20ms 주기 타이머가 실제로 얼마나 늦게 실행되는지
  // 재서, 청크 도착 갭(maxArrivalGap)의 원인을 가른다:
  //   갭 큼 + 루프 정시  → 소켓에 데이터가 없었다 = 서버 전송 공백 (서버 사안)
  //   갭 큼 + 루프도 밀림 → 이벤트 루프가 막혔다 = 클라 사안
  // 이 구분이 없으면 두 원인이 로그상 완전히 똑같이 보인다.
  static const int _elProbeMs = 20;
  Timer? _elProbeTimer;
  int _elLastMs = 0, _elLagMaxMs = 0, _elLagOver50 = 0;

  // [계측] 스트림 인플레이션(Dart 측). native 20ms 무음과 별개로 여기서도 [_silenceFrames]
  // (=50ms) 무음을 피드한다 — 주입기가 둘이다. 재생 스트림에 들어간 총량이 경과 시간을
  // 넘으면(fed/elapsed > 100%) 그 초과분이 곧 백로그 증가분이고, 어느 분기가 넣었는지까지 가른다.
  Timer? _inflateTimer;
  int _callT0Ms = 0;
  int _rxBytesTotal = 0; // 서버에서 받은 오디오(=재생돼야 할 진짜 양)
  int _fedAudBytes = 0; // 플러그인에 넣은 진짜 오디오
  int _fedSilFrames = 0; // 넣은 무음 전체
  int _fedSilSpeakFrames = 0; // 그중 "비버 발화 중"에 넣은 것 = 진짜 구멍
  int _fedSilPrebufFrames = 0; // 그중 프리버퍼 대기로 넣은 것 = 의도된 지연

  static String _sec(num bytes) => (bytes / 48000.0).toStringAsFixed(1);

  void _startInflateLog() {
    _inflateTimer?.cancel();
    _callT0Ms = DateTime.now().millisecondsSinceEpoch;
    _rxBytesTotal = 0;
    _fedAudBytes = 0;
    _fedSilFrames = 0;
    _fedSilSpeakFrames = 0;
    _fedSilPrebufFrames = 0;
    // 타이머 기반(청크 도착 기반 아님) — 오디오가 안 올 때도 균일하게 찍혀야 비교가 된다.
    _inflateTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      // ⭐ [계측] **빈 채널 호출의 왕복**을 같이 잰다(2026-08-13).
      //   실측: 네이티브 clear() 는 0~3ms 로 평평한데 Dart↔네이티브 왕복만 79→434ms 로
      //   커진다. 그런데 `clear()` 하나만 보고 있으면 **`clear` 가 느린 것**과
      //   **채널 전체가 밀리는 것**을 못 가른다. `ping` 은 네이티브에서 즉시 반환하므로,
      //   이 값이 같이 우상향하면 원인은 채널 적체다(= feed 가 앞에 쌓인 것).
      //
      // ⛔ **진단이 원인을 만들면 안 된다.** 그래서 새 타이머를 안 만들고 이미 있는 5초
      //   진단 타이머에 얹었다 — 같은 5초 창에서 feed 가 125회 도는데 여기에 1회를
      //   더하는 것이라 0.8% 다. 별도 주기로 자주 던지면 재려던 적체를 우리가 키운다.
      var pingMs = -1;
      if (_pcmActive) {
        final sw = Stopwatch()..start();
        try {
          await FlutterPcmSound.ping();
          pingMs = sw.elapsedMilliseconds;
        } catch (_) {
          // 구버전 플러그인 — 계측만 없다.
        }
      }
      final elapsedMs = DateTime.now().millisecondsSinceEpoch - _callT0Ms;
      final fedBytes = _fedAudBytes + _fedSilFrames * 2;
      final pct = elapsedMs > 0 ? (fedBytes / 48000.0 * 1000 / elapsedMs * 100) : 0;
      _log('INFLATE: elapsed ${(elapsedMs / 1000).toStringAsFixed(1)}s, '
          'rx ${_sec(_rxBytesTotal)}s, fedAud ${_sec(_fedAudBytes)}s, '
          // ⚠ 라벨을 바꿨다(2026-08-12). 예전 `speaking` 은 **"비버가 말한 시간"으로
          //   읽혔지만** 실제로는 *무음 중* "비버 발화 중에 넣은 것"이다 = 진짜 구멍.
          //   나머지(턴 사이 keep-alive)를 같이 찍어 셋의 합이 fedSil 임을 드러낸다 —
          //   두 항목만 보이면 "둘이 fedSil 과 안 맞는다"로 오해한다.
          'fedSil ${_sec(_fedSilFrames * 2)}s(무음주입: 발화중구멍 '
          '${_sec(_fedSilSpeakFrames * 2)}s + 프리버퍼대기 '
          '${_sec(_fedSilPrebufFrames * 2)}s + 턴사이 '
          '${_sec((_fedSilFrames - _fedSilSpeakFrames - _fedSilPrebufFrames) * 2)}s), '
          'fed/elapsed ${pct.toStringAsFixed(0)}%, queue ${_queueLen}B'
          // 통로와 무관하게 찍는다 — 사장님 증상은 **라이브 5분**이다. 캐스케이드에서만
          // 재면 반쪽이라, 같은 줄에서 두 통로를 같은 방식으로 본다.
          '${pingMs >= 0 ? ', 빈채널왕복 ${pingMs}ms' : ''}');
      // [계측] 푸시 모델이 버티고 있는지 한 줄로 가른다: engineMin 이 낮으면 native 가
      // 말랐다는 뜻(목표 상향), 높은데도 버벅이면 Dart 큐/서버 쪽이다.
      final minMs = _engineMinFrames == 1 << 30
          ? -1
          : _engineMinFrames * 1000 ~/ _playbackSampleRate;
      _log('PUMP: engine now ${_engineLevelFrames * 1000 ~/ _playbackSampleRate}ms, '
          'min ${minMs}ms (low ${_engineLowFrames * 1000 ~/ _playbackSampleRate}ms / '
          'target ${_engineTargetFrames * 1000 ~/ _playbackSampleRate}ms)');
      _engineMinFrames = 1 << 30; // 창마다 리셋 — 통화 전체 최저가 아니라 추세를 본다
    });
  }

  void _stopInflateLog() {
    _inflateTimer?.cancel();
    _inflateTimer = null;
  }

  /// [계측] 비버 턴이 열리는 순간의 **잔류 백로그**. 스트림 인플레이션 판별용.
  ///
  /// 왜 하필 턴 경계인가 — 정상 동작에서 버스트로 도착한 오디오는 그 턴 안에 다 재생되고,
  /// 다음 턴이 열릴 땐 큐도 엔진도 비어 있다(마이크 재개방 조건 자체가 [_audioDrained]
  /// 라서 구조적으로 보장된다). 그러니 이 시점의 잔류는 **정의상 이전 턴이 못 따라간 양**
  /// 이다. 서버 누적 송출량이 실시간 레이트를 넘으면 이 값이 턴마다 커진다.
  ///
  /// 60초 폭주 가드([_maxQueueBytes])는 이걸 못 잡는다 — 백로그가 10초, 20초로 자라도
  /// 아무 말 없이 있다가 60초에 가서 15초치를 통째로 버린다. 여기서는 **드롭하지 않고
  /// 드러내기만 한다**(2단계 방어는 실측 후 별도 판단).
  void _logTurnBoundaryBacklog() {
    final queueMs = _queueLen * 1000 ~/ (_playbackSampleRate * 2);
    final engineMs = _engineLevelFrames * 1000 ~/ _playbackSampleRate;
    final backlogMs = queueMs + engineMs;

    if (_prevTurnBacklogMs >= 0 && backlogMs > _prevTurnBacklogMs) {
      _backlogRiseStreak++;
    } else {
      _backlogRiseStreak = 0;
    }
    _prevTurnBacklogMs = backlogMs;

    // 연속 증가가 이어지면 버스트가 아니라 인플레이션이다. 임계는 낮게 잡아도 된다 —
    // 로그일 뿐이고, 놓치는 것보다 시끄러운 게 낫다.
    final verdict = _backlogRiseStreak >= 3
        ? ' ⚠ INFLATION? $_backlogRiseStreak턴 연속 증가 '
            '— 서버 누적 송출량 > 실시간 레이트 의심'
        : '';
    _log('TURN-BACKLOG: ${backlogMs}ms '
        '(queue ${queueMs}ms + engine ${engineMs}ms)$verdict');
  }

  void _startEventLoopProbe() {
    _elProbeTimer?.cancel();
    _elLastMs = DateTime.now().millisecondsSinceEpoch;
    _elLagMaxMs = 0;
    _elLagOver50 = 0;
    _elProbeTimer =
        Timer.periodic(const Duration(milliseconds: _elProbeMs), (_) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final lag = (now - _elLastMs) - _elProbeMs; // 예정보다 늦은 정도(ms)
      _elLastMs = now;
      if (lag > _elLagMaxMs) _elLagMaxMs = lag;
      if (lag > 50) _elLagOver50++;
    });
  }

  void _stopEventLoopProbe() {
    _elProbeTimer?.cancel();
    _elProbeTimer = null;
  }

  void _feedPlayer(Uint8List chunk) {
    // First inbound audio of the call: the split between "server was still
    // thinking" and "our pipeline was not ready yet" is exactly this timestamp
    // against startAudio's. Logged natively so it survives release builds.
    if (!_gotFirstAudio) {
      _gotFirstAudio = true;
      unawaited(_logNativeAudio('first-audio-in +${_elapsedSinceStartMs}ms '
          '(playback ${_pcmActive ? "ready" : "NOT ready"})'));
    }
    final fpT0 = DateTime.now().microsecondsSinceEpoch;
    final fpGap = _fpLastUs == 0 ? 0 : (fpT0 - _fpLastUs) ~/ 1000; // 청크 도착 간격(ms)
    _fpLastUs = fpT0;
    if (fpGap > _fpMaxGapMs) _fpMaxGapMs = fpGap;
    _feedPlayerBody(chunk);
    _fpChunks++;
    _fpBytes += chunk.length;
    _rxBytesTotal += chunk.length;
    _fpMicros += DateTime.now().microsecondsSinceEpoch - fpT0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (_fpWinMs == 0) _fpWinMs = nowMs;
    if (nowMs - _fpWinMs >= 5000) {
      final avg = _fpChunks > 0 ? _fpMicros / _fpChunks / 1000 : 0;
      // 24kHz mono Int16 → 48000 B/s. 5초 창이면 실시간은 240000B.
      final secs = _fpBytes / 48000.0;
      _log('FP-TIMING: $_fpChunks chunks/5s, avg ${avg.toStringAsFixed(2)}ms/chunk, '
          'maxArrivalGap ${_fpMaxGapMs}ms, queue ${_queueLen}B, '
          'rx ${_fpBytes}B (${secs.toStringAsFixed(2)}s audio), '
          'elLagMax ${_elLagMaxMs}ms, elLagOver50 $_elLagOver50');
      _fpChunks = 0; _fpMicros = 0; _fpMaxGapMs = 0; _fpWinMs = nowMs;
      _fpBytes = 0; _elLagMaxMs = 0; _elLagOver50 = 0;
    }
  }

  /// MERGE(v3→multilang) 주의: 재생이 아직 안 열렸어도 **항상** 큐에 쌓는다. CallKit
  /// 경로에서는 소켓이 오디오 파이프라인보다 먼저 열리므로(see [startFromIncoming])
  /// 서버의 첫 인사가 재생보다 먼저 도착하는 게 정상이고, 여기서 [_pcmActive] 로
  /// 막으면 사용자가 기다리는 인사말이 그대로 잘린다. 소비 측([_pump])만 게이트한다.
  /// 대신 재생 전 무한 적재는 아래 pre-roll cap 이 막는다.
  void _feedPlayerBody(Uint8List chunk) {
    // Ground truth for "did the server go quiet mid-utterance": the gap between
    // inbound chunks. The playback-side starve clock can't answer that — a long
    // enough hole trips the idle-ungate, `_beaverAudioActive` flips to false, and the
    // resumption then looks like a brand-new turn. Measured here (before
    // [_gateMic] clears `_turnEnded`) it survives all of that.
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final prevChunkMs = _lastChunkAtMs;
    if (prevChunkMs != null && !_turnEnded && nowMs - prevChunkMs >= 250) {
      _log('SERVER GAP ${nowMs - prevChunkMs}ms mid-utterance '
          '(mic was ${_micGated ? "closed" : "OPEN"})');
    }
    _lastChunkAtMs = nowMs;
    // Beaver audio is arriving → gate the mic (covers the opening greeting even
    // before/without a turn_start).
    _gateMic();
    // Queue is no longer empty → cancel any idle-ungate countdown so the mic
    // stays closed while the beaver's buffered turn is still playing out. (The
    // countdown is (re)armed by [_onFeed] only once the queue actually drains.)
    _gateSafetyTimer?.cancel();
    _gateSafetyTimer = null;
    // Fresh audio during a pending close resets the quiet window so the closing
    // line isn't acked early.
    _closingStableTimer?.cancel();
    _closingStableTimer = null;

    _appendToQueue(chunk);

    // Pre-roll cap: while playback isn't open yet, nothing drains the queue, so
    // it needs its own (much tighter) bound. An opening line is a few seconds;
    // anything beyond this means the audio stage is badly stuck, and holding
    // minutes of stale speech to replay later would be worse than dropping it.
    //
    // MERGE(v3→multilang): 이 상한은 청크 참조 큐(_dropFront) 기준으로 들어왔었다.
    // 이 브랜치는 v3 의 평면 링버퍼를 쓰므로 등가 연산은 head 전진 + 압축이다.
    if (!_pcmActive && _queueLen > _prerollMaxBytes) {
      var drop = _queueLen - _prerollMaxBytes;
      if (drop.isOdd) drop -= 1; // keep Int16 sample alignment
      _pcmHead += drop;
      _maybeCompact();
      _log('preroll cap: dropped ${drop}B (playback not open yet)');
      return;
    }

    // Resync: if the queue outgrows the cap (server bursts ahead / clock drift),
    // drop the oldest bytes down to the target so latency can't pile up and
    // stall — the callback-pull analogue of the demo's `playT = now`.
    final len = _queueLen;
    if (len > _maxQueueBytes) {
      var drop = len - _targetQueueBytes;
      if (drop.isOdd) drop -= 1; // keep Int16 sample alignment
      _pcmHead += drop;
      _log('resync: queue ${len}B > cap ${_maxQueueBytes}B → dropped ${drop}B');
      _maybeCompact();
    }
  }

  /// Starts the push loop. From here on Dart decides when the engine gets fed;
  /// the plugin's callback is only a backstop (see [_feedThresholdFrames]).
  void _startPushFeed() {
    _pushTimer?.cancel();
    _engineAnchorFrames = 0;
    _engineAnchorMs = 0;
    _engineMinFrames = 1 << 30;
    _pushTimer = Timer.periodic(_pushInterval, (_) => unawaited(_pump()));
  }

  void _stopPushFeed() {
    _pushTimer?.cancel();
    _pushTimer = null;
  }

  /// Backstop path: the plugin noticed its queue fell below
  /// [_feedThresholdFrames]. Its `remainingFrames` is ground truth, so use it to
  /// re-anchor the estimate, then pump. In a healthy call this never fires.
  Future<void> _onFeed(int remainingFrames) async {
    if (!_pcmActive) return;
    _anchorEngine(remainingFrames, DateTime.now().millisecondsSinceEpoch);
    await _pump();
  }

  /// Tops the native engine up. Called every [_pushInterval] (and by the
  /// backstop callback); does nothing at all unless the engine has drained past
  /// its low-water mark, so a healthy call spends most ticks returning here.
  ///
  /// Pulls up to [_feedChunkBytes] of real audio from [_pcmQueue]; when there's
  /// nothing to play it feeds silence instead, which keeps the AudioTrack out of
  /// AudioFlinger's idle path (the ~130ms reactivation stall).
  Future<void> _pump() async {
    if (!_pcmActive) return;
    if (_feeding) return; // a feed is already in flight — don't double-count
    _feeding = true;
    try {
      final avail = _queueLen;
      final whole = avail - (avail & 1); // even bytes = whole Int16 samples
      // Jitter prebuffer: at a turn start, hold real audio (feed silence) until a
      // small cushion is buffered so brief jitter can't starve mid-word. Bypassed
      // once playing, while closing (must drain), or when the flush timer fires.
      // `_turnEnded` matters as much as the cushion here: once the server has sent
      // `turn_end` the whole utterance is already queued, so holding out for
      // [_prebufferBytes] would only delay a short reply that will never reach it.
      // Without this arm, raising the cushion to 900ms would stall every "네."
      // until [_prebufferFlush] expired.
      // Resuming from a mid-utterance starve is the one case [_playing] must not
      // wave through: rebuild a small cushion first, or playback resumes on a
      // scrap and starves straight back into the stutter loop. `_turnEnded` and
      // `_drainScheduled` still bypass everything so short replies stay instant,
      // and [_prebufferFlush] bounds the wait via [_resumeFlushed].
      final resuming = _starveAtMs != null && !_resumeFlushed;
      final ready = _turnEnded ||
          _drainScheduled ||
          (resuming
              ? whole >= _resumeCushionBytes
              : (_playing || whole >= _cushionBytes));
      if (whole >= 2 && ready) {
        _playing = true;
        // Cancel unconditionally: a resume gate can arm this while [_playing] is
        // already true, so keying the cancel off `!_playing` would leave it live.
        _prebufferFlushTimer?.cancel();
        _prebufferFlushTimer = null;
        final starvedAt = _starveAtMs;
        if (starvedAt != null) {
          // The server had gone quiet mid-utterance and has now resumed. This gap
          // IS the glitch the user hears — measure it, don't just note that it
          // happened. Anything under [_prebufferFlush] would have been absorbed.
          _starveAtMs = null;
          _resumeFlushed = false;
          _log('audio resumed after '
              '${DateTime.now().millisecondsSinceEpoch - starvedAt}ms gap (starved)');
        }
        if (_lastFeedSilent != false) {
          _log('feed AUDIO (queue ${avail}B, engine '
              '${_engineLevelFrames * 1000 ~/ _playbackSampleRate}ms, '
              '쿠션 ${_cushionBytes ~/ 48}ms)');
          _lastFeedSilent = false;
        }
        // Only push once the engine has drained past its low-water mark. Above
        // it the tick does nothing — the bookkeeping above still had to run, but
        // there is no reason to hand the platform channel more bytes.
        final level = _engineLevelFrames;
        if (level < _engineLowFrames) {
          var take = (_engineTargetFrames - level) * 2;
          if (take > _feedChunkBytes) take = _feedChunkBytes;
          if (take > whole) take = whole;
          _fedAudBytes += take; // [계측]
          // 원장: 이건 **서버발** 오디오다. 진행도 보고가 이 기록에 걸려 있다.
          _ledger.recordFeed(frames: take ~/ 2, server: true);
          final sentAtMs = DateTime.now().millisecondsSinceEpoch;
          final gen = _clearGen; // ⚠ 아래 await 동안 barge-in 이 끼어들 수 있다
          final reported = await FlutterPcmSound.feed(_takeArray(take));
          if (gen != _clearGen) {
            // 이 피드가 날아가 있는 사이 [_clearPlayback] 이 돌았다. 여기서 앵커와
            // 꼬리를 쓰면 방금 리셋한 값을 **취소된 턴의 값으로 되살린다** —
            // `_audioTailUntilMs` 가 부활하면 [_audioDrained] 가 최대 2.5초 막히고
            // (C-3 재발), 앵커가 부활하면 다음 턴 첫 오디오가 늦는다(C-5 재발).
            _log('feed raced clear — 앵커/꼬리 갱신 건너뜀');
            return;
          }
          // Android reports its depth; elsewhere fall back to our own arithmetic
          // so iOS/web keep working unchanged.
          _anchorEngine(reported ?? (level + take ~/ 2), sentAtMs);
          // 이 실오디오가 스피커에서 끝날 시각. 무음 피드는 갱신하지 않는다 —
          // 무음까지 세면 턴 사이에도 꼬리가 계속 밀려 마이크가 안 열린다.
          _audioTailUntilMs = sentAtMs +
              (level + take ~/ 2) * 1000 ~/ _playbackSampleRate;
        }
      } else {
        if (whole >= 2) {
          // Buffering the prebuffer cushion → arm a bounded flush so a short
          // utterance (never reaching the cushion) still plays out.
          _prebufferFlushTimer ??= Timer(_prebufferFlush, () {
            _prebufferFlushTimer = null;
            _playing = true; // next feed drains whatever is queued
            // Releases the resume gate too, so a tail that never refills
            // [_resumeCushionBytes] plays out instead of hanging on silence.
            _resumeFlushed = true;
          });
        } else {
          // Queue genuinely drained. Between turns (beaver not speaking) require a
          // fresh prebuffer next turn; mid-turn keep _playing so resumed audio is
          // instant (no re-buffer gap).
          // Reverted from an unconditional refill: rebuilding the 900ms cushion
          // mid-utterance only added ~450ms of dead air per resumption without
          // removing a single dropout, because the holes being ridden out are
          // multi-second server gaps, not jitter a cushion can cover.
          if (!_beaverAudioActive) _playing = false;
          // Only a mid-utterance drain is a glitch; a drained queue between turns
          // is normal, so don't start the stall clock for it.
          // ⚠ `_beaverAudioActive` 만으로 판정하면 안 된다 — [_audioDrained] 여야 한다.
          //   푸시 모델에서는 [_pump] 가 매 틱 Dart 큐를 통째로 엔진에 밀어넣으므로
          //   **큐가 비어 있는 게 정상 상태**다(측정: INFLATE 창 대부분이 queue 0B).
          //   큐 빔만 보고 세면 엔진이 1.8초를 물고 멀쩡히 재생 중인데도 굶었다고
          //   집계돼, 쿠션이 상한까지 못 박히고 감쇠가 영영 안 걸린다.
          //   실측(5분 통화, 2026-08-02): 판정 26회 중 실제로 들린 끊김은 8회.
          //   나머지 18회가 가짜였고 쿠션은 72초 만에 1800ms 상한에 고정됐다.
          if (_beaverAudioActive && _audioDrained) {
            if (_starveAtMs == null) {
              // First starve of this turn: the cushion was too small for the
              // deficit this call is running, so widen it for the turns ahead.
              _starveAtMs = DateTime.now().millisecondsSinceEpoch;
              if (!_turnStarved) {
                _turnStarved = true;
                if (_cushionBytes < _cushionMaxBytes) {
                  _cushionBytes += _cushionStepBytes;
                  if (_cushionBytes > _cushionMaxBytes) {
                    _cushionBytes = _cushionMaxBytes;
                  }
                  _log('cushion grew → ${_cushionBytes * 1000 ~/ 48000}ms '
                      '(turn starved)');
                }
              }
            }
          } else {
            // The gate has cleared — the beaver finished and it's the user's turn.
            // Drop any clock started during the hangover, otherwise the *next*
            // turn's first chunk reports the whole exchange (beaver→user→beaver)
            // as one multi-second "gap" and buries the real glitches.
            _starveAtMs = null;
            _resumeFlushed = false;
          }
          if (_lastFeedSilent != true) {
            if (_beaverAudioActive) _dbgStarveCount++; // DEBUG(audio-glitch)
            _log('feed silence — queue empty'
                '${_beaverAudioActive ? ' WHILE beaver speaking (starved! #$_dbgStarveCount)' : ''}');
            _lastFeedSilent = true;
          }
          // Idle-ungate countdown (covers a missed turn_end so the mic can't
          // deadlock). Armed once per empty period; fresh audio cancels it.
          _armIdleUngate();
        }
        // Keep only a shallow floor of silence queued. It exists to hold the
        // AudioTrack in AudioFlinger's active list and to cover the platform
        // round trip; anything deeper is dead air queued ahead of the next reply.
        final level = _engineLevelFrames;
        if (level < _silenceLowFrames) {
          final silFrames = _silenceTargetFrames - level;
          // [계측] 무음 주입을 분기별로 분리 집계: 프리버퍼 대기(의도된 지연)인지,
          // 비버 발화 중 큐가 빈 것(진짜 구멍)인지가 원인 판정을 가른다.
          _fedSilFrames += silFrames;
          if (whole >= 2) {
            _fedSilPrebufFrames += silFrames;
          } else if (_beaverAudioActive) {
            _fedSilSpeakFrames += silFrames;
          }
          // 원장: 이건 **우리가 만든 필러**다. 서버는 이걸 "들은 양"으로 세면 안 된다.
          _ledger.recordFeed(frames: silFrames, server: false);
          final sentAtMs = DateTime.now().millisecondsSinceEpoch;
          final gen = _clearGen; // 오디오 분기와 같은 이유 — 위 주석 참조
          final reported = await FlutterPcmSound.feed(
            _silenceArray(silFrames),
          );
          if (gen != _clearGen) return;
          _anchorEngine(reported ?? (level + silFrames), sentAtMs);
        }
      }
    } catch (_) {
      // Engine released mid-feed (teardown) → ignore.
    } finally {
      _feeding = false;
    }
    // Real audio drained → maybe re-open the mic / finish the closing drain.
    // ⚠ Dart 큐가 아니라 [_audioDrained] 다 — 엔진에 남은 것까지 봐야 한다.
    if (_audioDrained) {
      _tryUngateMic();
      _maybeFinishClosing();
    }
  }

  /// Removes [byteCount] bytes from the front of the queue as a [PcmArrayInt16].
  /// The server's little-endian PCM16 passes straight through: mobile targets
  /// are little-endian (host), which is what the native player expects.
  /// Caller guarantees `byteCount <= _queueLen`.
  /// 오디오 피드용 스크래치. **호출마다 새로 만들지 않는다.**
  ///
  /// ⛔ 예전엔 `Uint8List(byteCount)` 를 매번 만들었다 — 최대 72KB × 초당 25회 =
  ///   **초당 1.8MB 를 GC 에 던진다.** 5분 통화면 수백 MB 다.
  /// ⭐ 재사용이 안전한 이유 두 가지:
  ///   ① `MethodChannel.invokeMethod` 는 인자를 **동기적으로** 인코딩한 뒤 await 한다 —
  ///      즉 우리가 다시 쓰기 전에 이미 채널 메시지로 복사돼 있다.
  ///   ② 그래도 겹칠 일이 없다: [_pump] 가 `_feeding` 으로 재진입을 막는다(한 번에 하나).
  ///   그리고 네이티브는 코덱이 디코드한 **자기 배열**(`byte[]`)을 들고 있다 — Dart 메모리를
  ///   참조하지 않는다(Android `feed` 의 `call.argument("buffer")` 확인).
  final Uint8List _feedScratch = Uint8List(_feedChunkBytes);

  /// 무음 피드용 스크래치 — **0 으로만 채워지므로 내용이 바뀔 일이 없다.**
  /// 최대 크기로 한 번 잡고 필요한 만큼만 뷰로 넘긴다.
  final Uint8List _silenceScratch = Uint8List(_silenceTargetFrames * 2);

  /// 무음 [frames] 개. 새로 할당하지 않는다.
  PcmArrayInt16 _silenceArray(int frames) {
    final want = frames * 2;
    // 방어: 목표보다 큰 요청이 오면(설정이 바뀌면) 그때만 새로 만든다.
    if (want > _silenceScratch.lengthInBytes) {
      return PcmArrayInt16.zeros(count: frames);
    }
    return PcmArrayInt16(bytes: ByteData.sublistView(_silenceScratch, 0, want));
  }

  PcmArrayInt16 _takeArray(int byteCount) {
    final out = _feedScratch;
    out.setRange(0, byteCount, _pcmQueue, _pcmHead);
    _pcmHead += byteCount;
    _maybeCompact();
    // Drive the avatar mouth from the samples about to play (matches what's
    // heard; the queue buffers ahead so arrival-time RMS would lead the audio).
    _updateAvatarLevel(out, byteCount);
    // ⚠ **부분 뷰**를 넘긴다. 전체를 넘기면 요청보다 긴 오디오가 나간다 —
    //   `FlutterPcmSound.pcmBytesOf` 가 offset/length 를 존중하도록 같이 고쳤다.
    return PcmArrayInt16(bytes: ByteData.sublistView(out, 0, byteCount));
  }

  /// Rewinds the indices once the queue is fully consumed. That is the only
  /// bookkeeping a steady call needs: between feeds the queue regularly hits
  /// empty, so the window slides back to the front for free and [_appendToQueue]
  /// never has to move live bytes.
  void _maybeCompact() {
    if (_pcmHead >= _pcmTail) {
      _pcmHead = 0;
      _pcmTail = 0;
    }
  }

  /// Computes the RMS of the PCM16 chunk about to play and publishes it as the
  /// avatar mouth-open level (0..1), with a perceptual curve so quiet speech
  /// still parts the mouth. Cheap (~a few thousand ops per ~10Hz feed).
  void _updateAvatarLevel(Uint8List bytes, int len) {
    final n = len ~/ 2;
    if (n == 0) return;
    final bd = bytes.buffer.asByteData();
    // One envelope entry per _envStepMs of audio (24kHz mono PCM16).
    final step = (_playbackSampleRate * _envStepMs) ~/ 1000; // samples
    var sumSqAll = 0.0;
    var zc = 0;
    var prev = 0;
    var i = 0;
    while (i < n) {
      final end = math.min(i + step, n);
      var sumSq = 0.0;
      for (var k = i; k < end; k++) {
        final s = bd.getInt16(k * 2, Endian.little);
        sumSq += s * s;
        sumSqAll += s * s;
        if (k > 0 && (s >= 0) != (prev >= 0)) zc++;
        prev = s;
      }
      final cnt = end - i;
      final rms = cnt > 0 ? math.sqrt(sumSq / cnt) : 0.0;
      _envQueue.add(_levelFromRms(rms));
      _envAdded++; // 마커 위치의 기준 — 이 인덱스에 자막·표정을 꽂는다
      i = end;
    }
    // Runaway guard. ⚠ 홀드백 자체가 최대 2.5초(엔진 목표)라 3초 캡은 여유가
    // 0.5초뿐이었다 — 한 번의 take(최대 1.5초)가 얹히면 캡이 큐 앞머리를 잘라
    // 립싱크가 **조용히** 어긋난다. 엔진 목표 + take 상한 위로 잡는다.
    final cap = 4000 ~/ _envStepMs;
    if (_envQueue.length > cap) {
      final dropped = _envQueue.length - cap;
      _envQueue.removeRange(0, dropped);
      // 잘려 나간 만큼도 '지나간' 것으로 센다. 안 그러면 마커가 영영 안 터진다.
      _envPlayed += dropped;
    }
    // Zero-crossing rate → vowel shape (whole chunk is fine for this).
    final zcr = n > 1 ? zc / (n - 1) : 0.0;
    avatarShape.value = ((zcr - 0.045) / 0.05).clamp(-1.0, 1.0);
    // Keep sumSqAll referenced (kept for future tuning/telemetry).
    assert(sumSqAll >= 0);
  }

  /// Maps an RMS to a 0..1 mouth-open level (gate + perceptual curve).
  double _levelFromRms(double rms) {
    if (rms < _avatarRmsGate) return 0.0;
    var lvl = rms / _avatarRmsFull;
    if (lvl > 1) lvl = 1;
    return math.pow(lvl, 0.7).toDouble();
  }

  /// Drains the sub-frame envelope in real time so the mouth tracks the audio.
  ///
  /// 홀드백 = **지금 네이티브가 물고 있는 양** + [_envLeadMs]. [_takeArray] 는 재생
  /// 직전이 아니라 "엔진이 저수위로 내려갔을 때" 불리므로, 거기서 뽑은 RMS 는 지금
  /// 들리는 소리가 아니라 **엔진 깊이만큼 뒤에 들릴** 소리다. 그만큼 붙잡아 둬야
  /// 입과 소리가 맞는다(sync_avatar 의 "aligns level to what is actually audible"
  /// 계약이 이걸 전제한다). 매 틱 계산하므로 쿠션이 적응적으로 커져도 따라간다.
  void _startEnvelope() {
    _envTimer?.cancel();
    _envTimer = Timer.periodic(
      const Duration(milliseconds: _envStepMs),
      (_) {
        final holdMs =
            _engineLevelFrames * 1000 ~/ _playbackSampleRate + _envLeadMs;
        final lead = holdMs ~/ _envStepMs;
        if (_envQueue.length > lead) {
          avatarLevel.value = _envQueue.removeAt(0);
          _envPlayed++;
          _fireDueMarkers();
          _advanceReveal();
        } else if (!_beaverAudioActive) {
          avatarLevel.value = 0.0;
        } else {
          // Brief gap mid-turn: ease shut rather than snapping.
          avatarLevel.value = avatarLevel.value * 0.6;
        }
      },
    );
  }

  /// Appends an inbound chunk, moving or growing the backing buffer only when it
  /// genuinely cannot fit. Both paths are rare: the queue normally drains to
  /// empty (see [_maybeCompact]) long before the write cursor reaches the end.
  void _appendToQueue(Uint8List chunk) {
    final live = _queueLen;
    final needed = live + chunk.length;
    if (needed > _pcmQueue.length) {
      var capacity = _pcmQueue.length;
      while (capacity < needed) {
        capacity *= 2;
      }
      final grown = Uint8List(capacity);
      grown.setRange(0, live, _pcmQueue, _pcmHead);
      _pcmQueue = grown;
      _pcmHead = 0;
      _pcmTail = live;
    } else if (_pcmTail + chunk.length > _pcmQueue.length) {
      // Enough total room, just not at the end → slide the live window forward.
      // `setRange` handles the self-overlapping copy correctly.
      _pcmQueue.setRange(0, live, _pcmQueue, _pcmHead);
      _pcmHead = 0;
      _pcmTail = live;
    }
    _pcmQueue.setRange(_pcmTail, _pcmTail + chunk.length, chunk);
    _pcmTail += chunk.length;
  }

  // ── Half-duplex mic gating helpers ─────────────────────────────────────────

  /// Engages the mic gate for a new/ongoing beaver turn. Cancels any pending
  /// ungate (hangover/safety) since the beaver is speaking again.
  /// Walks the adaptive cushion back down after a turn that played clean, so a
  /// single bad stretch doesn't leave every later reply paying its latency.
  /// Never goes below [_prebufferBytes].
  void _decayCushion() {
    if (_turnStarved) return; // this turn starved — don't undo the growth
    if (_cushionBytes <= _prebufferBytes) return;
    _cushionBytes -= _cushionDecayBytes;
    if (_cushionBytes < _prebufferBytes) _cushionBytes = _prebufferBytes;
  }

  void _gateMic() {
    if (!_beaverAudioActive) {
      // ⛔ **실제 게이트를 읽는다.** 예전엔 `_channelMode.gatesMic` 만 보고 찍어서,
      //   서버가 `mic_always_open=false` 를 준 통화에서 **마이크는 닫혀 있는데 로그는
      //   "열려 있다(barge-in)"** 고 말했다(실기기 확인, 2026-08-12).
      //   `통로=live` 와 **같은 계열**이다 — 진단이 실제 상태를 안 본다.
      // ⭐ 닫혔으면 **무엇이 막았는지**까지 찍는다. 안 그러면 "끼어들기가 안 된다"고 할 때
      //   AEC 문제인지 서버 정책인지 통로인지 못 가른다.
      _log(_micGated
          ? 'mic GATED — ${micGateReason(
              channelGates: _channelMode.gatesMic,
              serverMicAlwaysOpen: _serverMicAlwaysOpen,
              aecOn: _androidVoiceAudio,
            )}'
          : 'beaver turn OPEN — mic stays open (barge-in)');
      _turnStarved = false; // fresh turn: it hasn't starved yet
      // 새 턴 = 진행도 원장의 기준선. 턴 경계에서는 엔진이 비어 있는 게 계약이라
      // (재개방 조건이 [_audioDrained]) 여기서 비우면 이후 산출값이 곧
      // **이번 턴의** 재생량이 된다.
      _ledger.reset();
    }
    _micGateTimer?.cancel();
    _micGateTimer = null;
    _turnEnded = false;
    _beaverAudioActive = true;
    avatarSpeaking.value = true;
    // 비버가 말하기 시작했다 → 대기 상태를 기본으로 되돌린다. 말이 끝나 idle 이
    // 다시 보일 때 「듣는 중」이나 「생각 중」이 남아 있으면 대사와 어긋난다.
    _listenTimer?.cancel();
    _listenTimer = null;
    avatarIdleKind.value = kIdleWait;
  }

  /// Attempts to clear the mic gate. Requires BOTH the turn to have ended AND
  /// the playback queue to be empty, then waits a [_micHangover] tail (so the
  /// speaker's decaying audio isn't recaptured) before actually ungating.
  void _tryUngateMic() {
    if (!_beaverAudioActive) return;
    if (!_turnEnded) return;
    // ⚠ Dart 큐가 아니라 [_audioDrained]. 큐가 비어도 엔진에 최대 2.5초가 남아 있고,
    //   그때 마이크를 열면 스피커에서 나오는 비버 목소리를 그대로 되먹는다.
    if (!_audioDrained) return;
    // Arm the hangover once. Restarting it on every call was a real bug: [_pump]
    // calls this on every tick that finds the queue empty, so the countdown was
    // reset before it could ever expire and the mic never opened by this path —
    // it fell through to the slow `idle drained` safety net instead (measured 13
    // of 22 openings). New audio still cancels it via [_gateMic], which is what
    // the restart was there for.
    if (_micGateTimer != null) return;
    _micGateTimer = Timer(_micHangover, () {
      _micGateTimer = null;
      _gateSafetyTimer?.cancel();
      _gateSafetyTimer = null;
      _beaverAudioActive = false;
      avatarSpeaking.value = false;
      avatarLevel.value = 0.0;
      _decayCushion();
      _log('mic OPEN — your turn (turn_end + drained)');
    });
  }

  /// Idle-based ungate for the pull model: called from [_onFeed] once the queue
  /// has actually drained (silence being fed) while the beaver is still gated.
  /// If the queue is still empty after [_gateSafetyWindow], open the mic — this
  /// covers a missed `turn_end` ([_tryUngateMic] handles the fast path). Armed at
  /// most once per empty period (the `!= null` guard stops re-arming every
  /// silence callback); a fresh inbound chunk in [_feedPlayer] cancels it.
  void _armIdleUngate() {
    if (!_beaverAudioActive) return;
    if (_gateSafetyTimer != null) return; // already counting this empty period
    _gateSafetyTimer = Timer(_gateSafetyWindow, () {
      _gateSafetyTimer = null;
      if (_beaverAudioActive && _audioDrained) {
        _micGateTimer?.cancel();
        _micGateTimer = null;
        _beaverAudioActive = false;
        avatarSpeaking.value = false;
        avatarLevel.value = 0.0;
        _decayCushion();
        _log('mic OPEN — your turn (idle drained)');
      }
    });
  }

  // ── barge-in: 취소 처리 ────────────────────────────────────────────────────

  /// 서버가 비버 턴을 끊었다(`audio_cancel`). 재생을 즉시 죽이고, 어디까지 들렸는지
  /// 회신한다.
  ///
  /// **순서가 곧 정확도다.** 진행도를 먼저 확정하고 나서 버려야 한다 — 큐와 엔진을
  /// 비운 뒤에 읽으면 "남아 있던 양"을 알 수 없어 재생량이 부풀려진다.
  Future<void> _onAudioCancel(Map<String, dynamic> msg) async {
    // 서버가 `audio_cancel` 에 turn_id 를 필수로 싣는다. 그래도 파싱은 방어적으로 —
    // 타입이 다르거나 빠진 프레임에 죽지 않는다([_handleControl] 전반의 스타일).
    // ⚠ `as String?` 는 방어가 아니다: 값이 int 면 그대로 TypeError 를 던져 WS 스트림
    //   핸들러까지 올라간다. 타입 검사로 받아야 한다.
    // ⏱ "취소 수신 → 실제 무음" 의 시작점. **핸들러 첫 줄**이다(WS 프레임 수신 직후).
    //    단조 시계를 쓴다 — 벽시계는 통화 중 시각 동기화로 튈 수 있고, 그러면 지연이
    //    음수로 나오거나 수백 ms 뛴다.
    final stopWatch = Stopwatch()..start();

    final rawTurnId = msg['turn_id'];
    final turnId = (rawTurnId is String ? rawTurnId : null) ?? _currentTurnId;

    // ① 잔여 바이너리 차단을 먼저 세운다. clear() 를 await 하는 동안에도 소켓은
    //    계속 들어오므로, 여기서 안 막으면 그 사이 도착분이 큐에 다시 쌓인다.
    _cancelledResidual = true;
    _cancelledResidualBytes = 0;

    // ② `audio_cancel` 은 **그 턴의 종결을 겸한다** — 서버는 별도 `turn_end` 를
    //    보내지 않는다. 그러니 `turn_end` 를 훅하는 자리에 이것도 같이 건다.
    //    안 걸면 [_tryUngateMic] 과 [_maybeFinishClosing] 이 둘 다 막힌다.
    //
    //    ⚠ await **전**에 세운다. 뒤로 미루면 그 사이 도착한 다음 턴의 [_gateMic] 이
    //      `_turnEnded=false` 로 돌려놓은 것을 다시 true 로 덮어써서, 새 턴이
    //      "이미 끝난 턴"으로 취급된다(쿠션 우회 + 조기 ungate).
    _turnEnded = true;

    // ③ 재생 폐기 + 진행도 확정 (폐기 프레임 수가 진행도 계산의 ground truth 다).
    //    Dart 측 상태 리셋은 [_clearPlayback] 안에서 **await 이전에** 끝난다.
    final outcome = await _clearPlayback();

    // ⏱ 끝점. 여기서 네이티브 폐기가 끝났고, 거기에 **HAL 잔량**을 더해야 스피커가
    //    실제로 조용해지는 시점이 된다 — flush 는 AudioTrack 버퍼만 비우고, 이미
    //    믹서/HAL 로 넘어간 오디오는 그대로 울린다.
    stopWatch.stop();
    final clientStopMs = stopWatch.elapsedMilliseconds + outcome.halResidualMs;

    _tryUngateMic();
    _maybeFinishClosing();

    // 라우트는 **측정마다** 읽는다. 통화 중에도 바뀌므로(이어폰을 뽑으면) 세션 값으로는
    // 그 턴의 맥락을 못 말한다.
    // ⚠ stopWatch 를 멈춘 **뒤에** 읽는다 — 이 왕복이 client_stop_ms 에 섞이면
    //   측정하려던 지연이 오염된다. 대신 이 왕복만큼 서버가 보는 rtt_ms 가 늘어난다.
    final route = await AudioRouteProbe.currentRoute();

    // ④ 회신. 서버가 패딩 원장을 갖고 있고 24kHz PCM16 = 48000B/s 고정이라,
    //    바이트 → ms 와 "대사냐 패딩이냐"의 판정은 서버 몫이다.
    if (turnId == null) {
      // 서버 계약상 올 수 없는 경우. 조용히 빠뜨리면 서버가 어느 턴인지 못 맞추므로
      // 반드시 드러낸다.
      _log('⚠ audio_cancel 에 turn_id 가 없다 — 상관 불가');
    }
    // `source` 를 항상 'native' 로 박으면 안 된다. 네이티브 폐기량을 못 받아 추정치로
    // 떨어졌는데 'native' 라고 하면, 서버는 ±50~150ms 짜리 외삽값을 실측으로 믿고
    // 대화 이력에 박는다. 서버가 'estimate' 를 거부하고 사유를 찍게 설계돼 있으니,
    // 정직하게 보내고 거부당하는 쪽이 맞다.
    _send({
      'type': 'playback_progress',
      'turn_id': ?turnId,
      'played_server_bytes': outcome.playedServerBytes,
      'source': outcome.fromNative ? 'native' : 'estimate',
      'sampled_at': 'stop',
      'client_stop_ms': clientStopMs,
      'stop_measure': outcome.stopMeasure,
      'platform': AudioRouteProbe.platformName,
      // ⭐ 서버 불변식 I6 의 **외부 감시자**(백엔드 요청, 2026-08-12). 0 이 아니면 서버 버그다.
      //   서버 모델(`ClientPlaybackProgress`)에 `extra="forbid"` 가 없어 모르는 필드는
      //   무시된다(pydantic v2 기본 `ignore`) — 확인하고 넣었다. 즉 서버가 이 필드를
      //   받기 전에 보내도 진행도 회신 자체가 깨지지 않는다.
      'odd_frames': _oddFrames,
      // 빈 문자열 = **못 읽음**. 'speaker' 로 추측해 채우지 않는다 — 그러면 서버가
      // 측정 실패와 스피커폰을 구분하지 못한다.
      'audio_route': route,
    });
    _log('audio_cancel → cleared, played_server_bytes=${outcome.playedServerBytes} '
        'turn=$turnId source=${outcome.fromNative ? 'native' : 'estimate'} '
        'client_stop=${clientStopMs}ms '
        'stop_measure=${outcome.stopMeasure} '
        'route=${route.isEmpty ? '(못 읽음)' : route} '
        // ⭐ [진단] `폐기` 를 **왕복 / 네이티브 내부**로 쪼개고 쿠션을 같이 찍는다
        //   (2026-08-13). 통화가 길수록 client_stop 이 커지는데(186→413ms) 어디가
        //   커지는지 못 갈랐다. 네이티브가 평평한데 폐기만 크면 스레드 스케줄링이고,
        //   같이 크면 pause/flush 다. 쿠션은 "굶어서 커진 쿠션 탓"이라는 가설의 재료다.
        '(폐기 ${stopWatch.elapsedMilliseconds}ms'
        '${outcome.nativeMs >= 0 ? '[네이티브 ${outcome.nativeMs}ms]' : ''}'
        ' + HAL 잔량 ${outcome.halResidualMs}ms'
        '${outcome.halResidualKnown ? '' : ' ⚠미측정'}'
        '${outcome.writeInFlight ? ' ⚠write 진행 중 — 회수 대기분 있음' : ''}'
        ' 쿠션 ${_cushionBytes ~/ 48}ms)');
  }

  /// 재생 파이프라인을 즉시 비우고, **이번 턴에 실제로 스피커로 나간 서버발 바이트**를
  /// 돌려준다.
  ///
  /// 버퍼는 3단이다 — ①Dart 링버퍼 ②네이티브 대기 큐 ③오디오 트랙 내부. ①은 여기서,
  /// ②③은 네이티브 `clear()` 가 지운다. 트랙 자체는 살려 둔다: `release()` 로 죽이면
  /// 재기동에 120ms 정착 대기가 붙고, 무음 keep-alive 가 끊겨 AudioFlinger 가 트랙을
  /// idle 로 빼면 재활성화에 ~130ms 가 더 든다.
  Future<_ClearOutcome> _clearPlayback() async {
    // ⚠ Dart 측 리셋은 **전부 await 이전에** 끝낸다. 뒤로 미루면 플랫폼채널 왕복
    //   (5~15ms) 동안 [_pump] 가 한두 틱 돌아 방금 지운 값을 되살린다.
    //   [_clearGen] 은 그래도 남는 창(피드가 이미 날아가 있는 경우)을 막는다 —
    //   [_pump] 가 await 후 이 값을 비교해 앵커/꼬리 갱신을 건너뛴다.
    _clearGen++;

    // ① Dart 링버퍼.
    _pcmHead = 0;
    _pcmTail = 0;

    // 상태 리셋 — 여기를 빠뜨리면 barge-in 이 다음 턴을 망가뜨린다.
    //
    // ⚠ `_audioTailUntilMs`: 마지막 실오디오가 스피커에서 끝날 **미래 시각**이 박혀
    //   있다. 폐기했는데 이 값이 남으면 [_audioDrained] 가 최대 엔진 깊이(~2.5초)
    //   동안 false 라, 통화 종료 배수([_maybeFinishClosing])가 그만큼 멈춘다.
    _audioTailUntilMs = 0;
    // ⚠ starve 오집계 차단: 큐를 인위적으로 비운 것이라 "굶주림"이 아니다. 그냥 두면
    //   [_pump] 다음 틱이 이걸 starve 로 세서 쿠션을 +150ms 올리고, `_turnStarved` 가
    //   서면 그 턴은 감쇠도 못 받는다 → barge-in 이 잦을수록 쿠션이 상한(1.2s)에 머물러
    //   **모든 턴 시작이 느려진다.**
    _turnStarved = false;
    _starveAtMs = null;
    _resumeFlushed = false;
    // 다음 턴은 쿠션을 다시 쌓아야 한다(취소로 끊긴 재생을 이어가는 게 아니다).
    _playing = false;
    _prebufferFlushTimer?.cancel();
    _prebufferFlushTimer = null;
    // ⚠ 엔진 앵커: 네이티브는 비었는데 앵커가 취소 직전 값을 물고 있으면
    //   [_engineLevelFrames] 가 과대 보고돼 [_pump] 가 "아직 충분하다"고 판단하고
    //   다음 턴 첫 오디오를 안 밀어 넣는다.
    //   [_anchorEngine] 을 쓰지 않고 직접 넣는 이유: 그쪽은 `_engineMinFrames` 도 같이
    //   깎는데, 인위적으로 비운 0 이 "엔진이 말랐다"는 진단 지표로 잡히면 안 된다.
    _engineAnchorFrames = 0;
    _engineAnchorMs = DateTime.now().millisecondsSinceEpoch;
    // 취소된 오디오의 입모양이 다음 턴에 남으면 안 된다.
    _envQueue.clear();
    // ⛔ 큐에 꽂아 둔 **미발화 마커**도 같이 버린다. 안 지우면 다음 턴에 지난 턴
    //   표정·자막이 뜬다(그 오디오는 이미 폐기됐다).
    _pendingMarkers.clear();
    // 진행 중이던 드러내기도 멈춘다 — 남은 글자가 새면 안 들은 말이 자막에 남는다.
    _resetReveal();
    _lastFeedSilent = null;

    // 쿠션(`_cushionBytes`)은 건드리지 않는다 — 통화가 실제로 겪은 지터의 추정치라
    // 취소와 무관하다.

    // ② ③ 네이티브. 반환된 폐기 프레임 수가 "아직 안 나간 양"의 실측값이다.
    final res = await PcmPlaybackControl.clear();

    final int remainingFrames;
    if (res.framesDiscarded != null) {
      remainingFrames = res.framesDiscarded!;
    } else {
      // 폴백: 네이티브가 아직 폐기량을 안 준다(iOS 카운터 이전 / clear 미구현).
      // [_engineLevelFrames] 는 **외삽**이라 정확도가 떨어진다 — 숨기지 않고 찍는다.
      remainingFrames = _engineLevelFrames;
      _log('⚠ clear(): 네이티브 폐기량 없음 '
          '(ok=${res.ok}) → 엔진 추정치 $remainingFrames 프레임으로 폴백. '
          '진행도 정확도 하락(±50~150ms)');
    }
    if (!res.ok) {
      // Dart 큐만 비워진 상태 = 스피커에서는 계속 나온다. 조용히 넘어가면
      // "끊었는데 안 끊긴다"로만 보이므로 반드시 드러낸다.
      _log('⚠ clear(): 네이티브 미지원 — 엔진 잔량이 그대로 재생된다 '
          '(플러그인 clear() 구현 전)');
    }

    final playedFrames = _ledger.playedServerFrames(remainingFrames);

    // 원장은 진행도를 뽑은 **뒤에** 연다. 엔진이 비었다고 확신할 수 있는 지점이라야
    // 꼬리 계산이 맞다 — `turn_start` 는 그런 지점이 아니다(이전 턴 잔량이 남아 있을
    // 수 있다).
    _ledger.reset();

    return _ClearOutcome(
      playedServerBytes: playedFrames * 2, // 입력 프레임(PCM16 mono) → 바이트
      fromNative: res.framesDiscarded != null,
      halResidualMs: res.halResidualMs,
      halResidualKnown: res.halResidualKnown,
      writeInFlight: res.writeInFlight,
      nativeMs: res.nativeMs,
    );
  }

  /// 감정 라벨 → [avatarEmotion] 코드. **모르는 값은 0(neutral)** 이다.
  ///
  /// ⚠ **실측(2026-08-12 실기기 첫 통화): 영문 슬러그로 온다**(`happy`). 한글 수용은
  ///   그대로 둔다 — 서버가 라벨을 바꿔도 조용히 무표정이 되지 않게 하는 보험이다.
  /// ⛔ 화이트리스트로 막지 않는다 — 모르는 값이 오면 표정을 안 바꿀 뿐, 자막까지 버리면 안 된다.
  static int emotionCode(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'happy':
      case '기쁨':
      case '행복':
        return 1;
      case 'surprised':
      case 'surprise':
      case '놀람':
        return 2;
      case 'sad':
      case '슬픔':
        return 3;
      case 'angry':
      case '화남':
      case '분노':
        return 4;
      default:
        return 0; // neutral · 모르는 값 포함
    }
  }

  /// `sentence` — 구간 자막·표정 마커. **오디오 직전에 인밴드로** 온다.
  ///
  /// ⛔ 여기서 화면을 바꾸지 않는다. 이 구간의 오디오는 아직 안 들린다(우리는 최대 1.2초를
  ///   앞당겨 엔진에 넣는다). 도착 시점에 자막을 바꾸면 **소리보다 그만큼 앞서 간다.**
  ///   입모양과 같은 봉투 큐에 **위치로 꽂아** 두고, 재생이 그 지점에 닿을 때 터뜨린다.
  void _onSentenceMarker(Map<String, dynamic> msg) {
    // 취소 잔여 구간의 마커는 오디오와 **같이** 버린다(그 오디오는 이미 폐기됐다).
    if (_cancelledResidual) {
      _log('sentence 무시 — 취소 잔여 구간');
      return;
    }
    _sentenceCount++;
    final text = (msg['text'] as String?)?.trim() ?? '';
    final rawEmotion = msg['emotion'] as String?;
    final seqRaw = msg['seq'];
    final seq = seqRaw is int ? seqRaw : -1;
    _serverEmotionSeen = true;
    final sbRaw = msg['server_bytes'];
    _pendingMarkers.add((
      at: _envAdded,
      text: text,
      emotion: emotionCode(rawEmotion),
      seq: seq,
      // ⭐ **버리지 않는다.** 다음 마커와의 차분이 이 구간의 **정확한 오디오 길이**다
      //   (24kHz·16bit = 48,000 B/s 고정). 타자기 속도가 여기서 나온다.
      serverBytes: sbRaw is int ? sbRaw : -1,
    ));
    // [진단] 첫 실기기 통화에서 **서버 탓 / 앱 탓**을 가르는 줄이다.
    // 이 줄이 0건이면 서버가 안 보낸 것이고, 있는데 화면이 비면 앱 문제다.
    _log('sentence #$_sentenceCount seq=$seq emotion=$rawEmotion '
        'text="${text.length > 10 ? '${text.substring(0, 10)}…' : text}" '
        '위치=$_envAdded(재생 $_envPlayed) 대기=${_pendingMarkers.length}');

    // `server_bytes` 교차검증 — 없어도 동작한다. 어긋나면 드러낸다.
    final sb = msg['server_bytes'];
    if (sb is int) {
      final ours = _ledger.fedServerFrames * 2;
      final diff = sb - ours;
      if (diff.abs() > _serverBytesTolerance) {
        _log('⚠ server_bytes 불일치: 서버=$sb 우리원장=$ours 차이=${diff}B '
            '(${diff ~/ 48}ms) — 원장 절단 기준이 어긋난다');
      }
    }
  }

  /// 허용 오차(바이트). 한 청크(약 0.5초) 정도의 어긋남은 도착 순서 차이로 정상이다.
  static const int _serverBytesTolerance = 48 * 500;

  /// 재생이 마커 위치에 닿았다 — 이제 화면을 바꾼다.
  void _fireDueMarkers() {
    while (_pendingMarkers.isNotEmpty && _pendingMarkers.first.at <= _envPlayed) {
      final m = _pendingMarkers.removeAt(0);
      // ⚠ **구간 ≠ 문장이다.** 코드스위칭 문장은 언어별로 쪼개져 마커가 2~3개 온다
      //   (실측: "Hey! How's your" / "한국어" / "study today?"). LLM 이 끊는 게 아니라
      //   **TTS 가 언어별로 나눈다**(목소리가 언어마다 다르다).
      //   와이어에는 문장 경계가 없으므로 **턴을 단위로** 누적한다.
      if (m.text.isNotEmpty) {
        // ⭐ **앞 조각이 아직 다 안 드러났으면 즉시 마저 채운다.**
        //   뒤로 밀리면 자막이 소리보다 **늦어진다** — 앞서는 것만큼 나쁘다.
        _revealed = _revealTarget.length;
        _revealTarget =
            _revealTarget.isEmpty ? m.text : '$_revealTarget ${m.text}';
        _revealPerTick = _revealRateFor(m.text, m.serverBytes, _pendingMarkers);
        _revealAccum = 0;
        // 이 구간의 실측(글자↔바이트)을 다음 추정 재료로 남긴다.
        if (m.serverBytes >= 0 && _pendingMarkers.isNotEmpty) {
          final nb = _pendingMarkers.first.serverBytes;
          if (nb > m.serverBytes) {
            _revealCharsSum += m.text.length;
            _revealBytesSum += nb - m.serverBytes;
          }
        }
      }
      // ⛔ 감정은 **상태를 안 든다.** 서버가 매 마커에 이어붙인 결과를 이미 실어 준다.
      //   직전 값을 기억하면 `audio_cancel` 로 마커를 버릴 때 감정이 어긋난다.
      avatarEmotion.value = m.emotion;
    }
  }

  /// 이 조각을 **틱당 몇 글자씩** 드러낼지.
  ///
  /// ⭐ 다음 마커가 이미 대기 중이면 그 위치가 **이 조각의 오디오 길이**를 말해 준다
  ///   (마커는 오디오보다 먼저 도착한다). 그러면 추정이 아니라 **실제 길이에 맞춘다** —
  ///   글자가 조각의 소리와 정확히 같이 끝난다.
  ///
  /// 없을 때만 언어별 기본값을 쓴다. 근거는 실측 말하기 속도다:
  ///   한국어 6.3~8.5 자/초(중앙 7.7) · 영어 19.6 자/초.
  ///   봉투 틱이 25ms = 40틱/초 이므로 한국어 ≈0.19, 영문 ≈0.49 자/틱.
  /// ⚠ 한글 1글자(음절)가 영문 3~4글자 소리다 — 같은 속도를 쓰면 한글이 소리보다 훨씬
  ///   빨리 끝난다. 그래서 **한글이 섞여 있으면 느린 쪽**을 쓴다.
  double _revealRateFor(
    String text,
    int myServerBytes,
    List<({int at, String text, int emotion, int seq, int serverBytes})> pending,
  ) {
    // ① 다음 마커가 큐에 있으면 **차분이 곧 이 구간의 길이**다(추정 아님).
    //    실기기 로그가 이게 대부분 가능함을 보여 준다 — 우리가 최대 1.2초를 앞당겨
    //    엔진에 넣으므로 마커는 재생보다 앞서 쌓인다(`대기=2` 가 그 증거).
    var spanBytes = -1;
    if (pending.isNotEmpty && myServerBytes >= 0) {
      final nb = pending.first.serverBytes;
      if (nb > myServerBytes) spanBytes = nb - myServerBytes;
    }
    return revealRatePerTick(
      text: text,
      spanBytes: spanBytes,
      // ② 없으면(턴의 마지막 구간) **이 턴의 실측 비율**로 추정한다.
      charsPerByte: _revealBytesSum > 0 ? _revealCharsSum / _revealBytesSum : 0,
    );
  }

  /// 재생이 한 틱 나아갔다 — 그만큼 글자를 드러낸다.
  ///
  /// ⛔ **벽시계 타이머로 하지 않는다.** `Timer` 로 돌리면 재생이 멈춰도 자막이 계속
  ///   흐르고, 그게 지금 고치려는 어긋남과 **같은 종류**다. 이 함수는 봉투 큐가 실제로
  ///   한 칸 빠질 때만 불린다(= 소리가 그만큼 났을 때만).
  void _advanceReveal() {
    if (_revealTarget.isEmpty || _revealed >= _revealTarget.length) return;
    _revealAccum += _revealPerTick;
    var next = _revealed;
    while (_revealAccum >= 1.0 && next < _revealTarget.length) {
      next++;
      _revealAccum -= 1.0;
    }
    if (next != _revealed) {
      _revealed = next;
      state = state.copyWith(beaverSubtitle: _revealTarget.substring(0, _revealed));
    }
  }

  /// 드러내기 상태를 통째로 비운다(턴 시작 · 취소 · 통화 종료).
  void _resetReveal() {
    _revealTarget = '';
    _revealed = 0;
    _revealAccum = 0;
    _revealPerTick = 0.49;
    _revealCharsSum = 0;
    _revealBytesSum = 0;
  }

  /// `ready` — 이 세션이 **어떤 정책으로 도는지**를 서버가 알려준다. 서버가 이긴다.
  ///
  /// ⚠ 와이어 키는 **snake_case** 다. `cascade_protocol.py:254-264` 에 alias 도
  ///   alias_generator 도 없고, 서버 자신의 데모 화면(`cascade_demo.html`)도
  ///   `bargein_confirm`/`turn_silence_ms` 로 읽는다 — 1차 자료로 확인했다.
  ///   camelCase 도 같이 받는 이유: 나중에 서버가 alias 를 붙여도 **조용히 무동작**이
  ///   되지 않게. 이 종류의 어긋남은 에러가 안 나서 제일 늦게 발견된다.
  void _applyServerReady(Map<String, dynamic> msg) {
    bool? readBool(String snake, String camel) {
      final v = msg[snake] ?? msg[camel];
      return v is bool ? v : null;
    }

    int? readInt(String snake, String camel) {
      final v = msg[snake] ?? msg[camel];
      return v is int ? v : null;
    }

    final open = readBool('mic_always_open', 'micAlwaysOpen');
    if (open != null) _serverMicAlwaysOpen = open;
    final confirm = msg['bargein_confirm'] ?? msg['bargeinConfirm'];
    if (confirm is String) _serverBargeinConfirm = confirm;
    final silence = readInt('turn_silence_ms', 'turnSilenceMs');
    if (silence != null) _serverTurnSilenceMs = silence;

    // ⛔ 서버가 열라고 해도 AEC 스위치가 꺼져 있으면 **안 연다**. 그 거부를 로그에
    //   드러낸다 — 안 그러면 "서버는 상시개방인데 왜 barge-in 이 한 번도 안 되나"를
    //   아무도 못 찾는다(양쪽 다 자기 설정대로 돌고 있다고 믿는다).
    final refused = _serverMicAlwaysOpen && !_androidVoiceAudio;
    _log('ready: engine=${msg['engine']} 통로=${_channelMode.name} '
        'mic_always_open=$_serverMicAlwaysOpen '
        'bargein_confirm=$_serverBargeinConfirm '
        'turn_silence_ms=$_serverTurnSilenceMs '
        '→ 마이크 ${_micGated ? '게이팅' : '상시개방'}'
        '${refused ? ' ⚠ 서버는 상시개방을 요청했지만 AEC 미검증이라 거부했다' : ''}');
  }

  /// Parses and dispatches a control JSON frame from the server.
  void _handleControl(String text) {
    Map<String, dynamic> msg;
    try {
      final decoded = jsonDecode(text);
      if (decoded is! Map<String, dynamic>) return;
      msg = decoded;
    } catch (_) {
      return;
    }

    switch (msg['type'] as String?) {
      // 서버가 이 통화의 캐릭터를 정했다 — 화면 아바타를 대화 상대와 맞춘다.
      case 'call_started':
        final cid = msg['character_id'];
        if (cid is int) state = state.copyWith(characterId: cid);
        // [진단] 캐스케이드가 이걸 보내기 시작했는지 실기기에서 가리는 줄이다
        // (00155-br2). 안 오면 화면이 대표 캐릭터로 폴백하는데, 그건 **조용히**
        // 일어나서 로그가 없으면 "왜 다른 얼굴이지"를 못 찾는다.
        _log('call_started: character_id=$cid name=${msg['name'] ?? '(없음)'}');
        break;

      case 'turn_start':
        // 새 비버 턴이 열렸다 = 취소 잔여 구간의 끝. 서버 불변식상 여기부터 도착하는
        // 오디오는 이 턴의 것이다.
        if (_cancelledResidual) {
          _log('turn_start → 잔여 폐기 종료 (버린 양 ${_cancelledResidualBytes}B '
              '= ${(_cancelledResidualBytes / 48000).toStringAsFixed(2)}s)');
          _cancelledResidual = false;
          _cancelledResidualBytes = 0;
        }
        // 서버는 `turn_start`/`turn_end`/`output_transcript` 에 turn_id 를 예전부터
        // 필수로 싣고 있었다(protocol.py). 클라가 안 읽고 있었을 뿐이다.
        // 진행도 회신([_onAudioCancel])이 이 값을 쓴다.
        final rawTurnId = msg['turn_id'];
        _currentTurnId = rawTurnId is String ? rawTurnId : null;
        _logTurnBoundaryBacklog();
        if (state.phase == CallPhase.connecting) {
          state = state.copyWith(phase: CallPhase.inCall);
          _startElapsedTimer();
        }
        // New beaver turn → start a fresh subtitle line. The server streams the
        // line token-by-token via `output_transcript`, so the line must be
        // cleared here (not overwritten per token) and then accumulated below.
        // Also clear any stale hint: a new turn means the prior question is
        // answered (matches the server "new question cancels previous").
        // 소리가 나기 시작했다 = 더 이상 '준비 중'이 아니다.
        // 드러내기도 같이 멈춘다 — 안 그러면 다음 턴에 지난 조각이 이어서 흐른다.
        _resetReveal();
        state = state.copyWith(beaverSubtitle: '', hint: null, beaverPreparing: false);
        // New line → reset the avatar expression to neutral; it re-classifies as
        // the line streams in below. 문장 버퍼도 함께 비운다(직전 턴의 미완 조각이
        // 다음 턴 첫 문장에 섞이면 엉뚱한 표정이 나온다).
        avatarEmotion.value = 0;
        _emo.reset();
        // Beaver turn begins → gate the mic until the turn ends + audio drains.
        _gateMic();
      case 'output_transcript':
        // Incremental token/delta of the current beaver line — ACCUMULATE it
        // onto the running line instead of replacing, otherwise only the latest
        // token shows and the sentence appears chopped word-by-word. The line is
        // reset per turn in `turn_start` above.
        {
          final delta = msg['text'] as String?;
          if (delta != null && delta.isNotEmpty) {
            final line = state.beaverSubtitle + delta;
            state = state.copyWith(beaverSubtitle: line);
            // 표정은 **문장이 끝날 때 그 문장만** 보고 정한다.
            //
            // 이전 구현은 토큰마다 **누적 문자열 전체**를 재검사하고, 한 번 잡힌 값을
            // 턴이 끝날 때까지 고정했다. 그래서 문장 첫머리의 우연한 단어 하나가 턴
            // 전체의 표정을 결정했고, 실기기에서 "표정이 대사와 전혀 안 맞는다"로
            // 나타났다(2026-08-02). 립싱크 플랜 §6의 「턴 단위 갱신」 규약 위반이다.
            // ⛔ 서버가 감정을 직접 준 통화면 키워드 추측기를 쓰지 않는다. 둘이 같이
            //   쓰면 어느 쪽이 이겼는지 모르게 된다 — 명시적인 값이 추측을 이긴다.
            final next = _emo.feed(delta);
            if (next != null && !_serverEmotionSeen) avatarEmotion.value = next;
          }
        }
      case 'input_transcript':
        // Same streaming contract for the user's line: accumulate tokens; the
        // line is reset when the beaver's turn ends (below), i.e. right before
        // the user starts speaking.
        {
          final delta = msg['text'] as String?;
          if (delta != null && delta.isNotEmpty) {
            state = state.copyWith(userSubtitle: state.userSubtitle + delta);
            _markUserSpeaking(); // 듣는 얼굴로 — idle 슬롯 교체
          }
        }
      case 'turn_end':
        // Beaver turn finished generating. Clear the gate only once the
        // playback queue has also drained (+ hangover); see [_tryUngateMic].
        _turnEnded = true;
        // The beaver is done and the user is about to speak → start a fresh user
        // subtitle line so their next utterance accumulates from empty.
        state = state.copyWith(userSubtitle: '');
        _tryUngateMic();
      case 'audio_cancel':
        // barge-in: 사용자가 끼어들어 서버가 이 턴을 끊었다. 별도 `turn_end` 는 오지
        // 않는다 — 이 메시지가 턴 종결을 겸한다.
        unawaited(_onAudioCancel(msg));
      case 'user_turn_start':
        // ⚠ 서버→클라 **통지**다(UI 표시용). 클라에 VAD 는 없고 턴 판정은 전적으로
        //   서버가 한다. 그러니 재생·마이크 로직을 여기에 걸지 않는다 — 자막만 만진다.
        state = state.copyWith(userSubtitle: '');
      case 'user_turn_end':
        // 통지만. 자막 라인은 다음 `user_turn_start` 에서 새로 연다.
        break;
      case 'call_ended':
        // ⛔ **빈 문자열은 id 가 아니다.** 서버는 통화 행이 없을 때 `call_id` 를 null 이
        //   아니라 **`""`** 로 보낸다(`cascade_session.py:3198`:
        //   `ServerCallEnded(call_id=str(self._call_id or ""))`).
        //   그대로 받으면 `id?.toString()` 이 `""` 를 통과시켜 **우리가 id 를 가졌다고 믿는다.**
        //   그러면 통화 종료 화면의 복구 폴링(`_recoverCallId`)이 안 돌고 빈 id 로 분석을 친다 —
        //   **복구가 가장 필요한 경우(행이 없다)에 정확히 복구가 죽는다.** null 보다 나쁘다.
        // ⭐ 통로로 가르지 않는다. 한 자리에서 막아 두면 라이브 서버가 언젠가 같은 값을
        //   보내도 안 깨진다. 공백만 있는 값도 같이 없는 것으로 본다.
        final id = normalizeCallId(msg['call_id']);
        // Server-initiated close is expected; the socket's onDone must not be
        // treated as an unexpected drop.
        _expectClose = true;
        state = state.copyWith(
          phase: CallPhase.ending,
          callId: id,
          hint: null,
        );
        _log('call_ended id=${id ?? '(없음 — 종료 화면이 복구 폴링으로 되짚는다)'} '
            '→ draining closing line');
        _scheduleClosingDrain();
      case 'error':
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: (msg['message'] as String?) ?? _l10n.callErrorGeneric,
        );
        unawaited(_teardown(keepError: true));
      case 'hint':
        // Dynamic example-answer hint for the beaver's question turn. Additive:
        // unknown to older builds (harmlessly ignored). Replaces any prior hint.
        // ⛔ **버리면 왜 버렸는지 찍는다.** 서버는 보냈는데 앱에 아무 흔적도 없던
        //   통화가 있었다(2026-08-12) — 받아도 안 남고 버려도 안 남아 **판정 자체가
        //   불가능**했다. 조용한 실패를 없애는 게 이 로그의 목적이다.
        {
          final parsed = HintData.parse(msg);
          final hint = parsed.hint;
          if (hint != null) {
            _hintCount++;
            state = state.copyWith(hint: hint);
            _log('hint[turn=${hint.turnId}]: ${hint.examples.length}개 수신');
          } else {
            _hintDropped++;
            _log('⚠ hint 버림 — ${parsed.drop} (turn=${msg['turn_id']})');
          }
        }
      case 'teaching_plan':
        // ⚠ 여기도 같은 모양이다 — `whereType` 두 번이 **조용히** 걸러낸다.
        //   버린 게 있을 때만 찍는다(정상은 요약 카운터로 충분하다 — 로그 폭탄 금지).
        {
          final raw = msg['items'];
          if (raw is List) {
            final items = raw
                .whereType<Map<String, dynamic>>()
                .map(TeachingItem.fromJson)
                .whereType<TeachingItem>()
                .toList(growable: false);
            if (items.length != raw.length) {
              _log('⚠ teaching_plan 일부 버림 — ${raw.length}개 중 '
                  '${items.length}개만 살았다');
            }
            state = state.copyWith(teachingPlan: items);
          } else {
            _log('⚠ teaching_plan 버림 — items 가 배열이 아님(${raw.runtimeType})');
          }
        }
      case 'pong':
        break;

      // ── 캐스케이드 통로 전용 프레임 ─────────────────────────────────────────
      case 'sentence':
        _onSentenceMarker(msg);
      case 'ready':
        _applyServerReady(msg);
      case 'beaver_preparing':
        // 서버가 LLM/TTS 를 도는 중 — **설명되지 않는 침묵**을 막기 위한 통지다.
        // UI 는 아직 없다. 상태에만 얹어 두고(화면은 나중), 로그로 단계를 남긴다.
        {
          final stage = msg['stage'] as String? ?? '';
          final idx = msg['index'];
          final total = msg['total'];
          final elapsed = msg['elapsed_ms'];
          state = state.copyWith(beaverPreparing: true);
          _log('beaver_preparing: $stage '
              '${idx is int && total is int && total > 0 ? '$idx/$total ' : ''}'
              '${elapsed is int ? '+${elapsed}ms' : ''}');
        }
      case 'stt_rollover':
        // STT 내부 스트림 교체(구글은 5분 상한이 있다). 재생·턴에는 영향이 없지만,
        // **지연이 튀었을 때 롤오버 때문이었는지**를 사후에 가르려면 클라 로그에도 있어야 한다.
        {
          final reason = msg['reason'] as String? ?? '';
          final gap = msg['gap_ms'];
          _log('stt_rollover: reason=$reason '
              '${gap is int ? 'gap=${gap}ms' : ''} — 다음 턴부터 새 스트림');
        }
      case '__test_cancel_report':
        // dev 왕복 계측 회신(가짜 비버 취소). 앱 UI 는 없다 — 로그로만 받는다.
        _log('__test_cancel_report: $msg');

      default:
        break;
    }
  }

  /// After `call_ended`, waits for the queue to drain the beaver's closing line
  /// before acknowledging and closing (§8-4). The drain completes once the queue
  /// is empty *and* has stayed empty for [_closingStableDelay] (no new audio).
  /// A fallback timer guards against the queue never settling.
  void _scheduleClosingDrain() {
    if (_drainScheduled) return;
    _drainScheduled = true;
    // The queue may already be empty by now; start the stability check.
    _maybeFinishClosing();
    // Fallback: finish after a delay regardless (e.g. no trailing audio).
    // Stored + cancelled in [_teardown]/[_finishClosing] so a stray timer from a
    // finished call can't fire against a *later* call and end it early.
    //
    // ⚠ 3초였는데 **클라가 서버보다 조급했다.** 서버는 작별 오디오를 전부 흘려보낸
    //   뒤에 call_ended 를 보내고, playback_done 을 PLAYBACK_DONE_WAIT_S = 7.0 초까지
    //   기다린다(call_session.py). 즉 3초는 서버가 준 예산의 43% 만 쓰고 끊는 것이고,
    //   엔진이 최대 2.5초를 물고 있는 지금은 그 차이가 그대로 인사 절단이 된다.
    //   6초 = 서버 7초 안쪽에서 최대한 쓰는 값(넘기면 서버가 먼저 닫는다).
    _closingFallbackTimer?.cancel();
    _closingFallbackTimer = Timer(
      const Duration(seconds: 6),
      _forceFinishClosing,
    );
  }

  /// While a close is pending, completes it once the queue has been empty for a
  /// short quiet window. Fresh audio (in [_feedPlayer]) cancels the timer, so a
  /// still-arriving closing line is never cut off.
  void _maybeFinishClosing() {
    if (!_drainScheduled) return;
    // ⚠ 엔진 잔량까지 봐야 한다 — 여기서 조기 확정하면 _teardown 의 release() 가
    //   엔진에 남은 작별 인사(최대 2.5초)를 통째로 버린다.
    if (!_audioDrained) return; // still real audio queued/playing
    if (_closingStableTimer != null) return; // already waiting out the tail
    _closingStableTimer = Timer(_closingStableDelay, () {
      _closingStableTimer = null;
      if (!_drainScheduled) return;
      if (!_audioDrained) return; // audio came back; a later drain retries
      _forceFinishClosing();
    });
  }

  /// Fallback path: closes even if the queue never settles cleanly, but only
  /// after waiting out the fallback timer.
  void _forceFinishClosing() {
    if (!_drainScheduled) return;
    unawaited(_finishClosing());
  }

  /// Sends `playback_done`, closes the socket, and ends the session.
  Future<void> _finishClosing() async {
    if (!_drainScheduled) return;
    _drainScheduled = false;
    _closingStableTimer?.cancel();
    _closingStableTimer = null;
    _closingFallbackTimer?.cancel();
    _closingFallbackTimer = null;
    _log('playback drained → playback_done, closing');
    _send({'type': 'playback_done'});
    final preservedCallId = state.callId;
    final preservedElapsed = state.elapsedSec;
    await _teardown();
    state = CallState(
      phase: CallPhase.ended,
      callId: preservedCallId,
      elapsedSec: preservedElapsed,
    );
  }

  /// Socket closed by the server (incl. 1008 auth reject) (§8-6).
  void _onWsDone() {
    final phase = state.phase;
    if (phase == CallPhase.connecting) {
      // Closed before we ever went live → treat as auth/connection error.
      state = state.copyWith(
        phase: CallPhase.error,
        errorMsg: _l10n.connectionFailedTitle,
      );
      unawaited(_teardown(keepError: true));
      return;
    }
    // Expected close (hang-up / call_ended / teardown) already drives the exit.
    if (_expectClose) return;
    if (phase == CallPhase.inCall) {
      // Unexpected mid-call drop with no `call_ended` (e.g. a ~1-min idle
      // timeout on a proxy/LB). The old code did nothing here, stranding the
      // user on a frozen, silent "live" call. Recover exactly like a hang-up so
      // the wrap-up screen opens (and can recover the call id via the baseline).
      _log('ws closed unexpectedly during inCall → recovering to wrap-up');
      unawaited(hangUp());
    }
  }

  /// Transport-level error (§8-6).
  void _onWsError(Object error) {
    // Expected close (hang-up / call_ended / teardown) — the exit is already
    // being driven; a trailing error frame must not clobber it.
    if (_expectClose) return;
    // The call already completed (`call_ended` received, id captured) and is just
    // draining its closing line — an error here should finish the call normally
    // (opening the wrap-up screen), not discard a successful conversation.
    if (state.phase == CallPhase.ending && state.callId != null) {
      _log('ws error during closing drain → finishing normally');
      unawaited(_finishClosing());
      return;
    }
    state = state.copyWith(
      phase: CallPhase.error,
      errorMsg: _l10n.callNetworkError,
    );
    unawaited(_teardown(keepError: true));
  }

  /// Encodes and sends a control JSON frame if the socket is open.
  void _send(Map<String, dynamic> msg) {
    // ⚠ 소켓 null 체크 **앞**이다. 취소 배관 리그는 소켓 없이 돌기 때문에 여기서 못
    //   가로채면 `playback_progress` 가 조용히 사라진다 — 그러면 리그가 재려는 값이
    //   화면에 안 나온다. 가로채는 건 서버가 받게 될 것과 **같은 Map** 이어야 하므로
    //   가공하지 않고 그대로 넘긴다.
    if (kDebugMode) debugOutboundSink?.call(msg);
    final ch = _channel;
    if (ch == null) return;
    try {
      ch.sink.add(jsonEncode(msg));
    } catch (_) {
      // Socket already closing; ignore.
    }
  }

  /// Signals that the learner revealed a hint (fire-and-forget, no ack). The
  /// server downgrades that turn's evidence, so the UI must call this exactly
  /// once per hint, on first reveal.
  void sendHintUsed(String turnId) =>
      _send({'type': 'hint_used', 'turn_id': turnId});

  /// Toggles the subtitle (caption) display. UI preference only.
  void setSubtitleOn(bool value) =>
      state = state.copyWith(subtitleOn: value);

  /// Toggles whether the hint card is shown. UI preference only.
  void setHintOn(bool value) => state = state.copyWith(hintOn: value);

  /// Starts the UI elapsed-time ticker.
  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSec: state.elapsedSec + 1);
    });
  }

  /// Starts the application keepalive: a periodic `ping` so the socket always
  /// has recent client→server traffic (the server replies `pong`, already
  /// handled). Cancelled in [_teardown].
  void _startKeepalive() {
    _keepaliveTimer?.cancel();
    _keepaliveTimer = Timer.periodic(_keepaliveInterval, (_) {
      _send({'type': 'ping'});
    });
  }

  /// Tears down all resources: recorder, player, socket, timers (§8-1/§8-2).
  ///
  /// When [keepError] is true the phase is left untouched (an error phase was
  /// already set by the caller); otherwise it resets to [CallPhase.idle].
  Future<void> _teardown({bool keepError = false}) async {
    // ⛔ **아래 리셋들보다 먼저** 붙잡는다. 요약 줄이 실제로 쓴 통로를 말해야 하는데,
    //   리셋이 통로를 기본값으로 되돌리므로 나중에 읽으면 거짓이 된다(실기기 확인).
    final endedChannel = _channelMode;
    // End the CallKit call backing this session, first thing — every exit path
    // funnels through here (hang-up, server `call_ended`, ws error, next call's
    // teardown-before-connect), and the call is kept alive for the whole
    // conversation on purpose. Miss this and the lock-screen call UI outlives the
    // conversation, with its timer still counting.
    //
    // Safe on the [_connect] path too: _callUuid is still the PREVIOUS call's at
    // that point (it is assigned after this teardown), so a stale call gets
    // cleaned up rather than the new one.
    final callUuid = _callUuid;
    _callUuid = null; // cleared first: the ENDED event this triggers is a no-op
    if (callUuid != null) {
      try {
        await FlutterCallkitIncoming.endCall(callUuid);
      } catch (_) {
        // Already gone (user pressed End on the lock screen) — nothing to do.
      }
    }

    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    _keepaliveTimer?.cancel();
    _keepaliveTimer = null;
    _envTimer?.cancel();
    _envTimer = null;
    _envQueue.clear();
    // ⛔ 큐에 꽂아 둔 **미발화 마커**도 같이 버린다. 안 지우면 다음 턴에 지난 턴
    //   표정·자막이 뜬다(그 오디오는 이미 폐기됐다).
    _pendingMarkers.clear();
    // 진행 중이던 드러내기도 멈춘다 — 남은 글자가 새면 안 들은 말이 자막에 남는다.
    _resetReveal();
    _drainScheduled = false;
    _closingStableTimer?.cancel();
    _closingStableTimer = null;
    _closingFallbackTimer?.cancel();
    _closingFallbackTimer = null;
    // Diagnostics are per-call: a stall left open here would otherwise be
    // reported against the *next* call's anchor as an absurd gap.
    _starveAtMs = null;
    _lastChunkAtMs = null;
    _logAnchorMs = null;
    _audioTailUntilMs = 0;
    // barge-in 상태 — 다음 통화로 새어 나가면 첫 인사가 폐기된다.
    _cancelledResidual = false;
    _cancelledResidualBytes = 0;
    _currentTurnId = null;
    _ledger.reset();
    _prevTurnBacklogMs = -1;
    _backlogRiseStreak = 0;
    // 통로도 통화 스코프다. 남겨 두면 캐스케이드 통화 뒤의 다음 통화가 (호출부가
    // 값을 안 주는 경로로 들어왔을 때) 게이팅 없이 열린다 — AEC 실측 전엔 그게
    // 자기-대화 루프다. [_connect] 가 이 teardown **뒤에** 새 값을 넣는다.
    _channelMode = CallChannel.defaultChannel;
    // 서버가 준 세션 정책도 통화 스코프다. 남기면 다음 통화가 **이전 서버 답**으로
    // 마이크를 연다 — 그 통화의 서버는 다르게 말했을 수 있다.
    _serverMicAlwaysOpen = false;
    _serverBargeinConfirm = '';
    _serverTurnSilenceMs = 0;
    // ⭐ [진단] 통화 한 건의 **경계 판정용 한 줄**. 첫 실기기 통화에서 자막이 안 뜨면
    //   여기부터 본다:
    //     sentence=0        → **서버가 안 보냈다**(앱은 받을 준비가 돼 있었다)
    //     sentence>0, 자막 X → **앱 문제**(위치 발화·자막 배선을 본다)
    //     odd_frames>0      → **서버 불변식 I6 위반**(0 이 정상)
    _log(buildCallSummaryLine(
      sentences: _sentenceCount,
      pendingMarkers: _pendingMarkers.length,
      oddFrames: _oddFrames,
      // ⚠ 함수 **진입 시점에 붙잡아 둔** 값이다. 여기서 `_channelMode` 를 읽으면
      //   이미 기본값으로 되돌아간 뒤라 `live` 가 찍힌다(실기기에서 그렇게 나왔다).
      channel: endedChannel,
      hints: _hintCount,
      hintsDropped: _hintDropped,
    ));
    _oddFrames = 0;
    _pendingMarkers.clear();
    _envAdded = 0;
    _envPlayed = 0;
    _sentenceCount = 0;
    _hintCount = 0;
    _hintDropped = 0;
    _serverEmotionSeen = false;

    // Reset the half-duplex mic gate + its timers so a new call starts ungated.
    _micGateTimer?.cancel();
    _micGateTimer = null;
    _gateSafetyTimer?.cancel();
    _gateSafetyTimer = null;
    _beaverAudioActive = false;
    avatarSpeaking.value = false;
    avatarLevel.value = 0.0;
    avatarEmotion.value = 0;
    avatarShape.value = 0.0;
    _listenTimer?.cancel();
    _listenTimer = null;
    avatarIdleKind.value = kIdleWait;
    _emo.reset();
    _turnEnded = false;
    _micFramesSent = 0;
    _uplinkBytes = 0;
    _lastReportedRoute = '';
    AudioRouteProbe.setRouteChangeListener(null);
    _micWatchdogTimer?.cancel();
    _micWatchdogTimer = null;
    _micFramesReceived = 0;
    _micRestarted = false;

    // Stop the mic first so no more bytes flow into a closing socket.
    await _micSub?.cancel();
    _micSub = null;
    try {
      await _recorder?.stopRecorder();
    } catch (_) {}
    try {
      await _recorder?.closeRecorder();
    } catch (_) {}
    _recorder = null;
    await _micController?.close();
    _micController = null;

    // Stop in-call audio routing: remove the native route-change observer and
    // clear the speaker override so the session doesn't stay forced to the
    // loudspeaker after the call. Pairs with 'routeToSpeaker' in [start].
    //
    // Guarded on [_audioRoutingStarted] for the same reason as the session
    // deactivation below: the teardown that runs at the start of every call must
    // not clear the preferred input of a call that is just coming up.
    if (_audioRoutingStarted &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS) {
      _audioRoutingStarted = false;
      try {
        await _audioRouteChannel.invokeMethod<void>('stopCallAudioRouting');
      } catch (_) {}
    }

    // Stop native PCM playback: disable the feed callback first so no feed runs
    // against a released engine, then release and clear the queue.
    _pcmActive = false;
    _stopPushFeed();
    _stopEventLoopProbe();
    _stopInflateLog();
    _prebufferFlushTimer?.cancel();
    _prebufferFlushTimer = null;
    _playing = false;
    if (!kIsWeb && _pcmSetup) {
      try {
        FlutterPcmSound.setFeedCallback(null);
      } catch (_) {}
      // Wait out any feed callback that's mid-flight so release() doesn't race a
      // feed against the engine — that race can leave a fast re-call silent.
      for (var i = 0; i < 20 && _feeding; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      try {
        await FlutterPcmSound.release();
      } catch (_) {}
      // Let the singleton native engine fully tear down before a rapid re-call
      // re-runs setup() (guards the re-init race → "재통화 시 voice 안 나옴").
      await Future<void>.delayed(_releaseSettle);
    }
    _pcmSetup = false;
    _feeding = false;

    // [AEC] 통화 용도 모드를 되돌린다. **우리가 켠 경우에만** — 안 켠 모드를 NORMAL 로
    // 돌리면 시스템 통화(수신전화)가 잡고 있던 모드를 밟는다. 재생 트랙을 release 한
    // 뒤에 되돌려야 라우팅이 트랙보다 먼저 바뀌어 마지막 소리가 리시버로 새지 않는다.
    if (_voiceModeSet) {
      _voiceModeSet = false;
      final diag = await AudioRouteProbe.setVoiceCallMode(false);
      _log('AEC: 통화 용도 오디오 OFF → $diag');
    }

    _pcmQueue = Uint8List(_pcmQueueInitialBytes);
    _pcmHead = 0;
    _pcmTail = 0;
    _lastFeedSilent = null;

    // Close the socket.
    await _wsSub?.cancel();
    _wsSub = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;

    // Hand the audio session back so other apps' audio un-ducks and the next
    // call reconfigures from a clean slate. Best-effort (cleanup path).
    //
    // ONLY when we activated it. Never deactivate a session someone else owns:
    // teardown-before-connect runs at the START of every call, and deducing
    // ownership from [_callkitOwnedAudio] there read the PREVIOUS call's value —
    // so answering a CallKit call deactivated the session the system had just
    // activated for it. Socket alive, both audio directions dead. On the CallKit
    // path the system deactivates its own session (didDeactivate) when the call
    // ends, so there is nothing for us to do.
    if (_weActivatedSession) {
      _weActivatedSession = false;
      try {
        final session = await AudioSession.instance;
        await session.setActive(
          false,
          avAudioSessionSetActiveOptions:
              AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
        );
      } catch (_) {}
    }

    if (!keepError) {
      // Preserve callId/ended state set by callers; only reset a live phase.
      if (state.phase != CallPhase.ended) {
        state = const CallState();
      }
    }
  }

  // ── 취소 배관 리그 전용 표면 (디버그 빌드 전용) ─────────────────────────────
  //
  // `audio_cancel` 배관을 실기기에서 재려면 서버가 취소를 쏴 줘야 하는데, 서버 dev
  // 훅이 배포 전이다. 그래서 프레임을 **클라 안에서** 주입한다.
  //
  // 이게 유효한 측정인 이유: 재려는 값 `client_stop_ms`(취소 수신 → 실제 무음)는
  // 전부 클라 내부 구간이다. 서버가 기여하는 건 RTT 뿐이고 그건 이번 측정 대상이
  // 아니다. 즉 로컬 주입으로 나오는 숫자는 대용품이 아니라 진짜다.
  //
  // ⛔ 리그가 [_clearPlayback] 이나 [_onAudioCancel] 을 직접 부르면 안 된다. 그러면
  //   실제로는 안 도는 경로를 검증한 게 된다. 진입은 [debugInjectWsFrame] 하나뿐이다.

  /// [디버그 전용] 소켓으로 나가려던 제어 프레임을 가로챈다.
  ///
  /// 리그에는 소켓이 없어 [_send] 가 조용히 빠진다. 여기로 받아야 `playback_progress`
  /// 페이로드를 **서버가 받게 될 모습 그대로** 화면에 찍을 수 있다.
  static void Function(Map<String, dynamic> msg)? debugOutboundSink;

  /// [디버그 전용] 소켓이 받은 것처럼 프레임을 밀어 넣는다.
  ///
  /// [_onWsData] 는 소켓이 닿는 유일한 관문이다. 여기로만 들어가면 파싱·디스패치·
  /// 게이팅·원장·`clear()`·회신 구성까지 한 줄도 우회하지 않는다.
  /// [data] 는 제어 JSON 문자열이거나 PCM24k 바이너리([Uint8List]).
  void debugInjectWsFrame(dynamic data) {
    assert(kDebugMode, 'debug 전용 진입점이 릴리즈 경로에서 불렸다');
    _onWsData(data);
  }

  /// [디버그 전용] 소켓·마이크·권한 없이 **재생 파이프라인만** 개통한다.
  ///
  /// [voiceCallAudio] 로 AEC 전/후를 **리빌드 없이** 전환한다 — 컴파일 플래그
  /// (`ANDROID_VOICE_AUDIO`)에 묶으면 리그가 한 빌드에서 전/후를 못 재고, 그러면
  /// 두 측정 사이에 빌드가 끼어 "무엇 때문에 달라졌는지"를 못 가린다.
  Future<void> debugOpenPlayback({bool voiceCallAudio = false}) async {
    assert(kDebugMode, 'debug 전용 진입점이 릴리즈 경로에서 불렸다');
    await _openPlayback(voiceCallAudio: voiceCallAudio);
  }

  /// [디버그 전용] 리그 종료. 소켓/마이크가 애초에 없어도 [_teardown] 은 안전하다
  /// (전부 null 가드). 엔진 release 까지 여기서 끝낸다.
  Future<void> debugClosePlayback() => _teardown();

  /// [디버그 전용] 리그가 보는 계측 카운터 묶음.
  ///
  /// - `cancelledResidualBytes` — 취소 이후 폐기한 잔여. 서버 불변식("취소~다음
  ///   `turn_start` 사이 오디오는 버린다")이 실제로 지켜지는지 리그가 이걸로 판정한다.
  /// - `queuedBytes` — Dart 링버퍼 잔량. **락업 검출량이다.** 네이티브가 in-flight 를
  ///   부풀린 채 굳으면 [_engineLevelFrames] 가 계속 높게 나오고 [_pump] 의
  ///   `level < _engineLowFrames` 가 영영 거짓이 되어 이 값이 단조 증가한다.
  ///   사람 귀 대신 이걸 본다.
  /// - `engineLevelFrames` — 엔진 잔량 **추정**(외삽). 큐가 안 빠질 때 원인이 엔진
  ///   과대보고인지 가르는 보조 지표다.
  ///
  /// getter 3개가 아니라 메서드 하나인 이유: riverpod_lint 의
  /// `avoid_public_notifier_properties` 는 Notifier 의 공개 상태를 `state` 로만
  /// 노출하라고 요구한다. 이건 상태가 아니라 계측 훅이라 `state` 에 넣을 것도 아니고,
  /// 그렇다고 린트를 무시로 덮는 것보다 애초에 프로퍼티가 아닌 게 맞다.
  ({int cancelledResidualBytes, int queuedBytes, int engineLevelFrames})
      debugCounters() => (
            cancelledResidualBytes: _cancelledResidualBytes,
            queuedBytes: _queueLen,
            engineLevelFrames: _engineLevelFrames,
          );
}

/// [NormalCallController._clearPlayback] 의 결과 — `playback_progress` 페이로드의 재료.
///
/// 값 하나가 아니라 묶음인 이유는 **출처와 한계를 같이 실어야** 하기 때문이다.
/// 서버는 이 보고로 대화 이력의 절단 지점을 정하는데, 추정치를 실측으로 착각하면
/// 사용자가 듣지도 않은 문장이 "들은 것"으로 박힌다.
class _ClearOutcome {
  const _ClearOutcome({
    required this.playedServerBytes,
    required this.fromNative,
    required this.halResidualMs,
    required this.halResidualKnown,
    required this.writeInFlight,
    this.nativeMs = -1,
  });

  /// 이번 턴에 실제로 스피커로 나간 **서버발** 바이트(클라 필러 무음 제외).
  final int playedServerBytes;

  /// 위 값이 네이티브 실측 잔량으로 계산됐는가. false 면 Dart 외삽 폴백이라
  /// `source: 'estimate'` 로 보고해야 한다.
  final bool fromNative;

  /// flush 이후에도 HAL/믹서에 남아 계속 울리는 잔량(ms).
  final int halResidualMs;

  /// 위 값이 측정된 것인가. false 면 0 은 "없음"이 아니라 **모름**이다.
  final bool halResidualKnown;

  /// 폐기 시점에 재생 스레드가 실오디오 write() 안에 있었는가 — 그 데이터는 우리 flush
  /// 뒤에 트랙으로 들어가 잠깐 더 울린다.
  final bool writeInFlight;

  /// 네이티브 `clear()` **내부** 소요(ms). -1 = 미보고.
  final int nativeMs;

  /// `client_stop_ms` 가 **무엇을 잰 값인지** 와이어에 명시한다.
  ///
  /// - `hal_drained` — 하드웨어 잔량까지 빠져 **실제로 조용해진 시각**. 서버가 합격
  ///   판정(50~120ms)에 그대로 쓴다
  /// - `clear_returned` — flush 반환까지만. 실제 무음은 이보다 **늦으므로 하한**이다
  ///
  /// 둘을 가르는 조건이 두 개인 이유:
  ///   ① HAL 잔량을 못 쟀으면(getTimestamp 미가용·iOS) 애초에 하드웨어 구간이 빠져 있다
  ///   ② 쟀더라도 그 순간 실오디오 write 가 진행 중이었으면, 그 데이터가 flush 뒤에
  ///      들어가 재생 스레드가 회수할 때까지 소리가 남는다. 회수는 clear() 반환 뒤라
  ///      값에 못 담는다 — 그래서 하한으로 낮춘다
  ///
  /// ⚠ `hal_drained` 로 보내면 서버가 합격 판정에 그대로 쓴다. 애매하면 낮추는 쪽이 맞다.
  String get stopMeasure =>
      (halResidualKnown && !writeInFlight) ? 'hal_drained' : 'clear_returned';
}
