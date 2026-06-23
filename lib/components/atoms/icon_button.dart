import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// AppIconButton — a 40×40 circular, selectable atom.
///
/// Figma component set `176:13875` (IconButton), states `selected` /
/// `unselected`. Renders a short label (e.g. a weekday abbreviation or a single
/// Hangul character) centered on a circular [AppColors.surface2] background.
///
/// Measured from Figma:
/// - 40×40 fixed, `borderRadius` 20 → perfect circle.
/// - Background fill `Semantics/Background/Normal/Alternative` (surface2).
/// - Label uses `MO/Label 1/Normal - Regular` (≈ [AppType.label1] regular).
/// - `selected` → label color [AppColors.primary];
///   `unselected` → label color [AppColors.textSecondary].
///
/// This is a *controlled* atom: it owns no selection state. Pass [selected]
/// and react to [onChanged]. Set [disabled] to make it inert and dimmed.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.label,
    required this.selected,
    this.onChanged,
    this.disabled = false,
  });

  /// The short text shown inside the circle (e.g. "Su", "월", "1").
  final String label;

  /// Whether this button is currently selected.
  final bool selected;

  /// Called with the *toggled* value when tapped. No-op while [disabled].
  final ValueChanged<bool>? onChanged;

  /// When `true` the button is non-interactive and rendered dimmed.
  final bool disabled;

  static const double _size = 40;

  @override
  Widget build(BuildContext context) {
    final Color fg =
        selected ? AppColors.primary : AppColors.textSecondary;

    final Widget circle = Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppType.label1.r.copyWith(color: fg),
      ),
    );

    return Semantics(
      button: true,
      toggled: selected,
      enabled: !disabled,
      label: label,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: (disabled || onChanged == null)
                ? null
                : () => onChanged!(!selected),
            child: circle,
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing every [AppIconButton] state.
class AppIconButtonDemo extends StatefulWidget {
  const AppIconButtonDemo({super.key});

  @override
  State<AppIconButtonDemo> createState() => _AppIconButtonDemoState();
}

class _AppIconButtonDemoState extends State<AppIconButtonDemo> {
  static const _days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final _selected = <int>{1, 3};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Interactive (tap to toggle)',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _days.length; i++)
                AppIconButton(
                  label: _days[i],
                  selected: _selected.contains(i),
                  onChanged: (v) => setState(() {
                    v ? _selected.add(i) : _selected.remove(i);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('States',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              AppIconButton(label: 'Mo', selected: true),
              AppIconButton(label: 'Su', selected: false),
              AppIconButton(label: '월', selected: true, disabled: true),
              AppIconButton(label: '일', selected: false, disabled: true),
            ],
          ),
        ],
      ),
    );
  }
}
