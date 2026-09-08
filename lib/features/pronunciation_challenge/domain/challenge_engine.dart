import 'dart:math';

import '../data/curated_word_source.dart';
import 'challenge_card.dart';
import 'game_config.dart';
import 'matcher.dart';

/// The pure-Dart simulation for the Pronunciation Challenge.
///
/// No Flutter imports — it holds all mutable game state and advances it with
/// [update]. A presentation-layer controller drives it from a `Ticker` and a
/// `CustomPainter` renders [cards] / [hitTexts] / HUD state. Direct port of the
/// web game's `update(dt)`, `passCard`, `missCard` and `matchSpoken` candidate
/// selection (원근 터널 판, lines 1008–1071 and 632–651).
class ChallengeEngine {
  /// Creates an engine. Inject a seeded [wordSource] for deterministic tests.
  ChallengeEngine({CuratedWordSource? wordSource})
      : _words = wordSource ?? CuratedWordSource();

  final CuratedWordSource _words;

  // ── Live state ─────────────────────────────────────────────────
  /// All words currently on screen (live, grace, passing, or missing).
  final List<ChallengeCard> cards = <ChallengeCard>[];

  /// Floating hit texts (`+112`, `MISS`, …).
  final List<HitText> hitTexts = <HitText>[];

  int _nextId = 1;

  /// Current score.
  int score = 0;

  /// Current combo count (consecutive passes).
  int combo = 0;

  /// Best combo reached this session.
  int maxCombo = 0;

  /// Total words passed this session.
  int passCount = 0;

  /// Number of missed words (session ends at [Difficulty.missAllow]).
  int backlog = 0;

  /// Whether the session is actively running.
  bool running = false;

  /// Seconds left in the session.
  double sessionLeft = GameConfig.sessionSec.toDouble();

  /// Phase 0..1 of the tunnel rungs sliding toward the viewer. Without moving
  /// rungs the tunnel is indistinguishable from a still image. (Replaces the
  /// belt model's `beltOffset`.)
  double rungPhase = 0;

  /// Monotonically increasing clock (seconds), advanced every frame regardless
  /// of [running]. Used by the painter for the gate glow pulse.
  double clock = 0;

  /// Pass flash intensity 0..1 (decays).
  double flashPass = 0;

  /// Miss flash intensity 0..1 (decays).
  double flashMiss = 0;

  /// Selected difficulty (read live each frame — can change between rounds).
  Difficulty difficulty = Difficulty.normal;

  /// The most recent transcript the recognizer returned, matched or not.
  ///
  /// Shown under the gate for [heardTtl] seconds. Without it a misheard player
  /// gets no signal at all: the word just fails to clear, which reads the same
  /// as a dead mic. This is the only place the recognition is visible.
  String lastHeard = '';

  /// [clock] value when [lastHeard] arrived; negative means never.
  double lastHeardAt = double.negativeInfinity;

  /// How long a transcript stays on screen (seconds).
  static const double heardTtl = 2.5;

  /// Whether [lastHeard] should currently be drawn.
  bool get heardVisible =>
      lastHeard.isNotEmpty && (clock - lastHeardAt) < heardTtl;

  /// Records a transcript for display. Judging happens separately — this fires
  /// for every transcript, including the ones that match nothing.
  void heard(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    lastHeard = t;
    lastHeardAt = clock;
  }

  /// Words attempted this session: cleared plus missed.
  int get attempts => passCount + backlog;

  /// Share of attempts cleared, 0..1. Zero attempts reads as 0.
  double get accuracy => attempts == 0 ? 0 : passCount / attempts;

  /// Letter grade for the run (web `endGame`, line 964).
  ///
  /// `S` additionally requires volume — a single lucky clear is 100% accurate
  /// and must not outrank a long clean run.
  String get grade {
    final acc = accuracy;
    if (acc >= 0.9 && passCount >= 12) return 'S';
    if (acc >= 0.75) return 'A';
    if (acc >= 0.5) return 'B';
    return 'C';
  }

