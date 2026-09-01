import '../entities/report_reason.dart';

/// 유해 콘텐츠 신고 접수. 데이터 계층에서 구현한다.
///
/// 실패는 [AppException](`core/error/app_exception.dart`)으로 던진다 —
/// Supabase/dio 타입이 프레젠테이션 계층으로 새지 않는다.
abstract interface class ReportRepository {
  /// 신고 1건을 접수한다.
  ///
  /// [callId]는 통화 화면에서 왔을 때만 있다 — 기록 목록에서 특정 통화를 고르지
  /// 않고 신고하면 null이다. [detail]은 자유 입력이며 비어 있어도 된다.
  ///
  /// **접수는 앱 안에서 끝난다.** 메일 앱으로 넘기는 폴백은 정책상 "앱을
  /// 벗어남"으로 볼 여지가 있어 쓰지 않는다.
  Future<void> submit({
    required ReportReason reason,
    required ReportSource source,
    int? callId,
    String? detail,
  });
}
