import '../domain/entities/classroom_assignment.dart';

/// 리스트에서 과제가 들어갈 칸.
enum AssignmentBucket {
  /// 진행 중 — 미제출(마감 지남)과 마감 임박(D-3 이내)을 함께 담는다.
  inProgress,

  /// 예정 — 아직 여유가 있다.
  upcoming,

  /// 완료.
  done,
}

/// 마감까지 남은 **달력 날짜** 수. 지났으면 음수다.
///
/// 시각이 아니라 날짜로 센다 — 오늘 밤 11시 마감은 「0일」이지 「0.4일」이 아니다.
int daysUntilDue(DateTime dueAt, DateTime now) {
  final due = DateTime(dueAt.year, dueAt.month, dueAt.day);
  final today = DateTime(now.year, now.month, now.day);
  return due.difference(today).inDays;
}

/// 마감 임박으로 볼 경계 — 스펙 §7 「D-3 이내」.
const int kUrgentDays = 3;

/// 과제가 어느 칸에 들어가는지.
///
/// **마감이 지나도 제출은 막지 않는다.** 서버가 지각 제출을 받으므로 지난 과제는
/// 사라지지 않고 「진행 중」에 남는다.
AssignmentBucket bucketOf(ClassroomAssignment a, DateTime now) {
  if (a.status == AssignmentStatus.done) return AssignmentBucket.done;
  if (a.overdue) return AssignmentBucket.inProgress;
  return daysUntilDue(a.dueAt, now) <= kUrgentDays
      ? AssignmentBucket.inProgress
      : AssignmentBucket.upcoming;
}

/// 스펙 §7 「리스트 정렬」대로 칸별로 나눠 정렬한다.
///
/// 1. 미제출 — 마감일 최신순
/// 2. 마감 임박 — 마감 빠른 순
/// 3. 예정 — 마감 빠른 순
/// 4. 완료 — 마감 최신순
///
/// 완료를 「완료 시각 최신순」으로 두지 못한다 — 서버 응답에 완료 시각이 없다.
/// 마감 최신순으로 대신한다.
Map<AssignmentBucket, List<ClassroomAssignment>> groupAssignments(
  List<ClassroomAssignment> items,
  DateTime now,
) {
  final overdue = <ClassroomAssignment>[];
  final urgent = <ClassroomAssignment>[];
  final upcoming = <ClassroomAssignment>[];
  final done = <ClassroomAssignment>[];

  for (final a in items) {
    switch (bucketOf(a, now)) {
      case AssignmentBucket.done:
        done.add(a);
      case AssignmentBucket.upcoming:
        upcoming.add(a);
      case AssignmentBucket.inProgress:
        (a.overdue ? overdue : urgent).add(a);
    }
  }

  overdue.sort((x, y) => y.dueAt.compareTo(x.dueAt));
  urgent.sort((x, y) => x.dueAt.compareTo(y.dueAt));
  upcoming.sort((x, y) => x.dueAt.compareTo(y.dueAt));
  done.sort((x, y) => y.dueAt.compareTo(x.dueAt));

  return {
    AssignmentBucket.inProgress: [...overdue, ...urgent],
    AssignmentBucket.upcoming: upcoming,
    AssignmentBucket.done: done,
  };
}

/// 가장 빨리 마감되는 미완료 과제. 없으면 null 이다.
ClassroomAssignment? nextDueAssignment(
  List<ClassroomAssignment> items,
  DateTime now,
) {
  final open = items.where((a) => a.status != AssignmentStatus.done).toList()
    ..sort((x, y) => x.dueAt.compareTo(y.dueAt));
  return open.isEmpty ? null : open.first;
}
