import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';

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
      // Fill the host field's icon box; the SVG scales to it.
      child: SizedBox.expand(
        child: SvgPicture.asset(
          // hidden → slashed eye (eye-off); visible → open eye (eye-line).
          obscured ? AppIcons.eyeOff : AppIcons.eyeLine,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(
            AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
