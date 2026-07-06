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
