import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// `call_ended.call_id` 회귀.
///
/// ## 왜 이 테스트가 있나
///
/// 서버는 통화 행이 없을 때 `call_id` 를 **null 이 아니라 빈 문자열**로 보낸다
/// (`cascade_session.py:3198`). 예전 코드는 `id?.toString()` 이라 `""` 가 그대로 통과했고,
/// 그러면 앱은 **id 를 가졌다고 믿는다.**
///
/// 그 결과가 최악인 이유: `call_finish.dart` 의 `_analyze()` 는 `callId == null` 일 때만
/// `_recoverCallId()`(GET /calls 폴링)를 부른다. 빈 문자열이 통과하면
/// **복구가 가장 필요한 경우(통화 행이 없다)에 정확히 복구가 죽고**, 빈 id 로 분석을 친다.
void main() {
  group('빈 call_id 는 없는 것으로 본다 (복구 폴링이 돌아야 한다)', () {
    test('⛔ 빈 문자열 — 서버가 실제로 보내는 값이다', () {
      expect(normalizeCallId(''), isNull);
    });

    test('공백만 있는 값도 마찬가지다', () {
      expect(normalizeCallId('   '), isNull);
      expect(normalizeCallId('\t\n'), isNull);
    });

    test('없으면(null) 그대로 null 이다', () {
      expect(normalizeCallId(null), isNull);
    });

    test('진짜 id 는 그대로 살아남는다 — 방어가 정상 경로를 먹으면 안 된다', () {
      expect(normalizeCallId('123'), '123');
      expect(normalizeCallId(123), '123'); // 서버가 int 로 보내도 받는다
      expect(normalizeCallId(' 42 '), '42'); // 양끝 공백만 털어낸다
    });

    test('0 은 유효한 값이다 — 거짓같은 값이라고 버리면 안 된다', () {
      expect(normalizeCallId(0), '0');
      expect(normalizeCallId('0'), '0');
    });
  });
}
