import '../../../../screens/home/learning_summary.dart';
import '../entities/call_result.dart';
import '../entities/pron_summary.dart';

/// Post-call analysis capabilities the app depends on. Implemented in the data
/// layer.
///
/// All methods return entities and throw [AppException]
/// (see `core/error/app_exception.dart`) on failure. No dio/JSON leaks here.
abstract interface class NormalcallRepository {
  /// `PATCH /calls/{call_id}` with the user's [rating] (1=아쉬워요, 2=괜찮아요,
  /// 3=좋아요). Throws [AppException] on failure.
  Future<void> submitRating(int callId, int rating);

  /// `GET /calls/{call_id}/status` — current analysis lifecycle state.
  Future<CallAnalysisStatus> getStatus(int callId);

  /// `GET /calls/{call_id}/result` — the full analysis result.
  Future<CallResult> getResult(int callId);

  /// `GET /calls/{call_id}/pronunciation-report` — 복습 종료 발음 리포트.
  Future<LearningSummary> getPronunciationReport(int callId);

  /// 마이페이지 발음 카드 — 최근 [sessions] 세션 발음 4지표 평균
  /// (`GET /calls/pronunciation-summary`).
  ///
  /// "세션"은 **점수가 있는** 통화다. 통화만 하고 발음 챌린지를 안 누른 통화는
  /// 세지 않으므로, 통화를 여러 번 했어도 결과가 비어 있을 수 있다.
  Future<PronSummary> getPronunciationSummary({int sessions});

  /// `GET /calls` — past calls for the record list (newest first).
  Future<List<CallSummary>> listCalls({int? limit, int? offset});

  /// The largest existing `call_id` (newest call), or null when there are none.
  ///
  /// Used to recover the call id of a manually-ended call: the server does not
  /// send `call_ended` on a client hang-up, so the just-finished call has no id
  /// from the socket. Capturing this as a baseline before a call, then polling
  /// for a larger id after, identifies the new call. Throws [AppException].
  Future<int?> latestCallId();
}
