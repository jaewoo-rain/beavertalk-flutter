import 'game_config.dart';

/// Lifecycle state of a [ChallengeCard].
enum CardState {
  /// Growing out of the vanishing point toward the judgment point.
  live,

  /// Past [GameConfig.kMiss] and frozen there, still accepting speech for
  /// [GameConfig.graceSec] — the window that absorbs server-STT latency. Drawn
  /// dimmed, in the "late" colour.
  grace,

  /// Passed — keeps growing past the viewer and fades out.
  pass,

  /// Missed — drifts on and fades out in the miss colour.
  miss,
}

/// A single word in the Pronunciation Challenge tunnel.
///
/// Mutable on purpose: the engine advances progress / velocity / alpha in place
/// each frame (mirrors the plain-object cards in the web game).
///
/// There is no X or Y here. In the tunnel model a word's entire position is
/// [k] — the screen scale — and the painter derives both size and Y from it
/// via [GameConfig.wordSize] / [GameConfig.wordY].
class ChallengeCard {
  /// Creates a word. Live words start at [GameConfig.kSpawn].
  ChallengeCard({
    required this.id,
    required this.word,
    this.k = GameConfig.kSpawn,
    this.state = CardState.live,
    this.vk = 0,
    this.alpha = 1,
    this.graceLeft = 0,
  });

  /// Unique, monotonically increasing id.
  final int id;

  /// The Korean word or sentence to pronounce.
  final String word;

  /// Progress toward the viewer, and the word's screen scale. `k == 1` is the
  /// judgment point; [GameConfig.kSpawn] is where it appears.
  double k;

  /// Current lifecycle state.
  CardState state;

  /// Rate of change of [k] while dying (pass accelerates, miss drifts).
  double vk;

  /// Opacity 0..1.
  double alpha;

  /// Seconds left in the grace window; only meaningful in [CardState.grace].
  double graceLeft;
}

/// A short-lived floating text (e.g. `+112`, `COMBO ×3`, `MISS`) spawned on a
/// pass or miss. Rises and fades out.
class HitText {
  /// Creates a floating hit text.
  HitText({
    required this.text,
    required this.sub,
    required this.x,
    required this.y,
    required this.miss,
    this.life = 1,
  });

  /// Main line (e.g. `+112`).
  final String text;

  /// Optional second line (e.g. `COMBO ×3`); empty when none.
  final String sub;

  /// Centre X in design space.
  double x;

  /// Centre Y in design space.
  double y;

  /// Remaining life 0..1 (doubles as opacity).
  double life;

  /// Whether this is a miss (red) vs. a pass (mint).
  final bool miss;
}
