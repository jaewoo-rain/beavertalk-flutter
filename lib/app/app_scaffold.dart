import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../components/chrome/status_bar.dart';
import '../components/chrome/home_indicator.dart';

/// Device shell for every design_app screen. Centers a 375-wide phone frame on a
/// dark page and frames the screen body with the OS chrome (StatusBar top,
/// HomeIndicator bottom) — mirroring the Figma frames. Screens supply only the
/// body between the bars; chrome variants default to white content over dark.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.statusVariant = StatusBarVariant.whiteTransparent,
    this.homeVariant = HomeIndicatorVariant.whiteTransparent,
    this.background = AppColors.bg,
  });

  /// Screen content rendered between the status bar and home indicator.
  final Widget body;
  final StatusBarVariant statusVariant;
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
                        StatusBar(variant: statusVariant),
                        Expanded(child: body),
                        HomeIndicator(variant: homeVariant),
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
