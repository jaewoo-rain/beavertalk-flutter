/// 음소(자모) → 조음 도해 자산 매핑.
///
/// 도해는 Figma `Airflow / *` 22종을 그대로 내보낸 것이다(`assets/articulatory/`).
/// 다크 카드 위에 발광 기류를 그린 그림이라 **밝은 시트 위에 얹어도** 대비가 산다.
///
/// ⛔ 자모를 파일 경로에 넣지 않는다. 한글 자모가 든 asset 경로는 플랫폼마다
///    정규화(NFC/NFD)가 갈려 iOS 에서만 조용히 못 찾는 일이 생긴다. 로마자 stem 을 쓴다.
library;

/// 한 음소의 도해 자산과, 그 음소를 사람이 읽는 이름.
class PhonemeDiagram {
  const PhonemeDiagram({
    required this.jamo,
    required this.asset,
    required this.isCoda,
  });

  /// 자모 한 글자 — 시트 라벨에 그대로 쓴다(예: 'ㄹ').
  final String jamo;

  /// `assets/articulatory/*.png` 경로.
  final String asset;

  /// 받침 자리인지. 실제 발음 도해를 고를 때 **목표와 같은 자리**를 써야 한다 —
  /// 초성판과 종성판은 기류 그림이 다르므로 자리가 어긋나면 두 컷이 비교가 안 된다.
  final bool isCoda;
}

const String _dir = 'assets/articulatory';

/// 초성 자모 → 파일 stem.
///
/// 🔴 **ㄷ·ㅂ 는 비어 있다.** Figma 도해 세트에 종성판(`ㄷ(coda)`·`ㅂ(coda)`)만 있고
///    초성판이 없다. 종성판으로 대신하지 않는다 — 초성 파열음은 터뜨리고(파열),
///    종성은 안 터뜨린다(불파). 기류 그림이 다른데 같은 그림을 보여주면 도해가
///    거짓말을 한다. 그 두 음소는 도해 없이 설명 문구만 나간다.
const Map<String, String> _onsetStem = {
  'ㄱ': 'g',
  'ㄲ': 'gg',
  'ㄴ': 'n',
  'ㄸ': 'dd',
  'ㄹ': 'r',
  'ㅁ': 'm',
  'ㅃ': 'bb',
  'ㅅ': 's',
  'ㅆ': 'ss',
  'ㅇ': 'ng',
  'ㅈ': 'j',
  'ㅉ': 'jj',
  'ㅊ': 'ch',
  'ㅋ': 'k',
  'ㅌ': 't',
  'ㅍ': 'p',
  'ㅎ': 'h',
};

/// 종성 대표음(7종중화) → 파일 stem.
///
/// ㅁ·ㅇ 은 전용 종성판이 없지만 **비음은 초성과 종성의 조음이 같다** — 입을 막고
/// 코로 내보내는 그림 하나로 족하다. 파열음(ㄱ·ㄷ·ㅂ)과 유음(ㄹ)만 종성판을 따로 쓴다.
const Map<String, String> _codaStem = {
  'ㄱ': 'g_coda',
  'ㄴ': 'n_coda',
  'ㄷ': 'd_coda',
  'ㄹ': 'r_coda',
  'ㅁ': 'm',
  'ㅂ': 'b_coda',
  'ㅇ': 'ng',
};

/// 받침 7종중화 — 표준발음법의 대표음으로 접는다.
///
/// 겹받침은 앞자모만 남기고(ㄳ→ㄱ, ㄼ→ㄹ …) 대표음으로 보낸다. g2p 를 앱에 들이지
/// 않는 이유는 도해 선택에는 이 정도면 충분하기 때문이다 — 연음·경음화까지 맞추려면
/// 서버가 음소열을 내려줘야 한다.
const Map<String, String> _codaNeutral = {
  'ㄱ': 'ㄱ', 'ㄲ': 'ㄱ', 'ㅋ': 'ㄱ', 'ㄳ': 'ㄱ', 'ㄺ': 'ㄱ',
  'ㄴ': 'ㄴ', 'ㄵ': 'ㄴ', 'ㄶ': 'ㄴ',
  'ㄷ': 'ㄷ', 'ㅅ': 'ㄷ', 'ㅆ': 'ㄷ', 'ㅈ': 'ㄷ', 'ㅊ': 'ㄷ', 'ㅌ': 'ㄷ', 'ㅎ': 'ㄷ',
  'ㄹ': 'ㄹ', 'ㄼ': 'ㄹ', 'ㄽ': 'ㄹ', 'ㄾ': 'ㄹ', 'ㅀ': 'ㄹ',
  'ㅁ': 'ㅁ', 'ㄻ': 'ㅁ',
  'ㅂ': 'ㅂ', 'ㅍ': 'ㅂ', 'ㅄ': 'ㅂ', 'ㄿ': 'ㅂ',
  'ㅇ': 'ㅇ',
};

const List<String> _onsetTable = [
  'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ',
  'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
];

const List<String> _codaTable = [
  '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ',
  'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ',
  'ㅌ', 'ㅍ', 'ㅎ',
];

/// 완성형 한글 한 글자를 (초성, 종성) 자모로 가른다. 한글이 아니면 null.
///
/// 중성(모음)은 돌려주지 않는다 — 도해 세트가 자음만 있기 때문이다.
({String onset, String coda})? splitJamo(String syllable) {
  if (syllable.isEmpty) return null;
  final code = syllable.runes.first;
  if (code < 0xAC00 || code > 0xD7A3) return null;
  final index = code - 0xAC00;
  return (
    onset: _onsetTable[index ~/ (21 * 28)],
    coda: _codaTable[index % 28],
  );
}

/// 자모 하나에 해당하는 도해. 세트에 없으면 null.
PhonemeDiagram? diagramForJamo(String jamo, {required bool isCoda}) {
  final stem = isCoda
      ? _codaStem[_codaNeutral[jamo] ?? jamo]
      : _onsetStem[jamo];
  if (stem == null) return null;
  return PhonemeDiagram(jamo: jamo, asset: '$_dir/$stem.png', isCoda: isCoda);
}

/// 한 글자에서 **도해로 보여줄 자모 하나**를 고른다.
///
/// 받침이 있으면 받침을, 없으면 초성을 쓴다. 받침을 앞세우는 이유는 한국어 학습자의
/// 발음 오류가 받침에 몰리기 때문이다 — 초성은 모국어에 대응음이 있는 경우가 많지만
/// 받침(특히 불파음·유음)은 그렇지 않다.
PhonemeDiagram? diagramForSyllable(String syllable) {
  final parts = splitJamo(syllable);
  if (parts == null) return null;
  if (parts.coda.isNotEmpty) {
    final coda = diagramForJamo(parts.coda, isCoda: true);
    if (coda != null) return coda;
  }
  return diagramForJamo(parts.onset, isCoda: false);
}
