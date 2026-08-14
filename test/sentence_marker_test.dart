import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// `sentence` 마커 회귀.
///
/// 여기서 고정하는 것은 **순수 판정 로직**이다 — 위치 발화(봉투 큐)와 취소 폐기는
/// 컨트롤러 인스턴스가 필요해 실기기/위젯 경로에서 확인한다(그 경계는 코드 주석에 적어 뒀다).
void main() {
  group('emotion 라벨 → 코드 (모르면 neutral)', () {
    // ⚠ 서버가 한글 라벨을 줄지 영문 슬러그를 줄지 아직 확정 전이라 **둘 다** 받는다.
    test('영문 슬러그 5종', () {
      expect(emotionCodeForTest('neutral'), 0);
      expect(emotionCodeForTest('happy'), 1);
      expect(emotionCodeForTest('surprised'), 2);
      expect(emotionCodeForTest('sad'), 3);
      expect(emotionCodeForTest('angry'), 4);
    });

    test('한글 라벨도 같은 코드로 떨어진다', () {
      expect(emotionCodeForTest('기쁨'), 1);
      expect(emotionCodeForTest('놀람'), 2);
      expect(emotionCodeForTest('슬픔'), 3);
      expect(emotionCodeForTest('화남'), 4);
    });

    test('대소문자·공백을 견딘다', () {
      expect(emotionCodeForTest(' HAPPY '), 1);
      expect(emotionCodeForTest('Sad'), 3);
    });

    test('⛔ 모르는 값은 neutral 이다 — 화이트리스트로 막지 않는다', () {
      // 표정만 안 바꿀 뿐, 이 값 때문에 자막까지 버리면 안 된다.
      expect(emotionCodeForTest('excited'), 0);
      expect(emotionCodeForTest('두근두근'), 0);
      expect(emotionCodeForTest(''), 0);
      expect(emotionCodeForTest(null), 0);
    });
  });
}
