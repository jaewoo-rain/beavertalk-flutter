import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
/// **원근 터널 판 (정본 시안 2026-08-31).** Words do not slide sideways on a
/// belt and there are no wooden planks — a word is white text with a thick
/// outline that grows out of the vanishing point straight at the viewer. Draw
/// order mirrors the web game `render()` (lines 1245–1258): camera → tunnel →
/// gate → dying words → live words (far first) → flash → HUD → hit-texts.
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

  /// `Primary/Normal` for the current mode, handed in by the widget — a
  /// painter has no context, and a `static` could only ever hold one mode.
  final Color _mint;

  /// `Background/Normal/Normal` for the current mode — the game canvas fill.
  final Color _background;

  /// Cache of the (outline, fill) text layers, keyed by word, quantised font
  /// size and outline colour.
  ///
  /// The tunnel scales text continuously, so this is bucketed rather than
  /// one-entry-per-word: an unbucketed cache would grow without bound, and
  /// laying the text out every frame would show up on a low-end device.
  static final Map<String, (TextPainter, TextPainter)> _wordCache =
      <String, (TextPainter, TextPainter)>{};

  /// Font-size bucket (design px) for [_wordCache]. 6px steps are below the
  /// eye's threshold at these sizes.
  static const double _kSizeBucket = 6;

  /// Hard cap on [_wordCache] entries, cleared wholesale when exceeded.
  ///
  /// A passing word keeps growing (`k` accelerates past the viewer), so its
  /// font size runs well past the judgment-point 190 and mints a fresh bucket
  /// every 6px on the way out. Without this cap a 30s session leaves behind
  /// four figures' worth of laid-out paragraphs — the exact shape of the
  /// out-of-memory failure this game already hit once on the low-end device.
  static const int _kWordCacheMax = 192;

  /// Above this size a word is on its way out of frame and no longer read, so
  /// it reuses the judgment-point layout scaled by the canvas instead of
  /// laying out a new one.
  static const double _kMaxCachedSize = GameConfig.wordSizeNear;

  /// Word fill / outline colours (web `WORD_FILL` … `WORD_MISS`, lines 350–353).
  static const Color _kWordFill = Color(0xFFFFFFFF); // Static/White
  static const Color _kWordOutline = Color(0xFF0B0F14); // Background/Normal/Deep
  static const Color _kWordLate = Color(0xFFFFB548); // Status/Cautionary-Surface
  static const Color _kWordMiss = Color(0xFFFF7070); // Status/Negative

  /// Opacity of a word at [GameConfig.kSpawn], ramping to 1 at the judgment
  /// point. The design samples it at 50% / 72% / 100%.
  static const double _kFarAlpha = 0.5;

  /// Tunnel wedge / rail spread at the bottom edge (web lines 1116–1124).
  static const double _kRailLeft = -160;
  static const double _kRailRight = 1240;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / GameConfig.w); // design space → widget space

    _drawBackground(canvas);
    _drawTunnel(canvas);
    final listening = engine.running && engine.frontmostInZoneCard() != null;
    _drawGate(canvas, listening);
    // Dying words (pass/miss/grace) go down first, live words on top, far
    // before near. A grace word sits frozen at kMiss for 0.7s and can overlap
    // the follower; this order keeps a dying word off the one being judged.
    for (final c in engine.cards) {
      if (c.state != CardState.live) _drawWord(canvas, c);
    }
    final live = engine.cards.where((c) => c.state == CardState.live).toList()
      ..sort((a, b) => a.k.compareTo(b.k));
    for (final c in live) {
      _drawWord(canvas, c);
    }
    _drawLateChip(canvas);
    _drawFlash(canvas);
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

  // ── tunnel (web drawTunnel, 1110–1136) ──────────────────────────────
  void _drawTunnel(Canvas canvas) {
    const vp = Offset(GameConfig.vpX, GameConfig.vpY);
    // Both gradients run down Y only, matching
    // `ctx.createLinearGradient(0, VP_Y, 0, H)`.
    const gradientRect = Rect.fromLTRB(
      0,
      GameConfig.vpY,
      GameConfig.w,
      GameConfig.h,
    );

    // Floor wedge — fans out from the vanishing point to the bottom edge.
    final wedge = Path()
      ..moveTo(vp.dx, vp.dy)
      ..lineTo(_kRailLeft, GameConfig.h)
      ..lineTo(_kRailRight, GameConfig.h)
      ..close();
    canvas.drawPath(
      wedge,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            _mint.withValues(alpha: 0),
            _mint.withValues(alpha: 0.030),
            _mint.withValues(alpha: 0.085),
          ],
          stops: const <double>[0, 0.6, 1],
        ).createShader(gradientRect),
    );

    // Rails.
    final railPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          _mint.withValues(alpha: 0.04),
          _mint.withValues(alpha: 0.55),
        ],
      ).createShader(gradientRect);
    for (final x2 in const <double>[_kRailLeft, _kRailRight]) {
      canvas.drawLine(vp, Offset(x2, GameConfig.h), railPaint);
    }

    // Rungs — without these the tunnel reads as a still image. They accelerate
    // toward the viewer (quadratic easing = perspective).
    final rung = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (var i = 0; i < 4; i++) {
      final t = ((i / 4) + engine.rungPhase) % 1;
      final e = t * t;
      final y = GameConfig.vpY + (GameConfig.h - GameConfig.vpY) * e;
      final half = 700 * e;
      rung.color = _mint.withValues(alpha: 0.05 + e * 0.11);
      canvas.drawLine(
        Offset(GameConfig.vpX - half, y),
        Offset(GameConfig.vpX + half, y),
        rung,
      );
    }
  }

  // ── gate (web drawGate, 1137–1158) ──────────────────────────────────
  void _drawGate(Canvas canvas, bool listening) {
    final glow = listening
        ? (0.5 + 0.5 * math.sin(engine.clock * 1000 / 260).abs())
        : 0.25;
    const l = GameConfig.gateX;
    const t = GameConfig.gateY;
    const r = GameConfig.gateX + GameConfig.gateW;
    const b = GameConfig.gateY + GameConfig.gateH;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(l, t, GameConfig.gateW, GameConfig.gateH),
        const Radius.circular(32),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = listening ? 5 : 3
        ..color = _mint.withValues(alpha: (0.18 + glow * 0.55).clamp(0.0, 1.0)),
    );

    // Corner brackets. A dashed rectangle was unreadable in a still frame, and
    // the shared clip gets consumed as a thumbnail first.
    final bracket = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = _mint.withValues(alpha: (0.55 + glow * 0.40).clamp(0.0, 1.0));
    const armLen = 70.0;
    for (final corner in const <List<double>>[
      <double>[l, t, 1, 1],
      <double>[r, t, -1, 1],
      <double>[l, b, 1, -1],
      <double>[r, b, -1, -1],
    ]) {
      final cx = corner[0];
      final cy = corner[1];
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + armLen * corner[2], cy),
        bracket,
      );
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx, cy + armLen * corner[3]),
        bracket,
      );
    }

    // Glowing floor line. Canvas `shadowBlur` is roughly twice a Skia blur
    // sigma, so the glow pass uses half the web's value.
    final bw = listening ? 700.0 : 560.0;
    final bh = listening ? 14.0 : 10.0;
    final bar = RRect.fromRectAndRadius(
      Rect.fromLTWH(GameConfig.vpX - bw / 2, b - bh, bw, bh),
      Radius.circular(bh / 2),
    );
    canvas.drawRRect(
      bar,
      Paint()
        ..color = _mint.withValues(alpha: listening ? 0.95 : 0.9)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, listening ? 30 : 17),
    );
    canvas.drawRRect(
      bar,
      Paint()..color = _mint.withValues(alpha: listening ? 0.95 : 0.9),
    );
  }

  // ── word (web drawWord, 1159–1175) ──────────────────────────────────
  //
  // No plank: white fill over a thick dark outline, centred on the vanishing
  // axis. Both size and Y come from `k`.
  void _drawWord(Canvas canvas, ChallengeCard c) {
    final k = math.max(0.02, c.k);
    final size = GameConfig.wordSize(k);
    final y = GameConfig.wordY(k);
    // Depth fade (Figma `screen/pron_play`: 50% far, 72% mid, 100% at the
    // gate). Distance has to read as distance — drawn at full opacity the
    // queue looked like three words stacked, not one approaching.
    final depth = c.state == CardState.live
        ? _kFarAlpha +
            (1 - _kFarAlpha) *
                (((k - GameConfig.kSpawn) /
                        (1 - GameConfig.kSpawn))
                    .clamp(0.0, 1.0))
        : 1.0;
    final a = c.alpha.clamp(0.0, 1.0) *
        depth *
        (c.state == CardState.grace ? 0.55 : 1.0);
    if (a <= 0) return;

    final outlineColor = switch (c.state) {
      CardState.grace => _kWordLate,
      CardState.miss => _kWordMiss,
      _ => _kWordOutline,
    };
    final (outline, fill) = _wordLayers(c.word, size, outlineColor);
    // Past the cache ceiling the layers stop growing, so the canvas carries the
    // rest of the scale. Only a passing word gets here, on its way out of
    // frame, where re-laying-out the glyphs would buy nothing.
    final overshoot = size > _kMaxCachedSize ? size / _kMaxCachedSize : 1.0;

    canvas.save();
    canvas.translate(GameConfig.vpX, y);
    if (overshoot > 1) canvas.scale(overshoot);

    // Layer bounds hug the glyphs plus one font-size of slack (local coords, so
    // the scale above applies to them too). The blur spreads about 3*sigma
    // (= 66*k), which that slack covers. Full-width bounds made every glowing
    // word a 2160px-wide blurred layer — the kind of per-frame cost that shows
    // up on the low-end target device.
    final pad = math.min(size, _kMaxCachedSize);
    final bounds = Rect.fromCenter(
      center: Offset.zero,
      width: outline.width + pad * 2,
      height: outline.height + pad * 2,
    );
    final at = Offset(-outline.width / 2, -outline.height / 2);

    final needLayer = a < 0.999;
    if (needLayer) {
      canvas.saveLayer(
        bounds,
        Paint()..color = Color.fromRGBO(255, 255, 255, a),
      );
    }
    // A word inside the accept range glows — that is the "speak now" cue.
    if (c.state == CardState.live && k >= GameConfig.kAccept) {
      canvas.saveLayer(
        bounds,
        Paint()
          ..imageFilter = ImageFilter.blur(sigmaX: 22 * k, sigmaY: 22 * k),
      );
      outline.paint(canvas, at);
      canvas.restore();
    }
    outline.paint(canvas, at);
    fill.paint(canvas, Offset(-fill.width / 2, -fill.height / 2));
    if (needLayer) canvas.restore();
    canvas.restore();
  }

  /// Builds (and caches) the two text layers for [word] at [size]: a thick
  /// outline in [outlineColor] and the white fill on top.
  ///
  /// Long text wraps to the gate width instead of shrinking, so a learned
  /// **sentence** stays readable at the judgment point.
  (TextPainter, TextPainter) _wordLayers(
    String word,
    double size,
    Color outlineColor,
  ) {
    final fontSize = math.max(
      _kSizeBucket,
      math.min(_kMaxCachedSize, (size / _kSizeBucket).round() * _kSizeBucket),
    );
    final key = '$word|$fontSize|${outlineColor.toARGB32()}';
    if (_wordCache.length > _kWordCacheMax) _wordCache.clear();
    return _wordCache.putIfAbsent(key, () {
      TextPainter make(Paint paint) => TextPainter(
            text: TextSpan(
              text: word,
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                height: 1.15,
                foreground: paint,
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: GameConfig.gateW - 80);
      final outline = make(Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(4, fontSize * 0.085)
        ..strokeJoin = StrokeJoin.round
        ..color = outlineColor);
      final fill = make(Paint()..color = _kWordFill);
      return (outline, fill);
    });
  }

  // ── flash (web drawFlash, 1240–1243) ────────────────────────────────
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
          // 0.45, not the web's 0.22: the design calls for a wash that reads
          // as a miss without erasing the scene (its own 100% did erase it).
          ..color = Color.fromRGBO(
              255, 60, 60, (engine.flashMiss * 0.45).clamp(0.0, 1.0)),
      );
    }
  }

  // ── LATE stamp (Figma `screen/pron_late`) ───────────────────────
  //
  // Sits on the gate's top-left corner while a word is in its grace window.
  // Opaque, not the design's first pass at amber-10% with #111 ink — that was
  // one of the two contrast defects the design run recorded.
  void _drawLateChip(Canvas canvas) {
    final late = engine.cards.any((c) => c.state == CardState.grace);
    if (!late) return;
    final tp = _layout('LATE OK', 34, FontWeight.w900, const Color(0xFF111111));
    final w = tp.width + 40;
    const h = 52.0;
    final rect = Rect.fromLTWH(GameConfig.gateX + 8, GameConfig.gateY - h / 2, w, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()..color = _kWordLate,
    );
    tp.paint(
      canvas,
      Offset(rect.center.dx - tp.width / 2, rect.center.dy - tp.height / 2),
    );
  }



  // ── hit texts (web drawHits, 1231–1239) ─────────────────────────────
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
  TextPainter _layout(
    String s,
    double fontSize,
    FontWeight weight,
    Color color,
  ) =>
      TextPainter(
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
    final tp = _layout(s, fontSize, weight, color);
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

  @override
  bool shouldRepaint(covariant ChallengePainter oldDelegate) =>
      oldDelegate.engine != engine ||
      oldDelegate.cameraActive != cameraActive ||
      oldDelegate.micLevel != micLevel;
}

enum _HAlign { left, center, right }
