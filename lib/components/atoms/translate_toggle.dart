import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';

/// TranslateToggle — a 48×48 square outlined button for toggling translation.
///
/// Figma component set `170:9624` (TranslateToggle), states `active` /
/// `inactive`.
///
/// Measured from Figma:
/// - 48×48 fixed, `borderRadius` 8 ([AppRadius.xs]), padding 12, 1px stroke,
///   transparent fill.
/// - 24×24 translate icon (Figma `translate` icon → [Icons.translate]).
/// - `active`   → stroke + icon `Primary/Normal`.
/// - `inactive` → stroke `Line/Normal/Normal` (`Line/Normal`),
///   icon `Label/Normal`.
///
/// Controlled atom: pass [active] and handle [onPressed]; [disabled] dims it.
class TranslateToggle extends StatelessWidget {
  const TranslateToggle({
    super.key,
    required this.active,
    this.onPressed,
    this.disabled = false,
  });

  /// Whether translation is currently active.
  final bool active;

  /// Called with the *toggled* value when tapped. No-op while [disabled].
  final ValueChanged<bool>? onPressed;

  /// When `true` the button is non-interactive and rendered dimmed.
  final bool disabled;

  static const double _size = 48;
  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final Color stroke =
        active ? context.c.primaryNormal : context.c.lineNormal;
    final Color iconColor =
        active ? context.c.primaryNormal : context.c.labelNormal;

    final Widget box = Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: stroke),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: AppIcons.translate(
        size: _iconSize,
        color: iconColor,
      ),
    );

    return Semantics(
      button: true,
      toggled: active,
      enabled: !disabled,
      label: AppLocalizations.of(context).translateLabel,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            onTap: (disabled || onPressed == null)
                ? null
                : () => onPressed!(!active),
            child: box,
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing every [TranslateToggle] state.
class TranslateToggleDemo extends StatefulWidget {
  const TranslateToggleDemo({super.key});

  @override
  State<TranslateToggleDemo> createState() => _TranslateToggleDemoState();
}

class _TranslateToggleDemoState extends State<TranslateToggleDemo> {
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Interactive (tap to toggle)',
              style: TextStyle(color: context.c.labelNormal)),
          const SizedBox(height: 12),
          TranslateToggle(
            active: _active,
            onPressed: (v) => setState(() => _active = v),
          ),
          const SizedBox(height: 24),
          Text('States',
              style: TextStyle(color: context.c.labelNormal)),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TranslateToggle(active: true),
              SizedBox(width: 16),
              TranslateToggle(active: false),
              SizedBox(width: 16),
              TranslateToggle(active: true, disabled: true),
            ],
          ),
        ],
      ),
    );
  }
}
