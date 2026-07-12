import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A pill switch measured 1:1 from Figma (`Toggle` set `175:11388`).
///
/// The widget is **controlled**: it never holds its own state. Pass the current
/// [value] and react to user taps via [onChanged]. When [onChanged] is null or
/// [disabled] is true, the toggle is non-interactive and renders its disabled
/// styling.
///
/// Visual spec (measured):
/// * track — 52×28, full pill radius.
/// * thumb — 24px circle, 2px inset, animated between the two ends with
///   [AnimatedAlign].
/// * default (off) — track `surface2` (#252932), thumb white.
/// * selected (on) — track `accentLime` (#429E00), thumb white.
/// * disabled (off) — track `textTertiary` (#777C89), thumb `textSecondary`
///   (#9EA3B2). NOTE: the prompt described the disabled thumb as white, but the
///   measured Figma value is #9EA3B2 — the measured value is used here.
/// * selected-disabled — track `textTertiary`, thumb `textSecondary`.
///
/// When [label] is non-null it is shown to the right with an 8px gap, using
/// Label 1 Regular in white.
class AppToggle extends StatelessWidget {
  /// Creates a pill toggle.
  const AppToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.label,
  });

  /// Whether the toggle is currently on.
  final bool value;

  /// Called with the desired new value when the user taps the toggle.
  ///
  /// If null (or [disabled] is true) the toggle is non-interactive.
  final ValueChanged<bool>? onChanged;

  /// Forces the disabled appearance and blocks interaction, regardless of
  /// [onChanged].
  final bool disabled;

  /// Optional label rendered to the right of the track.
  final String? label;

  static const double _trackW = 52;
  static const double _trackH = 28;
  static const double _thumb = 24;
  static const double _inset = 2;

  bool get _isInteractive => !disabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final Color trackColor;
    final Color thumbColor;
    if (disabled) {
      trackColor = AppColors.textTertiary;
      thumbColor = AppColors.textSecondary;
    } else if (value) {
      trackColor = AppColors.accentLime;
      thumbColor = AppColors.text;
    } else {
      trackColor = AppColors.surface2;
      thumbColor = AppColors.text;
    }

    final Widget track = SizedBox(
      width: _trackW,
      height: _trackH,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(_trackH / 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_inset),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              width: _thumb,
              height: _thumb,
              decoration: BoxDecoration(
                color: thumbColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );

    Widget content = track;
    if (label != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          track,
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label!,
              style: AppType.label1.r.copyWith(color: AppColors.text),
            ),
          ),
        ],
      );
    }

    return Semantics(
      toggled: value,
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

/// Gallery demo exposing every [AppToggle] state.
class ToggleDemo extends StatefulWidget {
  /// Creates the toggle gallery demo.
  const ToggleDemo({super.key});

  @override
  State<ToggleDemo> createState() => _ToggleDemoState();
}

class _ToggleDemoState extends State<ToggleDemo> {
  bool _a = false;
  bool _b = true;

  @override
  Widget build(BuildContext context) {
    Widget row(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppType.label2.m.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Wrap(spacing: 24, runSpacing: 16, children: children),
            const SizedBox(height: 24),
          ],
        );

    return ColoredBox(
      color: AppColors.bg,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            row('interactive', [
              AppToggle(
                value: _a,
                onChanged: (v) => setState(() => _a = v),
                label: '텍스트 내용 텍스트 내용',
              ),
              AppToggle(
                value: _b,
                onChanged: (v) => setState(() => _b = v),
                label: '텍스트 내용 텍스트 내용',
              ),
              AppToggle(value: _a, onChanged: (v) => setState(() => _a = v)),
            ]),
            row('static states', const [
              AppToggle(value: false, label: 'default'),
              AppToggle(value: true, label: 'selected'),
              AppToggle(value: false, disabled: true, label: 'disabled'),
              AppToggle(value: true, disabled: true, label: 'selected-disabled'),
            ]),
          ],
        ),
      ),
    );
  }
}
