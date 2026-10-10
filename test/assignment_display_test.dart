// 숙제 목록의 분류·정렬 규칙 — 스펙 §7 「리스트 정렬」을 고정한다.
//
// 이 규칙이 흔들리면 미제출이 완료 아래로 내려가는 식으로 조용히 망가진다.
// 화면이 아니라 여기서 잡는다.

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/presentation/assignment_display.dart';
import 'package:beavertalk/screens/classroom/widgets/assignment_badge.dart';

final DateTime _now = DateTime(2026, 9, 2, 10);

ClassroomAssignment _a({
  required int id,
  required int daysFromNow,
  bool overdue = false,
  AssignmentStatus status = AssignmentStatus.notStarted,
}) {
  return ClassroomAssignment(
    assignmentId: id,
    classroomName: 'TOPIK 1급 A반',
    grade: 1,
    chapter: id,
    activities: const [AssignmentActivity.speaking],
    itemIds: const [],
    dueAt: _now.add(Duration(days: daysFromNow)),
    overdue: overdue,
    status: status,
  );
}

void main() {
  _titleTests();

  group('daysUntilDue — 시각이 아니라 날짜로 센다', () {
    test('오늘 밤 마감은 0일이다', () {
      expect(daysUntilDue(DateTime(2026, 9, 2, 23), _now), 0);
    });

    test('내일 아침 마감은 1일이다 — 14시간 뒤라도 0 이 아니다', () {
      expect(daysUntilDue(DateTime(2026, 9, 3, 0, 30), _now), 1);
    });

    test('지난 마감은 음수다', () {
      expect(daysUntilDue(DateTime(2026, 8, 31, 23), _now), -2);
    });
  });

  group('bucketOf', () {
    test('완료는 상태가 이긴다 — 마감이 지나도 완료 칸이다', () {
      final a = _a(
        id: 1,
        daysFromNow: -5,
        overdue: true,
        status: AssignmentStatus.done,
      );
      expect(bucketOf(a, _now), AssignmentBucket.done);
    });

    test('마감이 지나도 사라지지 않고 진행 중에 남는다', () {
      final a = _a(id: 2, daysFromNow: -2, overdue: true);
      expect(bucketOf(a, _now), AssignmentBucket.inProgress);
    });

    test('D-3 이내는 진행 중이다', () {
      expect(
        bucketOf(_a(id: 3, daysFromNow: 3), _now),
        AssignmentBucket.inProgress,
      );
    });

    test('D-4 부터는 예정이다', () {
      expect(
        bucketOf(_a(id: 4, daysFromNow: 4), _now),
        AssignmentBucket.upcoming,
      );
    });
  });

  group('groupAssignments — 스펙 §7 정렬', () {
    test('미제출이 먼저, 그 안에서는 마감 최신순이다', () {
      final items = [
        _a(id: 10, daysFromNow: -5, overdue: true),
        _a(id: 11, daysFromNow: -1, overdue: true),
        _a(id: 12, daysFromNow: 2),
      ];
      final g = groupAssignments(items, _now)[AssignmentBucket.inProgress]!;

      // 미제출 둘이 임박보다 앞이고, 최근에 지난 것이 위다.
      expect(g.map((a) => a.assignmentId).toList(), [11, 10, 12]);
    });

    test('예정과 완료는 각자 칸으로 간다', () {
      final items = [
        _a(id: 20, daysFromNow: 9),
        _a(id: 21, daysFromNow: 5),
        _a(id: 22, daysFromNow: -3, status: AssignmentStatus.done),
      ];
      final g = groupAssignments(items, _now);

      expect(g[AssignmentBucket.inProgress], isEmpty);
      expect(
        g[AssignmentBucket.upcoming]!.map((a) => a.assignmentId).toList(),
        [21, 20],
      );
      expect(g[AssignmentBucket.done]!.single.assignmentId, 22);
    });
  });

  group('nextDueAssignment', () {
    test('완료를 빼고 가장 빨리 마감되는 것을 준다', () {
      final items = [
        _a(id: 30, daysFromNow: 1, status: AssignmentStatus.done),
        _a(id: 31, daysFromNow: 4),
        _a(id: 32, daysFromNow: 2),
      ];
      expect(nextDueAssignment(items, _now)!.assignmentId, 32);
    });

    test('전부 완료면 null 이다', () {
      final items = [_a(id: 40, daysFromNow: 1, status: AssignmentStatus.done)];
      expect(nextDueAssignment(items, _now), isNull);
    });
  });

  group('닫힌 과제', () {
    ClassroomAssignment closed({required int id, required int daysFromNow}) {
      final a = _a(id: id, daysFromNow: daysFromNow);
      return ClassroomAssignment(
        assignmentId: a.assignmentId,
        classroomName: a.classroomName,
        grade: a.grade,
        chapter: a.chapter,
        activities: a.activities,
        itemIds: a.itemIds,
        dueAt: a.dueAt,
        overdue: a.overdue,
        status: a.status,
        closedAt: _now,
      );
    }

    test('할 수 있는 일 뒤로 밀린다 — 위에 두면 목록이 거짓말을 한다', () {
      final g = groupAssignments([
        closed(id: 1, daysFromNow: 2),
        _a(id: 2, daysFromNow: -1, overdue: true),
        _a(id: 3, daysFromNow: 2),
      ], _now)[AssignmentBucket.inProgress]!;

      // 미제출 → 임박 → 마감됨 순.
      expect(g.map((a) => a.assignmentId).toList(), [2, 3, 1]);
    });

    test('끝낸 과제가 닫혀도 완료 칸에 남는다', () {
      final a = ClassroomAssignment(
        assignmentId: 9,
        classroomName: 'A',
        grade: 1,
        chapter: 1,
        activities: const [AssignmentActivity.speaking],
        itemIds: const [],
        dueAt: _now,
        overdue: false,
        status: AssignmentStatus.done,
        closedAt: _now,
      );
      final g = groupAssignments([a], _now);
      expect(g[AssignmentBucket.done]!.single.assignmentId, 9);
      expect(g[AssignmentBucket.inProgress], isEmpty);
    });
  });


  // ── 완료 판정 (2026-09-04) ──
  //
  // 🔴 맞힌 수로 재면 두 문장 틀린 학습자는 38문장을 다 읽고도 영원히
  //    「학습하기」를 본다. 실측에서 37/38 통과인데 미완료로 떴다.
  group('발음 완료 판정은 읽은 수로 한다', () {
    ClassroomAssignment withSpeaking({
      required int scored,
      required int passed,
      required int total,
    }) => ClassroomAssignment(
      assignmentId: 1,
      classroomName: 'A반',
      grade: 1,
      chapter: 1,
      activities: const [AssignmentActivity.speaking],
      itemIds: const [],
      dueAt: _now,
      overdue: false,
      status: AssignmentStatus.done,
      speakingScored: scored,
      speakingPassed: passed,
      speakingTotal: total,
    );

    test('다 읽었으면 틀린 문장이 있어도 완료다', () {
      final a = withSpeaking(scored: 38, passed: 36, total: 38);
      expect(activityDone(a, AssignmentActivity.speaking), isTrue);
    });

    test('덜 읽었으면 완료가 아니다', () {
      final a = withSpeaking(scored: 37, passed: 37, total: 38);
      expect(activityDone(a, AssignmentActivity.speaking), isFalse);
    });

    test('아무것도 안 읽었으면 완료가 아니다', () {
      final a = withSpeaking(scored: 0, passed: 0, total: 38);
      expect(activityDone(a, AssignmentActivity.speaking), isFalse);
    });
  });
}

