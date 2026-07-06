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
