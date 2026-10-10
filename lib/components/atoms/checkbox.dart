import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
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
/// * default — fill `Background/Normal/Alternative`, 2px `Fill/Normal` border,
///   no check.
/// * checked — fill `Primary/Normal-10`, check stroke `Primary/Normal`.
/// * disabled — fill `Fill/Disabled`, 1px `Line/Disabled` border + check.
/// * checked-disabled — fill `Fill/Disabled`, check stroke `Line/Disabled`.
///
/// The disabled greys used to be hardcoded `#676E81` / `#969CAD` under a note
/// that "no design token exists for these two". **Design has since made them**
/// — `Fill/Disabled` and `Line/Disabled` (`175:11455` binds both) — and the
/// check stroke was the wrong grey: the frame uses `Line/Disabled` (#474C58),
/// not #969CAD.
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

  bool get _isInteractive => !disabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final double d = size.diameter;

    // ⚠ 상태별로 색을 **미리 접지 마라.** `value` 로 한 벌만 고르면 끌 때 목표색이
    //   그 순간 사라져 보간이 성립하지 않고 체크가 한 프레임에 튄다. 켠 팔레트와
    //   끈 팔레트를 둘 다 구해 두고 t 로만 섞는다.
    final Color fillOn;
    final Color fillOff;
    final Color? borderOn;
    final Color? borderOff;
    final Color? checkOn;
    if (disabled) {
      fillOn = fillOff = context.c.fillDisabled;
      borderOn = null;
      borderOff = context.c.lineDisabled;
      checkOn = context.c.lineDisabled;
    } else {
      fillOn = context.c.primaryNormal10;
      fillOff = context.c.backgroundNormalAlternative;
      borderOn = null;
      borderOff = context.c.fillNormal;
      checkOn = context.c.primaryNormal;
    }

    final Widget box = SizedBox(
      width: d,
      height: d,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: value ? 1 : 0),
        duration: AppMotion.medium,
        curve: AppMotion.toggle,
        builder: (context, t, _) => CustomPaint(
          painter: _CheckboxPainter(
            diameter: d,
            fill: Color.lerp(fillOff, fillOn, t)!,
            borderColor: _lerpOrNull(borderOff, borderOn, t),
            checkColor: checkOn,
            checkProgress: t,
          ),
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

/// 두 색을 섞되, 결과가 완전 투명이면 null 로 접는다.
///
/// 테두리는 「없음」이 곧 null 이라, 켜짐↔꺼짐 사이에 한쪽이 null 이면 그 자리를
/// **투명 같은 색**으로 채워야 보간이 성립한다. 다 섞고 나서 알파가 0 이면
/// 다시 null 로 돌려 painter 가 아예 안 그리게 한다.
Color? _lerpOrNull(Color? a, Color? b, double t) {
  final Color fallback =
      (a ?? b ?? const Color(0xFF000000)).withValues(alpha: 0);
  final Color? c = Color.lerp(a ?? fallback, b ?? fallback, t);
  if (c == null || c.a == 0) return null;
  return c;
}

/// Paints the circular box and (optionally) the check mark for [AppCheckbox].
class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({
    required this.diameter,
    required this.fill,
    required this.borderColor,
    required this.checkColor,
    this.checkProgress = 1,
  });

  final double diameter;
  final Color fill;
  final Color? borderColor;
  final Color? checkColor;

  /// 체크 획을 어디까지 그렸는지(0..1). 켜질 때 획이 그어지듯 들어온다.
  final double checkProgress;

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

    if (checkColor != null && checkProgress > 0) {
      // Check path defined on the 22px artboard: M7 11 L10 14 L15 8.
      final double s = diameter / 22.0;
      final Path path = Path()
        ..moveTo(7 * s, 11 * s)
        ..lineTo(10 * s, 14 * s)
        ..lineTo(15 * s, 8 * s);
      // 켜지는 동안에는 획을 앞에서부터 잘라 그린다 — 체크가 그어지듯 들어온다.
      Path drawn = path;
      if (checkProgress < 1) {
        drawn = Path();
        for (final metric in path.computeMetrics()) {
          drawn.addPath(
            metric.extractPath(0, metric.length * checkProgress),
            Offset.zero,
          );
        }
      }
      canvas.drawPath(
        drawn,
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
      old.checkColor != checkColor ||
      old.checkProgress != checkProgress;
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