// ── 과제 이름 — 커리큘럼은 챕터로, 직접 출제는 교사가 붙인 이름으로 ──
//
// 🔴 직접 출제 과제는 급수·챕터가 **null** 이라 `?? 0` 으로 떨어진다. 챕터로
//    제목을 만들면 세 화면(홈 카드·목록·상세)이 전부 「Chapter 00」을 그린다.
void _titleTests() {
  String chapterLabel(String n) => 'Chapter $n';

  ClassroomAssignment make({
    AssignmentSource source = AssignmentSource.curriculum,
    String? title,
    int chapter = 3,
  }) => ClassroomAssignment(
    assignmentId: 1,
    classroomName: 'TOPIK 1급 A반',
    source: source,
    title: title,
    grade: 1,
    chapter: chapter,
    activities: const [AssignmentActivity.speaking],
    itemIds: const [],
    dueAt: _now,
    overdue: false,
    status: AssignmentStatus.notStarted,
  );

  group('assignmentTitleOf', () {
    test('커리큘럼 과제는 챕터로 부른다', () {
      expect(assignmentTitleOf(make(), chapterLabel), 'Chapter 03');
    });

    test('직접 출제는 교사가 붙인 이름으로 부른다', () {
      final a = make(
        source: AssignmentSource.manual,
        title: '9월 2주차 · 시장에서 쓰는 말',
        chapter: 0,
      );
      expect(assignmentTitleOf(a, chapterLabel), '9월 2주차 · 시장에서 쓰는 말');
    });

    test('이름이 비면 챕터로 떨어진다 — 빈 제목을 그리지 않는다', () {
      final a = make(source: AssignmentSource.manual, title: '   ');
      expect(assignmentTitleOf(a, chapterLabel), 'Chapter 03');
    });
  });

  group('fromJson', () {
    Map<String, dynamic> base() => {
      'assignment_id': 1,
      'classroom_name': 'A반',
      'activities': ['speaking'],
      'due_at': '2026-09-06T14:00:00Z',
    };

    test('출처를 안 실어 주면 커리큘럼으로 읽는다 — 옛 응답도 그대로 돈다', () {
      final a = ClassroomAssignment.fromJson(base());
      expect(a.source, AssignmentSource.curriculum);
      expect(a.hasOwnTitle, isFalse);
    });

    test('직접 출제는 급수·챕터가 null 이어도 제목으로 불린다', () {
      final a = ClassroomAssignment.fromJson({
        ...base(),
        'source': 'manual',
        'title': '시장에서 쓰는 말',
        'grade': null,
        'chapter': null,
      });
      expect(a.hasOwnTitle, isTrue);
      expect(assignmentTitleOf(a, chapterLabel), '시장에서 쓰는 말');
    });

    test('모르는 출처는 커리큘럼으로 떨어진다 — 서버가 늘려도 앱이 안 죽는다', () {
      final a = ClassroomAssignment.fromJson({...base(), 'source': 'imported'});
      expect(a.source, AssignmentSource.curriculum);
    });
  });

  group('회화는 과제당 한 번', () {
    // ⭐ 2026-09-04 사장님 결정. 서버가 이미 잠근다(b2b `link_call` 이 두 번째 통화를
    //   안 묶고, `conversation-goals` 가 끝난 과제에 목표를 안 준다). 화면은 그 규칙을
    //   **보여 주기만** 한다 — 눌리는데 아무 일도 안 나는 것이 최악이다.
    ClassroomAssignment build({int? met}) => ClassroomAssignment(
      assignmentId: 1,
      classroomName: 'A반',
      grade: 1,
      chapter: 1,
      activities: const [AssignmentActivity.conversation],
      itemIds: const [],
      dueAt: DateTime.now().add(const Duration(days: 3)),
      overdue: false,
      status: met == null ? AssignmentStatus.notStarted : AssignmentStatus.done,
      conversationMet: met,
      conversationTotal: 10,
    );

    test('통화 전이면 아직 안 끝난 것이다', () {
      expect(
        build().isActivityDone(AssignmentActivity.conversation),
        isFalse,
      );
    });

    test('통화가 귀속되면 끝난 것이다 — 목표를 다 못 채워도', () {
      expect(build(met: 0).isActivityDone(AssignmentActivity.conversation), isTrue);
      expect(build(met: 3).isActivityDone(AssignmentActivity.conversation), isTrue);
    });
  });
}
