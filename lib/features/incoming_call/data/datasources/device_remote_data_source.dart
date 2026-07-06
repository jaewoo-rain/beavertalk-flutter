import 'package:dio/dio.dart';

/// `/devices` 엔드포인트(푸시 토큰 등록/삭제)와 통신한다.
///
/// 공유 `dioProvider` 인스턴스를 쓰므로 `Authorization: Bearer` 는 AuthInterceptor 가
/// 자동으로 붙인다(여기서 헤더 수동 처리 없음). 경로는 상대경로 — base URL 이 이미
/// 호스트 + `/api/v1` 을 담고 있다. 서버 계약은
/// docs/2026-07-06_1300_server-fcm-inbound-call-proposal.md §4 참고.
class DeviceRemoteDataSource {
  DeviceRemoteDataSource(this._dio);

  final Dio _dio;

  /// `POST /devices` — 내 기기 푸시 토큰 등록(upsert). 바디: `{platform, token}` → 201.
  Future<void> register({
    required String platform,
    required String token,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/devices',
      data: {'platform': platform, 'token': token},
    );
  }

  /// `DELETE /devices/{token}` — 로그아웃/토큰 폐기 시 삭제. 토큰에 `:` 등이 들어가므로
  /// 경로 세그먼트로 안전하게 인코딩한다(서버는 FastAPI 가 자동 디코딩해 원본과 매칭).
  Future<void> delete(String token) async {
    await _dio.delete<void>('/devices/${Uri.encodeComponent(token)}');
  }
}
