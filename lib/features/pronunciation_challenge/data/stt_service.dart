import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:vosk_flutter_2/vosk_flutter_2.dart';

import '../domain/speech_matcher.dart';
import 'curated_word_source.dart';

/// Lifecycle of the [SttService].
enum SttStatus {
  /// Never initialized.
  idle,

  /// Loading / downloading the Vosk model.
  loading,

  /// Model + recognizer ready, not yet capturing.
  ready,

  /// Capturing mic PCM and feeding the recognizer.
  listening,

  /// STT can't run here (web, iOS-unsupported plugin, no model, denied mic) —
  /// callers must fall back to tap input.
  unavailable,
}

/// On-device Korean speech recognition for the Pronunciation Challenge.
///
/// ## Single-mic-tap architecture (why Vosk, not `speech_to_text`)
/// The platform speech recognizers (Android `SpeechRecognizer` / iOS
/// `SFSpeechRecognizer`) own the microphone **exclusively**, so STT and audio
/// recording cannot coexist. Vosk instead accepts raw PCM via
/// [Recognizer.acceptWaveformBytes], so **one** mic capture can fan out:
///
/// ```
/// AudioRecorder.startStream (16 kHz mono PCM16)
///    ├─→ Vosk recognizer.acceptWaveformBytes → partial/final → token match
///    └─→ (future) audio track for video muxing  ← see ChallengeCameraService
/// ```
///
/// Because *we* own the stream there is no 60-second session cut-off or re-arm
/// dead-zone that the platform recognizers suffer (plan §D-1 / D-4.5).
///
/// ## Graceful degradation
/// Every failure path (web, unsupported platform, model download failure,
/// denied mic) resolves to [SttStatus.unavailable] and returns `false` rather
/// than throwing — the screen then keeps the tap-to-pass fallback. The game is
/// always playable.
class SttService {
  /// Creates the service. Inject a [matcher] for tests.
  SttService({SpeechMatcher? matcher}) : _matcher = matcher ?? SpeechMatcher();

  /// Korean small model (~82 MB). Downloaded on first use and cached under the
  /// app documents dir by [ModelLoader].
  ///
  /// TODO(device): consider bundling this as an asset and switching to
  /// `ModelLoader().loadFromAssets(...)` to remove the first-run download; the
  /// download path is used here because no device is available to verify a
  /// bundled asset. The ~82 MB download must be verified on a real network.
  static const String koModelUrl =
      'https://alphacephei.com/vosk/models/vosk-model-small-ko-0.22.zip';

  /// Recognizer sample rate — must match the [RecordConfig.sampleRate].
  static const int sampleRate = 16000;

  final SpeechMatcher _matcher;

  /// Current lifecycle status (drives the loading panel + fallback decision).
  final ValueNotifier<SttStatus> status = ValueNotifier<SttStatus>(
    SttStatus.idle,
  );

  /// Smoothed 0..1 mic level for the on-screen indicator.
  final ValueNotifier<double> micLevel = ValueNotifier<double>(0);

  /// Wired to `ChallengeEngine.tryPassToken` by the controller: attempts to
  /// pass a card for a normalized spoken token, returning `true` on a match.
  bool Function(String token)? onToken;

  VoskFlutterPlugin? _plugin;
  Model? _model;
  Recognizer? _recognizer;
  AudioRecorder? _recorder;
  StreamSubscription<Uint8List>? _sub;
  final BytesBuilder _buffer = BytesBuilder(copy: false);
  bool _pumping = false;
  bool _disposed = false;

  /// Whether the recognizer is ready (or already listening).
  bool get isAvailable =>
      status.value == SttStatus.ready || status.value == SttStatus.listening;