  /// Result title, keyed to [grade] (web `praise`, line 965).
  ///
  /// The old title only looked at [maxCombo], so a run that missed nearly
  /// everything still said "Nice!" as long as it strung three together.
  String get resultTitle => switch (grade) {
        'S' => 'Flawless!',
        'A' => 'Great!',
        'B' => 'Nice!',
        _ => 'Keep going!',
      };

  /// (Re)starts a session: resets all counters and the shuffle bag.
  void start() {
    cards.clear();
    hitTexts.clear();
    // Keep the previewed word if the countdown already drew one, so the card
    // the player sees first is the one they were just shown.
    final opener = _peeked;
    if (opener == null) _words.reset();
    score = 0;
    combo = 0;
    maxCombo = 0;
    passCount = 0;
    backlog = 0;
    sessionLeft = GameConfig.sessionSec.toDouble();
    lastHeard = '';
    lastHeardAt = double.negativeInfinity;
    running = true;
    if (opener != null) {
      cards.add(ChallengeCard(id: _nextId++, word: opener));
      _peeked = null;
    }
  }

  /// The word the next round will open with, without consuming it.
  ///
  /// The countdown previews it. Drawing it here and holding it means the very
  /// first card is one the player has already read once — the opening word is
  /// the only one that arrives with no warm-up.
  String? peekFirstWord() {
    if (_peeked == null) {
      _words.reset();
      _peeked = _words.draw().word;
    }
    return _peeked;
  }

  String? _peeked;

  /// Ends the session (idempotent).
  void endGame() {
    if (!running) return;
    running = false;
  }

  /// Advances the simulation by [dt] seconds.
  void update(double dt) {
    clock += dt;
    // Rungs + flashes animate even when idle.
    rungPhase = (rungPhase + dt * 0.35 * difficulty.mult) % 1;
    if (flashPass > 0) flashPass = max(0, flashPass - dt * 3);
    if (flashMiss > 0) flashMiss = max(0, flashMiss - dt * 3);

    if (!running) return;

    sessionLeft -= dt;
    if (sessionLeft <= 0) {
      sessionLeft = 0;
      endGame();
      return;
    }

    _spawn();

    // `k` is linear in time, so this rate is literally "scale per second".
    // Difficulty multiplier times a gentle ramp with the cleared count.
    final kps = ((1 - GameConfig.kSpawn) / GameConfig.tripSec) *
        difficulty.mult *
        (1 + min(0.6, passCount * 0.013));
    for (final c in cards) {
      switch (c.state) {
        case CardState.live:
          c.k += kps * dt;
          // Not a miss yet — the word freezes at kMiss and goes translucent
          // while the grace window runs.
          if (c.k > GameConfig.kMiss) {
            c.k = GameConfig.kMiss;
            c.state = CardState.grace;
            c.graceLeft = GameConfig.graceSec;
          }
        case CardState.grace:
          c.graceLeft -= dt;
          if (c.graceLeft <= 0) missCard(c);
        case CardState.pass:
          // Rushes past the viewer, growing and fading.
          c.k += c.vk * dt;
          c.vk += dt * 2.4;
          c.alpha -= dt * 1.9;
        case CardState.miss:
          c.k += c.vk * dt;
          c.alpha -= dt * 1.3;
      }
    }
    cards.removeWhere((c) => !(c.alpha > 0));

    for (final ht in hitTexts) {
      ht.y -= dt * 90;
      ht.life -= dt * 1.1;
    }
    hitTexts.removeWhere((h) => !(h.life > 0));
  }

  /// Depth-based spawn: a new word appears only once the **youngest** live word
  /// has travelled [GameConfig.kSpacing], which keeps the gap constant.
  ///
  /// The belt model measured from the *leading* card; doing that here makes the
  /// condition permanently true and spawns a word every frame, because the
  /// leading word only ever gets closer. At this spacing there are always two
  /// words on screen — the one being judged and the next one to read.
  void _spawn() {
    var youngest = double.infinity;
    for (final c in cards) {
      if (c.state == CardState.live && c.k < youngest) youngest = c.k;
    }
    if (youngest == double.infinity ||
        youngest >= GameConfig.kSpawn + GameConfig.kSpacing) {
      cards.add(ChallengeCard(id: _nextId++, word: _words.draw().word));
    }
  }

