import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 이번 세션에 푼 발음 과제의 집계.
///
/// **서버는 과제 점수를 보관하지 않는다.** `POST .../speaking` 이 받는 것은 점수가
/// 아니라 「알아들은 문장 수」다. 그래서 상세 화면이 결과 게이지를 그리려면 방금
/// 푼 결과를 앱이 들고 있어야 한다.
///
/// 앱을 껐다 켜면 사라진다. 그게 맞다 — 남아 있으면 서버가 모르는 점수를 화면이
/// 계속 주장하게 된다.
class AssignmentAttempt {
  /// 한 과제의 시도 결과.
  const AssignmentAttempt({
    required this.assignmentId,
    this.total = 0,
    this.passed = 0,
    this.scoreSum = 0,
    this.scored = 0,
    this.failedItemIds = const <int>[],
  });

  /// 대상 과제.
  final int assignmentId;

  /// 출제 문장 수.
  final int total;

  /// 통과한 문장 수 — **서버 판정을 그대로 센다**.
  final int passed;

  /// 채점된 총점의 합. 평균을 내기 위한 것이다.
  final int scoreSum;

  /// 채점된 문장 수(합의 분모).
  final int scored;

  /// 통과 못 한 항목 id. 교사 화면 「다시 가르칠 문장」의 유일한 재료다.
  final List<int> failedItemIds;

  /// 평균 총점(0~100). 채점 이력이 없으면 null 이다 — 0 과 다르다.
  int? get averageScore => scored == 0 ? null : (scoreSum / scored).round();

  /// 한 문장의 채점 결과를 더한 사본.
  AssignmentAttempt add({
    required int itemId,
    required bool itemPassed,
    required int totalScore,
  }) {
    return AssignmentAttempt(
      assignmentId: assignmentId,
      total: total,
      passed: passed + (itemPassed ? 1 : 0),
      scoreSum: scoreSum + totalScore,
      scored: scored + 1,
      failedItemIds: itemPassed
          ? failedItemIds
          : <int>[...failedItemIds, itemId],
    );
  }
}

/// 과제별 마지막 시도. 키는 과제 id 다.
final assignmentAttemptProvider =
    NotifierProvider<AssignmentAttemptNotifier, Map<int, AssignmentAttempt>>(
      AssignmentAttemptNotifier.new,
    );

/// [AssignmentAttempt] 갱신기.
class AssignmentAttemptNotifier extends Notifier<Map<int, AssignmentAttempt>> {
  @override
  Map<int, AssignmentAttempt> build() => const <int, AssignmentAttempt>{};

  /// 새 시도를 시작한다. **이전 집계를 반드시 지운다** — 이어 세면 두 번 푼
  /// 학습자의 통과 수가 출제 수를 넘는다.
  void start({required int assignmentId, required int total}) {
    state = {
      ...state,
      assignmentId: AssignmentAttempt(assignmentId: assignmentId, total: total),
    };
  }

  /// 문장 하나의 결과를 더한다.
  void record({
    required int assignmentId,
    required int itemId,
    required bool passed,
    required int totalScore,
  }) {
    final current = state[assignmentId];
    if (current == null) return;
    state = {
      ...state,
      assignmentId: current.add(
        itemId: itemId,
        itemPassed: passed,
        totalScore: totalScore,
      ),
    };
  }

  /// 특정 과제의 시도.
  AssignmentAttempt? of(int assignmentId) => state[assignmentId];
}
