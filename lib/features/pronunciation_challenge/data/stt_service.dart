import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/network/ws_url.dart';
import '../domain/speech_matcher.dart';
import 'curated_word_source.dart';

/// Lifecycle of the [SttService].
enum SttStatus {
  /// Never initialized.
  idle,

  /// Preparing (checking platform/auth before the first capture).
  loading,

  /// STT is usable but not capturing.
  ready,

  /// Capturing mic PCM, streaming it to the server, feeding transcripts back.
  listening,

  /// STT can't run here (web, no auth token, denied mic, connection failure) —
  /// callers must fall back to tap input.
  unavailable,
}

/// Server-side Korean speech recognition for the Pronunciation Challenge.
///
/// ## Server STT over a single mic PCM capture (was: on-device Vosk)
/// Recognition runs on the backend: the app opens **one** mic capture
/// (`FlutterSoundRecorder`, PCM16 mono 16 kHz — the exact pipeline the
/// normalcall feature uses) and streams the raw PCM to the STT WebSocket. The
/// server streams partial/final transcripts back, which drive the same
/// [SpeechMatcher] token-consumption + card-matching logic as before. There is
/// no model download and no iOS-unsupported plugin path.
///
/// ```
/// FlutterSoundRecorder.startRecorder(toStream, PCM16/16k)
///    └─→ WebSocket(/api/v1/pron/stt/ws) → {partial|final}.text → token match
/// ```
///
/// ## Protocol (see server `pron_stt.py` / `stt_session.py`)
/// * connect: `wss://…/api/v1/pron/stt/ws?token=<Supabase access token>`
/// * client → server: first text `{"type":"config","words":[…],"sampleRate":16000}`,
///   then binary PCM16 frames, optional `{"type":"stop"}`.
/// * server → client: `{"type":"ready"}` / `{"type":"partial","text":…}` /
///   `{"type":"final","text":…}` / `{"type":"error","error":…}` (all text JSON).
///
/// ## Graceful degradation
/// Every failure path (web, missing auth token, denied mic, connection/socket
/// error, server `error` event) resolves to [SttStatus.unavailable] and returns
/// `false` rather than throwing — the screen then keeps the tap-to-pass
/// fallback. The game is always playable, even offline or with the server down.
class SttService {
  /// Creates the service. Inject a [matcher] for tests.
  SttService({SpeechMatcher? matcher}) : _matcher = matcher ?? SpeechMatcher();

  /// PCM sample rate sent to the recorder and advertised in the STT `config`
  /// (server transcodes as needed). Matches normalcall's 16 kHz capture.
  static const int sampleRate = 16000;

  /// How long to wait for the WebSocket handshake before giving up (→ tap).
  static const Duration _connectTimeout = Duration(seconds: 6);

  final SpeechMatcher _matcher;

  /// Current lifecycle status (drives the loading panel + fallback decision).
  final ValueNotifier<SttStatus> status = ValueNotifier<SttStatus>(
    SttStatus.idle,
  );

  /// Smoothed 0..1 mic level for the on-screen indicator.
  final ValueNotifier<double> micLevel = ValueNotifier<double>(0);

  /// Wired to `ChallengeEngine.tryPassToken` by the screen: attempts to pass a
  /// card for a normalized spoken token, returning `true` on a match.
  bool Function(String token)? onToken;

  FlutterSoundRecorder? _recorder;
  StreamController<Uint8List>? _micController;
  StreamSubscription<Uint8List>? _micSub;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSub;

  /// True once we've asked the socket to close (stop/dispose), so its `onDone`
  /// isn't mistaken for an unexpected mid-round drop.
  bool _expectClose = false;

  bool _disposed = false;

  /// Guards concurrent [init] calls (e.g. a fast double tap on Start).
  Future<bool>? _initFuture;

  /// Whether STT is ready (or already listening).
  bool get isAvailable =>
      status.value == SttStatus.ready || status.value == SttStatus.listening;

