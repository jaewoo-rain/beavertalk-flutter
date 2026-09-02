import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/datasources/classroom_remote_data_source.dart';
import '../data/repositories/classroom_repository_impl.dart';
import '../domain/entities/classroom_assignment.dart';
import '../domain/repositories/classroom_repository.dart';

/// 반 라우터 데이터 소스.
final classroomRemoteDataSourceProvider = Provider<ClassroomRemoteDataSource>((
  ref,
) {
  return ClassroomRemoteDataSource(ref.watch(dioProvider));
});

/// 반 참여·숙제 리포지토리.
final classroomRepositoryProvider = Provider<ClassroomRepository>((ref) {
  return ClassroomRepositoryImpl(ref.watch(classroomRemoteDataSourceProvider));
});

/// A6 숙제 목록.
///
/// 마감 역순으로 내려오는 것을 **그대로 두지 않고** 화면 정렬 규칙으로 다시
/// 세운다 — 스펙 §7 「리스트 정렬」이 미제출 → 임박 → 예정 → 완료 순이다.
/// 정렬은 화면 계층에서 한다. 여기서는 서버 응답을 그대로 캐시한다.
final myAssignmentsProvider = FutureProvider<List<ClassroomAssignment>>((
  ref,
) async {
  return ref.watch(classroomRepositoryProvider).myAssignments();
});
