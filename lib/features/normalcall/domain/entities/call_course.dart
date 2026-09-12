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
/// `domains/learning/realtime/protocol.py:105`
/// ```python
/// call_type: Literal["normal", "level_test", "expression", "freetalk"] | None = None
/// ```
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
