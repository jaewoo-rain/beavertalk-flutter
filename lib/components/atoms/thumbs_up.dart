import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';

/// ThumbsUp — a large selectable "like" atom.
///
/// Figma component set `170:9592` (ThumbsUp), states `active` / `inactive`.
///
/// Measured from Figma:
/// - Outer box 101×112, `borderRadius` 20, padding `28px 24px`, 1px stroke.
/// - Inner circle 56×56 (padding 14, `borderRadius` 9999 / pill), holds a 24×24
///   thumbs-up icon (Figma `thumbs-up` icon → [Icons.thumb_up_outlined]).
/// - `active`   → outer stroke + icon `Primary/Normal`, inner fill
///   `Primary/Primary-10` (`Primary/Normal-10`).
/// - `inactive` → outer stroke + inner fill `Line/Normal/Alternative`
///   (`Line/Alternative`), icon `Label/Normal`.
///
/// Controlled atom: pass [active] and handle [onChanged]; [disabled] dims it.
class ThumbsUp extends StatelessWidget {
  const ThumbsUp({
    super.key,
    required this.active,
    this.onChanged,
    this.disabled = false,
  });

  /// Whether the thumbs-up is currently active (selected).
  final bool active;

  /// Called with the *toggled* value when tapped. No-op while [disabled].
  final ValueChanged<bool>? onChanged;

  /// When `true` the button is non-interactive and rendered dimmed.
  final bool disabled;

  static const double _width = 101;
  static const double _height = 112;
  static const double _innerSize = 56;
  static const double _iconSize = 24;
  static const double _outerRadius = 20;

  @override
  Widget build(BuildContext context) {
    final Color outerStroke =
        active ? context.c.primaryNormal : context.c.lineAlternative;
    final Color innerFill =
        active ? context.c.primaryNormal10 : context.c.lineAlternative;
    final Color iconColor =
        active ? context.c.primaryNormal : context.c.labelNormal;

    final Widget content = Container(
      width: _width,
      height: _height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: outerStroke),
        borderRadius: BorderRadius.circular(_outerRadius),
      ),
      child: Container(
        width: _innerSize,
        height: _innerSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: innerFill,
          shape: BoxShape.circle,
        ),
        child: AppIcons.thumbsUp(
          size: _iconSize,
          color: iconColor,
        ),
      ),
    );

    return Semantics(
      button: true,
      toggled: active,
      enabled: !disabled,
      label: 'Thumbs up',
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_outerRadius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(_outerRadius),
            onTap: (disabled || onChanged == null)
                ? null
                : () => onChanged!(!active),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing every [ThumbsUp] state.
class ThumbsUpDemo extends StatefulWidget {
  const ThumbsUpDemo({super.key});

  @override
  State<ThumbsUpDemo> createState() => _ThumbsUpDemoState();
}

class _ThumbsUpDemoState extends State<ThumbsUpDemo> {
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
          ThumbsUp(
            active: _active,
            onChanged: (v) => setState(() => _active = v),
          ),
          const SizedBox(height: 24),
          Text('States',
              style: TextStyle(color: context.c.labelNormal)),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ThumbsUp(active: true),
              SizedBox(width: 16),
              ThumbsUp(active: false),
              SizedBox(width: 16),
              ThumbsUp(active: true, disabled: true),
            ],
          ),
        ],
      ),
    );
  }
}
