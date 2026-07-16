import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/pressable.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/review/domain/entities/review_feedback.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Call analysis screen — Figma `screen/analysis__확정` (`3474:435`).
///
/// A full rework of the previous `screen/analysis` (`2224:21244`) layout. The
/// gauge stays (the design pins it as `pronunciation_result (고정)`); everything
/// below it is new, and the old 복습하기 / 발음 챌린지 buttons and the bookmark +
/// speaker + 연습하기 card actions are gone.
///
/// Sections, top to bottom:
/// - **CallHeader** — `result.summary` as the title, then a `·`-joined meta line
///   (partner · date · duration · which call this is).
/// - **Gauge** — average **recomputed on the frontend** from
///   [reviewScoresProvider], the mean over sentences practiced this session.
///   Before any practice the map is empty → inactive ("-%"); it updates live as
///   the user records sentences and returns here. (`result.average` is unused.)
/// - **Baba의 한마디 / 오늘 고칠 것 하나 / 이번에 처음 한 것 / 다음 통화에 해볼 것** —
///   see below.
/// - **새로 배운 표현** — one row per `result.sentences` entry; tapping a row
///   practices that one sentence (what the old per-card 연습하기 button did).
///
/// **The server sends none of the four narrative sections yet** (nor the partner
/// or call sequence) — see `docs/2026-07-15_2114_analysis-screen-redesign.md`
/// for the proposed payload. [CallResult] declares them and the DTO parses them,
/// so they light up without a client change. Until then each is null and its
/// section is omitted outright: a fabricated "one thing to fix" is worse than no
/// section at all, and this screen's whole credibility rests on those lines
/// being real.
class AnalysisScreen extends ConsumerStatefulWidget {
  /// Creates the call analysis screen.
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  CallResult? _result;

  /// Learned sentences adapted to the learning flow's [MockSentence] shape
  /// (text only). Built once from [_result].
  List<MockSentence> _learningSentences = const [];