  /// Lightweight readiness check (no model to download anymore). Returns `true`
  /// when STT can be attempted; `false` (with [status] == [SttStatus.unavailable])
  /// to signal the caller to use tap input. Never throws. The actual socket +
  /// mic are opened per round in [startListening].
  Future<bool> init() {
    final inFlight = _initFuture;
    if (inFlight != null) return inFlight;
    final future = _initInternal();
    _initFuture = future;
    future.whenComplete(() => _initFuture = null);
    return future;
  }

  Future<bool> _initInternal() async {
    if (_disposed) return false;
    // Web: no flutter_sound recorder — the screen falls back to tap.
    if (kIsWeb) {
      status.value = SttStatus.unavailable;
      return false;
    }
    status.value = SttStatus.loading;
    // Need a Supabase session to authenticate the STT socket; without one the
    // server closes with 1008, so degrade to tap up-front.
    final token = _authToken();
    if (token == null || token.isEmpty) {
      debugPrint('SttService.init: no auth token → tap fallback');
      status.value = SttStatus.unavailable;
      return false;
    }
    status.value = SttStatus.ready;
    return true;
  }

  /// Opens the STT socket and a single 16 kHz mono PCM capture feeding it.
  /// Returns `false` (→ tap fallback) if unavailable, the mic is denied, or the
  /// socket can't be established. Never throws.
  Future<bool> startListening() async {
    if (_disposed || kIsWeb) return false;
    if (status.value == SttStatus.unavailable) return false;
    // A previous round's socket/recorder may still be around (fast stop→start).
    await _closePipeline();
    _matcher.reset();

    final token = _authToken();
    if (token == null || token.isEmpty) {
      status.value = SttStatus.unavailable;
      return false;
    }

    // Mic permission (same gate as normalcall). Denied → tap fallback.
    try {
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        status.value = SttStatus.unavailable;
        return false;
      }
    } catch (e) {
      debugPrint('SttService: mic permission check failed → tap fallback: $e');
      status.value = SttStatus.unavailable;
      return false;
    }
    if (_disposed) return false;

    // Connect the STT WebSocket and wait for the handshake so a dead/unreachable
    // server degrades to tap *before* the round starts (rather than mid-round).
    _expectClose = false;
    WebSocketChannel? channel;
    try {
      channel = WebSocketChannel.connect(Uri.parse(pronSttWsUrl(token)));
      await channel.ready.timeout(_connectTimeout);
    } catch (e) {
      debugPrint('SttService: STT connect failed → tap fallback: $e');
      try {
        await channel?.sink.close();
      } catch (_) {}
      status.value = SttStatus.unavailable;
      return false;
    }
    if (_disposed) {
      try {
        await channel.sink.close();
      } catch (_) {}
      return false;
    }
    _channel = channel;
    _wsSub = channel.stream.listen(
      _onWsData,
      onError: _onWsError,
      onDone: _onWsDone,
      cancelOnError: false,
    );

    // First frame must be the config (words = game vocabulary as phrase hints).
    _send(<String, dynamic>{
      'type': 'config',
      'words': CuratedWordSource.words,
      'sampleRate': sampleRate,
    });

