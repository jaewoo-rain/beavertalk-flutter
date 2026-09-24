import 'package:beavertalk/features/review/data/models/review_feedback_dto.dart';
import 'package:beavertalk/features/review/domain/entities/review_feedback.dart';
import 'package:beavertalk/features/review/presentation/review_providers.dart';
import 'package:beavertalk/screens/home/learning_args.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 통화 기록 점수(분석 게이지) 규칙 · 채점 실패 처리(09-24 사장님).
void main() {
  ReviewFeedback fb(int sentenceId, Map<String, dynamic>? evaluation) =>
      ReviewFeedbackDto.fromJson({
        'review_id': 1,
        'sentence_id': sentenceId,
        'evaluation': ?evaluation,
        'char_scores': const [],
      }).toEntity();

  test('「발음 학습하기」만 통화 점수에 들어간다 — 문장 하나 연습 · 과제는 아니다', () {
    expect(LearningOrigin.callReview.countsTowardCallScore, isTrue);
    expect(LearningOrigin.sentence.countsTowardCallScore, isFalse);
    expect(LearningOrigin.assignment.countsTowardCallScore, isFalse);
  });

  test('채점 결과가 없으면 evaluation 은 null — 0 으로 채우지 않는다', () {
    expect(fb(1, null).evaluation, isNull);
    expect(fb(1, {'total_score': null}).evaluation, isNull);
    final ok = fb(1, {'total_score': 84, 'pronunciation': 80, 'fluency': 90, 'rhythm': 82}).evaluation!;
    expect(ok.totalScore, 84);
    // 진짜 0점은 0 이다.
    expect(fb(1, {'total_score': 0, 'pronunciation': 0, 'fluency': 0, 'rhythm': 0}).evaluation!.totalScore, 0);
  });

  test('채점 못 한 시도는 게이지 평균에 안 들어가고, 앞서 얻은 점수도 지우지 않는다', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final scores = c.read(reviewScoresProvider.notifier);
    scores.record(fb(7, {'total_score': 80, 'pronunciation': 80, 'fluency': 80, 'rhythm': 80}));
    scores.record(fb(7, null));
    expect(c.read(reviewScoresProvider)[7]!.totalScore, 80);
    scores.record(fb(8, null));
    expect(c.read(reviewScoresProvider).containsKey(8), isFalse);
  });
}
