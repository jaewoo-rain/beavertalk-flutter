import 'dart:math';

import '../data/curated_word_source.dart';
import 'challenge_card.dart';
import 'game_config.dart';
import 'matcher.dart';

/// The pure-Dart simulation for the Pronunciation Challenge.
///
/// No Flutter imports — it holds all mutable game state and advances it with
/// [update]. A presentation-layer controller drives it from a `Ticker` and a
/// `CustomPainter` renders [cards] / [hitTexts] / HUD state. This is a direct
/// port of the web game's `update(dt)` and friends (lines 406–471).
class ChallengeEngine {
  /// Creates an engine. Inject a seeded [wordSource] for deterministic tests.
  ChallengeEngine({CuratedWordSource? wordSource})
      : _words = wordSource ?? CuratedWordSource();

  final CuratedWordSource _words;

  // ── Live state ─────────────────────────────────────────────────
  /// All cards currently on screen (live, passing, or missing).
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

  /// Total cards passed this session.
  int passCount = 0;

  /// Number of missed cards (session ends at [GameConfig.maxBacklog]).
  int backlog = 0;

  /// Whether the session is actively running.
  bool running = false;

  /// Seconds left in the session.
  double sessionLeft = GameConfig.sessionSec.toDouble();

  /// Scrolling offset of the belt stripes (modulo 80).
  double beltOffset = 0;

  /// Monotonically increasing clock (seconds), advanced every frame regardless
  /// of [running]. Used by the painter for the zone glow pulse.
  double clock = 0;

  /// Pass flash intensity 0..1 (decays).
  double flashPass = 0;

  /// Miss flash intensity 0..1 (decays).
  double flashMiss = 0;

  /// Selected difficulty (read live each frame — can change between rounds).
  Difficulty difficulty = Difficulty.normal;

  /// Result title, mirroring the web game (line 418).
  String get resultTitle => maxCombo >= 10 ? '🔥 Amazing!' : 'Nice!';

  /// (Re)starts a session: resets all counters and the shuffle bag.
  void start() {
    cards.clear();
    hitTexts.clear();
    _words.reset();
    score = 0;
    combo = 0;
    maxCombo = 0;
    passCount = 0;
    backlog = 0;
    sessionLeft = GameConfig.sessionSec.toDouble();
    running = true;
  }

  /// Ends the session (idempotent).
  void endGame() {
    if (!running) return;
    running = false;
  }

  /// Advances the simulation by [dt] seconds. Port of `update(dt)` (406–471).
  void update(double dt) {
    clock += dt;
    // Belt + flashes animate even when idle (web game lines 442–444).
    beltOffset =
        (beltOffset + dt * GameConfig.baseSpeed * 1.1 * difficulty.mult) % 80;
    if (flashPass > 0) flashPass = max(0, flashPass - dt * 3);
    if (flashMiss > 0) flashMiss = max(0, flashMiss - dt * 3);

    if (!running) return;

    sessionLeft -= dt;
    if (sessionLeft <= 0) {
      sessionLeft = 0;
      endGame();
      return;
    }

    // Distance-based spawn: only add a card once the rightmost live card has
    // moved MIN_SPACING away → constant spacing (web game lines 450–455).
    var rightmost = double.negativeInfinity;
    for (final c in cards) {
      if (c.state == CardState.live && c.x > rightmost) rightmost = c.x;
    }
    if (rightmost == double.negativeInfinity ||
        rightmost <= GameConfig.spawnX - GameConfig.minSpacing) {
      final d = _words.draw();
      cards.add(ChallengeCard(
        id: _nextId++,
        word: d.word,
        colorIndex: d.colorIndex,
        x: GameConfig.spawnX,
        y: GameConfig.beltY,
      ));
    }

    // Chosen difficulty × a gentle ramp with cleared count (web game line 457).
    final speed = (GameConfig.baseSpeed + min(90, passCount * 2)) *
        difficulty.mult;
    for (final c in cards) {
      switch (c.state) {
        case CardState.live:
          c.x -= speed * dt;
          if (c.x < GameConfig.missX) missCard(c);
        case CardState.pass:
          c.x += c.vx * dt;
          c.y += c.vy * dt;
          c.vy += 1400 * dt;
          c.rot += dt * 6;
          c.alpha -= dt * 1.4;
        case CardState.miss:
          c.y += c.vy * dt;
          c.vy += 900 * dt;
          c.alpha -= dt * 1.1;
      }
    }
    cards.removeWhere((c) => !(c.alpha > 0 && c.x > -GameConfig.cardW));

    for (final ht in hitTexts) {
      ht.y -= dt * 90;
      ht.life -= dt * 1.1;
    }
    hitTexts.removeWhere((h) => !(h.life > 0));
  }

