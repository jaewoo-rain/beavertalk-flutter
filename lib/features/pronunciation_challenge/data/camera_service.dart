import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// Lifecycle of the [ChallengeCameraService].
enum CameraStatus {
  /// Never initialized.
  idle,

  /// Initializing.
  loading,

  /// Preview is live.
  ready,

  /// No camera / permission denied / unsupported — keep the solid backdrop.
  unavailable,
}

/// Front-camera preview backdrop for the Pronunciation Challenge — the Flutter
/// analogue of the web game's `drawCamera()` selfie background.
///
/// ## Mic coexistence
/// The controller is created with `enableAudio: false` **on purpose**: a
/// preview-only camera must NOT open the microphone, otherwise it would contend
/// with the STT service's PCM capture (Android `AudioRecord` / iOS
/// `AVAudioSession` only cleanly allow one mic owner). The STT service now grabs
/// the mic directly (`FlutterSoundRecorder` → server STT WebSocket), so keeping
/// camera audio off lets the preview and that mic stream coexist.
///
/// ## Video recording (deliberately NOT wired here — see the screen's TODO)
/// True "record the composited gameplay canvas + selfie + voice to MP4" needs a
/// frame-capture + mux pipeline (`RepaintBoundary` frames + PCM → encoder),
/// which is native/`ffmpeg`-heavy and unverifiable without a device. The
/// shipped share path is a result **score-card image** (see the screen). This
/// service intentionally stops at the preview backdrop.
///
/// Every failure resolves to [CameraStatus.unavailable]; the game stays
/// playable on the solid `AppColors.surface` background.
class ChallengeCameraService {
  /// The initialized controller, or `null` until [CameraStatus.ready].
  CameraController? controller;

  /// Current lifecycle status.
  final ValueNotifier<CameraStatus> status = ValueNotifier<CameraStatus>(
    CameraStatus.idle,
  );

  bool _disposed = false;

  /// Guards concurrent [init] calls (e.g. a fast double tap on Start) so we
  /// never build two `CameraController`s and leak one.
  Future<bool>? _initFuture;

  /// Whether a live preview is available.
  bool get isReady =>
      status.value == CameraStatus.ready && controller != null;

  /// Initializes the front camera preview. Returns `true` on success; `false`
  /// (→ solid backdrop) on any failure. Never throws.
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
    status.value = CameraStatus.loading;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        status.value = CameraStatus.unavailable;
        return false;
      }
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false, // ← keep the mic free for STT capture (see class doc)
      );
      await controller.initialize();
      if (_disposed) {
        await controller.dispose();
        return false;
      }
      this.controller = controller;
      status.value = CameraStatus.ready;
      return true;
    } catch (e) {
      debugPrint('ChallengeCameraService.init failed → solid backdrop: $e');
      status.value = CameraStatus.unavailable;
      return false;
    }
  }

  /// Releases the controller without permanently disposing the service —
  /// used when the app is backgrounded, where the OS can invalidate the
  /// preview session. Unlike [dispose], [init] can rebuild the preview
  /// afterwards (standard `camera` package pause/resume pattern).
  Future<void> pause() async {
    try {
      await controller?.dispose();
    } catch (_) {}
    controller = null;
    if (!_disposed) {
      status.value = CameraStatus.idle;
    }
  }

  /// Disposes the controller + notifier.
  Future<void> dispose() async {
    _disposed = true;
    try {
      await controller?.dispose();
    } catch (_) {}
    controller = null;
    status.dispose();
  }
}
