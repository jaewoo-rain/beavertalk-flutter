// A6 숙제 목록 화면 — 2026-10-12 확정안(탭 · 반 정보 머리 · 새 카드 · GNB 나가기).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
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

/// 탭 라벨만 고른다.
///
/// 「완료」는 탭과 완료 배지가 **같은 낱말**이라 `find.text` 가 둘을 잡는다
/// (영문 `Done`, 한국어 `완료` 모두). 탭은 Label 1(14) 이고 배지는 Caption 2(11)
/// 이라 크기로 가른다 — 시안 `6677:18163` 실측값이다.
Finder _tab(String label) {
  return find.byWidgetPredicate(
    (w) => w is Text && w.data == label && (w.style?.fontSize ?? 0) == 14,
  );
}

/// GNB 나가기 아이콘.
final Finder _leaveIcon = find.byKey(const ValueKey('hw-leave-class'));

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

class _LeaveRepository implements ClassroomRepository {
  final left = <int>[];

  @override
  Future<void> leave(int classroomId) async => left.add(classroomId);

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
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 10'), findsOneWidget);
  });

  testWidgets('과제 0개 — 탭은 남기고 남은 자리에 안내 제목·본문(§2-6)', (tester) async {
    await tester.pumpWidget(_host(const []));
    await tester.pumpAndSettle();

    expect(_tab('To do'), findsOneWidget);
    expect(find.text('No homework yet'), findsOneWidget);
    // 완료 탭으로 가도 같은 안내다.
    await tester.tap(_tab('Done'));
    await tester.pumpAndSettle();
    expect(find.text('No homework yet'), findsOneWidget);
  });

  testWidgets('미완료 0개 · 완료 있음 — 첫 탭은 미완료이고 모두 마쳤다는 안내', (tester) async {
    await tester.pumpWidget(
      _host([_a(id: 1, daysFromNow: -2, status: AssignmentStatus.done)]),
    );
    await tester.pumpAndSettle();

    expect(find.text('You finished all your homework'), findsOneWidget);
    expect(find.text('Chapter 01'), findsNothing);
  });

  testWidgets('완료 0개 — 완료 탭 안내', (tester) async {
    await tester.pumpWidget(_host([_a(id: 1, daysFromNow: 3)]));
    await tester.pumpAndSettle();
    await tester.tap(_tab('Done'));
    await tester.pumpAndSettle();

    expect(find.text('No finished homework yet'), findsOneWidget);
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
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
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

  testWidgets('완료만 있으면 미완료 탭은 비고 완료 탭에 나온다', (tester) async {
    await tester.pumpWidget(
      _host([_a(id: 1, daysFromNow: -2, status: AssignmentStatus.done)]),
    );
    await tester.pumpAndSettle();

    expect(_tab('To do'), findsOneWidget);
    expect(find.text('Chapter 01'), findsNothing);
    await tester.tap(_tab('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 01'), findsOneWidget);
  });

  testWidgets('미완료 탭 = 진행 중 + 예정 · 완료 탭 = done', (tester) async {
    await tester.pumpWidget(
      _host([
        _a(id: 1, daysFromNow: -2, overdue: true),
        _a(id: 2, daysFromNow: 9),
        _a(id: 3, daysFromNow: -5, status: AssignmentStatus.done),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chapter 01'), findsOneWidget);
    expect(find.text('Chapter 02'), findsOneWidget);
    expect(find.text('Chapter 03'), findsNothing);
    // 진행 중(미제출)이 예정보다 위다.
    expect(
      tester.getTopLeft(find.text('Chapter 01')).dy,
      lessThan(tester.getTopLeft(find.text('Chapter 02')).dy),
    );

    await tester.tap(_tab('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 01'), findsNothing);
    expect(find.text('Chapter 03'), findsOneWidget);
  });

  testWidgets('카드에 마감일이 yyyy-MM-dd 로 나오고 n/N 은 없다', (tester) async {
    final a = _a(id: 4, daysFromNow: 5);
    await tester.pumpWidget(_host([a]));
    await tester.pumpAndSettle();

    final d = a.dueAt;
    final ymd =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    expect(find.text(ymd), findsOneWidget);
    expect(find.text('0/2'), findsNothing);
    expect(find.text('TOPIK 1 A'), findsNothing); // 반 이름은 카드에서 뺐다
  });

  testWidgets('활동 아이콘은 스크린리더 라벨을 단다', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host([_a(id: 4, daysFromNow: 5)]));
    await tester.pumpAndSettle();

    // 카드 전체가 버튼이라 라벨이 합쳐진다 — 한 조각으로 들어 있는지만 본다.
    expect(find.bySemanticsLabel(RegExp('Pronunciation not done')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('반 정보 머리 — 기관·반·선생님·학기, 빈 값은 줄째 숨긴다', (tester) async {
    Future<void> pump(JoinedClassroom room) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          myAssignmentsProvider.overrideWith(
            (ref) async => [_a(id: 1, daysFromNow: 2)],
          ),
          myClassroomsProvider.overrideWith((ref) async => [room]),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssignmentListScreen(),
        ),
      ));
      await tester.pumpAndSettle();
    }

    await pump(const JoinedClassroom(
      classroomId: 3,
      name: 'TOPIK 1 A반',
      institution: '전북대학교 한국어교육원',
      teacherDisplayName: '이수진',
      term: '2026 가을학기',
    ));
    expect(find.text('전북대학교 한국어교육원'), findsOneWidget);
    expect(find.text('TOPIK 1 A반'), findsOneWidget);
    expect(find.text('Teacher 이수진'), findsOneWidget);
    expect(find.text('2026 가을학기'), findsOneWidget);
  });

  testWidgets('반 정보 머리 — 기관·선생님·학기가 비면 빈 줄을 남기지 않는다', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        myAssignmentsProvider.overrideWith(
          (ref) async => [_a(id: 1, daysFromNow: 2)],
        ),
        myClassroomsProvider.overrideWith(
          (ref) async => const [JoinedClassroom(classroomId: 3, name: 'QA B')],
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AssignmentListScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('QA B'), findsOneWidget);
    expect(find.textContaining('Teacher'), findsNothing);
  });

  testWidgets('나가기 아이콘은 목록이 있을 때 항상 있다', (tester) async {
    await tester.pumpWidget(_host([_a(id: 1, daysFromNow: 2)]));
    await tester.pumpAndSettle();

    expect(_leaveIcon, findsOneWidget);
    expect(find.text('Leave the class'), findsNothing); // 글자 링크는 걷었다
  });

  testWidgets('과제가 0개인 반도 나가기 아이콘이 있다(2026-10-12 PM-DEC-523)', (tester) async {
    await tester.pumpWidget(_host(const []));
    await tester.pumpAndSettle();

    expect(find.text('No homework yet'), findsOneWidget);
    expect(_leaveIcon, findsOneWidget);
  });

  testWidgets('기기 저장값이 없어도 내 반 목록의 id 로 나간다(재설치·다른 기기 참여)', (tester) async {
    SharedPreferences.setMockInitialValues({}); // 기기에 적어 둔 반 id 없음
    final repo = _LeaveRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        myAssignmentsProvider.overrideWith((ref) async => const []),
        myClassroomsProvider.overrideWith(
          (ref) async => const [JoinedClassroom(classroomId: 3, name: 'QA B')],
        ),
        classroomRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AssignmentListScreen(),
        routes: {'/mypage': (_) => const Text('MYPAGE')},
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(_leaveIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();

    expect(repo.left, [3]);
  });

  testWidgets('미제출 배지는 지난 날수를 붙이지 않는다(2026-10-12 확정)', (tester) async {
    await tester.pumpWidget(_host([_a(id: 1, daysFromNow: -3, overdue: true)]));
    await tester.pumpAndSettle();

    expect(find.text('Not submitted'), findsOneWidget);
  });

  testWidgets('반 여러 개 — 셰브런·시트로 반을 바꾸면 머리·목록·나가기가 그 반 기준(§2-7)', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = _LeaveRepository();
    ClassroomAssignment inRoom(int id, int room) => ClassroomAssignment(
      assignmentId: id,
      classroomId: room,
      classroomName: 'R$room',
      grade: 1,
      chapter: id,
      activities: const [AssignmentActivity.speaking],
      itemIds: const [],
      dueAt: DateTime.now().add(const Duration(days: 2)),
      overdue: false,
      status: AssignmentStatus.notStarted,
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        myAssignmentsProvider.overrideWith(
          (ref) async => [inRoom(1, 3), inRoom(2, 4)],
        ),
        myClassroomsProvider.overrideWith(
          (ref) async => const [
            JoinedClassroom(classroomId: 3, name: 'Class A', institution: 'Uni'),
            JoinedClassroom(classroomId: 4, name: 'Class B', institution: 'Center'),
          ],
        ),
        classroomRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AssignmentListScreen(),
        routes: {'/mypage': (_) => const Text('MYPAGE')},
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Class A'), findsOneWidget);
    expect(find.text('Chapter 01'), findsOneWidget);
    expect(find.text('Chapter 02'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('hw-class-picker')));
    await tester.pumpAndSettle();
    expect(find.text('Choose a class'), findsOneWidget);
    await tester.tap(find.text('Class B'));
    await tester.pumpAndSettle();

    expect(find.text('Class B'), findsOneWidget);
    expect(find.text('Chapter 02'), findsOneWidget);
    expect(find.text('Chapter 01'), findsNothing);

    await tester.tap(_leaveIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    expect(repo.left, [4]);
  });

  testWidgets('반이 하나면 셰브런이 없다', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        myAssignmentsProvider.overrideWith((ref) async => [_a(id: 1, daysFromNow: 2)]),
        myClassroomsProvider.overrideWith(
          (ref) async => const [JoinedClassroom(classroomId: 3, name: 'Only')],
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AssignmentListScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('hw-class-picker')), findsNothing);
  });

  testWidgets('완료 카드 — 완료 배지(체크 없음) · 흐림 없음', (tester) async {
    await tester.pumpWidget(
      _host([_a(id: 5, daysFromNow: -1, status: AssignmentStatus.done)]),
    );
    await tester.pumpAndSettle();
    await tester.tap(_tab('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Chapter 05'), findsOneWidget);
    expect(find.byType(Opacity), findsNothing);
  });

  testWidgets('교사 이름이 이미 선생님으로 끝나면 호칭을 덧붙이지 않는다', (tester) async {
    Future<void> pump(Locale locale) async {
      await tester.pumpWidget(ProviderScope(
        key: UniqueKey(),
        overrides: [
          myAssignmentsProvider.overrideWith((ref) async => [_a(id: 1, daysFromNow: 2)]),
          myClassroomsProvider.overrideWith(
            (ref) async => const [
              JoinedClassroom(classroomId: 3, name: 'A', teacherDisplayName: '김 선생님 '),
            ],
          ),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AssignmentListScreen(),
        ),
      ));
      await tester.pumpAndSettle();
    }

    await pump(const Locale('ko'));
    expect(find.text('김 선생님'), findsOneWidget);
    expect(find.textContaining('선생님 선생님'), findsNothing);
    await pump(const Locale('en'));
    expect(find.text('김 선생님'), findsOneWidget);
    expect(find.textContaining('Teacher'), findsNothing);
  });
}
