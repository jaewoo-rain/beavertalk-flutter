import '../../../../screens/home/learning_summary.dart';
import '../entities/call_result.dart';
import '../entities/call_resume_status.dart';
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

  /// 이 통화를 **이어갈 수 있는지** 서버에 묻는다 (`GET /calls/{id}/resume-status`).
  ///
  /// 상한 판정의 **1차 권위**다. 클라도 [CallAllowance] 로 같은 계산을 할 수 있지만,
  /// 「누가 유료인가」에 대한 판단이 서버와 다를 수 있고 **다를 때는 서버가 맞다** —
  /// 이어가기를 실제로 허락하는 쪽이 서버이기 때문이다.
  ///
  /// 못 받으면 **null** 을 돌려준다(구버전 서버 404, 남의 통화 404, 네트워크 실패).
  /// 호출부는 그때 로컬 계산으로 내려간다. **던지지 않는다** — 이걸 못 물어봤다고
  /// 통화를 막을 이유는 없다.
  Future<CallResumeStatus?> getResumeStatus(int callId);
}
