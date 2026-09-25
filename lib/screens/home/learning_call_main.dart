import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../core/format/dates.dart';
import '../../components/atoms/button.dart';
import '../../components/layout/need_based_rows.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import 'learning_args.dart';
import 'learning_call_main_loading.dart';
import 'learning_summary.dart';
import 'table_columns.dart';

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
/// **Entry point (2026-07-17):** the end of a call review — analysis 복습하기 →
/// learning_intro → learning_next → here, once the last sentence is done. The
/// single-sentence flow (Card-Bookmark 연습하기) still ends on
/// [LearningSentenceMainScreen]; [LearningOrigin] is what splits them.
///
/// **Server-wired.** Reads the [LearningArgs.callId] off the route and fetches
/// `GET /calls/{callId}/pronunciation-report` via [pronunciationReportProvider]
/// ([LearningSummary.fromJson]) — [LearningCallMainLoadingScreen] while it
/// loads, a retry on error. 문장별·통과·최근 세션은 실집계, 소리별 정확도·가장
/// 어려웠던 소리는 아직 서버 목값(음소 채점 모델 도입 전). See `learning_summary.dart`.
/// 문장별 결과를 전부 펼쳤는지.
///
/// 과제는 한 챕터가 40문장이라 표가 화면을 통째로 밀어낸다. 기본은 5줄만 보이고
/// 머리글의 「n개 전체 보기」로 펼친다.
///
/// autoDispose: 화면을 벗어나면 접힌 상태로 돌아간다. 다시 들어왔을 때 펼쳐져
/// 있으면 위쪽 게이지가 안 보인다.
final _sentencesExpandedProvider = StateProvider.autoDispose<bool>((ref) => false);

/// 접었을 때 보여줄 문장 수.
const int _kSentencePreview = 5;

