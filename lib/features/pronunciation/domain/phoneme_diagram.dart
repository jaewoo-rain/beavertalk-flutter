/// 음소(자모) → 조음 도해 자산 매핑.
///
/// 도해는 **움직인다.** `assets/articulatory/` 82종은 재디자인 폴더
/// `05_영상` 의 MP4 68종을 애니메이션 WebP 로 구운 것이다(440px · 12.5fps ·
/// q50 · 7.3MB). 다크 카드 위에 발광 기류를 그린 그림이라 밝은 시트 위에
/// 얹어도 대비가 산다.
///
/// ⛔ **MP4 + `video_player` 로 되돌리지 마라.** 시트는 학습 결과 화면 위에
///    뜨는데 그 뒤에서 아바타가 이미 하드웨어 디코더를 잡고 있다(idle·talk·emo).
///    두 컷이면 디코더가 2개 더 필요하고, 2026-08-30 에 정확히 그 한계로 감정
///    클립이 한 번도 안 뜬 적이 있다. WebP 는 `Image.asset` 이 그리므로 디코더를
///    쓰지 않고, 컨트롤러 수명주기도 없다.
///
/// 자산 82종 = 자모 이름 기준이고, 원본 영상은 68종이다. Airflow 는 조음 위치당
/// 그림 한 장이라 여러 자모가 **같은 파일 내용**을 공유한다(ㄱ·ㄲ·ㅋ·ㄱ받침 등).
/// 이름을 나눠 둔 것은 나중에 그림이 갈릴 여지를 남기기 위해서다.
///
/// `sy_*` 5종과 `vw_*_hold` 10종은 **매핑이 없다** — 띄울 신호가 없어서다.
/// hold 는 「자세를 유지하라」는 뜻이라 지속 구간 신호가 있어야 하는데
/// `phoneme_misses` 는 자모 치환만 담고, `sy_*`(모음 삽입 = 음절 수 증가)도 같다.
/// 다만 자산은 10종을 통째로 받아 뒀다 — 예전엔 재설계 이전 판 3종만 있어 세트가
/// 반쪽이었다.
///
/// ⛔ 자모를 파일 경로에 넣지 않는다. 한글 자모가 든 asset 경로는 플랫폼마다
///    정규화(NFC/NFD)가 갈려 iOS 에서만 조용히 못 찾는다. 로마자 stem 을 쓴다.
///
/// ★ **계열을 잘못 고르면 도해가 아무것도 설명하지 못한다.** 실측: Airflow 도해로
///   ㄱ·ㄲ·ㅋ 을 비교하면 다른 픽셀이 **0.00~0.02%** 다 — 기류 경로가 같으니 당연하다.
///   같은 쌍을 Phonation(휴지 테스트) 도해로 보면 **3.00~10.7%** 로 갈린다.
///   그래서 [diagramPair] 가 오류 종류를 보고 계열을 고른다.
library;

/// 도해 계열 — 무엇을 보여주는 그림인가.
enum DiagramSeries {
  /// 기류가 어디로 흐르나. 조음 **방법**이 다를 때(ㄹ↔ㄴ).
  airflow,

  /// 어디서 막히나. 방법은 같고 조음 **위치**가 다를 때(ㄴ↔ㅇ).
  place,

  /// 정면 입 + 혀. 모음 오류.
  vowel,

  /// 휴지 테스트 — 평음·경음·격음. **긴장도**만 다를 때(ㄱ↔ㅋ).
  phonation,

  /// 입 모양 박자. 음절 구조가 깨졌을 때. 자모 쌍만으로는 못 고른다.
  syllable,
}

/// 한 음소의 도해 자산과, 그 음소를 사람이 읽는 이름.
class PhonemeDiagram {
  /// Creates one diagram reference.
  const PhonemeDiagram({
    required this.jamo,
    required this.asset,
    required this.isCoda,
    required this.series,
  });

  /// 자모 한 글자 — 시트 라벨에 그대로 쓴다(예: 'ㄹ').
  final String jamo;

  /// `assets/articulatory/*.webp` 경로 — 애니메이션 WebP 다.
  final String asset;

