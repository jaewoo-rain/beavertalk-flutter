/// 결제 내역 라벨 현지화(서버 R4 · 2026-10-16 PM-DEC-674).
///
/// 서버 `payment.description` 은 한국어 라벨 + 꼬리다(`iap_service._PAYMENT_LABEL`):
/// 「구독 결제」 · 「구독 결제 · bt_max_monthly」 · 「캐릭터 구매: Popo」 · 「캐릭터 묶음 구매 · bt_character_bundle」.
/// 서버는 이 값을 바꾸지 않는다(과거 행 그대로). 앱이 앞의 한국어 라벨만 회원 언어로 갈아 끼우고,
/// 꼬리(상품 ID·캐릭터 이름 — 고유명)는 그대로 둔다. 모르는 형식이면 null → 화면이 원문을 보인다.
library;

/// 서버 라벨 원문 → 현지화 라벨. 긴 것부터 맞춘다(「캐릭터 묶음 구매」가 「캐릭터 구매」보다 먼저).
String? localizedPaymentLabel(
  String? description, {
  required String subscription,
  required String character,
  required String bundle,
}) {
  final d = description?.trim();
  if (d == null || d.isEmpty) return null;
  for (final (ko, label) in [
    ('캐릭터 묶음 구매', bundle),
    ('캐릭터 구매', character),
    ('구독 결제', subscription),
  ]) {
    if (d == ko) return label;
    if (d.startsWith('$ko · ') || d.startsWith('$ko: ')) {
      return label + d.substring(ko.length);
    }
  }
  return null;
}
