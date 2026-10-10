// A6 숙제 목록 화면 — 칸 머리글이 상태에 따라 나타나고 사라지는지 본다.
//
// 「그룹이 비면 섹션 헤더째 숨긴다」(스펙 §7)가 이 화면의 유일한 조건부
// 레이아웃이라 회귀가 눈에 안 띈다.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/features/classroom/domain/repositories/classroom_repository.dart';
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

class _AssignmentsRepository implements ClassroomRepository {
  List<ClassroomAssignment> items = [];
  int requests = 0;
  Completer<List<ClassroomAssignment>>? pending;

  @override
  Future<List<ClassroomAssignment>> myAssignments() async {
    requests++;
    return pending?.future ?? items;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('앱 복귀는 홈이 보유한 빈 캐시도 다시 조회한다', (tester) async {
    dotenv.testLoad(fileInput: 'B2B_API_BASE_URL=https://b2b.invalid');
    addTearDown(dotenv.clean);
    final repository = _AssignmentsRepository();
    final container = ProviderContainer(
      overrides: [classroomRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(myAssignmentsProvider, (_, _) {});
    addTearDown(subscription.close);
    expect(await container.read(myAssignmentsProvider.future), isEmpty);
    repository.items = [_a(id: 10, daysFromNow: 1)];
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    final items = await container.read(myAssignmentsProvider.future);
    expect(items.single.assignmentId, 10);
    expect(repository.requests, 2);
    repository.pending = Completer<List<ClassroomAssignment>>();
    final refresh = container.refresh(myAssignmentsProvider.future);
    expect(repository.requests, 3);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 1));
    expect(repository.requests, 3);
    repository.pending!.complete(repository.items);
    await refresh;
    subscription.close();
    container.dispose();
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('빈 캐시를 가진 목록에 다시 들어가면 새 숙제가 나타난다', (tester) async {
    var items = <ClassroomAssignment>[];
    final container = ProviderContainer(
      overrides: [myAssignmentsProvider.overrideWith((ref) async => items)],
    );
    addTearDown(container.dispose);
    await container.read(myAssignmentsProvider.future);
    items = [_a(id: 9, daysFromNow: 1)];
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssignmentListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Chapter 09'), findsOneWidget);
    expect(find.text('No homework yet'), findsNothing);
  });

  testWidgets('빈 목록을 당겨 갱신하면 나중에 발행된 숙제가 나타난다', (tester) async {
    var items = <ClassroomAssignment>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [myAssignmentsProvider.overrideWith((ref) async => items)],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssignmentListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No homework yet'), findsOneWidget);
    items = [_a(id: 10, daysFromNow: 1)];
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 10'), findsOneWidget);
  });

  testWidgets('빈 목록은 안내만 그리고 칸 머리글을 만들지 않는다', (tester) async {
    await tester.pumpWidget(_host(const []));
    await tester.pumpAndSettle();

    expect(find.text('No homework yet'), findsOneWidget);
    expect(_sectionHeader('In progress'), findsNothing);
    expect(_sectionHeader('Done'), findsNothing);
  });

  testWidgets('짧은 목록도 당겨 갱신하면 새 숙제가 나타난다', (tester) async {
    var items = [_a(id: 9, daysFromNow: 1)];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [myAssignmentsProvider.overrideWith((ref) async => items)],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssignmentListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    items = [...items, _a(id: 10, daysFromNow: 1)];
    await tester.drag(find.byType(ListView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 10'), findsOneWidget);
  });

  testWidgets('지연된 새로고침은 중복 요청 없이 대기하고 실패 후 재시도한다', (tester) async {
    var requests = 0;
    final delayed = Completer<List<ClassroomAssignment>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myAssignmentsProvider.overrideWith((ref) {
            requests++;
            if (requests == 2) return delayed.future;
            return Future.value([_a(id: 9, daysFromNow: 1)]);
          }),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssignmentListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(requests, 1);
    final refresh = tester.widget<RefreshIndicator>(
      find.byType(RefreshIndicator),
    );
    final indicator = tester.state<RefreshIndicatorState>(
      find.byType(RefreshIndicator),
    );
    final first = indicator.show();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final duplicate = refresh.onRefresh();
    await tester.pump();
    expect(requests, 2);
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    delayed.completeError(StateError('offline'));
    await Future.wait([first, duplicate]);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // The error UI's existing button must retry the repository request.
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(requests, 3);
    expect(find.text('Chapter 09'), findsOneWidget);
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
