import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A single tab in a [BottomNavBar].
@immutable
class BottomNavItem {
  /// Creates a nav item.
  ///
  /// [key] identifies the tab (compared against [BottomNavBar.activeKey]).
  /// [icon] is painted at `24×24` for the side tabs and `32×32` for the active
  /// center pill. [label] is optional and used for accessibility.
  const BottomNavItem({
    required this.key,
    required this.icon,
    this.label,
  });

  /// Stable identifier for this tab.
  final String key;

  /// Icon glyph. An [IconData] (Material) or a [BottomNavGlyph] (one of the
  /// Figma-exported nav glyphs).
  final Object icon;

  /// Accessible label for screen readers.
  final String? label;
}

/// The three Figma-exported nav glyphs (`162:4336` / `162:4225` / `162:4307`),
/// usable as [BottomNavItem.icon] without bundling SVG assets.
enum BottomNavGlyph {
  /// `calendar` (`162:4336`).
  calendar,

  /// `call` (`162:4225`) — the center action.
  call,

  /// `history` (`162:4307`).
  history,
}

/// BottomNavBar — BeaverTalk bottom navigation. Figma `03_Organisms /
/// BottomNavBar` (`164:441`).
///
/// Three tabs in a row (gap `40`): left, a glowing **center pill**, and right.
/// The active tab renders as a [AppColors.primary] pill (`68` wide, `18`
/// vertical padding, fully rounded) with a soft mint glow ("Primary Blur",
/// `0 0 32 rgba(0,255,178,0.24)`); inactive icons render at
/// [AppColors.textSecondary].
///
/// Props (per spec): [items] (icon + key), [activeKey], [onTap].
///
/// ```dart
/// BottomNavBar(
///   items: const [
///     BottomNavItem(key: 'calendar', icon: BottomNavGlyph.calendar),
///     BottomNavItem(key: 'call',     icon: BottomNavGlyph.call),
///     BottomNavItem(key: 'history',  icon: BottomNavGlyph.history),
///   ],
///   activeKey: 'call',
///   onTap: (key) => ...,
/// );
/// ```
class BottomNavBar extends StatelessWidget {
  /// Creates a bottom nav bar.
  const BottomNavBar({
    super.key,
    required this.items,
    required this.activeKey,
    this.onTap,
  });

  /// The tabs, left to right.
  final List<BottomNavItem> items;

  /// The [BottomNavItem.key] of the active tab.
  final String activeKey;

  /// Called with the tapped tab's [BottomNavItem.key].
  final ValueChanged<String>? onTap;

  /// Overall bar height (Figma `96`).
  static const double _barHeight = 96;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: _barHeight,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000), // shadow/nav: rgba(0,0,0,0.1)
                blurRadius: 8,
              ),
            ],
          ),
          // Top-aligned per Figma (inner row sits at y=13, height 60).
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const SizedBox(width: 40),
                    _NavTab(
                      item: items[i],
                      active: items[i].key == activeKey,
                      onTap: onTap,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One tab: a `60×60` hit area holding either a side icon or the center pill.
class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool active;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (active) {
      // Center action: a perfect 68×68 primary circle with a mint glow and a
      // 32×32 icon (Figma 162:46508 — 68 wide, 18px vertical padding → 68 tall).
      child = Container(
        width: 68,
        height: 68,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x3D00FFB2), // Primary Blur: rgba(0,255,178,0.24)
              blurRadius: 32,
            ),
          ],
        ),
        child: Center(
          child: _NavIcon(
            icon: item.icon,
            size: 32,
            color: AppColors.onPrimary,
          ),
        ),
      );
    } else {
      // Side tab: 24×24 icon centered in a 60×60 box.
      child = SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: _NavIcon(
            icon: item.icon,
            size: 24,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Semantics(
      button: true,
      selected: active,
      label: item.label ?? item.key,
      child: InkResponse(
        onTap: onTap == null ? null : () => onTap!(item.key),
        radius: 36,
        child: child,
      ),
    );
  }
}

/// Renders a [BottomNavItem.icon]: an [IconData] or a [BottomNavGlyph].
class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.size,
    required this.color,
  });

  final Object icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final glyph = icon;
    if (glyph is IconData) {
      return Icon(glyph, size: size, color: color);
    }
    if (glyph is BottomNavGlyph) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _NavGlyphPainter(glyph, color)),
      );
    }
    return SizedBox(width: size, height: size);
  }
}

/// Paints one of the exported nav glyphs, scaled into [size].
///
/// Path data and source viewBox are taken verbatim from the Figma SVG exports
/// (`162:4336` calendar 24, `162:4225` call 32, `162:4307` history 24).
class _NavGlyphPainter extends CustomPainter {
  const _NavGlyphPainter(this.glyph, this.color);

  final BottomNavGlyph glyph;
  final Color color;

  static const _calendar =
      'M5 22C4.45 22 3.97917 21.8042 3.5875 21.4125C3.19583 21.0208 3 20.55 3 '
      '20V6C3 5.45 3.19583 4.97917 3.5875 4.5875C3.97917 4.19583 4.45 4 5 '
      '4H6V2H8V4H16V2H18V4H19C19.55 4 20.0208 4.19583 20.4125 4.5875C20.8042 '
      '4.97917 21 5.45 21 6V20C21 20.55 20.8042 21.0208 20.4125 21.4125C20.0208 '
      '21.8042 19.55 22 19 22H5ZM5 20H19V10H5V20ZM5 8H19V6H5V8Z';

