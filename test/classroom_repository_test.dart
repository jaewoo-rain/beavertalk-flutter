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
      final r = await _make(409, {'detail': '반 정원이 찼습니다.'}).repo.join(
        joinCode: 'ABC123',
        rosterName: '김학생',
        shareConsent: true,
      );
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

    test('발음이 전건 통과면 활동 1개가 끝난 것으로 센다', () {
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
        'speaking_passed': 14,
        'speaking_total': 14,
      });

      // 워크북은 서버에 완료 신호가 없어 세지 않는다.
      expect(a.completedActivityCount, 1);
      expect(a.activityCount, 2);
    });
  });
}
