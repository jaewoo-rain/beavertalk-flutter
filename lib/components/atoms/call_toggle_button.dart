import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';

/// A 40×40 circular on/off toggle used in the in-call control row — the
/// parametric atom behind both Figma `btn/hint` (`3226:13`) and `btn/subtitle`
/// (`3226:18`).
///
/// Measured from Figma:
/// - 40×40, fully rounded (pill).
/// - **on**  → filled with [activeFill], glyph [AppColors.text] (white).
/// - **off** → transparent, 1px `Line/Neutral` stroke, glyph
///   `Label/Normal`.
///
/// The two instances differ only by [activeFill]: hint = `hintAccent` (orange),
/// subtitle = `surface2`. Controlled: pass [active] and handle [onChanged].
class CallToggleButton extends StatelessWidget {
  const CallToggleButton({
    super.key,
    required this.icon,
    required this.active,
    required this.activeFill,
    required this.semanticLabel,
    this.onChanged,
  });

  /// Glyph builder (e.g. `AppIcons.lightbulb`, `AppIcons.cc`).
  final AppIconBuilder icon;

  /// Whether the toggle is currently on.
  final bool active;

  /// Fill color when [active] (hint → `hintAccent`, subtitle → `surface2`).
  final Color activeFill;

  /// Accessibility label (e.g. 'Hint', 'Subtitle').
  final String semanticLabel;

  /// Called with the *toggled* value when tapped.
  final ValueChanged<bool>? onChanged;

  static const double _size = 40;
  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final Color fill = active ? activeFill : Colors.transparent;
    // Active sits on the coloured [activeFill] and its glyph is always white
    // (staticWhite, not labelStrong — that flips to #000 in Light). Inactive is
    // a transparent chip, so the theme label colour is right there.
    final Color glyph = active ? context.c.staticWhite : context.c.labelNormal;

    return Semantics(
      button: true,
      toggled: active,
      label: semanticLabel,
      child: Material(
        color: fill,
        shape: CircleBorder(
          side: active
              ? BorderSide.none
              : BorderSide(color: context.c.lineNeutral),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onChanged == null ? null : () => onChanged!(!active),
          child: SizedBox(
            width: _size,
            height: _size,
            child: Center(child: icon(size: _iconSize, color: glyph)),
          ),
        ),
      ),
    );
  }
}
