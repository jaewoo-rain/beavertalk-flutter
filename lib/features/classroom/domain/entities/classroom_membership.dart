/// 반 참여 결과 — `POST /classrooms/join` 응답.
class ClassroomMembership {
  /// 응답 1건을 담는다.
  const ClassroomMembership({
    required this.classroomMemberId,
    required this.classroomId,
    required this.classroomName,
    required this.rosterName,
  });

  /// `{"classroom_member_id": …, "classroom_id": …}` 를 읽는다.
  factory ClassroomMembership.fromJson(Map<String, dynamic> json) {
    return ClassroomMembership(
      classroomMemberId: (json['classroom_member_id'] as num).toInt(),
      classroomId: (json['classroom_id'] as num).toInt(),
      classroomName: json['classroom_name'] as String? ?? '',
      rosterName: json['roster_name'] as String? ?? '',
    );
  }

  /// 반 명단에서의 내 id. 교사 화면이 이 값으로 나를 가리킨다.
  final int classroomMemberId;

  /// 반 id. 나가기에 쓴다.
  final int classroomId;

  /// 반 이름 원문.
  final String classroomName;

  /// 반에서 쓰는 이름. 앱 계정 이름과 별개다.
  final String rosterName;
}

/// 참여 시도 결과.
///
/// 정원 초과만 결과 타입으로 올린다 — 학습자 잘못이 아니고 재시도해도 같으므로
/// 「오류」가 아니라 안내 화면이 맞다. 나머지 실패는 예외로 던진다.
sealed class JoinResult {
  /// 하위 타입 공통 생성자.
  const JoinResult();
}

/// 참여했다.
///
/// **이미 참여 중이었어도 이 결과다.** 서버가 기존 행을 그대로 돌려준다(멱등).
///
/// 🔴 **나갔다가 다시 들어오면 새 행이다.** `leave` 가 익명화로 `member_id` 를
/// 비우기 때문에 `join` 이 옛 행을 찾지 못한다 — 서버가 의도한 동작이며
/// 「새 행 = 새 동의」다. 앱이 「돌아오셨네요」 같은 복구를 기대하면 안 된다.
class JoinSucceeded extends JoinResult {
  /// 참여 결과를 담는다.
  const JoinSucceeded(this.membership);

  /// 참여한 반의 명단 정보.
  final ClassroomMembership membership;
}

/// 정원이 찼다(서버 409).
class JoinClassFull extends JoinResult {
  /// 상수 인스턴스.
  const JoinClassFull();
}
