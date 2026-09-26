/// Word-matching helpers, ported from the web game (`norm`, `lev`, `wordMatch`,
/// `segmentByVocab`).
///
/// Kept pure so the same normalization backs the speech-token path and the unit
/// tests. Matching is deliberately tolerant: recognizers almost never hand back
/// an isolated noun in dictionary form, so exact-only matching clears almost
/// nothing. See [wordMatch] for the tiers and [segmentByVocab] for run-on
/// speech.
library;

/// Matches everything that is NOT a digit, ASCII letter, or Hangul syllable —
/// i.e. the characters stripped by [norm] (web game line 252).
final RegExp _stripPattern = RegExp('[^0-9a-z가-힣]');

/// Normalizes [s]: lower-cases and strips anything outside `[0-9a-z가-힣]`.
///
/// Port of the web game `norm()` (line 252).
String norm(String? s) =>
    (s ?? '').toLowerCase().replaceAll(_stripPattern, '');

/// Whether a spoken/normalized token [tok] matches [target] (a card word).
///
/// Port of the web game `wordMatch()` (`pronunciation-challenge.html`
/// lines 264–272). Speech recognition rarely returns an isolated noun exactly
/// as its dictionary form, so exact-only matching leaves most cards uncleared.
/// Three tiers, in order:
///  1. exact normalized equality;
///  2. **particle-attached** — [tok] starts with [target] and is longer, so
///     "음악을" ⊇ "음악", "학교에서" ⊇ "학교" (only for targets ≥2 chars, else a
///     1-char card like "코" would swallow "코끼리");
///  3. **1-char wobble** — Levenshtein distance ≤1 for targets ≥3 chars (long
///     enough that a single mis-heard jamo/char shouldn't be a false positive).
bool wordMatch(String tok, String target) {
  if (tok.isEmpty) return false;
  final t = norm(target);
  if (t.isEmpty) return false;
  if (tok == t) return true;
  if (t.length >= 2 && tok.length > t.length && tok.startsWith(t)) return true;
  if (t.length >= 3 && _levenshtein(tok, t) <= 1) return true;
  return false;
}

/// Whether a spoken [transcript] covers the target [sentence] — used by the
/// sentence-card challenge (the player says a whole learned sentence, not one
/// word). Two tiers:
///  1. the normalized transcript **contains** the normalized sentence
///     (spaces/punctuation ignored) — a clean full utterance;
///  2. **character-weighted eojeol coverage** — the matched eojeols must carry
///     at least [_kSentenceCoverage] of the sentence's characters.
///
/// Coverage is weighted by length, not counted per eojeol, and that is the
/// whole point. Counting eojeols gave a two-eojeol sentence no tolerance at
/// all — `ceil(2 * 0.7) == 2` demands a perfect hit — so "저는 선생님이에요"
/// failed whenever the recognizer contracted 저는 to 전, which it normally
/// does (measured on device 2026-09-08).
///
/// Weighting by characters fixes that without opening the door to near
/// misses: "전 선생님이에요" covers 6 of 8 characters (0.75, passes) while
/// "저는 학생이에요" against the same target covers only 저는 — 2 of 8 (0.25,
/// fails). Those two are exactly the cards that sit on screen together, so
/// keeping them apart is the constraint that matters.
///
/// **라틴 문자가 든 어절은 판정에서 뺀다**(QA F057 · PM-DEC-044). 학습 문장에 캐릭터·사람
/// 이름 같은 영어(「Zena는 학생이에요」)가 섞이면, 서버 STT 가 ko-KR 하나라 그 부분이
/// 「제나는」 처럼 한글로 전사되어 「zena」 와 절대 안 맞았다 — 문장 전체가 커버리지 미달로
/// 실패했다. 그 어절은 자동 통과로 보고 나머지 한국어만으로 판정한다. 화면 표시는 그대로다.
/// 한국어 어절이 하나도 없는 문장은 판정할 게 없어 실패한다 — 그런 문장은 애초에 챌린지
/// 문장 풀에 넣지 않는다([hasKoreanToScore] · PM-DEC-053). 무엇을 말해도 통과하던 구멍이었다.
bool sentenceMatch(String transcript, String sentence) {
  final t = norm(transcript);
  final scorable = sentence
      .split(_wordSplit)
      .where((w) => w.isNotEmpty && !_latinLetter.hasMatch(w))
      .toList();
  final s = norm(scorable.join(' '));
  if (s.isEmpty) return false;
  if (t.contains(s)) return true;
  final words = scorable.map(norm).where((w) => w.isNotEmpty).toList();
  if (words.length < 2) return false;
  var covered = 0;
  var total = 0;
  for (final w in words) {
    total += w.length;
    if (t.contains(w)) covered += w.length;
  }
  return total > 0 && covered / total >= _kSentenceCoverage;
}

