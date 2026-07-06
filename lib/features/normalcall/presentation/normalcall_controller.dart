import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb;
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding;
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/network/ws_url.dart';
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

  /// Returns a copy with the given fields replaced.
  CallState copyWith({
    CallPhase? phase,
    int? elapsedSec,
    String? callId,
    int? baselineCallId,
    String? beaverSubtitle,
    String? userSubtitle,
    String? errorMsg,
  }) {
    return CallState(
      phase: phase ?? this.phase,
      elapsedSec: elapsedSec ?? this.elapsedSec,
      callId: callId ?? this.callId,
      baselineCallId: baselineCallId ?? this.baselineCallId,
      beaverSubtitle: beaverSubtitle ?? this.beaverSubtitle,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      errorMsg: errorMsg ?? this.errorMsg,
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

  /// Dev-only pipeline log (compiled out of release builds via [kDebugMode]).
  void _log(String msg) {
    if (kDebugMode) debugPrint('[call] $msg');
  }

  Timer? _elapsedTimer;

  /// Re-entry guard for [start] (§8-1).
  bool _starting = false;

  /// Set after `call_ended` while draining the beaver's closing line before
  /// sending `playback_done` (§8-4).
  bool _drainScheduled = false;

  /// Stability timer for the closing drain: the queue must stay empty for a
  /// short window (no new audio) before the close completes, so the closing
  /// line isn't cut off. Reset whenever fresh audio arrives.
  Timer? _closingStableTimer;

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

      // Open native gapless PCM playback at the server's 24kHz (no upsampling).
      // The feed callback pulls from [_pcmQueue]; silence keep-alive prevents the
      // underflow-churn stall that cut audio out after ~1 minute.
      _pcmQueue = <int>[];
      _pcmHead = 0;
      _pcmActive = false;
      await FlutterPcmSound.setLogLevel(LogLevel.error);
      await FlutterPcmSound.setup(
        sampleRate: _playbackSampleRate,
        channelCount: _playbackChannels,
      );
      _pcmSetup = true;
      await FlutterPcmSound.setFeedThreshold(_feedThresholdFrames);
      FlutterPcmSound.setFeedCallback(_onFeed);
      _pcmActive = true;
      // Kicks the first feed callback (queue empty → silence) to start the loop.
      FlutterPcmSound.start();
      _lastFeedSilent = null;
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

      // Connect the WebSocket.
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

      // Start streaming the mic to the server.
      await _startMic();
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

  /// User-initiated hang up: closes the socket (the server finalizes the call in
  /// its `finally`) and tears the pipeline down (§8-2).
  Future<void> hangUp() async {
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
    final avail = _queueLen;
    final whole = avail - (avail & 1); // even bytes = whole Int16 samples
    try {
      if (whole >= 2) {
        if (_lastFeedSilent != false) {
          _log('feed AUDIO (queue ${avail}B)');
          _lastFeedSilent = false;
        }
        final take = whole < _feedChunkBytes ? whole : _feedChunkBytes;
        await FlutterPcmSound.feed(_takeArray(take));
      } else {
        if (_lastFeedSilent != true) {
          _log('feed silence — queue empty'
              '${_beaverSpeaking ? ' WHILE beaver speaking (starved!)' : ''}');
          _lastFeedSilent = true;
        }
        // Queue genuinely drained while gated → start the idle-ungate countdown
        // (covers a missed turn_end so the mic can't deadlock). Armed at most
        // once per empty period; fresh audio in [_feedPlayer] cancels it.
        _armIdleUngate();
        await FlutterPcmSound.feed(
          PcmArrayInt16.zeros(count: _silenceFrames),
        );
      }
    } catch (_) {
      // Engine released mid-feed (teardown) → ignore.
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
    return PcmArrayInt16(bytes: out.buffer.asByteData());
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
        state = state.copyWith(beaverSubtitle: '');
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
            state =
                state.copyWith(beaverSubtitle: state.beaverSubtitle + delta);
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
        state = state.copyWith(
          phase: CallPhase.ending,
          callId: id?.toString(),
        );
        _log('call_ended id=$id → draining closing line');
        _scheduleClosingDrain();
      case 'error':
        state = state.copyWith(
          phase: CallPhase.error,
          errorMsg: (msg['message'] as String?) ?? '통화 중 오류가 발생했습니다.',
        );
        unawaited(_teardown(keepError: true));
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
    Timer(const Duration(seconds: 3), _forceFinishClosing);
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
    }
    // For inCall/ending, hangUp / call_ended already drives teardown.
  }

  /// Transport-level error (§8-6).
  void _onWsError(Object error) {
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

  /// Starts the UI elapsed-time ticker.
  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSec: state.elapsedSec + 1);
    });
  }

  /// Tears down all resources: recorder, player, socket, timers (§8-1/§8-2).
  ///
  /// When [keepError] is true the phase is left untouched (an error phase was
  /// already set by the caller); otherwise it resets to [CallPhase.idle].
  Future<void> _teardown({bool keepError = false}) async {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    _drainScheduled = false;
    _closingStableTimer?.cancel();
    _closingStableTimer = null;

    // Reset the half-duplex mic gate + its timers so a new call starts ungated.
    _micGateTimer?.cancel();
    _micGateTimer = null;
    _gateSafetyTimer?.cancel();
    _gateSafetyTimer = null;
    _beaverSpeaking = false;
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
    if (!kIsWeb && _pcmSetup) {
      try {
        FlutterPcmSound.setFeedCallback(null);
      } catch (_) {}
      try {
        await FlutterPcmSound.release();
      } catch (_) {}
    }
    _pcmSetup = false;
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
