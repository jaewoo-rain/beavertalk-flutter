import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Available render sizes for [AppCheckbox] (the circular box diameter in px).
enum AppCheckboxSize {
  /// 22px box, paired with a Body 2 label.
  size22(22),

  /// 20px box, paired with a Label 1 label.
  size20(20);

  const AppCheckboxSize(this.diameter);

  /// The box diameter in logical pixels.
  final double diameter;
}

/// A circular, controlled checkbox measured 1:1 from Figma
/// (`Checkbox` set `175:11455`).
///
/// The widget is **controlled**: it never holds its own state. Pass the current
/// [value] and react to user taps via [onChanged]. When [onChanged] is null or
/// [disabled] is true, the checkbox is non-interactive and renders its disabled
/// styling.
///
/// Visual spec (measured):
/// * default — fill `surface2` (#252932), 2px border white@12%, no check.
/// * checked — fill `primary10` (#00FFB2 @10%), check stroke `primary` (#00FFB2).
/// * disabled — fill #676E81, 1px border + check stroke #969CAD (no design
///   token exists for these two greys; hex is used — see file-level note).
/// * checked-disabled — fill #676E81, check stroke #969CAD.
///
/// The check mark is drawn with a [CustomPainter] (path `M7 11 L10 14 L15 8`
/// on the 22px artboard, scaled to [size]).
///
/// When [label] is non-null it is shown to the right with an 8px gap, using
/// Body 2 Regular for [AppCheckboxSize.size22] and Label 1 Regular for
/// [AppCheckboxSize.size20]. Both labels render in white.
class AppCheckbox extends StatelessWidget {
  /// Creates a circular checkbox.
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.label,
    this.size = AppCheckboxSize.size22,
  });

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called with the desired new value when the user taps the checkbox.
  ///
  /// If null (or [disabled] is true) the checkbox is non-interactive.
  final ValueChanged<bool>? onChanged;

  /// Forces the disabled appearance and blocks interaction, regardless of
  /// [onChanged].
  final bool disabled;

  /// Optional label rendered to the right of the box.
  final String? label;

  /// The box size (and the matching label typography). Defaults to 22px.
  final AppCheckboxSize size;

  // ── Measured tokens (no AppColors entry exists for these) ──────────────
  // default border: Semantics/Fill/Normal = rgba(255,255,255,0.12)
  static const Color _defaultBorder = Color(0x1FFFFFFF);
  // disabled fill: #676E81 (Figma had no semantic token)
  static const Color _disabledFill = Color(0xFF676E81);
  // disabled border + check: Semantics/Label/Disabled = #969CAD
  static const Color _disabledFg = Color(0xFF969CAD);

  bool get _isInteractive => !disabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final double d = size.diameter;

    // Resolve box styling per state.
    final Color fill;
    final Color? borderColor;
    final Color? checkColor;
    if (disabled) {
      fill = _disabledFill;
      borderColor = value ? null : _disabledFg;
      checkColor = value ? _disabledFg : null;
    } else if (value) {
      fill = context.c.primaryNormal10;
      borderColor = null;
      checkColor = context.c.primaryNormal;
    } else {
      fill = context.c.backgroundNormalAlternative;
      borderColor = _defaultBorder;
      checkColor = null;
    }

    final Widget box = SizedBox(
      width: d,
      height: d,
      child: CustomPaint(
        painter: _CheckboxPainter(
          diameter: d,
          fill: fill,
          borderColor: borderColor,
          checkColor: checkColor,
        ),
      ),
    );

    final TextStyle labelStyle =
        (size == AppCheckboxSize.size22 ? AppType.body2 : AppType.label1)
            .r
            .copyWith(color: context.c.labelStrong);

    Widget content = box;
    if (label != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          box,
          const SizedBox(width: 8),
          Flexible(child: Text(label!, style: labelStyle)),
        ],
      );
    }

    return Semantics(
      checked: value,
      enabled: _isInteractive,
      label: label,
      container: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isInteractive ? () => onChanged!(!value) : null,
        child: content,
      ),
    );
  }
}

/// Paints the circular box and (optionally) the check mark for [AppCheckbox].
class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({
    required this.diameter,
    required this.fill,
    required this.borderColor,
    required this.checkColor,
  });

  final double diameter;
  final Color fill;
  final Color? borderColor;
  final Color? checkColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double r = diameter / 2;
    final Offset center = Offset(r, r);

    // Fill the circle. Inset by half the (1px) border so the stroke sits
    // inside the bounds, matching Figma's centered 0.5px stroke on disabled.
    canvas.drawCircle(center, r, Paint()..color = fill);

    if (borderColor != null) {
      // default uses a 2px-equivalent inner ring (white@12%); disabled uses 1px.
      canvas.drawCircle(
        center,
        r - 0.5,
        Paint()
          ..color = borderColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    if (checkColor != null) {
      // Check path defined on the 22px artboard: M7 11 L10 14 L15 8.
      final double s = diameter / 22.0;
      final Path path = Path()
        ..moveTo(7 * s, 11 * s)
        ..lineTo(10 * s, 14 * s)
        ..lineTo(15 * s, 8 * s);
      canvas.drawPath(
        path,
        Paint()
          ..color = checkColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * s
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_CheckboxPainter old) =>
      old.diameter != diameter ||
      old.fill != fill ||
      old.borderColor != borderColor ||
      old.checkColor != checkColor;
}

/// Gallery demo exposing every [AppCheckbox] state and size.
class CheckboxDemo extends StatefulWidget {
  /// Creates the checkbox gallery demo.
  const CheckboxDemo({super.key});

  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  bool _a = false;
  bool _b = true;
  bool _c = false;
  bool _d = true;

  @override
  Widget build(BuildContext context) {
    Widget row(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppType.label2.m.copyWith(color: context.c.labelNormal)),
            const SizedBox(height: 12),
            Wrap(spacing: 24, runSpacing: 16, children: children),
            const SizedBox(height: 24),
          ],
        );

    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            row('size 22 — interactive', [
              AppCheckbox(
                value: _a,
                onChanged: (v) => setState(() => _a = v),
                label: '텍스트 내용 텍스트 내용',
              ),
              AppCheckbox(
                value: _b,
                onChanged: (v) => setState(() => _b = v),
                label: '텍스트 내용 텍스트 내용',
              ),
              AppCheckbox(value: _a, onChanged: (v) => setState(() => _a = v)),
            ]),
            row('size 22 — static states', const [
              AppCheckbox(value: false, label: 'default'),
              AppCheckbox(value: true, label: 'checked'),
              AppCheckbox(value: false, disabled: true, label: 'disabled'),
              AppCheckbox(value: true, disabled: true, label: 'checked-disabled'),
            ]),
            row('size 20 — interactive', [
              AppCheckbox(
                size: AppCheckboxSize.size20,
                value: _c,
                onChanged: (v) => setState(() => _c = v),
                label: '텍스트 내용 텍스트 내용',
              ),
              AppCheckbox(
                size: AppCheckboxSize.size20,
                value: _d,
                onChanged: (v) => setState(() => _d = v),
                label: '텍스트 내용 텍스트 내용',
              ),
            ]),
            row('size 20 — static states', const [
              AppCheckbox(size: AppCheckboxSize.size20, value: false, label: 'default'),
              AppCheckbox(size: AppCheckboxSize.size20, value: true, label: 'checked'),
              AppCheckbox(
                size: AppCheckboxSize.size20,
                value: false,
                disabled: true,
                label: 'disabled',
              ),
              AppCheckbox(
                size: AppCheckboxSize.size20,
                value: true,
                disabled: true,
                label: 'checked-disabled',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