    // Start the mic capture (PCM16/16k) and stream it to the socket.
    try {
      await _startMic();
    } catch (e) {
      debugPrint('SttService.startListening: mic open failed → tap: $e');
      await _closePipeline();
      status.value = SttStatus.unavailable;
      return false;
    }
    if (_disposed) {
      await _closePipeline();
      return false;
    }
    status.value = SttStatus.listening;
    return true;
  }

  /// Stops the capture and closes the socket. Idempotent. Leaves [status] at
  /// [SttStatus.ready] (not [unavailable]) so a replay can re-arm STT.
  Future<void> stopListening() async {
    _expectClose = true;
    // Ask the server to finalize, then tear the pipeline down.
    _send(<String, dynamic>{'type': 'stop'});
    await _closePipeline();
    micLevel.value = 0;
    _matcher.reset();
    if (!_disposed && status.value == SttStatus.listening) {
      status.value = SttStatus.ready;
    }
  }

  /// Opens the recorder and pipes its PCM16/16k stream straight to the socket —
  /// the same capture normalcall uses (`FlutterSoundRecorder` → `toStream`).
  Future<void> _startMic() async {
    final controller = StreamController<Uint8List>();
    _micController = controller;
    _micSub = controller.stream.listen(
      _onPcm,
      onError: (Object e) => debugPrint('mic stream error: $e'),
    );
    final recorder = FlutterSoundRecorder();
    _recorder = recorder;
    await recorder.openRecorder();
    await recorder.startRecorder(
      toStream: controller.sink,
      codec: Codec.pcm16,
      sampleRate: sampleRate,
      numChannels: 1,
      enableVoiceProcessing: true,
      enableEchoCancellation: true,
    );
  }

  /// Forwards a mic PCM chunk to the socket and updates the on-screen level.
  void _onPcm(Uint8List data) {
    _updateMicLevel(data);
    final ch = _channel;
    if (ch == null) return;
    try {
      ch.sink.add(data);
    } catch (_) {
      // Socket already closing; ignore.
    }
  }

  /// Handles inbound WS frames. The server only sends text JSON (control +
  /// transcripts); any binary is ignored.
  void _onWsData(dynamic data) {
    if (data is String) _handleControl(data);
  }

  /// Parses and dispatches a server STT event.
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
      case 'ready':
        // STT stream is up; audio already flowing. Nothing to do.
        break;
      case 'partial':
        _onTranscript(msg['text'], isFinal: false);
      case 'final':
        _onTranscript(msg['text'], isFinal: true);
      case 'error':
        debugPrint('SttService: server error → tap fallback: ${msg['error']}');
        unawaited(_failListening());
      default:
        break;
    }
  }

  /// Feeds a partial/final transcript into the matcher (unchanged token logic).
  void _onTranscript(Object? raw, {required bool isFinal}) {
    final text = raw is String ? raw.trim() : '';
    if (text.isNotEmpty) {
      _matcher.feed(
        text,
        isFinal: isFinal,
        attempt: (String t) => onToken?.call(t) ?? false,
      );
    } else if (isFinal) {
      // Reset per-utterance bookkeeping on an empty final.
      _matcher.feed('', isFinal: true, attempt: (_) => false);
    }
  }

  /// Unexpected socket close mid-round → re-arm tap input.
  void _onWsDone() {
    if (_expectClose || _disposed) return;
    debugPrint('SttService: STT socket closed mid-round → tap fallback');
    unawaited(_failListening());
  }

  /// Transport error → re-arm tap input (unless we're already closing).
  void _onWsError(Object error) {
    if (_expectClose || _disposed) return;
    debugPrint('SttService: STT socket error → tap fallback: $error');
    unawaited(_failListening());
  }

  /// Watchdog trip: STT is no longer usable mid-round. Tears the pipeline down
  /// and flips [status] to [SttStatus.unavailable] — the signal the screen
  /// listens for to re-arm tap input.
  Future<void> _failListening() async {
    await _closePipeline();
    micLevel.value = 0;
    if (!_disposed) {
      status.value = SttStatus.unavailable;
    }
  }

  /// Closes the recorder + socket without disposing the notifiers, so a replay
  /// (or the failure→tap path) leaves the service reusable.
  Future<void> _closePipeline() async {
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

    await _wsSub?.cancel();
    _wsSub = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }

  void _updateMicLevel(Uint8List data) {
    if (data.length < 2) return;
    final bytes = ByteData.sublistView(data);
    final n = data.length ~/ 2;
    var sum = 0.0;
    for (var i = 0; i < n; i++) {
      sum += bytes.getInt16(i * 2, Endian.little).abs();
    }
    // Normalize mean amplitude (0..~32768) into a lively 0..1 gauge.
    final level = ((sum / n) / 4000).clamp(0.0, 1.0);
    // Light smoothing so the bar doesn't strobe.
    micLevel.value = micLevel.value * 0.6 + level * 0.4;
  }

  String? _authToken() =>
      Supabase.instance.client.auth.currentSession?.accessToken;

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

  /// Releases the recorder + socket + notifiers.
  Future<void> dispose() async {
    _disposed = true;
    _expectClose = true;
    await _closePipeline();
    status.dispose();
    micLevel.dispose();
  }
}
