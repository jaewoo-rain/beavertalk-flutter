/// 통화가 붙을 **통로**. 소켓 주소와 마이크 정책이 여기서 같이 갈린다.
///
/// ## 왜 런타임 값인가
///
/// 예전엔 `bool.fromEnvironment('CASCADE_BARGE_IN')` 상수 하나였다. 그러면 **한 APK 가
/// 한 통로만** 된다 — 두 통로를 같이 쓰려면 빌드를 두 벌 내야 하고, 되돌리려면 스토어
/// 심사가 낀다. 그래서 통화마다 정해지는 값으로 내렸다.
///
/// **선택 주체는 서버다**(통화 시작 응답에 실려 온다). 앱 업데이트 없이 전환·롤백하기
/// 위해서다. ⚠ 다만 서버가 아직 그 값을 줄 수 있는 상태가 아니라(캐스케이드는 통화
/// 수명주기가 없는 순수 WS 데모다), **지금은 호출부가 넘기는 값까지만** 있다. 필드
/// 계약은 캐스케이드가 통화 기록에 올라탈 때 확정된다 — 그때까지 서버 응답 필드 이름을
/// 추측해서 만들지 않는다.
///
/// ## 두 통로가 다른 점
///
/// | | [live] | [cascade] |
/// |---|---|---|
/// | 소켓 | `/calls/stream` | `/cascade/stream` |
/// | 서버 | Gemini Live 양방향 | STT→LLM→TTS |
/// | 마이크 | **반이중 게이팅** — 비버 발화 중 닫는다 | **상시 개방** — 끼어들 수 있다 |
/// | 끼어들기 판정 | 없음 | 서버(STT 활동 + 에너지·지속·전사) |
///
/// 인증 토큰은 **둘 다 같다**(Supabase access token → `verify_token`). 그래서 통로
/// 전환에 토큰 경로 변경이 따라붙지 않는다.
enum CallChannel {
  /// Gemini Live 양방향. 반이중 — 비버가 말하는 동안 마이크를 닫는다.
  live,

  /// 캐스케이드(STT→LLM→TTS). 마이크 상시 개방 + barge-in.
  ///
  /// ## ⛔ **서버가 막아 줄 것이라고 기대하지 마라**
  ///
  /// 서버는 이 라우터를 `if settings.ENV != "prod":` 안에서 마운트하고, 그 옆 주석은
  /// "운영에는 노출하지 않는다"고 적혀 있다. **그 주석이 틀렸다.**
  /// 실서비스(app-api)의 런타임 `ENV` 는 `"prod"` 가 아니라 **`"test"`** 다
  /// (`GET /health` → `{"status":"ok","env":"test"}` 로 직접 확인). 그러니 저 조건은
  /// 실서비스에서 **참**이고, 이 라우터를 막는 장치가 아니다. 서버 쪽 2차 방어는
  /// 백엔드가 따로 처리한다(다른 dev 도구들은 `CurrentAdmin` 으로 한 겹 더 막고 있고,
  /// 이 라우터에만 그게 없다).
  ///
  /// ⚠ 교훈: **주석은 1차 자료가 아니다. 런타임으로 갈리는 조건은 런타임 값을 봐야
  ///   한다.** 같은 파일 80줄 아래에 "실서비스의 ENV 는 test 라 이 블록이 실서비스에도
  ///   노출된다"가 이미 적혀 있었다.
  ///
  /// ## 이 통로를 고르기 전 확인할 것
  ///
  /// 위험은 "운영이냐"가 아니라 **AEC 가 검증됐냐**다. 마이크가 상시 열리므로, 플랫폼
  /// AEC 가 실제로 걸리지 않은 상태로 고르면 비버가 자기 목소리에 끊긴다(call_id=855
  /// 실측 전례). 그건 어느 서버에 붙든 똑같이 난다.
  cascade;

  /// 호출부가 통로를 안 정했을 때 쓰는 값.
  ///
  /// ⚠ `bool.fromEnvironment` 를 **지우지 않고 기본값 출처로 강등**했다. 지우면
  /// `flutter test --dart-define=CASCADE_BARGE_IN=true` 로 도는 플래그on 스위트가
  /// 의미를 잃는다 — 그게 지금 유일한 회귀망이다.
  ///
  /// 기본은 여전히 [live] 다. 라이브 통화 동작이 한 톨도 바뀌면 안 된다.
  static const CallChannel defaultChannel =
      bool.fromEnvironment('CASCADE_BARGE_IN') ? CallChannel.cascade : CallChannel.live;

  /// 캐스케이드 통로인가.
  bool get isCascade => this == CallChannel.cascade;

  /// 비버가 말하는 동안 마이크를 닫아야 하는가.
  ///
  /// [cascade] 는 false 다 — barge-in 은 "사용자가 아무 때나 말할 수 있다"는 뜻이고,
  /// 그러려면 마이크가 항상 열려 있어야 한다. 게이팅은 barge-in 이 없던 시절의 장치다.
  ///
  /// ⚠ 그래도 [defaultChannel] 이 [live] 인 이유: Android 플랫폼 AEC 가 아직 실측
  ///   전이라(`ANDROID_VOICE_AUDIO` 기본 꺼짐), 게이팅을 빼면 비버 목소리가 무방비로
  ///   업링크에 실린다 — 실측 전례가 있다(call_id=855, 2026-08-01: 유저 턴의 절반이
  ///   비버 대사였다).
  bool get gatesMic => this == CallChannel.live;

  /// 이 통로의 WS 경로(호스트·토큰 제외). URL 조립은 `core/network/ws_url.dart` 가 한다.
  String get wsPath => isCascade ? '/cascade/stream' : '/calls/stream';
}
