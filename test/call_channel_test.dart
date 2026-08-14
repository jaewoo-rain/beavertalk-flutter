import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/network/ws_url.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_channel.dart';

/// 이 스위트가 도는 빌드의 컴파일 플래그. `flutter test` 와
/// `flutter test --dart-define=CASCADE_BARGE_IN=true` 가 **서로 다른 것을 검사하게**
/// 만드는 값이다.
const bool kFlagOn = bool.fromEnvironment('CASCADE_BARGE_IN');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // URL 조립이 `Env.apiBaseUrl` 을 타므로 .env 를 세워 준다(ws_url_test 와 같은 방식).
  setUp(() => dotenv.testLoad(
        fileInput: 'API_BASE_URL=https://example.test\n',
      ));
  tearDown(() => dotenv.clean());

  // ⭐ 이 작업의 존재 이유. 예전엔 컴파일 상수라 **한 APK 가 한 통로만** 됐고, 그래서
  //   "두 모드가 다르다"를 한 빌드 안에서 증명할 방법 자체가 없었다.
  group('같은 빌드에서 두 통로가 다르게 동작한다', () {
    test('마이크 정책이 반대다 — 라이브는 게이팅, 캐스케이드는 상시 개방', () {
      expect(CallChannel.live.gatesMic, isTrue);
      expect(CallChannel.cascade.gatesMic, isFalse);
    });

    test('소켓 경로가 다르다', () {
      expect(CallChannel.live.wsPath, '/calls/stream');
      expect(CallChannel.cascade.wsPath, '/cascade/stream');
      expect(CallChannel.live.wsPath, isNot(CallChannel.cascade.wsPath));
    });

    test('URL 선택이 통로를 따라간다', () {
      final live = callStreamWsUrl(token: 't', cascade: false);
      final cascade = callStreamWsUrl(token: 't', cascade: true);
      expect(live, contains(CallChannel.live.wsPath));
      expect(cascade, contains(CallChannel.cascade.wsPath));
      expect(live, isNot(cascade));
    });

    test('isCascade 는 통로 하나만 참이다', () {
      expect(CallChannel.live.isCascade, isFalse);
      expect(CallChannel.cascade.isCascade, isTrue);
    });
  });

  group('두 통로가 공유하는 것', () {
    test('호스트가 같다 — 통로를 바꿔도 백엔드가 안 갈린다', () {
      final live = Uri.parse(callStreamWsUrl(token: 't', cascade: false));
      final cascade = Uri.parse(callStreamWsUrl(token: 't', cascade: true));
      expect(cascade.scheme, live.scheme);
      expect(cascade.host, live.host);
      expect(cascade.port, live.port);
    });

    test('토큰이 같은 자리에 같은 방식으로 실린다 — 통로 전환에 토큰 경로 변경이 없다', () {
      // 서버도 둘 다 `verify_token` 으로 Supabase 액세스 토큰을 본다.
      const token = 'a.b+c/d=';
      for (final cascade in [false, true]) {
        final u = Uri.parse(callStreamWsUrl(token: token, cascade: cascade));
        expect(u.queryParameters['token'], token,
            reason: 'cascade=$cascade 에서 토큰이 깨졌다');
      }
    });

    test('`/api/v1` 접두는 유지된다 — 서버가 두 라우터를 같은 prefix 로 마운트한다', () {
      for (final cascade in [false, true]) {
        expect(callStreamWsUrl(token: 't', cascade: cascade), contains('/api/v1/'));
      }
    });
  });

  group('기본 통로 — bool.fromEnvironment 는 지운 게 아니라 강등됐다', () {
    // ⚠ 이 그룹이 플래그on 스위트를 의미 있게 만든다. 이 테스트가 없으면
    //   `--dart-define=CASCADE_BARGE_IN=true` 로 도는 스위트가 플래그와 무관한 테스트
    //   287건을 그대로 다시 도는 것뿐이고, **플래그가 아무 일도 안 해도 통과한다.**
    test('CASCADE_BARGE_IN 을 그대로 따라간다', () {
      expect(
        CallChannel.defaultChannel,
        kFlagOn ? CallChannel.cascade : CallChannel.live,
      );
    });

    test('그 결과 마이크 정책도 플래그를 따라간다', () {
      // 상수를 런타임 값으로 내리면서 조용히 끊어지기 가장 쉬운 연결이다 —
      // defaultChannel 만 맞고 게이팅이 안 따라오면 아무도 모른다.
      expect(CallChannel.defaultChannel.gatesMic, !kFlagOn);
    });

    test('플래그를 안 켠 빌드의 기본은 라이브 + 게이팅이다 (동작 무변화 보장)', () {
      if (kFlagOn) return; // 플래그on 스위트에서는 위 두 건이 반대를 검사한다
      expect(CallChannel.defaultChannel, CallChannel.live);
      expect(CallChannel.defaultChannel.gatesMic, isTrue);
      expect(CallChannel.defaultChannel.wsPath, '/calls/stream');
    });
  });

  // ⭐ A안(2026-08-12) 회귀망 — 캐스케이드 소켓만 데모 서버로 보낸다.
  //   두 가지를 **동시에** 고정한다: 라이브 URL 불변 · 캐스케이드 URL 이 오버라이드를 따라감.
  //   하나만 고정하면 나머지 하나가 조용히 깨진다(둘 다 "그냥 URL"이라 에러가 안 난다).
  group('캐스케이드 전용 호스트 오버라이드', () {
    const prod = 'https://prod.test';
    const demo = 'https://demo.test';

    void loadEnv({String? cascade}) {
      dotenv.clean();
      final lines = <String>['API_BASE_URL=$prod'];
      if (cascade != null) lines.add('CASCADE_API_BASE_URL=$cascade');
      dotenv.testLoad(fileInput: lines.join('\n'));
    }

    test('⛔ 라이브 URL 은 오버라이드가 있든 없든 한 글자도 안 바뀐다', () {
      loadEnv();
      final without = normalcallWsUrl('t');
      loadEnv(cascade: demo);
      final with_ = normalcallWsUrl('t');
      expect(with_, without);
      expect(with_, 'wss://prod.test/api/v1/calls/stream?token=t');
    });

    test('⛔ 발음 STT 도 안 바뀐다 — 같은 _wsBase 를 공유한다', () {
      loadEnv();
      final without = pronSttWsUrl('t');
      loadEnv(cascade: demo);
      expect(pronSttWsUrl('t'), without);
    });

    test('캐스케이드는 오버라이드 호스트로 간다', () {
      loadEnv(cascade: demo);
      expect(cascadeWsUrl('t'), 'wss://demo.test/api/v1/cascade/stream?token=t');
      // 같은 빌드에서 두 통로가 **다른 호스트**로 간다 — 이게 A안의 정의다.
      expect(Uri.parse(cascadeWsUrl('t')).host,
          isNot(Uri.parse(normalcallWsUrl('t')).host));
    });

    test('키가 없으면 캐스케이드도 API_BASE_URL 로 폴백한다 (동작 무변화)', () {
      loadEnv();
      expect(cascadeWsUrl('t'), 'wss://prod.test/api/v1/cascade/stream?token=t');
      expect(Uri.parse(cascadeWsUrl('t')).host,
          Uri.parse(normalcallWsUrl('t')).host);
    });

    test('빈 값도 미설정과 같게 다룬다 — 공백 한 칸이 통로를 갈라선 안 된다', () {
      dotenv.clean();
      dotenv.testLoad(
        fileInput: ['API_BASE_URL=$prod', 'CASCADE_API_BASE_URL=   '].join('\n'),
      );
      expect(Uri.parse(cascadeWsUrl('t')).host, 'prod.test');
    });

    test('오버라이드에도 /api/v1 접두와 토큰 인코딩이 그대로 붙는다', () {
      loadEnv(cascade: demo);
      final u = Uri.parse(cascadeWsUrl('a+b/c='));
      expect(u.path, '/api/v1/cascade/stream');
      expect(u.queryParameters['token'], 'a+b/c=');
    });
  });
}
