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
