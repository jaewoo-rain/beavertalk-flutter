import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
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
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.noAlarms,
          textAlign: TextAlign.center,
          style: AppType.headline1.sb.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          l10n.noAlarmsBody,
          textAlign: TextAlign.center,
          style: AppType.label1.r.copyWith(color: context.c.labelNormal),
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
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
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
                    text: l10n.addSchedule,
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
