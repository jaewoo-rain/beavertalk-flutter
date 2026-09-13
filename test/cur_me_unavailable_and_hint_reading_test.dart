// 2026-09-13 계약 두 건.
//
// ① `/cur/me` 에 language·available 추가. available=false 면 lesson·status 가 **null**,
//    items 0, open 둘 다 false, next_course=expression — 앱은 죽지 않고 홈에 «{언어}
//    커리큘럼은 준비 중이에요» 를 그린다. 사장님 계정(target=en)이 운영에서 500 을 받던
//    화면이다. 두 키가 없으면(구서버) available=true — 종전 동작.
// ② 힌트 HintExample.reading(가나, 일본어만). 카드가 표면형 아래 작은 글씨로 그리고,
//    없으면 아무것도 안 그려 한국어 화면은 픽셀이 안 바뀐다.

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/molecules/hint_card.dart';
import 'package:beavertalk/components/organisms/home_gnb.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_hint.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

Widget _ko(Widget child) => MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  group('CurMe — language·available', () {
    test('available=false: lesson·status null 이어도 죽지 않고 빈 값으로 읽는다', () {
      final m = CurMe.fromJson({
        'language': 'en',
        'available': false,
        'lesson': null,
        'status': null,
        'items_total': 0,
        'items_drilled': 0,
        'open': {'expression': false, 'freetalk': false},
        'next_course': 'expression',
      });

      expect(m.available, isFalse);
      expect(m.language, 'en');
      expect(m.lesson.code, '');
      expect(m.status, '');
      expect(m.itemsTotal, 0);
      expect(m.openExpression, isFalse);
      expect(m.nextCourse, CallCourse.expression);
    });

    test('⭐ 두 키가 없으면(구서버) available=true — 종전 동작 그대로', () {
      final m = CurMe.fromJson({
        'lesson': {'no': 4, 'code': 'A1-T01-1', 'level_no': 1},
        'status': 'learning',
        'items_total': 18,
        'items_drilled': 16,
        'open': {'expression': true, 'freetalk': false},
        'next_course': 'expression',
      });

      expect(m.available, isTrue);
      expect(m.language, isNull);
      expect(m.lesson.code, 'A1-T01-1');
    });

    test('available 이 bool 이 아니면 true — 모르면 종전 쪽', () {
      expect(CurMe.fromJson({'available': 'no'}).available, isTrue);
    });
  });

  group('HomeCourse.fromCurMe — unavailable 은 noLevel 과 다른 변형이다', () {
    test('available=false → unavailable + 언어', () {
      final c = HomeCourse.fromCurMe(CurMe.fromJson({
        'language': 'en',
        'available': false,
        'next_course': 'expression',
      }));
      expect(c.kind, HomeCourseKind.unavailable);
      expect(c.language, 'en');
    });

    test('available=true 인데 차시가 비면 noLevel(종전) — 겹치지 않는다', () {
      final c = HomeCourse.fromCurMe(CurMe.fromJson({'available': true}));
      expect(c.kind, HomeCourseKind.noLevel);
    });

    test('languageLabel — 목록에 있으면 그 언어의 자기 이름, 없으면 코드 대문자', () {
      expect(languageLabel('en'), 'English');
      expect(languageLabel('ko'), '한국어', reason: '목록 id 가 ko-KR 이어도 맞춘다');
      expect(languageLabel('xx'), 'XX', reason: '지어내지 않는다');
      expect(languageLabel(null), '');
    });
  });

  testWidgets('홈 학습 현황 — 준비 중 변형: «English 커리큘럼은 준비 중이에요» + 안내', (tester) async {
    await tester.pumpWidget(_ko(const HomeGnb(
      course: HomeCourse(kind: HomeCourseKind.unavailable, language: 'en'),
    )));
    await tester.pump();

    expect(find.text('준비 중'), findsOneWidget, reason: '중립 배지');
    expect(find.text('English 커리큘럼은 준비 중이에요'), findsOneWidget);
    expect(find.text('일반 표현학습으로 통화해요'), findsOneWidget);
    expect(find.text('표현학습'), findsNothing, reason: '오른쪽 코스 라벨은 없다(noLevel 과 같은 모양)');
  });

  group('HintExample.reading — 가나', () {
    test('키가 있으면 읽고, 없으면 null', () {
      final ja = HintExample.fromJson({
        'korean': '駅はどこですか',
        'reading': 'えきはどこですか',
        'roman': 'eki wa doko desu ka',
        'native': 'Where is the station?',
      });
      expect(ja.reading, 'えきはどこですか');

      final ko = HintExample.fromJson({'korean': '화장실에 가요', 'native': 'restroom'});
      expect(ko.reading, isNull);
    });

    testWidgets('카드: reading 이 있으면 표면형 아래 작은 글씨, 없으면 그 줄이 없다', (tester) async {
      final hint = HintData.fromJson({
        'type': 'hint',
        'turn_id': 't1',
        'examples': [
          {
            'korean': '駅はどこですか',
            'reading': 'えきはどこですか',
            'native': 'Where is the station?',
          },
        ],
      })!;
      await tester.pumpWidget(_ko(HintCard(
        examples: hint.examples,
        revealed: true,
        index: 0,
        onReveal: () {},
        onCycle: () {},
      )));
      await tester.pump();
      expect(find.text('えきはどこですか'), findsOneWidget);

      final koHint = HintData.fromJson({
        'type': 'hint',
        'turn_id': 't2',
        'examples': [
          {'korean': '화장실에 가요', 'native': 'restroom'},
        ],
      })!;
      await tester.pumpWidget(_ko(HintCard(
        examples: koHint.examples,
        revealed: true,
        index: 0,
        onReveal: () {},
        onCycle: () {},
      )));
      await tester.pump();
      // 표면형·뜻만 — 두 Text. reading 줄이 끼어들지 않는다(픽셀 불변의 근거).
      expect(find.text('화장실에 가요'), findsOneWidget);
      expect(find.text('restroom'), findsOneWidget);
    });
  });
}
