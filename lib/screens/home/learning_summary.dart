/// Data for the learning session summary (`screen/learning_main`, `3569:15065`)
/// — and, for now, the mock that stands in for it.
///
/// ## Read this before wiring the API
///
/// [mockLearningSummary] is **fake**. It is the Figma frame's own sample values,
/// hardcoded, and [LearningCallMainScreen] renders it unconditionally — so the
/// screen currently shows invented phoneme statistics and an invented session
/// history to whoever opens it.
///
/// That is a deliberate exception (decision, 2026-07-16: UI first, server
/// later), not the house style — elsewhere this app hides a section rather than
/// fabricate it (`analysis.dart`). Two things follow:
///
/// 1. **The screen must not be given an entry point until this is real.** It has
///    none today, which is the only reason the mock is harmless.
/// 2. **Wiring the server means replacing [mockLearningSummary]**, nothing else.
///    Every widget reads [LearningSummary], so building one from the response is
///    the whole job — then delete the mock and this warning with it.
///
/// No endpoint serves phoneme accuracy or session history yet. The client shape
/// below is a proposal, not a contract.
library;

/// One row of `Section/Phonemes` — how a single sound went this session.
class PhonemeStat {
  /// Creates a phoneme accuracy row.
  const PhonemeStat({
    required this.sound,
    required this.attempts,
    required this.correct,
  });

  /// The sound as the learner sees it, e.g. `받침 ㄹ`, `ㅓ / ㅗ 구분`.
  final String sound;

  /// How many times it came up.
  final int attempts;

  /// How many of those were right.
  final int correct;

  /// 0–100. A row with no attempts should not exist, but guard rather than hand
  /// a NaN to the formatter.
  int get accuracy => attempts == 0 ? 0 : (correct * 100 / attempts).round();
}

/// One row of `Section/Sentences` — a sentence's three sub-scores.
class SentenceScore {
  /// Creates a per-sentence score row.
  const SentenceScore({
    required this.sentence,
    required this.pronunciation,
    required this.fluency,
    required this.rhythm,
  });

  /// The Korean sentence practiced.
  final String sentence;

  /// 0–100 sub-scores.
  final int pronunciation, fluency, rhythm;
}

/// One session in `Section/Trend` — a bar in the chart and a row in the table.
class SessionPoint {
  /// Creates a past-session point.
  const SessionPoint({
    required this.label,
    required this.date,
    required this.sentences,
    required this.score,
    this.delta,
  });

  /// The chart's x-axis tick, e.g. `12/21` — or `오늘` for the latest.
  final String label;

  /// The table's date cell, e.g. `12월 21일`.
  final String date;

  /// How many sentences that session covered.
  final int sentences;

  /// 0–100 session score.
  final int score;

  /// Change from the session before, or null for the earliest one on record —
  /// which renders as `—`, not `0`: "no previous session" is not "no change".
  final int? delta;
}

/// Everything `screen/learning_main` (`3569:15065`) draws.
class LearningSummary {
  /// Creates a learning-session summary.
  const LearningSummary({
    required this.passed,
    required this.total,
    required this.date,
    required this.overall,
    required this.pronunciation,
    required this.fluency,
    required this.rhythm,
    required this.hardestSound,
    required this.hardestEvidence,
    required this.l1Interference,
    required this.phonemes,
    required this.sentences,
    required this.sessions,
  });

  /// Sentences passed, out of [total].
  final int passed, total;

  /// When the session happened — the head's meta line (`3569:15082`).
  ///
  /// This replaced both the delta pill and the "오늘 학습 · 6분 12초" duration
  /// when the frame changed on 2026-07-16. Confirm the server sends a session
  /// timestamp when the endpoint lands; nothing supplies one today.
  final DateTime date;

  /// 0–100 gauge score and its three sub-scores.
  final int overall, pronunciation, fluency, rhythm;

  /// `Section/OneFix` — the sound that went worst, an example of it going wrong,
  /// and why the learner's first language makes it hard.
  final String hardestSound, hardestEvidence, l1Interference;

  /// Phoneme rows, worst accuracy first (the design's order).
  final List<PhonemeStat> phonemes;

  /// Sentence rows, in practice order.
  final List<SentenceScore> sentences;

  /// Chart/table points, **oldest first** — the chart draws left→right and the
  /// table reverses it.
  final List<SessionPoint> sessions;

  /// Total attempts across [phonemes], for the section's sub-label.
  int get phonemeAttempts => phonemes.fold(0, (sum, p) => sum + p.attempts);
}

/// ⚠️ FAKE. The Figma frame's sample values (`3569:15065`). See the library doc.
final mockLearningSummary = LearningSummary(
  passed: 8,
  total: 10,
  date: DateTime(2026, 7, 16),
  overall: 97,
  pronunciation: 96,
  fluency: 91,
  rhythm: 91,
  hardestSound: '받침 ㄹ',
  hardestEvidence: '“산책시킬게요”에서 7번 중 4번 새어 나갔어요',
  l1Interference: '스페인어엔 이 받침이 없어요. 당신 잘못이 아니에요.',
  phonemes: [
    PhonemeStat(sound: '받침 ㄹ', attempts: 7, correct: 3),
    PhonemeStat(sound: 'ㅓ / ㅗ 구분', attempts: 12, correct: 9),
    PhonemeStat(sound: '받침 ㅇ', attempts: 9, correct: 8),
    PhonemeStat(sound: 'ㅅ / ㅆ 구분', attempts: 5, correct: 5),
  ],
  sentences: [
    SentenceScore(
      sentence: '이 식당은 맛있는 음식을 팔아',
      pronunciation: 98,
      fluency: 95,
      rhythm: 97,
    ),
    SentenceScore(
      sentence: '강아지를 산책시킬게요',
      pronunciation: 71,
      fluency: 88,
      rhythm: 84,
    ),
    SentenceScore(
      sentence: '취향이 비슷하네요',
      pronunciation: 94,
      fluency: 90,
      rhythm: 92,
    ),
    SentenceScore(
      sentence: '내 귀를 사로잡았다',
      pronunciation: 89,
      fluency: 86,
      rhythm: 91,
    ),
  ],
  sessions: [
    SessionPoint(label: '12/21', date: '12월 21일', sentences: 9, score: 80),
    SessionPoint(
        label: '12/24', date: '12월 24일', sentences: 10, score: 87, delta: 7),
    SessionPoint(
        label: '12/28', date: '12월 28일', sentences: 8, score: 84, delta: -3),
    SessionPoint(
        label: '12/30', date: '12월 30일', sentences: 10, score: 92, delta: 8),
    SessionPoint(label: '오늘', date: '1월 2일', sentences: 10, score: 97, delta: 5),
  ],
);
