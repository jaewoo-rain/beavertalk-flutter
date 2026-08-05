/// Word-matching helpers, ported from the web game (`norm`, `wordMatch`).
///
/// Kept pure so the same normalization can back both the future speech-token
/// path and unit tests. No fuzzy/Levenshtein tolerance — the reference uses an
/// exact normalized match to minimise false positives.
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
///  2. **eojeol coverage** — most of the sentence's words appear in the
///     transcript, so a slightly mis-heard or partial utterance still passes
///     (STT drops/garbles the odd word in a long sentence).
bool sentenceMatch(String transcript, String sentence) {
  final t = norm(transcript);
  final s = norm(sentence);
  if (s.isEmpty) return false;
  if (t.contains(s)) return true;
  final words = sentence
      .split(_wordSplit)
      .map(norm)
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.length < 2) return false;
  final hit = words.where(t.contains).length;
  final needed = (words.length * 0.7).ceil();
  return hit >= needed;
}

final RegExp _wordSplit = RegExp(r'\s+');

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
