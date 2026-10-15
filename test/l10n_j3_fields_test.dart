// 2026-10-16 PM-DEC-674 — 서버 J2 새 필드(topic_translation · 목록 situation_translation)와 결제 라벨 현지화.
import 'package:beavertalk/components/organisms/home_gnb.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/payment/domain/payment_label.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _me(Map<String, dynamic> lesson) => {
      'language': 'ko',
      'available': true,
      'lesson': {'no': 5, 'code': 'A1-T02-1', 'level_no': 2, ...lesson},
      'status': 'learning',
      'items_total': 10,
      'items_drilled': 0,
      'open': {'expression': true, 'freetalk': false},
      'next_course': 'expression',
    };

void main() {
  group('CurLesson.topicTranslation', () {
    test('새 키를 읽는다', () {
      final me = CurMe.fromJson(_me({'topic': '가족과 친척', 'topic_translation': 'Gia đình và họ hàng'}));
      expect(me.lesson.topicTranslation, 'Gia đình và họ hàng');
      expect(HomeCourse.fromCurMe(me).topic, 'Gia đình và họ hàng');
    });

    test('구서버(키 없음)는 종전대로 원문 주제', () {
      final me = CurMe.fromJson(_me({'topic': '가족과 친척'}));
      expect(me.lesson.topicTranslation, isNull);
      expect(HomeCourse.fromCurMe(me).topic, '가족과 친척');
    });

    test('주제 없는 차시는 상황 번역 → 상황 원문 · 빈 문자열은 null 로 걸러 빈 줄이 없다', () {
      final a = CurMe.fromJson(_me({'topic': null, 'topic_translation': '  ', 'situation': '인사하기', 'situation_translation': 'Greeting'}));
      expect(HomeCourse.fromCurMe(a).topic, 'Greeting');
      final b = CurMe.fromJson(_me({'situation': '인사하기'}));
      expect(HomeCourse.fromCurMe(b).topic, '인사하기');
    });
  });

  test('CurLessonRow.situationTranslation — 새 키 · 구서버 null', () {
    final r = CurLessonRow.fromJson({'no': 1, 'code': 'L1-S01-1', 'level_no': 1, 'situation': '인사하기', 'situation_translation': 'あいさつ'});
    expect(r.situationTranslation, 'あいさつ');
    final old = CurLessonRow.fromJson({'no': 1, 'code': 'L1-S01-1', 'level_no': 1, 'situation': '인사하기'});
    expect(old.situationTranslation, isNull);
  });

  group('localizedPaymentLabel', () {
    String? f(String? d) => localizedPaymentLabel(d, subscription: 'Subscription payment', character: 'Character purchase', bundle: 'Character bundle purchase');

    test('서버 형식 4종', () {
      expect(f('구독 결제'), 'Subscription payment');
      expect(f('구독 결제 · bt_max_monthly'), 'Subscription payment · bt_max_monthly');
      expect(f('캐릭터 구매: Popo'), 'Character purchase: Popo');
      expect(f('캐릭터 묶음 구매 · bt_character_bundle'), 'Character bundle purchase · bt_character_bundle');
    });

    test('모르는 형식·빈 값은 null(화면이 원문을 보인다)', () {
      expect(f('프리미엄 구독(월간)'), isNull);
      expect(f('구독 결제됨'), isNull);
      expect(f(null), isNull);
      expect(f('  '), isNull);
    });
  });
}
