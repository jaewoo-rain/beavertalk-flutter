import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../components/chrome/status_bar.dart';
import '../components/chrome/home_indicator.dart';

/// Full-screen shell for every design_app screen. The body fills the real
/// device height inside a [SafeArea] (so the OS status bar / home indicator
/// insets are respected), capped at a 430px-wide phone column that is centred
/// on a dark page for wide/desktop windows.
///
/// The old fixed 375×812 mock frame (and its reserved fake-chrome spacers) was
/// dropped: it scaled the whole UI down when the soft keyboard opened. Now the
/// keyboard resizes the body and each screen's own scroll view handles it.
/// [statusVariant] / [homeVariant] are retained so existing call sites keep
/// compiling, but they no longer affect layout.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.statusVariant = StatusBarVariant.whiteTransparent,
    this.homeVariant = HomeIndicatorVariant.whiteTransparent,
    this.background = AppColors.bg,
  });

  /// Screen content; fills the frame's middle band (between the reserved
  /// status-bar and home-indicator spacers).
  final Widget body;

  /// Retained for call-site compatibility; no longer rendered.
  final StatusBarVariant statusVariant;

  /// Retained for call-site compatibility; no longer rendered.
  final HomeIndicatorVariant homeVariant;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C10),
      // Keep the soft keyboard resizing the body so each screen's own scroll
      // view lifts the focused field above the keyboard (no whole-UI shrink).
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Full-height, phone-width column: fills the real device height and
          // caps width at 430 so wide/desktop windows keep a centred phone
          // column with dark side margins. SafeArea respects the OS insets.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: ColoredBox(
                color: background,
                child: SafeArea(
                  child: SizedBox.expand(child: body),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
