import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/network/ws_url.dart';
import '../domain/matcher.dart';
import 'curated_word_source.dart';

/// Lifecycle of the [SttService].
enum SttStatus {
  /// Never initialized.
  idle,

  /// Preparing (connecting the STT WebSocket on start).
  loading,

  /// Ready to capture (mic available), not yet streaming.
  ready,

  /// Capturing mic PCM and streaming it to the server recognizer.
  listening,

  /// STT can't run here (web, no mic permission, or the STT server is
  /// unreachable / errored) — callers must fall back to tap input.
  unavailable,
}

/// Korean speech recognition for the Pronunciation Challenge, backed by
/// **server STT** (Google Cloud Speech-to-Text streaming over a WebSocket).
///
/// ## Why server STT (not Vosk on-device, not `speech_to_text`)
/// The platform speech recognizers (Android `SpeechRecognizer` / iOS
/// `SFSpeechRecognizer`) own the microphone **exclusively**, so STT and audio
/// recording cannot coexist. Server STT keeps a single mic capture and fans its
/// PCM out over a WebSocket, so recording can coexist and there's no on-device
/// model download. Mirrors the web game (`app/public/pronunciation-challenge
/// .html`).
///
/// 엔드포인트는 **앱 백엔드**의 `/api/v1/pron/stt/ws` 다(웹 서버 구현을 그대로 이식했다).
/// 웹 판과 한 가지가 다르다 — **Supabase 토큰이 필수**다. STT 는 과금이 있어 서버가
/// 인증된 사용자만 받고, 토큰이 없거나 무효면 1008 로 즉시 닫는다. 웹 서버 쪽은 인증이
/// 없어(origin 헤더만 확인) 토큰 없이도 붙었는데, 그 주소를 앱이 오래 들고 있었다.
/// 주소는 [pronSttWsUrl] 이 `API_BASE_URL` 에서 유도한다 — 호스트를 따로 박지 않는다.
///
/// ## Protocol (`services/stt/stt_session.py`)
/// * client→server: first text `{"type":"config","words":[…],"sampleRate":N}`,
///   then binary LINEAR16 PCM, optional `{"type":"stop"}`.
/// * server→client: `{"type":"ready"}`, `{"type":"partial","text":…}`,
///   `{"type":"final","text":…}`, `{"type":"error","error":…}`.
///
/// ## Stream rollover (why we reconnect mid-round)
/// Google V1 `streaming_recognize` reliably transcribes only ~one short
/// utterance per stream: after the first result its latency climbs and later
/// words arrive too late (their card has already left the zone). So we keep each
/// stream **short** and roll it over — close + reopen a fresh stream — during
/// the natural pause between spoken words, detected by voice-activity
/// ([_maybeRolloverForSilence]), by a server `final`, or by a hard max-age
/// safety. The mic keeps running throughout, so the reconnect falls in the
/// silence and never clips speech.
///
/// ## Graceful degradation
/// Every failure path (web, denied mic, WS connect failure, server `error`)
/// resolves to [SttStatus.unavailable] and returns `false` rather than
/// throwing — the screen keeps the tap-to-pass fallback. The game is always
/// playable.
class SttService {
  /// Creates the service.
  SttService();

  /// Whitespace splitter for tokenizing a transcript.
  static final RegExp _whitespace = RegExp(r'\s+');

  /// Capture sample rate — sent to the server in the `config` message so its
  /// Google STT `RecognitionConfig` matches. 16 kHz mono is Google's preferred
  /// LINEAR16 rate and keeps the WS payload small.
  static const int sampleRate = 16000;

  /// How long to wait for the WS handshake + server `ready` before giving up
  /// and falling back to tap input.
  static const Duration _connectTimeout = Duration(seconds: 4);

  /// Raw mic level (0..1, see [_rawLevel]) above which we count the frame as
  /// speech for voice-activity detection.
  static const double _voiceLevel = 0.06;

  /// Quiet time after the last speech before rolling the stream over — long
  /// enough for the in-flight word to finish transcribing, short enough that the
  /// fresh stream is ready before the next word.
  static const int _silenceMs = 550;

  /// Hard cap on a single stream's lifetime (covers continuous speech with no
  /// pause, where silence-rollover never fires) — keeps latency from climbing.
  static const int _maxStreamMs = 2600;

  /// Current lifecycle status (drives the loading panel + fallback decision).
  final ValueNotifier<SttStatus> status = ValueNotifier<SttStatus>(
    SttStatus.idle,
  );

  /// Smoothed 0..1 mic level for the on-screen indicator.
  final ValueNotifier<double> micLevel = ValueNotifier<double>(0);