  /// 받침 자리인지. 실제 발음 도해를 고를 때 **목표와 같은 자리**를 써야 한다 —
  /// 초성판과 종성판은 기류 그림이 다르므로 자리가 어긋나면 두 컷이 비교가 안 된다.
  final bool isCoda;

  /// 어느 계열의 그림인지. 두 컷은 **반드시 같은 계열**이어야 비교가 된다.
  final DiagramSeries series;
}

const String _dir = 'assets/articulatory';

// ── Airflow (조음 방법) ─────────────────────────────────────────────────────

/// 초성 자모 → Airflow stem. 자음 19종 전부 있다.
///
/// ★ Airflow 는 **조음 위치당 그림 한 장**이다. 긴장도(평·경·격)도, 초성·종성
///   자리도 구분하지 않는다. 실측 — 같은 위치끼리는 최대 채널차가 1~14/255 라
///   사람 눈에 같은 그림이고(ㄸ↔ㅌ 11 · ㄷ초성↔ㄷ종성 3 · ㅁ↔ㅁ종성 3),
///   위치가 다르면 221 이다. 그래서 긴장도 대립은 [DiagramSeries.phonation],
///   위치 대립은 [DiagramSeries.place] 로 갈라야 비교가 성립한다.
const Map<String, String> _airflowOnset = {
  'ㄱ': 'g', 'ㄲ': 'gg', 'ㄴ': 'n', 'ㄷ': 'd', 'ㄸ': 'dd', 'ㄹ': 'r',
  'ㅁ': 'm', 'ㅂ': 'b', 'ㅃ': 'bb', 'ㅅ': 's', 'ㅆ': 'ss', 'ㅇ': 'ng',
  'ㅈ': 'j', 'ㅉ': 'jj', 'ㅊ': 'ch', 'ㅋ': 'k', 'ㅌ': 't', 'ㅍ': 'p',
  'ㅎ': 'h',
};

/// 종성 대표음(7종중화) → Airflow stem.
///
/// ㅁ·ㅇ 은 초성판을 그대로 쓴다. 세트에 `ㅁ(coda)`·`ㅇ(coda)` 카드가 따로 있지만
/// 반출해 대조하니 초성판과 최대 채널차 3·13 — **같은 그림**이라 파일을 늘릴 이유가
/// 없다. 비음은 초성과 종성의 조음이 같으므로 원래 그렇게 설계된 것이다.
const Map<String, String> _airflowCoda = {
  'ㄱ': 'g_coda', 'ㄴ': 'n_coda', 'ㄷ': 'd_coda',
  'ㄹ': 'r_coda', 'ㅁ': 'm', 'ㅂ': 'b_coda', 'ㅇ': 'ng',
};

// ── Phonation (긴장도) ──────────────────────────────────────────────────────

/// 자모 → Phonation stem. 평·경·격 14종 전부 있다.
const Map<String, String> _phonationStem = {
  'ㄱ': 'ph_g', 'ㄲ': 'ph_gg', 'ㅋ': 'ph_k',
  'ㄷ': 'ph_d', 'ㄸ': 'ph_dd', 'ㅌ': 'ph_t',
  'ㅂ': 'ph_b', 'ㅃ': 'ph_bb', 'ㅍ': 'ph_p',
  'ㅅ': 'ph_s', 'ㅆ': 'ph_ss',
  'ㅈ': 'ph_j', 'ㅉ': 'ph_jj', 'ㅊ': 'ph_ch',
};

/// 긴장도 대립군 — 같은 군 안에서 틀렸으면 **Phonation** 으로 보여준다.
const List<Set<String>> _tensionFamilies = [
  {'ㄱ', 'ㄲ', 'ㅋ'},
  {'ㄷ', 'ㄸ', 'ㅌ'},
  {'ㅂ', 'ㅃ', 'ㅍ'},
  {'ㅅ', 'ㅆ'},
  {'ㅈ', 'ㅉ', 'ㅊ'},
];

// ── Place (조음 위치) ───────────────────────────────────────────────────────

