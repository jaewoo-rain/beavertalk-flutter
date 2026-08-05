import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

/// Single-utterance PCM16 recorder for the review flow.
///
/// Mirrors the normalcall controller's recorder config (PCM16 / 16000 Hz /
/// mono, voice processing + echo cancellation) — which is verified to work on
/// web and mobile — but instead of streaming to a socket it accumulates the raw
/// PCM bytes in memory and returns them on [stop].
///
/// Lifecycle: create → [start] → (speak) → [stop] (returns PCM) → [dispose].
class ReviewAudioRecorder {
  FlutterSoundRecorder? _recorder;
  StreamController<Uint8List>? _controller;
  StreamSubscription<Uint8List>? _sub;
  final BytesBuilder _pcm = BytesBuilder();
  bool _recording = false;
  bool _starting = false;

  /// Broadcasts the live input level (normalized 0..1) while recording, driven
  /// by flutter_sound's `onProgress` decibel readings. Additive — it never
  /// touches the PCM capture path. Consumers (e.g. the mic button) can drive a
  /// reactive visual from it; when no reading is available (e.g. web where the
  /// streaming recorder may not report dbPeakLevel) it simply emits nothing.
  StreamController<double>? _amp;
  StreamSubscription<RecordingDisposition>? _ampSub;

  /// Whether a recording is currently in progress.
  bool get isRecording => _recording;

  /// Live, normalized (0..1) microphone level stream while recording. Empty when
  /// not recording. Best-effort: reflects `onProgress` decibels where the
  /// platform provides them (mobile/desktop); may stay silent on platforms that
  /// don't report a level during streaming capture (some web browsers).
  Stream<double> get amplitude =>
      _amp?.stream ?? const Stream<double>.empty();

  /// Requests mic permission (if needed) and starts recording into memory.
  ///
  /// Throws [StateError] with a user-facing message when permission is denied.
  Future<void> start() async {
    // `_recording` only flips true at the very end (after several awaits), so a
    // fast double-tap could enter twice and interleave two recorders into the
    // same buffer. Guard synchronously up front.
    if (_recording || _starting) return;
    _starting = true;
    try {
      await _startInternal();
    } finally {
      _starting = false;
    }
  }

  Future<void> _startInternal() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw StateError('마이크 권한이 필요해요.');
    }

    _pcm.clear();
    final controller = StreamController<Uint8List>();
    _controller = controller;
    _sub = controller.stream.listen(_pcm.add);

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

    // Additive amplitude signal: subscribe to the recorder's progress events
    // (decibel peak levels) and republish them as a normalized 0..1 stream.
    // This does not affect the PCM capture above.
    final amp = StreamController<double>.broadcast();
    _amp = amp;
    try {
      await recorder
          .setSubscriptionDuration(const Duration(milliseconds: 80));
      _ampSub = recorder.onProgress?.listen((e) {
        if (amp.isClosed) return;
        final db = e.decibels ?? 0.0;
        // flutter_sound's dbPeakLevel runs roughly 0..~90 for speech; map to a
        // subtle 0..1 range (÷60 gives good headroom without clipping to 1 on
        // normal talking). Silence → ~0.
        amp.add((db / 60.0).clamp(0.0, 1.0));
      });
    } catch (_) {
      // Amplitude is a nice-to-have; never let it block recording.
    }

    _recording = true;
  }

  /// Stops recording and returns the accumulated raw PCM16 bytes (headerless).
  ///
  /// Returns an empty list if nothing was captured. Safe to call when not
  /// recording (returns whatever was captured, or empty).
  Future<Uint8List> stop() async {
    if (!_recording) return _pcm.toBytes();
    _recording = false;
    try {
      await _recorder?.stopRecorder();
    } catch (_) {
      // Ignore stop errors — we still return what we captured.
    }
    await _ampSub?.cancel();
    _ampSub = null;
    await _amp?.close();
    _amp = null;
    await _sub?.cancel();
    _sub = null;
    await _controller?.close();
    _controller = null;
    return _pcm.toBytes();
  }

  /// Releases the recorder. Idempotent. Call from the owning widget's dispose.
  Future<void> dispose() async {
    _recording = false;
    try {
      if (_recorder?.isRecording ?? false) {
        await _recorder?.stopRecorder();
      }
    } catch (_) {
      // best-effort
    }
    await _ampSub?.cancel();
    _ampSub = null;
    await _amp?.close();
    _amp = null;
    await _sub?.cancel();
    _sub = null;
    await _controller?.close();
    _controller = null;
    try {
      await _recorder?.closeRecorder();
    } catch (_) {
      // best-effort
    }
    _recorder = null;
  }
}
