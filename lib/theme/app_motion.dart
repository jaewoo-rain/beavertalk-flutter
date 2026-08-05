import 'package:flutter/animation.dart';

/// BeaverTalk motion tokens.
///
/// These are not new inventions — they codify the de-facto scale already used
/// across the component layer, so screens stop hardcoding one-off values:
///
/// * 90ms  — `MicButton` press (`atoms/mic_button.dart`)
/// * 120ms — `InputField` / `OtpInput` / `Dropdown` border+state
/// * 160ms — `Dropdown` expand
/// * 180ms — `Toggle` thumb (`atoms/toggle.dart`)
/// * 350ms — `BlurUpImage` fade-in
///
/// Curve convention, also taken from the existing code: `easeOut` for things
/// entering or responding to a press (fast start, settles gently), `easeInOut`
/// for two-way state changes (toggles, expands) so both directions feel equal.
abstract final class AppMotion {
  /// Press/release feedback. Must stay under ~100ms or the tap feels laggy.
  static const Duration press = Duration(milliseconds: 90);

  /// Small state changes: field borders, selection, checkmarks.
  static const Duration fast = Duration(milliseconds: 120);

  /// Two-way transitions: toggles, expands, cross-fades.
  static const Duration medium = Duration(milliseconds: 180);

  /// Page transitions and larger reveals.
  static const Duration page = Duration(milliseconds: 260);

  /// Content fade-in (images, first paint of loaded data).
  static const Duration slow = Duration(milliseconds: 350);

  /// Entering / responding. Fast start, gentle settle.
  static const Curve enter = Curves.easeOut;

  /// Two-way state changes — symmetric in both directions.
  static const Curve toggle = Curves.easeInOut;

  /// Page transitions. Slightly sharper than [enter] so pushes feel decisive.
  static const Curve pageCurve = Curves.easeOutCubic;

  /// Scale a pressable shrinks to while held. Subtle on purpose: the app's
  /// existing reference (`MicButton`) uses a light squeeze, not a bounce.
  static const double pressScale = 0.96;
}
