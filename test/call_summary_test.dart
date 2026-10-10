import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_channel.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// 통화 요약 줄 회귀.
///
/// ## 왜 있나 — 이 줄이 실기기에서 **거짓을 말했다**(2026-08-12)
///
/// 캐스케이드 통화였는데 `통로=live` 로 찍혔다. 값이 틀린 게 아니라 **읽는 시점**이
/// 틀렸다: `_teardown` 이 통로를 기본값(live)으로 되돌린 **뒤에** 요약이 찍혔다.
/// 되돌리기 자체는 안전장치라 유지해야 한다(안 되돌리면 다음 통화가 게이팅 없이 열린다).
///
/// ⭐ 그래서 "로그를 리셋 위로 옮긴다"로 고치지 않았다 — 그건 **순서 의존** 수리라
/// 다음에 리셋이 재배치되면 같은 버그가 돌아온다. 요약이 통로를 **인자로 받게** 만들어
/// 필드를 아예 못 읽게 했고, 호출부는 함수 진입 시점 값을 넘긴다.
///
/// ⚠ 한계: 여기서 고정하는 것은 **"요약은 받은 통로를 그대로 말한다"** 이지
/// "호출부가 올바른 시점에 붙잡는다"가 아니다. 후자는 컨트롤러 인스턴스가 필요하고,
/// 실기기 로그가 그 증거가 된다.
void main() {
  group('요약 줄은 넘겨받은 통로를 그대로 말한다', () {
    test('캐스케이드로 넘기면 cascade 라고 말한다 — 실기기에서 틀렸던 자리', () {
      final line = buildCallSummaryLine(
        sentences: 5,
        pendingMarkers: 0,
        oddFrames: 0,
        channel: CallChannel.cascade,
      );
      expect(line, contains('통로=cascade'));
      expect(line, isNot(contains('통로=live')));
    });

    test('라이브로 넘기면 live 라고 말한다', () {
      expect(
        buildCallSummaryLine(
          sentences: 0, pendingMarkers: 0, oddFrames: 0,
          channel: CallChannel.live,
        ),
        contains('통로=live'),
      );
    });

    test('⛔ 기본값과 **반대** 통로를 넘겨도 넘긴 값을 쓴다 — 필드를 안 읽는다는 증명', () {
      // ⚠ 기본값을 하드코딩하지 않는다. 이 스위트는 `--dart-define=CASCADE_BARGE_IN=true`
      //   로도 도는데, 그때 defaultChannel 은 cascade 다 — 하드코딩하면 그 판에서 깨진다
      //   (실제로 한 번 깼다). 어느 쪽이 기본이든 **반대쪽**을 넘겨 검사한다.
      final other = CallChannel.defaultChannel == CallChannel.live
          ? CallChannel.cascade
          : CallChannel.live;
      expect(
        buildCallSummaryLine(
          sentences: 1, pendingMarkers: 0, oddFrames: 0,
          channel: other,
        ),
        contains('통로=${other.name}'),
      );
    });

    test('진단 3종이 다 들어간다 — 하나라도 빠지면 원인을 못 가른다', () {
      final line = buildCallSummaryLine(
        sentences: 5, pendingMarkers: 2, oddFrames: 3,
        channel: CallChannel.cascade,
      );
      expect(line, contains('sentence=5'));
      expect(line, contains('미발화마커=2'));
      expect(line, contains('odd_frames=3'));
    });
  });
}
