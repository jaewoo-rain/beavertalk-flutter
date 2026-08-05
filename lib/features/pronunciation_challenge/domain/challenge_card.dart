/// Lifecycle state of a [ChallengeCard].
enum CardState {
  /// Riding the belt leftward, awaiting a pass.
  live,

  /// Passed — launched up-and-right, tumbling and fading out.
  pass,

  /// Missed — dropped down, fading out.
  miss,
}

/// A single word card in the Pronunciation Challenge.
///
/// Mutable on purpose: the engine advances position / velocity / rotation /
/// alpha in place each frame (mirrors the plain-object cards in the web game).
class ChallengeCard {
  /// Creates a card. Live cards start on the belt ([y] defaults to the belt Y
  /// passed by the engine).
  ChallengeCard({
    required this.id,
    required this.word,
    required this.colorIndex,
    required this.x,
    required this.y,
    this.state = CardState.live,
    this.vx = 0,
    this.vy = 0,
    this.rot = 0,
    this.alpha = 1,
  });

  /// Unique, monotonically increasing id.
  final int id;

  /// The Korean word to pronounce.
  final String word;

  /// Index into the card-colour palette (see the painter).
  final int colorIndex;

  /// Centre X in design space.
  double x;

  /// Centre Y in design space.
  double y;

  /// Current lifecycle state.
  CardState state;

  /// Horizontal velocity (px/s) — used while tumbling.
  double vx;

  /// Vertical velocity (px/s) — used while tumbling / dropping.
  double vy;

  /// Rotation in radians — used while tumbling.
  double rot;

  /// Opacity 0..1.
  double alpha;
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
