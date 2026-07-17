import 'dart:typed_data';

import '../../features/review/domain/entities/review_feedback.dart';
import '../../mock/mock_data.dart';

/// Where a learning session was started from — which is what decides the screen
/// it ends on.
enum LearningOrigin {
  /// 복습하기 on `analysis`. The parent is a **call record**, so the session ends
  /// on the call-level summary (`learning_main__pronunciation`,
  /// [Routes.learningCallMain]).
  callReview,

  /// 연습하기 on a **single sentence** (Card-Bookmark, in records/archive), so
  /// the session ends on the sentence result (`learning_main__word`,
  /// [Routes.learningSentenceMain]).
  sentence,
}

/// Navigation payload shared across the learning flow
/// ([Routes.learningIntro] → [Routes.learningNext] → the [origin]'s result
/// screen).
///
/// Carries the full list of sentences in the current learning session plus the
/// [index] of the sentence currently being practiced. "복습하기" passes every
/// learned sentence; "연습하기" passes a single-element list. Each screen reads
/// this off `ModalRoute.of(context)!.settings.arguments` and forwards it
/// (advancing [index] when moving to the next sentence).
///
/// After a recording is scored, learning_intro attaches the resulting
/// [feedback] and the recorded [recordedWav] (for "Me" playback) before pushing
/// learning_next; these are dropped when advancing to a fresh sentence.
class LearningArgs {
  /// Creates a learning payload for [sentences] positioned at [index].
  const LearningArgs({
    required this.sentences,
    this.index = 0,
    this.feedback,
    this.recordedWav,
    this.origin = LearningOrigin.sentence,
  });

  /// The sentence sequence for this session (1+ items).
  final List<MockSentence> sentences;

  /// What started this session — see [LearningOrigin]. Decides the result
  /// screen once the last sentence is done.
  ///
  /// Defaults to [LearningOrigin.sentence] on purpose: that is the branch whose
  /// result screen is backed by the real response, so a caller who forgets to
  /// pass an origin lands on real data rather than on
  /// [Routes.learningCallMain]'s mock.
  ///
  /// It cannot be inferred from `sentences.length`: 복습하기 on a call with a
  /// single sentence would look identical to 연습하기 and end on the wrong
  /// screen.
  final LearningOrigin origin;

  /// Zero-based position of the active sentence within [sentences].
  final int index;

  /// Scored feedback for the current sentence's latest attempt, or null before
  /// the user has recorded.
  final ReviewFeedback? feedback;

  /// The user's just-recorded WAV bytes for "Me" playback, or null.
  final Uint8List? recordedWav;

  /// The sentence currently being practiced.
  MockSentence get current => sentences[index];

  /// Whether a sentence follows [current] in the sequence.
  bool get hasNext => index < sentences.length - 1;

  /// 1-based step number for progress labels (`current/total`).
  int get step => index + 1;

  /// Total number of sentences in the sequence.
  int get total => sentences.length;

  /// A copy advanced to the next sentence (caller must check [hasNext] first).
  /// Drops the previous sentence's feedback/recording — but **not** [origin],
  /// which has to survive the whole sequence: it is only read at the end, on the
  /// last sentence, and dropping it here would silently send every multi-sentence
  /// review to the wrong result screen.
  LearningArgs next() =>
      LearningArgs(sentences: sentences, index: index + 1, origin: origin);

  /// A copy carrying the freshly-scored [feedback] and [recordedWav].
  LearningArgs withFeedback(ReviewFeedback feedback, Uint8List recordedWav) =>
      LearningArgs(
        sentences: sentences,
        index: index,
        feedback: feedback,
        recordedWav: recordedWav,
        origin: origin,
      );
}
