/// A2 「반 확인」 화면이 쓰는 값 — `GET /classrooms/preview` 응답 그대로다.
///
/// 반 이름은 교사가 쓴 원문이 내려온다. **번역하지 않는다**(서버 주석 명시).
class JoinPreview {
  /// 서버 응답 1건을 담는다.
  const JoinPreview({
    required this.classroomId,
    required this.name,
    required this.targetGrade,
    required this.learnerCount,
    required this.capacity,
    this.institution,
    this.teacherDisplayName,
    this.term,
  });

  /// `{"classroom_id": 1, "name": "...", ...}` 를 읽는다.
  factory JoinPreview.fromJson(Map<String, dynamic> json) {
    return JoinPreview(
      classroomId: (json['classroom_id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      targetGrade: (json['target_grade'] as num?)?.toInt() ?? 0,
      learnerCount: (json['learner_count'] as num?)?.toInt() ?? 0,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      institution: json['institution'] as String?,
      teacherDisplayName: json['teacher_display_name'] as String?,
      term: json['term'] as String?,
    );
  }

  /// 반 id. 참여 후 `DELETE /classrooms/{id}/leave` 에 쓴다.
  final int classroomId;

  /// 교사가 지은 반 이름 원문.
  final String name;

  /// 대상 급수(1~6).
  final int targetGrade;

  /// 현재 참여 인원.
  final int learnerCount;

  /// 정원. 참여 시점에 [learnerCount] 가 이 값에 닿으면 409 가 난다.
  final int capacity;

  /// 기관명. 교사가 비워 둘 수 있다.
  final String? institution;

  /// 교사 표시 이름. 교사가 비워 둘 수 있다.
  final String? teacherDisplayName;

  /// 학기 표기(예: `2026-2`). 교사가 비워 둘 수 있다.
  final String? term;

  /// 정원이 찼는지. 화면이 미리 막아 409 를 덜 만나게 한다.
  bool get isFull => capacity > 0 && learnerCount >= capacity;
}

/// 참여코드 조회 결과.
///
/// **코드가 틀린 것은 예외가 아니라 화면 상태다.** 서버는 404·410 으로
/// 답하지만 학습자에게는 「오류」가 아니라 「다시 입력해 주세요」다. 그래서
/// throw 하지 않고 결과 타입으로 올린다 — 네트워크·인증 실패만 예외로 던진다.
sealed class JoinPreviewResult {
  /// 하위 타입 공통 생성자.
  const JoinPreviewResult();
}

/// 코드가 맞았다. [preview] 를 A2 화면에 그린다.
class JoinPreviewFound extends JoinPreviewResult {
  /// 조회된 반 정보를 담는다.
  const JoinPreviewFound(this.preview);

  /// 조회 결과.
  final JoinPreview preview;
}

/// 그런 코드가 없거나 보관된 반이다(서버 404).
class JoinPreviewNotFound extends JoinPreviewResult {
  /// 상수 인스턴스.
  const JoinPreviewNotFound();
}

/// 코드는 있었지만 유효기간이 지났다(서버 410).
///
/// 안내 문구가 [JoinPreviewNotFound] 와 달라야 한다 — 학습자가 코드를 잘못
/// 적은 게 아니라 교사에게 새 코드를 받아야 하는 상황이다.
class JoinPreviewExpired extends JoinPreviewResult {
  /// 상수 인스턴스.
  const JoinPreviewExpired();
}
