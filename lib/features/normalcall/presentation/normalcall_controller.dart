import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart'
    show ValueNotifier, debugPrint, kDebugMode, kIsWeb;
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding;
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/network/ws_url.dart';
import '../domain/entities/call_hint.dart';
import 'normalcall_providers.dart';

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
    this.baselineCallId,
    this.beaverSubtitle = '',
    this.userSubtitle = '',
    this.errorMsg,
    this.hint,
    this.teachingPlan = const [],
    this.subtitleOn = true,
    this.hintOn = true,
  });

  /// Current lifecycle phase.
  final CallPhase phase;

  /// Elapsed call time in whole seconds (UI display only; server is the source
  /// of truth for actual call limits via `call_ended`).
  final int elapsedSec;

  /// Server call id, available once `call_ended` arrives. Pass to analysis.
  final String? callId;

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

  /// Sentinel so [copyWith] can distinguish "leave [hint] unchanged" from
  /// "clear [hint] to null" — the `?? this.hint` idiom cannot express the latter.
  static const Object _keep = Object();

  /// Returns a copy with the given fields replaced. Pass `hint: null` to clear
  /// the active hint (the [_keep] sentinel preserves it when omitted).
  CallState copyWith({
    CallPhase? phase,
    int? elapsedSec,
    String? callId,
    int? baselineCallId,
    String? beaverSubtitle,
    String? userSubtitle,
    String? errorMsg,
    Object? hint = _keep,
    List<TeachingItem>? teachingPlan,
    bool? subtitleOn,
    bool? hintOn,
  }) {
    return CallState(
      phase: phase ?? this.phase,
      elapsedSec: elapsedSec ?? this.elapsedSec,
      callId: callId ?? this.callId,
      baselineCallId: baselineCallId ?? this.baselineCallId,
      beaverSubtitle: beaverSubtitle ?? this.beaverSubtitle,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      errorMsg: errorMsg ?? this.errorMsg,
      hint: identical(hint, _keep) ? this.hint : hint as HintData?,
      teachingPlan: teachingPlan ?? this.teachingPlan,
      subtitleOn: subtitleOn ?? this.subtitleOn,
      hintOn: hintOn ?? this.hintOn,
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

  /// True while the beaver is speaking (mirrors [_beaverSpeaking]).
  final ValueNotifier<bool> avatarSpeaking = ValueNotifier<bool>(false);

  /// Current avatar emotion code (0 neutral/smug, 1 happy, 2 surprised, 3 sad,
  /// 4 angry), classified from the beaver's streamed line so the face reacts to
  /// what it says. Reset to neutral each turn; set sticky within a turn.
  final ValueNotifier<int> avatarEmotion = ValueNotifier<int>(0);

  /// Mouth SHAPE, −1 (round "OO") .. 0 ("AH") .. +1 (wide "EE"), from the
  /// zero-crossing rate of the audio about to play (a cheap spectral-tilt proxy:
  /// high ZCR = front/fricative → wide, low ZCR = back vowel → round). Lets the
  /// mouth form vowel shapes instead of a generic open/close. The widget smooths
  /// it. Characters without EE/OO sprites simply ignore this.
  final ValueNotifier<double> avatarShape = ValueNotifier<double>(0.0);

  /// Keyword lexicon for the (heuristic) emotion classifier. Keyed by the same
  /// codes as [avatarEmotion]. Korean + English; matched case-insensitively.
  static const Map<int, List<String>> _emotionLexicon = {
    1: ['하하', 'ㅋㅋ', 'ㅎㅎ', '좋아', '좋은', '좋네', '좋다', '최고', '굿', '짱', '잘했',
      '대단', '훌륭', '기뻐', '신나', '행복', '사랑', 'good', 'great', 'awesome',
      'nice', 'love', 'cool', 'haha', 'perfect', 'well done', 'yay'],
    2: ['헐', '대박', '진짜?', '정말?', '뭐?', '우와', '와우', '놀라', '세상에', '믿기',
      '오마이', 'wow', 'whoa', 'no way', 'oh my', 'really?', 'what?!'],
    3: ['슬프', '슬퍼', '미안', '아쉽', '안타', '속상', '우울', 'ㅠ', 'ㅜ', '눈물',
      'sorry', 'sad', 'unfortunately', 'poor'],
    4: ['짜증', '뭐야', '바보', '멍청', '어이없', '그만', '답답', '흥', '쳇', '열받', '화나',
      'ugh', 'stupid', 'annoying', 'stop it'],
  };

  /// Sub-frame mouth envelope: one entry per [_envStepMs] of audio, queued as
  /// audio is handed to the player and drained in real time. A single RMS per
  /// ~200ms feed (≈5Hz) is far too coarse for syllables; this runs at 40Hz so
  /// the mouth lands on the actual speech.
  final List<double> _envQueue = <double>[];
  Timer? _envTimer;
  static const int _envStepMs = 25;

  /// The native player buffers a little ahead of what is audible, so hold the
  /// envelope back by this much — otherwise the lips run ahead of the sound.
  static const int _envLeadMs = 100;

  /// RMS below this (near-silence) closes the mouth outright.
  static const double _avatarRmsGate = 260;

  /// RMS mapped to a fully-open mouth (tuned for Gemini 24k speech).
  static const double _avatarRmsFull = 5200;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSub;

  FlutterSoundRecorder? _recorder;
  StreamController<Uint8List>? _micController;
  StreamSubscription<Uint8List>? _micSub;

  // ── Gapless PCM playback (flutter_pcm_sound, callback-pull @ native 24kHz) ──
  // A byte queue holds inbound server PCM16; the plugin's feed callback pulls
  // from it. When the queue is empty we feed a short silence so the engine is
  // never starved into a stuck underflow churn — the root cause of the ~1-min
  // audio cutout with the old flutter_sound stream player.

  /// Inbound PCM16 byte queue (little-endian samples). Consumed from [_pcmHead]
  /// forward; an odd trailing byte simply stays until the next chunk completes
  /// its Int16 sample, so samples never split across chunks.
  List<int> _pcmQueue = <int>[];

  /// Read offset into [_pcmQueue]. Bytes before it are already fed; the list is
  /// compacted (see [_maybeCompact]) once the offset grows large.
  int _pcmHead = 0;

  /// True once [FlutterPcmSound.setup] has run (guards teardown's release()).
  bool _pcmSetup = false;

  /// True while playback is live; gates the feed callback and enqueue so no
  /// audio work runs before setup or after teardown.
  bool _pcmActive = false;

  // Playback tuning (frames = samples; PCM16 mono → 2 bytes/frame @ 24kHz).
  static const int _playbackSampleRate = 24000;
  static const int _playbackChannels = 1;

  /// Feed callback fires when buffered frames fall below this (~100ms).
  static const int _feedThresholdFrames = 2400;

  /// Bytes fed per callback when audio is available (~200ms of 24kHz PCM16).
  static const int _feedChunkBytes = 9600;

  /// Silence frames fed when the queue is empty (~50ms keep-alive).
  static const int _silenceFrames = 1200;

  /// Jitter prebuffer (~120ms of PCM16): at the start of a beaver turn, hold real
  /// audio (feed silence) until this much is queued, so brief network jitter can't
  /// starve the engine into an audible gap ("voice 씹힘"). Bounded by
  /// [_prebufferFlush] so a short utterance is never held back forever.
  static const int _prebufferBytes = _playbackSampleRate * 2 * 120 ~/ 1000;
  static const Duration _prebufferFlush = Duration(milliseconds: 90);

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

  /// Bytes currently queued (unfed).
  int get _queueLen => _pcmQueue.length - _pcmHead;

  /// Last feed mode (true=silence, false=audio, null=unset), so [_log] reports
  /// only audio↔silence transitions instead of spamming every feed callback.
  bool? _lastFeedSilent;

  /// True while a feed callback is mid-flight (awaiting the native `feed`), so
  /// [_teardown] can wait for it before `release()` — a fresh call's `setup()`
  /// must not race a feed running against the old (releasing) engine.
  bool _feeding = false;

  /// True once the jitter prebuffer has filled and real audio is draining. Reset
  /// between beaver turns (so each turn re-buffers a small cushion), but NOT on a
  /// mid-turn starve, so resumed audio plays instantly without a re-buffer gap.
  bool _playing = false;

  /// Bounded flush for the prebuffer: if audio is queued but stays below
  /// [_prebufferBytes], start playing anyway so a short utterance never stalls.
  Timer? _prebufferFlushTimer;

  /// Dev-only pipeline log (compiled out of release builds via [kDebugMode]).
  void _log(String msg) {
    if (kDebugMode) debugPrint('[call] $msg');
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

  /// Count of mic frames actually forwarded to the socket (dev-log heartbeat).
  int _micFramesSent = 0;

  /// True while the beaver is speaking (turn open and/or audio still playing).
  /// While true, mic PCM is dropped (not sent to the socket).
  bool _beaverSpeaking = false;

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

  /// Starts a live call with the given [characterId].
  ///
  /// Re-entry safe (§8-1): returns immediately when already starting or when the
  /// phase is connecting/inCall/ending; otherwise runs [_teardown] first so any
  /// stale socket/recorder/player is closed before a fresh connection opens.
  /// After the socket opens it sends `{type:"start", character_id}` once, which
  /// triggers the server's automatic opening line (§8-3).
  Future<void> start(int characterId) async {
    if (_starting) return;
    final phase = state.phase;
    if (phase == CallPhase.connecting ||
        phase == CallPhase.inCall ||
        phase == CallPhase.ending) {
      return;
    }
    _starting = true;
    try {
      // teardown-first-then-connect → two sockets are structurally impossible.
      await _teardown();
      // Claim this start's generation AFTER the initial teardown. A hangUp() at
      // any await below bumps _gen, so `_stale(myGen)` aborts this start cleanly.
      final myGen = ++_gen;
      state = const CallState(phase: CallPhase.connecting);

      final token =
          Supabase.instance.client.auth.currentSession?.accessToken;
      if (token == null || token.isEmpty) {
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: '로그인이 필요합니다.',
        );
        return;
      }

      // Playback is device-only (flutter_pcm_sound has no web support). Guard so
      // entering a call on web fails cleanly instead of crashing on a missing
      // platform channel. Mic/WS aren't opened either — the call is a no-op here.
      if (kIsWeb) {
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: '웹에서는 음성 통화를 지원하지 않습니다. 앱에서 이용해 주세요.',
        );
        return;
      }

      // 잠금화면에서 예약전화를 받으면 accept 직후엔 아직 잠금 해제/화면 전환 전이라,
      // 마이크·오디오가 제대로 잡히지 않는다. 앱이 실제로 포그라운드(통화 화면)로 올라온
      // 뒤에 오디오 파이프라인을 시작한다. 일반 경로(홈→전화하기)는 이미 resumed라 즉시 통과.
      await _awaitForeground();
      if (myGen != _gen) return _abortStart();

      // 마이크(음성) 권한 확인·요청. 전화가 올 때마다 통화는 이 start()를 타므로 매 통화
      // 시작 시 항상 체크한다. 이미 허용돼 있으면 즉시 통과하고, 아니면 시스템 권한 팝업을
      // 띄운다. 거부 상태면 마이크 없이는 대화가 불가하므로 통화를 시작하지 않고 안내한다.
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: micStatus.isPermanentlyDenied
              ? '마이크 권한이 꺼져 있어요. 설정 > 앱 권한에서 마이크를 허용해 주세요.'
              : '마이크 권한이 필요해요. 통화하려면 마이크를 허용해 주세요.',
        );
        return;
      }
      if (myGen != _gen) return _abortStart();

      // Open native gapless PCM playback at the server's 24kHz (no upsampling).
      // The feed callback pulls from [_pcmQueue]; silence keep-alive prevents the
      // underflow-churn stall that cut audio out after ~1 minute.
      _pcmQueue = <int>[];
      _pcmHead = 0;
      _pcmActive = false;
      _playing = false;
      await FlutterPcmSound.setLogLevel(LogLevel.error);
      await FlutterPcmSound.setup(
        sampleRate: _playbackSampleRate,
        channelCount: _playbackChannels,
      );
      _pcmSetup = true;
      await FlutterPcmSound.setFeedThreshold(_feedThresholdFrames);
      FlutterPcmSound.setFeedCallback(_onFeed);
      _pcmActive = true;
      _lastFeedSilent = null;
      _envQueue.clear();
      _startEnvelope();
      // Kick the pull loop directly instead of FlutterPcmSound.start().
      // start() only kicks when the plugin's *static* `_needsStart` flag is true,
      // and that flag is NEVER reset by release()/setup(): the first call feeds
      // audio → sets it false → it stays false, so on the 2nd call start() no-ops
      // and playback never begins (the "재통화 시 음성 안 나옴" bug). Priming the
      // feed callback ourselves (a silence frame starts the native OnFeedSamples
      // loop) is independent of that stale flag and works on every call.
      unawaited(_onFeed(0));
      _log('playback started @ ${_playbackSampleRate}Hz (gapless PCM)');

      // Capture the baseline max call_id *before* the socket creates this call's
      // row, so a manual hang-up (which gets no `call_ended`) can recover the new
      // id later by polling for an id greater than this. Best-effort: a failure
      // here must never block the call from starting.
      try {
        final base = await ref.read(normalcallRepositoryProvider).latestCallId();
        state = state.copyWith(baselineCallId: base);
      } catch (_) {
        // Leave baselineCallId null; recovery degrades to "newest id".
      }

      // Aborted while setting up playback / fetching the baseline id → don't open
      // a socket or mic for a call the user already hung up.
      if (myGen != _gen) return _abortStart();

      // Connect the WebSocket.
      _expectClose = false;
      final url = normalcallWsUrl(token);
      final channel = WebSocketChannel.connect(Uri.parse(url));
      _channel = channel;
      _wsSub = channel.stream.listen(
        _onWsData,
        onDone: _onWsDone,
        onError: _onWsError,
        cancelOnError: false,
      );

      // §8-3: trigger the server's auto opening line (no button).
      _send({'type': 'start', 'character_id': characterId});

      // Keepalive so an idle proxy/LB doesn't drop the socket mid-call.
      _startKeepalive();

      // Start streaming the mic to the server.
      await _startMic();
      if (myGen != _gen) return _abortStart();
    } catch (e) {
      state = state.copyWith(
        phase: CallPhase.error,
        errorMsg: '통화를 시작할 수 없습니다.',
      );
      await _teardown();
    } finally {
      _starting = false;
    }
  }

  /// Aborts an in-flight [start] whose generation was superseded by a [hangUp]:
  /// tears down anything already opened. The phase was already set by the
  /// hangUp, so [_teardown] preserves it.
  Future<void> _abortStart() async {
    _log('start aborted — superseded by hang up');
    await _teardown();
  }

  /// User-initiated hang up: closes the socket (the server finalizes the call in
  /// its `finally`) and tears the pipeline down (§8-2).
  Future<void> hangUp() async {
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
      // Half-duplex gate: while the beaver is speaking (or its audio tail is
      // still decaying), DROP the frame so the AI's voice picked up by the mic
      // is never echoed back to the server's STT (which caused the self-talk
      // loop on speakerphone). The recorder keeps running so the audio
      // session / AEC stays stable; we only skip forwarding.
      if (_beaverSpeaking) return;
      final ch = _channel;
      if (ch != null) {
        ch.sink.add(bytes);
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
          enableVoiceProcessing: true,
          enableEchoCancellation: true,
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
      _feedPlayer(data);
    } else if (data is List<int>) {
      _feedPlayer(Uint8List.fromList(data));
    }
  }

  /// Enqueues an inbound PCM24k chunk onto [_pcmQueue]. The plugin's feed
  /// callback ([_onFeed]) drains it; here we only gate the mic, reset the
  /// closing-drain stability window, and cap the queue (resync).
  void _feedPlayer(Uint8List chunk) {
    if (!_pcmActive) return;
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

    _pcmQueue.addAll(chunk);

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

  /// flutter_pcm_sound feed callback: invoked when buffered frames fall below
  /// the threshold (or hit zero). Pulls up to [_feedChunkBytes] of real audio
  /// from [_pcmQueue]; when empty, feeds a short silence so the engine never
  /// starves into a stuck underflow (the fix for the ~1-min cutout).
  Future<void> _onFeed(int remainingFrames) async {
    if (!_pcmActive) return;
    _feeding = true;
    try {
      final avail = _queueLen;
      final whole = avail - (avail & 1); // even bytes = whole Int16 samples
      // Jitter prebuffer: at a turn start, hold real audio (feed silence) until a
      // small cushion is buffered so brief jitter can't starve mid-word. Bypassed
      // once playing, while closing (must drain), or when the flush timer fires.
      final ready = _playing || _drainScheduled || whole >= _prebufferBytes;
      if (whole >= 2 && ready) {
        if (!_playing) {
          _playing = true;
          _prebufferFlushTimer?.cancel();
          _prebufferFlushTimer = null;
        }
        if (_lastFeedSilent != false) {
          _log('feed AUDIO (queue ${avail}B)');
          _lastFeedSilent = false;
        }
        final take = whole < _feedChunkBytes ? whole : _feedChunkBytes;
        await FlutterPcmSound.feed(_takeArray(take));
      } else {
        if (whole >= 2) {
          // Buffering the prebuffer cushion → arm a bounded flush so a short
          // utterance (never reaching the cushion) still plays out.
          _prebufferFlushTimer ??= Timer(_prebufferFlush, () {
            _prebufferFlushTimer = null;
            _playing = true; // next feed drains whatever is queued
          });
        } else {
          // Queue genuinely drained. Between turns (beaver not speaking) require a
          // fresh prebuffer next turn; mid-turn keep _playing so resumed audio is
          // instant (no re-buffer gap).
          if (!_beaverSpeaking) _playing = false;
          if (_lastFeedSilent != true) {
            _log('feed silence — queue empty'
                '${_beaverSpeaking ? ' WHILE beaver speaking (starved!)' : ''}');
            _lastFeedSilent = true;
          }
          // Idle-ungate countdown (covers a missed turn_end so the mic can't
          // deadlock). Armed once per empty period; fresh audio cancels it.
          _armIdleUngate();
        }
        await FlutterPcmSound.feed(
          PcmArrayInt16.zeros(count: _silenceFrames),
        );
      }
    } catch (_) {
      // Engine released mid-feed (teardown) → ignore.
    } finally {
      _feeding = false;
    }
    // Real audio drained → maybe re-open the mic / finish the closing drain.
    if (_queueLen < 2) {
      _tryUngateMic();
      _maybeFinishClosing();
    }
  }

  /// Removes [byteCount] bytes from the front of [_pcmQueue] as a
  /// [PcmArrayInt16]. The server's little-endian PCM16 passes straight through:
  /// mobile targets are little-endian (host), which is what the native player
  /// expects.
  PcmArrayInt16 _takeArray(int byteCount) {
    final out = Uint8List(byteCount);
    out.setRange(0, byteCount, _pcmQueue, _pcmHead);
    _pcmHead += byteCount;
    _maybeCompact();
    // Drive the avatar mouth from the samples about to play (matches what's
    // heard; the queue buffers ahead so arrival-time RMS would lead the audio).
    _updateAvatarLevel(out, byteCount);
    return PcmArrayInt16(bytes: out.buffer.asByteData());
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
      i = end;
    }
    // Runaway guard: never let the envelope outgrow ~3s of audio.
    final cap = 3000 ~/ _envStepMs;
    if (_envQueue.length > cap) {
      _envQueue.removeRange(0, _envQueue.length - cap);
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
  /// Holds [_envLeadMs] of it back to offset the player's buffer.
  void _startEnvelope() {
    _envTimer?.cancel();
    final lead = _envLeadMs ~/ _envStepMs;
    _envTimer = Timer.periodic(
      const Duration(milliseconds: _envStepMs),
      (_) {
        if (_envQueue.length > lead) {
          avatarLevel.value = _envQueue.removeAt(0);
        } else if (!_beaverSpeaking) {
          avatarLevel.value = 0.0;
        } else {
          // Brief gap mid-turn: ease shut rather than snapping.
          avatarLevel.value = avatarLevel.value * 0.6;
        }
      },
    );
  }

  /// Classifies the beaver's (partial) line into an emotion code (0 neutral) by
  /// counting lexicon hits. Cheap keyword scan; short lines. Ties/none → the
  /// highest-count wins, 0 when nothing matches.
  int _classifyEmotion(String line) {
    if (line.isEmpty) return 0;
    final t = line.toLowerCase();
    var best = 0;
    var bestCount = 0;
    _emotionLexicon.forEach((code, words) {
      var c = 0;
      for (final w in words) {
        if (t.contains(w)) c++;
      }
      if (c > bestCount) {
        bestCount = c;
        best = code;
      }
    });
    return best;
  }

  /// Compacts [_pcmQueue] once the consumed prefix grows large, so the backing
  /// list doesn't grow unbounded across a long call.
  void _maybeCompact() {
    if (_pcmHead > 65536 && _pcmHead * 2 > _pcmQueue.length) {
      _pcmQueue = _pcmQueue.sublist(_pcmHead);
      _pcmHead = 0;
    }
  }

  // ── Half-duplex mic gating helpers ─────────────────────────────────────────

  /// Engages the mic gate for a new/ongoing beaver turn. Cancels any pending
  /// ungate (hangover/safety) since the beaver is speaking again.
  void _gateMic() {
    if (!_beaverSpeaking) _log('mic GATED — beaver speaking (your mic paused)');
    _micGateTimer?.cancel();
    _micGateTimer = null;
    _turnEnded = false;
    _beaverSpeaking = true;
    avatarSpeaking.value = true;
  }

  /// Attempts to clear the mic gate. Requires BOTH the turn to have ended AND
  /// the playback queue to be empty, then waits a [_micHangover] tail (so the
  /// speaker's decaying audio isn't recaptured) before actually ungating.
  void _tryUngateMic() {
    if (!_beaverSpeaking) return;
    if (!_turnEnded) return;
    if (_queueLen >= 2) return;
    // Start (or restart) the hangover; if a new turn_start/audio arrives first,
    // [_gateMic] cancels this timer and keeps the gate closed.
    _micGateTimer?.cancel();
    _micGateTimer = Timer(_micHangover, () {
      _micGateTimer = null;
      _gateSafetyTimer?.cancel();
      _gateSafetyTimer = null;
      _beaverSpeaking = false;
      avatarSpeaking.value = false;
      avatarLevel.value = 0.0;
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
    if (!_beaverSpeaking) return;
    if (_gateSafetyTimer != null) return; // already counting this empty period
    _gateSafetyTimer = Timer(_gateSafetyWindow, () {
      _gateSafetyTimer = null;
      if (_beaverSpeaking && _queueLen < 2) {
        _micGateTimer?.cancel();
        _micGateTimer = null;
        _beaverSpeaking = false;
        avatarSpeaking.value = false;
        avatarLevel.value = 0.0;
        _log('mic OPEN — your turn (idle drained)');
      }
    });
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
      case 'turn_start':
        if (state.phase == CallPhase.connecting) {
          state = state.copyWith(phase: CallPhase.inCall);
          _startElapsedTimer();
        }
        // New beaver turn → start a fresh subtitle line. The server streams the
        // line token-by-token via `output_transcript`, so the line must be
        // cleared here (not overwritten per token) and then accumulated below.
        // Also clear any stale hint: a new turn means the prior question is
        // answered (matches the server "new question cancels previous").
        state = state.copyWith(beaverSubtitle: '', hint: null);
        // New line → reset the avatar expression to neutral; it re-classifies as
        // the line streams in below.
        avatarEmotion.value = 0;
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
            // React to what the beaver says: a detected emotion sticks until the
            // next turn resets it (avoids flicker on neutral tokens).
            final emo = _classifyEmotion(line);
            if (emo != 0) avatarEmotion.value = emo;
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
      case 'call_ended':
        final id = msg['call_id'];
        // Server-initiated close is expected; the socket's onDone must not be
        // treated as an unexpected drop.
        _expectClose = true;
        state = state.copyWith(
          phase: CallPhase.ending,
          callId: id?.toString(),
          hint: null,
        );
        _log('call_ended id=$id → draining closing line');
        _scheduleClosingDrain();
      case 'error':
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: (msg['message'] as String?) ?? '통화 중 오류가 발생했습니다.',
        );
        unawaited(_teardown(keepError: true));
      case 'hint':
        // Dynamic example-answer hint for the beaver's question turn. Additive:
        // unknown to older builds (harmlessly ignored). Replaces any prior hint.
        final hint = HintData.fromJson(msg);
        if (hint != null) state = state.copyWith(hint: hint);
      case 'teaching_plan':
        final raw = msg['items'];
        if (raw is List) {
          final items = raw
              .whereType<Map<String, dynamic>>()
              .map(TeachingItem.fromJson)
              .whereType<TeachingItem>()
              .toList(growable: false);
          state = state.copyWith(teachingPlan: items);
        }
      case 'pong':
        break;
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
    // Fallback: finish after a short delay regardless (e.g. no trailing audio).
    // Stored + cancelled in [_teardown]/[_finishClosing] so a stray timer from a
    // finished call can't fire against a *later* call and end it early.
    _closingFallbackTimer?.cancel();
    _closingFallbackTimer = Timer(
      const Duration(seconds: 3),
      _forceFinishClosing,
    );
  }

  /// While a close is pending, completes it once the queue has been empty for a
  /// short quiet window. Fresh audio (in [_feedPlayer]) cancels the timer, so a
  /// still-arriving closing line is never cut off.
  void _maybeFinishClosing() {
    if (!_drainScheduled) return;
    if (_queueLen >= 2) return; // still real audio queued
    if (_closingStableTimer != null) return; // already waiting out the tail
    _closingStableTimer = Timer(_closingStableDelay, () {
      _closingStableTimer = null;
      if (!_drainScheduled) return;
      if (_queueLen >= 2) return; // audio came back; a later drain retries
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
        errorMsg: '연결에 실패했습니다. 다시 시도해 주세요.',
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
      errorMsg: '네트워크 오류가 발생했습니다.',
    );
    unawaited(_teardown(keepError: true));
  }

  /// Encodes and sends a control JSON frame if the socket is open.
  void _send(Map<String, dynamic> msg) {
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
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    _keepaliveTimer?.cancel();
    _keepaliveTimer = null;
    _envTimer?.cancel();
    _envTimer = null;
    _envQueue.clear();
    _drainScheduled = false;
    _closingStableTimer?.cancel();
    _closingStableTimer = null;
    _closingFallbackTimer?.cancel();
    _closingFallbackTimer = null;

    // Reset the half-duplex mic gate + its timers so a new call starts ungated.
    _micGateTimer?.cancel();
    _micGateTimer = null;
    _gateSafetyTimer?.cancel();
    _gateSafetyTimer = null;
    _beaverSpeaking = false;
    avatarSpeaking.value = false;
    avatarLevel.value = 0.0;
    avatarEmotion.value = 0;
    avatarShape.value = 0.0;
    _turnEnded = false;
    _micFramesSent = 0;

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

    // Stop native PCM playback: disable the feed callback first so no feed runs
    // against a released engine, then release and clear the queue.
    _pcmActive = false;
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
    _pcmQueue = <int>[];
    _pcmHead = 0;
    _lastFeedSilent = null;

    // Close the socket.
    await _wsSub?.cancel();
    _wsSub = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;

    if (!keepError) {
      // Preserve callId/ended state set by callers; only reset a live phase.
      if (state.phase != CallPhase.ended) {
        state = const CallState();
      }
    }
  }
}
