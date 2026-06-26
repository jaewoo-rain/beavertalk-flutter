import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/network/ws_url.dart';

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

  /// Latest beaver (assistant) subtitle, updated by `output_transcript`.
  final String beaverSubtitle;

  /// Latest user subtitle, updated by `input_transcript`.
  final String userSubtitle;

  /// Human-readable error message when [phase] is [CallPhase.error].
  final String? errorMsg;

  /// Returns a copy with the given fields replaced.
  CallState copyWith({
    CallPhase? phase,
    int? elapsedSec,
    String? callId,
    String? beaverSubtitle,
    String? userSubtitle,
    String? errorMsg,
  }) {
    return CallState(
      phase: phase ?? this.phase,
      elapsedSec: elapsedSec ?? this.elapsedSec,
      callId: callId ?? this.callId,
      beaverSubtitle: beaverSubtitle ?? this.beaverSubtitle,
      userSubtitle: userSubtitle ?? this.userSubtitle,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

/// App-scoped singleton owning the live normalcall pipeline: a single WebSocket,
/// the mic recorder (PCM 16k → server), and the player (PCM 24k ← server).
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
  FlutterSoundPlayer? _player;
  StreamController<Uint8List>? _micController;
  StreamSubscription<Uint8List>? _micSub;

  /// FIFO queue of inbound PCM24k chunks awaiting playback. A single consumer
  /// ([_playbackLoop]) drains it, awaiting each feed for backpressure.
  StreamController<Uint8List>? _playbackController;
  StreamSubscription<void>? _playbackSub;

  /// Number of chunks queued but not yet accepted by the player. The closing
  /// drain waits for this to reach 0 *and* the player to underflow before
  /// sending `playback_done`.
  int _pendingChunks = 0;

  /// A dangling odd byte from the previous chunk's PCM16 parse, carried over to
  /// prepend to the next chunk so a 16-bit sample never splits across chunks.
  /// Reset on start/teardown so a new call never inherits a stray byte.
  int? _carryByte;

  Timer? _elapsedTimer;

  /// Re-entry guard for [start] (§8-1).
  bool _starting = false;

  /// Pending audio chunks awaiting the player's underflow signal, used to drain
  /// the beaver's closing line before sending `playback_done` (§8-4).
  bool _drainScheduled = false;

  /// Set when the player's underflow has fired while a close is pending. The
  /// close only completes once this is true *and* the queue is empty.
  bool _underflowSeen = false;

  // ── Half-duplex mic gating (echo-loop prevention) ──────────────────────────
  // On speakerphone the AI's voice bleeds into the mic, gets sent back, is
  // transcribed as user speech, and the AI replies to itself → infinite loop.
  // Echo cancellation alone isn't enough, so while the beaver is speaking we
  // DROP mic frames instead of forwarding them. This is intentionally
  // half-duplex: the user cannot barge-in / interrupt the AI mid-sentence — an
  // accepted tradeoff to kill the self-talk loop.

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

      // Open audio devices before networking so playback is ready for the
      // opening line.
      _player = FlutterSoundPlayer();
      await _player!.openPlayer();
      await _player!.startPlayerFromStream(
        codec: Codec.pcm16,
        interleaved: true,
        numChannels: 1,
        // Device AudioTrack runs natively at 48kHz. The server sends PCM16 mono
        // @ 24kHz, but flutter_sound's internal resampling is unreliable and
        // played 24k data at the native 48k rate → 2x-fast (chipmunk). So we
        // run the player at the native 48kHz and upsample each incoming chunk
        // 24k→48k ourselves (see [_upsample24to48]); the data rate then matches
        // the playback rate and no implicit resample happens.
        sampleRate: 48000,
        // Larger buffer gives the AudioTrack more headroom; the awaited
        // single-consumer feed loop below (backpressure) is the corruption fix.
        bufferSize: 16384,
        onBufferUnderflow: _onPlayerUnderflow,
      );
      // Start the single-consumer playback loop that applies backpressure.
      _startPlaybackLoop();

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
    await _teardown();
    state = CallState(phase: CallPhase.ended, callId: preservedCallId);
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
      if (ch != null) ch.sink.add(bytes);
    });

    final recorder = FlutterSoundRecorder();
    _recorder = recorder;
    await recorder.openRecorder();
    await recorder.startRecorder(
      toStream: controller.sink,
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
      enableVoiceProcessing: true,
      enableEchoCancellation: true,
    );
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

  /// Enqueues a PCM24k chunk for playback. The actual `feedUint8FromStream` is
  /// done by the single-consumer [_playbackLoop], which awaits each feed so we
  /// never overfeed the AudioTrack (the cause of "control block is corrupt").
  void _feedPlayer(Uint8List chunk) {
    final controller = _playbackController;
    if (controller == null || controller.isClosed) return;
    // Beaver audio is arriving → gate the mic (covers the opening greeting even
    // before/without a turn_start), and (re)arm the missed-turn_end safety.
    _gateMic();
    _armGateSafety();
    _pendingChunks++;
    controller.add(chunk);
  }

  /// Opens the playback queue and wires its single consumer ([_playbackLoop]).
  /// FIFO ordering is guaranteed by the single subscription.
  void _startPlaybackLoop() {
    final controller = StreamController<Uint8List>();
    _playbackController = controller;
    _pendingChunks = 0;
    _underflowSeen = false;
    _carryByte = null;
    // `asyncMap` processes one event at a time and waits for the returned
    // Future before pulling the next — exactly the backpressure we want.
    _playbackSub = controller.stream.asyncMap(_playChunk).listen(
      (_) {},
      cancelOnError: false,
    );
  }

  /// Feeds one chunk to the player and awaits acceptance (backpressure).
  /// Upsamples 24kHz→48kHz first so the data rate matches the native player
  /// rate. Decrements the pending counter; when the queue empties during a
  /// pending close, completes the drain.
  Future<void> _playChunk(Uint8List chunk) async {
    final player = _player;
    if (player != null) {
      try {
        final upsampled = _upsample24to48(chunk);
        if (upsampled.isNotEmpty) {
          await player.feedUint8FromStream(upsampled);
        }
      } catch (_) {
        // Player closing/closed mid-feed → drop the chunk.
      }
    }
    if (_pendingChunks > 0) _pendingChunks--;
    // Queue drained → maybe the beaver finished talking; try to re-open the mic.
    if (_pendingChunks == 0) _tryUngateMic();
    _maybeFinishClosing();
  }

  // ── Half-duplex mic gating helpers ─────────────────────────────────────────

  /// Engages the mic gate for a new/ongoing beaver turn. Cancels any pending
  /// ungate (hangover/safety) since the beaver is speaking again.
  void _gateMic() {
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
    if (_pendingChunks > 0) return;
    // Start (or restart) the hangover; if a new turn_start/audio arrives first,
    // [_gateMic] cancels this timer and keeps the gate closed.
    _micGateTimer?.cancel();
    _micGateTimer = Timer(_micHangover, () {
      _micGateTimer = null;
      _gateSafetyTimer?.cancel();
      _gateSafetyTimer = null;
      _beaverSpeaking = false;
    });
  }

  /// (Re)arms the missed-`turn_end` safety: if no new audio arrives and the
  /// queue is empty for [_gateSafetyWindow], assume turn_end was missed and
  /// ungate so the mic can't deadlock. Reset on every inbound audio chunk.
  void _armGateSafety() {
    _gateSafetyTimer?.cancel();
    _gateSafetyTimer = Timer(_gateSafetyWindow, () {
      _gateSafetyTimer = null;
      if (_beaverSpeaking && _pendingChunks == 0) {
        _micGateTimer?.cancel();
        _micGateTimer = null;
        _beaverSpeaking = false;
      }
    });
  }

  /// Upsamples a PCM16 mono chunk from 24kHz to 48kHz (2x) with linear
  /// interpolation, returning little-endian Int16 bytes ready to feed.
  ///
  /// Byte math:
  /// - Prepend any [_carryByte] left over from the previous chunk, then parse
  ///   the bytes as little-endian Int16 samples. If the resulting length is odd,
  ///   the final byte can't form a full sample → stash it in [_carryByte] for
  ///   the next chunk (samples never split across chunks).
  /// - For N input samples, emit 2N output samples: out[2i] = s[i];
  ///   out[2i+1] = (s[i] + s[i+1]) / 2, and the very last odd slot duplicates
  ///   the last sample (no successor to interpolate toward).
  /// - The (s[i]+s[i+1]) average of two int16s stays within int16 range, so no
  ///   clamping is needed; [Int16List] truncates the value to 16-bit anyway.
  Uint8List _upsample24to48(Uint8List chunk) {
    // Stitch the carried byte (if any) onto the front of this chunk.
    final Uint8List bytes;
    final carry = _carryByte;
    if (carry != null) {
      bytes = Uint8List(chunk.length + 1)
        ..[0] = carry
        ..setRange(1, chunk.length + 1, chunk);
      _carryByte = null;
    } else {
      bytes = chunk;
    }

    // Carry a dangling odd byte forward so 16-bit samples stay intact.
    var usableLen = bytes.length;
    if (usableLen.isOdd) {
      _carryByte = bytes[usableLen - 1];
      usableLen -= 1;
    }
    final sampleCount = usableLen ~/ 2;
    if (sampleCount == 0) return Uint8List(0);

    final inView = ByteData.sublistView(bytes, 0, usableLen);
    final input = Int16List(sampleCount);
    for (var i = 0; i < sampleCount; i++) {
      input[i] = inView.getInt16(i * 2, Endian.little);
    }

    // 2x output: original + interpolated sample for each input sample.
    final output = Int16List(sampleCount * 2);
    for (var i = 0; i < sampleCount; i++) {
      final cur = input[i];
      output[2 * i] = cur;
      final next = (i + 1 < sampleCount) ? input[i + 1] : cur;
      output[2 * i + 1] = (cur + next) ~/ 2;
    }

    // Re-serialize little-endian Int16.
    final out = Uint8List(output.length * 2);
    final outView = ByteData.sublistView(out);
    for (var i = 0; i < output.length; i++) {
      outView.setInt16(i * 2, output[i], Endian.little);
    }
    return out;
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
        // Beaver turn begins → gate the mic until the turn ends + audio drains.
        _gateMic();
      case 'output_transcript':
        state = state.copyWith(
          beaverSubtitle: (msg['text'] as String?) ?? state.beaverSubtitle,
        );
      case 'input_transcript':
        state = state.copyWith(
          userSubtitle: (msg['text'] as String?) ?? state.userSubtitle,
        );
      case 'turn_end':
        // Beaver turn finished generating. Clear the gate only once the
        // playback queue has also drained (+ hangover); see [_tryUngateMic].
        _turnEnded = true;
        _tryUngateMic();
      case 'call_ended':
        final id = msg['call_id'];
        state = state.copyWith(
          phase: CallPhase.ending,
          callId: id?.toString(),
        );
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

  /// After `call_ended`, waits for the player to drain the beaver's closing line
  /// before acknowledging and closing (§8-4). The drain completes only once the
  /// queue is empty (`_pendingChunks == 0`) *and* the player has underflowed.
  /// A fallback timer guards against the underflow never firing.
  void _scheduleClosingDrain() {
    if (_drainScheduled) return;
    _drainScheduled = true;
    // The queue may already be empty by now; re-check.
    _maybeFinishClosing();
    // Fallback: if underflow never fires (e.g. no trailing audio), finish after
    // a short delay so the call still closes regardless.
    Timer(const Duration(seconds: 3), _forceFinishClosing);
  }

  /// Player underflow callback — the AudioTrack ran out of queued audio.
  void _onPlayerUnderflow() {
    _underflowSeen = true;
    _maybeFinishClosing();
  }

  /// Completes the close iff a close is pending, the queue has been fully fed,
  /// and the player has underflowed (so the trailing audio actually played).
  void _maybeFinishClosing() {
    if (!_drainScheduled) return;
    if (_pendingChunks > 0) return;
    if (!_underflowSeen) return;
    unawaited(_finishClosing());
  }

  /// Fallback path: closes even if underflow never fired (e.g. no trailing
  /// audio or a stuck signal), but only after waiting out the fallback timer.
  void _forceFinishClosing() {
    if (!_drainScheduled) return;
    unawaited(_finishClosing());
  }

  /// Sends `playback_done`, closes the socket, and ends the session.
  Future<void> _finishClosing() async {
    if (!_drainScheduled) return;
    _drainScheduled = false;
    _send({'type': 'playback_done'});
    final preservedCallId = state.callId;
    await _teardown();
    state = CallState(phase: CallPhase.ended, callId: preservedCallId);
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
    _underflowSeen = false;

    // Reset the half-duplex mic gate + its timers so a new call starts ungated.
    _micGateTimer?.cancel();
    _micGateTimer = null;
    _gateSafetyTimer?.cancel();
    _gateSafetyTimer = null;
    _beaverSpeaking = false;
    _turnEnded = false;

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

    // Stop the playback queue/consumer BEFORE closing the player so no feed
    // runs against a closed player.
    await _playbackSub?.cancel();
    _playbackSub = null;
    await _playbackController?.close();
    _playbackController = null;
    _pendingChunks = 0;
    _carryByte = null;

    // Stop playback.
    try {
      await _player?.stopPlayer();
    } catch (_) {}
    try {
      await _player?.closePlayer();
    } catch (_) {}
    _player = null;

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
