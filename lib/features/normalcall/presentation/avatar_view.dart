import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

/// Emotion codes shared by the controller (transcript classifier) and this
/// renderer. 0 = neutral/smug (the resting face), 1..4 map to sprite files.
const int kEmotionNeutral = 0;
const int kEmotionHappy = 1;
const int kEmotionSurprised = 2;
const int kEmotionSad = 3;
const int kEmotionAngry = 4;

/// Emotion code → sprite file stem within the character's asset dir.
const Map<int, String> _emotionStem = {
  kEmotionHappy: 'e_happy',
  kEmotionSurprised: 'e_surprised',
  kEmotionSad: 'e_sad',
  kEmotionAngry: 'e_angry',
};

/// Returns the avatar sprite asset dir for a character, or null when the
/// character has no rigged sprite set (→ caller falls back to a static image).
///
/// Currently only characters with a generated sprite set under
/// `assets/avatar/<key>/` are listed here; add a key when its sprites ship.
String? avatarAssetDirFor(int? characterId, String? name) {
  final n = (name ?? '').toLowerCase();
  bool has(String k) => n.contains(k);
  if (characterId == 2 || has('baba') || has('비버')) return 'assets/avatar/baba';
  if (has('bibi') || has('비비')) return 'assets/avatar/bibi';
  if (has('dudu') || has('두두')) return 'assets/avatar/dudu';
  if (has('popo') || has('포포')) return 'assets/avatar/popo';
  if (has('rara') || has('라라')) return 'assets/avatar/rara';
  return null;
}

/// Real-time talking-avatar renderer for a call character.
///
/// Design (see docs/2026-07-23_2106_영상통화-아바타-립싱크-플랜.md):
/// Gemini Live returns raw PCM with no viseme/phoneme timing, so the mouth is
/// driven by the audio **envelope** and the expression by the **transcript**.
/// The controller publishes `level` (0=closed..1=wide, from the PCM about to
/// play), `speaking`, and `emotion` (from a keyword classifier on the beaver's
/// line). This widget cross-fades a pre-rendered mouth ramp by `level`, overlays
/// an emotion frame between phrases (it yields to the talking mouth as `level`
/// rises), and adds idle blinks + breathing. Sprites are generated once and ship
/// as static assets, so it runs fully offline at 60fps.
class BeaverAvatar extends StatefulWidget {
  /// Creates the talking avatar for the sprite set under [assetDir].
  const BeaverAvatar({
    super.key,
    required this.assetDir,
    required this.level,
    required this.speaking,
    required this.emotion,
  });

  /// Sprite asset directory, e.g. `assets/avatar/baba` (see [avatarAssetDirFor]).
  final String assetDir;

  /// Live mouth-open target, 0 (closed) .. 1 (wide). ~10Hz; smoothed to 60fps.
  final ValueListenable<double> level;

  /// True while the character is speaking (gates blink cadence).
  final ValueListenable<bool> speaking;

  /// Current emotion code (see the k* constants). Drives the expression overlay.
  final ValueListenable<int> emotion;

  @override
  State<BeaverAvatar> createState() => _BeaverAvatarState();
}

