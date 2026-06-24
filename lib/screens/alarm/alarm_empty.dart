import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// The centered "no alarms yet" message block. Reused by both the standalone
/// [AlarmEmptyScreen] and the empty state inside the live [AlarmListScreen].
class AlarmEmptyBody extends StatelessWidget {
  /// Creates the empty-state message block.
  const AlarmEmptyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⏰', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text('등록된 알림이 없어요',
              style: AppType.heading2.sb.copyWith(color: AppColors.text)),
          const SizedBox(height: 8),
          Text('통화 일정을 추가해 꾸준히 대화해보세요',
              style: AppType.body2.r
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// Empty alarm list — Figma `screen/alarm_empty` (`2117:20513`).
class AlarmEmptyScreen extends StatelessWidget {
  /// Creates the empty-alarm screen.
  const AlarmEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '알림', onBack: () => Navigator.pop(context)),
          const Expanded(child: AlarmEmptyBody()),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '새 일정 추가',
                onPressed: () => Navigator.pushNamed(context, Routes.alarmAdd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
