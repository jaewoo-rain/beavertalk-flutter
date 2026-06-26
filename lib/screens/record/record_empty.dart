import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Empty conversation records — Figma `screen/record_empty` (`2117:20502`).
class RecordEmptyScreen extends StatelessWidget {
  /// Creates the empty-records screen.
  const RecordEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // Centered empty-state copy + CTA (Figma `2296:26201`).
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '아직 통화 기록이 없어요',
                    textAlign: TextAlign.center,
                    style:
                        AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI와 첫 통화를 마치면\n여기에 기록이 쌓여요.',
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '통화하러 가기',
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.callLoading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
