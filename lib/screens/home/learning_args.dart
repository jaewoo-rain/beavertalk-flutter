import '../../mock/mock_data.dart';

/// Navigation payload shared across the learning flow
/// ([Routes.learningIntro] → [Routes.learningNext] → [Routes.learningMain]).
///
/// Carries the full list of sentences in the current learning session plus the
/// [index] of the sentence currently being practiced. "복습하기" passes every
/// learned sentence; "연습하기" passes a single-element list. Each screen reads
/// this off `ModalRoute.of(context)!.settings.arguments` and forwards it
/// (advancing [index] when moving to the next sentence).
class LearningArgs {
  /// Creates a learning payload for [sentences] positioned at [index].
  const LearningArgs({required this.sentences, this.index = 0});

  /// The sentence sequence for this session (1+ items).
  final List<MockSentence> sentences;

  /// Zero-based position of the active sentence within [sentences].
  final int index;

  /// The sentence currently being practiced.
  MockSentence get current => sentences[index];

  /// Whether a sentence follows [current] in the sequence.
  bool get hasNext => index < sentences.length - 1;

  /// 1-based step number for progress labels (`current/total`).
  int get step => index + 1;

  /// Total number of sentences in the sequence.
  int get total => sentences.length;

  /// A copy advanced to the next sentence (caller must check [hasNext] first).
  LearningArgs next() => LearningArgs(sentences: sentences, index: index + 1);
}