  /// True once the deferred per-call reset of [reviewScoresProvider] has run.
  /// Until then the gauge ignores any (possibly stale) scores so a fresh call
  /// starts empty even on the first frame, before the post-frame reset lands.
  bool _scoresReset = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_result != null) return; // capture once
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is CallResult) {
      final result = _kDesignPreview ? _withDesignPreview(args) : args;
      _result = result;
      _learningSentences =
          result.sentences.map(_toMockSentence).toList(growable: false);
      // Defer provider/notifier mutations out of the lifecycle phase: Riverpod
      // forbids modifying a provider during build/initState/didChangeDependencies.
      // Runs exactly once (guarded by the `_result == null` capture above).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // New analysis session → reset the running per-sentence scores so they
        // don't leak across different calls (keyed by call id; re-opening the
        // same call keeps scores the user already earned).
        ref.read(reviewScoresProvider.notifier).resetForCall(args.callId);
        // Reconcile the in-memory bookmark store with the server's flags — set
        // each id to its true state (add saved, clear un-saved) so a stale
        // `true` from a prior session can't linger. This screen no longer shows
        // bookmarks, but the learning flow it pushes into does, and this is
        // where those ids are seeded from the server.
        for (final s in args.sentences) {
          setBookmark(s.sentenceId, s.isBookmarked);
        }
        setState(() => _scoresReset = true);
      });
    }
  }

  /// Adapts a domain [LearnedSentence] to the learning flow's [MockSentence]
  /// (text + id only; review scores come from the API at practice time).
  MockSentence _toMockSentence(LearnedSentence s) => MockSentence(
        id: s.sentenceId,
        korean: s.korean ?? '',
        native: s.native ?? '',
        charScores: const [],
        overall: 0,
        pronunciation: 0,
        fluency: 0,
        rhythm: 0,
        bookmarked: s.isBookmarked,
      );

  /// Pushes the learning flow for [sentences], starting at [index].
  void _startLearning(List<MockSentence> sentences, {int index = 0}) {
    if (sentences.isEmpty) return;
    Navigator.pushNamed(
      context,
      Routes.learningIntro,
      arguments: LearningArgs(sentences: sentences, index: index),
    );
  }

  /// Formats a nullable 0–100 score as a rounded percent, or `-%` when null.
  String _pct(double? value) => value == null ? '-%' : '${value.round()}%';

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: AppLocalizations.of(context).conversationRecord,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: result == null ? const _EmptyState() : _content(result),
          ),
        ],
      ),
    );
  }

  Widget _content(CallResult result) {
    final l10n = AppLocalizations.of(context);
    // Recompute the gauge average from the per-sentence review scores. Until the
    // deferred per-call reset has run, treat scores as empty so a fresh call
    // never shows a previous call's leftover scores on the first frame.
    final scores =
        _scoresReset ? ref.watch(reviewScoresProvider) : const <int, PronScore>{};
    final total = averageOf(scores, (s) => s.totalScore);
    final pronunciation = averageOf(scores, (s) => s.pronunciation);
    final fluency = averageOf(scores, (s) => s.fluency);
    final rhythm = averageOf(scores, (s) => s.rhythm);

    final title = (result.summary != null && result.summary!.trim().isNotEmpty)
        ? result.summary!
        : l10n.analysisResult;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s16,
        AppSpacing.s20,
        AppSpacing.s40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── CallHeader (3474:457) ──────────────────────────────────
          Text(title, style: AppType.heading2.m),
          ..._metaLine(l10n, result),

          const SizedBox(height: AppSpacing.s24),
          Center(
            child: PronunciationResult(
              // Empty (no practice yet) → inactive gauge ("-%").
              state: total == null
                  ? PronunciationState.inactive
                  : PronunciationState.active,
              score: total ?? 0,
              metrics: [
                PronunciationMetric(
                  label: l10n.pronunciation,
                  value: _pct(pronunciation),
                ),
                PronunciationMetric(label: l10n.fluency, value: _pct(fluency)),
                PronunciationMetric(label: l10n.rhythm, value: _pct(rhythm)),
              ],
            ),
          ),

          ..._babaNote(l10n, result),
          ..._oneFix(l10n, result.oneFix),
          ..._firstTime(l10n, result.firstTime),
          ..._expressions(l10n, result),
          ..._nextCall(l10n, result.nextCall),
        ],
      ),
    );
  }

  /// `Baba · 1월 2일 · 10분 37초 · 3번째 통화` — a single `·`-joined line
  /// (3474:459). Every part is nullable, so the line renders whatever is known
  /// and disappears entirely when nothing is.
  List<Widget> _metaLine(AppLocalizations l10n, CallResult result) {
    final locale = Localizations.localeOf(context).toString();
    final parts = <String>[
      if (result.character != null) result.character!.name,
      // Locale-aware: this screen renders in 30 locales. (The old code pinned
      // this to 'en', which printed "Jul 10" inside an otherwise Korean line.)
      if (result.callDate != null)
        intl.DateFormat.MMMd(locale).format(result.callDate!),
      if (result.totalTime != null) _formatDuration(l10n, result.totalTime!),
      if (result.callSequence != null) l10n.callSequence(result.callSequence!),
    ];
    if (parts.isEmpty) return const [];
    return [
      const SizedBox(height: 6), // no s6 token
      Text(
        parts.join(' · '),
        style: AppType.label2.r.copyWith(color: AppColors.labelMeta),
      ),
    ];
  }

  /// `N분 N초` from a duration in seconds.
  String _formatDuration(AppLocalizations l10n, int totalSeconds) =>
      l10n.durationMinSec(totalSeconds ~/ 60, totalSeconds % 60);

  /// Section/BabaNote (3474:582) — needs both the remark and the partner it is
  /// attributed to, so it is hidden unless the server sends both.
  List<Widget> _babaNote(AppLocalizations l10n, CallResult result) {
    final note = result.note;
    final character = result.character;
    if (note == null || character == null) return const [];
    return _section(
      label: l10n.characterNoteTitle(character.name),
      child: _card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surface2,
              backgroundImage: _avatarFor(character.imageUrl),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.text, style: AppType.label2.r),
                  const SizedBox(height: 6),
                  Text(
                    l10n.characterNoteFooter(character.name),
                    style: _micro(AppColors.labelFootnote),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The partner avatar, or the static beaver asset when there's no URL — the
  /// same fallback the record list uses.
  ImageProvider _avatarFor(String? imageUrl) =>
      (imageUrl != null && imageUrl.isNotEmpty)
          ? NetworkImage(imageUrl)
          : beaverImage;

  /// Section/OneFix (3474:589).
  List<Widget> _oneFix(AppLocalizations l10n, OneFix? fix) {
    if (fix == null) return const [];
    final streak = fix.streakCount;
    return _section(
      label: l10n.oneFixTitle,
      // A streak of 1 is just "this call" — only 2+ is a recurrence worth
      // flagging, so the badge stays hidden below that.
      trailing: (streak != null && streak >= 2)
          ? _streakBadge(l10n.streakBadge(streak))
          : null,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fix.title, style: AppType.body2.m),
            if (fix.evidence != null) ...[
              const SizedBox(height: 10), // no s10 token
              Text(
                fix.evidence!,
                style: AppType.caption1.r.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (fix.l1Interference != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: AppSpacing.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary08,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  fix.l1Interference!,
                  style: AppType.caption1.r.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _streakBadge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.negativeAccent16,
          borderRadius: BorderRadius.circular(6), // no r6 token
        ),
        child: Text(
          text,
          style: _micro(AppColors.negativeAccent, weight: FontWeight.w500),
        ),
      );

  /// Section/FirstTime (3475:545).
  List<Widget> _firstTime(AppLocalizations l10n, FirstTime? first) {
    if (first == null) return const [];
    return _section(
      label: l10n.firstTimeTitle,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(first.text, style: AppType.label2.r),
            if (first.previous != null) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                first.previous!,
                style:
                    AppType.caption2.r.copyWith(color: AppColors.labelFootnote),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Section/Expressions (3475:550). The only interactive section: each row
  /// pushes the learning flow for that one sentence.
  List<Widget> _expressions(AppLocalizations l10n, CallResult result) {
    final sentences = result.sentences;
    final total = result.expressionsTotal;
    return _section(
      label: l10n.newExpressionsCount(sentences.length),
      trailing: total == null
          ? null
          : Text(
              l10n.expressionsTotal(total),
              style:
                  AppType.caption2.r.copyWith(color: AppColors.labelFootnote),
            ),
      child: sentences.isEmpty
          ? Text(
              l10n.noNewExpressions,
              style: AppType.label2.r.copyWith(color: AppColors.textSecondary),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < sentences.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _ExpressionRow(
                    sentence: sentences[i],
                    onTap: () => _startLearning([_learningSentences[i]]),
                  ),
                ],
              ],
            ),
    );
  }

  /// Section/NextCall (3475:581).
  List<Widget> _nextCall(AppLocalizations l10n, String? next) {
    if (next == null) return const [];
    return _section(
      label: l10n.nextCallTitle,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(next, style: AppType.label2.r),
            const SizedBox(height: AppSpacing.s4),
            Text(
              l10n.nextCallFooter,
              style:
                  AppType.caption2.r.copyWith(color: AppColors.labelFootnote),
            ),
          ],
        ),
      ),
    );
  }

  /// A titled section: 24px above it, an optional trailing badge/count on the
  /// label row, then the content 8px below.
  List<Widget> _section({
    required String label,
    Widget? trailing,
    required Widget child,
  }) =>
      [
        const SizedBox(height: AppSpacing.s24),
        Row(
          children: [
            Expanded(child: Text(label, style: AppType.body2.m)),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s8),
              trailing,
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        child,
      ];

  /// The shared card shell for every narrative section (#1F222A, r12, p16).
  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: child,
      );
}

