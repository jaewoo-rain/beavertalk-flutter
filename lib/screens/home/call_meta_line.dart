import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../components/atoms/skeleton.dart';
import '../../core/format/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// `Baba · 1월 2일 · 10분 37초 · 3번째 통화` — the CallHeader's meta line (3474:459).
///
/// Shared by the analysis screen and the analysis-loading screen so the line
/// sits at the same place in the same type on both: the loading screen fills it
/// in from the call record (`GET /calls/{id}`) before the analysis is done, and
/// the hand-off to the analysis screen must not move it (A4 · 10-03 사용자
/// 「날짜와 통화 시간 초를 먼저 … Loading 일 때 어색해서」).
///
/// Every part is nullable, so the line renders whatever is known and takes no
/// space when nothing is. [durationPending] holds a skeleton where the duration
/// will go — the server writes `total_time` the moment it sees the call end,
/// which can land a beat after the loading screen first asks.
class CallMetaLine extends StatelessWidget {
  /// Creates the meta line.
  const CallMetaLine({
    super.key,
    this.characterName,
    this.callDate,
    this.totalTime,
    this.callSequence,
    this.durationPending = false,
  });

  /// The call partner's name, or null to omit it.
  final String? characterName;

  /// When the call took place (local time), or null to omit it.
  final DateTime? callDate;

  /// Call duration in seconds, or null to omit it.
  final int? totalTime;

  /// The 1-based call count with this partner, or null to omit it.
  final int? callSequence;

  /// Draws a skeleton in the duration's place while it is not known yet.
  final bool durationPending;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final seconds = totalTime;
    final parts = <String>[
      ?characterName,
      // Locale-aware: this line renders in 30 locales. (The old code pinned
      // this to 'en', which printed "Jul 10" inside an otherwise Korean line.)
      if (callDate != null)
        asciiDigits(intl.DateFormat.MMMd(locale).format(callDate!)),
      if (seconds != null && !durationPending)
        l10n.durationMinSec(seconds ~/ 60, seconds % 60),
      if (callSequence != null) l10n.callSequence(callSequence!),
    ];
    if (parts.isEmpty && !durationPending) return const SizedBox.shrink();

    final style = AppType.label2.r.copyWith(color: context.c.labelNeutral);
    return Padding(
      padding: const EdgeInsets.only(top: 6), // no s6 token
      child: !durationPending
          ? Text(parts.join(' · '), style: style)
          // Known parts, then the duration's slot. No fixed height: the text
          // sets it (label2 = 18 at 1.0, taller under a larger text scale — a
          // fixed 18 clipped the date there, i18n_clip_test), and the 14 bar
          // never exceeds it, so the line keeps its height when the number
          // replaces the bar.
          : Row(
              children: [
                if (parts.isNotEmpty) Text('${parts.join(' · ')} · ', style: style),
                const Skeleton.bar(width: 56, height: 14),
              ],
            ),
    );
  }
}
