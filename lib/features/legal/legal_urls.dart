/// 법무 고지 문서의 정본 위치 (Notion 공개 페이지).
///
/// ★ 앱은 법무 문안을 자체 보유하지 않는다. 예전에는 `legal_texts.dart` 에 마크다운
///   사본을 들고 있었는데, 웹만 고치고 앱을 잊는 바람에 앱이 구 주소·구 약관을
///   계속 노출했다(2026-08-16 정리). 정본은 노션 「비버톡 > 법적 고지」 한 곳이며
///   웹과 앱이 같은 페이지를 본다.
///
/// ★★ **약관은 웹판과 앱판이 다르다.** 앱에는 인앱결제·구독·환불 조항이 있고
///    웹판에는 없다. 여기서는 반드시 **앱판**을 가리켜야 한다 —
///    `beavertalk.im/terms` 는 웹판으로 리다이렉트되므로 쓰면 안 된다.
///
/// 처리방침과 데이터 삭제 안내는 웹·앱 공통이라 같은 문서를 쓴다.
library;

const String _notion = 'https://bronzed-eocursor-e88.notion.site';

/// 개인정보처리방침 — 웹·앱 공통(사업자 단위 문서).
const String kPrivacyPolicyUrl = '$_notion/3bea58100489810a9bc8d84fd6341c06';

/// 이용약관 (앱) — 인앱결제·구독·환불 포함. 웹판을 쓰지 마라.
const String kTermsOfUseUrl = '$_notion/3bea58100489817497eac16e89c55746';

/// 데이터 삭제 요청 안내 — Meta 앱 심사 제출용 URL 과 동일하다.
const String kDataDeletionUrl = '$_notion/3bea5810048981c6a5c6d6176b0badbb';
