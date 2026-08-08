import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// Empty alarm list — Figma `screen/alarm_empty` (`2296:26207`). Back-only GNB
/// over a vertically-centered message + "새 일정 추가" CTA.
///
/// The message block used to live here as a public `AlarmEmptyBody` so the
/// alarm list could reuse it. Both are [EmptyScreen] now, so the block is gone.
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
            child: EmptyScreen(
              title: l10n.noAlarms,
              body: l10n.noAlarmsBody,
              ctaText: l10n.addSchedule,
              onCta: () => Navigator.pushNamed(context, Routes.alarmAdd),
            ),
          ),
        ],
      ),
    );
  }
}
