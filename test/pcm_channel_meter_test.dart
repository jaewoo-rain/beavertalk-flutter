import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';

/// 플랫폼 채널 계량기 회귀.
///
/// ## 왜 있나 — 이 숫자로 **수술 대상을 고른다**
///
/// 6분 통화에서 빈채널왕복이 3ms → 1,443ms 로 자라는데 네이티브 처리시간은
/// 0.02→0.03ms 로 평평했다(2026-08-13 에뮬, 아바타·힌트 OFF). 그러면 시간은
/// 호출과 처리 **사이**에서 사라지는 것이고 후보가 둘이다:
///
///   ① 처리율 < 도착률 → **미완(sent-done)** 이 시간에 따라 벌어진다
///   ② 건수는 그대로인데 왕복만 늘어난다 → 적체가 채널 **밖**(플랫폼 스레드)에 있다
///
/// 처방이 정반대(①=조각을 키운다 / ②=스레드를 옮긴다)라, 계량기가 틀리면 엉뚱한
/// 수술을 한다. 그래서 계량기 자체를 고정한다.
///
/// ⚠ 여기서 고정하는 것은 **세는 방식**이지 실기기 수치가 아니다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_pcm_sound/methods');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void mock(Future<Object?>? Function(MethodCall)? handler) =>
      messenger.setMockMethodCallHandler(channel, handler);

  setUp(() {
    mock((_) async => null);
    FlutterPcmSound.channelWindow(); // 이전 테스트 잔여를 비우고 시작한다
  });

  tearDown(() => mock(null));

  test('보낸 건수와 완료 건수를 센다 — 정상 상태에선 둘이 같다', () async {
    await FlutterPcmSound.ping();
    await FlutterPcmSound.ping();
    await FlutterPcmSound.ping();

    final w = FlutterPcmSound.channelWindow();
    expect(w.sent, 3);
    expect(w.done, 3);
    expect(w.inflight, 0, reason: '전부 응답이 돌아왔으면 미완은 0 이어야 한다');
  });

  test('창을 읽으면 누적이 리셋된다 — 다음 창이 이전 창을 물려받으면 추세를 못 본다', () async {
    await FlutterPcmSound.ping();
    expect(FlutterPcmSound.channelWindow().sent, 1);
    expect(FlutterPcmSound.channelWindow().sent, 0);
  });

  test('feed 의 인자 바이트를 센다 — "건당 몇 바이트"가 조각 크기 처방의 근거다', () async {
    mock((_) async => 0);
    await FlutterPcmSound.feed(PcmArrayInt16.zeros(count: 100)); // 200B
    await FlutterPcmSound.feed(PcmArrayInt16.zeros(count: 50)); //  100B

    final w = FlutterPcmSound.channelWindow();
    expect(w.bytes, 300);
    expect(w.sent, 2);
  });

  test('⛔ 예외로 끝난 호출도 완료로 센다 — 안 세면 미완이 영영 안 줄어 가짜 결론이 나온다',
      () async {
    mock((_) async => throw PlatformException(code: 'boom'));

    await expectLater(FlutterPcmSound.ping(), throwsA(isA<PlatformException>()));

    final w = FlutterPcmSound.channelWindow();
    expect(w.sent, 1);
    expect(w.done, 1);
    expect(w.inflight, 0);
  });

  test('동시에 여러 건이 날아가면 창최대 미완이 그걸 드러낸다', () async {
    // 응답을 붙잡아 둔 채 3건을 띄운다 = "처리율 < 도착률" 의 최소 재현.
    final gate = Completer<void>();
    mock((_) async {
      await gate.future;
      return null;
    });

    final calls = [
      FlutterPcmSound.ping(),
      FlutterPcmSound.ping(),
      FlutterPcmSound.ping(),
    ];
    await Future<void>.delayed(Duration.zero);

    gate.complete();
    await Future.wait(calls);

    final w = FlutterPcmSound.channelWindow();
    expect(w.inflightMax, greaterThan(1),
        reason: '동시 미완이 1 을 넘은 사실이 창최대에 남아야 한다');
    expect(w.inflight, 0, reason: '다 돌아왔으니 지금 미완은 0');
  });
}
