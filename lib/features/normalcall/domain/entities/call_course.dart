/// 이 통화가 **무엇을 하는 통화인가** — 서버 `start` 프레임의 `call_type` 값.
///
/// ## ⛔ [CallChannel] 과 **다른 축이다.** 섞지 마라
///
/// | | [CallChannel] | [CallCourse] |
/// |---|---|---|
/// | 정하는 것 | **어디로 붙나** — 소켓 주소·마이크 정책 | **무엇을 하나** — 수업 내용 |
/// | 와이어 | 경로(`/calls/stream` vs `/cascade/stream`) | `start` 프레임의 `call_type` 필드 |
/// | 값 | live · cascade | expression · freetalk |
///
/// 한쪽 enum 에 값을 더해 합치면 「표현학습인데 캐스케이드」 같은 **존재하지 않는
/// 조합이 표현 가능해진다.** 두 축을 따로 두면 그 상태를 타입이 막는다.
///
/// ## 서버 계약 — 새 파라미터가 아니다
///
/// `domains/learning/realtime/protocol.py:115`(서버 `origin/dev` `50d03df`)
/// ```python
/// call_type: Literal["normal", "level_test", "expression", "freetalk", "auto", "chat"] | None = None
/// ```
/// `"normal"` 은 신서버에서 죽은 값이다(보내면 `chat` 으로 흡수). 앱은 `chat` 을 보낸다.
/// **기존 `call_type` 필드에 문자열을 넣는 것이 전부다.** 소켓 경로는 그대로
/// `/calls/stream` 이다.
///
/// ⭐ 값을 **안 보내면**(null) 서버가 판단한다(D11 자동 라우팅 —
/// `member.korean_level` 미확정이면 레벨테스트). 그래서 [wireValue] 를 실을지 말지는
/// `buildStartFrame` 의 `?` 스프레드가 정한다 — null 이면 **필드 자체가 안 나간다.**
/// ⛔ 빈 문자열이나 `"normal"` 을 대신 보내지 마라. 그건 자동 라우팅을 **덮어쓴다.**
///
/// ## ⚠ 이 값은 구간을 넘어 다시 실려야 한다
///
/// 「Keep talking」 이 통화를 잇는 방식은 **소켓을 새로 여는 것**이라, `start` 프레임을
/// 다시 조립한다. 그때 값이 빠지면 2구간부터 평소 통화가 되는데 **에러가 안 난다** —
/// 이 프레임이 이미 세 번 겪은 사고다(`continues_call_id` 2026-08-24 ·
/// `inbound_call_id` 2026-08-31 · `assignment_id` 2026-09-06). 그래서
/// `NormalCallController` 는 이 값을 지역 인자가 아니라 **필드로** 들고 있는다.
enum CallCourse {
  /// 표현학습 — 18개 표현을 드릴하고 3개마다 퀴즈, 끝에 오답퀴즈.
  ///
  /// ⚠ `member.korean_level` 이 null 이어도 **돈다** — 서버가 레벨 2 로 폴백한다
  /// (`call_session.py`: `setup.get("korean_level") or 2`).
  expression,

  /// 프리토킹 — 100% 학습 언어 자유대화. 학습 항목을 주입하지 않는다.
  ///
  /// ⚠ 그 차시 표현학습이 안 끝났으면 서버가 `error{code: COURSE_LOCKED}` 뒤 1008 로
  ///   닫는다. 메시지는 `call_loading` 이 스낵바로 그대로 띄운다(`error` 프레임 경로).
  freetalk,

  /// 자유대화 — 홈 **대화 모드**(사장님 정의 2026-09-22: 「제한 없는 자유 대화」).
  ///
  /// 서버 premium 계약 §2(09-23): 한국어 위주 대화 · 학습자가 모르거나 모국어로 물으면 그
  /// 턴만 모국어로 설명 · 끝나면 서버가 대화 기억을 저장해 다음 자유대화에 넣는다.
  /// 진도 게이트가 없다(프리토킹의 `COURSE_LOCKED` 가 안 걸린다). 옛 값 `normal` 을 대체한다
  /// (09-23 · 사용자 「main이 아니라 지금 dev를 보고 진행」 — 앱이 붙는 demo-api 가 dev).
  /// ⚠ `call_started.course` 는 `expression`·`freetalk` 만 준다 — 이 코스는 돌아오지 않는다.
  /// ⛔ [auto] 대신 쓰지 마라 — 이건 사용자가 대화 모드를 **고른** 경우만이다.
  chat,

