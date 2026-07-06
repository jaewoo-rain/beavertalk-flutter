/// 푸시 토큰 등록/삭제 기능(데이터 계층에서 구현).
///
/// 실패 시 `AppException`(core/error/app_exception.dart)을 던진다 — dio/JSON 누수 없음.
abstract interface class DeviceRepository {
  /// `POST /devices` — 내 기기 푸시 토큰 등록(upsert).
  Future<void> register({required String platform, required String token});

  /// `DELETE /devices/{token}` — 토큰 삭제(로그아웃/폐기).
  Future<void> delete(String token);
}
