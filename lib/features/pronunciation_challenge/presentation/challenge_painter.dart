import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import '../../../theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../domain/challenge_card.dart';
import '../domain/challenge_engine.dart';
import '../domain/game_config.dart';

/// Renders the Pronunciation Challenge simulation into a `1080×1920` space.
///
/// The very first canvas op scales design space to the real widget size
/// (`size.width / 1080`), so every draw call below keeps the web game's verbatim
/// constants. Hosted inside an `AspectRatio(9/16)` so width/height stay in sync.
///
/// Draw order mirrors the web game `render()` (lines 576–586):
/// bg → belt → zone → non-live cards → live cards → flash → HUD → hit-texts.
class ChallengePainter extends CustomPainter {
  /// Creates the painter, repainting whenever [engine]'s controller notifies.
  ChallengePainter({
    required this.engine,
    required Listenable repaint,
    required Color mint,
    required Color background,
    this.cameraActive = false,
    this.micLevel,
  })  : _mint = mint,
        _background = background,
        super(repaint: repaint);

  /// The simulation to render.
  final ChallengeEngine engine;

  /// When `true`, the solid background is skipped so a camera preview behind the
  /// canvas shows through (web `drawCamera` parity).
  final bool cameraActive;

  /// Live mic level (0..1) for the on-screen gauge; `null` hides the gauge.
  /// Read on every frame so the gauge tracks without rebuilding the painter.
  final ValueListenable<double>? micLevel;

  /// Card-colour palette (web game `CARD_COLORS`, line 212). Indexed by
  /// [ChallengeCard.colorIndex]. Length must equal
  /// `CuratedWordSource.paletteSize`.
  static const List<Color> cardColors = <Color>[
    Color(0xFFE4572E),
    Color(0xFF2E86E4),
    Color(0xFF00FFB2),
    Color(0xFFE4B72E),
    Color(0xFFB04FE6),
    Color(0xFFE64F92),
  ];

  /// `Primary/Normal` for the current mode, handed in by the widget — a
  /// painter has no context, and a `static` could only ever hold one mode.
  final Color _mint;

  /// `Background/Normal/Normal` for the current mode — the game canvas fill.
  final Color _background;

