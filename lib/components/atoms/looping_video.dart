import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A muted, looping, chrome-free video — the Max paywall's hero.
///
/// The asset is **expected to be swapped later**, so this deliberately never
/// hard-fails: until a real file is bundled (or if one fails to decode) the
/// widget paints [placeholderColor] at the same [aspectRatio] instead of
/// throwing a red box into the paywall. Autoplay is silent and looping, so it
/// reads as motion art rather than a player — no controls are drawn.
class LoopingVideo extends StatefulWidget {
  /// Creates a looping video.
  const LoopingVideo({
    super.key,
    required this.asset,
    required this.aspectRatio,
    this.placeholderColor,
  });

  /// Bundled asset path, e.g. `assets/videos/paywall_max_hero.mp4`.
  final String asset;

  /// Box the video is laid out in; also the placeholder's shape.
  final double aspectRatio;

  /// Painted while loading, and kept if the asset is missing or undecodable.
  final Color? placeholderColor;

  @override
  State<LoopingVideo> createState() => _LoopingVideoState();
}

class _LoopingVideoState extends State<LoopingVideo> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void didUpdateWidget(LoopingVideo old) {
    super.didUpdateWidget(old);
    if (old.asset != widget.asset) {
      _controller?.dispose();
      _controller = null;
      _ready = false;
      _open();
    }
  }

  Future<void> _open() async {
    final c = VideoPlayerController.asset(widget.asset);
    try {
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
    } catch (_) {
      // Missing/undecodable asset — stay on the placeholder. A paywall must
      // still sell the plan without its decoration.
      await c.dispose();
      return;
    }
    if (!mounted) {
      await c.dispose();
      return;
    }
    setState(() {
      _controller = c;
      _ready = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: _ready && controller != null
          ? FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            )
          : ColoredBox(
              color: widget.placeholderColor ?? const Color(0x14000000),
            ),
    );
  }
}
