/// 학습 문장 두 줄 접기 — 웹 `layoutWord` 의 **접는 자리** 부분.
///
/// 판정 지점 글자 크기로 잰 폭이 판정 구역([GameConfig.wordMaxW])을 넘는 문장은 두 줄로 접고
/// [GameConfig.longWordScale] 로 줄인다. 폭을 재는 건 글꼴이 필요해 그리는 쪽(painter)이 하고,
/// 여기서는 **어디서 자르나**만 정한다 — 순수 함수라 시험할 수 있다.
///
/// 웹은 단어마다 수동 `br` 을 들고 있지만(잰말놀이), 앱의 학습 문장은 통화에서 와서 미리 정할 수
/// 없다. 그래서 규칙으로 정한다(09-26 요청서 §4.6):
/// - 글자 수 가운데에 가장 가까운 **띄어쓰기**에서 자른다(그 띄어쓰기는 버린다). 같은 거리면 앞쪽
/// - 띄어쓰기가 없으면 글자 수 절반(올림)에서 자른다
/// - 세 줄 이상은 만들지 않는다
library;

/// [text] 를 두 줄로 나눈다. 한 글자 이하면 나눌 수 없어 `null`.
///
/// 예: 「저는 선생님이에요」 → (「저는」, 「선생님이에요」).
(String, String)? splitInTwoLines(String text) {
  final chars = text.trim().runes.toList();
  if (chars.length < 2) return null;
  const space = 0x20;
  final mid = chars.length / 2;
  int? best;
  for (var i = 0; i < chars.length; i++) {
    if (chars[i] != space) continue;
    if (best == null || (i - mid).abs() < (best - mid).abs()) best = i;
  }
  final String head;
  final String tail;
  if (best != null) {
    head = String.fromCharCodes(chars.sublist(0, best)).trim();
    tail = String.fromCharCodes(chars.sublist(best + 1)).trim();
  } else {
    final cut = (chars.length / 2).ceil();
    head = String.fromCharCodes(chars.sublist(0, cut));
    tail = String.fromCharCodes(chars.sublist(cut));
  }
  if (head.isEmpty || tail.isEmpty) return null;
  return (head, tail);
}