  /// Passes a word: launches it at the viewer and awards score + combo.
  ///
  /// A [CardState.grace] pass counts, at [GameConfig.latePointRatio] of the
  /// points — the recognition arrived late but the player did speak in time.
  void passCard(ChallengeCard c) {
    if (c.state != CardState.live && c.state != CardState.grace) return;
    final late = c.state == CardState.grace;
    c.state = CardState.pass;
    c.vk = 1.9;
    c.alpha = 1;
    passCount++;
    combo++;
    maxCombo = max(maxCombo, combo);
    final pts =
        ((100 + (combo - 1) * 12) * (late ? GameConfig.latePointRatio : 1.0))
            .round();
    score += pts;
    flashPass = 1;
    final comboTxt = combo > 1 ? 'COMBO x$combo' : '';
    hitTexts.add(HitText(
      text: '+$pts',
      sub: late ? (comboTxt.isEmpty ? 'LATE' : 'LATE · $comboTxt') : comboTxt,
      x: GameConfig.vpX,
      y: GameConfig.wordY(1) - 300,
      miss: false,
    ));
  }

  /// Misses a word: lets it drift off, breaks the combo, grows the backlog.
  void missCard(ChallengeCard c) {
    c.state = CardState.miss;
    c.vk = 0.55;
    c.alpha = 1;
    combo = 0;
    backlog++;
    flashMiss = 1;
    hitTexts.add(HitText(
      text: 'MISS',
      sub: '',
      x: GameConfig.vpX,
      y: GameConfig.wordY(1) - 300,
      miss: true,
    ));
    if (backlog >= difficulty.missAllow) endGame();
  }

  /// The nearest judgeable word, or `null`. Drives the gate's "listening" glow
  /// and the tap fallback.
  ChallengeCard? frontmostInZoneCard() {
    final cand = _judgeable();
    return cand.isEmpty ? null : cand.first;
  }

  /// Tap fallback (stand-in for speech recognition): passes the nearest
  /// judgeable word. Returns whether one was passed.
  bool tapPass() {
    if (!running) return false;
    final c = frontmostInZoneCard();
    if (c == null) return false;
    passCard(c);
    return true;
  }

  /// Speech input: passes the nearest judgeable word whose text matches the
  /// normalized spoken [token]. Returns whether one was passed.
  ///
  /// The per-utterance token bookkeeping (`consumed`/`lastTxt`) lives in
  /// `SpeechMatcher` so a single utterance clears at most one word per token.
  bool tryPassToken(String token) {
    if (!running) return false;
    for (final c in _judgeable()) {
      if (wordMatch(token, c.word)) {
        passCard(c);
        return true;
      }
    }
    return false;
  }

  /// Sentence input: passes the nearest judgeable word whose sentence the
  /// spoken [transcript] covers (see [sentenceMatch]). Used when the words are
  /// learned **sentences** (DB-sourced) rather than single nouns — the player
  /// speaks the whole sentence and it clears. Returns whether one passed.
  bool tryPassSentence(String transcript) {
    if (!running) return false;
    for (final c in _judgeable()) {
      if (sentenceMatch(transcript, c.word)) {
        passCard(c);
        return true;
      }
    }
    return false;
  }

  /// Judgment candidates, nearest (largest `k`) first: live words at or past
  /// [GameConfig.kAccept], plus every word still in its grace window.
  ///
  /// Dropping the grace words here would turn the whole of the STT round-trip
  /// latency back into misses.
  List<ChallengeCard> _judgeable() {
    final cand = <ChallengeCard>[];
    for (final c in cards) {
      if ((c.state == CardState.live && c.k >= GameConfig.kAccept) ||
          c.state == CardState.grace) {
        cand.add(c);
      }
    }
    cand.sort((a, b) => b.k.compareTo(a.k));
    return cand;
  }
}
