import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';

/// Visual variant of [StatusBar].
///
/// Maps 1:1 to the Figma `StatusBar` component set (`160:79547`):
/// `white-bg`, `black-bg`, `black-transparent`, `white-transparent`.
///
/// The `*-bg` variants paint an opaque background; the `*-transparent`
/// variants are background-less (overlay on top of arbitrary content). The
/// `white-*` family uses white content (light text/icons), the `black-*`
/// family uses dark content.
enum StatusBarVariant {
  /// Opaque white background, dark (black) content.
  whiteBg,

  /// Opaque black background, light (white) content.
  blackBg,

  /// Transparent background, dark (black) content.
  blackTransparent,

  /// Transparent background, light (white) content.
  whiteTransparent,
}

/// iOS-style status bar chrome (375×44) measured 1:1 from Figma `160:79547`.
///
/// Shows the time `9:41` on the left and mobile-signal / Wi-Fi / battery
/// glyphs on the right. All glyphs are drawn with [CustomPainter] using the
/// inline vector paths exported from Figma, so they inherit the variant's
/// content color (no asset bundling required).
///
/// Note on radius: the Figma node has no corner radius on the StatusBar
/// itself (unlike [HomeIndicator], which carries a 24px bottom radius).
class StatusBar extends StatelessWidget {
  /// Creates a status bar with the given [variant].
  const StatusBar({super.key, this.variant = StatusBarVariant.blackBg});

  /// The visual style; controls background and content color.
  final StatusBarVariant variant;

  /// Logical frame width from Figma.
  static const double width = 375;

  /// Logical frame height from Figma.
  static const double height = 44;

  /// Background fill, or `null` for the transparent variants.
  Color? _background(BuildContext context) {
    switch (variant) {
      case StatusBarVariant.whiteBg:
        return context.c.staticWhite;
      case StatusBarVariant.blackBg:
        return context.c.commonDarkAndWhite;
      case StatusBarVariant.blackTransparent:
      case StatusBarVariant.whiteTransparent:
        return null;
    }
  }