  /// Wired to `ChallengeEngine.tryPassToken` by the controller: attempts to
  /// pass a card for a normalized spoken token, returning `true` on a match.
  /// Used in **word mode**.
  bool Function(String token)? onToken;

  /// Wired to `ChallengeEngine.tryPassSentence` in **sentence mode**: attempts
  /// to pass a card for the whole spoken transcript. When [sentenceMode] is set,
  /// the full transcript is forwarded here instead of tokenizing to [onToken].
  bool Function(String transcript)? onTranscript;

  /// When `true`, cards are learned **sentences** (the player speaks the whole
  /// sentence). Widens the rollover timing so a multi-word utterance isn't cut
  /// mid-sentence, and routes matching through [onTranscript].
  bool sentenceMode = false;

  AudioRecorder? _recorder;
  StreamSubscription<Uint8List>? _micSub;
  WebSocketChannel? _ws;
  StreamSubscription<dynamic>? _wsSub;

  bool _disposed = false;

  /// True from a successful [startListening] until [stopListening]/[dispose]/a
  /// terminal failure. While active, an unexpected socket close is treated as a
  /// per-utterance rollover (see [_handleWsDrop]) rather than the end of STT.
  bool _active = false;

  /// Whether a [_reconnect] is currently in flight (so overlapping triggers —
  /// silence, final, max-age, socket close — don't spawn parallel reconnects).
  bool _reconnecting = false;

  /// Whether the `config` frame has been sent on the CURRENT socket. Until it
  /// has, [_onPcm] must not push binary PCM: on a mid-stream rollover the mic is
  /// already running, so without this gate a PCM frame can be enqueued ahead of
  /// `config` while `_openWs` awaits the handshake. The server would then read
  /// that first (binary) frame as audio, fall back to its DEFAULT 48 kHz sample
  /// rate, and Google STT — fed our 16 kHz audio under a 48 kHz config — returns
  /// no transcript, silently killing every stream after the first.
  bool _configSent = false;

  // ── per-stream state (reset on every (re)connect) ──────────────────
  /// Tokens that have already cleared a card in the CURRENT stream. Re-scanning
  /// the cumulative transcript would otherwise let a stale word clear a fresh
  /// same-word card, or re-fire on Google's repeated partials.
  final Set<String> _clearedThisStream = <String>{};

  /// `millisecondsSinceEpoch` when the current stream opened (0 = none).
  int _streamStartMs = 0;

  /// `millisecondsSinceEpoch` of the last speech frame (0 = none this stream).
  int _lastVoiceMs = 0;

  /// Whether any transcript arrived on the current stream (so we don't roll an
  /// idle, never-spoken-into stream).
  bool _spokeThisStream = false;

  /// Whether the recognizer is ready to start (or already streaming).
  bool get isAvailable =>
      status.value == SttStatus.ready || status.value == SttStatus.listening;

  /// No model to load for server STT — becomes usable immediately on a
  /// supported platform. Web has no mic-stream story here, so it falls back to
  /// tap. Never throws.
  Future<bool> init() async {
    if (_disposed) return false;
    if (kIsWeb) {
      status.value = SttStatus.unavailable;
      return false;
    }
    status.value = SttStatus.ready;
    return true;
  }

