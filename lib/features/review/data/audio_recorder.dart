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

  /// Whether a recording is currently in progress.
  bool get isRecording => _recording;

  /// Requests mic permission (if needed) and starts recording into memory.
  ///
  /// Throws [StateError] with a user-facing message when permission is denied.
  Future<void> start() async {
    if (_recording) return;

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
