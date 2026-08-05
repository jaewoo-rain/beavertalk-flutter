import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Lifecycle of the [ChallengeRecorder].
enum RecorderStatus {
  /// Not recording.
  idle,

  /// MediaProjection consent granted, capture running.
  recording,

  /// Screen recording can't run here (web / iOS / denied consent / API 34+).
  unavailable,
}

/// Records the Pronunciation Challenge gameplay to an MP4 via the native
/// `MediaProjection` recorder (see `MainActivity.kt`).
///
/// ## Why native screen capture, not RepaintBoundary frames
/// The camera backdrop is a native `Texture`; Flutter's
/// `RenderRepaintBoundary.toImage()` cannot read external platform textures
/// (they capture as black). MediaProjection captures the composited screen —
/// live camera preview + game `CustomPaint` + chrome — exactly as shown, the
/// only way to get "camera + overlay" in one file without a native compositor.
///
/// ## Audio (deliberately video-only)
/// The native recorder captures video only. Opening the microphone (via
/// `MediaRecorder` audio) would contend with [SttService]'s `AudioRecord`
/// capture and break the live speech input that drives the game. Recording is
/// therefore silent by design; adding voice needs the mic-contention question
/// resolved first (see docs/).
///
/// Every failure resolves to [RecorderStatus.unavailable] and the game keeps
/// working — recording is a best-effort extra, never a hard dependency.
class ChallengeRecorder {
  /// Creates a recorder. Inject a [channel] in tests.
  ChallengeRecorder({MethodChannel? channel})
      : _channel = channel ??
            const MethodChannel('beavertalk/challenge_recorder');

  final MethodChannel _channel;

  /// Current lifecycle status.
  final ValueNotifier<RecorderStatus> status =
      ValueNotifier<RecorderStatus>(RecorderStatus.idle);

  bool _disposed = false;

  /// Whether a capture is currently running.
  bool get isRecording => status.value == RecorderStatus.recording;

  /// Starts screen capture. Shows the OS MediaProjection consent sheet. Returns
  /// `true` when capture began; `false` (→ no clip, game still plays) on
  /// web/iOS/denied/API-34+. Never throws.
  Future<bool> start() async {
    if (_disposed || isRecording) return false;
    // Only the Android channel implements this; elsewhere it's unavailable.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      status.value = RecorderStatus.unavailable;
      return false;
    }
    try {
      final ok = await _channel.invokeMethod<bool>('start') ?? false;
      if (_disposed) {
        if (ok) await _safeStop();
        return false;
      }
      status.value = ok ? RecorderStatus.recording : RecorderStatus.unavailable;
      return ok;
    } catch (e) {
      debugPrint('ChallengeRecorder.start failed → no clip: $e');
      status.value = RecorderStatus.unavailable;
      return false;
    }
  }

  /// Stops capture and returns the MP4 path, or `null` if nothing was recorded
  /// or finalization failed. Idempotent.
  Future<String?> stop() async {
    if (!isRecording) return null;
    try {
      final path = await _channel.invokeMethod<String>('stop');
      if (!_disposed) status.value = RecorderStatus.idle;
      return (path == null || path.isEmpty) ? null : path;
    } catch (e) {
      debugPrint('ChallengeRecorder.stop failed: $e');
      if (!_disposed) status.value = RecorderStatus.idle;
      return null;
    }
  }

  Future<void> _safeStop() async {
    try {
      await _channel.invokeMethod<String>('stop');
    } catch (_) {}
  }

  /// Stops any in-flight capture and releases the notifier.
  Future<void> dispose() async {
    _disposed = true;
    if (status.value == RecorderStatus.recording) await _safeStop();
    status.dispose();
  }
}
