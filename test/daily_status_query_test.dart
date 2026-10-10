import 'dart:convert';
import 'dart:typed_data';

import 'package:beavertalk/features/normalcall/data/datasources/normalcall_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// `GET /calls/daily-status` 쿼리 계약 — 서버 dev `get_daily_status(date: str, tz_offset: int = 0,
/// tz: str | None)`. `date` 가 빠지면 422 다(09-24 실기기: Free 카드 「오늘 통화 시간」 이 늘 숨었다).
class _Capture implements HttpClientAdapter {
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? _, Future<void>? _) async {
    last = o;
    return ResponseBody.fromString(
      jsonEncode({'budget_s': 300, 'used_s': 0, 'remaining_s': 300}),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('date(필수) · tz · tz_offset 을 싣는다 — tz_offset_min 이 아니다', () async {
    final cap = _Capture();
    final dio = Dio(BaseOptions(baseUrl: 'https://h.run.app/api/v1'))..httpClientAdapter = cap;
    await NormalcallRemoteDataSource(dio)
        .getDailyStatus(date: '2026-09-24', tz: 'Asia/Seoul', tzOffsetMin: 540);
    expect(cap.last!.path, '/calls/daily-status');
    expect(cap.last!.queryParameters,
        {'date': '2026-09-24', 'tz': 'Asia/Seoul', 'tz_offset': 540});
  });

  test('IANA 를 모르면 tz 키만 빠진다', () async {
    final cap = _Capture();
    final dio = Dio(BaseOptions(baseUrl: 'https://h.run.app/api/v1'))..httpClientAdapter = cap;
    await NormalcallRemoteDataSource(dio).getDailyStatus(date: '2026-09-24', tzOffsetMin: -300);
    expect(cap.last!.queryParameters, {'date': '2026-09-24', 'tz_offset': -300});
  });
}
