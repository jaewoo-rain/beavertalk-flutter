import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// SelectBox — a small single-character selectable chip.
///
/// Figma component set `170:9634` (SelectBox): `state` (selected/unselected) ×
/// `weight` (regular/bold).
///
/// Measured from Figma:
/// - Row layout, hug sizing, padding `2px 7px`, `borderRadius` 8 ([AppRadius.xs]).
/// - Label uses `MO/Body 1/*` (≈ [AppType.body1]); `bold` variant is SemiBold
///   (`.sb`), `regular` is `.r`.
/// - Both states share bg `Background/Normal/Alternative` (surface2, #252932);
///   selection is conveyed by the **text color only** (Figma alarm weekday chip):
///   `selected` → text [AppColors.primary], `unselected` → [AppColors.textSecondary].
///
/// Controlled atom: pass [selected] and handle [onChanged]; [disabled] dims it.
class SelectBox extends StatelessWidget {
  const SelectBox({
    super.key,
    required this.label,
    required this.selected,
    this.bold = false,
    this.onChanged,
    this.disabled = false,
    this.expand = false,
  });

  /// The single character shown in the chip (e.g. "T", "S").
  final String label;

  /// Whether this chip is currently selected.
  final bool selected;

  /// Use the SemiBold (`bold`) weight variant when `true`.
  final bool bold;

  /// Called with the *toggled* value when tapped. No-op while [disabled].
  final ValueChanged<bool>? onChanged;

  /// When `true` the chip is non-interactive and rendered dimmed.
  final bool disabled;

  /// When `true` the chip stretches to fill its parent's width (e.g. inside an
  /// [Expanded] cell) instead of hug-sizing to its label — used so a row of
  /// chips renders at identical widths. Defaults to `false` (hug).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    // Figma weekday chip: both states use surface2 (#252932); selection shows
    // via text color only (unselected surfaceElevated was a shade too dark).
    const Color bg = AppColors.surface2;
    final Color fg =
        selected ? AppColors.primary : AppColors.textSecondary;
    final TextStyle base = bold ? AppType.body1.sb : AppType.body1.r;

    final Widget chip = Container(
      width: expand ? double.infinity : null,
      alignment: expand ? Alignment.center : null,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: base.copyWith(color: fg),
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
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
          borderRadius: BorderRadius.circular(AppRadius.xs),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            onTap: (disabled || onChanged == null)
                ? null
                : () => onChanged!(!selected),
            child: chip,
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing every [SelectBox] variant.
class SelectBoxDemo extends StatefulWidget {
  const SelectBoxDemo({super.key});

  @override
  State<SelectBoxDemo> createState() => _SelectBoxDemoState();
}

class _SelectBoxDemoState extends State<SelectBoxDemo> {
  bool _a = true;
  bool _b = false;

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectBox(
                label: 'T',
                selected: _a,
                onChanged: (v) => setState(() => _a = v),
              ),
              const SizedBox(width: 8),
              SelectBox(
                label: 'S',
                bold: true,
                selected: _b,
                onChanged: (v) => setState(() => _b = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('selected × regular/bold',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SelectBox(label: 'T', selected: true),
              SizedBox(width: 8),
              SelectBox(label: 'T', selected: true, bold: true),
            ],
          ),
          const SizedBox(height: 16),
          const Text('unselected × regular/bold',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SelectBox(label: 'S', selected: false),
              SizedBox(width: 8),
              SelectBox(label: 'S', selected: false, bold: true),
            ],
          ),
        ],
      ),
    );
  }
}
