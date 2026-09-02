import 'package:dio/dio.dart';

import '../../../../core/error/dio_error_mapper.dart';
import '../../domain/entities/classroom_assignment.dart';
import '../../domain/entities/classroom_membership.dart';
import '../../domain/entities/join_preview.dart';
import '../../domain/repositories/classroom_repository.dart';
import '../datasources/classroom_remote_data_source.dart';

/// [ClassroomRepository] 구현.
///
/// 상태 코드를 두 갈래로 나눈다.
/// - **학습자가 되돌릴 수 있는 것**(404·410·409) → 결과 타입으로 올린다.
/// - 그 밖의 실패 → `mapDioException` 을 거쳐 `AppException` 으로 던진다.
///
/// 410(만료)을 결과로 올리는 이유 — `mapDioException` 에 410 분기가 없어
/// `UnknownFailure` 로 뭉개진다. 그러면 「코드가 틀렸다」와 「기간이 지났다」를
/// 화면이 구분할 수 없다. 두 안내 문구는 학습자가 할 일이 다르다.
class ClassroomRepositoryImpl implements ClassroomRepository {
  /// [ds] 로 서버를 부른다.
  ClassroomRepositoryImpl(this._ds);

  final ClassroomRemoteDataSource _ds;

  @override
  Future<JoinPreviewResult> previewByCode(String joinCode) async {
    try {
      final json = await _ds.preview(joinCode);
      return JoinPreviewFound(JoinPreview.fromJson(json));
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 404:
          return const JoinPreviewNotFound();
        case 410:
          return const JoinPreviewExpired();
      }
      throw mapDioException(e);
    }
  }

  @override
  Future<JoinResult> join({
    required String joinCode,
    required String rosterName,
    required bool shareConsent,
    String? studentNo,
  }) async {
    try {
      final json = await _ds.join(
        joinCode: joinCode,
        rosterName: rosterName,
        shareConsent: shareConsent,
        studentNo: studentNo,
      );
      return JoinSucceeded(ClassroomMembership.fromJson(json));
    } on DioException catch (e) {
      // 참여 경로의 409 는 정원 초과 하나뿐이다(서버 `classroom_service.join`).
      if (e.response?.statusCode == 409) return const JoinClassFull();
      throw mapDioException(e);
    }
  }

  @override
  Future<List<ClassroomAssignment>> myAssignments() async {
    try {
      final list = await _ds.myAssignments();
      return list
          .whereType<Map<String, dynamic>>()
          .map(ClassroomAssignment.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> leave(int classroomId) async {
    try {
      await _ds.leave(classroomId);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> submitSpeaking({
    required int assignmentId,
    required int passed,
    required int total,
    List<int> failedItemIds = const <int>[],
  }) async {
    try {
      await _ds.submitSpeaking(
        assignmentId: assignmentId,
        passed: passed,
        total: total,
        failedItemIds: failedItemIds,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