class LearningCallMainScreen extends ConsumerWidget {
  /// Creates the learning session summary screen.
  const LearningCallMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // callId 는 복습 플로우가 LearningArgs 로 실어 온다(callReview origin).
    final args = ModalRoute.of(context)?.settings.arguments;
    final callId = args is LearningArgs ? args.callId : null;
    // 과제도 **이 화면**을 쓴다(2026-09-04 사용자 결정). 통화 리포트와 같은 모양을
    // b2b 가 과제 축으로 내주므로, 어느 축인지에 따라 읽을 곳만 갈린다.
    final assignmentId = args is LearningArgs && args.origin == LearningOrigin.assignment
        ? args.assignmentId
        : null;
    if (callId == null && assignmentId == null) {
      return _errorView(context, l10n, null);
    }
    final report = assignmentId != null
        ? ref.watch(assignmentReportProvider(assignmentId))
        : ref.watch(pronunciationReportProvider(callId!));
    return report.when(
          loading: () => const LearningCallMainLoadingScreen(),
          error: (_, _) => _errorView(
            context,
            l10n,
            () => assignmentId != null
                ? ref.invalidate(assignmentReportProvider(assignmentId))
                : ref.invalidate(pronunciationReportProvider(callId!)),
          ),
          data: (s) => _content(context, ref, l10n, s, callId: callId),
        );
  }

  /// Ends the session: strips every learning screen (intro/report/loading) off
  /// the stack and lands on the entry point (대화 기록 = 전화기록). Stops at the
  /// first non-learning route rather than popping to a hardcoded one, so it
  /// works whichever screen launched the flow.
  void _finish(BuildContext context) =>
      Navigator.popUntil(context, (route) {
        final name = route.settings.name;
        return name != Routes.learningIntro &&
            name != Routes.learningCallMain &&
            name != Routes.learningCallMainLoading;
      });

  /// Error state — a message and, when recoverable, a retry that refetches.
  ///
  /// The GNB is the point of this branch. Without it there was no way out at
  /// all when [onRetry] is null (a missing `callId`): the retry button is the
  /// only other control and it does not render in that case, so the screen was
  /// a dead end. Back runs [_finish] for the same reason the footer does —
  /// popping one step would land on the learning screens this flow is done
  /// with.
  Widget _errorView(
    BuildContext context,
    AppLocalizations l10n,
    VoidCallback? onRetry,
  ) {
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(onBack: () => _finish(context)),
          Expanded(
            child: NetworkErrorView(
              message: l10n.analysisFailed,
              onRetry: onRetry,
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, AppLocalizations l10n,
      LearningSummary s, {int? callId}) {
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        // The footer CTA is full-width (fill). Without this the Column defaults
        // to CrossAxisAlignment.center and the Button — which has no width of
        // its own (Row/mainAxisSize.min) — hugs its label and floats centred.
        // The inner scroll Column already stretches, which is why the footer
        // read as correct on review. Same failure `avatar_detail._footer`
        // documents ("Use This" rendered ~260px wide instead of the gutters).
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Untitled: the frame defines no title for this screen, so the GNB
          // is a back affordance only. Same unwind as the footer below.
          Gnb.main(onBack: () => _finish(context)),
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
                  _head(context, l10n, s),
                  const SizedBox(height: AppSpacing.s24),
                  Center(
                    child: PronunciationResult(
                      state: PronunciationState.active,
                      score: s.overall.toDouble(),
                      metrics: [
                        PronunciationMetric(
                          label: l10n.pronunciation,
                          value: '${s.pronunciation}%',
                          score: s.pronunciation,
                        ),
                        PronunciationMetric(
                          label: l10n.fluency,
                          value: '${s.fluency}%',
                          score: s.fluency,
                        ),
                        PronunciationMetric(
                          label: l10n.rhythm,
                          value: '${s.rhythm}%',
                          score: s.rhythm,
                        ),
                      ],
                    ),
                  ),
                  ..._oneFix(context, l10n, s),
                  ..._phonemes(context, l10n, s),
                  ..._sentences(context, ref, l10n, s),
                  ..._trend(context, l10n, s, callId: callId),
                ],
              ),
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(bottom: AppSpacing.s20),
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.endLearning,
              onPressed: () => _finish(context),
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
  Widget _head(BuildContext context, AppLocalizations l10n, LearningSummary s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learningPassed(s.passed, s.total),
            style: AppType.heading2.b,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            intl.DateFormat('yyyy-MM-dd').format(s.date),
            style: AppType.label2.r.copyWith(color: context.c.labelNormal),
          ),
        ],
      );

  /// Section/OneFix (`3569:15113`).
  ///
  /// 🔴 **소리가 없으면 섹션째 안 그린다.** 서버는 근거가 없으면 이 칸을 비워 보낸다
  ///    (다 맞았거나, 자모 점수가 아직 없거나). 예전에는 그래도 그려서 **빈 카드에
  ///    빈 초록 알약**만 뜨는 화면이 됐다(2026-09-04 실기기 실측).
  ///    ⛔ 자리를 채우려고 문구를 지어내지 마라 — 없는 분석을 만드는 셈이다.
  List<Widget> _oneFix(BuildContext context, AppLocalizations l10n, LearningSummary s) {
    if (s.hardestSound.isEmpty) return const [];
    return _section(context,
        label: l10n.hardestSound,
        child: _card(context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.hardestSound, style: AppType.headline1.b),
              // 근거·모국어 간섭은 따로 빈다 — 소리는 알아도 인용할 발화가 없을 수 있다.
              if (s.hardestEvidence.isNotEmpty) ...[
                const SizedBox(height: 10), // no s10 token
                Text(
                  s.hardestEvidence,
                  style:
                      AppType.caption1.r.copyWith(color: context.c.labelNormal),
                ),
              ],
              if (s.l1Interference.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: AppSpacing.s8),
                  decoration: BoxDecoration(
                    // Primary/Normal @ 8% — an alpha of the theme's primary, so it
                    // flips with the mode (Dark #00FFB2 / Light #007A55).
                    color: context.c.primaryNormal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    s.l1Interference,
                    style: AppType.caption1.r.copyWith(color: context.c.primaryNormal),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
  }

  /// Section/Phonemes (`3569:15122`).
  List<Widget> _phonemes(BuildContext context, AppLocalizations l10n, LearningSummary s) => _section(context, 
        label: l10n.soundAccuracy,
        trailing: Text(
          l10n.phonemeAttempts(s.phonemeAttempts),
          textAlign: TextAlign.end,
          style: AppType.caption2.r.copyWith(color: context.c.labelAlternative),
          // 수치는 자르지 않는다 — 잘린 횟수는 틀린 횟수다.
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        child: _table(context, 
          header: [
            _Cell.flex(l10n.colSound),
            _Cell.fixed(l10n.colAttempts, 40),
            _Cell.fixed(l10n.colCorrect, 40),
            _Cell.fixed(l10n.colAccuracy, 52),
          ],
          rows: [
            for (final p in s.phonemes)
              [
                _Cell.flex(p.sound, style: _rowName(context)),
                _Cell.fixed('${p.attempts}', 40, style: _rowValue(context)),
                _Cell.fixed('${p.correct}', 40, style: _rowValue(context)),
                _Cell.fixed('${p.accuracy}%', 52,
                    style: _rowEmphasis(_accuracyColor(context, p.accuracy))),
              ],
          ],
          emptyLabel: l10n.noPhonemesYet,
        ),
      );

  /// Section/Sentences (`3569:15156`).
  List<Widget> _sentences(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, LearningSummary s) {
    final expanded = ref.watch(_sentencesExpandedProvider);
    // 🔴 5줄을 넘길 때만 접는다. 세 문장짜리 표에 「전체 보기」가 붙으면 눌러도
    //    아무 일이 안 일어난다.
    final foldable = s.sentences.length > _kSentencePreview;
    final shown = expanded || !foldable
        ? s.sentences
        : s.sentences.take(_kSentencePreview).toList();

    return _section(
      context,
      label: l10n.sentenceResults,
      // 세는 것은 이 세션 전체다 — 지금 보이는 줄 수가 아니다. 그게 이 버튼이
      // 무엇을 열어 주는지 말한다.
      trailing: foldable
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ref
                  .read(_sentencesExpandedProvider.notifier)
                  .update((v) => !v),
              child: Text(
                expanded ? l10n.close : l10n.viewAllSentences(s.total),
                textAlign: TextAlign.end,
                style:
                    AppType.caption2.m.copyWith(color: context.c.primaryNormal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : null,
      child: _table(
        context,
        header: [
          _Cell.flex(l10n.colSentence),
          _Cell.fixed(l10n.colPronunciation, 36),
          _Cell.fixed(l10n.colFluency, 36),
          _Cell.fixed(l10n.colRhythm, 36),
        ],
        rows: [
          for (final x in shown)
            [
              _Cell.flex(x.sentence, style: _rowName(context)),
              // 「발음」 열만 13 Bold + 점수 색(Figma 3569:15156 · 소리별 정확도와 같은 기준,
              // 09-24 figma-code-diff). 유창·리듬은 Regular 그대로.
              _Cell.fixed('${x.pronunciation}', 36,
                  style: _rowEmphasis(_accuracyColor(context, x.pronunciation))),
              _Cell.fixed('${x.fluency}', 36, style: _rowValue(context)),
              _Cell.fixed('${x.rhythm}', 36, style: _rowValue(context)),
            ],
        ],
        emptyLabel: l10n.noSentencesYet,
      ),
    );
  }

  /// Section/Trend (`3569:15190`) — the chart, then the same data as a table.
  ///
  /// **「이 통화」 강조**(09-25 사장님 확정 A · Figma `__past_call` Mobile `6404:24650` · Tablet
  /// `6404:42246`): 차트 강조를 「최신」에서 지금 리포트의 통화(`call_id`) 막대로 옮기고, 표에서는
  /// 그 줄 배경을 칠한다. 이 통화가 최근 5개에 없으면(또는 구서버라 `call_id` 가 없으면) 차트는
  /// 종전처럼 최신을 강조하고 표는 칠하지 않는다.
  List<Widget> _trend(BuildContext context, AppLocalizations l10n, LearningSummary s,
      {int? callId}) {
    final match = callId == null
        ? -1
        : s.sessions.indexWhere((p) => p.callId == callId);
    final emphasis = match >= 0 ? match : s.sessions.length - 1;
    return _section(context, 
        label: l10n.recentSessions(s.sessions.length),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(context, 
              padding: const EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s16,
                  AppSpacing.s16, AppSpacing.s12),
              child: _TrendChart(sessions: s.sessions, l10n: l10n, emphasis: emphasis),
            ),
            const SizedBox(height: AppSpacing.s8),
            _table(context, 
              // 표는 최신이 위(역순) — 세션 index i 는 줄 (길이 − 1 − i).
              tintRow: match >= 0 ? s.sessions.length - 1 - match : null,
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
                      _tableDate(context, l10n, s.sessions[i]),
                      style: _rowName(context),
                    ),
                    _Cell.fixed('${s.sessions[i].sentences}', 40,
                        style: _rowValue(context)),
                    // 「점수」 열은 13 Bold · Label/Strong(Figma 최근 세션 표 · 09-24 figma-code-diff).
                    // 점수 없음(null)은 「—」 — 0 이 아니다(서버 1c83fd9 🔴2 · delta 와 같은 규칙).
                    // 「—」 은 Label/Alternative(Figma __unscored_session Mobile 6408:17396 · Tablet 6408:42355).
                    _Cell.fixed(s.sessions[i].score == null ? '—' : '${s.sessions[i].score}', 40,
                        style: _rowEmphasis(s.sessions[i].score == null
                            ? context.c.labelAlternative
                            : context.c.labelStrong)),
                    _Cell.fixed(
                      s.sessions[i].delta == null
                          ? '—'
                          : _signed(s.sessions[i].delta!),
                      48,
                      style: _rowEmphasis(_deltaColor(context, s.sessions[i].delta)),
                    ),
                  ],
              ],
            ),
          ],
        ),
      );
  }

  /// 표 날짜 칸 — 세션 시각이 있으면 현지 날짜(「9월 24일」)로, 없으면 서버 문자열.
  ///
  /// 「(오늘)」은 **정말 오늘일 때만** 붙인다. 예전엔 맨 윗줄에 무조건 붙여서, 서버가 UTC 로
  /// 전날을 적은 세션이 「9/23 (오늘)」이 됐다(09-24 실기기). 최신 세션이 오늘이라는 보장도 없다.
  static String _tableDate(
      BuildContext context, AppLocalizations l10n, SessionPoint p) {
    final at = p.callDate;
    if (at == null) {
      return p.serverSaysToday ? l10n.dateToday(p.date) : p.date;
    }
    final date = localizedShortDate(context, at);
    return _isToday(at) ? l10n.dateToday(date) : date;
  }

  static bool _isToday(DateTime local) {
    final now = DateTime.now();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  // ── shared shells ─────────────────────────────────────────────────────────

  List<Widget> _section(BuildContext context, {
    required String label,
    Widget? trailing,
    required Widget child,
  }) {
    final title = Text(
      label,
      style: AppType.body2.m,
      // 구획 이름은 아래 표가 무엇의 표인지 알려 주는 단서다.
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    return [
      const SizedBox(height: AppSpacing.s24),
      // 부가 문구(「음소 단위 · N회 시도」 `3569:15125` · 「N개 전체 보기」 `3569:15159`)는 머리 행
      // **오른쪽 끝**이다. 옛 `Expanded`(제목) + `Flexible`(부가)는 폭을 1:1 로 갈라 부가 문구가
      // 행 가운데쯤 떴다(09-24 사장님 실기기 「양옆으로 정렬하는 게 아니라 좀 붙어있어」).
      // 긴 언어에서는 긴 쪽이 줄을 바꾼다(`LabelValueRow`).
      if (trailing == null) title else LabelValueRow(label: title, value: trailing),
      const SizedBox(height: AppSpacing.s8),
      child,
    ];
  }

  Widget _card(BuildContext context, {required Widget child, EdgeInsets? padding}) => Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: child,
      );

  /// The table shell shared by all three tables (`3569:15126`) — a header row,
  /// then rows split by hairlines.
  /// [emptyLabel] fills the body when [rows] is empty — the header and the
  /// divider stay, so the table keeps its shape instead of collapsing to a bare
  /// header row (`screen/learning_main__pronunciation__sparse`, 4849:8555).
  ///
  /// Null on the trend table: the sparse frame keeps that one populated, so the
  /// design has no empty copy for it and inventing a line here would be exactly
  /// the kind of made-up string the work order forbids.
  Widget _table(BuildContext context, {
    required List<_Cell> header,
    required List<List<_Cell>> rows,
    String? emptyLabel,
    int? tintRow,
  }) {
    // 고정 열은 머리의 가장 긴 낱말까지 넓힌다(이름 열 몫은 남김) — [fitTableColumns].
    // 열 폭을 머리에서 한 번 정해 머리 · 모든 줄에 같이 쓴다.
    final wanted = <double?>[
      for (final h in header)
        h.width == null ? null : longestWordWidth(context, h.text, _headerStyle(context)),
    ];
    return Container(
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.s16, 4, AppSpacing.s16, 6),
        child: LayoutBuilder(builder: (context, box) {
          final widths = fitTableColumns(
            spec: [for (final h in header) h.width],
            wanted: wanted,
            innerWidth: box.maxWidth,
            gap: AppSpacing.s8,
          );
          List<_Cell> fit(List<_Cell> cells) => [
                for (var i = 0; i < cells.length; i++) cells[i].withWidth(widths[i]),
              ];
          return Column(
          children: [
            _row(context, fit(header), vertical: 10),
            // `Line/Neutral` — 12% white. (This read `borderSubtle` (6%) under
            // a comment claiming the design was 7%; the variable actually
            // resolves to 12%, so every divider on this screen was drawn at
            // half the intended weight.)
            if (rows.isEmpty && emptyLabel != null) ...[
              Divider(height: 1, thickness: 1, color: context.c.lineNeutral),
              EmptyRow(label: emptyLabel),
            ],
            for (var r = 0; r < rows.length; r++) ...[
              Divider(height: 1, thickness: 1, color: context.c.lineNeutral),
              r == tintRow
                  ? _thisCallTint(context, _row(context, fit(rows[r]), vertical: 11))
                  : _row(context, fit(rows[r]), vertical: 11),
            ],
          ],
        );
        }),
      );
  }

  /// 「이 통화」 줄 배경(Figma `ThisCallTint`) — `Primary/Normal-10` · 모서리 8 · 줄보다 좌우 8씩
  /// 넓게(글자 정렬은 그대로). 글자 굵기 · 색은 바꾸지 않는다.
  Widget _thisCallTint(BuildContext context, Widget row) => Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -8,
            right: -8,
            top: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.c.primaryNormal10,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          row,
        ],
      );

  Widget _row(BuildContext context, List<_Cell> cells, {required double vertical}) => Padding(
        padding: EdgeInsets.symmetric(vertical: vertical),
        child: Row(
          children: [
            for (var i = 0; i < cells.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.s8),
              cells[i].build(context),
            ],
          ],
        ),
      );
}

