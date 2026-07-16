import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_summary.dart';

/// Learning session summary — Figma `screen/learning_main` (`3569:15065`).
///
/// The whole session at a glance: how many sentences passed and the change from
/// last time, the gauge, 가장 어려웠던 소리, accuracy per phoneme, results per
/// sentence, and the last five sessions as a chart over a table.
///
/// Not to be confused with [LearningSentenceMainScreen], which Figma also calls
/// `screen/learning_main` (`2221:3837`) — that one scores a single sentence and
/// is what the learning flow shows today. This is the session-level redesign,
/// kept as a separate screen (decision, 2026-07-16) so the per-sentence result
/// survives.
///
/// **No entry point yet.** Routed, but nothing navigates here — where a session
/// summary belongs in the flow is an open product question. Until it is
/// answered this screen is unreachable, and nothing in the build will catch
/// that (the pronunciation challenge sat orphaned the same way), so it is
/// called out here.
///
/// **No data source yet.** Everything comes from [mockLearningSummary]; see
/// `learning_summary.dart`.
class LearningCallMainScreen extends StatelessWidget {
  /// Creates the learning session summary screen.
  const LearningCallMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = mockLearningSummary;
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s16,
                AppSpacing.s20,
                AppSpacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _head(l10n, s),
                  const SizedBox(height: AppSpacing.s24),
                  Center(
                    child: PronunciationResult(
                      state: PronunciationState.active,
                      score: s.overall.toDouble(),
                      metrics: [
                        PronunciationMetric(
                          label: l10n.pronunciation,
                          value: '${s.pronunciation}%',
                        ),
                        PronunciationMetric(
                          label: l10n.fluency,
                          value: '${s.fluency}%',
                        ),
                        PronunciationMetric(
                          label: l10n.rhythm,
                          value: '${s.rhythm}%',
                        ),
                      ],
                    ),
                  ),
                  ..._oneFix(l10n, s),
                  ..._phonemes(l10n, s),
                  ..._sentences(l10n, s),
                  ..._trend(l10n, s),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s20),
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.endLearning,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Head (`3569:15077`) — the pass count, then the session date.
  ///
  /// The delta pill that sat beside the count ("지난 세션 +5%") was **deleted
  /// from the frame** on 2026-07-16, and the meta line changed from
  /// "오늘 학습 · 6분 12초" to the date. `screen/learning_main_loading` still
  /// draws the old head; it is the stale one (a loading state cannot hold a
  /// value the loaded state has dropped), so both follow this frame.
  ///
  /// The date renders ISO (`3569:15082` reads `2026-07-16`), which is what the
  /// frame specifies and is unambiguous in all 30 locales — unlike the call
  /// meta line in `analysis.dart`, which is localized via `DateFormat.MMMd`. If
  /// design wants this localized too, it is a one-line change here.
  Widget _head(AppLocalizations l10n, LearningSummary s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learningPassed(s.passed, s.total),
            style: AppType.heading2.b,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            intl.DateFormat('yyyy-MM-dd').format(s.date),
            style: AppType.label2.r.copyWith(color: AppColors.textSecondary),
          ),
        ],
      );

  /// Section/OneFix (`3569:15113`).
  List<Widget> _oneFix(AppLocalizations l10n, LearningSummary s) => _section(
        label: l10n.hardestSound,
        child: _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.hardestSound, style: AppType.headline1.b),
              const SizedBox(height: 10), // no s10 token
              Text(
                s.hardestEvidence,
                style:
                    AppType.caption1.r.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: AppSpacing.s8),
                decoration: BoxDecoration(
                  color: AppColors.primary08,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  s.l1Interference,
                  style: AppType.caption1.r.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      );

  /// Section/Phonemes (`3569:15122`).
  List<Widget> _phonemes(AppLocalizations l10n, LearningSummary s) => _section(
        label: l10n.soundAccuracy,
        trailing: Text(
          l10n.phonemeAttempts(s.phonemeAttempts),
          style: AppType.caption2.r.copyWith(color: AppColors.labelFootnote),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        child: _table(
          header: [
            _Cell.flex(l10n.colSound),
            _Cell.fixed(l10n.colAttempts, 40),
            _Cell.fixed(l10n.colCorrect, 40),
            _Cell.fixed(l10n.colAccuracy, 52),
          ],
          rows: [
            for (final p in s.phonemes)
              [
                _Cell.flex(p.sound, style: _rowName),
                _Cell.fixed('${p.attempts}', 40, style: _rowValue),
                _Cell.fixed('${p.correct}', 40, style: _rowValue),
                _Cell.fixed('${p.accuracy}%', 52,
                    style: _rowEmphasis(_accuracyColor(p.accuracy))),
              ],
          ],
        ),
      );

  /// Section/Sentences (`3569:15156`).
  List<Widget> _sentences(AppLocalizations l10n, LearningSummary s) => _section(
        label: l10n.sentenceResults,
        // Counts the whole session, not the rows shown — the table is a preview
        // and this is the way into the rest.
        trailing: Text(
          l10n.viewAllSentences(s.total),
          style: AppType.caption2.m.copyWith(color: AppColors.primary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        child: _table(
          header: [
            _Cell.flex(l10n.colSentence),
            _Cell.fixed(l10n.colPronunciation, 36),
            _Cell.fixed(l10n.colFluency, 36),
            _Cell.fixed(l10n.colRhythm, 36),
          ],
          rows: [
            for (final x in s.sentences)
              [
                _Cell.flex(x.sentence, style: _rowName),
                _Cell.fixed('${x.pronunciation}', 36, style: _rowValue),
                _Cell.fixed('${x.fluency}', 36, style: _rowValue),
                _Cell.fixed('${x.rhythm}', 36, style: _rowValue),
              ],
          ],
        ),
      );

  /// Section/Trend (`3569:15190`) — the chart, then the same data as a table.
  List<Widget> _trend(AppLocalizations l10n, LearningSummary s) => _section(
        label: l10n.recentSessions(s.sessions.length),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s16,
                  AppSpacing.s16, AppSpacing.s12),
              child: _TrendChart(sessions: s.sessions, l10n: l10n),
            ),
            const SizedBox(height: AppSpacing.s8),
            _table(
              header: [
                _Cell.flex(l10n.colDate),
                _Cell.fixed(l10n.colSentences, 40),
                _Cell.fixed(l10n.colScore, 40),
                _Cell.fixed(l10n.colChange, 48),
              ],
              // Newest first: the chart runs oldest→newest left to right, but a
              // table is read top-down and the latest session is the point.
              rows: [
                for (var i = s.sessions.length - 1; i >= 0; i--)
                  [
                    _Cell.flex(
                      i == s.sessions.length - 1
                          ? l10n.dateToday(s.sessions[i].date)
                          : s.sessions[i].date,
                      style: _rowName,
                    ),
                    _Cell.fixed('${s.sessions[i].sentences}', 40,
                        style: _rowValue),
                    _Cell.fixed('${s.sessions[i].score}', 40, style: _rowValue),
                    _Cell.fixed(
                      s.sessions[i].delta == null
                          ? '—'
                          : _signed(s.sessions[i].delta!),
                      48,
                      style: _rowEmphasis(_deltaColor(s.sessions[i].delta)),
                    ),
                  ],
              ],
            ),
          ],
        ),
      );

  // ── shared shells ─────────────────────────────────────────────────────────

  List<Widget> _section({
    required String label,
    Widget? trailing,
    required Widget child,
  }) =>
      [
        const SizedBox(height: AppSpacing.s24),
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppType.body2.m,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s8),
              // Flexible, not fixed: these sub-labels carry counts ("음소 단위 ·
              // 33회 시도"), and a locale that renders one long enough would push
              // the row off a 320dp screen otherwise.
              Flexible(child: trailing),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        child,
      ];

  Widget _card({required Widget child, EdgeInsets? padding}) => Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: child,
      );

  /// The table shell shared by all three tables (`3569:15126`) — a header row,
  /// then rows split by hairlines.
  Widget _table({
    required List<_Cell> header,
    required List<List<_Cell>> rows,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.s16, 4, AppSpacing.s16, 6),
        child: Column(
          children: [
            _row(header, vertical: 10),
            for (final r in rows) ...[
              // The design's divider is white 7%; `borderSubtle` is 6% — one
              // alpha step apart, indistinguishable on a hairline.
              const Divider(
                  height: 1, thickness: 1, color: AppColors.borderSubtle),
              _row(r, vertical: 11),
            ],
          ],
        ),
      );

  Widget _row(List<_Cell> cells, {required double vertical}) => Padding(
        padding: EdgeInsets.symmetric(vertical: vertical),
        child: Row(
          children: [
            for (var i = 0; i < cells.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.s8),
              cells[i].build(),
            ],
          ],
        ),
      );
}