/// Opt-in design-review flag: `--dart-define=ANALYSIS_DESIGN_PREVIEW=true`.
///
/// The server sends none of the narrative fields (verified against
/// `domains/learning/schemas/call.py` — `CallResult` is `call_id`, `summary`,
/// `rating`, `average`, `sentences` and nothing else), so on a real device every
/// new section hides and the redesign is invisible. This flag fills the nulls
/// with the Figma frame's own sample copy so the layout can be reviewed on
/// device before the API exists.
///
/// It is double-gated — `kDebugMode` **and** the dart-define — so sample text
/// cannot reach a release build even if the define is left on by accident.
/// Delete this and [_withDesignPreview] once the server ships the fields.
const bool _kDesignPreview =
    kDebugMode && bool.fromEnvironment('ANALYSIS_DESIGN_PREVIEW');

/// Fills only the fields the server does not send yet, leaving real data
/// (summary, scores, sentences) untouched.
CallResult _withDesignPreview(CallResult r) => CallResult(
      callId: r.callId,
      summary: r.summary ?? '강아지 산책과 음악 취향',
      rating: r.rating,
      callDate: r.callDate ?? DateTime(2026, 1, 2),
      totalTime: r.totalTime ?? 637,
      average: r.average,
      // Only when the call produced none — otherwise the real ones stay, and
      // [_learningSentences] is rebuilt from whatever this returns so the row
      // index → sentence mapping can never drift.
      sentences: r.sentences.isNotEmpty
          ? r.sentences
          : const [
              LearnedSentence(
                sentenceId: -1,
                korean: '내 귀를 사로잡았다',
                native: 'His words caught my ear',
              ),
              LearnedSentence(
                sentenceId: -2,
                korean: '취향이 비슷하다',
                native: 'To have similar taste',
              ),
              LearnedSentence(
                sentenceId: -3,
                korean: '산책시키다',
                native: 'To walk a dog',
              ),
            ],
      character: r.character ??
          const CallCharacterBrief(characterId: 1, name: 'Baba'),
      callSequence: r.callSequence ?? 3,
      note: r.note ??
          const CharacterNote(
            text: '강아지 얘기 나오니까 갑자기 말이 빨라지던데요.\n그 톤이 진짜예요.',
          ),
      oneFix: r.oneFix ??
          const OneFix(
            title: '받침 ㄹ이 자꾸 새요',
            evidence: '“산책시킬게요”를 “산책시키게요”로 3번 발음했어요',
            l1Interference: '스페인어엔 이 받침이 없어요. 당신 잘못이 아니에요.',
            streakCount: 3,
          ),
      firstTime: r.firstTime ??
          const FirstTime(text: '되묻지 않고 바로 답했어요 · 7회', previous: '지난 통화엔 2회'),
      nextCall: r.nextCall ?? '“내 귀를 사로잡았다”를 직접 써보기',
      expressionsTotal: r.expressionsTotal ?? 27,
    );

/// 10px/14 — below the `MO/*` scale's floor (`caption2` is 11px), so the size
/// and line-height are set explicitly rather than scaled off a token.
TextStyle _micro(Color color, {FontWeight weight = FontWeight.w400}) => TextStyle(
      fontFamily: kFontFamily,
      fontSize: 10,
      height: 14 / 10,
      fontWeight: weight,
      color: color,
    );

/// One "새로 배운 표현" row (3475:555) — Korean over its native translation,
/// with a chevron. The whole card is the tap target.
class _ExpressionRow extends StatelessWidget {
  const _ExpressionRow({required this.sentence, required this.onTap});

  final LearnedSentence sentence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final korean = sentence.korean ?? '';
    final native = sentence.native ?? '';
    return Pressable(
      onTap: onTap,
      semanticLabel: korean.isEmpty ? native : korean,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(korean, style: AppType.label1.m),
                  if (native.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      native,
                      style: AppType.caption1.r
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s16),
            AppIcons.chevronRight(size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Shown when the screen is opened without a [CallResult] argument.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Text(
          AppLocalizations.of(context).analysisLoadError,
          style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
