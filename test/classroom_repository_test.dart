// 반 참여·숙제 계약 테스트.
//
// 지키려는 것 셋.
// 1) 학습자가 되돌릴 수 있는 실패(코드 오타·만료·정원 초과)는 예외가 아니라
//    결과 타입으로 올라온다 — 화면이 세 안내를 따로 그려야 하기 때문이다.
// 2) 진행 수치 4종의 null 이 0 으로 뭉개지지 않는다 — null 은 「아직 없음」이고
//    0 은 「0건 통과」다.
// 3) 빈 학번은 키 자체를 보내지 않는다 — 명단에 빈 학번이 남으면 안 된다.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/features/classroom/data/datasources/classroom_remote_data_source.dart';
import 'package:beavertalk/features/classroom/data/repositories/classroom_repository_impl.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/domain/entities/join_preview.dart';

/// 지정한 상태 코드·본문으로 답하고 마지막 요청을 붙잡아 둔다.
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object? body;
  RequestOptions? lastRequest;
  String? lastBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (requestStream != null) {
      final chunks = await requestStream.toList();
      lastBody = utf8.decode(chunks.expand((c) => c).toList());
    }
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

({ClassroomRepositoryImpl repo, _StubAdapter adapter}) _make(
  int status,
  Object? body,
) {
  final adapter = _StubAdapter(status, body);
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api/v1'))
    ..httpClientAdapter = adapter;
  return (
    repo: ClassroomRepositoryImpl(ClassroomRemoteDataSource(dio)),
    adapter: adapter,
  );
}

