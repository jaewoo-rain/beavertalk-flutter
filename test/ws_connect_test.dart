import 'package:beavertalk/core/network/ws_connect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stripTokenQuery removes only the token query (PM-DEC-1017)', () {
    final u = Uri.parse('wss://h.example/api/v1/calls/stream?token=abc.def-ghi&os=android&app_version=1.0.1');
    final s = stripTokenQuery(u);
    expect(s.queryParameters.containsKey('token'), isFalse);
    expect(s.queryParameters['os'], 'android');
    expect(s.queryParameters['app_version'], '1.0.1');
    expect(s.path, '/api/v1/calls/stream');
    expect(s.scheme, 'wss');
  });

  test('stripTokenQuery leaves no dangling ? when token was the only query', () {
    final s = stripTokenQuery(Uri.parse('wss://h.example/api/v1/pron/stt/ws?token=abc'));
    expect(s.toString(), 'wss://h.example/api/v1/pron/stt/ws');
  });

  test('subprotocol marker matches the server', () {
    expect(kWsAuthSubprotocol, 'bt.auth');
  });
}
