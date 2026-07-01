import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/chat_bubble.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/review/domain/entities/review_feedback.dart';
import '../../features/review/presentation/review_providers.dart';
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
/// it is hidden.
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
            title: '대화 기록',
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
        : '대화 분석 결과';

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
          const SizedBox(height: AppSpacing.s8),
          // TODO(server): call date + duration are not in CallResult yet —
          // placeholder values. Wire when the API provides them.
          Row(
            children: [
              Text(
                '1월 2일',
                style: AppType.label1.sb.copyWith(color: AppColors.textSecondary),
              ),
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
              Text(
                '10분 37초',
                style: AppType.label1.sb.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
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
            text: '복습하기',
            disabled: _learningSentences.isEmpty,
            onPressed: () => _startLearning(_learningSentences),
          ),

          // ── section 2: 새로 배운 표현 ───────────────────────────────
          const SizedBox(height: AppSpacing.s24),
          Text(
            '새로 배운 표현',
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.s16),
          if (result.sentences.isEmpty)
            Text(
              '이번 대화에서 새로 배운 표현이 없어요.',
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
                          toggleBookmark(result.sentences[i].sentenceId),
                      onPractice: () =>
                          _startLearning([_learningSentences[i]]),
                    ),
                  ],
                ],
              ),
            ),

          // ── section 3: 대화 상세 ────────────────────────────────────
          // NOTE(shell): CallResult has no conversation transcript field yet —
          // placeholder bubbles to match Figma `2296:26458`. TODO(server): wire
          // the real transcript when the API provides it.
          const SizedBox(height: AppSpacing.s24),
          Text(
            '대화 상세',
            style: AppType.headline1.sb.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.s16),
          const ChatBubble(sender: ChatSender.ai, text: '오, 정말 괜찮아!'),
          const SizedBox(height: AppSpacing.s16),
          const ChatBubble(
            sender: ChatSender.user,
            text: '오늘 진짜 추워. 강아지랑 같이 얼음 됐어.',
          ),
          const SizedBox(height: AppSpacing.s16),
          const ChatBubble(sender: ChatSender.ai, text: '오, 정말 괜찮아!'),
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
    required this.onPractice,
  });

  final LearnedSentence sentence;
  final bool bookmarked;
  final PronScore? score;
  final VoidCallback onBookmarkTap;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
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
          actionText: '연습하기',
          onAction: onPractice,
        ),
        if (score != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s8, left: AppSpacing.s4),
            child: Text(
              '최근 점수 ${score!.totalScore}%',
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
          '분석 결과를 불러올 수 없어요.',
          style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
