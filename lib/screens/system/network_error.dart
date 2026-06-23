import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Network error — Figma `screen/network_error` (`2117:20406`).
///
/// A centered error illustration (📡 stand-in for the Figma 3D asset — mock),
/// a "연결에 실패했어요" heading + sub copy. The bottom is the Figma
/// `two-button-row`: a secondary "홈으로" (returns to [Routes.home]) and a
/// primary "다시 시도" (pops back to retry).
class NetworkErrorScreen extends StatelessWidget {
  /// Creates the network error screen.
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error illustration — emoji stand-in for the Figma 3D asset
                  // (mock; no asset bundled).
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    alignment: Alignment.center,
                    child: const Text('📡', style: TextStyle(fontSize: 56)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '연결에 실패했어요',
                    textAlign: TextAlign.center,
                    style: AppType.heading2.sb,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '네트워크 상태를 확인하고\n다시 시도해주세요.',
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    type: BtnType.secondaryOutline,
                    size: BtnSize.s60,
                    text: '홈으로',
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(Routes.home, (r) => false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '다시 시도',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
