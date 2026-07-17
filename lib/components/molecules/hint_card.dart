import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/normalcall/domain/entities/call_hint.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// In-call hint card — Figma `card/hint` (`3229:56`), states `peek`/`full` ×
/// `suggestion=1|2|3`.
///
/// Controlled: the host owns [revealed] and [index] and reacts to callbacks.
/// - **peek** (`revealed == false`): shows only suggestion 1's Korean line plus
///   an expand affordance — the example detail stays hidden so the learner
///   recalls first. Tapping the card fires [onReveal].
/// - **full** (`revealed == true`): shows the "Hint" header, an `N/3` counter +
///   cycle control ([onCycle] advances 1→2→3, wrapping), and the current
///   example's Korean / romanization / native gloss.
///
/// [onSpeak] is optional; when null the speaker button is hidden (no in-call TTS
/// source is wired yet).
class HintCard extends StatelessWidget {
  const HintCard({
    super.key,
    required this.examples,
    required this.revealed,
    required this.index,
    required this.onReveal,
    required this.onCycle,
    this.onSpeak,
  });

  /// The 1–3 example answers.
  final List<HintExample> examples;

  /// Whether the card is expanded (full) vs collapsed (peek).
  final bool revealed;

  /// Currently shown example index (host clamps/wraps).
  final int index;

  /// Fired when the learner first expands the card (peek → full).
  final VoidCallback onReveal;

  /// Fired to advance to the next example (wraps at the end).
  final VoidCallback onCycle;

  /// Optional: play the current example's audio. Hidden when null.
  final VoidCallback? onSpeak;

  HintExample get _current =>
      examples[index.clamp(0, examples.length - 1)];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final card = Container(
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: revealed ? _full(context, l10n) : _peek(context),
    );

    // In peek the whole card is the reveal target; in full the card itself is
    // inert (its inner controls handle taps).
    if (revealed) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onReveal, child: card),
    );
  }

  Widget _peek(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16, AppSpacing.s12, AppSpacing.s12, AppSpacing.s12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              examples.first.korean,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
            ),
          ),
          if (onSpeak != null) ...[
            const SizedBox(width: AppSpacing.s8),
            _speakButton(context),
          ],
          const SizedBox(width: AppSpacing.s8),
          // Expand affordance: chevron-right rotated to point up (no chevron-up
          // asset). Decorative — the whole card is the tap target.
          Transform.rotate(
            angle: -math.pi / 2,
            child: AppIcons.chevronRight(
                size: 20, color: context.c.labelNormal),
          ),
        ],
      ),
    );
  }

  Widget _full(BuildContext context, AppLocalizations l10n) {
    final ex = _current;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16, AppSpacing.s12, AppSpacing.s16, AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: "Hint" + counter/cycle.
          Row(
            children: [
              // Non-flex: the short "Hint" label must not share flex with the
              // Spacer (that split the row 50/50 and shoved the counter/cycle
              // group left instead of pinning it to the right).
              Text(
                l10n.hintLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    AppType.caption2.sb.copyWith(color: context.c.accentActive),
              ),
              const Spacer(),
              if (examples.length > 1) ...[
                Text('${index + 1}/${examples.length}',
                    style: AppType.caption2.r
                        .copyWith(color: context.c.labelNormal)),
                const SizedBox(width: AppSpacing.s4),
                Semantics(
                  button: true,
                  label: l10n.nextHint,
                  child: InkResponse(
                    onTap: onCycle,
                    radius: 18,
                    child: AppIcons.redo(
                        size: 16, color: context.c.labelNormal),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ex.korean,
                        style: AppType.body1.sb
                            .copyWith(color: context.c.labelStrong)),
                    if (ex.roman != null && ex.roman!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s2),
                      Text(ex.roman!,
                          style: AppType.caption1.r
                              .copyWith(color: context.c.labelNormal)),
                    ],
                    if (ex.native.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s2),
                      Text(ex.native,
                          style: AppType.caption1.r
                              .copyWith(color: context.c.labelNormal)),
                    ],
                  ],
                ),
              ),
              if (onSpeak != null) ...[
                const SizedBox(width: AppSpacing.s8),
                _speakButton(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _speakButton(BuildContext context) {
    return Material(
      color: context.c.backgroundElevatedNormal,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onSpeak,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: AppIcons.volume(size: 20, color: context.c.labelStrong),
          ),
        ),
      ),
    );
  }
}
