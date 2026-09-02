// 숙제 목록의 분류·정렬 규칙 — 스펙 §7 「리스트 정렬」을 고정한다.
//
// 이 규칙이 흔들리면 미제출이 완료 아래로 내려가는 식으로 조용히 망가진다.
// 화면이 아니라 여기서 잡는다.

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/presentation/assignment_display.dart';

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
}
