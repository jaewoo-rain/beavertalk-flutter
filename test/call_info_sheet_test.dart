// 통화 i 안내 시트(BottomSheetCallInfo) — 04_통화 정본(PM-DEC-760·780·785·793·796).
//
// 시트 단독으로 본다: 번역 줄 규칙 · TTS 실패 시 그 행만 비활성 · 320 폭 넘침 0 · 유형 판정.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/organisms/bottom_sheet_call_info.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/entities/homework_roleplay.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/call.dart';

Future<void> _pump(WidgetTester tester, Widget sheet, {double width = 375, Locale locale = const Locale('en')}) async {
  tester.view.physicalSize = Size(width, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Align(alignment: Alignment.bottomCenter, child: sheet)),
  ));
  await tester.pump();
}

const _long = '혹시 이 근처에 편의점이 어디에 있는지 아세요? 길을 잃어버려서 정말 곤란한데 도와주실 수 있을까요?';

final _expressions = [
  const CallInfoExpression(id: 1, surface: '먹음직스럽다', meaning: 'to look delicious'),
  const CallInfoExpression(id: 2, surface: _long, meaning: 'Do you happen to know where there is a convenience store near here? I am lost.'),
  const CallInfoExpression(id: 3, surface: '가게'),
];

List<CurLessonRow> _lessons() => [
      for (var no = 4; no <= 30; no++)
        CurLessonRow(no: no, code: 'A1-$no', levelNo: 2, situation: '상황 $no $_long', situationTranslation: 'Situation $no'),
    ];

void main() {
  group('번역 줄', () {
    testWidgets('번역이 있으면 그리고, null 이면(ko 회원) 그리지 않는다', (tester) async {
      await _pump(tester, const BottomSheetCallInfo(
        type: CallInfoType.conversation,
        title: '물건 사기와 값',
        titleTranslation: 'Shopping and prices',
        situation: '가게에서 물건값을 묻고 사기',
        situationTranslation: 'Asking prices at a store',
        partner: '동네 슈퍼마켓 주인',
        me: '물건값을 묻는 손님',
      ));
      expect(find.text('Shopping and prices'), findsOneWidget);
      expect(find.text('Asking prices at a store'), findsOneWidget);
      expect(find.text('동네 슈퍼마켓 주인'), findsOneWidget);
      expect(find.text('물건값을 묻는 손님'), findsOneWidget);

      await _pump(tester, const BottomSheetCallInfo(
        type: CallInfoType.conversation,
        title: '물건 사기와 값',
        situation: '가게에서 물건값을 묻고 사기',
        partner: '동네 슈퍼마켓 주인',
      ), locale: const Locale('ko'));
      expect(find.text('Shopping and prices'), findsNothing);
      expect(find.text('물건값을 묻는 손님'), findsNothing, reason: 'learner_role 없음 → 나 행 숨김');
    });

    testWidgets('주제 번역이 원문과 같으면(서버가 원문을 준 경우) 번역 줄을 숨긴다', (tester) async {
      await _pump(tester, const BottomSheetCallInfo(
        type: CallInfoType.expression, title: '인사', titleTranslation: '인사', expressions: []));
      expect(find.text('인사'), findsOneWidget);
    });

    testWidgets('숙제 — 탭 없음 · 제목만 · 표현 행', (tester) async {
      await _pump(tester, BottomSheetCallInfo(type: CallInfoType.homework, title: 'Chapter 03', expressions: _expressions));
      final l10n = AppLocalizations.of(tester.element(find.byType(BottomSheetCallInfo)));
      expect(find.text(l10n.callHintTabLessons), findsNothing);
      expect(find.text('Chapter 03'), findsOneWidget);
      expect(find.text('to look delicious'), findsOneWidget);
      expect(find.text('가게'), findsOneWidget);
    });
  });

  group('TTS', () {
    testWidgets('누르면 그 표현을 부르고, 실패하면 그 행 버튼만 비활성(숨기지 않음)', (tester) async {
      final played = <int>[];
      await _pump(tester, BottomSheetCallInfo(
        type: CallInfoType.expression,
        title: 't',
        expressions: _expressions,
        onPlay: (e) async {
          played.add(e.id);
          if (e.id == 1) throw StateError('tts 실패');
        },
      ));
      final l10n = AppLocalizations.of(tester.element(find.byType(BottomSheetCallInfo)));
      Finder tts(String s) => find.bySemanticsLabel('${l10n.listenStandard} $s');
      await tester.tap(tts('먹음직스럽다'));
      await tester.pump();
      expect(played, [1]);
      final s1 = tester.getSemantics(tts('먹음직스럽다'));
      expect('${s1.flagsCollection.isEnabled}', endsWith('isFalse'), reason: '실패한 행은 비활성');
      await tester.tap(tts('가게'));
      await tester.pump();
      expect(played, [1, 3], reason: '다른 행은 그대로 동작');
      expect(tts('먹음직스럽다'), findsOneWidget, reason: '버튼은 남는다');
    });
  });

  group('320 폭 넘침 0', () {
    for (final type in CallInfoType.values) {
      testWidgets('$type', (tester) async {
        await _pump(tester, BottomSheetCallInfo(
          type: type,
          title: _long,
          titleTranslation: 'A very long translated title that keeps going and going past the edge',
          expressions: _expressions,
          situation: _long,
          situationTranslation: _long,
          partner: _long,
          partnerTranslation: _long,
          me: _long,
          meTranslation: _long,
          levelNo: 2,
          currentNo: 9,
          lessons: _lessons(),
        ), width: 320, locale: const Locale('de'));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('차시 목록 탭 · 320', (tester) async {
      await _pump(tester, BottomSheetCallInfo(
        type: CallInfoType.expression, title: 't', expressions: const [],
        levelNo: 2, currentNo: 9, lessons: _lessons(), initialTab: 1,
      ), width: 320, locale: const Locale('de'));
      expect(tester.takeException(), isNull);
      expect(find.text('A1'), findsOneWidget);
    });
  });

  test('유형 판정 — 명세 4절 · 일반·레벨테스트는 없음', () {
    final rp = HomeworkRoleplay.fromJson(const {'situation': 's', 'ai_role': 'a'});
    expect(callInfoTypeFor(course: CallCourse.expression, homeworkRoleplay: null, homeworkExpression: false, assignmentId: null),
        CallInfoType.expression);
    expect(callInfoTypeFor(course: CallCourse.freetalk, homeworkRoleplay: null, homeworkExpression: false, assignmentId: null),
        CallInfoType.conversation);
    expect(callInfoTypeFor(course: CallCourse.chat, homeworkRoleplay: null, homeworkExpression: false, assignmentId: null),
        CallInfoType.free);
    expect(callInfoTypeFor(course: null, homeworkRoleplay: null, homeworkExpression: true, assignmentId: 3),
        CallInfoType.homework);
    expect(callInfoTypeFor(course: null, homeworkRoleplay: rp, homeworkExpression: false, assignmentId: 3),
        CallInfoType.roleplay);
    expect(callInfoTypeFor(course: null, homeworkRoleplay: null, homeworkExpression: false, assignmentId: null), isNull);
    expect(callInfoTypeFor(course: null, homeworkRoleplay: null, homeworkExpression: false, assignmentId: 3), isNull,
        reason: '역할극 숙제는 homework_roleplay 를 받기 전엔 모른다');
  });
}
