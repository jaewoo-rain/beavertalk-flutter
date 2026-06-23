import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/dim.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Microphone permission denied — Figma `screen/perm_mic_denied`
/// (`2117:20524`).
///
/// A dimmed permission screen with a centered [DialogBasic]
/// (`state=default` → [DialogBasicVariant.twoHorizontal]) explaining the denial.
/// The two secondary buttons are "닫기" (pops the dialog/screen) and
/// "설정으로 이동" (a mock — pops back; would deep-link to OS settings).
///
/// A muted-mic illustration (🔇 stand-in — mock) sits above the dialog as the
/// "빨강 X 일러스트" placeholder.
class MicDeniedScreen extends StatelessWidget {
  /// Creates the mic-denied screen.
  const MicDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Stack(
        children: [
          // Dim scrim over the (blank) underlying screen.
          const Dim(),
          // Red-tinted muted-mic illustration above the dialog (mock).
          Align(
            alignment: const Alignment(0, -0.35),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              alignment: Alignment.center,
              child: const Text('🔇', style: TextStyle(fontSize: 56)),
            ),
          ),
          // The permission dialog.
          Center(
            child: DialogBasic(
              title: '마이크 권한이 필요해요',
              description: 'AI와 통화하려면 마이크 권한을 허용해야 해요. '
                  '설정에서 권한을 켜주세요.',
              variant: DialogBasicVariant.twoHorizontal,
              primary: DialogAction(
                label: '닫기',
                onPressed: () => Navigator.maybePop(context),
              ),
              secondary: DialogAction(
                label: '설정으로 이동',
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
