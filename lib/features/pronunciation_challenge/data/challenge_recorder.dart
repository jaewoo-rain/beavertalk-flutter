import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Lifecycle of the [ChallengeRecorder].
enum RecorderStatus {
  /// Not recording.
  idle,

  /// MediaProjection consent granted, capture running.
  recording,

  /// 여기서는 화면 녹화를 못 한다(웹 / 동의 거부 / 시스템 거절).
  unavailable,
}

/// Records the Pronunciation Challenge gameplay to an MP4 via a native screen
/// recorder — `MediaProjection` on Android (`MainActivity.kt` +
/// `ScreenCaptureService.kt`), ReplayKit in-app recording on iOS
/// (`ios/Runner/ChallengeRecorder.swift`). Both answer the same channel.
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

  /// Whether this platform can screen-record at all.
  ///
  /// Android(`MediaProjection`) 과 iOS(ReplayKit 인앱 녹화) 둘 다 된다. iOS 가
  /// 브로드캐스트 익스텐션을 요구한다는 건 오해였다 — 그건 **다른 앱까지 포함해
  /// 화면 전체를 송출하는** 경로고, 이 앱이 그린 것만 잡으면 되는 인앱 녹화는
  /// 별도 타깃 없이 `RPScreenRecorder` 로 된다.
  ///
  /// 이걸 런 **전에** 알아야 시작 패널이 아무것도 못 하는 스위치를 내놓지 않고,
  /// 결과 패널도 없는 클립을 기다리지 않는다. 웹은 경로가 없다.
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Whether a capture is currently running.
  bool get isRecording => status.value == RecorderStatus.recording;

  /// Starts screen capture. 안드로이드는 MediaProjection 동의 시트를, iOS 는
  /// ReplayKit 권한 알림을 띄운다. 캡처가 시작되면 `true`, 아니면 `false`
  /// (→ 클립 없음, 게임은 계속). 예외를 던지지 않는다.
  Future<bool> start() async {
    if (_disposed || isRecording) return false;
    if (!isSupported) {
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
