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

import 'package:flutter/foundation.dart';

const String _notion = 'https://bronzed-eocursor-e88.notion.site';

/// 개인정보처리방침 — 웹·앱 공통(사업자 단위 문서).
const String kPrivacyPolicyUrl = '$_notion/3bea58100489810a9bc8d84fd6341c06';

/// 이용약관 (앱) — 인앱결제·구독·환불 포함. 웹판을 쓰지 마라.
const String kTermsOfUseUrl = '$_notion/3bea58100489817497eac16e89c55746';

/// 데이터 삭제 요청 안내 — Meta 앱 심사 제출용 URL 과 동일하다.
const String kDataDeletionUrl = '$_notion/3bea5810048981c6a5c6d6176b0badbb';

// ── 영문판(QA F018 · 09-26 사용자 결정 A) ─────────────────────────────────────
//
// 위 두 문서는 한국어 전용이라 외국어 UI 회원이 약관을 못 읽었다. 노션에 영문판을 만들고
// 앱은 UI 언어로 고른다 — 한국어는 한국어판, **그 밖의 모든 언어는 영문판**.
// 영문판은 노션 「비버톡 > 법적 고지」 하위에 있다(09-26 공개 · 대조표
// `02_노션_하네스/_output/2026-09-26_법적고지영문판/01_URL표.md` — 조항 수 한국어판과 같음).
// 비워 두면 한국어판으로 폴백한다(빈 화면보다 낫다).
// ★★ 약관 영문판도 반드시 **앱판**(인앱결제·구독·환불 포함 · 26조)이어야 한다.
// 데이터 삭제 영문판(`…18194d7d92e417159c5`)은 앱이 띄우지 않아 두지 않는다.

/// 이용약관 (앱) 영문판 — 26조. 비면 [kTermsOfUseUrl] 로 폴백.
const String _termsOfUseUrlEn = '$_notion/3e7a581004898116b428d4ce14473638';

/// 개인정보처리방침 영문판 — v2.1 · 16조. 비면 [kPrivacyPolicyUrl] 로 폴백.
const String _privacyPolicyUrlEn = '$_notion/3e7a581004898130a587cdb1c5b90b73';

/// UI 언어 [languageCode] 로 볼 이용약관(앱판).
String termsOfUseUrlFor(String languageCode) =>
    pickLegalUrl(languageCode, ko: kTermsOfUseUrl, en: _termsOfUseUrlEn);

/// UI 언어 [languageCode] 로 볼 개인정보처리방침.
String privacyPolicyUrlFor(String languageCode) =>
    pickLegalUrl(languageCode, ko: kPrivacyPolicyUrl, en: _privacyPolicyUrlEn);

/// 한국어면 [ko], 아니면 [en] — [en] 이 아직 비었으면 [ko].
@visibleForTesting
String pickLegalUrl(String languageCode,
        {required String ko, required String en}) =>
    languageCode == 'ko' || en.isEmpty ? ko : en;

// ── 문의 ──────────────────────────────────────────────────────────────────

/// 공식 문의 메일(설정 「Contact Us」 · QA F012/F021). 웹 문의 링크와 같은 주소다
/// (`beavertalkweb/app/src/site/paths.ts` `inquiry` · 사업자 정보 푸터 `content/nav.ts`).
const String kContactEmail = 'contact@beavertalk.im';

/// 문의 메일 작성 주소 — 제목에 설치 빌드([version], 예 `v1.0.0 (43)`)를 싣는다.
///
/// `Uri.queryParameters` 는 공백을 `+` 로 바꿔 메일 앱 제목에 `+` 가 그대로 찍힌다 —
/// 제목은 직접 인코딩한다.
Uri contactMailUri({String? version}) {
  final subject = version == null ? '[BeaverTalk]' : '[BeaverTalk] $version';
  return Uri(
    scheme: 'mailto',
    path: kContactEmail,
    query: 'subject=${Uri.encodeComponent(subject)}',
  );
}
