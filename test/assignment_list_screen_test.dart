// A6 숙제 목록 화면 — 칸 머리글이 상태에 따라 나타나고 사라지는지 본다.
//
// 「그룹이 비면 섹션 헤더째 숨긴다」(스펙 §7)가 이 화면의 유일한 조건부
// 레이아웃이라 회귀가 눈에 안 띈다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/classroom/assignment_list.dart';

ClassroomAssignment _a({
  required int id,
  required int daysFromNow,
  bool overdue = false,
  AssignmentStatus status = AssignmentStatus.notStarted,
}) {
  return ClassroomAssignment(
    assignmentId: id,
    classroomName: 'TOPIK 1 A',
    grade: 1,
    chapter: id,
    activities: const [
      AssignmentActivity.speaking,
      AssignmentActivity.conversation,
    ],
    itemIds: const [],
    dueAt: DateTime.now().add(Duration(days: daysFromNow)),
    overdue: overdue,
    status: status,
  );
}

Widget _host(List<ClassroomAssignment> items) {
  return ProviderScope(
    overrides: [myAssignmentsProvider.overrideWith((ref) async => items)],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AssignmentListScreen(),
    ),
  );
}

/// 칸 머리글만 고른다.
///
/// 「완료」는 머리글과 완료 배지가 **같은 낱말**이라 `find.text` 가 둘을 잡는다
/// (영문 `Done`, 한국어 `완료` 모두). 머리글은 Body 1 Bold(16) 이고 배지는
/// Caption 2(11) 이라 크기로 가른다 — 시안 실측값이다.
Finder _sectionHeader(String label) {
  return find.byWidgetPredicate(
    (w) => w is Text && w.data == label && (w.style?.fontSize ?? 0) >= 16,
  );
}

void main() {
  testWidgets('빈 목록은 안내만 그리고 칸 머리글을 만들지 않는다', (tester) async {
    await tester.pumpWidget(_host(const []));
    await tester.pumpAndSettle();

    expect(find.text('No homework yet'), findsOneWidget);
    expect(_sectionHeader('In progress'), findsNothing);
    expect(_sectionHeader('Done'), findsNothing);
  });

  testWidgets('완료만 있으면 완료 머리글만 나온다', (tester) async {
    await tester.pumpWidget(
      _host([_a(id: 1, daysFromNow: -2, status: AssignmentStatus.done)]),
    );
    await tester.pumpAndSettle();

    expect(_sectionHeader('Done'), findsOneWidget);
    expect(_sectionHeader('In progress'), findsNothing);
    expect(_sectionHeader('Upcoming'), findsNothing);
  });

  testWidgets('세 상태가 섞이면 머리글 셋이 모두 나온다', (tester) async {
    await tester.pumpWidget(
      _host([
        _a(id: 1, daysFromNow: -2, overdue: true),
        _a(id: 2, daysFromNow: 9),
        _a(id: 3, daysFromNow: -5, status: AssignmentStatus.done),
      ]),
    );
    await tester.pumpAndSettle();

    expect(_sectionHeader('In progress'), findsOneWidget);
    expect(_sectionHeader('Upcoming'), findsOneWidget);
    expect(_sectionHeader('Done'), findsOneWidget);
  });

  testWidgets('나가기 링크는 목록이 있을 때 항상 있다', (tester) async {
    await tester.pumpWidget(_host([_a(id: 1, daysFromNow: 2)]));
    await tester.pumpAndSettle();

    expect(find.text('Leave the class'), findsOneWidget);
  });

  testWidgets('미제출 배지는 지난 날수를 말한다', (tester) async {
    await tester.pumpWidget(_host([_a(id: 1, daysFromNow: -3, overdue: true)]));
    await tester.pumpAndSettle();

    expect(find.textContaining('Not submitted'), findsOneWidget);
  });
}
