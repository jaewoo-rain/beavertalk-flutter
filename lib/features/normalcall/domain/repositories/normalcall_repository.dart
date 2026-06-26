import '../entities/call_result.dart';

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
}
