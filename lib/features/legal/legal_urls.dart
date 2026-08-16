/// 법무 고지 문서의 정본 위치.
///
/// ★ 앱은 법무 문안을 자체 보유하지 않는다. 웹(beavertalk.im)의 페이지를 그대로
///   띄운다. 예전에는 `legal_texts.dart` 에 마크다운 사본을 들고 있었는데, 웹만
///   고치고 앱을 잊는 바람에 앱이 구 주소·구 약관을 계속 노출했다(2026-08-16 정리).
///   문안을 고칠 곳은 `beavertalkweb` 저장소의 `app/src/content/legal/` 한 곳뿐이다.
///
/// 웹 라우터에 `/privacy` → `/policy` 리다이렉트가 있으므로 구 링크도 살아 있다.
library;

/// 개인정보처리방침 (한국어 정본 + 영문 토글).
const String kPrivacyPolicyUrl = 'https://www.beavertalk.im/policy';

/// 이용약관 (한국어 정본 + 영문 토글).
const String kTermsOfUseUrl = 'https://www.beavertalk.im/terms';

/// 데이터 삭제 요청 안내 — Meta 앱 심사 제출용 URL 과 동일하다.
const String kDataDeletionUrl = 'https://www.beavertalk.im/data-deletion';