TextStyle get _headerStyle =>
    AppType.caption2.r.copyWith(color: AppColors.labelFootnote);
TextStyle get _rowName => AppType.label2.m.copyWith(color: AppColors.text);
TextStyle get _rowValue =>
    AppType.label2.r.copyWith(color: AppColors.textSecondary);
TextStyle _rowEmphasis(Color color) => AppType.label2.b.copyWith(color: color);

/// The design's accuracy ramp, read off its four samples: 43% red, 75% amber,
/// 89% and 100% mint. The exact cut-offs are written down nowhere, so these are
/// inferred — revisit if the design ever states them.
Color _accuracyColor(int accuracy) {
  if (accuracy >= 80) return AppColors.primary;
  if (accuracy >= 60) return AppColors.warning;
  return AppColors.negativeAccent;
}

/// A missing delta (the earliest session on record) is not a flat one.
Color _deltaColor(int? delta) {
  if (delta == null) return AppColors.textSecondary;
  if (delta > 0) return AppColors.primary;
  if (delta < 0) return AppColors.negativeAccent;
  return AppColors.textSecondary;
}

/// `+5` / `−3` — an explicit sign either way, with a real minus (U+2212) as the
/// design has it, not a hyphen.
String _signed(int value) => value < 0 ? '−${value.abs()}' : '+$value';

