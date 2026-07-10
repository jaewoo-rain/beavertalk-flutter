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

/// Whether a single spoken/normalized token [tok] exactly matches [target]
/// after normalization.
///
/// Port of the web game `wordMatch()` (lines 262–266): exact match only.
bool wordMatch(String tok, String target) {
  if (tok.isEmpty) return false;
  final t = norm(target);
  return t.isNotEmpty && tok == t;
}
