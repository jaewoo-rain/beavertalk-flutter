import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

/// Lip-synced video-call avatar.
///
/// Every frame comes from ONE neural clip shot with the head locked in place
/// (measured: mouth-region σ≈18 vs σ≈1.6 everywhere else), so listening,
/// speaking and blinking all share the exact same head — switching between them
/// can never make the head jump.
///
/// - **mouth** — `lip0…lipN` run closed → wide. The live audio envelope is the
///   *target*; the mouth is moved there by a critically-damped spring with a
///   speed limit, and the two nearest frames are blended. That is what keeps it
///   continuous: the mouth travels through the in-between openings instead of
///   teleporting to whichever frame matches the instantaneous loudness.
/// - **response** — the spring tracks the envelope directly (no idle→talk mode
///   cross-fade in the way), so the mouth starts moving the moment audio has
///   energy, and closes as soon as it stops.
/// - **blink** — `lipblink0…` composited through `lipmask.png` (the eye region
///   only), so a blink never disturbs the mouth.
/// - **life** — subtle sway / tilt / breathing on top, since the source head is
///   deliberately static.
class SyncAvatar extends StatefulWidget {
  /// Creates the lip-synced avatar for the frames under [assetDir].
  const SyncAvatar({
    super.key,
    required this.assetDir,
    required this.level,
    required this.speaking,
    this.fallback,
  });

  /// Asset dir holding `lipN.png`, `lipblinkN.png` and `lipmask.png`.
  final String assetDir;

  /// Live mouth-open level, 0 (silent) .. 1 (loud) — the audio envelope.
  final ValueListenable<double> level;

  /// True while the character is speaking (only tunes blink cadence).
  final ValueListenable<bool> speaking;

  /// Shown until the frames are ready (and if they fail to load).
  final Widget? fallback;

  @override
  State<SyncAvatar> createState() => _SyncAvatarState();
}

class _SyncAvatarState extends State<SyncAvatar>
    with SingleTickerProviderStateMixin {
  final List<ui.Image> _lip = [];
  final List<ui.Image> _blink = [];
  ui.Image? _eyeMask;
  bool _ready = false;

  late final Ticker _ticker;
  final _st = _AvatarFrame();
  final _repaint = ValueNotifier<int>(0);
  final _rng = math.Random();

  Duration _last = Duration.zero;
  double _t = 0;
  double _nextBlinkAt = 2.0;
  double _blinkT = -1; // >=0 while a blink plays

  /// Mouth spring: ~45ms settle, critically damped, with a speed cap so a sudden
  /// loud onset still opens fast but never snaps.
  static const double _omega = 22.0;
  static const double _maxVel = 130.0; // frame-index units / second
  static const double _blinkDur = 0.22;

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = createTicker(_tick)..start();
  }

  Future<void> _load() async {
    for (var i = 0; i < 64; i++) {
      final img = await _tryDecode('${widget.assetDir}/lip$i.png');
      if (img == null) break;
      _lip.add(img);
    }
    for (var i = 0; i < 16; i++) {
      final img = await _tryDecode('${widget.assetDir}/lipblink$i.png');
      if (img == null) break;
      _blink.add(img);
    }
    _eyeMask = await _tryDecode('${widget.assetDir}/lipmask.png');
    if (mounted) setState(() => _ready = _lip.length >= 2);
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
    var dt = _last == Duration.zero
        ? 0.016
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (dt > 0.05) dt = 0.05; // guard after a stall
    _t += dt;

    if (_lip.length >= 2) {
      // Envelope → target frame index, reached by a damped spring so the mouth
      // sweeps through the in-between openings (this is the anti-choppiness).
      final target = widget.level.value.clamp(0.0, 1.0) * (_lip.length - 1);
      final accel =
          _omega * _omega * (target - _st.idx) - 2 * _omega * _st.vel;
      _st.vel = (_st.vel + accel * dt).clamp(-_maxVel, _maxVel);
      _st.idx = (_st.idx + _st.vel * dt).clamp(0.0, _lip.length - 1.0);
    }

    // Blink scheduling (a touch rarer while talking).
    if (_blinkT >= 0) {
      _blinkT += dt;
      if (_blinkT > _blinkDur) _blinkT = -1;
    } else if (_t >= _nextBlinkAt) {
      _blinkT = 0;
      final talking = widget.speaking.value;
      _nextBlinkAt =
          _t + (talking ? 4.0 : 2.6) + _rng.nextDouble() * (talking ? 4.0 : 3.0);
    }
    _st.blinkPhase = _blinkT < 0 ? -1 : (_blinkT / _blinkDur).clamp(0.0, 1.0);

    // Life on top of the deliberately static head.
    _st.sway = math.sin(_t * 0.47) * 0.006 + math.sin(_t * 1.13) * 0.0018;
    _st.bob = math.sin(_t * 0.83) * 0.004;
    _st.tilt = math.sin(_t * 0.39) * 0.008;
    _st.breathe = (math.sin(_t * 0.8) * 0.5 + 0.5) * 0.010;

    _repaint.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    for (final i in _lip) {
      i.dispose();
    }
    for (final i in _blink) {
      i.dispose();
    }
    _eyeMask?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return widget.fallback ?? const SizedBox.expand();
    return RepaintBoundary(
      child: CustomPaint(
        painter: _AvatarPainter(
          lip: _lip,
          blink: _blink,
          eyeMask: _eyeMask,
          state: _st,
          repaint: _repaint,
        ),
        size: Size.infinite,
      ),
    );
  }
}

