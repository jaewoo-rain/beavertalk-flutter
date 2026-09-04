import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/datasources/review_remote_data_source.dart';
import '../data/repositories/review_repository_impl.dart';
import '../data/speech_cache.dart';
import '../domain/entities/review_feedback.dart';
import '../domain/repositories/review_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final reviewRemoteDataSourceProvider =
    Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.watch(dioProvider));
});

/// Pronunciation-review repository (domain interface) backed by the remote
/// data source.
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    remote: ref.watch(reviewRemoteDataSourceProvider),
  );
});

/// 합성된 힌트 음성을 들고 있는 캐시 — `POST /tts/speech` 왕복(=합성 요금)을 줄인다.
///
/// 화면이 아니라 여기 사는 이유: 통화 화면이 리빌드되거나 화면을 오갔다 와도 같은 문장을
/// 다시 합성하지 않기 위해서다. 세션 스코프라 로그아웃 시 함께 버려진다.
final speechCacheProvider = Provider<SpeechCache>((ref) => SpeechCache());

/// Latest per-sentence [PronScore] for the current analysis session
/// (`sentenceId → score`). The analysis gauge averages over this map so the
/// overall score reflects practice as the user records sentences.
///
/// Cleared/seeded per call by the analysis screen (keyed by call id) so scores
/// never leak across different calls.
final reviewScoresProvider =
    NotifierProvider<ReviewScores, Map<int, PronScore>>(ReviewScores.new);

/// Holds the running map of latest review scores plus the call id it belongs to.
class ReviewScores extends Notifier<Map<int, PronScore>> {
  /// The call id the current scores belong to (for leak-proof reset).
  int? _callId;

  @override
  Map<int, PronScore> build() => const {};

  /// Resets the map for a new analysis session [callId]. No-op if the same
  /// call is re-opened (preserves scores the user already earned this session).
  void resetForCall(int callId) {
    if (_callId == callId) return;
    _callId = callId;
    state = const {};
  }

  /// Records the latest [feedback] for its sentence (overwrites any prior).
  void record(ReviewFeedback feedback) {
    state = {...state, feedback.sentenceId: feedback.evaluation};
  }

  /// The latest score for [sentenceId], or null if not yet practiced.
  PronScore? scoreFor(int sentenceId) => state[sentenceId];
}

/// Mean of a [selector] over all recorded scores, or null when none exist.
/// Rounded to a whole number for display.
double? averageOf(
  Map<int, PronScore> scores,
  int Function(PronScore) selector,
) {
  if (scores.isEmpty) return null;
  var sum = 0;
  for (final s in scores.values) {
    sum += selector(s);
  }
  return sum / scores.length;
}
