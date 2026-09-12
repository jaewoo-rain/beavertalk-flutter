// 홈 학습 현황 매핑 — `GET /cur/me` 응답이 어느 변형으로 떨어지는가.
//
// 이 매핑에는 **서버가 말해 주지 않는 판단이 하나** 들어 있다. 「레벨 미정」은
// `CurMe` 에 플래그로 오지 않고 *차시가 비어 있는 것*으로만 드러난다. 그 해석이
// 틀리면 레벨이 있는 사용자에게 「아직 레벨이 없어요」를 띄우게 되므로, 경계를
// 여기서 못 박는다.
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/organisms/home_gnb.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';

/// `GET /cur/me` 응답 한 장. 서버 `CurMeOut` 의 필드 이름을 그대로 쓴다.
Map<String, dynamic> _json({
  String code = 'A1-T01-1',
  int levelNo = 1,
  String? topic = '처음 만난 반 친구와 이름과 나라 말하기',
  String? situation,
  int itemsTotal = 18,
  int itemsDrilled = 4,
  String nextCourse = 'expression',
  bool openFreetalk = false,
}) =>
    <String, dynamic>{
      'lesson': <String, dynamic>{
        'no': 1,
        'code': code,
        'level_no': levelNo,
        'topic': ?topic,
        'situation': ?situation,
      },
      'status': 'learning',
      'items_total': itemsTotal,
      'items_drilled': itemsDrilled,
      'open': <String, dynamic>{
        'expression': true,
        'freetalk': openFreetalk,
      },
      'next_course': nextCourse,
    };

void main() {
  group('HomeCourse.fromCurMe', () {
    test('표현학습 — 남은 개수는 total 에서 drilled 를 뺀 값이다', () {
      final c = HomeCourse.fromCurMe(CurMe.fromJson(_json()));

      expect(c.kind, HomeCourseKind.expression);
      expect(c.unitCode, 'A1-1'); // A1-T01-1 에서 상황 칸을 뺀다
      expect(c.topic, '처음 만난 반 친구와 이름과 나라 말하기');
      expect(c.expressionsLeft, 14); // 18 - 4
    });

    test('next_course 가 freetalk 면 자유회화로 간다 — 배지·주제는 그대로다', () {
      final c = HomeCourse.fromCurMe(
        CurMe.fromJson(_json(nextCourse: 'freetalk', openFreetalk: true)),
      );

      expect(c.kind, HomeCourseKind.freetalk);
      // 자유회화에서도 단원과 주제는 계속 보인다 — 바뀌는 건 셋째 줄뿐이다.
      expect(c.unitCode, 'A1-1');
      expect(c.topic, isNotEmpty);
    });

    test('주제가 없으면 상황문이 대신 선다', () {
      final c = HomeCourse.fromCurMe(
        CurMe.fromJson(_json(topic: null, situation: '교실에서 처음 인사하기')),
      );

      expect(c.topic, '교실에서 처음 인사하기');
    });

    test('차시 코드가 비면 레벨 미정이다 — 단원도 주제도 지운다', () {
      final c = HomeCourse.fromCurMe(CurMe.fromJson(_json(code: '')));

      expect(c.kind, HomeCourseKind.noLevel);
      // 🔴 남겨 두면 「레벨 미정」배지 옆에 단원이 붙어 모순된 화면이 된다.
      expect(c.unitCode, isNull);
      expect(c.topic, isNull);
    });

    test('레벨 번호가 0이어도 레벨 미정이다', () {
      final c = HomeCourse.fromCurMe(CurMe.fromJson(_json(levelNo: 0)));

      expect(c.kind, HomeCourseKind.noLevel);
    });

    test('빈 응답도 레벨 미정으로 떨어진다 — 던지지 않는다', () {
      // 서버가 아직 차시를 못 정한 회원에게 `{}` 를 줄 수 있다.
      // 여기서 예외가 나면 홈 전체가 에러 화면이 된다.
      final c = HomeCourse.fromCurMe(CurMe.fromJson(const {}));

      expect(c.kind, HomeCourseKind.noLevel);
    });

    test('drilled 가 total 을 넘겨도 남은 개수는 음수가 되지 않는다', () {
      final c = HomeCourse.fromCurMe(
        CurMe.fromJson(_json(itemsTotal: 18, itemsDrilled: 20)),
      );

      // 「표현 -2개 남음」은 나오면 안 된다.
      expect(c.expressionsLeft, 0);
    });
  });

  group('HomeCourse.badgeCode', () {
    test('상황 칸을 뺀다 — 레벨과 순번만 남는다', () {
      expect(HomeCourse.badgeCode('A1-T01-1'), 'A1-1');
      expect(HomeCourse.badgeCode('A1-T03-12'), 'A1-12');
      expect(HomeCourse.badgeCode('B2-T10-7'), 'B2-7');
    });

    test('칸이 셋이 아니면 손대지 않는다', () {
      // 🔴 서버가 코드 모양을 바꿨을 때 엉뚱한 조각을 이어 붙이면 **틀린 차시
      //    번호**가 된다. 맞는 긴 번호보다 나쁘다.
      expect(HomeCourse.badgeCode('A1-1'), 'A1-1');
      expect(HomeCourse.badgeCode('A1'), 'A1');
      expect(HomeCourse.badgeCode('A1-T01-1-x'), 'A1-T01-1-x');
      expect(HomeCourse.badgeCode(''), '');
    });
  });
}
