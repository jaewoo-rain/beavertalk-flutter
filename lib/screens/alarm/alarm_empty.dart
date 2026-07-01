import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// The "no alarms yet" message block (title + subtitle). Reused by the
/// standalone [AlarmEmptyScreen] and the empty state inside [AlarmListScreen]
/// (wrap in a [Center] there). Caller positions it.
class AlarmEmptyBody extends StatelessWidget {
  /// Creates the empty-state message block.
  const AlarmEmptyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '등록된 알람이 없어요',
          textAlign: TextAlign.center,
          style: AppType.headline1.sb.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          '학습 리마인더를 추가하면\n꾸준한 습관을 만들 수 있어요.',
          textAlign: TextAlign.center,
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Empty alarm list — Figma `screen/alarm_empty` (`2296:26207`). Back-only GNB
/// over a vertically-centered message + "새 일정 추가" CTA.
class AlarmEmptyScreen extends StatelessWidget {
  /// Creates the empty-alarm screen.
  const AlarmEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AlarmEmptyBody(),
                  const SizedBox(height: AppSpacing.s20),
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '새 일정 추가',
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.alarmAdd),
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
