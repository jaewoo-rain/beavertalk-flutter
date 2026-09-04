// 발음 과제 집계 — 교사 화면의 「n / m 문장」이 여기서 나온다.
//
// 지키는 것 셋.
// 1) 통과 판정은 서버 값을 그대로 센다(앱이 점수로 다시 재지 않는다).
// 2) 미통과 항목 id 를 빠짐없이 모은다 — 교사 화면 「다시 가르칠 문장」의 유일한 재료다.
// 3) 채점 이력이 없으면 평균은 null 이다. 0 과 다르다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/classroom/domain/entities/assignment_item.dart';
import 'package:beavertalk/features/classroom/presentation/assignment_attempt_provider.dart';

void main() {
  late ProviderContainer container;
  AssignmentAttemptNotifier notifier() =>
      container.read(assignmentAttemptProvider.notifier);

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('시작 전에는 시도가 없다', () {
    expect(notifier().of(1), isNull);
  });

  test('채점 전 평균은 null 이다 — 0 점이 아니다', () {
    notifier().start(assignmentId: 1, total: 3);
    final a = notifier().of(1)!;
    expect(a.total, 3);
    expect(a.scored, 0);
    expect(a.averageScore, isNull);
  });

  test('서버 판정을 그대로 세고 미통과 id 를 모은다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 3);
    n.record(assignmentId: 1, itemId: 11, passed: true, totalScore: 90);
    n.record(assignmentId: 1, itemId: 12, passed: false, totalScore: 40);
    n.record(assignmentId: 1, itemId: 13, passed: true, totalScore: 80);

    final a = n.of(1)!;
    expect(a.passed, 2);
    expect(a.total, 3);
    expect(a.failedItemIds, [12]);
    expect(a.averageScore, 70); // (90+40+80)/3
  });

  test('높은 점수라도 서버가 통과로 안 보면 통과가 아니다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 1);
    // 경계는 서버 한 곳에서만 정한다. 앱이 점수로 다시 재면 두 곳이 된다.
    n.record(assignmentId: 1, itemId: 11, passed: false, totalScore: 99);

    final a = n.of(1)!;
    expect(a.passed, 0);
    expect(a.failedItemIds, [11]);
  });

  test('다시 시작하면 이전 집계를 지운다 — 통과 수가 출제 수를 넘으면 안 된다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 2);
    n.record(assignmentId: 1, itemId: 11, passed: true, totalScore: 90);
    n.record(assignmentId: 1, itemId: 12, passed: true, totalScore: 90);
    expect(n.of(1)!.passed, 2);

    n.start(assignmentId: 1, total: 2);
    expect(n.of(1)!.passed, 0);
    expect(n.of(1)!.failedItemIds, isEmpty);
  });

  test('과제끼리 섞이지 않는다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 1);
    n.start(assignmentId: 2, total: 1);
    n.record(assignmentId: 1, itemId: 11, passed: true, totalScore: 90);

    expect(n.of(1)!.passed, 1);
    expect(n.of(2)!.passed, 0);
  });

  test('시작하지 않은 과제의 기록은 무시한다', () {
    final n = notifier();
    n.record(assignmentId: 9, itemId: 1, passed: true, totalScore: 90);
    expect(n.of(9), isNull);
  });

  test('세부 지표도 평균을 낸다 — 상세 카드의 세 칸이 이 값이다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 2);
    n.record(
      assignmentId: 1,
      itemId: 11,
      passed: true,
      totalScore: 90,
      pronunciation: 88,
      fluency: 92,
      rhythm: 90,
    );
    n.record(
      assignmentId: 1,
      itemId: 12,
      passed: true,
      totalScore: 70,
      pronunciation: 72,
      fluency: 68,
      rhythm: 70,
    );

    final a = n.of(1)!;
    expect(a.averagePronunciation, 80);
    expect(a.averageFluency, 80);
    expect(a.averageRhythm, 80);
  });

  test('채점 전에는 세부 평균도 null 이다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 1);
    final a = n.of(1)!;
    expect(a.averagePronunciation, isNull);
    expect(a.averageFluency, isNull);
    expect(a.averageRhythm, isNull);
  });

  // ── 서버 복원 (2026-09-04) ──
  //
  // 채점이 서버에 남는다. 세 문장 읽고 나갔다 들어온 학습자는 이전 결과를
  // 되찾아야 하고, 같은 문장을 다시 읽으면 통과 수가 늘지 않아야 한다.

  AssignmentItem item(int id, {AssignmentItemResult? score}) => AssignmentItem(
    itemId: id,
    surface: '단어$id',
    example: '단어$id 를 씁니다.',
    exampleMeaning: 'I use word $id.',
    score: score,
  );

  test('서버에 남은 채점으로 되살린다', () {
    final n = notifier();
    n.restore(
      assignmentId: 1,
      items: [
        item(11, score: const AssignmentItemResult(
          itemId: 11, passed: true, totalScore: 90, pronunciation: 90,
          fluency: 90, rhythm: 90,
        )),
        item(12, score: const AssignmentItemResult(
          itemId: 12, passed: false, totalScore: 40,
        )),
        item(13), // 아직 안 읽은 문장
      ],
    );

    final a = n.of(1)!;
    expect(a.total, 3);      // 분모는 출제 수다
    expect(a.scored, 2);     // 읽은 것은 둘
    expect(a.passed, 1);
    expect(a.failedItemIds, [12]);
    expect(a.averageScore, 65);
  });

  test('되살릴 때 앱에만 있던 값을 이어 붙이지 않는다 — 서버가 정답이다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 2);
    n.record(assignmentId: 1, itemId: 11, passed: true, totalScore: 90);

    n.restore(assignmentId: 1, items: [item(11), item(12)]);
    expect(n.of(1)!.scored, 0);
  });

  test('같은 문장을 다시 읽으면 덮어쓴다 — 통과 수가 출제 수를 넘지 않는다', () {
    final n = notifier();
    n.start(assignmentId: 1, total: 1);
    n.record(assignmentId: 1, itemId: 11, passed: false, totalScore: 30);
    n.record(assignmentId: 1, itemId: 11, passed: true, totalScore: 91);

    final a = n.of(1)!;
    expect(a.scored, 1);
    expect(a.passed, 1);
    expect(a.averageScore, 91);   // 앞의 30 이 남아 평균을 끌어내리지 않는다
    expect(a.failedItemIds, isEmpty);
  });

  test('예문을 읽을 때는 예문 번역이 뜬다 — 표제어 뜻이 아니다', () {
    // 🔴 「그 사람은 선생님이 아닙니다」 밑에 `person` 이 뜨던 어긋남.
    const withExample = AssignmentItem(
      itemId: 1,
      surface: '사람',
      example: '그 사람은 선생님이 아닙니다.',
      meaning: 'person',
      exampleMeaning: 'That person is not a teacher.',
    );
    expect(withExample.readable, '그 사람은 선생님이 아닙니다.');
    expect(withExample.readableMeaning, 'That person is not a teacher.');

    // 예문이 없어 표제어를 읽는다면 표제어 뜻이 맞다.
    const wordOnly = AssignmentItem(itemId: 2, surface: '사람', meaning: 'person');
    expect(wordOnly.readable, '사람');
    expect(wordOnly.readableMeaning, 'person');

    // 예문 번역이 없으면 **비운다.** 표제어 뜻으로 메우지 않는다.
    const noTranslation = AssignmentItem(
      itemId: 3, surface: '천', example: '이 가방은 천 원이에요.', meaning: 'thousand',
    );
    expect(noTranslation.readableMeaning, isNull);
  });
}
