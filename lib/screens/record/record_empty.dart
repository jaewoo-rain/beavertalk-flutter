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
          Gnb.main(title: '대화 기록', onBack: () => Navigator.pop(context)),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💬', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text('아직 대화 기록이 없어요',
                      style: AppType.heading2.sb.copyWith(color: AppColors.text)),
                  const SizedBox(height: 8),
                  Text('비버와 통화하면 여기에 기록돼요',
                      style: AppType.body2.r
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '통화 시작하기',
                onPressed: () => Navigator.pushNamed(context, Routes.callLoading),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