/// Share of a sentence's characters that must be recognized for it to count.
const double _kSentenceCoverage = 0.7;

final RegExp _wordSplit = RegExp(r'\s+');

/// 라틴 문자 하나라도 든 어절 — [sentenceMatch] 가 판정에서 빼는 대상.
final RegExp _latinLetter = RegExp('[A-Za-z]');

/// 챌린지 문장 풀에 넣어도 되는가 — 라틴 어절을 뺀 뒤 판정할 한국어가 남는가(PM-DEC-053).
bool hasKoreanToScore(String sentence) => sentence
    .split(_wordSplit)
    .any((w) => !_latinLetter.hasMatch(w) && norm(w).isNotEmpty);

/// Levenshtein edit distance (web game `lev()`, lines 253–260). Small strings
/// only (card words), so the simple O(m·n) DP is fine.
int _levenshtein(String a, String b) {
  final m = a.length, n = b.length;
  if (m == 0) return n;
  if (n == 0) return m;
  var prev = List<int>.generate(n + 1, (j) => j);
  var curr = List<int>.filled(n + 1, 0);
  for (var i = 1; i <= m; i++) {
    curr[0] = i;
    for (var j = 1; j <= n; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      curr[j] = [curr[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost]
          .reduce((x, y) => x < y ? x : y);
    }
    final tmp = prev;
    prev = curr;
    curr = tmp;
  }
  return prev[n];
}


/// Builds the lookup [segmentByVocab] needs: every word normalized, deduped,
/// and sorted **longest first** so a scan takes the longest match at each
/// position ("기차책" → 기차 + 책, never 기 + 차책).
List<String> buildVocabIndex(Iterable<String> words) {
  final out = <String>{};
  for (final w in words) {
    final n = norm(w);
    if (n.isNotEmpty) out.add(n);
  }
  final list = out.toList()..sort((a, b) => b.length.compareTo(a.length));
  return List<String>.unmodifiable(list);
}

/// Re-splits a run-on token into game vocabulary, longest match first.
///
/// **This is what makes continuous speech playable.** A recognizer hands back
///연속 발화 as one blob — say "기차 책" and it arrives as "기차책". One token
/// only ever clears one card, so the second word was a guaranteed miss; worse,
/// when only the trailing word was on screen the prefix tier in [wordMatch]
/// did not fire either ("기차책" does not start with "책"), so nothing cleared
/// at all.
///
/// Splitting against the whole vocabulary rather than the on-screen cards is
/// deliberate: it also rescues "기차책" when only "책" is left.
///
/// [vocabSortedByLengthDesc] must come from [buildVocabIndex]. Characters that
/// match nothing (particles, noise) are skipped one at a time.
List<String> segmentByVocab(String tok, List<String> vocabSortedByLengthDesc) {
  final out = <String>[];
  var i = 0;
  while (i < tok.length) {
    String? hit;
    for (final w in vocabSortedByLengthDesc) {
      if (tok.startsWith(w, i)) {
        hit = w; // sorted by length → the first hit is the longest
        break;
      }
    }
    if (hit != null) {
      out.add(hit);
      i += hit.length;
    } else {
      i++; // a particle or a stray character
    }
  }
  return out;
}