  static const _call =
      'M26.6 28C23.8222 28 21.0778 27.3944 18.3667 26.1833C15.6556 24.9722 '
      '13.1889 23.2556 10.9667 21.0333C8.74444 18.8111 7.02778 16.3444 5.81667 '
      '13.6333C4.60556 10.9222 4 8.17778 4 5.4C4 5 4.13333 4.66667 4.4 '
      '4.4C4.66667 4.13333 5 4 5.4 4H10.8C11.1111 4 11.3889 4.10556 11.6333 '
      '4.31667C11.8778 4.52778 12.0222 4.77778 12.0667 5.06667L12.9333 '
      '9.73333C12.9778 10.0889 12.9667 10.3889 12.9 10.6333C12.8333 10.8778 '
      '12.7111 11.0889 12.5333 11.2667L9.3 14.5333C9.74444 15.3556 10.2722 '
      '16.15 10.8833 16.9167C11.4944 17.6833 12.1667 18.4222 12.9 '
      '19.1333C13.5889 19.8222 14.3111 20.4611 15.0667 21.05C15.8222 21.6389 '
      '16.6222 22.1778 17.4667 22.6667L20.6 19.5333C20.8 19.3333 21.0611 '
      '19.1833 21.3833 19.0833C21.7056 18.9833 22.0222 18.9556 22.3333 '
      '19L26.9333 19.9333C27.2444 20.0222 27.5 20.1833 27.7 20.4167C27.9 '
      '20.65 28 20.9111 28 21.2V26.6C28 27 27.8667 27.3333 27.6 27.6C27.3333 '
      '27.8667 27 28 26.6 28Z';

  static const _history =
      'M4 20V12H8V20H4ZM10 20V4H14V20H10ZM16 20V9H20V20H16Z';

  double get _viewBox => glyph == BottomNavGlyph.call ? 32.0 : 24.0;

  String get _d {
    switch (glyph) {
      case BottomNavGlyph.calendar:
        return _calendar;
      case BottomNavGlyph.call:
        return _call;
      case BottomNavGlyph.history:
        return _history;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _parsePath(_d);
    final scale = size.width / _viewBox;
    canvas.save();
    canvas.scale(scale);
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NavGlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}

// ── Minimal SVG path parser (absolute M/L/H/V/C/Z) ──────────────
//
// Material icon exports use H/V (horizontal/vertical line-to) in addition to
// M/L/C/Z, so this parser supports those. Kept local to avoid a dependency.
Path _parsePath(String d) {
  final path = Path();
  final tokens = _tokenize(d);
  var i = 0;
  double cx = 0;
  double cy = 0;
  double next() => tokens[i++].value!;

  while (i < tokens.length) {
    final cmd = tokens[i++].cmd!;
    switch (cmd) {
      case 'M':
        cx = next();
        cy = next();
        path.moveTo(cx, cy);
      case 'L':
        cx = next();
        cy = next();
        path.lineTo(cx, cy);
      case 'H':
        cx = next();
        path.lineTo(cx, cy);
      case 'V':
        cy = next();
        path.lineTo(cx, cy);
      case 'C':
        final x1 = next();
        final y1 = next();
        final x2 = next();
        final y2 = next();
        cx = next();
        cy = next();
        path.cubicTo(x1, y1, x2, y2, cx, cy);
      case 'Z':
        path.close();
    }
  }
  return path;
}

class _Token {
  const _Token.cmd(this.cmd) : value = null;
  const _Token.num(this.value) : cmd = null;
  final String? cmd;
  final double? value;
}

List<_Token> _tokenize(String d) {
  final tokens = <_Token>[];
  final buf = StringBuffer();

  void flush() {
    if (buf.isNotEmpty) {
      tokens.add(_Token.num(double.parse(buf.toString())));
      buf.clear();
    }
  }

  const cmds = {'M', 'L', 'H', 'V', 'C', 'Z'};
  for (var k = 0; k < d.length; k++) {
    final ch = d[k];
    if (cmds.contains(ch)) {
      flush();
      tokens.add(_Token.cmd(ch));
    } else if (ch == ' ' || ch == ',' || ch == '\n' || ch == '\t') {
      flush();
    } else if (ch == '-' && buf.isNotEmpty) {
      flush();
      buf.write(ch);
    } else {
      buf.write(ch);
    }
  }
  flush();
  return tokens;
}

/// Gallery demo: BottomNavBar with each tab active in turn.
class BottomNavBarDemo extends StatefulWidget {
  /// Creates the demo.
  const BottomNavBarDemo({super.key});

  @override
  State<BottomNavBarDemo> createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  static const _items = <BottomNavItem>[
    BottomNavItem(
      key: 'calendar',
      icon: BottomNavGlyph.calendar,
      label: 'Calendar',
    ),
    BottomNavItem(key: 'call', icon: BottomNavGlyph.call, label: 'Call'),
    BottomNavItem(
      key: 'history',
      icon: BottomNavGlyph.history,
      label: 'History',
    ),
  ];

  String _active = 'call';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'active: $_active (tap to change)',
                style: AppType.caption1.m
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
          BottomNavBar(
            items: _items,
            activeKey: _active,
            onTap: (key) => setState(() => _active = key),
          ),
        ],
      ),
    );
  }
}