/// One table cell: the flexible name column, or a fixed right-aligned number.
class _Cell {
  const _Cell.flex(this.text, {this.style})
      : width = null,
        _alignRight = false;

  const _Cell.fixed(this.text, double this.width, {this.style})
      : _alignRight = true;

  final String text;
  final double? width;
  final TextStyle? style;
  final bool _alignRight;

  Widget build() {
    final child = Text(
      text,
      style: style ?? _headerStyle,
      textAlign: _alignRight ? TextAlign.right : TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    return width == null
        ? Expanded(child: child)
        : SizedBox(width: width, child: child);
  }
}

/// Card/Trend's plot (`3569:15194`) — a bar per session with its score above and
/// its date below, gridlines at 60/80/100, and the average drawn across.
///
/// Scores plot against a **60–100** window, as the design's gridlines are: bars
/// measure up from the 60 line, not from zero. That exaggerates differences on
/// purpose (the frame's 80 and 97 differ by half the plot height), which is fine
/// for "am I improving" but means the bars are not proportional to the scores.
/// Anything at or below 60 flattens to the baseline rather than inverting.
class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.sessions, required this.l10n});

  final List<SessionPoint> sessions;
  final AppLocalizations l10n;

  static const double _min = 60, _max = 100;

  /// 60→100 spans this many pixels (the design's y 20→120).
  static const double _plotHeight = 100;

  /// Room above the plot for the value labels, and below it for the ticks.
  ///
  /// 26 = the frame's 8 gap + a 14 tick line + 4 slack (`3569:15204` sits at
  /// y128 under a plot whose baseline is y120). With it, the chart is 146 and
  /// the card lands on `Card/Trend`'s 174 once padded.
  static const double _valueRow = 20, _tickRow = 26;

  double _y(num score) =>
      (_max - score.toDouble().clamp(_min, _max)) / (_max - _min) * _plotHeight;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) return const SizedBox.shrink();
    final avg =
        (sessions.fold<int>(0, (a, b) => a + b.score) / sessions.length).round();
    return SizedBox(
      height: _valueRow + _plotHeight + _tickRow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _axis(),
          const SizedBox(width: 6), // no s6 token
          Expanded(
            child: Stack(
              children: [
                _gridlines(),
                _avgLine(avg),
                Row(
                  children: [
                    // Each column takes an equal share rather than a fixed
                    // width: the design's 46 × 5 needs 230px, but a 320dp phone
                    // leaves the plot 222 after the screen padding, the card and
                    // the axis — fixed columns overflow on the narrowest devices
                    // the app supports.
                    for (var i = 0; i < sessions.length; i++)
                      Expanded(
                        child:
                            _bar(sessions[i], isToday: i == sessions.length - 1),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 100 / 80 / 60, each sitting on its gridline.
  Widget _axis() => SizedBox(
        width: 20,
        height: _valueRow + _plotHeight,
        child: Stack(
          children: [
            for (final v in [100, 80, 60])
              Positioned(
                // −7 centres the 14-high line on the 1px rule.
                top: _valueRow + _y(v) - 7,
                right: 0,
                child: Text(
                  '$v',
                  // 10px — under `caption2`'s 11 floor, and the axis has to stay
                  // quieter than the values it labels.
                  style: AppType.caption2.r.copyWith(
                    color: AppColors.labelFootnote,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _gridlines() => Positioned.fill(
        child: Stack(
          children: [
            for (final v in [100, 80, 60])
              Positioned(
                top: _valueRow + _y(v),
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  // 60 is the baseline the bars stand on, so it reads a step
                  // stronger than the two above it.
                  color: v == 60 ? AppColors.border : AppColors.borderSubtle,
                ),
              ),
          ],
        ),
      );

  Widget _avgLine(int avg) => Positioned(
        top: _valueRow + _y(avg),
        left: 0,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 1, color: AppColors.primary35),
            Padding(
              padding: const EdgeInsets.only(left: 2, top: 2),
              child: Text(
                l10n.trendAverage(avg),
                // 9px — the smallest thing on the screen by design; it labels
                // the line without competing with the bars.
                style: AppType.caption2.m
                    .copyWith(color: AppColors.primary, fontSize: 9),
              ),
            ),
          ],
        ),
      );

  Widget _bar(SessionPoint p, {required bool isToday}) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _valueRow + _plotHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  child: Text(
                    '${p.score}',
                    style: isToday
                        ? AppType.caption2.b.copyWith(color: AppColors.text)
                        : AppType.caption2.m
                            .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 2),
                // The bar keeps the design's 34 unless the column is narrower
                // than that, which it can be once five of them share a 320dp
                // plot.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 34),
                  child: Container(
                    width: 34,
                    height: _plotHeight - _y(p.score),
                    decoration: BoxDecoration(
                      // Today is the point of the chart; the rest are context.
                      color: isToday ? AppColors.primary : AppColors.primary22,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                        bottom: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            p.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isToday
                ? AppType.caption2.m.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  )
                : AppType.caption2.r.copyWith(
                    color: AppColors.labelFootnote,
                    fontSize: 10,
                  ),
          ),
        ],
      );
}