  /// Opens the STT WebSocket, sends the `config`, then starts a single 16 kHz
  /// mono PCM capture streaming to the server. Returns `false` (→ tap fallback)
  /// if the mic is denied or the server is unreachable/errors. Never throws.
  Future<bool> startListening() async {
    if (_disposed) return false;
    _recorder ??= AudioRecorder();

    // 1) Mic permission — without it there's nothing to stream.
    try {
      if (!await _recorder!.hasPermission()) {
        status.value = SttStatus.unavailable;
        return false;
      }
    } catch (e) {
      debugPrint('SttService: mic permission check failed → tap fallback: $e');
      status.value = SttStatus.unavailable;
      return false;
    }

    status.value = SttStatus.loading;

    // 2) Connect the WS and wait for the server's `ready`.
    final connected = await _openWs();
    if (!connected || _disposed) {
      await _teardownWs();
      if (!_disposed) status.value = SttStatus.unavailable;
      return false;
    }
    // Mark active BEFORE starting the mic so a socket close during mic setup is
    // handled by the rollover path, not dropped.
    _active = true;

    // 3) Start the mic stream → forward PCM to the server.
    try {
      final stream = await _recorder!.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
        ),
      );
      _micSub = stream.listen(
        _onPcm,
        onError: (Object e) => debugPrint('mic stream error: $e'),
      );
      status.value = SttStatus.listening;
      return true;
    } catch (e) {
      debugPrint('SttService.startListening failed → tap fallback: $e');
      _active = false;
      await _teardownWs();
      if (!_disposed) status.value = SttStatus.unavailable;
      return false;
    }
  }

  /// Opens the WebSocket, sends the `config` frame, resets per-stream state, and
  /// resolves `true` once the server acknowledges `{"type":"ready"}` (or `false`
  /// on timeout / early close). A close/error AFTER `ready` routes to
  /// [_handleWsDrop] (mid-round → rollover reconnect).
  Future<bool> _openWs() async {
    // Fresh stream: clear the dedup set and voice/age timers.
    _clearedThisStream.clear();
    _spokeThisStream = false;
    _lastVoiceMs = 0;
    _configSent = false; // gate PCM until this stream's config frame is sent
    _streamStartMs = DateTime.now().millisecondsSinceEpoch;

    final ready = Completer<bool>();
    void settle(bool ok) {
      if (!ready.isCompleted) ready.complete(ok);
    }

    void onClosed() {
      if (!ready.isCompleted) {
        ready.complete(false);
      } else {
        _handleWsDrop();
      }
    }

    try {
      // STT WS 는 **인증 필수**다(서버: 토큰 없음/무효 → 1008 즉시 close).
      // 과금이 있어 인증된 사용자만 허용한다 — 통화 WS 와 같은 규약.
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token == null || token.isEmpty) {
        debugPrint('SttService: 세션 토큰 없음 → tap fallback');
        return false;
      }
      final channel = WebSocketChannel.connect(Uri.parse(pronSttWsUrl(token)));
      _ws = channel;
      await channel.ready.timeout(_connectTimeout);

      channel.sink.add(
        jsonEncode(<String, dynamic>{
          'type': 'config',
          'words': CuratedWordSource.words,
          'sampleRate': sampleRate,
        }),
      );
      // Config is now first in the sink's queue → PCM may flow.
      _configSent = true;

      _wsSub = channel.stream.listen(
        (dynamic data) => _onWsMessage(data, settle),
        onError: (Object e) {
          debugPrint('STT ws error: $e');
          onClosed();
        },
        onDone: onClosed,
        cancelOnError: true,
      );

      return await ready.future.timeout(_connectTimeout, onTimeout: () => false);
    } catch (e) {
      debugPrint('STT ws connect failed → tap fallback: $e');
      settle(false);
      return false;
    }
  }

  /// Handles a mid-round socket close (server ended the STT session, e.g. its
  /// own endpointer finalized). Reconnects if still active.
  void _handleWsDrop() {
    if (_disposed || !_active || _reconnecting) return;
    unawaited(_reconnect());
  }

  /// Proactively rolls the stream over (fresh Google recognizer) — triggered by
  /// a server `final`, detected silence, or the max-age cap.
  void _rolloverStream() {
    if (_disposed || !_active || _reconnecting) return;
    unawaited(_reconnect());
  }

  /// Reopens the STT socket without touching the running mic capture. Falls back
  /// to tap input only if the reconnect itself fails (server unreachable).
  Future<void> _reconnect() async {
    _reconnecting = true;
    try {
      await _teardownWs();
      if (_disposed || !_active) return;
      final ok = await _openWs();
      if (ok) {
        if (status.value != SttStatus.listening && !_disposed) {
          status.value = SttStatus.listening;
        }
      } else if (_active && !_disposed) {
        debugPrint('STT reconnect failed → tap fallback');
        await _failListening();
      }
    } finally {
      _reconnecting = false;
    }
  }

  void _onWsMessage(dynamic data, void Function(bool) settle) {
    if (data is! String) return; // server events are JSON text
    Map<dynamic, dynamic>? msg;
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) msg = decoded;
    } catch (_) {}
    if (msg == null) return;

    final type = msg['type'];
    switch (type) {
      case 'ready':
        settle(true);
        break;
      case 'partial':
      case 'final':
        _spokeThisStream = true;
        final text = (msg['text'] as String?)?.trim() ?? '';
        if (text.isNotEmpty) _matchSpoken(text);
        // A server `final` is a natural utterance boundary — roll over so the
        // next word gets a fresh recognizer (belt-and-braces with the
        // client-side silence rollover, which usually fires first).
        if (type == 'final') _rolloverStream();
        break;
      case 'error':
        debugPrint('STT server error → tap fallback: ${msg['error']}');
        settle(false);
        unawaited(_failListening());
        break;
    }
  }

  /// Matches a transcript against the in-zone cards — **stateless per message**,
  /// mirroring the web game's `matchSpoken`. Google streaming returns a
  /// cumulative growing transcript, so every message re-scans all tokens;
  /// [onToken] (→ `ChallengeEngine.tryPassToken`) only passes a live in-zone
  /// card. [_clearedThisStream] stops an already-cleared word from firing again
  /// on Google's repeated partials or clearing a fresh same-word card.
  void _matchSpoken(String text) {
    // Sentence mode: match the WHOLE transcript against the in-zone sentence
    // cards (the player says a full learned sentence, not one word).
    if (sentenceMode) {
      onTranscript?.call(text);
      return;
    }
    final cb = onToken;
    if (cb == null) return;
    for (final raw in text.toLowerCase().split(_whitespace)) {
      final tok = norm(raw);
      if (tok.isEmpty || _clearedThisStream.contains(tok)) continue;
      if (cb(tok)) _clearedThisStream.add(tok);
    }
  }

  /// Stops the capture, tells the server to stop, and closes the socket.
  /// Idempotent.
  Future<void> stopListening() async {
    // Clear _active first so the socket close below is treated as a deliberate
    // stop, not an utterance rollover.
    _active = false;
    await _micSub?.cancel();
    _micSub = null;
    try {
      await _recorder?.stop();
    } catch (_) {}
    final ws = _ws;
    if (ws != null) {
      try {
        ws.sink.add(jsonEncode(<String, dynamic>{'type': 'stop'}));
      } catch (_) {}
    }
    await _teardownWs();
    micLevel.value = 0;
    if (!_disposed && status.value == SttStatus.listening) {
      status.value = SttStatus.ready;
    }
  }

  /// Watchdog trip: the server/socket died and couldn't be re-established. Stops
  /// capture and flips [status] to [SttStatus.unavailable] so the screen re-arms
  /// the tap fallback.
  Future<void> _failListening() async {
    _active = false;
    await _micSub?.cancel();
    _micSub = null;
    try {
      await _recorder?.stop();
    } catch (_) {}
    await _teardownWs();
    micLevel.value = 0;
    if (!_disposed) {
      status.value = SttStatus.unavailable;
    }
  }

  Future<void> _teardownWs() async {
    _configSent = false;
    await _wsSub?.cancel();
    _wsSub = null;
    try {
      await _ws?.sink.close();
    } catch (_) {}
    _ws = null;
  }

  void _onPcm(Uint8List data) {
    final raw = _updateMicLevel(data);
    _maybeRolloverForSilence(raw);
    final ws = _ws;
    // Don't push PCM before this stream's `config` frame (see [_configSent]) —
    // a binary-first frame makes the server default to 48 kHz and drop the round.
    if (ws == null || !_configSent) return;
    // `record` pcm16bits stream is already raw Int16 LE PCM — forward straight
    // to the server as a binary frame (no float→int conversion needed).
    try {
      ws.sink.add(data);
    } catch (e) {
      debugPrint('STT ws send failed: $e');
    }
  }

  /// Voice-activity driven rollover: once the player has spoken in this stream
  /// and then gone quiet for [_silenceMs] (or the stream has run past
  /// [_maxStreamMs]), roll over so the NEXT word gets a fresh, low-latency
  /// recognizer — with the reconnect landing inside the pause, not on speech.
  void _maybeRolloverForSilence(double rawLevel) {
    if (!_active || _reconnecting || _disposed) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (rawLevel >= _voiceLevel) _lastVoiceMs = now;
    if (!_spokeThisStream) return;
    // Sentences take longer to say (and the player pauses between words), so a
    // full sentence isn't cut mid-utterance — widen both thresholds.
    final silence = sentenceMode ? 1100 : _silenceMs;
    final maxAge = sentenceMode ? 6500 : _maxStreamMs;
    if (_lastVoiceMs != 0 && now - _lastVoiceMs > silence) {
      _rolloverStream();
      return;
    }
    if (_streamStartMs != 0 && now - _streamStartMs > maxAge) {
      _rolloverStream();
    }
  }

  /// Updates the smoothed [micLevel] gauge and returns the RAW (unsmoothed)
  /// 0..1 level for voice-activity detection.
  double _updateMicLevel(Uint8List data) {
    if (data.length < 2) return 0;
    final bytes = ByteData.sublistView(data);
    final n = data.length ~/ 2;
    var sum = 0.0;
    for (var i = 0; i < n; i++) {
      sum += bytes.getInt16(i * 2, Endian.little).abs();
    }
    // Normalize mean amplitude (0..~32768) into a 0..1 gauge.
    final raw = ((sum / n) / 4000).clamp(0.0, 1.0);
    // Light smoothing so the on-screen bar doesn't strobe.
    micLevel.value = micLevel.value * 0.6 + raw * 0.4;
    return raw;
  }

  /// Releases the recorder + socket + notifiers.
  Future<void> dispose() async {
    _disposed = true;
    _active = false;
    await _micSub?.cancel();
    try {
      await _recorder?.stop();
    } catch (_) {}
    await _teardownWs();
    try {
      await _recorder?.dispose();
    } catch (_) {}
    status.dispose();
    micLevel.dispose();
  }
}
