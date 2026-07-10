import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Call analysis screen — Figma `screen/analysis` (`2224:21244`).
///
/// Binds the real [CallResult] passed as route arguments (fetched by
/// [Routes.analysisLoading] after the analysis finished):
/// - the conversation title ← `result.summary` (fallback when null),
/// - a [PronunciationResult] gauge whose average is **recomputed on the
///   frontend** from [reviewScoresProvider] — the mean over sentences the user
///   has practiced this session. Before any practice the map is empty → the
///   gauge is inactive ("-%"); it updates live as the user records sentences
///   and returns here. (We do not use `result.average`.)
/// - a "복습하기" button that reviews **every** learned sentence,
/// - a "새로 배운 표현" list (one card per `result.sentences` entry) where each
///   card carries a "연습하기" button that practices **that one** sentence and
///   shows the sentence's latest practiced score when available.
///
/// The "대화 상세" chat-bubble section has no backing field in [CallResult], so
/// it has been removed (previously placeholder bubbles).
///
/// Both review paths push [Routes.learningIntro] with a [LearningArgs]. The
/// learning flow operates on [MockSentence] for layout, but the real scoring
/// comes from the review API; learned sentences are adapted to [MockSentence]
/// (text only — review scores come from the API, not these placeholders).
class AnalysisScreen extends ConsumerStatefulWidget {
  /// Creates the call analysis screen.
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

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
      _result = args;
      _learningSentences =
          args.sentences.map(_toMockSentence).toList(growable: false);
      // Defer provider/notifier mutations out of the lifecycle phase: Riverpod
      // forbids modifying a provider during build/initState/didChangeDependencies.
      // Runs exactly once (guarded by the `_result == null` capture above).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // New analysis session → reset the running per-sentence scores so they
        // don't leak across different calls (keyed by call id; re-opening the
        // same call keeps scores the user already earned).
        ref.read(reviewScoresProvider.notifier).resetForCall(args.callId);
        // Seed the in-memory bookmark store from the server's flags.
        final saved = {...bookmarkedSentenceIds.value};
        for (final s in args.sentences) {
          if (s.isBookmarked) saved.add(s.sentenceId);
        }
        bookmarkedSentenceIds.value = saved;
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

  /// Toggles a sentence's bookmark. Flips the shared in-memory store instantly
  /// (optimistic), then **persists to the server** via
  /// [bookmarkToggleControllerProvider] so the 보관 list (server-backed) actually
  /// reflects it — previously this only flipped the local store, so bookmarks
  /// made here never reached `GET /members/me/bookmarks`. Reverts on failure.
  Future<void> _toggleBookmark(int sentenceId) async {
    final willSave = !bookmarkedSentenceIds.value.contains(sentenceId);
    toggleBookmark(sentenceId); // optimistic local flip
    try {
      await ref
          .read(bookmarkToggleControllerProvider.notifier)
          .toggleBookmark(sentenceId, willSave);
    } catch (_) {
      toggleBookmark(sentenceId); // revert on failure
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong.')),
        );
      }
    }
  }

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
  /// a playable URL ([LearnedSentence.voiceUrl]); otherwise shows a message.
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

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Call date + duration row from the server result. Returns an empty list when
  /// neither is available (so nothing — and no gap — renders).
  List<Widget> _metaSection(CallResult result) {
    final parts = <String>[
      if (result.callDate != null) _formatDate(result.callDate!),
      if (result.totalTime != null) _formatDuration(result.totalTime!),
    ];
    if (parts.isEmpty) return const [];
    return [
      const SizedBox(height: AppSpacing.s8),
      Row(
        children: [
          for (var i = 0; i < parts.length; i++) ...[
            if (i > 0) ...[
              const SizedBox(width: AppSpacing.s4),
              Container(
                width: AppSpacing.s4,
                height: AppSpacing.s4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.s4),
            ],
            Text(
              parts[i],
              style:
                  AppType.label1.sb.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    ];
  }

  /// Localized short date, e.g. `Jul 10`.
  String _formatDate(DateTime d) => DateFormat.MMMd('en').format(d);

  /// `N min N sec` from a duration in seconds.
  String _formatDuration(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return AppLocalizations.of(context).durationMinSec(m, s);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: AppLocalizations.of(context).conversation,
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s24, AppSpacing.s20, AppSpacing.s40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── section 1: summary + gauge + 복습하기 ───────────────────
          Text(
            title,
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          // Call date + duration from the server result (hidden until provided).
          ..._metaSection(result),
          const SizedBox(height: AppSpacing.s32),
          Center(
            child: PronunciationResult(
              // Empty (no practice yet) → inactive gauge ("-%").
              state: total == null
                  ? PronunciationState.inactive
                  : PronunciationState.active,
              score: total ?? 0,
              metrics: [
                PronunciationMetric(
                  label: 'Pronunciation',
                  value: _pct(pronunciation),
                ),
                PronunciationMetric(label: 'Fluency', value: _pct(fluency)),
                PronunciationMetric(label: 'Rhythm', value: _pct(rhythm)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.review,
            disabled: _learningSentences.isEmpty,
            onPressed: () => _startLearning(_learningSentences),
          ),
          const SizedBox(height: AppSpacing.s16),
          Button(
            type: BtnType.primaryOutline,
            size: BtnSize.s60,
            text: l10n.pronunciationChallenge,
            onPressed: () =>
                Navigator.pushNamed(context, Routes.pronunciationChallenge),
          ),

          // ── section 2: new expressions ─────────────────────────────
          const SizedBox(height: AppSpacing.s24),
          Text(
            l10n.newExpressions,
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.s16),
          if (result.sentences.isEmpty)
            Text(
              l10n.noNewExpressions,
              style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
            )
          else
            ValueListenableBuilder<Set<int>>(
              valueListenable: bookmarkedSentenceIds,
              builder: (context, ids, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < result.sentences.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.s20),
                    _SentenceCard(
                      sentence: result.sentences[i],
                      bookmarked:
                          ids.contains(result.sentences[i].sentenceId),
                      score: scores[result.sentences[i].sentenceId],
                      onBookmarkTap: () =>
                          _toggleBookmark(result.sentences[i].sentenceId),
                      onSpeak: () => _playSentence(result.sentences[i]),
                      onPractice: () =>
                          _startLearning([_learningSentences[i]]),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One "새로 배운 표현" card: the bookmark card plus an optional latest-score
/// line shown once the sentence has been practiced.
class _SentenceCard extends StatelessWidget {
  const _SentenceCard({
    required this.sentence,
    required this.bookmarked,
    required this.score,
    required this.onBookmarkTap,
    required this.onSpeak,
    required this.onPractice,
  });

  final LearnedSentence sentence;
  final bool bookmarked;
  final PronScore? score;
  final VoidCallback onBookmarkTap;
  final VoidCallback onSpeak;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardBookmark(
          korean: sentence.korean ?? '',
          native: sentence.native ?? '',
          bookmarked: bookmarked,
          // TODO(server): no "learned expression span" field — shell placeholder
          // so the Figma underline shows on the mock copy.
          highlight: '내 귀를 사로잡았다',
          onBookmarkTap: onBookmarkTap,
          onSpeakerTap: onSpeak,
          actionText: l10n.practice,
          onAction: onPractice,
        ),
        if (score != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s8, left: AppSpacing.s4),
            child: Text(
              l10n.recentScore(score!.totalScore),
              style: AppType.label2.sb.copyWith(color: AppColors.primary),
            ),
          ),
      ],
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
