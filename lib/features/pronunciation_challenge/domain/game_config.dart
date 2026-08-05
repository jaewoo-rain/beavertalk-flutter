/// Tuning constants for the Pronunciation Challenge mini-game.
///
/// Ported **verbatim** from the reference web game
/// `beavertalkweb-main/app/public/pronunciation-challenge.html` (설정 block,
/// lines 191–202). The whole simulation runs in a fixed `1080×1920` design
/// space; the painter scales that space to the real widget size, so every
/// value here stays in the original pixel units.
abstract final class GameConfig {
  /// Design-space stage width (px).
  static const double w = 1080;

  /// Design-space stage height (px).
  static const double h = 1920;

  /// Session length in seconds.
  static const int sessionSec = 60;

  /// Card centre Y on the belt (top is left empty for the face in the web game).
  static const double beltY = 1180;

  /// Judgment-zone centre X.
  static const double zoneCx = 360;

  /// Judgment-zone half width (generous).
  static const double zoneHalf = 230;

  /// Pronunciation-accept range (wider than the zone) → time to speak.
  ///
  /// Widened past the web game's 400: server STT has ~0.5–1s of recognition
  /// latency (mic → WS → Google → transcript), so a card must stay acceptable a
  /// bit longer after it enters the zone for a spoken word to still land.
  static const double acceptMargin = 470;

  /// A live card left of this X counts as a miss.
  static const double missX = 80;

  /// Card width / height.
  static const double cardW = 230;
  static const double cardH = 300;

  /// Cards spawn at this X (just off the right edge).
  static const double spawnX = 1220;

  /// Base leftward speed (px/s).
  static const double baseSpeed = 150;

  /// Minimum distance between cards (distance-based spawn).
  static const double minSpacing = cardW + 260;

  /// Missing this many cards ends the session.
  static const int maxBacklog = 3;
}

/// Difficulty presets. The value is the speed multiplier applied to card
/// movement and belt scroll (web game `data-mult`: 0.6 / 1 / 1.8).
enum Difficulty {
  slow(0.6),
  normal(1.0),
  fast(1.8);

  const Difficulty(this.mult);

  /// Speed multiplier for this difficulty.
  final double mult;
}
