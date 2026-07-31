import 'package:beavertalk/features/pronunciation_challenge/data/stt_ws_url.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

/// 발음 챌린지 STT 주소 회귀.
///
/// 이 주소가 틀리면 게임은 **정상으로 보인다** — SttService 가 연결 실패를 던지지 않고
/// 탭 입력으로 조용히 폴백하기 때문이다. 실제로 리전이 us-central1 로 박혀 있어(서비스는
/// asia-northeast3) 오래 안 드러났다. 그래서 "조용한 실패"를 테스트로 붙잡는다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => dotenv.clean());

  test('.env 없이도 ws 스킴 + 올바른 경로로 조립된다', () {
    dotenv.testLoad(fileInput: '');
    final url = pronSttWsUrl();
    expect(url, startsWith('wss://'));
    expect(url, endsWith('/api/v1/pron/stt/ws'));
  });

  test('기본 상수가 죽은 리전(us-central1)을 가리키지 않는다', () {
    dotenv.testLoad(fileInput: '');
    // us-central1 주소는 Cloud Run 이 아니라 구글 404 페이지를 준다(= 서비스 없음).
    expect(pronSttWsUrl(), isNot(contains('us-central1')));
    // STT 는 app 백엔드에 없다(WS 핸드셰이크 403). web 백엔드여야 한다.
    expect(pronSttWsUrl(), contains('beavertalk-web-api'));
    expect(pronSttWsUrl(), isNot(contains('app-api')));
    expect(pronSttWsUrl(), isNot(contains('app-demo-api')));
  });

  test('.env 의 PRON_STT_WS_ORIGIN 이 상수를 이긴다 (스킴 정규화 포함)', () {
    dotenv.testLoad(
      fileInput: 'PRON_STT_WS_ORIGIN=https://example.test/\n',
    );
    expect(pronSttWsUrl(), 'wss://example.test/api/v1/pron/stt/ws');
  });

  test('bare host 와 http 도 ws 스킴으로 정규화된다', () {
    dotenv.testLoad(fileInput: 'PRON_STT_WS_ORIGIN=192.168.0.30:8080\n');
    expect(pronSttWsUrl(), 'wss://192.168.0.30:8080/api/v1/pron/stt/ws');

    dotenv.clean();
    dotenv.testLoad(fileInput: 'PRON_STT_WS_ORIGIN=http://192.168.0.30:8080\n');
    expect(pronSttWsUrl(), 'ws://192.168.0.30:8080/api/v1/pron/stt/ws');
  });
}