  /// Per-(word,colour) laid-out text cache — avoids re-layout every frame.
  static final Map<String, TextPainter> _wordCache = <String, TextPainter>{};

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / GameConfig.w); // design space → widget space

    _drawBackground(canvas);
    _drawBelt(canvas);
    final listening =
        engine.running && engine.frontmostInZoneCard() != null;
    _drawZone(canvas, listening);
    for (final c in engine.cards) {
      if (c.state != CardState.live) _drawCard(canvas, c);
    }
    for (final c in engine.cards) {
      if (c.state == CardState.live) _drawCard(canvas, c);
    }
    _drawFlash(canvas);
    _drawHud(canvas);
    if (micLevel != null && engine.running) _drawMic(canvas);
    _drawHits(canvas);

    canvas.restore();
  }

  // ── background (solid; replaces the web game's camera feed) ─────────
  void _drawBackground(Canvas canvas) {
    // When a camera preview sits behind the canvas, leave the background
    // transparent so the selfie shows through (web `drawCamera` parity).
    if (cameraActive) return;
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, GameConfig.w, GameConfig.h),
      Paint()..color = _background,
    );
  }

  // ── mic level gauge (web drawHUD mic indicator, lines 548–554) ──────
  void _drawMic(Canvas canvas) {
    final level = (micLevel?.value ?? 0).clamp(0.0, 1.0);
    const micY = GameConfig.h - 215;
    const micIconX = GameConfig.w / 2 - 108;
    // Mint mic dot.
    canvas.drawCircle(
      const Offset(micIconX, micY),
      32,
      Paint()..color = _mint.withValues(alpha: 0.9),
    );
    // Level gauge.
    const gw = 190.0;
    const gx = micIconX + 52;
    const gy = micY - 13;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(gx, gy, gw * level, 26),
        const Radius.circular(13),
      ),
      Paint()..color = _mint.withValues(alpha: 0.85),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(gx, gy, gw, 26),
        const Radius.circular(13),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0x40FFFFFF),
    );
  }

  // ── belt (web game drawBelt, 491–503) ──────────────────────────────
  void _drawBelt(Canvas canvas) {
    final top = GameConfig.beltY + GameConfig.cardH / 2 - 20;
    final bot = top + 330;

    // Band.
    canvas.drawRect(
      Rect.fromLTWH(0, top, GameConfig.w, bot - top),
      Paint()..color = const Color(0xFF20262C),
    );

    // Moving diagonal stripes (clipped to the band, minus the front edge).
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, top, GameConfig.w, bot - top - 40));
    final stripe = Paint()
      ..color = const Color(0x0DFFFFFF) // rgba(255,255,255,.05)
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke;
    for (var x = -80 + engine.beltOffset; x < GameConfig.w + 120; x += 80) {
      canvas.drawLine(Offset(x, top - 20), Offset(x - 60, bot), stripe);
    }
    canvas.restore();

    // Red/white front edge.
    final ey = bot - 40;
    final edge = Paint();
    for (var x = -40 + engine.beltOffset * .5;
        x < GameConfig.w + 40;
        x += 56) {
      edge.color = ((x / 56).floor() % 2 == 0)
          ? const Color(0xFFE23B3B)
          : const Color(0xFFF2F2F2);
      canvas.drawRect(Rect.fromLTWH(x, ey, 56, 40), edge);
    }
  }

  // ── judgment zone (dashed; web game drawZone, 504–511) ──────────────
  void _drawZone(Canvas canvas, bool listening) {
    final x = GameConfig.zoneCx - GameConfig.zoneHalf;
    final y = GameConfig.beltY - GameConfig.cardH / 2 - 16;
    final w = GameConfig.zoneHalf * 2;
    final h = GameConfig.cardH + 32;
    final glow = listening
        ? (0.5 + 0.5 * (math.sin(engine.clock * 1000 / 260)).abs())
        : 0.25;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, w, h),
      const Radius.circular(26),
    );
    final base = Path()..addRRect(rrect);
    canvas.drawPath(
      _dashPath(base, const <double>[18, 12]),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = _mint.withValues(alpha: (0.35 + glow * 0.6).clamp(0.0, 1.0)),
    );
  }

  // ── card (web game drawCard, 512–530) ───────────────────────────────
  void _drawCard(Canvas canvas, ChallengeCard c) {
    final cy = c.state == CardState.live ? GameConfig.beltY : c.y;
    final a = c.alpha.clamp(0.0, 1.0);
    canvas.save();
    canvas.translate(c.x, cy);
    if (c.rot != 0) canvas.rotate(c.rot);

    const halfW = GameConfig.cardW / 2;
    const halfH = GameConfig.cardH / 2;

    // Shadow.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-halfW + 8, -halfH + 14, GameConfig.cardW,
            GameConfig.cardH),
        const Radius.circular(22),
      ),
      Paint()..color = Color.fromRGBO(0, 0, 0, 0.35 * a),
    );

    // Wood plank.
    final plank = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-halfW, -halfH, GameConfig.cardW, GameConfig.cardH),
      const Radius.circular(22),
    );
    final grad = ui.Gradient.linear(
      const Offset(0, -halfH),
      const Offset(0, halfH),
      <Color>[
        Color.fromRGBO(0xC8, 0x94, 0x4E, a),
        Color.fromRGBO(0xA9, 0x76, 0x2F, a),
      ],
    );
    canvas.drawRRect(plank, Paint()..shader = grad);
    canvas.drawRRect(
      plank,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Color.fromRGBO(80, 50, 20, 0.5 * a),
    );

    // Grain.
    final grain = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Color.fromRGBO(120, 75, 30, 0.25 * a);
    for (var i = -2; i <= 2; i++) {
      final gy = i * 36.0;
      final path = Path()
        ..moveTo(-halfW + 16, gy)
        ..cubicTo(-20, gy - 10, 20, gy + 10, halfW - 16, gy);
      canvas.drawPath(path, grain);
    }

    // Word (cached layout; alpha via a save-layer when fading).
    final tp = _wordPainter(c.word, c.colorIndex);
    final needLayer = a < 0.999;
    if (needLayer) {
      canvas.saveLayer(
        const Rect.fromLTWH(-halfW, -halfH, GameConfig.cardW, GameConfig.cardH),
        Paint()..color = Color.fromRGBO(255, 255, 255, a),
      );
    }
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2 + 4));
    if (needLayer) canvas.restore();

    canvas.restore();
  }

  TextPainter _wordPainter(String word, int colorIndex) {
    final key = '$word|$colorIndex';
    return _wordCache.putIfAbsent(key, () {
      final tp = TextPainter(
        text: TextSpan(
          text: word,
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 62,
            fontWeight: FontWeight.w800,
            color: cardColors[colorIndex % cardColors.length],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      return tp;
    });
  }

  // ── flash (web game drawFlash, 571–574) ─────────────────────────────
  void _drawFlash(Canvas canvas) {
    const full = Rect.fromLTWH(0, 0, GameConfig.w, GameConfig.h);
    if (engine.flashPass > 0) {
      canvas.drawRect(
        full,
        Paint()
          ..color =
              _mint.withValues(alpha: (engine.flashPass * 0.18).clamp(0.0, 1.0)),
      );
    }
    if (engine.flashMiss > 0) {
      canvas.drawRect(
        full,
        Paint()
          ..color = Color.fromRGBO(
              255, 60, 60, (engine.flashMiss * 0.22).clamp(0.0, 1.0)),
      );
    }
  }

  // ── HUD (timer / score / combo / backlog; web game drawHUD, 531–561) ─
  void _drawHud(Canvas canvas) {
    final mm = (engine.sessionLeft / 60).floor();
    final ss = (engine.sessionLeft % 60).floor();
    final tstr = '$mm:${ss.toString().padLeft(2, '0')}';

    // Timer pill.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(GameConfig.w / 2 - 130, 52, 260, 92),
        const Radius.circular(46),
      ),
      Paint()..color = const Color(0xB80A0E12), // rgba(10,14,18,.72)
    );
    _text(
      canvas,
      tstr,
      x: GameConfig.w / 2,
      y: 100,
      fontSize: 60,
      weight: FontWeight.w800,
      color: engine.sessionLeft <= 10 ? const Color(0xFFFF6B6B) : Colors.white,
    );

    // Score (right aligned).
    _text(
      canvas,
      _thousands(engine.score),
      x: GameConfig.w - 56,
      y: 100,
      fontSize: 46,
      weight: FontWeight.w800,
      color: Colors.white,
      align: _HAlign.right,
    );

    // Combo.
    if (engine.combo > 1) {
      _text(
        canvas,
        'COMBO ×${engine.combo}',
        x: GameConfig.w / 2,
        y: 210,
        fontSize: 48,
        weight: FontWeight.w900,
        color: _mint,
      );
    }

    // Backlog (MISS label + slots).
    _text(
      canvas,
      'MISS',
      x: 56,
      y: GameConfig.h - 70,
      fontSize: 34,
      weight: FontWeight.w800,
      color: const Color(0xFFCFD6DC),
      align: _HAlign.left,
    );
    for (var i = 0; i < GameConfig.maxBacklog; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(170 + i * 54, GameConfig.h - 92, 44, 44),
          const Radius.circular(10),
        ),
        Paint()
          ..color = i < engine.backlog
              ? const Color(0xFFFF5555)
              : const Color(0x33FFFFFF),
      );
    }
  }

  // ── hit texts (web game drawHits, 562–570) ──────────────────────────
  void _drawHits(Canvas canvas) {
    for (final h in engine.hitTexts) {
      final a = h.life.clamp(0.0, 1.0);
      _text(
        canvas,
        h.text,
        x: h.x,
        y: h.y,
        fontSize: 72,
        weight: FontWeight.w900,
        color: (h.miss ? const Color(0xFFFF6B6B) : _mint).withValues(alpha: a),
      );
      if (h.sub.isNotEmpty) {
        _text(
          canvas,
          h.sub,
          x: h.x,
          y: h.y + 58,
          fontSize: 40,
          weight: FontWeight.w800,
          color: Colors.white.withValues(alpha: a),
        );
      }
    }
  }

  // ── helpers ─────────────────────────────────────────────────────────
  void _text(
    Canvas canvas,
    String s, {
    required double x,
    required double y,
    required double fontSize,
    required FontWeight weight,
    required Color color,
    _HAlign align = _HAlign.center,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontFamily: kFontFamily,
          fontSize: fontSize,
          fontWeight: weight,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final double dx;
    switch (align) {
      case _HAlign.left:
        dx = x;
      case _HAlign.center:
        dx = x - tp.width / 2;
      case _HAlign.right:
        dx = x - tp.width;
    }
    tp.paint(canvas, Offset(dx, y - tp.height / 2)); // baseline≈middle
  }

  /// Formats an int with thousands separators (`toLocaleString` parity).
  String _thousands(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  /// Emulates `ctx.setLineDash([on, off])` by extracting dashed sub-paths.
  Path _dashPath(Path source, List<double> pattern) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var dist = 0.0;
      var draw = true;
      var idx = 0;
      while (dist < metric.length) {
        final len = pattern[idx % pattern.length];
        final end = math.min(dist + len, metric.length);
        if (draw) dest.addPath(metric.extractPath(dist, end), Offset.zero);
        dist += len;
        idx++;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant ChallengePainter oldDelegate) =>
      oldDelegate.engine != engine ||
      oldDelegate.cameraActive != cameraActive ||
      oldDelegate.micLevel != micLevel;
}

enum _HAlign { left, center, right }
