/// 스토어 심사 빌드 전용 스위치(`--dart-define`).
///
/// 2026-10-06 사용자: 「심사 올릴 때 학습 언어를 '한국어' 외에 다른 언어는 빼야해.」 ·
/// 「부스 전시할 때는 다른 언어도 넣긴 할거야.」(PM-DEC-409·410)
///
/// 기본값(false)은 부스용 다국어다. 스토어(App Store · Play) 제출 빌드만
/// `--dart-define=STORE_KO_ONLY=true` 로 켠다.
library;

/// true 면 설정의 「학습 언어」 선택지가 한국어 하나뿐이다.
const bool kStoreKoOnly = bool.fromEnvironment('STORE_KO_ONLY');

/// 시험에서 [kStoreKoOnly] 를 덮는 값(컴파일 상수는 시험에서 바꿀 수 없다). 앱은 쓰지 않는다.
bool? debugStoreKoOnlyOverride;

/// 실제로 쓸 값 — 시험 덮기가 있으면 그것, 없으면 빌드 플래그.
bool get storeKoOnly => debugStoreKoOnlyOverride ?? kStoreKoOnly;

/// 결제·구독 기능 스위치(`--dart-define=PAYMENTS_ENABLED=false`).
///
/// 2026-10-16 사용자: 「결제나 구독에 대한 기능을 우선은 빼고, 심사를 올리고, 심사 승인 이후에 월 구독과
/// 캐릭터 인앱결제를 업데이트 하는 방향으로 하려고 해」(PM-DEC-706 · T-20261016-07).
///
/// 기본값(true)은 지금과 같다. 결제 없는 1.0 심사 빌드만 false 로 굽는다 — 결제 코드는 지우지 않고 진입점만 닫는다.
/// false 면: 결제 라우트 빌더 없음 · 설정 「결제」 구획 없음 · 통화 시트에 구독 유도 없음 · 유료 캐릭터 숨김 ·
/// 스토어 SDK 를 만들지 않음(시작 시 IAP · 윈백 · 복원). 무료 한도·이미 산 캐릭터 권한은 서버 그대로.
const bool kPaymentsEnabled = bool.fromEnvironment('PAYMENTS_ENABLED', defaultValue: true);

/// 시험에서 [kPaymentsEnabled] 를 덮는 값. 앱은 쓰지 않는다. 라우트 표는 컴파일 상수를 직접 본다(트리셰이킹).
bool? debugPaymentsEnabledOverride;

/// 실제로 쓸 값 — 시험 덮기가 있으면 그것, 없으면 빌드 플래그.
bool get paymentsEnabled => debugPaymentsEnabledOverride ?? kPaymentsEnabled;
