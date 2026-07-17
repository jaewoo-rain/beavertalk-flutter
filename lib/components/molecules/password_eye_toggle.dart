import 'package:flutter/material.dart';

import '../../components/icons/app_icons.dart';
import '../../theme/app_color_tokens.dart';

/// Password-field visibility toggle for an [InputField]'s `rightIcon` slot.
///
/// Shows the slashed eye ([AppIcons.eyeOff]) while the text is [obscured] (tap
/// to reveal) and the open eye ([AppIcons.eyeLine]) once visible (tap to hide) —
/// matching Figma (login form = slashed, signup = open). Both are single-colour
/// (#111111) and tinted to `textSecondary` to read on the dark field. [onTap]
/// flips the host field's `obscureText`.
class PasswordEyeToggle extends StatelessWidget {
  /// Creates a password visibility toggle.
  const PasswordEyeToggle({
    super.key,
    required this.obscured,
    required this.onTap,
  });

  /// Whether the field is currently obscured.
  final bool obscured;

  /// Flips the obscure state.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // hidden → slashed eye (eye-off); visible → open eye (eye-line). 20px
      // matches the InputField's icon box (size56). Tinted to textSecondary.
      child: obscured
          ? AppIcons.eyeOff(size: 20, color: context.c.labelNormal)
          : AppIcons.eyeLine(size: 20, color: context.c.labelNormal),
    );
  }
}
