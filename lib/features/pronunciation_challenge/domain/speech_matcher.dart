import 'matcher.dart';

/// Per-utterance token-consumption bookkeeping, ported **verbatim** from the
/// web game's `handleTranscript` + `tryPass` (`pronunciation-challenge.html`
/// lines 305–350).
///
/// Server STT (like the Vosk / Web Speech recognizers it replaces) emits a
/// *growing* partial transcript many times per utterance (`"안녕"`,
/// `"안녕 하세요"`, …). Without
/// bookkeeping, every partial would re-attempt already-spoken words and a
/// single utterance could sweep several cards. This class tracks:
///
/// * [_lastTxt] — the previous lower-cased transcript. When the new transcript
///   is **not** a continuation of it (doesn't start with it, or is shorter) a
///   fresh utterance has begun, so the consumed cursor resets.
/// * [_consumed] — how many leading tokens of the current utterance have
///   already been matched, so they are never re-used.
///
/// Kept pure (no Flutter / plugin imports) so it is unit-testable against a
/// fake token sequence. The actual card matching is injected via the `attempt`
/// callback (wired to `ChallengeEngine.tryPassToken` at runtime).
class SpeechMatcher {
  int _consumed = 0;
  String _lastTxt = '';

  static final RegExp _whitespace = RegExp(r'\s+');

  /// Number of leading tokens already consumed in the current utterance
  /// (exposed for tests / debugging).
  int get consumed => _consumed;

  /// Feeds a [text] transcript (partial or final).
  ///
  /// [attempt] is called with each not-yet-consumed normalized token and must
  /// return `true` when it passes a card for that token; the first `true`
  /// advances the consumed cursor and stops (one card per call — web line 347).
  /// On [isFinal] the cursor and last-text reset so the next utterance starts
  /// clean (web lines 312, 323).
  void feed(
    String text, {
    required bool isFinal,
    required bool Function(String token) attempt,
  }) {
    final low = text.toLowerCase();
    // New utterance (not a continuation) → forget consumed tokens (web 309).
    if (!low.startsWith(_lastTxt) || low.length < _lastTxt.length) {
      _consumed = 0;
    }
    _lastTxt = low;
    _tryPass(text, attempt);
    if (isFinal) {
      _consumed = 0;
      _lastTxt = '';
    }
  }

  void _tryPass(String text, bool Function(String token) attempt) {
    final tokens = text
        .toLowerCase()
        .split(_whitespace)
        .map(norm)
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.length <= _consumed) return;
    for (var i = _consumed; i < tokens.length; i++) {
      if (attempt(tokens[i])) {
        _consumed = i + 1;
        return;
      }
    }
  }

  /// Resets the bookkeeping. Call when (re)arming recognition or on game start
  /// (web `startSTT`, line 334, and `recognition.onstart`, line 323).
  void reset() {
    _consumed = 0;
    _lastTxt = '';
  }
}
