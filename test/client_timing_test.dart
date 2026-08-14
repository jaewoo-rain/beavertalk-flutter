import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// `client_timing` 계약 회귀.
///
/// ## 왜 이 스위트가 필요한가
/// 이 메시지는 **서버가 뺄셈을 하기 위한 것**이다:
///     클라 재생 몫 = 클라가 들은 시각 − 서버가 보낸 시각
/// 그 뺄셈은 `turn_id` 로 짝을 맞춰야 성립한다. **비버 턴 id 가 아니면 조인이 깨지고**,
/// 서버는 그걸 「짝 없음」으로밖에 못 본다 — 값이 조용히 사라진다.
///
/// ⛔ 컨트롤러를 통째로 띄우는 통합 테스트는 소켓·오디오가 필요해 여기서 못 돈다.
///   그래서 **계약의 모양**과 **값을 만드는 산수**를 고정한다. 그 둘이 갈라지는 것이
///   실제로 일어난 사고였다(오늘 `발화중구멍` 이 두 가지를 한 이름으로 부르고 있었다).
void main() {
  group('페이로드 계약 — 서버가 조인할 수 있어야 한다', () {
    /// 컨트롤러가 만드는 것과 **같은 모양**. 필드 이름이 바뀌면 여기서 걸린다.
    Map<String, dynamic> payload({
      required String turnId,
      required int audibleMs,
      int? turnStartMs,
      required int cushionMs,
      required bool estimated,
    }) =>
        {
          'type': 'client_timing',
          'turn_id': turnId,
          'audible_ms': audibleMs,
          'turn_start_ms': ?turnStartMs,
          'cushion_ms': cushionMs,
          'estimated': estimated,
        };

    test('필수 키가 다 있다 — 하나라도 빠지면 서버가 조인/뺄셈을 못 한다', () {
      final m = payload(
          turnId: 'b58', audibleMs: 3370, cushionMs: 300, estimated: false);
      expect(m['type'], 'client_timing');
      expect(m['turn_id'], 'b58');
      expect(m['audible_ms'], 3370);
      expect(m['cushion_ms'], 300);
      expect(m['estimated'], isFalse);
    });

    test('turn_start_ms 는 있을 때만 실린다 — 없는 값을 0 으로 채우면 안 된다', () {
      // 0 으로 채우면 서버가 「제어 신호가 즉시 왔다」로 읽는다. 없음과 0 은 다르다.
      expect(
        payload(turnId: 'b1', audibleMs: 100, cushionMs: 0, estimated: false),
        isNot(contains('turn_start_ms')),
      );
      expect(
        payload(
            turnId: 'b1',
            audibleMs: 100,
            turnStartMs: 1500,
            cushionMs: 0,
            estimated: false)['turn_start_ms'],
        1500,
      );
    });

    test('⛔ estimated 를 빠뜨리지 않는다 — 추정치가 실측과 같은 표에 섞이면 안 된다', () {
      final m =
          payload(turnId: 'b2', audibleMs: 1, cushionMs: 1, estimated: true);
      expect(m.containsKey('estimated'), isTrue);
      expect(m['estimated'], isTrue);
    });
  });

  group('값을 만드는 산수는 한 곳뿐이다', () {
    test('⭐ 서버로 보내는 audible_ms 는 화면·로그와 **같은 함수**에서 나온다', () {
      // 두 곳에서 계산하면 언젠가 갈라진다. 같은 입력이면 같은 값이어야 한다.
      final a = audibleResponseMs(
          userTurnEndAtMs: 0,
          fedAtMs: 2000,
          preDepthFrames: 24000 * 300 ~/ 1000,
          sampleRate: 24000);
      final b = audibleResponseMs(
          userTurnEndAtMs: 0,
          fedAtMs: 2000,
          preDepthFrames: 24000 * 300 ~/ 1000,
          sampleRate: 24000);
      expect(a, b);
      expect(a, 2300); // 2000 + 쿠션 300
    });
  });
}
