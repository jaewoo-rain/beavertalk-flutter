import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Call connecting — Figma `screen/call_loading` (`2117:19923`).
///
/// A dark full-screen "연결 중..." state shown while the call is dialing. It
/// renders the [beaverImage] avatar, a [CircularProgressIndicator] spinner, and
/// a status line, with a top-left close button returning to [Routes.home].
///
/// After [_dialDuration] (2.5s) it auto-advances to the live call via
/// `Navigator.pushReplacementNamed(Routes.call)`. The timer is created in
/// [initState] and cancelled in [dispose] so it never fires after teardown.
class CallLoadingScreen extends StatefulWidget {
  /// Creates the call-connecting screen.
  const CallLoadingScreen({super.key});

  @override
  State<CallLoadingScreen> createState() => _CallLoadingScreenState();
}

class _CallLoadingScreenState extends State<CallLoadingScreen> {
  /// How long the faux "dialing" state lasts before the call connects.
  static const Duration _dialDuration = Duration(milliseconds: 2500);

  /// Pending auto-advance timer; cancelled in [dispose].
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_dialDuration, _connect);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Replaces this screen with the live [Routes.call] screen.
  void _connect() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.call);
  }

  /// Cancels dialing and returns home.
  void _cancel() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.bg,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Stack(
        children: [
          // Centered avatar + spinner + status line.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface2,
                    image: DecorationImage(
                      image: beaverImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  mockPartnerName,
                  style: AppType.heading2.sb.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '연결 중...',
                  style: AppType.body1.r
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Top-left close button → home.
          Positioned(
            left: 8,
            top: 8,
            child: IconButton(
              onPressed: _cancel,
              icon: const Icon(Icons.close),
              color: AppColors.text,
              iconSize: 28,
              tooltip: '닫기',
            ),
          ),
        ],
      ),
    );
  }
}
