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

  /// 숙제 상세의 발음 과제. 문장은 통화가 아니라 **과제 출제 스냅샷**에서 온다.
  ///
  /// 셋이 다르다.
  /// - 채점 경로 — 과제 전용 무상태 엔드포인트를 쓴다. 통화 발화가 아니라
  ///   `sentence` 행이 없고, 그 행은 `call_id` 가 NOT NULL 이라 만들 수도 없다.
  /// - 북마크 — 끈다. 문장 id 가 아니라 학습 항목 id 라 그대로 누르면 **남의
  ///   문장 id 로 서버를 때린다.**
  /// - 끝난 뒤 — 결과 화면으로 가지 않고 숙제 상세로 돌아온다. 거기 과제 카드가
  ///   방금 친 결과를 보여준다.
  assignment,
}

/// Navigation payload shared across the learning flow
/// ([Routes.learningIntro] → the [origin]'s result
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
    this.callId,
    this.assignmentId,
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

  /// The call this review belongs to — set for [LearningOrigin.callReview] so
  /// the session-summary screen ([Routes.learningCallMain]) can fetch
  /// `GET /calls/{callId}/pronunciation-report`. Null for single-sentence
  /// (연습하기) origin. Like [origin], it must survive the whole sequence —
  /// it is only read at the end.
  final int? callId;

  /// 이 세션이 수행하는 과제 id — [LearningOrigin.assignment] 일 때만 있다.
  ///
  /// [origin] 과 같은 이유로 세션 끝까지 살아 있어야 한다. 마지막 문장에서
  /// 제출할 때 읽는다.
  final int? assignmentId;

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
  LearningArgs next() => LearningArgs(
        sentences: sentences,
        index: index + 1,
        origin: origin,
        callId: callId,
        assignmentId: assignmentId,
      );

  /// A copy carrying the freshly-scored [feedback] and [recordedWav].
  LearningArgs withFeedback(ReviewFeedback feedback, Uint8List recordedWav) =>
      LearningArgs(
        sentences: sentences,
        index: index,
        feedback: feedback,
        recordedWav: recordedWav,
        origin: origin,
        callId: callId,
        assignmentId: assignmentId,
      );
}
