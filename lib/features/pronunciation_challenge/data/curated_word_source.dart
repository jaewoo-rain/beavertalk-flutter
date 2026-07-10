import 'dart:math';

/// A word drawn from the shuffle bag: the Korean word plus its palette index.
class DrawnWord {
  /// Creates a drawn word.
  const DrawnWord(this.word, this.colorIndex);

  /// Korean word to pronounce.
  final String word;

  /// Index into the card-colour palette.
  final int colorIndex;
}

/// Supplies clean beginner Korean nouns via a shuffle bag (avoids clustering).
///
/// The word list is the web game's `WORDS` (lines 204–211) **minus** its five
/// profanities (씨발 · 병신 · 바보 · 멍청이 · 개새끼), topped up with common
/// beginner nouns so the pool stays varied. Colour assignment mirrors the web
/// game: `colorIndex = wordIndex % paletteSize` (line 270).
class CuratedWordSource {
  /// Creates a source. Pass a seeded [random] for deterministic tests.
  CuratedWordSource({Random? random}) : _random = random ?? Random();

  final Random _random;
  final List<int> _bag = <int>[];

  /// Number of colours in the card palette (see the painter's `cardColors`).
  static const int paletteSize = 6;

  /// Curated beginner Korean nouns (profanities removed, beginner set added).
  static const List<String> words = <String>[
    // ── web game WORDS (clean subset) ──
    '가방', '야구', '어머니', '여자', '오리', '요리', '우산', '우유',
    '그림', '기차', '개', '얘기', '게', '시계', '사과', '돼지',
    '회사', '원숭이', '스웨터', '가위', '의자', '나무', '다리', '라면',
    '머리', '바다', '사람', '아이', '주스', '책', '코', '토마토',
    '포도', '하늘', '까치', '딸기', '빵', '쌀', '가짜',
    // ── beginner top-up ──
    '학교', '친구', '사랑', '커피', '지하철', '병원', '음악', '시간',
    '가족', '선생님',
  ];

  /// Draws the next word, refilling and reshuffling the bag when empty.
  ///
  /// Port of `drawBag()` (web game lines 267–271).
  DrawnWord draw() {
    if (_bag.isEmpty) {
      _bag.addAll(List<int>.generate(words.length, (i) => i));
      // Fisher–Yates shuffle.
      for (var i = _bag.length - 1; i > 0; i--) {
        final j = _random.nextInt(i + 1);
        final tmp = _bag[i];
        _bag[i] = _bag[j];
        _bag[j] = tmp;
      }
    }
    final idx = _bag.removeLast();
    return DrawnWord(words[idx], idx % paletteSize);
  }

  /// Empties the bag (called on a fresh game so words re-shuffle).
  void reset() => _bag.clear();
}
