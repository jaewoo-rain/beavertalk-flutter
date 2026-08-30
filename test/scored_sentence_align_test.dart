import 'package:beavertalk/screens/home/learning_intro.dart';
import 'package:flutter_test/flutter_test.dart';

/// 결과 화면의 문장은 **원문**을 그리고 색만 채점에서 가져온다.
///
/// 예전에는 `char_scores` 를 그대로 이어붙였는데, 서버가 그 목록에 공백과 구두점을
/// 안 담아서 「저는 학생이에요.」가 화면에서 「저는학생이에요」로 나왔다
/// (실측 2026-08-30 · review 208·209).
void main() {
  group('alignScoresToText', () {
    test('공백과 마침표는 채점에 없어도 자리를 지킨다', () {
      // 서버 실측값: char_scores 는 7글자뿐이고 공백·마침표가 없다.
      final align = alignScoresToText(
        '저는 학생이에요.',
        const ['저', '는', '학', '생', '이', '에', '요'],
      );

      // 원문 길이만큼 나온다 — 글자가 사라지지 않는다는 뜻이다.
      expect(align.length, '저는 학생이에요.'.length);
      // 공백(2)과 마침표(8)만 대응이 없다.
      expect(align, const [0, 1, -1, 2, 3, 4, 5, 6, -1]);
    });

    test('채점 글자가 원문 순서대로 매핑된다', () {
      final align = alignScoresToText('저는 제나예요.', const ['저', '는', '제', '나', '예', '요']);
      // 색을 입힐 자리의 인덱스가 어긋나면 엉뚱한 글자가 빨개진다.
      expect(align.where((i) => i >= 0).toList(), const [0, 1, 2, 3, 4, 5]);
    });

    test('채점이 비면 전부 대응 없음이다', () {
      expect(alignScoresToText('안녕', const []), const [-1, -1]);
    });

    test('원문과 다른 문장이 오면 대응이 0건이다', () {
      // 호출부는 이 경우를 폴백 신호로 쓴다 — 색이 정보의 본체라서, 원문을 포기하고
      // 채점된 글자를 잇는 쪽이 낫다.
      final align = alignScoresToText('안녕하세요', const ['学', '生']);
      expect(align.where((i) => i >= 0), isEmpty);
    });

    test('여러 글자로 된 자소(이모지)도 한 자리로 센다', () {
      // `.characters` 를 쓰는 이유 — split('') 이면 서로게이트 페어가 쪼개진다.
      final align = alignScoresToText('가🇰🇷나', const ['가', '나']);
      expect(align.length, 3);
      expect(align, const [0, -1, 1]);
    });
  });
}
