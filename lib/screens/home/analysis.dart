import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/domain/entities/review_feedback.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Call analysis screen — Figma `screen/analysis` (`3583:34434`).
///
/// Sections, top to bottom, are exactly that frame's children:
/// - **CallHeader** (`3583:34438`) — `result.summary` as the title, then a
///   `·`-joined meta line (partner · date · duration · which call this is).
/// - **Gauge** (`3583:34441`) — pinned by the design as `pronunciation_result
///   (고정)`. The average is **recomputed on the frontend** from
///   [reviewScoresProvider], the mean over sentences practiced this session.
///   Before any practice the map is empty → inactive ("-%"); it updates live as
///   the user records sentences and returns here. (`result.average` is unused.)
/// - **복습하기 / 발음 챌린지 도전하기** — the two `Footer/PrimaryAction`s
///   (`3583:34443`/`3583:34444`), right under the gauge. This is also the app's
///   only entry to the challenge: without them `Routes.pronunciationChallenge`
///   is unreachable, and nothing would catch that — the tests mount the screen
///   directly, so they pass either way.
/// - **Baba의 한마디** (`3583:34445`).
/// - **새로 배운 표현 N** (`3583:34462`) — one [CardBookmark] per
///   `result.sentences` entry (speaker · bookmark toggle · 연습하기).
///
/// **오늘의 피드백 (OneFix) was deleted from the design** (2026-07-16) — it is
/// gone from both the loaded frame and `screen/analysis_loading` (`3569:27500`),
/// so this is the design agreeing with itself rather than the frame-vs-frame
/// split the buttons once had. The section, its entity and its DTO parsing went
/// with it; nothing consumed them (the server never sent the field).
///
/// **The server still sends no narrative fields** (nor the partner or call
/// sequence) — see `docs/2026-07-16_1145_analysis-확정디자인-정합.md` for the
/// proposed payload. [CallResult] declares them and the DTO parses them, so they
/// light up without a client change. Until then each is null and its section is
/// omitted outright: a fabricated remark is worse than no section at all, and
/// this screen's whole credibility rests on those lines being real.
///
/// [CardBookmark.highlight] stays null, so the learned expression renders
/// without the design's underline: no server field carries that span, and the
/// previous hardcoded `'내 귀를 사로잡았다'` underlined a fixed string regardless of
/// the sentence. Proposed to the server in the doc above.
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

  /// Plays a sentence's standard pronunciation for the card speaker glyph.
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  /// Sentence ids with a bookmark write in flight — a second tap while the
  /// first is still landing would toggle the server back and desync the store.
  final Set<int> _bookmarkInFlight = <int>{};

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
        // `true` from a prior session can't linger. Seeds both this screen's
        // card glyphs and the learning flow it pushes into.
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
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Plays a learned sentence's standard pronunciation when the server provides
  /// a playable URL ([LearnedSentence.voiceUrl]); otherwise says so.
  Future<void> _playSentence(LearnedSentence sentence) async {
    final l10n = AppLocalizations.of(context);
    final url = sentence.voiceUrl;
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      _snack(l10n.standardAudioNotReady);
      return;
    }
    try {
      await _player.playUrl(url);
    } catch (_) {
      _snack(l10n.standardAudioPlayError);
    }
  }

  /// Toggles a sentence's bookmark: flips the shared in-memory store instantly,
  /// then **persists to the server** so the 보관함 list (server-backed, via
  /// `GET /members/me/bookmarks`) actually reflects it. Reverts on failure —
  /// leaving the glyph filled after a failed write would claim a save that the
  /// archive won't have.
  Future<void> _toggleBookmark(int sentenceId) async {
    if (_bookmarkInFlight.contains(sentenceId)) return;
    _bookmarkInFlight.add(sentenceId);
    final willSave = !bookmarkedSentenceIds.value.contains(sentenceId);
    toggleBookmark(sentenceId); // optimistic local flip
    try {
      await ref
          .read(bookmarkToggleControllerProvider.notifier)
          .toggleBookmark(sentenceId, willSave);
    } catch (_) {
      toggleBookmark(sentenceId); // revert
      if (mounted) _snack(AppLocalizations.of(context).somethingWentWrong);
    } finally {
      _bookmarkInFlight.remove(sentenceId);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
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

          // ── Actions (`3583:34442`) ─────────────────────────────────
          const SizedBox(height: AppSpacing.s24),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.review,
            // Nothing to practice → nothing for the button to do.
            disabled: _learningSentences.isEmpty,
            onPressed: () => _startLearning(_learningSentences),
          ),
          const SizedBox(height: AppSpacing.s12),
          Button(
            type: BtnType.primaryOutline,
            size: BtnSize.s60,
            text: l10n.pronunciationChallenge,
            onPressed: () =>
                Navigator.pushNamed(context, Routes.pronunciationChallenge),
          ),

          ..._babaNote(l10n, result),
          ..._expressions(l10n, result),
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
        style: AppType.label2.r.copyWith(color: context.c.labelNeutral),
      ),
    ];
  }

  /// `N분 N초` from a duration in seconds.
  String _formatDuration(AppLocalizations l10n, int totalSeconds) =>
      l10n.durationMinSec(totalSeconds ~/ 60, totalSeconds % 60);

  /// Section/BabaNote (`3583:34445`) — needs both the remark and the partner it
  /// is attributed to, so it is hidden unless the server sends both.
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
              backgroundColor: context.c.backgroundNormalAlternative,
              backgroundImage: _avatarFor(character.imageUrl),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.text, style: AppType.label2.r),
                  const SizedBox(height: 6), // no s6 token
                  Text(
                    l10n.characterNoteFooter(character.name),
                    style: AppType.caption2.r
                        .copyWith(color: context.c.labelAlternative),
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

  /// Section/Expressions (`3583:34462`) — one `Card-Bookmark` per sentence
  /// (`3583:34466`–`3583:34468`), each with a speaker, a bookmark toggle and a
  /// 연습하기 button that practices just that sentence.
  List<Widget> _expressions(AppLocalizations l10n, CallResult result) {
    final sentences = result.sentences;
    if (sentences.isEmpty) return const [];
    return _section(
      label: l10n.newExpressionsCount(sentences.length),
      child: ValueListenableBuilder<Set<int>>(
        valueListenable: bookmarkedSentenceIds,
        builder: (context, saved, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < sentences.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.s12),
              CardBookmark(
                korean: sentences[i].korean ?? '',
                native: sentences[i].native ?? '',
                bookmarked: saved.contains(sentences[i].sentenceId),
                onBookmarkTap: () => _toggleBookmark(sentences[i].sentenceId),
                onSpeakerTap: () => _playSentence(sentences[i]),
                actionText: l10n.practice,
                onAction: () => _startLearning([_learningSentences[i]]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// A titled section: 24px above it, then the content 8px below the label.
  List<Widget> _section({required String label, required Widget child}) => [
        const SizedBox(height: AppSpacing.s24),
        Text(label, style: AppType.body2.m),
        const SizedBox(height: AppSpacing.s8),
        child,
      ];

  /// The shared card shell for every narrative section (#1F222A, r12, p16).
  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
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
    );

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
          style: AppType.body1.r.copyWith(color: context.c.labelNormal),
        ),
      ),
    );
  }
}
