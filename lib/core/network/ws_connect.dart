import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

/// 서버와 맞춘 subprotocol 표식(beavertalk-server ws_router `_WS_AUTH_SUBPROTOCOL`).
const String kWsAuthSubprotocol = 'bt.auth';

/// [url] 에서 `token` 쿼리만 뺀 주소. 다른 쿼리(`client_session`·`os` 등)는 그대로 둔다.
Uri stripTokenQuery(Uri url) {
  final rest = Map<String, String>.from(url.queryParameters)..remove('token');
  final base = '${url.scheme}://${url.authority}${url.path}';
  return Uri.parse(rest.isEmpty ? base : '$base?${Uri(queryParameters: rest).query}');
}

/// 인증 토큰을 주소가 아니라 `Sec-WebSocket-Protocol` 로 실어 WS 를 연다(PM-DEC-997·1017).
///
/// 왜: 쿼리 `?token=` 은 Cloud Run 요청 로그(requestUrl)에 토큰째 남는다. 헤더로 옮기면 안 남는다.
///
/// 서버가 `bt.auth` 를 수락하지 않으면(그 기능 전의 서버 — 롤백 등) 한 번만 쿼리 토큰으로 다시 연다.
/// 그래서 [urlWithToken] 은 종전처럼 토큰이 붙은 주소를 그대로 넘긴다.
Future<WebSocketChannel> connectWithAuth(
  String urlWithToken,
  String token, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final full = Uri.parse(urlWithToken);
  WebSocketChannel? first;
  try {
    first = WebSocketChannel.connect(
      stripTokenQuery(full),
      protocols: <String>[kWsAuthSubprotocol, token],
    );
    await first.ready.timeout(timeout);
    if (first.protocol == kWsAuthSubprotocol) return first;
    unawaited(first.sink.close());
  } catch (_) {
    // 수락 안 함(1008 거절)·시간 초과 — 아래 쿼리 토큰 연결로 한 번 더 간다.
    final c = first;
    if (c != null) unawaited(c.sink.close().catchError((Object _) {}));
  }
  return WebSocketChannel.connect(full);
}
