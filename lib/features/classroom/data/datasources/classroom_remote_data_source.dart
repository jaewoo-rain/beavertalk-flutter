import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';

/// 앱 서버(FastAPI)의 학습자용 반 라우터를 부른다.
///
/// 신고(Supabase 직행)와 달리 여기는 **앱 서버가 이미 구현돼 있다** — 2026-09-02
/// 서버 소스 실측 기준 `preview`·`join`·`my/assignments`·`leave`·`speaking`
/// 5종이 살아 있다. 없는 것은 과제 문장 목록과 무상태 채점 2종이다.
///
/// 응답을 그대로 돌려주고, 타입 변환과 예외 번역은 리포지토리가 한다.
class ClassroomRemoteDataSource {
  /// [dio] 를 주입받는다(테스트에서 대체 가능).
  ClassroomRemoteDataSource(this._dio);

  final Dio _dio;

  /// A2 반 확인. 무인증 경로다.
  Future<Map<String, dynamic>> preview(String joinCode) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.classroomPreview,
      queryParameters: <String, dynamic>{'join_code': joinCode},
    );
    return res.data ?? const <String, dynamic>{};
  }

  /// A3 반 참여.
  ///
  /// `student_no` 는 선택이라 비어 있으면 **키 자체를 보내지 않는다** — 빈
  /// 문자열을 보내면 명단에 빈 학번이 남는다.
  Future<Map<String, dynamic>> join({
    required String joinCode,
    required String rosterName,
    required bool shareConsent,
    String? studentNo,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.classroomJoin,
      data: <String, dynamic>{
        'join_code': joinCode,
        'roster_name': rosterName,
        'share_consent': shareConsent,
        if (studentNo != null && studentNo.trim().isNotEmpty)
          'student_no': studentNo.trim(),
      },
    );
    return res.data ?? const <String, dynamic>{};
  }

  /// A6 내 과제 목록.
  Future<List<dynamic>> myAssignments() async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.classroomMyAssignments,
    );
    return res.data ?? const <dynamic>[];
  }

  /// DA1 반 나가기. 성공 시 204 라 본문이 없다.
  Future<void> leave(int classroomId) async {
    await _dio.delete<void>(ApiEndpoints.classroomLeave(classroomId));
  }

  /// B4 발음 과제 제출.
  Future<void> submitSpeaking({
    required int assignmentId,
    required int passed,
    required int total,
    required List<int> failedItemIds,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.classroomSpeakingSubmit(assignmentId),
      data: <String, dynamic>{
        'passed': passed,
        'total': total,
        'failed_item_ids': failedItemIds,
      },
    );
  }
}
