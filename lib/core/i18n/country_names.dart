import 'country_names.g.dart';

/// 억양 국적 라벨(서버 영문명) → UI 언어의 나라 이름.
///
/// 서버는 억양 결과를 **영문 나라 이름 하나**로만 준다(`speak_country.first_country` 등 —
/// 국적 분류 모델의 라벨 그대로). 그래서 마이페이지 억양 카드와 공유 문장이 모든 언어에서
/// 영어로 나왔다(QA F001 · 09-26 사용자 결정 「국적명도 UI 언어로」).
///
/// 표에 없는 라벨이나 언어면 서버 이름을 그대로 돌려준다 — 모르는 나라를 지우거나
/// 엉뚱한 이름으로 바꾸느니 영문이 낫다. 표는 `tool/gen_country_names.py` 가 CLDR 로 만든다.
String localizedCountryName(String serverLabel, String languageCode) {
  final iso = kAccentLabelIso[serverLabel];
  if (iso == null) return serverLabel;
  return kCountryNames[languageCode]?[iso] ?? serverLabel;
}
