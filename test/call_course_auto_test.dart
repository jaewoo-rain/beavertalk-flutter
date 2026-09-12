// 커리큘럼 2단계 «자동(auto)» — 서버가 코스를 정하는 통화.
//
// 세 조각이다. (1) `CallCourse.fromWire` — `call_started.course` 를 코스로 읽는다.
// (2) `CurMe.fromJson` — `GET /cur/me`. (3) 개발자 도구 한 줄이 그 값을 그린다.
//
// 서버 계약(a652cdc): protocol.py:107 Literal[…,"auto"] · :319 call_started.course
// Literal["expression","freetalk"] | None(None 이면 키 자체가 빠진다) ·
// schemas/curriculum.py CurMeOut.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';

void main() {
  group('CallCourse.fromWire — call_started.course 읽기', () {
    test('서버 두 값을 그대로 읽는다', () {
      expect(CallCourse.fromWire('expression'), CallCourse.expression);
      expect(CallCourse.fromWire('freetalk'), CallCourse.freetalk);
    });

    test('⛔ "auto" 는 코스가 아니라 요청이다 — 서버가 돌려줄 일이 없고, 와도 null', () {
      // 서버 Literal 은 expression|freetalk 뿐이다. auto 를 코스로 세우면 힌트 UI 는
      // 가려지지만 「무엇을 하는 통화인가」가 영영 안 채워진다.
      expect(CallCourse.fromWire('auto'), isNull);
    });

    test('모르는 값·null·비문자열은 null — 추측하지 않는다', () {
      expect(CallCourse.fromWire('pronunciation'), isNull);
      expect(CallCourse.fromWire(null), isNull);
      expect(CallCourse.fromWire(3), isNull);
    });

    test('대소문자·공백은 관대하게', () {
      expect(CallCourse.fromWire(' Expression '), CallCourse.expression);
    });
  });

  group('CurMe.fromJson — GET /cur/me', () {
    test('정상 — 서버 CurMeOut 을 그대로 읽는다', () {
      final m = CurMe.fromJson({
        'lesson': {
          'no': 4,
          'code': 'A1-T01-1',
          'level_no': 1,
          'situation': '처음 만난 반 친구와 이름과 나라 말하기',
          'topic': '자기소개와 신상',
        },
        'status': 'learning',
        'items_total': 18,
        'items_drilled': 16,
        'open': {'expression': true, 'freetalk': false},
        'next_course': 'expression',
      });

      expect(m.lesson.no, 4);
      expect(m.lesson.code, 'A1-T01-1');
      expect(m.lesson.topic, '자기소개와 신상');
      expect(m.status, 'learning');
      expect(m.itemsTotal, 18);
      expect(m.itemsDrilled, 16);
      expect(m.itemsLeft, 2);
      expect(m.openExpression, isTrue);
      expect(m.openFreetalk, isFalse);
      expect(m.nextCourse, CallCourse.expression);
    });

    test('표현학습을 다 드릴했으면 다음은 프리토킹이고 프리토킹이 열린다', () {
      final m = CurMe.fromJson({
        'lesson': {'no': 4, 'code': 'A1-T01-1', 'level_no': 1},
        'status': 'expression_done',
        'items_total': 18,
        'items_drilled': 18,
        'open': {'expression': true, 'freetalk': true},
        'next_course': 'freetalk',
      });

      expect(m.itemsLeft, 0);
      expect(m.openFreetalk, isTrue);
      expect(m.nextCourse, CallCourse.freetalk);
    });

    test('키가 빠져도 파싱이 멈추지 않는다 — 빈 값으로 읽는다', () {
      // 🔴 한 필드 때문에 개발자 도구 줄이 통째로 안 뜨면 안 된다.
      final m = CurMe.fromJson(const {});

      expect(m.lesson.code, '');
      expect(m.itemsTotal, 0);
      expect(m.itemsLeft, 0, reason: '음수로 내려가지 않는다');
      expect(m.openFreetalk, isFalse, reason: '모르면 잠긴 쪽으로');
      expect(m.nextCourse, isNull);
    });

    test('드릴 수가 총량을 넘어도 남은 수는 0 이다', () {
      final m = CurMe.fromJson({
        'lesson': const {},
        'items_total': 5,
        'items_drilled': 7,
        'open': const {},
      });
      expect(m.itemsLeft, 0);
    });
  });

  group('개발자 도구 한 줄', () {
    Widget host(AsyncValue<CurMe> value) => ProviderScope(
          overrides: [
            curMeProvider.overrideWith((ref) => switch (value) {
                  AsyncData(:final value) => Future.value(value),
                  AsyncError(:final error) => Future<CurMe>.error(error),
                  _ => Completer<CurMe>().future,
                }),
          ],
          child: MaterialApp(
            locale: const Locale('ko'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MyPageScreen(),
          ),
        );

    testWidgets('«차시 N 코드 · 남은 a/b · 상태 · 다음: 코스» 로 그린다', (tester) async {
      tester.view.physicalSize = const Size(375, 2400); // 개발자 카드는 맨 아래다
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(AsyncData(CurMe.fromJson({
        'lesson': {'no': 4, 'code': 'A1-T01-1', 'level_no': 1},
        'status': 'learning',
        'items_total': 18,
        'items_drilled': 16,
        'open': {'expression': true, 'freetalk': false},
        'next_course': 'expression',
      }))));
      await tester.pump(const Duration(milliseconds: 32));
      tester.takeException(); // 다른 카드의 프로바이더는 여기서 목이 없다 — 이 줄만 본다

      expect(
        find.text('차시 4 A1-T01-1 · 남은 2/18 · 상태 learning · 다음: 표현학습 · 프리토킹 잠김'),
        findsOneWidget,
      );
      expect(find.text('자동 통화 (auto)'), findsOneWidget,
          reason: '세 번째 버튼이 카드에 있다');
    });

    testWidgets('⛔ 개발자 카드는 진도 한 줄 + 코스 버튼 3개만 — 옛 항목은 안 그린다',
        (tester) async {
      // 2026-09-12 사장님: 「코스 버튼 3개만」. 코드는 남기고 화면에서만 내렸다
      // (mypage.dart _kLegacyDevTools). 다시 그리게 되면 여기서 걸린다.
      tester.view.physicalSize = const Size(375, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(AsyncData(CurMe.fromJson({
        'lesson': {'no': 1, 'code': 'A1-T01-1', 'level_no': 1},
        'status': 'learning',
        'items_total': 18,
        'items_drilled': 0,
        'open': {'expression': true, 'freetalk': false},
        'next_course': 'expression',
      }))));
      await tester.pump(const Duration(milliseconds: 32));
      tester.takeException();

      // 남는 것 — 4개
      expect(find.textContaining('차시 1 A1-T01-1'), findsOneWidget);
      expect(find.text('표현학습 통화'), findsOneWidget);
      expect(find.text('프리토킹 통화'), findsOneWidget);
      expect(find.text('자동 통화 (auto)'), findsOneWidget);
      // 빠지는 것 — 화면에 없어야 한다
      for (final gone in [
        '캐스케이드 통화 (테스트 서버)',
        '└ 아바타 영상',
        '└ 힌트 카드',
        '취소 배관 리그',
        '에코 측정 리그',
        '└ 자동 대화',
        '└ 마이크 끔',
        '컴포넌트 갤러리',
      ]) {
        expect(find.text(gone), findsNothing, reason: '$gone 은 화면에서 내렸다');
      }
      expect(find.textContaining('빌드 '), findsNothing,
          reason: '빌드 정보 줄도 「남길 것」 목록에 없어 같이 내렸다');
    });

    testWidgets('실패도 글자로 보인다 — 개발자 도구는 조용히 비우지 않는다', (tester) async {
      tester.view.physicalSize = const Size(375, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(AsyncError(StateError('401'), StackTrace.empty)));
      await tester.pump(const Duration(milliseconds: 32));
      tester.takeException();

      expect(find.textContaining('커리큘럼 조회 실패'), findsOneWidget);
    });
  });
}
