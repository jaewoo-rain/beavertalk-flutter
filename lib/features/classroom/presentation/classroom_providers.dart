import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/network/env.dart';
import '../data/datasources/classroom_remote_data_source.dart';
import '../data/datasources/joined_class_store.dart';
import '../data/repositories/classroom_repository_impl.dart';
import '../domain/entities/classroom_assignment.dart';
import '../domain/entities/classroom_membership.dart';
import '../domain/repositories/classroom_repository.dart';
import '../../../screens/home/learning_summary.dart';

/// 반 라우터 데이터 소스.
///
/// ⛔ [dioProvider] 가 아니라 [b2bDioProvider] 다 — 교실·과제는 분리된 B2B
///    서비스에 있고, 앱 서버에는 `/classrooms/*` 경로가 하나도 없다.
final classroomRemoteDataSourceProvider = Provider<ClassroomRemoteDataSource>((
  ref,
) {
  return ClassroomRemoteDataSource(ref.watch(b2bDioProvider));
});

/// 참여한 반 id 저장소 — 목록 응답에 `classroom_id` 가 없어 필요하다.
final joinedClassStoreProvider = Provider<JoinedClassStore>((ref) {
  return const JoinedClassStore();
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
  // B2B 주소가 없는 빌드에서는 숙제가 통째로 꺼진 것이다. 여기서 빈 목록으로
  // 끊는다 — 안 끊으면 [b2bDioProvider] 가 던지고 화면마다 오류로 번역된다.
  if (!Env.hasB2bApi) return const <ClassroomAssignment>[];
  return ref.watch(classroomRepositoryProvider).myAssignments();
});

/// 내가 참여한 반.
///
/// 🔴 **참여 여부를 [myAssignmentsProvider] 로 판정하지 마라.** 숙제를 다 끝내면
/// 그 목록은 「할 일 없음」이 되고, 그것을 「반 없음」으로 읽으면 홈이 참여코드
/// 입력으로 돌아간다 — 학습자가 앱을 켤 때마다 코드를 다시 치게 된다(2026-09-04).
final myClassroomsProvider = FutureProvider<List<JoinedClassroom>>((ref) async {
  // B2B 주소가 없는 빌드에서는 교실이 통째로 꺼진 것이다(숙제 목록과 같은 규약).
  if (!Env.hasB2bApi) return const <JoinedClassroom>[];
  return ref.watch(classroomRepositoryProvider).myClassrooms();
});

/// 반 소속이 바뀌었다 — **교실 축 캐시를 통째로 버린다.**
///
/// 🔴 하나만 버리지 마라. 참여·나가기는 두 축을 **동시에** 바꾼다.
///    2026-09-04 실측: 나가기가 [myAssignmentsProvider] 만 버려서, 서버에서는
///    이미 나갔는데(`left_at` 기록됨) 마이페이지 카드는 [myClassroomsProvider]
///    의 옛 값을 들고 **반 이름을 계속 보여줬다.** 눌러서 들어가면 숙제만
///    사라져 있었다 — 「나갔는데 안 나가진」 화면이다.
///
/// ⛔ 소속을 바꾸는 화면은 이 함수를 부른다. 개별 provider 를 골라 버리지 마라 —
///    축이 하나 늘 때마다 호출부를 전부 고쳐야 하고, 그때 한 곳을 빠뜨린다.
void invalidateClassroomMembership(WidgetRef ref) {
  ref.invalidate(myAssignmentsProvider);
  ref.invalidate(myClassroomsProvider);
}

/// 과제 발음 결과 요약. 세션 요약 화면이 읽는다.
///
/// autoDispose: 화면을 벗어나면 버린다. 다시 들어오면 서버 값을 새로 읽어야
/// 방금 채점한 문장이 반영된다.
final assignmentReportProvider = FutureProvider.autoDispose
    .family<LearningSummary, int>((ref, assignmentId) async {
      return ref.watch(classroomRepositoryProvider).assignmentReport(assignmentId);
    });

