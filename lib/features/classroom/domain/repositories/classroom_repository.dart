import 'dart:typed_data';

import '../entities/assignment_item.dart';
import '../entities/classroom_assignment.dart';
import '../entities/classroom_membership.dart';
import '../entities/join_preview.dart';

/// 반 참여·숙제 조회. 데이터 계층에서 구현한다.
///
/// 실패는 `core/error/app_exception.dart` 의 `AppException` 으로 던진다 —
/// dio 타입이 프레젠테이션 계층으로 새지 않는다.
///
/// **학습자가 되돌릴 수 있는 상황은 예외가 아니라 결과 타입이다**
/// ([JoinPreviewResult]·[JoinResult]). 코드 오타·만료·정원 초과가 그렇다.
abstract interface class ClassroomRepository {
  /// A1→A2. 참여코드로 반을 미리 본다. 인증이 필요 없다.
  ///
  /// [joinCode] 는 6자리다. 서버가 대문자로 맞추므로 앱이 변환하지 않아도 된다.
  Future<JoinPreviewResult> previewByCode(String joinCode);

  /// A3→A5. 반에 참여한다.
  ///
  /// [shareConsent] 가 false 면 서버가 400 으로 거절한다 — 화면이 먼저 막는다.
  /// [rosterName] 은 반에서 쓸 이름이며 앱 계정 이름과 별개다.
  Future<JoinResult> join({
    required String joinCode,
    required String rosterName,
    required bool shareConsent,
    String? studentNo,
  });

  /// A6. 내가 속한 반들의 과제를 마감 역순으로 받는다.
  Future<List<ClassroomAssignment>> myAssignments();

  /// DA1. 반을 나간다 = **개인정보 공유 동의 철회**.
  ///
  /// 반 명단 정보는 파기되고 교사가 조회할 수 없게 된다. 앱 계정과 개인 학습
  /// 기록은 지워지지 않는다.
  Future<void> leave(int classroomId);

  /// A7. 과제가 출제한 문장 목록. 순서는 출제 시점 그대로다.
  ///
  /// [locale] 은 뜻의 언어다. 서버가 요청 로케일 → 영어 → null 순으로 떨어뜨린다.
  Future<AssignmentItems> assignmentItems(int assignmentId, {String? locale});

  /// 과제 문장 1개를 채점한다. **서버가 아무것도 저장하지 않는다.**
  ///
  /// 통과 여부는 서버가 판정한 [AssignmentItemScore.passed] 를 그대로 쓴다 —
  /// 앱이 점수로 다시 판정하면 경계가 두 곳이 된다.
  Future<AssignmentItemScore> scoreItem({
    required int assignmentId,
    required int itemId,
    required Uint8List wavBytes,
  });

  /// B4. 발음 과제 결과를 제출한다.
  ///
  /// 🔴 [passed] 는 **점수가 아니라 AI 가 알아들은 문장 수**다. 0~100 을 보내면
  /// 교사 화면의 「n / m 문장」이 깨진다.
  ///
  /// [failedItemIds] 는 교사 화면 「다시 가르칠 문장」의 유일한 재료다. 비워
  /// 보내면 그 칸이 영원히 빈 상태로 남는다.
  Future<void> submitSpeaking({
    required int assignmentId,
    required int passed,
    required int total,
    List<int> failedItemIds,
  });
}
