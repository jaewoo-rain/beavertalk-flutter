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
  freetalk;

  /// 서버로 보내는 문자열. enum 이름과 같게 **일부러** 맞춰 뒀다 —
  /// 매핑 표를 따로 두면 값을 늘릴 때 한쪽만 고치는 사고가 난다.
  String get wireValue => name;
}