class _BeaverAvatarState extends State<BeaverAvatar>
    with SingleTickerProviderStateMixin {
  final List<ui.Image?> _mouth = List<ui.Image?>.filled(4, null);
  ui.Image? _blink;
  final Map<int, ui.Image> _emotion = {};
  bool _loaded = false;

  late final Ticker _ticker;
  final _painterState = _PainterState();
  final _repaint = ValueNotifier<int>(0);

  final _rng = math.Random();
  Duration _last = Duration.zero;
  double _nextBlinkSec = 2.5;
  double _blinkT = 0;
  double _elapsedSec = 0;

  static const double _blinkDur = 0.14;

  @override
  void initState() {
    super.initState();
    _loadSprites();
    _ticker = createTicker(_onTick)..start();
  }

  Future<void> _loadSprites() async {
    final dir = widget.assetDir;
    for (var i = 0; i < 4; i++) {
      _mouth[i] = await _tryDecode('$dir/v$i.png');
    }
    _blink = await _tryDecode('$dir/blink.png');
    for (final entry in _emotionStem.entries) {
      final img = await _tryDecode('$dir/${entry.value}.png');
      if (img != null) _emotion[entry.key] = img;
    }
    if (mounted) setState(() => _loaded = _mouth[0] != null);
  }

  /// Decodes an asset image, or returns null if it is absent (a character may
  /// ship a partial sprite set — missing frames are simply skipped).
  Future<ui.Image?> _tryDecode(String asset) async {
    try {
      final data = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      return null;
    }
  }

  void _onTick(Duration elapsed) {
    final dt = _last == Duration.zero
        ? 0.016
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _elapsedSec += dt;

    // Smooth the coarse (~10Hz) RMS target into fluid motion; open fast, close
    // a touch slower so the mouth reads as speech, not strobe.
    final target = widget.level.value.clamp(0.0, 1.0);
    final cur = _painterState.level;
    _painterState.level += (target - cur) * (target > cur ? 0.45 : 0.22);

    // Ease the emotion-overlay presence toward the current emotion.
    _painterState.emotion = widget.emotion.value;
    final emoTarget = _painterState.emotion == kEmotionNeutral ? 0.0 : 1.0;
    _painterState.emoPresence +=
        (emoTarget - _painterState.emoPresence) * 0.12;

    // Blink scheduler on a randomized cadence.
    if (_blinkT > 0) {
      _blinkT -= dt;
    } else if (_elapsedSec >= _nextBlinkSec) {
      _blinkT = _blinkDur;
      final speaking = widget.speaking.value;
      _nextBlinkSec = _elapsedSec +
          (speaking ? 3.5 : 2.2) + _rng.nextDouble() * (speaking ? 4.0 : 3.0);
    }
    final bt = (_blinkT / _blinkDur).clamp(0.0, 1.0);
    _painterState.blink = 1.0 - (2.0 * bt - 1.0).abs();

    // Gentle idle breathing.
    _painterState.breathe = math.sin(_elapsedSec * 1.6) * 0.012;

    _repaint.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    for (final im in _mouth) {
      im?.dispose();
    }
    _blink?.dispose();
    for (final im in _emotion.values) {
      im.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.expand();
    return RepaintBoundary(
      child: CustomPaint(
        painter: _BeaverPainter(
          mouth: _mouth,
          blink: _blink,
          emotion: _emotion,
          state: _painterState,
          repaint: _repaint,
        ),
        size: Size.infinite,
      ),
    );
  }
}

/// Mutable frame state shared between the ticker and painter (avoids rebuilding
/// the tree at 60fps; the painter repaints off its [Listenable]).
class _PainterState {
  double level = 0; // smoothed mouth-open 0..1
  double blink = 0; // 0..1 blink envelope
  double breathe = 0; // small +/- scale
  int emotion = 0; // current emotion code
  double emoPresence = 0; // eased 0..1 presence of the emotion overlay
}

class _BeaverPainter extends CustomPainter {
  _BeaverPainter({
    required this.mouth,
    required this.blink,
    required this.emotion,
    required this.state,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<ui.Image?> mouth;
  final ui.Image? blink;
  final Map<int, ui.Image> emotion;
  final _PainterState state;

  @override
  void paint(Canvas canvas, Size size) {
    final level = state.level.clamp(0.0, 1.0);

    final scale = 1.0 + state.breathe;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, scale);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Mouth ramp cross-fade: pos in [0,3], blend frame i → i+1.
    final pos = level * (mouth.length - 1);
    final i = pos.floor().clamp(0, mouth.length - 2);
    final frac = (pos - i).clamp(0.0, 1.0);
    _draw(canvas, mouth[i], size, 1.0);
    if (frac > 0) _draw(canvas, mouth[i + 1], size, frac);

    // Emotion overlay: present between phrases, yields to the talking mouth as
    // the level rises (so active speech shows the lip-synced ramp).
    final emoImg = emotion[state.emotion];
    if (emoImg != null && state.emoPresence > 0.01) {
      final emoAlpha = state.emoPresence * (1.0 - level).clamp(0.0, 1.0);
      if (emoAlpha > 0.01) _draw(canvas, emoImg, size, emoAlpha);
    }

    // Blink on top.
    if (state.blink > 0.01 && blink != null) {
      _draw(canvas, blink, size, state.blink.clamp(0.0, 1.0));
    }

    canvas.restore();
  }

  void _draw(Canvas canvas, ui.Image? img, Size size, double opacity) {
    if (img == null) return;
    final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..color = Color.fromRGBO(0, 0, 0, opacity.clamp(0.0, 1.0));
    canvas.drawImageRect(img, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant _BeaverPainter oldDelegate) => false;
}
