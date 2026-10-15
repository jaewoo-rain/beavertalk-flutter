// A7 숙제 상세 — 2026-10-12 확정안(머리 · 완료 테두리 · 회화 완료 분기 · 썸네일 · 워크북 정보 줄).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/components/molecules/card_task.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/assignment_detail.dart';
import 'package:beavertalk/screens/classroom/widgets/homework_thumbnails.dart';

ClassroomAssignment _a({
  int? conversationMet,
  DateTime? workbookOpenedAt,
  int? pages = 12,
  int? words = 40,
  AssignmentSource source = AssignmentSource.curriculum,
  String? title,
  bool overdue = false,
  DateTime? closedAt,
  AssignmentStatus status = AssignmentStatus.inProgress,
}) {
  return ClassroomAssignment(
    assignmentId: 7,
    classroomId: 3,
    classroomName: 'TOPIK 1 A',
    source: source,
    title: title,
    grade: 1,
    chapter: 3,
    activities: [
      AssignmentActivity.speaking,
      AssignmentActivity.conversation,
      if (source == AssignmentSource.curriculum) AssignmentActivity.workbook,
    ],
    itemIds: const [],
    dueAt: DateTime(2026, 10, 11, 20),
    overdue: overdue,
    closedAt: closedAt,
    status: status,
    conversationMet: conversationMet,
    conversationTotal: conversationMet == null ? null : 5,
    workbookUrl: source == AssignmentSource.curriculum
        ? 'https://example.invalid/wb.pdf'
        : null,
    workbookOpenedAt: workbookOpenedAt,
    workbookPageCount: pages,
    workbookWordCount: words,
  );
}

Future<void> _pump(WidgetTester tester, ClassroomAssignment a) async {
  tester.view.physicalSize = const Size(375 * 3, 2400 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      myClassroomsProvider.overrideWith(
        (ref) async => const [
          JoinedClassroom(classroomId: 3, name: 'TOPIK 1 A', teacherDisplayName: 'Lee'),
        ],
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AssignmentDetailScreen(assignment: a),
    ),
  ));
  await tester.pumpAndSettle();
}

CardTask _card(WidgetTester tester, String title) => tester.widget<CardTask>(
  find.byWidgetPredicate((w) => w is CardTask && w.title == title),
);

void main() {
  testWidgets('GNB 는 Homework 고정 · 머리에 마감일·제목·반, 선생님', (tester) async {
    await _pump(tester, _a());

    expect(find.text('Homework'), findsOneWidget);
    expect(find.text('2026-10-11'), findsOneWidget);
    expect(find.text('Chapter 03'), findsOneWidget);
    expect(find.text('TOPIK 1 A, Teacher Lee'), findsOneWidget);
  });

  testWidgets('회화 전 — 학습하기 · 테두리 없음 · 통화 썸네일', (tester) async {
    await _pump(tester, _a());

    final conv = _card(tester, 'Conversation');
    expect(conv.outlined, isFalse);
    expect(conv.ctaLabel, 'Start');
    expect(conv.ctaDisabled, isFalse);
    expect(find.byType(CallThumbnail), findsOneWidget);
  });

  testWidgets('회화 완료(서버 conversation_met) — 학습완료 비활성 · 문구 교체 · 테두리', (tester) async {
    await _pump(tester, _a(conversationMet: 1));

    final conv = _card(tester, 'Conversation');
    expect(conv.outlined, isTrue);
    expect(conv.ctaLabel, 'Completed');
    expect(conv.ctaDisabled, isTrue);
    expect(conv.description, 'You can only do the conversation once per assignment.');
    final btn = tester.widget<Button>(
      find.byWidgetPredicate((w) => w is Button && w.text == 'Completed'),
    );
    expect(btn.disabled, isTrue);
    // 썸네일은 완료여도 그대로다.
    expect(find.byType(CallThumbnail), findsOneWidget);
  });

  testWidgets('워크북 — 원고지 썸네일 · 정보 줄 · 연 뒤 테두리', (tester) async {
    await _pump(tester, _a(workbookOpenedAt: DateTime(2026, 10, 10)));

    expect(find.byType(WorkbookThumbnail), findsOneWidget);
    expect(find.text('Chapter 03 workbook (12 pages, 40 words)'), findsOneWidget);
    expect(_card(tester, 'Workbook').outlined, isTrue);
    expect(_card(tester, 'Pronunciation').outlined, isFalse);
  });

  testWidgets('워크북 쪽수·단어 수가 없으면 그 항목만 뺀다', (tester) async {
    await _pump(tester, _a(pages: null, words: null));
    expect(find.text('Chapter 03 workbook'), findsOneWidget);
  });

  testWidgets('직접 출제는 워크북 카드가 없고 교사 제목을 쓴다', (tester) async {
    await _pump(
      tester,
      _a(source: AssignmentSource.manual, title: '시장에서 자주 쓰이는 말'),
    );
    expect(find.byType(WorkbookThumbnail), findsNothing);
    expect(
      find.byWidgetPredicate(
        (w) => w is Text && (w.data ?? '').replaceAll('⁠', '') == '시장에서 자주 쓰이는 말',
      ),
      findsOneWidget,
    );
  });

  testWidgets('마감 지남(미완료) — 지각 제출 안내 · 버튼 그대로(§3-7)', (tester) async {
    await _pump(tester, _a(overdue: true));
    expect(
      find.text('The due date has passed, but you can still submit it now.'),
      findsOneWidget,
    );
    expect(_card(tester, 'Conversation').ctaDisabled, isFalse);
  });

  testWidgets('닫힘 — 닫힘 안내만 · 회화 비활성', (tester) async {
    await _pump(tester, _a(overdue: true, closedAt: DateTime(2026, 10, 12)));
    expect(find.textContaining('due date has passed'), findsNothing);
    expect(_card(tester, 'Conversation').ctaDisabled, isTrue);
  });

  testWidgets('완료 과제에는 마감 안내가 없다', (tester) async {
    await _pump(tester, _a(overdue: true, status: AssignmentStatus.done));
    expect(find.textContaining('due date has passed'), findsNothing);
  });
}
