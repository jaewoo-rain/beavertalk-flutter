import 'package:flutter/widgets.dart';

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

/// 글리프 색을 [AppMotion.medium] 동안 보간해 그린다.
///
/// `AppIcons.*` 는 색을 **인자로** 받아 매번 새 위젯을 만들기 때문에
/// [AnimatedContainer] 같은 암시적 애니메이션이 걸리지 않는다. 그래서 색만
/// 따로 보간해 builder 로 흘려준다.
///
/// 첫 빌드에서는 애니메이션이 없다 — [TweenAnimationBuilder] 가 `begin` 을
/// `end` 로 맞춰 시작하므로 위젯 테스트가 보는 정착 상태는 그대로다.
class AnimatedGlyphColor extends StatelessWidget {
  /// Creates an animated-colour glyph wrapper.
  const AnimatedGlyphColor({
    super.key,
    required this.color,
    required this.builder,
    this.duration = AppMotion.medium,
    this.curve = AppMotion.toggle,
  });

  /// Target colour.
  final Color color;

  /// Builds the glyph with the interpolated colour.
  final Widget Function(Color color) builder;

  /// Transition length.
  final Duration duration;

  /// Transition curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: color),
        duration: duration,
        curve: curve,
        builder: (context, value, _) => builder(value ?? color),
      );
}