void main() {
  group('previewByCode — 되돌릴 수 있는 실패는 결과 타입이다', () {
    test('404 는 예외가 아니라 JoinPreviewNotFound 다', () async {
      final r = await _make(404, {
        'detail': '참여코드를 확인해 주세요.',
      }).repo.previewByCode('ABC123');
      expect(r, isA<JoinPreviewNotFound>());
    });

    test('410 은 만료로 구분된다 — 404 와 안내가 다르다', () async {
      final r = await _make(410, {
        'detail': '만료된 참여코드입니다.',
      }).repo.previewByCode('ABC123');
      expect(r, isA<JoinPreviewExpired>());
    });

    test('500 은 그대로 예외로 던진다', () async {
      expect(
        () => _make(500, {'detail': 'boom'}).repo.previewByCode('ABC123'),
        throwsA(isA<AppException>()),
      );
    });

    test('200 이면 반 정보를 준다', () async {
      final r = await _make(200, {
        'classroom_id': 7,
        'name': '초급 1반',
        'institution': '전북대학교 한국어교육원',
        'teacher_display_name': '김선생',
        'target_grade': 1,
        'term': '2026-2',
        'learner_count': 12,
        'capacity': 30,
      }).repo.previewByCode('ABC123');

      expect(r, isA<JoinPreviewFound>());
      final p = (r as JoinPreviewFound).preview;
      expect(p.classroomId, 7);
      expect(p.name, '초급 1반');
      expect(p.isFull, isFalse);
    });

    test('정원이 찬 반은 isFull 로 미리 드러난다', () async {
      final r = await _make(200, {
        'classroom_id': 7,
        'name': '초급 1반',
        'target_grade': 1,
        'learner_count': 30,
        'capacity': 30,
      }).repo.previewByCode('ABC123');

      expect((r as JoinPreviewFound).preview.isFull, isTrue);
    });
  });

  group('join', () {
    test('409 는 예외가 아니라 JoinClassFull 이다', () async {
      final r = await _make(409, {
        'detail': '반 정원이 찼습니다.',
      }).repo.join(joinCode: 'ABC123', rosterName: '김학생', shareConsent: true);
      expect(r, isA<JoinClassFull>());
    });

    test('빈 학번은 키 자체를 보내지 않는다', () async {
      final made = _make(201, {
        'classroom_member_id': 1,
        'classroom_id': 7,
        'classroom_name': '초급 1반',
        'roster_name': '김학생',
      });
      final r = await made.repo.join(
        joinCode: 'ABC123',
        rosterName: '김학생',
        shareConsent: true,
        studentNo: '   ',
      );

      expect(r, isA<JoinSucceeded>());
      final sent = jsonDecode(made.adapter.lastBody!) as Map<String, dynamic>;
      expect(sent.containsKey('student_no'), isFalse);
      expect(sent['share_consent'], isTrue);
      expect((r as JoinSucceeded).membership.classroomId, 7);
    });

    test('학번이 있으면 공백을 떼고 보낸다', () async {
      final made = _make(201, {
        'classroom_member_id': 1,
        'classroom_id': 7,
        'classroom_name': '초급 1반',
        'roster_name': '김학생',
      });
      await made.repo.join(
        joinCode: 'ABC123',
        rosterName: '김학생',
        shareConsent: true,
        studentNo: ' 20260001 ',
      );

      final sent = jsonDecode(made.adapter.lastBody!) as Map<String, dynamic>;
      expect(sent['student_no'], '20260001');
    });
  });

  group('submitSpeaking', () {
    test('점수가 아니라 문장 수를 보낸다', () async {
      final made = _make(200, {'ok': true});
      await made.repo.submitSpeaking(
        assignmentId: 3,
        passed: 12,
        total: 14,
        failedItemIds: const [101, 102],
      );

      final sent = jsonDecode(made.adapter.lastBody!) as Map<String, dynamic>;
      expect(sent['passed'], 12);
      expect(sent['total'], 14);
      expect(sent['failed_item_ids'], [101, 102]);
      expect(
        made.adapter.lastRequest!.path,
        '/classrooms/assignments/3/speaking',
      );
    });
  });

  group('ClassroomAssignment.fromJson', () {
    test('진행 수치의 null 을 0 으로 뭉개지 않는다', () {
      final a = ClassroomAssignment.fromJson({
        'assignment_id': 3,
        'classroom_name': '초급 1반',
        'grade': 1,
        'chapter': 3,
        'activities': ['speaking', 'conversation', 'workbook'],
        'item_ids': [11, 12],
        'due_at': '2026-09-10T14:00:00Z',
        'overdue': false,
        'status': 'not_started',
        'speaking_passed': null,
        'speaking_total': null,
        'conversation_met': null,
        'conversation_total': null,
      });

      expect(a.speakingPassed, isNull);
      expect(a.speakingTotal, isNull);
      expect(a.status, AssignmentStatus.notStarted);
      expect(a.activityCount, 3);
      expect(a.completedActivityCount, 0);
    });

    test('0 통과는 null 과 다르게 남는다', () {
      final a = ClassroomAssignment.fromJson({
        'assignment_id': 4,
        'classroom_name': '초급 1반',
        'grade': 1,
        'chapter': 3,
        'activities': ['speaking'],
        'item_ids': <int>[],
        'due_at': '2026-09-10T14:00:00Z',
        'overdue': true,
        'status': 'in_progress',
        'speaking_passed': 0,
        'speaking_total': 14,
      });

      expect(a.speakingPassed, 0);
      expect(a.speakingTotal, 14);
      expect(a.completedActivityCount, 0);
      expect(a.overdue, isTrue);
    });

    test('모르는 활동 코드는 버리고 죽지 않는다', () {
      final a = ClassroomAssignment.fromJson({
        'assignment_id': 5,
        'classroom_name': '초급 1반',
        'grade': 1,
        'chapter': 3,
        'activities': ['speaking', 'listening_v2'],
        'item_ids': <int>[],
        'due_at': '2026-09-10T14:00:00Z',
        'overdue': false,
        'status': 'done',
      });

      expect(a.activities, [AssignmentActivity.speaking]);
      expect(a.status, AssignmentStatus.done);
    });

    test('발음을 다 읽으면 활동 1개가 끝난 것으로 센다', () {
      final a = ClassroomAssignment.fromJson({
        'assignment_id': 6,
        'classroom_name': '초급 1반',
        'grade': 1,
        'chapter': 3,
        'activities': ['speaking', 'workbook'],
        'item_ids': <int>[],
        'due_at': '2026-09-10T14:00:00Z',
        'overdue': false,
        'status': 'done',
        'speaking_scored': 14,
        'speaking_passed': 14,
        'speaking_total': 14,
      });

      // 워크북은 서버에 완료 신호가 없어 세지 않는다.
      expect(a.completedActivityCount, 1);
      expect(a.activityCount, 2);
    });

    test('두 문장 틀려도 다 읽었으면 센다 — 분자는 읽은 수다', () {
      // 🔴 2026-09-04 실측. `speaking_passed` 로 세던 시절 상세는 「완료」인데
      //    목록 카드는 `0/3` 이었다. 판정은 한 곳(`isActivityDone`)에만 둔다.
      final a = ClassroomAssignment.fromJson({
        'assignment_id': 7,
        'classroom_name': '초급 1반',
        'grade': 1,
        'chapter': 1,
        'activities': ['speaking', 'conversation', 'workbook'],
        'item_ids': <int>[],
        'due_at': '2026-09-10T14:00:00Z',
        'overdue': false,
        'status': 'in_progress',
        'speaking_scored': 38,
        'speaking_passed': 37,
        'speaking_total': 38,
        'conversation_met': null,
        'conversation_total': 10,
      });

      expect(a.isActivityDone(AssignmentActivity.speaking), isTrue);
      expect(a.isActivityDone(AssignmentActivity.conversation), isFalse);
      expect(a.isActivityDone(AssignmentActivity.workbook), isFalse);
      expect(a.completedActivityCount, 1);
      expect(a.activityCount, 3);
    });
  });

  group('과제 문장 목록·채점', () {
    test('문장 목록은 서버 순서를 그대로 지킨다', () async {
      final r = await _make(200, {
        'assignment_id': 3,
        'grade': 1,
        'chapter': 2,
        'chapter_range': '그림 ~ 남편',
        'closed': false,
        'items': [
          {'item_id': 21, 'seq': 41, 'surface': '그림', 'example': '그림을 봅니다.'},
          {'item_id': 22, 'seq': 42, 'surface': '남편', 'meaning': 'husband'},
        ],
      }).repo.assignmentItems(3, locale: 'en');

      expect(r.chapterRange, '그림 ~ 남편');
      expect(r.items.map((e) => e.itemId).toList(), [21, 22]);
      // 예문이 있으면 예문을, 없으면 표제어를 읽는다.
      expect(r.items[0].readable, '그림을 봅니다.');
      expect(r.items[1].readable, '남편');
      // 뜻은 비어 있을 수 있다 — 표제어로 메우지 않는다.
      expect(r.items[0].meaning, isNull);
      expect(r.items[1].meaning, 'husband');
    });

    test('채점은 서버의 통과 판정을 그대로 쓴다', () async {
      final made = _make(200, {
        'item_id': 21,
        'ref_text': '그림을 봅니다.',
        'passed': false,
        'evaluation': {
          'total_score': 92,
          'pronunciation': 90,
          'fluency': 94,
          'rhythm': 91,
        },
        'char_scores': [
          {'char': '그', 'score': 90, 'grade': '상'},
        ],
      });
      final s = await made.repo.scoreItem(
        assignmentId: 3,
        itemId: 21,
        wavBytes: Uint8List.fromList(const [1, 2, 3]),
      );

      // 92 점이지만 서버가 통과로 안 봤다. 앱이 점수로 다시 재면 안 된다.
      expect(s.passed, isFalse);
      expect(s.itemId, 21);
      expect(s.refText, '그림을 봅니다.');
      expect(s.feedback.evaluation.totalScore, 92);
      expect(s.feedback.charScores, hasLength(1));
      expect(
        made.adapter.lastRequest!.path,
        '/classrooms/assignments/3/items/21/score',
      );
    });
  });

  group('ClassroomAssignment — 닫힘·워크북', () {
    ClassroomAssignment parse(Map<String, dynamic> extra) {
      return ClassroomAssignment.fromJson({
        'assignment_id': 7,
        'classroom_name': '초급 1반',
        'grade': 1,
        'chapter': 3,
        'activities': ['workbook'],
        'item_ids': <int>[],
        'due_at': '2026-09-10T14:00:00Z',
        'overdue': false,
        'status': 'not_started',
        ...extra,
      });
    }

    test('닫힌 과제는 마감과 다르다', () {
      expect(parse({}).isClosed, isFalse);
      expect(parse({'closed_at': '2026-09-11T00:00:00Z'}).isClosed, isTrue);
    });

    test('워크북은 챕터 자산이라 중첩 객체로 온다', () {
      expect(parse({}).workbookUrl, isNull);
      expect(
        parse({
          'workbook': {
            'grade': 1,
            'chapter': 3,
            'file_name': '1급_3과.pdf',
            'view_url': 'https://drive.example/x.pdf',
            'download_url': null,
          },
        }).workbookUrl,
        'https://drive.example/x.pdf',
      );
    });

    test('평평한 workbook_url 은 더 이상 읽지 않는다', () {
      // 09-03 초안의 `assignment.workbook_url` 컬럼안은 폐기됐다. 서버가 그
      // 모양으로 보내는 일이 없어야 하고, 와도 링크로 오인하지 않는다.
      expect(parse({'workbook_url': 'https://drive.example/x.pdf'}).workbookUrl,
          isNull);
    });

    test('반 id 를 서버가 주면 읽는다 — 나가기가 이 값을 요구한다', () {
      expect(parse({}).classroomId, isNull);
      expect(parse({'classroom_id': 42}).classroomId, 42);
    });
  });
}
