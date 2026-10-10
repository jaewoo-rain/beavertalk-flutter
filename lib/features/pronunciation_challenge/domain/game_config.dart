/// Tuning constants for the Pronunciation Challenge mini-game.
///
/// Ported **verbatim** from the reference web game
/// `beavertalkweb/app/pronunciation-challenge.html` (설정 block, lines 285–331).
/// The whole simulation runs in a fixed `1080×1920` design space; the painter
/// scales that space to the real widget size, so every value here stays in the
/// original pixel units.
///
/// **This is the 원근 터널 (perspective-tunnel) model, 정본 시안 2026-08-31.**
/// The old belt model scrolled cards right-to-left across a conveyor; a word's
/// state was its X. Here a word does not travel sideways at all — it grows out
/// of the vanishing point straight at the viewer, and its whole state is one
/// scalar [ChallengeCard.k], the screen scale. `k == 1` is the judgment point.
/// Font size and Y both derive from `k` ([wordSize] / [wordY]), so there is no
/// second axis to keep in sync.
abstract final class GameConfig {
  /// Design-space stage width (px).
  static const double w = 1080;

  /// Design-space stage height (px).
  static const double h = 1920;

  /// Session length in seconds.
  ///
  /// 60 → 30 with the tunnel (web line 291): recognition was reported to stop
  /// attaching around the 30s mark (root cause never found — the server stream
  /// itself keeps returning, so the remaining suspect is the client audio
  /// path), and a 30s clip suits sharing better anyway.
  static const int sessionSec = 30;

  // ── 원근 터널 기하 (시안 확정값) ───────────────────────────────────
  /// Vanishing-point X — every word grows from here.
  static const double vpX = 540;

  /// Vanishing-point Y.
  static const double vpY = 1010;

  /// Word centre Y at the judgment point (`k == 1`).
  static const double wordYNear = 1480;

  /// Word font size at the judgment point (`k == 1`).
  static const double wordSizeNear = 190;

  /// Judgment area (the bracketed gate). Kept as four scalars rather than a
  /// `Rect` so this domain layer stays free of Flutter imports.
  static const double gateX = 60;
  static const double gateY = 1250;
  static const double gateW = 960;
  static const double gateH = 460;

  // ── 진행도 k = 화면 배율 ───────────────────────────────────────────
  /// Spawn progress (word ≈48px at this scale).
  static const double kSpawn = 0.25;

  /// At or past this scale a word accepts speech (replaces the belt's
  /// `acceptMargin`).
  static const double kAccept = 0.72;

  /// Past this scale the word has gone by → it freezes here and enters
  /// [CardState.grace] (replaces the belt's `missX`).
  static const double kMiss = 1.22;

  /// Spawn spacing in progress, not pixels — the belt's `minSpacing` (a
  /// horizontal distance) has no meaning in a tunnel.
  ///
  /// Overlap is the real invariant. A word's half-height is `0.57 * size`, so
  /// two words clear each other only above a `k` ratio of 1.6, and the worst
  /// case is a leading word frozen at [kMiss] on grace. `1.22 / 1.6 = 0.7625`,
  /// so a gap of 0.50 keeps the follower below [kAccept] and always safe.
  /// (0.45 overlapped at the end of the run.)
  static const double kSpacing = 0.50;

  /// Seconds for a word to travel [kSpawn] → 1.0, before the difficulty
  /// multiplier. `k` rises **linearly in time**: true perspective is linear in
  /// depth, which makes the scale explode at the end and leaves no time to read
  /// the word. Even reading time wins.
  static const double tripSec = 5.0;

  /// How long a word past [kMiss] stays alive before the miss is final.
  ///
  /// Server STT round-trips in 300–800ms, so a transcript always lands after
  /// the moment the player spoke. Without this, speaking exactly on the beat
  /// still scored a miss. This grace window is the tunnel's answer to the same
  /// latency the belt model tried to absorb by widening its accept margin.
  static const double graceSec = 0.7;

  /// A grace-window pass is worth less than an on-time one.
  static const double latePointRatio = 0.6;

  // ── 점수 (웹 `POINT_BASE` · `POINT_COMBO_STEP`, 3c4cda0) ─────────────
  /// 한 장 기본 점수.
  static const int pointBase = 100;

  /// 콤보가 1 늘 때마다 더하는 점수 — 09-24 사용자 「콤보 점수를 엄청 많이」(12 → 100).
  /// 한 장 = `(pointBase + (combo - 1) * pointComboStep)`, 늦으면 × [latePointRatio].
  /// 10콤보 연속 합 = 5,500. 앱은 랭킹·서버 점수 검사가 없어 로컬 점수만 바뀐다.
  static const int pointComboStep = 100;

  // ── 판정 등급 (웹 `judgeOf`) — 연출만, 점수·콤보에는 안 들어간다 ──────
  /// PERFECT 하한·상한 — 통과 순간의 깊이 `k`. 판정 지점(1) 근처이고, 서버 STT 지연만큼
  /// 늦게 깨지는 걸 감안해 뒤쪽을 넓게 뒀다.
  static const double kPerfectMin = 0.9;
  static const double kPerfectMax = 1.15;

  /// GREAT 하한. 그 아래는 GOOD. 유예(LATE) 통과는 `k` 와 무관하게 GOOD.
  static const double kGreatMin = 0.8;

  /// 이 콤보의 배수마다 가운데 「N COMBO!」 · 큰 흔들림 · 강한 섬광.
  static const int comboMilestone = 5;

  // ── 학습 문장 두 줄 (웹 `layoutWord`) ─────────────────────────────
  /// 판정 지점 글자 크기([wordSizeNear])로 잰 폭이 이걸 넘으면 두 줄로 접는다(= 판정 구역 폭).
  static const double wordMaxW = gateW;

  /// 두 줄일 때 글자 배율. 두 줄 덩어리 높이를 한 줄 단어와 비슷하게 둬야 뒤 단어와 안 겹친다
  /// (앞 반높이 + 뒤 반높이 < k 간격 거리 — 0.58 이면 2 × [wordLineH] × 0.58 ≈ 1.22 줄 높이).
  static const double longWordScale = 0.58;

  /// 두 줄일 때 줄 간격(글자 크기 배수).
  static const double wordLineH = 1.05;

  /// Miss allowance at the hardest difficulty — the floor any difficulty can
  /// hand out. The live allowance is per-difficulty ([Difficulty.missAllow]).
  static const int minMissAllow = 2;

  /// `k` → word font size.
  static double wordSize(double k) => wordSizeNear * k;

  /// `k` → word centre Y. Interpolates the vanishing point to the judgment
  /// point, so a word is at [vpY] when `k == 0` and [wordYNear] when `k == 1`.
  static double wordY(double k) => vpY + (wordYNear - vpY) * k;
}

/// Difficulty presets: speed multiplier **and** miss allowance (web
/// `DIFFICULTIES`).
///
/// 목숨 4 / 3 / 2 — 09-24 사용자 지시(옛 5 / 4 / 3 에서 하나씩 줄임, 웹 `3c4cda0` 과 같음).
/// 속도 배율은 그대로다. 느린 난이도일수록 목숨이 많은 이유는 같다 — 초보의 판이 몇 초 만에
/// 끝나면 공유할 만한 영상이 안 남는다.
enum Difficulty {
  slow(0.6, 4),
  normal(1.0, 3),
  fast(1.8, 2);

  const Difficulty(this.mult, this.missAllow);

  /// Speed multiplier for how fast `k` grows and the rungs approach.
  final double mult;

  /// Misses allowed before the session ends.
  final int missAllow;
}
