import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// Lip-synced talking avatar.
///
/// Two modes, cross-faded:
/// - **listening** → the neural `idle.mp4` loop plays (natural head motion,
///   blinks, breathing).
/// - **speaking** → a *flipbook* of frames cut from a neural "still-head"
///   talking clip is driven directly by the live audio envelope, so the mouth
///   lands on the actual syllables. The source clip holds the head perfectly
///   still (measured: mouth-region σ≈18 vs σ≈1.6 everywhere else), so picking
///   frames by loudness never makes the head jump — only the mouth moves.
///
/// Frames ship as `sync0.png … syncN.png` (closed → wide open) next to the
/// clips. A little procedural sway/breathing is added on top so the still-head
/// frames still feel alive while talking.
class SyncAvatar extends StatefulWidget {
  /// Creates the lip-synced avatar for the assets under [assetDir].
  const SyncAvatar({
    super.key,
    required this.assetDir,
    required this.level,
    required this.speaking,
    this.fallback,
  });

  /// Asset dir holding `idle.mp4` and the `syncN.png` flipbook.
  final String assetDir;

  /// Live mouth-open level, 0 (closed) .. 1 (wide) — the audio envelope.
  final ValueListenable<double> level;

  /// True while the character is speaking (flipbook) vs listening (idle clip).
  final ValueListenable<bool> speaking;

  /// Shown until assets are ready (and if they fail to load).
  final Widget? fallback;

  @override
  State<SyncAvatar> createState() => _SyncAvatarState();
}

class _SyncAvatarState extends State<SyncAvatar>
    with SingleTickerProviderStateMixin {
  final List<ui.Image> _frames = [];
  VideoPlayerController? _idle;
  bool _ready = false;
  bool _failed = false;

  late final Ticker _ticker;
  final _st = _FrameState();
  final _repaint = ValueNotifier<int>(0);
  Duration _last = Duration.zero;
  double _elapsed = 0;

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = createTicker(_tick)..start();
  }

  Future<void> _load() async {
    for (var i = 0; i < 32; i++) {
      final img = await _tryDecode('${widget.assetDir}/sync$i.png');
      if (img == null) break;
      _frames.add(img);
    }
    try {
      final c = VideoPlayerController.asset('${widget.assetDir}/idle.mp4');
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      _idle = c;
    } catch (_) {
      // Idle clip optional — the flipbook alone still works.
    }
    if (!mounted) return;
    setState(() {
      _ready = _frames.isNotEmpty || _idle != null;
      _failed = !_ready;
    });
  }

  Future<ui.Image?> _tryDecode(String asset) async {
    try {
      final data = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      return (await codec.getNextFrame()).image;
    } catch (_) {
      return null;
    }
  }

  void _tick(Duration elapsed) {
    final dt = _last == Duration.zero
        ? 0.016
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _elapsed += dt;

    // Track the envelope closely — this is the lip sync, so attack is fast and
    // decay only slightly slower. Over-smoothing here is what makes lips lag.
    final target = widget.level.value.clamp(0.0, 1.0);
    final cur = _st.level;
    _st.level += (target - cur) * (target > cur ? 0.62 : 0.38);

    // Cross-fade between the idle clip and the flipbook.
    final want = widget.speaking.value ? 1.0 : 0.0;
    _st.talkMix += (want - _st.talkMix) * 0.14;

    // The flipbook's head is static, so add a little life on top.
    _st.sway = math.sin(_elapsed * 0.5) * 0.004;
    _st.bob = math.sin(_elapsed * 0.9) * 0.003 + _st.level * 0.006;
    _st.breathe = (math.sin(_elapsed * 0.85) * 0.5 + 0.5) * 0.008;

    _repaint.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    for (final f in _frames) {
      f.dispose();
    }
    _idle?.dispose();
    super.dispose();
  }

  Widget _idleView(VideoPlayerController c) {
    final s = c.value.size;
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: s.width, height: s.height, child: VideoPlayer(c)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || !_ready) return widget.fallback ?? const SizedBox.expand();
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_idle != null) _idleView(_idle!),
          if (_frames.isNotEmpty)
            RepaintBoundary(
              child: CustomPaint(
                painter: _FlipbookPainter(
                  frames: _frames,
                  state: _st,
                  repaint: _repaint,
                ),
                size: Size.infinite,
              ),
            ),
        ],
      ),
    );
  }
}

/// Mutable per-frame state shared with the painter (avoids rebuilding at 60fps).
class _FrameState {
  double level = 0; // smoothed mouth-open 0..1 → frame index
  double talkMix = 0; // 0 = idle clip, 1 = flipbook
  double sway = 0;
  double bob = 0;
  double breathe = 0;
}

class _FlipbookPainter extends CustomPainter {
  _FlipbookPainter({
    required this.frames,
    required this.state,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<ui.Image> frames;
  final _FrameState state;

  @override
  void paint(Canvas canvas, Size size) {
    if (state.talkMix <= 0.01) return; // idle clip shows through
    final idx = (state.level.clamp(0.0, 1.0) * (frames.length - 1))
        .round()
        .clamp(0, frames.length - 1);
    final img = frames[idx];

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    // Subtle life on the static-head frames.
    canvas.translate(state.sway * size.width, state.bob * size.height);
    final scale = 1.0 + state.breathe;
    canvas.translate(size.width / 2, size.height);
    canvas.scale(scale, scale);
    canvas.translate(-size.width / 2, -size.height);

    final iw = img.width.toDouble();
    final ih = img.height.toDouble();
    final cover = math.max(size.width / iw, size.height / ih);
    final dw = iw * cover;
    final dh = ih * cover;
    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, iw, ih),
      Rect.fromLTWH((size.width - dw) / 2, (size.height - dh) / 2, dw, dh),
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(0, 0, 0, state.talkMix.clamp(0.0, 1.0)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FlipbookPainter oldDelegate) => false;
}