/// 자모 → Place stem. 위치가 같은 자모들이 한 그림을 공유한다. 위치 5종 전부 있다.
///
/// ㅎ(성문)은 표시점이 목 끝에 찍혀 카드가 잘라내던 자리라 뒤늦게 들어왔다.
/// ㅅ·ㅆ(치경)과 ㅎ(성문)이 얽히는 마찰음 위치 오류가 이 그림으로 갈린다.
const Map<String, String> _placeOnset = {
  'ㄱ': 'pl_g', 'ㄲ': 'pl_g', 'ㅋ': 'pl_g',
  'ㄴ': 'pl_n', 'ㄷ': 'pl_n', 'ㄸ': 'pl_n', 'ㅌ': 'pl_n',
  'ㅅ': 'pl_n', 'ㅆ': 'pl_n',
  'ㄹ': 'pl_r',
  'ㅁ': 'pl_mb', 'ㅂ': 'pl_mb', 'ㅃ': 'pl_mb', 'ㅍ': 'pl_mb',
  'ㅈ': 'pl_jchjj', 'ㅉ': 'pl_jchjj', 'ㅊ': 'pl_jchjj',
  'ㅎ': 'pl_h',
};

const Map<String, String> _placeCoda = {
  'ㄴ': 'pl_n_coda',
  'ㅇ': 'pl_ng_coda',
};

/// 조음 방법 — 같은 방법인데 위치가 다르면 Place 로 보여준다.
const Map<String, String> _manner = {
  'ㄱ': 'stop', 'ㄲ': 'stop', 'ㅋ': 'stop',
  'ㄷ': 'stop', 'ㄸ': 'stop', 'ㅌ': 'stop',
  'ㅂ': 'stop', 'ㅃ': 'stop', 'ㅍ': 'stop',
  'ㅅ': 'fricative', 'ㅆ': 'fricative', 'ㅎ': 'fricative',
  'ㅈ': 'affricate', 'ㅉ': 'affricate', 'ㅊ': 'affricate',
  'ㄴ': 'nasal', 'ㅁ': 'nasal', 'ㅇ': 'nasal',
  'ㄹ': 'liquid',
};

// ── Vowel ───────────────────────────────────────────────────────────────────

const Map<String, String> _vowelStem = {
  'ㅏ': 'vw_a', 'ㅐ': 'vw_ae', 'ㅑ': 'vw_ya', 'ㅒ': 'vw_yae',
  'ㅓ': 'vw_eo', 'ㅔ': 'vw_e', 'ㅕ': 'vw_yeo', 'ㅖ': 'vw_ye',
  'ㅗ': 'vw_o', 'ㅘ': 'vw_wa', 'ㅙ': 'vw_wae', 'ㅚ': 'vw_oe', 'ㅛ': 'vw_yo',
  'ㅜ': 'vw_u', 'ㅝ': 'vw_wo', 'ㅞ': 'vw_we', 'ㅟ': 'vw_wi', 'ㅠ': 'vw_yu',
  'ㅡ': 'vw_eu', 'ㅢ': 'vw_ui', 'ㅣ': 'vw_i',
};

// ── 한글 분해 ───────────────────────────────────────────────────────────────

/// 받침 7종중화 — 표준발음법의 대표음으로 접는다.
///
/// 겹받침은 대표음으로 보낸다. g2p 를 앱에 들이지 않는 이유는 도해 선택에는 이
/// 정도면 충분하기 때문이다 — 연음·경음화까지 맞추려면 서버가 음소열을 내려줘야 한다.
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

const List<String> _vowelTable = [
  'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ',
  'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
];

const List<String> _codaTable = [
  '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ',
  'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ',
  'ㅌ', 'ㅍ', 'ㅎ',
];

/// 완성형 한글 한 글자를 자모로 가른다. 한글이 아니면 null.
({String onset, String vowel, String coda})? splitJamo(String syllable) {
  if (syllable.isEmpty) return null;
  final code = syllable.runes.first;
  if (code < 0xAC00 || code > 0xD7A3) return null;
  final index = code - 0xAC00;
  return (
    onset: _onsetTable[index ~/ (21 * 28)],
    vowel: _vowelTable[(index ~/ 28) % 21],
    coda: _codaTable[index % 28],
  );
}