  /// **자동** — 서버가 진도(`cur_member_progress` · `cur_member_lesson.status`)로 이번
  /// 통화의 코스를 정한다. 표현학습을 다 드릴하면 다음은 프리토킹, 프리토킹 1회 뒤
  /// 다음 차시 표현학습(커리큘럼 2단계).
  ///
  /// ⭐ 이건 **요청**이지 코스가 아니다. 서버가 정한 실제 코스는 `call_started.course`
  ///   로 온다(`"expression" | "freetalk"`). 컨트롤러가 그 값으로 `CallState.course`
  ///   를 덮어쓴다 — 힌트 UI 가림·결과 화면 배지가 그 값을 본다.
  ///   ⇒ [fromWire] 로 `"auto"` 가 **돌아오는 일은 없다**(서버 Literal 에 없다).
  auto;

  /// 서버로 보내는 문자열. enum 이름과 같게 **일부러** 맞춰 뒀다 —
  /// 매핑 표를 따로 두면 값을 늘릴 때 한쪽만 고치는 사고가 난다.
  String get wireValue => name;

  /// 서버가 `call_started.course` 로 준 문자열 → 코스. 모르는 값·null 은 null.
  ///
  /// ⛔ 모르는 값을 [auto] 나 다른 것으로 **추측하지 않는다.** 서버가 어휘를 넓혔는데
  ///   앱이 모르면 null 이 되어 힌트 UI 가 다시 보인다 — 조용히 틀리는 쪽보다 낫다.
  static CallCourse? fromWire(Object? raw) {
    if (raw is! String) return null;
    final v = raw.trim().toLowerCase();
    for (final c in values) {
      if (c != auto && c.wireValue == v) return c;
    }
    return null;
  }
}

/// 코스 통화 **요청** — 라우트 인자. 코스 + QA 용 잠금 우회 플래그.
///
/// ⭐ [forceCourse] 는 코스의 속성이 아니라 **개발자 도구 버튼의 속성**이다. 그래서
///   [CallCourse] 에 값을 더하지 않고 요청 객체로 감싼다 — 「프리토킹이면 무조건 우회」로
///   묶어 두면 나중에 제품 진입점이 프리토킹을 걸 때도 우회가 따라간다.
///
/// 서버 계약(`ClientStart.force_course: bool = False`, expr-build 작업 중): admin 계정만
/// `COURSE_LOCKED` 를 우회하고 진도는 바꾸지 않는다. user 계정이면 서버가 무시하고
/// 지금처럼 `COURSE_LOCKED` 스낵바다. ⚠ 배포 전 서버는 `extra=ignore` 라 이 키를 조용히
/// 버린다(protocol.py:192) — 보내도 422 가 나지 않는다.
///
/// `call_loading` 은 인자가 이것이든 맨 [CallCourse] 든 둘 다 받는다.
class CourseCallRequest {
  /// 요청을 만든다. [forceCourse] 기본 false · [planOverride] 기본 null = 둘 다
  /// 프레임에서 빠진다.
  const CourseCallRequest(
    this.course, {
    this.forceCourse = false,
    this.planOverride,
  });

  /// 걸 코스.
  final CallCourse course;

  /// 잠금 우회(QA). true 일 때만 `start.force_course: true` 가 실린다.
  final bool forceCourse;

  /// 이 통화만 다른 플랜의 엔진으로(QA). null 이면 키가 빠진다. [PlanOverride] 참조.
  final PlanOverride? planOverride;
}

/// `start.plan_override` — **구독과 무관하게 이 통화만** 그 플랜의 엔진으로 연다(QA).
///
/// 서버 계약(`premium` 브랜치 09-23, `ClientStart.plan_override: Literal["free","premium"]`):
/// admin 계정만 유효, user 는 무시. Premium = 영상·표정, Free = 음성.
/// ⛔ 옛 값 `pro`·`max` 를 보내면 신서버는 start 프레임을 검증에서 통째로 버린다 — 에러도
///   없이 통화가 안 열리고 타임아웃된다. 구서버는 `extra=ignore` 라 모르는 값을 조용히 버린다.
///
/// ⭐ [CallCourse]·[forceCourse] 와 같은 규율 — 2구간 재연결에도 **같은 값을 다시 싣는다**
///   (컨트롤러 필드 `_planOverride`). 안 그러면 「Keep talking」 뒤 엔진이 구독 플랜으로
///   되돌아가 QA 가 반쪽이 된다.
enum PlanOverride {
  free,
  premium;

  /// 서버로 보내는 문자열. enum 이름과 같게 맞춰 뒀다.
  String get wireValue => name;
}
