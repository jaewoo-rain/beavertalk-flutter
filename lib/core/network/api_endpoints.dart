/// Backend path constants (relative to [Env.apiBaseUrl], no host or prefix).
///
/// Authentication is handled by Supabase Auth (the `/auth/*` backend endpoints
/// were removed); only the Bearer-protected member endpoints remain here.
abstract final class ApiEndpoints {
  // ── Members ──
  static const membersMe = '/members/me';
  static const membersMeProfile = '/members/me/profile';
  static const onboarding = '/members/me/onboarding';

  /// 레벨테스트 다시 받기. 레벨 배정만 지우고 **체크판(학습 기록)은 보존**한다.
  /// 성공하면 다음 통화가 자동으로 레벨테스트로 라우팅된다.
  static const membersMeLevelTestRetake = '/members/me/level-test/retake';

  // ── Classroom (learner side) ──
  /// A2 반 확인. 무인증. `?join_code=` 6자리.
  static const classroomPreview = '/classrooms/preview';

  /// A3 반 참여. `roster_name`·`student_no`·`share_consent` 를 보낸다.
  static const classroomJoin = '/classrooms/join';

  /// A6 내 과제 목록. 문안이 아니라 데이터만 내려온다.
  static const classroomMyAssignments = '/classrooms/my/assignments';

  /// 내가 참여한 반. **과제가 없어도 나온다** — 참여 여부는 숙제로 추측할 것이
  /// 아니다.
  static const classroomMy = '/classrooms/my';

  /// DA1 반 나가기 = 공유 동의 철회. `/classrooms/{id}/leave`.
  static String classroomLeave(int classroomId) =>
      '/classrooms/$classroomId/leave';

  /// A7 과제 문장 목록. `?locale=` 로 뜻의 언어를 고른다.
  static String classroomAssignmentItems(int assignmentId) =>
      '/classrooms/assignments/$assignmentId/items';

  /// 과제 문장 1개의 무상태 채점(multipart `audio`).
  static String classroomItemScore(int assignmentId, int itemId) =>
      '/classrooms/assignments/$assignmentId/items/$itemId/score';

  /// 과제 발음 결과 요약. `/classrooms/assignments/{id}/pronunciation-report`.
  ///
  /// 앱 서버의 `/calls/{id}/pronunciation-report` 와 **같은 모양**이지만 축이
  /// 다르다 — 그쪽은 통화, 이쪽은 과제다.
  static String classroomAssignmentReport(int assignmentId) =>
      '/classrooms/assignments/$assignmentId/pronunciation-report';

  /// 과제 예문의 원어민 음성. `/classrooms/assignments/{id}/items/{itemId}/tts`.
  ///
  /// 🔴 앱 서버의 `/sentences/{id}/tts` 를 쓰면 안 된다 — 그쪽은 **통화 문장** 전용이고
  /// 과제 문장의 id 는 학습 항목 id 라 남의 문장이 나온다.
  static String classroomItemTts(int assignmentId, int itemId) =>
      '/classrooms/assignments/$assignmentId/items/$itemId/tts';

  /// B4 발음 과제 제출. `/classrooms/assignments/{id}/speaking`.
  static String classroomSpeakingSubmit(int assignmentId) =>
      '/classrooms/assignments/$assignmentId/speaking';

  // ── Calls ──
  /// 마이페이지 발음 카드 — 최근 N세션 발음 4지표 평균(`?sessions=`).
  static const callsPronunciationSummary = '/calls/pronunciation-summary';
}
