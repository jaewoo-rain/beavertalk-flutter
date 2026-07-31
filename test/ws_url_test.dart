import 'package:beavertalk/core/network/ws_url.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

/// WebSocket 주소 조립 회귀 — 통화 스트림 + 발음 챌린지 STT.
///
/// 발음 챌린지 STT 가 오래 죽어 있었다. 원인은 두 겹이었다:
///   ① 별도 파일(stt_ws_url.dart)이 **웹 백엔드 주소를 하드코딩**했고 그마저 리전이
///      틀려(us-central1, 실제는 asia-northeast3) 존재하지 않는 호스트였다.
///   ② 그 웹 백엔드는 인증이 없어 토큰 없이도 핸드셰이크가 통과한다. 반면 앱 서버의
///      /pron/stt/ws 는 **토큰 필수**(과금 방어)라, 웹용 주소를 그대로 쓰면 앱 서버로
///      옮기는 순간 1008 로 닫힌다.
/// SttService 는 연결 실패를 던지지 않고 탭 입력으로 폴백하므로(설계), 게임은 멀쩡히
/// 돌고 음성만 안 먹는 상태가 오래 안 드러났다. 그래서 주소 조립을 테스트로 고정한다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => dotenv.testLoad(
        fileInput: 'API_BASE_URL=https://example.test\n',
      ));
  tearDown(() => dotenv.clean());

  test('STT 는 API_BASE_URL 을 따라간다 — 호스트를 따로 박지 않는다', () {
    final url = pronSttWsUrl('tok');
    expect(url, startsWith('wss://example.test/api/v1/'));
    // 웹 백엔드로 새지 않는다(예전 하드코딩의 흔적).
    expect(url, isNot(contains('beavertalk-web-api')));
    expect(url, isNot(contains('us-central1')));
  });

  test('STT 는 토큰을 싣는다 — 없으면 서버가 1008 로 닫는다', () {
    expect(pronSttWsUrl('tok'), endsWith('/pron/stt/ws?token=tok'));
  });

  test('토큰은 퍼센트 인코딩된다 — JWT 의 =·+·/ 가 살아남아야 한다', () {
    final url = pronSttWsUrl('a+b/c=d');
    expect(url, endsWith('token=a%2Bb%2Fc%3Dd'));
  });

  test('통화 스트림과 STT 가 같은 호스트·스킴을 쓴다', () {
    final call = Uri.parse(normalcallWsUrl('t'));
    final stt = Uri.parse(pronSttWsUrl('t'));
    expect(stt.scheme, call.scheme);
    expect(stt.host, call.host);
  });

  test('http 베이스는 ws 로 내려간다(로컬 개발)', () {
    dotenv.clean();
    dotenv.testLoad(fileInput: 'API_BASE_URL=http://192.168.0.30:8000\n');
    expect(pronSttWsUrl('t'), startsWith('ws://192.168.0.30:8000/api/v1/'));
  });
}
