import 'package:supabase_flutter/supabase_flutter.dart';

/// `public.content_report` 에 신고를 적재한다.
///
/// **앱 서버(FastAPI)가 아니라 Supabase로 보낸다.** 라이브 OpenAPI를 실측한
/// 결과(2026-09-01, 경로 41종) 신고 엔드포인트가 없었고, 서버에 신설을 요청하면
/// 그 회신이 출시 임계경로에 얹힌다. 신고 경로는 첫 릴리스에 반드시 들어가야
/// 하는 유일한 항목이라 서버 의존을 만들지 않았다.
///
/// 서버가 나중에 `POST /reports` 를 열면 이 클래스만 갈아끼우면 된다 —
/// 리포지토리 인터페이스는 그대로다.
class ReportRemoteDataSource {
  /// [client] 를 주입받는다(테스트에서 대체 가능).
  ReportRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// 신고 테이블 이름. RLS가 `auth.uid()` 로 본인 행만 허용한다.
  static const String table = 'content_report';

  /// 신고 1행을 넣는다. `reporter_uid` 는 DB 기본값(`auth.uid()`)이 채운다 —
  /// 클라이언트가 보낸 값을 믿지 않는다.
  Future<void> insert({
    required String reason,
    required String source,
    int? callId,
    String? detail,
    String? locale,
  }) async {
    await _client.from(table).insert(<String, dynamic>{
      'reason': reason,
      'source': source,
      'call_id': ?callId,
      if (detail != null && detail.isNotEmpty) 'detail': detail,
      if (locale != null && locale.isNotEmpty) 'locale': locale,
    });
  }
}