/// Mutable per-frame state shared with the painter (no 60fps widget rebuilds).
class _AvatarFrame {
  double idx = 0; // current mouth frame (fractional)
  double vel = 0; // frame index velocity
  double blinkPhase = -1; // -1 = not blinking, else 0..1 through the blink
  double sway = 0;
  double bob = 0;
  double tilt = 0;
  double breathe = 0;
}

class _AvatarPainter extends CustomPainter {
  _AvatarPainter({
    required this.lip,
    required this.blink,
    required this.eyeMask,
    required this.state,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<ui.Image> lip;
  final List<ui.Image> blink;
  final ui.Image? eyeMask;
  final _AvatarFrame state;

  @override
  void paint(Canvas canvas, Size size) {
    if (lip.isEmpty) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    // Subtle life: sway / bob / tilt / breathing around the lower centre.
    final px = size.width / 2;
    final py = size.height * 0.95;
    canvas.translate(state.sway * size.width, state.bob * size.height);
    canvas.translate(px, py);
    canvas.rotate(state.tilt);
    final s = 1.0 + state.breathe;
    canvas.scale(s, s);
    canvas.translate(-px, -py);

    // Mouth: blend the two frames around the fractional index so the motion is
    // continuous rather than stepping between discrete openings.
    final i = state.idx.floor().clamp(0, lip.length - 1);
    final j = math.min(i + 1, lip.length - 1);
    final f = (state.idx - i).clamp(0.0, 1.0);
    _draw(canvas, lip[i], size, 1.0);
    if (j != i && f > 0) _draw(canvas, lip[j], size, f);

    // Blink: composite only the eye region so the mouth is untouched.
    final bp = state.blinkPhase;
    if (bp >= 0 && blink.isNotEmpty && eyeMask != null) {
      final k = (bp * (blink.length - 1)).round().clamp(0, blink.length - 1);
      canvas.saveLayer(Offset.zero & size, Paint());
      _draw(canvas, blink[k], size, 1.0);
      _draw(canvas, eyeMask!, size, 1.0, blend: BlendMode.dstIn);
      canvas.restore();
    }

    canvas.restore();
  }

  void _draw(Canvas canvas, ui.Image img, Size size, double opacity,
      {BlendMode? blend}) {
    final iw = img.width.toDouble();
    final ih = img.height.toDouble();
    final cover = math.max(size.width / iw, size.height / ih);
    final dw = iw * cover;
    final dh = ih * cover;
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..color = Color.fromRGBO(0, 0, 0, opacity.clamp(0.0, 1.0));
    if (blend != null) paint.blendMode = blend;
    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, iw, ih),
      Rect.fromLTWH((size.width - dw) / 2, (size.height - dh) / 2, dw, dh),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) => false;
}