// ── 조회 ────────────────────────────────────────────────────────────────────

String? _stemFor(String jamo, DiagramSeries series, bool isCoda) {
  switch (series) {
    case DiagramSeries.airflow:
      return isCoda
          ? _airflowCoda[_codaNeutral[jamo] ?? jamo]
          : _airflowOnset[jamo];
    case DiagramSeries.phonation:
      return _phonationStem[jamo];
    case DiagramSeries.place:
      return isCoda
          ? _placeCoda[_codaNeutral[jamo] ?? jamo]
          : _placeOnset[jamo];
    case DiagramSeries.vowel:
      return _vowelStem[jamo];
    case DiagramSeries.syllable:
      return null; // 자모 하나로는 못 고른다 — [DiagramSeries.syllable] 주석 참조.
  }
}

/// 자모 하나를 [series] 계열의 도해로. 세트에 없으면 null.
PhonemeDiagram? diagramForJamo(
  String jamo, {
  required bool isCoda,
  DiagramSeries series = DiagramSeries.airflow,
}) {
  final stem = _stemFor(jamo, series, isCoda);
  if (stem == null) return null;
  return PhonemeDiagram(
    jamo: jamo,
    asset: '$_dir/$stem.webp',
    isCoda: isCoda,
    series: series,
  );
}

/// 한 글자에서 **도해로 보여줄 자모 하나**를 고른다(실제 발음을 모를 때).
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

bool _sameTensionFamily(String a, String b) =>
    _tensionFamilies.any((f) => f.contains(a) && f.contains(b));

/// 목표와 실제를 받아 **계열을 고르고** 두 컷을 만든다.
///
/// 계열 선택 규칙 — 위에서부터 먼저 맞는 것을 쓴다.
///
/// 1. 둘 다 모음 → [DiagramSeries.vowel]
/// 2. 같은 긴장도 대립군(ㄱ·ㄲ·ㅋ 등) → [DiagramSeries.phonation]
///    ★ 이걸 Airflow 로 그리면 **같은 그림 두 장**이 나온다(실측 0.00~0.02%).
/// 3. 조음 방법이 같고 위치가 다름 → [DiagramSeries.place]
/// 4. 그 외 → [DiagramSeries.airflow]
///
/// 고른 계열에 둘 중 하나라도 그림이 없으면 다음 계열로 내려가고, 끝까지 못 맞추면
/// **목표 한 컷만** 돌려준다. 계열이 섞인 두 컷은 비교가 아니므로 섞지 않는다.
({PhonemeDiagram? target, PhonemeDiagram? current}) diagramPair(
  String expected,
  String? actual, {
  required bool isCoda,
}) {
  final expectedIsVowel = _vowelStem.containsKey(expected);
  final fallbackSeries =
      expectedIsVowel ? DiagramSeries.vowel : DiagramSeries.airflow;

  if (actual == null || actual.isEmpty || actual == expected) {
    return (
      target: diagramForJamo(expected, isCoda: isCoda, series: fallbackSeries),
      current: null,
    );
  }

  final order = <DiagramSeries>[];
  if (expectedIsVowel && _vowelStem.containsKey(actual)) {
    order.add(DiagramSeries.vowel);
  } else {
    if (_sameTensionFamily(expected, actual)) {
      order.add(DiagramSeries.phonation);
    }
    final mannerExpected = _manner[expected];
    if (mannerExpected != null && mannerExpected == _manner[actual]) {
      order.add(DiagramSeries.place);
    }
    order.add(DiagramSeries.airflow);
  }

  for (final series in order) {
    final target = diagramForJamo(expected, isCoda: isCoda, series: series);
    final current = diagramForJamo(actual, isCoda: isCoda, series: series);
    if (target != null && current != null) {
      return (target: target, current: current);
    }
  }
  return (
    target: diagramForJamo(expected, isCoda: isCoda, series: fallbackSeries),
    current: null,
  );
}