  /// Passes a card: launches it and awards score + combo (web game 423–431).
  void passCard(ChallengeCard c) {
    if (c.state != CardState.live) return;
    c.state = CardState.pass;
    c.vy = -900;
    c.vx = 520;
    c.rot = 0;
    c.alpha = 1;
    passCount++;
    combo++;
    maxCombo = max(maxCombo, combo);
    final pts = 100 + (combo - 1) * 12;
    score += pts;
    flashPass = 1;
    hitTexts.add(HitText(
      text: '+$pts',
      sub: combo > 1 ? 'COMBO ×$combo' : '',
      x: GameConfig.zoneCx,
      y: GameConfig.beltY - 160,
      miss: false,
    ));
  }

  /// Misses a card: drops it, breaks the combo, grows backlog (432–437).
  void missCard(ChallengeCard c) {
    c.state = CardState.miss;
    c.vy = 260;
    c.alpha = 1;
    combo = 0;
    backlog++;
    flashMiss = 1;
    hitTexts.add(HitText(
      text: 'MISS',
      sub: '',
      x: c.x,
      y: GameConfig.beltY - 160,
      miss: true,
    ));
    if (backlog >= GameConfig.maxBacklog) endGame();
  }

  /// The front-most (closest to the exit) live card inside the accept range,
  /// or `null`. Mirrors the in-zone selection used by the web game's speech
  /// path (lines 342–343), reused here for the temporary tap input.
  ChallengeCard? frontmostInZoneCard() {
    ChallengeCard? best;
    for (final c in cards) {
      if (c.state == CardState.live &&
          (c.x - GameConfig.zoneCx).abs() < GameConfig.acceptMargin) {
        if (best == null || c.x < best.x) best = c;
      }
    }
    return best;
  }

  /// Temporary input (stand-in for speech recognition): passes the front-most
  /// in-zone live card. Returns whether a card was passed.
  bool tapPass() {
    if (!running) return false;
    final c = frontmostInZoneCard();
    if (c == null) return false;
    passCard(c);
    return true;
  }

  /// Speech input: passes the front-most in-zone live card whose word exactly
  /// matches the normalized spoken [token]. Returns whether a card was passed.
  ///
  /// Port of the inner match loop of the web game's `tryPass` (lines 342–349):
  /// it scans the in-zone cards front-to-back and passes the first exact match.
  /// The per-utterance token bookkeeping (`consumed`/`lastTxt`) lives in
  /// [SpeechMatcher] so a single utterance clears at most one card per token.
  bool tryPassToken(String token) {
    if (!running) return false;
    final inZone = <ChallengeCard>[];
    for (final c in cards) {
      if (c.state == CardState.live &&
          (c.x - GameConfig.zoneCx).abs() < GameConfig.acceptMargin) {
        inZone.add(c);
      }
    }
    inZone.sort((a, b) => a.x.compareTo(b.x));
    for (final c in inZone) {
      if (wordMatch(token, c.word)) {
        passCard(c);
        return true;
      }
    }
    return false;
  }
}
