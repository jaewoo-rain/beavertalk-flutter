import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/app_motion.dart';

/// Wraps arbitrary content in a press response: a subtle scale-down plus a
/// haptic tick on tap.
///
/// Use this for tappable things that a ripple doesn't suit — custom cards,
/// image tiles, icon rows. For standard CTAs prefer `Button`, which already has
/// a Material ripple.
///
/// Why it exists: much of the app is tappable via a raw [GestureDetector] with
/// no feedback at all (home avatar/profile, payment method cards, checkboxes,
/// onboarding select cards), so taps register with no acknowledgement. This
/// mirrors the feel of `MicButton` — the codebase's existing motion reference —
/// rather than introducing a new vocabulary.
///
/// Feedback is skipped automatically when [onTap] is null, so a disabled
/// control does not appear to respond.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = AppMotion.pressScale,
    this.haptic = true,
    this.behavior = HitTestBehavior.opaque,
    this.semanticLabel,
  });

  final Widget child;

  /// Tap handler. When null the widget renders inert — no scale, no haptic.
  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  /// Scale held while pressed. Defaults to [AppMotion.pressScale].
  final double scale;

  /// Fires [HapticFeedback.selectionClick] on tap. Turn off for controls that
  /// already emit their own haptic, to avoid a double tick.
  final bool haptic;

  final HitTestBehavior behavior;

  /// When set, exposes the child as a button to screen readers with this label.
  final String? semanticLabel;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  void _setDown(bool v) {
    if (!_enabled || _down == v) return;
    setState(() => _down = v);
  }

  void _handleTap() {
    final onTap = widget.onTap;
    if (onTap == null) return;
    if (widget.haptic) HapticFeedback.selectionClick();
    onTap();
  }

  void _handleLongPress() {
    final onLongPress = widget.onLongPress;
    if (onLongPress == null) return;
    if (widget.haptic) HapticFeedback.mediumImpact();
    onLongPress();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedScale(
      duration: AppMotion.press,
      curve: AppMotion.enter,
      scale: _down ? widget.scale : 1.0,
      child: widget.child,
    );
    final gesture = GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => _setDown(true),
      onTapUp: (_) => _setDown(false),
      onTapCancel: () => _setDown(false),
      onTap: widget.onTap == null ? null : _handleTap,
      onLongPress: widget.onLongPress == null ? null : _handleLongPress,
      child: content,
    );
    final label = widget.semanticLabel;
    if (label == null) return gesture;
    return Semantics(button: true, label: label, child: gesture);
  }
}
