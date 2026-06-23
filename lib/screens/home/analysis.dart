import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_bookmark.dart';
import '../../components/molecules/chat_bubble.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Call analysis screen — Figma `screen/analysis` (`2224:21244`).
///
/// A long-scrolling [AppScaffold] under a [GnbType.main] header ("대화 기록"):
/// - the conversation title + a dotted date/duration meta row,
/// - a [PronunciationResult] gauge driven by [mockCallResult],
/// - a full-width "복습하기" button that reviews **every** learned sentence,
/// - a "새로 배운 표현" list (one card per [mockSentences] entry) where each
///   card carries a "연습하기" button that practices **that one** sentence,
/// - a "대화 상세" section of a few [ChatBubble]s.
///
/// Both review paths push [Routes.learningIntro] with a [LearningArgs]:
/// "복습하기" → all sentences from index 0; "연습하기" → a single-sentence list.
class AnalysisScreen extends StatefulWidget {
  /// Creates the call analysis screen.
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  /// Pushes the learning flow for [sentences], starting at [index].
  void _startLearning(List<MockSentence> sentences, {int index = 0}) {
    Navigator.pushNamed(
      context,
      Routes.learningIntro,
      arguments: LearningArgs(sentences: sentences, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = mockCallResult;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: '대화 기록',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── section 1: summary + 복습하기 ───────────────────
                  Text(
                    '강아지 산책과 음악 취향',
                    style: AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 8),
                  _MetaRow(segments: const ['1월 2일', '10분 37초']),
                  const SizedBox(height: 32),
                  Center(
                    child: PronunciationResult(
                      score: result.overall.toDouble(),
                      metrics: [
                        PronunciationMetric(
                          label: 'Pronunciation',
                          value: '${result.pronunciation}%',
                        ),
                        PronunciationMetric(
                          label: 'Fluency',
                          value: '${result.fluency}%',
                        ),
                        PronunciationMetric(
                          label: 'Rhythm',
                          value: '${result.rhythm}%',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '복습하기',
                    onPressed: () => _startLearning(result.sentences),
                  ),

                  // ── section 2: 새로 배운 표현 ───────────────────────
                  const SizedBox(height: 40),
                  Text(
                    '새로 배운 표현',
                    style: AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<Set<int>>(
                    valueListenable: bookmarkedSentenceIds,
                    builder: (context, ids, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < result.sentences.length; i++) ...[
                          if (i > 0) const SizedBox(height: 20),
                          CardBookmark(
                            korean: result.sentences[i].korean,
                            native: result.sentences[i].native,
                            bookmarked: ids.contains(result.sentences[i].id),
                            onBookmarkTap: () =>
                                toggleBookmark(result.sentences[i].id),
                            actionText: '연습하기',
                            onAction: () =>
                                _startLearning([result.sentences[i]]),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── section 3: 대화 상세 ────────────────────────────
                  const SizedBox(height: 40),
                  Text(
                    '대화 상세',
                    style: AppType.headline1.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 16),
                  const ChatBubble(
                    sender: ChatSender.ai,
                    text: '오, 정말 괜찮아!',
                  ),
                  const SizedBox(height: 20),
                  const ChatBubble(
                    sender: ChatSender.user,
                    text: '오늘 진짜 추워. 강아지랑 같이 얼음 됐어.',
                  ),
                  const SizedBox(height: 20),
                  const ChatBubble(
                    sender: ChatSender.ai,
                    text: '오, 정말 괜찮아!',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A dotted "date · duration" meta row (Figma `2224:21252`): Label 1 SemiBold
/// in [AppColors.textSecondary] with 4×4 dot separators.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.segments});

  final List<String> segments;

  @override
  Widget build(BuildContext context) {
    final style = AppType.label1.sb.copyWith(color: AppColors.textSecondary);
    final children = <Widget>[];
    for (int i = 0; i < segments.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: 4));
        children.add(
          const SizedBox(
            width: 4,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
        children.add(const SizedBox(width: 4));
      }
      children.add(Text(segments[i], style: style));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
