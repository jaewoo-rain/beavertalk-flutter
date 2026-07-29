import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, IOSink; // TEMP DEBUG: 수신 PCM 덤프
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart' // TEMP DEBUG
    show getExternalStorageDirectory;

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb;
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

  /// TEMP DEBUG — skip opening the mic recorder entirely.
  ///
  /// Isolates Android's voice-communication audio processing. The recorder is
  /// normally held open for the whole call *on purpose* (see [_startMic]) so the
  /// session/AEC stays stable, which also means the platform runs in
  /// MODE_IN_COMMUNICATION with AEC/NS/AGC applied for the entire call. If the
  /// beaver's voice stops breaking up with no recorder open, that processing —
  /// not our buffering — is what's chopping it. The call still works one-way:
  /// the server speaks first, we just can't answer.
  static const bool _kDebugSkipMic = false;

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
  static const int _prebufferBytes = _playbackSampleRate * 2 * 900 ~/ 1000;

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
  int _cushionBytes = _prebufferBytes;

  /// Growth per starved turn (~300ms), ceiling (~2.5s), and decay per clean turn
  /// (~150ms). Growth outpaces decay so the cushion settles above the deficit
  /// instead of oscillating through it.
  static const int _cushionStepBytes = _playbackSampleRate * 2 * 300 ~/ 1000;
  static const int _cushionMaxBytes = _playbackSampleRate * 2 * 2500 ~/ 1000;
  static const int _cushionDecayBytes = _playbackSampleRate * 2 * 150 ~/ 1000;

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

  /// TEMP DEBUG — raw sink for every inbound PCM chunk, byte-for-byte as it
  /// arrived. Playing this back settles whether the choppiness is already in what
  /// the server sent (nothing on the client can fix that) or is introduced by our
  /// own playback. Debug builds only; remove once the question is answered.
  IOSink? _dumpSink;

  /// Off by default: the dump writes every received byte to external storage for
  /// the whole call, which has no business running in a normal debug session.
  /// Flip to true only while investigating what the server actually sent — and
  /// note the trap it already set once: the file concatenates received bytes, so
  /// timing holes vanish and it always sounds smooth. It answers "is the audio
  /// content intact", never "did it arrive on time".
  static const bool _kDebugDumpRxPcm = false;

  /// TEMP DEBUG — opens the dump file for this call. Best-effort: a failure here
  /// must never affect the call.
  Future<void> _openDump() async {
    if (!_kDebugDumpRxPcm) return;
    if (!kDebugMode || kIsWeb) return;
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) return;
      final file = File('${dir.path}/beaver_rx.pcm');
      _dumpSink = file.openWrite();
      _log('PCM DUMP → ${file.path}');
    } catch (e) {
      _log('PCM DUMP open failed: $e');
    }
  }

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
      _pcmQueue = Uint8List(_pcmQueueInitialBytes);
      _pcmHead = 0;
      _pcmTail = 0;
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
      _startEventLoopProbe(); // [계측] 청크 갭의 원인(서버 공백 vs 루프 블록) 판별용
      _startInflateLog(); // [계측] 무음 주입으로 스트림이 부풀어 백로그가 자라는지 판별용
      // Drive playback from Dart's own clock. Note this also sidesteps
      // FlutterPcmSound.start(), which only kicks when the plugin's *static*
      // `_needsStart` flag is true — and that flag is NEVER reset by
      // release()/setup(): the first call feeds audio → sets it false → it stays
      // false, so on the 2nd call start() no-ops and playback never begins (the
      // "재통화 시 음성 안 나옴" bug). Pumping ourselves is independent of it.
      _startPushFeed();
      unawaited(_pump()); // don't wait a tick to open the stream
      _logAnchorMs = DateTime.now().millisecondsSinceEpoch;
      _starveAtMs = null;
      // The cushion is per-call state: a rough previous call must not tax this one.
      _cushionBytes = _prebufferBytes;
      _turnStarved = false;
      _resumeFlushed = false;
      await _openDump(); // TEMP DEBUG
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
      if (!_kDebugSkipMic) {
        await _startMic();
      } else {
        _log('TEMP DEBUG: mic skipped — no recorder, no AEC/MODE_IN_COMMUNICATION');
      }
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
          // Restored: turning these off made no difference to the break-up, so
          // the platform's voice processing is not what chews up the output.
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
    _inflateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final elapsedMs = DateTime.now().millisecondsSinceEpoch - _callT0Ms;
      final fedBytes = _fedAudBytes + _fedSilFrames * 2;
      final pct = elapsedMs > 0 ? (fedBytes / 48000.0 * 1000 / elapsedMs * 100) : 0;
      _log('INFLATE: elapsed ${(elapsedMs / 1000).toStringAsFixed(1)}s, '
          'rx ${_sec(_rxBytesTotal)}s, fedAud ${_sec(_fedAudBytes)}s, '
          'fedSil ${_sec(_fedSilFrames * 2)}s '
          '(speaking ${_sec(_fedSilSpeakFrames * 2)}s, prebuf ${_sec(_fedSilPrebufFrames * 2)}s), '
          'fed/elapsed ${pct.toStringAsFixed(0)}%, queue ${_queueLen}B');
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
    if (!_pcmActive) return;
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

  void _feedPlayerBody(Uint8List chunk) {
    if (!_pcmActive) return;
    // Ground truth for "did the server go quiet mid-utterance": the gap between
    // inbound chunks. The playback-side starve clock can't answer that — a long
    // enough hole trips the idle-ungate, `_beaverSpeaking` flips to false, and the
    // resumption then looks like a brand-new turn. Measured here (before
    // [_gateMic] clears `_turnEnded`) it survives all of that.
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final prevChunkMs = _lastChunkAtMs;
    if (prevChunkMs != null && !_turnEnded && nowMs - prevChunkMs >= 250) {
      _log('SERVER GAP ${nowMs - prevChunkMs}ms mid-utterance '
          '(mic was ${_beaverSpeaking ? "closed" : "OPEN"})');
    }
    _lastChunkAtMs = nowMs;
    _dumpSink?.add(chunk); // TEMP DEBUG: exactly what the server sent
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
              '${_engineLevelFrames * 1000 ~/ _playbackSampleRate}ms)');
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
          final sentAtMs = DateTime.now().millisecondsSinceEpoch;
          final reported = await FlutterPcmSound.feed(_takeArray(take));
          // Android reports its depth; elsewhere fall back to our own arithmetic
          // so iOS/web keep working unchanged.
          _anchorEngine(reported ?? (level + take ~/ 2), sentAtMs);
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
          if (!_beaverSpeaking) _playing = false;
          // Only a mid-utterance drain is a glitch; a drained queue between turns
          // is normal, so don't start the stall clock for it.
          if (_beaverSpeaking) {
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
            _log('feed silence — queue empty'
                '${_beaverSpeaking ? ' WHILE beaver speaking (starved!)' : ''}');
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
          } else if (_beaverSpeaking) {
            _fedSilSpeakFrames += silFrames;
          }
          final sentAtMs = DateTime.now().millisecondsSinceEpoch;
          final reported = await FlutterPcmSound.feed(
            PcmArrayInt16.zeros(count: silFrames),
          );
          _anchorEngine(reported ?? (level + silFrames), sentAtMs);
        }
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
    return PcmArrayInt16(bytes: out.buffer.asByteData());
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
    if (!_beaverSpeaking) {
      _log('mic GATED — beaver speaking (your mic paused)');
      _turnStarved = false; // fresh turn: it hasn't starved yet
    }
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
      _beaverSpeaking = false;
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
    if (!_beaverSpeaking) return;
    if (_gateSafetyTimer != null) return; // already counting this empty period
    _gateSafetyTimer = Timer(_gateSafetyWindow, () {
      _gateSafetyTimer = null;
      if (_beaverSpeaking && _queueLen < 2) {
        _micGateTimer?.cancel();
        _micGateTimer = null;
        _beaverSpeaking = false;
        _decayCushion();
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
    // TEMP DEBUG: close the dump so the file is complete and pullable.
    final dump = _dumpSink;
    _dumpSink = null;
    if (dump != null) {
      try {
        await dump.flush();
        await dump.close();
        _log('PCM DUMP closed');
      } catch (_) {}
    }

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

    if (!keepError) {
      // Preserve callId/ended state set by callers; only reset a live phase.
      if (state.phase != CallPhase.ended) {
        state = const CallState();
      }
    }
  }
}