  /// Content (text + glyph) color derived from the variant.
  Color _content(BuildContext context) {
    switch (variant) {
      case StatusBarVariant.whiteBg:
      case StatusBarVariant.blackTransparent:
        return context.c.commonDarkAndWhite; // dark content
      case StatusBarVariant.blackBg:
      case StatusBarVariant.whiteTransparent:
        return context.c.staticWhite; // light content
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _content(context);
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: _background(context) ?? const Color(0x00000000),
        child: Stack(
          children: [
            // Time "9:41" — Figma group at x:18, y:12; text box 54×20.
            Positioned(
              left: 18,
              top: 12,
              child: SizedBox(
                width: 54,
                height: 20,
                child: Center(
                  child: Text(
                    '9:41',
                    style: TextStyle(
                      // Figma: SF Pro Text Semibold 15 / 20 / -0.0333em.
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 20 / 15,
                      letterSpacing: 15 * -0.0333,
                      color: content,
                    ),
                  ),
                ),
              ),
            ),
            // Right side cluster — Figma group at x:272.67, y:4.33 (66.66×11.34).
            Positioned(
              left: 272.67,
              top: 4.33,
              child: SizedBox(
                width: 66.66,
                height: 11.34,
                child: Stack(
                  children: [
                    // Mobile signal — x:0, y:0.34 (17×10.67).
                    Positioned(
                      left: 0,
                      top: 0.34,
                      child: CustomPaint(
                        size: const Size(17, 10.67),
                        painter: _SignalPainter(content),
                      ),
                    ),
                    // Wi-Fi — x:22.03, y:0 (15.27×10.97).
                    Positioned(
                      left: 22.03,
                      top: 0,
                      child: CustomPaint(
                        size: const Size(15.27, 10.97),
                        painter: _WifiPainter(content),
                      ),
                    ),
                    // Battery — x:42.33, y:0 (24.33×11.33).
                    Positioned(
                      left: 42.33,
                      top: 0,
                      child: CustomPaint(
                        size: const Size(24.33, 11.33),
                        painter: _BatteryPainter(content),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mobile-signal bars glyph (Figma viewBox 17×11), painted in [color].
class _SignalPainter extends CustomPainter {
  const _SignalPainter(this.color);

  /// Glyph fill color.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 17, size.height / 11);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(16, 0)
      ..lineTo(15, 0)
      ..cubicTo(14.4477, 0, 14, 0.447715, 14, 1)
      ..lineTo(14, 9.66667)
      ..cubicTo(14, 10.219, 14.4477, 10.6667, 15, 10.6667)
      ..lineTo(16, 10.6667)
      ..cubicTo(16.5523, 10.6667, 17, 10.219, 17, 9.66667)
      ..lineTo(17, 1)
      ..cubicTo(17, 0.447715, 16.5523, 0, 16, 0)
      ..close()
      // bar 2
      ..moveTo(10.3333, 2.33333)
      ..lineTo(11.3333, 2.33333)
      ..cubicTo(11.8856, 2.33333, 12.3333, 2.78105, 12.3333, 3.33333)
      ..lineTo(12.3333, 9.66667)
      ..cubicTo(12.3333, 10.219, 11.8856, 10.6667, 11.3333, 10.6667)
      ..lineTo(10.3333, 10.6667)
      ..cubicTo(9.78105, 10.6667, 9.33333, 10.219, 9.33333, 9.66667)
      ..lineTo(9.33333, 3.33333)
      ..cubicTo(9.33333, 2.78105, 9.78105, 2.33333, 10.3333, 2.33333)
      ..close()
      // bar 3
      ..moveTo(6.66667, 4.66667)
      ..lineTo(5.66667, 4.66667)
      ..cubicTo(5.11438, 4.66667, 4.66667, 5.11438, 4.66667, 5.66667)
      ..lineTo(4.66667, 9.66667)
      ..cubicTo(4.66667, 10.219, 5.11438, 10.6667, 5.66667, 10.6667)
      ..lineTo(6.66667, 10.6667)
      ..cubicTo(7.21895, 10.6667, 7.66667, 10.219, 7.66667, 9.66667)
      ..lineTo(7.66667, 5.66667)
      ..cubicTo(7.66667, 5.11438, 7.21895, 4.66667, 6.66667, 4.66667)
      ..close()
      // bar 4
      ..moveTo(2, 6.66667)
      ..lineTo(1, 6.66667)
      ..cubicTo(0.447715, 6.66667, 0, 7.11438, 0, 7.66667)
      ..lineTo(0, 9.66667)
      ..cubicTo(0, 10.219, 0.447715, 10.6667, 1, 10.6667)
      ..lineTo(2, 10.6667)
      ..cubicTo(2.55228, 10.6667, 3, 10.219, 3, 9.66667)
      ..lineTo(3, 7.66667)
      ..cubicTo(3, 7.11438, 2.55228, 6.66667, 2, 6.66667)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SignalPainter old) => old.color != color;
}

/// Wi-Fi arcs glyph (Figma viewBox 16×11), painted in [color].
class _WifiPainter extends CustomPainter {
  const _WifiPainter(this.color);

  /// Glyph fill color.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 16, size.height / 11);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(7.66109, 2.28463)
      ..cubicTo(9.88409, 2.28473, 12.0221, 3.13889, 13.6332, 4.67059)
      ..cubicTo(13.7545, 4.78884, 13.9484, 4.78735, 14.0679, 4.66724)
      ..lineTo(15.2276, 3.49684)
      ..cubicTo(15.2881, 3.43592, 15.3218, 3.3534, 15.3213, 3.26755)
      ..cubicTo(15.3208, 3.18169, 15.2861, 3.09958, 15.2249, 3.03937)
      ..cubicTo(10.9963, -1.01312, 4.32519, -1.01312, 0.0965812, 3.03937)
      ..cubicTo(0.0353268, 3.09954, 0.000571828, 3.18163, 0.00000699313, 3.26748)
      ..cubicTo(-0.000557841, 3.35333, 0.033114, 3.43588, 0.0935716, 3.49684)
      ..lineTo(1.25361, 4.66724)
      ..cubicTo(1.37302, 4.78753, 1.56709, 4.78902, 1.68834, 4.67059)
      ..cubicTo(3.29964, 3.13879, 5.43788, 2.28462, 7.66109, 2.28463)
      ..close()
      ..moveTo(7.66109, 6.09247)
      ..cubicTo(8.88248, 6.09239, 10.0603, 6.54637, 10.9657, 7.3662)
      ..cubicTo(11.0881, 7.48256, 11.281, 7.48003, 11.4004, 7.36052)
      ..lineTo(12.5587, 6.19011)
      ..cubicTo(12.6197, 6.12872, 12.6536, 6.04544, 12.6527, 5.9589)
      ..cubicTo(12.6518, 5.87235, 12.6163, 5.78978, 12.5541, 5.72964)
      ..cubicTo(9.79705, 3.16506, 5.52747, 3.16506, 2.77046, 5.72964)
      ..cubicTo(2.70818, 5.78978, 2.67265, 5.8724, 2.67183, 5.95896)
      ..cubicTo(2.67102, 6.04553, 2.70498, 6.12881, 2.76611, 6.19011)
      ..lineTo(3.92415, 7.36052)
      ..cubicTo(4.04352, 7.48003, 4.23642, 7.48256, 4.35887, 7.3662)
      ..cubicTo(5.26363, 6.54692, 6.4405, 6.09297, 7.66109, 6.09247)
      ..close()
      ..moveTo(9.9815, 8.65447)
      ..cubicTo(9.98327, 8.74126, 9.94916, 8.82493, 9.88721, 8.88573)
      ..lineTo(7.88347, 10.9079)
      ..cubicTo(7.82473, 10.9673, 7.74465, 11.0007, 7.66109, 11.0007)
      ..cubicTo(7.57753, 11.0007, 7.49745, 10.9673, 7.43871, 10.9079)
      ..lineTo(5.43464, 8.88573)
      ..cubicTo(5.37273, 8.82488, 5.33868, 8.74118, 5.34051, 8.6544)
      ..cubicTo(5.34235, 8.56762, 5.37991, 8.48543, 5.44434, 8.42726)
      ..cubicTo(6.724, 7.34492, 8.59818, 7.34492, 9.87784, 8.42726)
      ..cubicTo(9.94222, 8.48548, 9.97973, 8.56769, 9.9815, 8.65447)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WifiPainter old) => old.color != color;
}

/// Battery glyph (Figma viewBox 25×12), painted in [color].
///
/// Three parts: the outer shell (35% opacity stroke), the positive nub
/// (40% opacity fill) and the full charge fill (solid).
class _BatteryPainter extends CustomPainter {
  const _BatteryPainter(this.color);

  /// Glyph color (opacity applied per-part to match Figma).
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 25, size.height / 12);

    // Outer shell — stroke at 35% opacity, 1px.
    final shell = Path()
      ..moveTo(2.74066, 0.513811)
      ..lineTo(19.867, 0.513811)
      ..cubicTo(21.0967, 0.513811, 22.0939, 1.51099, 22.0939, 2.74066)
      ..lineTo(22.0939, 8.90638)
      ..cubicTo(22.0937, 10.1359, 21.0966, 11.1322, 19.867, 11.1322)
      ..lineTo(2.74066, 11.1322)
      ..cubicTo(1.5111, 11.1322, 0.513992, 10.1359, 0.513811, 8.90638)
      ..lineTo(0.513811, 2.74066)
      ..lineTo(0.524849, 2.51285)
      ..cubicTo(0.638765, 1.39001, 1.58776, 0.513811, 2.74066, 0.513811)
      ..close();
    canvas.drawPath(
      shell,
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Positive terminal nub — 40% opacity fill.
    final nub = Path()
      ..moveTo(23.6353, 3.76928)
      ..lineTo(23.6353, 7.87977)
      ..cubicTo(24.4622, 7.53163, 25, 6.72177, 25, 5.82452)
      ..cubicTo(25, 4.92727, 24.4622, 4.11742, 23.6353, 3.76928)
      ..close();
    canvas.drawPath(
      nub,
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill,
    );

    // Charge fill — solid.
    final fill = Path()
      ..moveTo(2.05524, 3.18563)
      ..cubicTo(2.05524, 2.56133, 2.56133, 2.05524, 3.18563, 2.05524)
      ..lineTo(19.422, 2.05524)
      ..cubicTo(20.0463, 2.05524, 20.5524, 2.56133, 20.5524, 3.18563)
      ..lineTo(20.5524, 8.46075)
      ..cubicTo(20.5524, 9.08504, 20.0463, 9.59113, 19.422, 9.59113)
      ..lineTo(3.18563, 9.59113)
      ..cubicTo(2.56133, 9.59113, 2.05524, 9.08504, 2.05524, 8.46075)
      ..lineTo(2.05524, 3.18563)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter old) => old.color != color;
}

/// Gallery demo exposing every [StatusBarVariant].
class StatusBarDemo extends StatelessWidget {
  /// Creates the demo.
  const StatusBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const items = <(String, StatusBarVariant)>[
      ('white-bg', StatusBarVariant.whiteBg),
      ('black-bg', StatusBarVariant.blackBg),
      ('black-transparent', StatusBarVariant.blackTransparent),
      ('white-transparent', StatusBarVariant.whiteTransparent),
    ];
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, variant) in items) ...[
              Text(label, style: TextStyle(color: context.c.labelNormal)),
              const SizedBox(height: 6),
              // Checkerboard-ish backdrop so transparent variants are visible.
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.c.backgroundNormalNormal,
                  border: Border.all(color: context.c.lineNeutral),
                ),
                child: StatusBar(variant: variant),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
