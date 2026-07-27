/// 앱 전역 기능 스위치(피처 플래그) 모음.
///
/// 컴파일 타임 상수라 `false`로 두면 관련 코드 경로가 트리 셰이킹으로 빠진다.
library;

/// 인바운드 콜(비버가 거는 전화) 기능 스위치.
///
/// 현재는 '로컬 트리거' 단계다(FCM/VoIP/서버 발송 없음 — 앱 안에서
/// `simulateIncomingCall`로만 수신 화면을 띄운다). 나중에 밖에서 깨우는 푸시
/// (Android FCM / iOS APNs VoIP)만 붙이면 동일한 수신/accept 흐름을 재사용한다.
///
/// 모든 초기화/이벤트 attach 지점은 `kInboundCallEnabled && !kIsWeb`일 때만 동작해야
/// 한다(웹·기능 OFF 시 완전 no-op).
const bool kInboundCallEnabled = true;

/// FCM 토큰을 서버 `POST /devices`에 자동 등록할지 여부.
///
/// 배선(datasource/repository/controller)은 미리 다 되어 있고, 로그인/토큰갱신 시
/// 자동으로 `POST /devices`에 등록한다. 서버 `/devices`가 아직 없으면 404가 나지만
/// try/catch로 삼켜 앱에 무해하며(디버그 로그 `[devices] 등록 실패(무시)`), 서버가
/// 배포되는 순간 코드 변경 없이 자동 연동된다. `kInboundCallEnabled`의 하위 스위치.
const bool kDeviceRegistrationEnabled = true;

/// 로컬 스케줄러(`InboundCallScheduler`)가 알람 시각에 **직접 수신 화면을 띄울지** 여부.
///
/// **현재 false — 수신 트리거를 FCM으로 일원화했다(재우님 결정).**
/// 알람 하나에 로컬 스케줄러와 서버 FCM이 각자 전화를 띄워 **약 1.6초 간격으로 두 번**
/// 울렸고, 두 번째 수신 화면이 첫 화면을 덮는 문제가 있었다. 두 경로 중 앱 종료 상태까지
/// 커버하는 쪽은 FCM뿐이라 로컬 발사를 끄는 방향으로 정리했다.
///
/// 트레이드오프(알고 끄는 것):
/// - 오프라인/푸시 미도달 시 대체 발사 경로가 없다(로컬 예약 알림도 미구현).
/// - **iOS는 현재 미커버** — `DeviceRegistrationController`가 Android에서만 토큰을
///   등록해 서버가 iOS로 보낼 주소가 없다. 추후 APNs VoIP로 별도 처리 예정.
///
/// 되돌리려면 이 값을 true로 바꾸면 된다(스케줄러 코드는 그대로 살아 있다). 단, 서버
/// FCM 발송이 계속 살아 있으면 중복 링이 다시 생긴다.
const bool kLocalAlarmRingEnabled = false;
