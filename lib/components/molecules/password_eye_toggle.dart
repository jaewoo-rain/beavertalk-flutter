import 'package:flutter/material.dart';

import '../../components/icons/app_icons.dart';
import '../../theme/app_color_tokens.dart';
import '../atoms/icon_toggle.dart';

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
    // hidden → slashed eye (eye-off); visible → open eye (eye-line). 20px
    // matches the InputField's icon box (size56). Tinted to textSecondary.
    //
    // 🔴 탭 영역이 20×20 이다(권장 44). 이 위젯이 아니라 [InputField] 가
    //    `rightIcon` 을 `SizedBox(iconSize)` 에 가둬서 생기는 상한이라, 여기서는
    //    못 넓힌다 — 넓히려면 필드의 trailing 폭 배분을 바꿔야 하고 그건 시안 변경이다.
    return IconToggle(
      value: !obscured,
      onIcon: AppIcons.eyeLine,
      offIcon: AppIcons.eyeOff,
      onColor: context.c.labelNormal,
      offColor: context.c.labelNormal,
      size: 20,
      onTap: onTap,
    );
  }
}