  /// Loads the model and builds the recognizer. Returns `true` when STT is
  /// usable; `false` (with [status] == [SttStatus.unavailable]) to signal the
  /// caller to use tap input. Never throws.
  Future<bool> init() async {
    if (_disposed) return false;
    // Web has no dart:io/FFI — Vosk can't run. (Web could use the Web Speech
    // API, but that's out of scope; the screen falls back to tap.)
    if (kIsWeb) {
      status.value = SttStatus.unavailable;
      return false;
    }
    if (_recognizer != null) {
      status.value = SttStatus.ready;
      return true;
    }
    status.value = SttStatus.loading;
    try {
      final modelPath = await ModelLoader().loadFromNetwork(koModelUrl);
      // NOTE: VoskFlutterPlugin supports Android (method channel) and
      // Linux/Windows (FFI). iOS is NOT supported by vosk_flutter_2 and throws
      // here → caught below → tap fallback. Must verify an iOS STT story.
      _plugin = VoskFlutterPlugin.instance();
      _model = await _plugin!.createModel(modelPath);
      // Constrain recognition to the game vocabulary for much higher accuracy
      // on isolated words. Falls back to open recognition if grammar is
      // unsupported by the model.
      try {
        _recognizer = await _plugin!.createRecognizer(
          model: _model!,
          sampleRate: sampleRate,
          grammar: <String>[...CuratedWordSource.words, '[unk]'],
        );
      } catch (_) {
        _recognizer = await _plugin!.createRecognizer(
          model: _model!,
          sampleRate: sampleRate,
        );
      }
      if (_disposed) return false;
      status.value = SttStatus.ready;
      return true;
    } catch (e) {
      debugPrint('SttService.init failed → tap fallback: $e');
      status.value = SttStatus.unavailable;
      return false;
    }
  }

  /// Starts a single 16 kHz mono PCM capture feeding the recognizer. Returns
  /// `false` (→ tap fallback) if unavailable or the mic is denied.
  Future<bool> startListening() async {
    if (_disposed || _recognizer == null) return false;
    _matcher.reset();
    try {
      await _recognizer!.reset();
    } catch (_) {}
    _recorder ??= AudioRecorder();
    try {
      if (!await _recorder!.hasPermission()) {
        status.value = SttStatus.unavailable;
        return false;
      }
      final stream = await _recorder!.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
        ),
      );
      _buffer.clear();
      _sub = stream.listen(
        _onPcm,
        onError: (Object e) => debugPrint('mic stream error: $e'),
      );
      status.value = SttStatus.listening;
      return true;
    } catch (e) {
      debugPrint('SttService.startListening failed → tap fallback: $e');
      status.value = SttStatus.unavailable;
      return false;
    }
  }

  /// Stops the capture and flushes the recognizer. Idempotent.
  Future<void> stopListening() async {
    await _sub?.cancel();
    _sub = null;
    try {
      await _recorder?.stop();
    } catch (_) {}
    _buffer.clear();
    micLevel.value = 0;
    if (_recognizer != null) {
      try {
        await _recognizer!.getFinalResult();
        await _recognizer!.reset();
      } catch (_) {}
      if (!_disposed && status.value == SttStatus.listening) {
        status.value = SttStatus.ready;
      }
    }
    _matcher.reset();
  }

  void _onPcm(Uint8List data) {
    _updateMicLevel(data);
    _buffer.add(data);
    unawaited(_pump());
  }

  /// Drains the PCM buffer through the recognizer sequentially (one in-flight
  /// [Recognizer.acceptWaveformBytes] at a time to preserve ordering).
  Future<void> _pump() async {
    if (_pumping || _recognizer == null) return;
    _pumping = true;
    try {
      while (_buffer.length > 0 && !_disposed) {
        final chunk = _buffer.takeBytes(); // returns + clears
        final done = await _recognizer!.acceptWaveformBytes(chunk);
        final json = done
            ? await _recognizer!.getResult()
            : await _recognizer!.getPartialResult();
        final text = _extractText(json, isFinal: done);
        if (text.isNotEmpty) {
          _matcher.feed(
            text,
            isFinal: done,
            attempt: (String t) => onToken?.call(t) ?? false,
          );
        } else if (done) {
          // Reset per-utterance bookkeeping on an empty final.
          _matcher.feed('', isFinal: true, attempt: (_) => false);
        }
      }
    } catch (e) {
      debugPrint('vosk feed error: $e');
    } finally {
      _pumping = false;
    }
  }

  /// Extracts the transcript from a Vosk result JSON (`{"partial":...}` for
  /// partials, `{"text":...}` for finals).
  String _extractText(String jsonStr, {required bool isFinal}) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map) {
        final v = isFinal ? decoded['text'] : decoded['partial'];
        if (v is String) return v.trim();
      }
    } catch (_) {}
    return '';
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

  /// Releases the recorder + recognizer + notifiers.
  Future<void> dispose() async {
    _disposed = true;
    await _sub?.cancel();
    try {
      await _recorder?.stop();
    } catch (_) {}
    try {
      await _recorder?.dispose();
    } catch (_) {}
    try {
      await _recognizer?.dispose();
    } catch (_) {}
    status.dispose();
    micLevel.dispose();
  }
}
