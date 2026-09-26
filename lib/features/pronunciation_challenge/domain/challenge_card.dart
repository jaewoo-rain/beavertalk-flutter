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

/// 통과·미스 판정 등급(웹 `judgeOf`). 연출만 — 점수·콤보 공식에는 안 들어간다.
enum Judge { perfect, great, good, miss }

/// A short-lived floating text spawned on a pass or miss — a [Judge] word with
/// its points under it, or a `N COMBO!` milestone. Pops out, rises and fades
/// (web `drawHits`, 2026-09-25).
class HitText {
  /// A judgment word (`PERFECT` … `MISS`) with [points] under it.
  HitText.judge({
    required Judge this.judge,
    required this.points,
    required this.x,
    required this.y,
  })  : combo = 0,
        life = 1,
        life0 = 1;

  /// The `N COMBO!` milestone, every [GameConfig.comboMilestone] combos.
  HitText.milestone({
    required this.combo,
    required this.x,
    required this.y,
  })  : judge = null,
        points = 0,
        life = 1.3,
        life0 = 1.3;

  /// Judgment word, or `null` for a milestone.
  final Judge? judge;

  /// Points awarded (drawn as `+1,000` under the word). 0 on a miss.
  final int points;

  /// Combo count a milestone celebrates; 0 for a judgment.
  final int combo;

  /// Whether this is the `N COMBO!` milestone.
  bool get isMilestone => judge == null;

  /// Centre X in design space.
  double x;

  /// Centre Y in design space.
  double y;

  /// Remaining life (doubles as opacity once below 0.35).
  double life;

  /// Life at spawn — the pop-out animation runs on `life0 - life`.
  final double life0;
}