TextStyle _headerStyle(BuildContext context) =>
    AppType.caption2.r.copyWith(color: context.c.labelAlternative);
TextStyle _rowName(BuildContext context) =>
    AppType.label2.m.copyWith(color: context.c.labelStrong);
TextStyle _rowValue(BuildContext context) =>
    AppType.label2.r.copyWith(color: context.c.labelNormal);
TextStyle _rowEmphasis(Color color) => AppType.label2.b.copyWith(color: color);

/// The design's accuracy ramp, read off its four samples: 43% red, 75% amber,
/// 89% and 100% mint. The exact cut-offs are written down nowhere, so these are
/// inferred — revisit if the design ever states them.
Color _accuracyColor(BuildContext context, int accuracy) {
  if (accuracy >= 80) return context.c.primaryNormal;
  if (accuracy >= 60) return context.c.statusCautionary;
  return context.c.statusNegative;
}

/// A missing delta (the earliest session on record) is not a flat one.
Color _deltaColor(BuildContext context, int? delta) {
  // 「—」(비교할 앞 채점 세션 없음)은 Label/Alternative(Figma __unscored_session 6408:17396).
  if (delta == null) return context.c.labelAlternative;
  if (delta > 0) return context.c.primaryNormal;
  if (delta < 0) return context.c.statusNegative;
  return context.c.labelNormal;
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

  /// 같은 칸을 열 폭만 바꿔 — 고정 열만 해당([width] 가 null 이면 그대로).
  _Cell withWidth(double? w) => width == null || w == null
      ? this
      : _Cell.fixed(text, w, style: style);

  Widget build(BuildContext context) {
    final child = Text(
      text,
      style: style ?? _headerStyle(context),
      textAlign: _alignRight ? TextAlign.right : TextAlign.left,
      // 컬럼 헤더가 잘리면 그 열의 숫자가 무슨 숫자인지 모른다.
      maxLines: 2,
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
///
/// **60 미만 세션이 하나라도 있으면 눈금을 0/50/100 으로 바꿔 막대를 0부터 그린다**
/// (09-24 app designer 합의 · Figma 에 없는 규칙이라 사장님 보고 중). 60 창에 그대로 두면
/// 0점과 60점이 똑같이 바닥에 깔린다(09-24 실기기). 눈금 선 셋 · 높이는 그대로다.
class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.sessions, required this.l10n, required this.emphasis});

  final List<SessionPoint> sessions;
  final AppLocalizations l10n;

  /// 강조할 막대 — 「이 통화」, 없으면 최신(09-25 사장님 확정 A).
  final int emphasis;

  /// 날짜 눈금을 진하게 쓸 세션 — 「이 통화」와 「오늘」.
  bool _isTodaySession(SessionPoint p) {
    final at = p.callDate;
    if (at == null) return p.serverSaysToday;
    final now = DateTime.now();
    return at.year == now.year && at.month == now.month && at.day == now.day;
  }

  static const double _max = 100;

  /// 위→아래 눈금 셋.
  List<int> get _ticks => sessions.any((s) => s.score != null && s.score! < 60)
      ? const [100, 50, 0]
      : const [100, 80, 60];

  double get _min => _ticks.last.toDouble();

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
    // 점수 없는(null) 세션은 평균에서 뺀다. 0 은 진짜 0점이라 넣는다 — 예전 서버는 없음을 0 으로
    // 보내서 0 을 빼는 규칙이었다(서버 1c83fd9 🔴2).
    final scored = sessions.map((s) => s.score).whereType<int>().toList();
    // 평균은 채점 세션이 **둘 이상**일 때만 — Figma `__first`(4849:8421, 세션 1개)에 평균선이
    // 없다. 채점 세션이 없을 때 「평균 0」을 그리면 없는 값을 0으로 적는 셈이다(09-24).
    final avg = scored.length < 2
        ? null
        : (scored.fold<int>(0, (a, b) => a + b) / scored.length).round();
    return SizedBox(
      height: _valueRow + _plotHeight + _tickRow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _axis(context),
          const SizedBox(width: 6), // no s6 token
          Expanded(
            child: Stack(
              children: [
                _gridlines(context),
                if (avg != null) _avgLine(context, avg),
                Row(
                  children: [
                    // Each column takes an equal share rather than a fixed
                    // width: the design's 46 × 5 needs 230px, but a 320dp phone
                    // leaves the plot 222 after the screen padding, the card and
                    // the axis — fixed columns overflow on the narrowest devices
                    // the app supports.
                    for (var i = 0; i < sessions.length; i++)
                      Expanded(
                        child: _bar(
                          context,
                          sessions[i],
                          emphasized: i == emphasis,
                          tickStrong: i == emphasis || _isTodaySession(sessions[i]),
                        ),
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

  /// 100 / 80 / 60 (or 100 / 50 / 0), each sitting on its gridline.
  Widget _axis(BuildContext context) => SizedBox(
        width: 20,
        height: _valueRow + _plotHeight,
        child: Stack(
          // 맨 아래 눈금 글자는 바닥선에 가운데를 맞춰 상자 밖으로 7px 나간다 — 자르면
          // 「60」의 아래가 잘린다(09-24 실기기).
          clipBehavior: Clip.none,
          children: [
            for (final v in _ticks)
              Positioned(
                // −7 centres the 14-high line on the 1px rule.
                top: _valueRow + _y(v) - 7,
                right: 0,
                child: Text(
                  '$v',
                  // 10px — under `caption2`'s 11 floor, and the axis has to stay
                  // quieter than the values it labels.
                  style: AppType.caption2.r.copyWith(
                    color: context.c.labelAlternative,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _gridlines(BuildContext context) => Positioned.fill(
        child: Stack(
          children: [
            for (final v in _ticks)
              Positioned(
                top: _valueRow + _y(v),
                left: 0,
                right: 0,
                // All three bind `Line/Neutral` (12%) in the frame — the
                // baseline is not singled out. This used to draw 100/80 at 6%
                // under an invented hierarchy.
                child: ColoredBox(
                  color: context.c.lineNeutral,
                  child: SizedBox(height: 1),
                ),
              ),
          ],
        ),
      );

  /// 평균 글자 칸 높이 — 글자가 **선 위**에 앉도록 선보다 이만큼 위에서 시작한다.
  static const double _avgLabelBox = 12, _avgLabelGap = 2;

  Widget _avgLine(BuildContext context, int avg) => Positioned(
        // 글자는 평균선 **위**(Figma 「평균 88」 · 3569:15065). 선 아래에 두면 평균이 바닥에
        // 가까울 때 가로 눈금 글자(「9/13」)와 겹쳤다(09-24 실기기).
        top: _valueRow + _y(avg) - _avgLabelBox - _avgLabelGap,
        left: 0,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: _avgLabelBox,
              child: Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    l10n.trendAverage(avg),
                    // 9px — the smallest thing on the screen by design; it labels
                    // the line without competing with the bars.
                    style: AppType.caption2.m
                        .copyWith(color: context.c.primaryNormal, fontSize: 9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: _avgLabelGap),
            Container(
                height: 1,
                color: context.c.primaryNormal.withValues(alpha: 0.35)),
          ],
        ),
      );

  /// 가로 눈금 — 세션 시각이 있으면 현지 날짜의 「9/24」·「오늘」, 없으면 서버 문자열.
  /// 서버 「오늘」은 한국어 고정이라 앱 언어의 「오늘」로 바꿔 쓴다.
  ///
  /// 형식은 Figma 눈금(「12/21」)과 서버 문자열 그대로 `월/일` 이다. 로케일 형식
  /// (`DateFormat.Md`, ko 「9. 20.」)은 막대 한 칸(320dp 에서 약 44px)에 안 들어간다.
  String _tick(SessionPoint p) {
    final at = p.callDate;
    if (at == null) return p.serverSaysToday ? l10n.today : p.label;
    final now = DateTime.now();
    final today =
        at.year == now.year && at.month == now.month && at.day == now.day;
    return today ? l10n.today : '${at.month}/${at.day}';
  }

  Widget _bar(BuildContext context, SessionPoint p,
          {required bool emphasized, required bool tickStrong}) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _valueRow + _plotHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  child: Text(
                    // 점수 없음은 「—」 · 막대 없음.
                    p.score == null ? '—' : '${p.score}',
                    style: emphasized
                        ? AppType.caption2.b.copyWith(color: context.c.labelStrong)
                        : AppType.caption2.m
                            .copyWith(color: context.c.labelNormal),
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
                    height: p.score == null ? 0 : _plotHeight - _y(p.score!),
                    decoration: BoxDecoration(
                      // 「이 통화」가 차트의 주인공이고 나머지는 맥락이다.
                      color: emphasized
                          ? context.c.primaryNormal
                          : context.c.primaryNormal.withValues(alpha: 0.22),
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
            _tick(p),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tickStrong
                ? AppType.caption2.m.copyWith(
                    color: context.c.labelNormal,
                    fontSize: 10,
                  )
                : AppType.caption2.r.copyWith(
                    color: context.c.labelAlternative,
                    fontSize: 10,
                  ),
          ),
        ],
      );
}
