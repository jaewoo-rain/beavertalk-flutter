import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/assignment_item.dart';

/// 발음 과제의 문장별 채점 집계.
///
/// **서버가 문장마다 결과를 저장한다**(2026-09-04~ `submission_item_score`).
/// 그래서 이 값은 앱만의 기억이 아니다 — 과제에 들어올 때 [AssignmentAttemptNotifier.restore]
/// 로 서버 값을 받아 채우고, 채점할 때마다 [AssignmentAttemptNotifier.record] 로
/// 갱신한다. 중간에 나갔다 들어와도, 앱을 껐다 켜도 같은 값이 보인다.
///
/// ★ **합이 아니라 문장별 지도로 들고 있다.** 예전에는 합계만 누적해서 같은
///   문장을 두 번 읽으면 통과 수가 출제 수를 넘었고, 서버가 제출을 422 로
///   거절했다. 지도로 들면 다시 읽은 결과가 자연히 앞의 것을 대체한다.
class AssignmentAttempt {
  /// 한 과제의 진행 상황.
  const AssignmentAttempt({
    required this.assignmentId,
    this.total = 0,
    this.results = const <int, AssignmentItemResult>{},
  });

  /// 대상 과제.
  final int assignmentId;

  /// 출제 문장 수. **채점한 수가 아니다** — 「3 / 38」의 분모다.
  final int total;

  /// 문장 id → 마지막 채점 결과.
  final Map<int, AssignmentItemResult> results;

  /// 통과한 문장 수 — **서버 판정을 그대로 센다**.
  int get passed => results.values.where((r) => r.passed).length;

  /// 채점된 문장 수(평균의 분모).
  int get scored => results.length;

  /// 통과 못 한 항목 id. 교사 화면 「다시 가르칠 문장」의 유일한 재료다.
  List<int> get failedItemIds =>
      results.values.where((r) => !r.passed).map((r) => r.itemId).toList()
        ..sort();

  /// 평균 총점(0~100). 채점 이력이 없으면 null 이다 — 0 과 다르다.
  int? get averageScore => _average((r) => r.totalScore);

  /// 발음 평균. 채점 전이면 null.
  int? get averagePronunciation => _average((r) => r.pronunciation);

  /// 유창성 평균. 채점 전이면 null.
  int? get averageFluency => _average((r) => r.fluency);

  /// 리듬 평균. 채점 전이면 null.
  int? get averageRhythm => _average((r) => r.rhythm);

  int? _average(int Function(AssignmentItemResult) pick) {
    if (results.isEmpty) return null;
    final sum = results.values.fold<int>(0, (acc, r) => acc + pick(r));
    return (sum / results.length).round();
  }

  /// 한 문장의 결과를 반영한 사본. **같은 문장이면 덮어쓴다.**
  AssignmentAttempt withResult(AssignmentItemResult result) {
    return AssignmentAttempt(
      assignmentId: assignmentId,
      total: total,
      results: {...results, result.itemId: result},
    );
  }
}

/// 과제별 진행 상황. 키는 과제 id 다.
final assignmentAttemptProvider =
    NotifierProvider<AssignmentAttemptNotifier, Map<int, AssignmentAttempt>>(
      AssignmentAttemptNotifier.new,
    );

/// [AssignmentAttempt] 갱신기.
class AssignmentAttemptNotifier extends Notifier<Map<int, AssignmentAttempt>> {
  @override
  Map<int, AssignmentAttempt> build() => const <int, AssignmentAttempt>{};

  /// 빈 시도를 연다. 서버에 남은 결과가 없을 때 쓴다.
  void start({required int assignmentId, required int total}) {
    state = {
      ...state,
      assignmentId: AssignmentAttempt(assignmentId: assignmentId, total: total),
    };
  }

  /// 서버가 준 문장 묶음으로 진행 상황을 되살린다.
  ///
  /// ⛔ 이전 상태를 이어 붙이지 마라 — **서버가 정답이다.** 앱에만 있던 값이
  ///    남으면 서버가 모르는 점수를 화면이 계속 주장하게 된다.
  void restore({
    required int assignmentId,
    required List<AssignmentItem> items,
  }) {
    state = {
      ...state,
      assignmentId: AssignmentAttempt(
        assignmentId: assignmentId,
        total: items.length,
        results: <int, AssignmentItemResult>{
          for (final item in items)
            if (item.score != null) item.itemId: item.score!,
        },
      ),
    };
  }

  /// 문장 하나의 결과를 반영한다. 같은 문장을 다시 읽으면 덮어쓴다.
  void record({
    required int assignmentId,
    required int itemId,
    required bool passed,
    required int totalScore,
    int pronunciation = 0,
    int fluency = 0,
    int rhythm = 0,
  }) {
    final current = state[assignmentId];
    if (current == null) return;
    state = {
      ...state,
      assignmentId: current.withResult(
        AssignmentItemResult(
          itemId: itemId,
          passed: passed,
          totalScore: totalScore,
          pronunciation: pronunciation,
          fluency: fluency,
          rhythm: rhythm,
        ),
      ),
    };
  }

  /// 특정 과제의 진행 상황.
  AssignmentAttempt? of(int assignmentId) => state[assignmentId];
}
