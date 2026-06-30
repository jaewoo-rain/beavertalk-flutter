import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../components/chrome/status_bar.dart';
import '../components/chrome/home_indicator.dart';

/// Device shell for every design_app screen. Centers a 375-wide phone frame on a
/// dark page and hosts the screen body in the middle band of the frame.
///
/// The Figma mockups draw fake OS chrome (a StatusBar at the top and a
/// HomeIndicator at the bottom). The chrome glyphs are no longer rendered
/// (removed per design feedback), but their vertical footprint
/// ([StatusBar.height] top, [HomeIndicator.height] bottom) is preserved as
/// blank space so every screen body keeps the exact region it was laid out for
/// instead of stretching into the old bar areas. [statusVariant] /
/// [homeVariant] are retained so existing call sites keep compiling, but they
/// no longer affect layout.
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
      body: Stack(
        children: [
          Center(
            // Scale the fixed 375×812 phone frame to fit the viewport so the
            // whole screen is always visible (no clipping) on windows shorter
            // than 812 — e.g. the web/desktop preview.
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 375,
                height: 812,
                child: ClipRect(
                  child: Container(
                    color: background,
                    child: Column(
                      children: [
                        // Mock OS chrome removed per design feedback, but its
                        // footprint is kept as blank space so each screen body
                        // stays in the 734px region it was laid out for (no
                        // stretch / shift into the old bar areas).
                        const SizedBox(height: StatusBar.height),
                        Expanded(child: body),
                        const SizedBox(height: HomeIndicator.height),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Debug-only shortcut to the component gallery (in the dark margin).
          if (kDebugMode)
            Positioned(
              top: 12,
              left: 12,
              child: SafeArea(
                child: Material(
                  color: AppColors.surface2,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => Navigator.of(context).pushNamed('/gallery'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text('🎨 Gallery',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
