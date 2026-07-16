import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// The waiting state for [LearningCallMainScreen] — Figma
/// `screen/learning_main_loading` (`3583:34469`).
///
/// Mirrors that screen's skeleton, section for section, so the swap costs no
/// reflow: the same head, gauge, 가장 어려웠던 소리 card, and the two tables,
/// with every value a [Skeleton] and only the static labels rendered for real.
///
/// **Not wired to anything.** [LearningCallMainScreen] reads a `const` mock and
/// so never waits — there is nothing to show this *during* yet. It exists
/// because the frame does and because it is the shape the screen will need the
/// moment a real request sits behind it: build it into that screen's `loading:`
/// branch then, and delete this note.
///
/// **This frame is stale and is deliberately not followed in one place.** It
/// still draws the head that `screen/learning_main` (`3569:15065`) has since
/// dropped: a `skeleton-pill` for the delta (`3583:34484`) and the meta line as
/// real `오늘 학습 · 6분 12초` text (`3583:34485`). The loaded frame now shows the
/// pass count over a bare session date and no pill at all — and a loading state
/// cannot hold a value the loaded state has dropped — so the head here follows
/// the loaded frame. Design owes this frame an update.
///
/// One further departure: the frame's trend section is a full chart skeleton
/// (bars at a fixed height, ticks). A bar chart of placeholder bars reads as
/// data — five equal mint columns look like five equal scores — so this holds
/// the card's height with a plain block instead. The tables carry the "rows are
/// coming" signal.
class LearningCallMainLoadingScreen extends StatelessWidget {
  /// Creates the learning-summary loading screen.
  const LearningCallMainLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: SkeletonShimmer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Same padding as the loaded screen.
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20,
                  AppSpacing.s16,
                  AppSpacing.s20,
                  AppSpacing.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Head (3583:34481) ──────────────────────────────
                    // 28 = Heading 2's line box, so the gauge lands where it
                    // will once the headline arrives.
                    const SizedBox(
                      height: 28,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Skeleton.bar(width: 160, height: 20),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    // The session date's line (`3569:15082`), 90 wide for an
                    // ISO `2026-07-16`.
                    const SizedBox(
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Skeleton.bar(width: 90, height: 12),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.s24),
                    Center(
                      child: PronunciationResult(
                        state: PronunciationState.inactive,
                        score: 0,
                        metrics: [
                          PronunciationMetric(
                              label: l10n.pronunciation, value: '-%'),
                          PronunciationMetric(label: l10n.fluency, value: '-%'),
                          PronunciationMetric(label: l10n.rhythm, value: '-%'),
                        ],
                      ),
                    ),

                    // ── Section/OneFix (3583:34516) ────────────────────
                    ..._section(
                      label: l10n.hardestSound,
                      child: _card(
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Skeleton.bar(width: 110, height: 20),
                            SizedBox(height: 10), // no s10 token
                            Skeleton.bar(height: 12),
                            SizedBox(height: AppSpacing.s8),
                            Skeleton.bar(width: 210, height: 12),
                            SizedBox(height: 10),
                            _L1Placeholder(),
                          ],
                        ),
                      ),
                    ),

                    // ── Section/Phonemes (3583:34525) ──────────────────
                    ..._section(
                      label: l10n.soundAccuracy,
                      trailing: const Skeleton.bar(width: 100, height: 12),
                      child: _tableSkeleton(
                        header: [
                          _H.flex(l10n.colSound),
                          _H.fixed(l10n.colAttempts, 40),
                          _H.fixed(l10n.colCorrect, 40),
                          _H.fixed(l10n.colAccuracy, 52),
                        ],
                        // The frame shows four; the real table's row count is
                        // what is loading, so this is a shape, not a promise.
                        rowCount: 4,
                        nameWidths: const [88, 104, 76, 96],
                      ),
                    ),

                    // ── Section/Sentences (3583:34575) ─────────────────
                    ..._section(
                      label: l10n.sentenceResults,
                      trailing: const Skeleton.bar(width: 69, height: 12),
                      child: _tableSkeleton(
                        header: [
                          _H.flex(l10n.colSentence),
                          _H.fixed(l10n.colPronunciation, 36),
                          _H.fixed(l10n.colFluency, 36),
                          _H.fixed(l10n.colRhythm, 36),
                        ],
                        rowCount: 4,
                        nameWidths: const [148, 120, 100, 112],
                        valueWidth: 20,
                      ),
                    ),

                    // ── Section/Trend (3583:34625) ─────────────────────
                    ..._section(
                      // The count is unknown until the sessions land; the frame
                      // labels it 최근 5세션 regardless, which would be a claim.
                      labelWidget: const Skeleton.bar(width: 68, height: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _card(
                            // 142 + the card's 16/16 padding = Card/Trend's 174,
                            // held so the chart drops straight in.
                            child: const SizedBox(
                              height: 142,
                              child: Skeleton.bar(height: 142),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          _tableSkeleton(
                            header: [
                              _H.flex(l10n.colDate),
                              _H.fixed(l10n.colSentences, 40),
                              _H.fixed(l10n.colScore, 40),
                              _H.fixed(l10n.colChange, 48),
                            ],
                            rowCount: 5,
                            nameWidths: const [104, 84, 84, 84, 84],
                            // 26 — the trend rows carry a signed delta, so
                            // their value bars are wider than the other tables'
                            // (`3583:34668`).
                            valueWidth: 26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer/PrimaryAction (3583:34709) — the CTA's slot, held.
            const Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s20),
              child: Skeleton.bar(height: 60),
            ),
          ],
        ),
      ),
    );
  }

  /// The loaded screen's section rhythm (24 above, 8 under the label). Takes
  /// either a real [label] or a [labelWidget] for the one that is itself a
  /// skeleton.
  List<Widget> _section({
    String? label,
    Widget? labelWidget,
    Widget? trailing,
    required Widget child,
  }) =>
      [
        const SizedBox(height: AppSpacing.s24),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: labelWidget ??
                    Text(
                      label!,
                      style: AppType.body2.m,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s8),
              Flexible(child: trailing),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        child,
      ];

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: child,
      );

  /// The loaded screen's table with its cells stubbed. Headers stay real —
  /// 소리 / 시도 / 정확 / 정확도 do not depend on the response.
  Widget _tableSkeleton({
    required List<_H> header,
    required int rowCount,
    required List<double> nameWidths,
    double valueWidth = 22,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.s16, 4, AppSpacing.s16, 6),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  for (var i = 0; i < header.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.s8),
                    header[i].build(),
                  ],
                ],
              ),
            ),
            for (var r = 0; r < rowCount; r++) ...[
              const Divider(
                  height: 1, thickness: 1, color: AppColors.borderSubtle),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  children: [
                    // Varying name widths per row: a column of identical bars
                    // reads as a rendering glitch rather than as text loading.
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Skeleton.bar(
                          width: nameWidths[r % nameWidths.length],
                          height: 12,
                        ),
                      ),
                    ),
                    for (var i = 1; i < header.length; i++) ...[
                      const SizedBox(width: AppSpacing.s8),
                      SizedBox(
                        width: header[i].width,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Skeleton.bar(width: valueWidth, height: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      );
}

/// The L1 box keeps its tint while empty (`3583:34523`) — the reassurance is the
/// shape as much as the words.
class _L1Placeholder extends StatelessWidget {
  const _L1Placeholder();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 33,
        decoration: BoxDecoration(
          color: AppColors.primary08,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
      );
}

/// A real header cell — flexible name column, or a fixed right-aligned one.
class _H {
  const _H.flex(this.text) : width = null;
  const _H.fixed(this.text, double this.width);

  final String text;
  final double? width;

  Widget build() {
    final child = Text(
      text,
      style: AppType.caption2.r.copyWith(color: AppColors.labelFootnote),
      textAlign: width == null ? TextAlign.left : TextAlign.right,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    return width == null
        ? Expanded(child: child)
        : SizedBox(width: width, child: child);
  }
}
