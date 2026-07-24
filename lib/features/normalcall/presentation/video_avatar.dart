import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// Neural talking-avatar renderer: plays two seamless, looping, neural-generated
/// clips — an **idle** loop (listening) and a **talking** loop — and cross-fades
/// to the talking loop while the character speaks.
///
/// This is the "generated motion, not sprite-swap" path: the mouth/head/body
/// move as a coherent character (rendered by a video model), which reads far
/// more naturally than compositing still frames. It's still real-time and fully
/// in-app (just video playback), driven by the existing call `speaking` signal;
/// it is not word-accurate lip-sync (the loop is generic talking motion).
///
/// Returns [fallback] until the clips initialize, and if the character has no
/// `idle.mp4`/`talk.mp4` the caller should use the sprite avatar instead.
class VideoAvatar extends StatefulWidget {
  /// Creates the video avatar for the clips under [assetDir].
  const VideoAvatar({
    super.key,
    required this.assetDir,
    required this.speaking,
    this.fallback,
  });

  /// Asset dir holding `idle.mp4` and `talk.mp4` (e.g. `assets/avatar/baba`).
  final String assetDir;

  /// True while the character is speaking → cross-fade to the talking loop.
  final ValueListenable<bool> speaking;

  /// Shown until the clips are ready (and if they fail to load).
  final Widget? fallback;

  @override
  State<VideoAvatar> createState() => _VideoAvatarState();
}

class _VideoAvatarState extends State<VideoAvatar> {
  VideoPlayerController? _idle;
  VideoPlayerController? _talk;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final idle = VideoPlayerController.asset('${widget.assetDir}/idle.mp4');
      final talk = VideoPlayerController.asset('${widget.assetDir}/talk.mp4');
      _idle = idle;
      _talk = talk;
      await Future.wait([idle.initialize(), talk.initialize()]);
      await idle.setLooping(true);
      await talk.setLooping(true);
      await idle.setVolume(0);
      await talk.setVolume(0);
      // Play both continuously; opacity picks which one is visible so switching
      // is instant with no load gap.
      await idle.play();
      await talk.play();
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _idle?.dispose();
    _talk?.dispose();
    super.dispose();
  }

  Widget _cover(VideoPlayerController c) {
    final size = c.value.size;
    return FittedBox(
      fit: BoxFit.cover,
      // Bias toward the top so the head stays visible when a square clip is
      // cover-cropped into a wide band (the chest/arms crop off first).
      alignment: Alignment.topCenter,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.fallback ?? const SizedBox.expand();
    if (!_ready) return widget.fallback ?? const SizedBox.expand();
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _cover(_idle!),
          ValueListenableBuilder<bool>(
            valueListenable: widget.speaking,
            builder: (context, speaking, _) => AnimatedOpacity(
              opacity: speaking ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              child: _cover(_talk!),
            ),
          ),
        ],
      ),
    );
  }
}
