/// Data model for the learning session summary (`screen/learning_main`,
/// `3569:15065`) — what [LearningCallMainScreen] draws.
///
/// Built from `GET /calls/{callId}/pronunciation-report` via
/// [LearningSummary.fromJson] (see `normalcall_providers.dart`
/// `pronunciationReportProvider`). The old hardcoded `mockLearningSummary` is
/// gone — the screen now renders the server's data, with loading/error handled
/// by the provider's `AsyncValue`.
///
/// Server note: 문장별·통과·최근 세션은 실집계지만, 소리별 정확도(phonemes)·가장
/// 어려웠던 소리는 아직 서버가 목값으로 내려준다(음소 채점 모델 도입 전). [fromJson]
/// 은 없는 키를 안전 기본값으로 흡수한다(엔드포인트 계약이 아직 확정 전).
library;

/// Lenient JSON int — accepts num or numeric string, else 0.
int _asInt(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;

/// One row of `Section/Phonemes` — how a single sound went this session.
class PhonemeStat {
  /// Creates a phoneme accuracy row.
  const PhonemeStat({
    required this.sound,
    required this.attempts,
    required this.correct,
  });

  /// From `{sound, attempts, correct}` (server: pronunciation-report).
  factory PhonemeStat.fromJson(Map<String, dynamic> j) => PhonemeStat(
        sound: j['sound'] as String? ?? '',
        attempts: _asInt(j['attempts']),
        correct: _asInt(j['correct']),
      );

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

  /// From `{sentence, pronunciation, fluency, rhythm}`.
  factory SentenceScore.fromJson(Map<String, dynamic> j) => SentenceScore(
        sentence: j['sentence'] as String? ?? '',
        pronunciation: _asInt(j['pronunciation']),
        fluency: _asInt(j['fluency']),
        rhythm: _asInt(j['rhythm']),
      );

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
    this.callDate,
  });

  /// From `{label, date, sentences, score, delta, call_date?}` — label/date are
  /// server-formatted strings; delta is null for the earliest session.
  factory SessionPoint.fromJson(Map<String, dynamic> j) => SessionPoint(
        label: j['label'] as String? ?? '',
        date: j['date'] as String? ?? '',
        sentences: _asInt(j['sentences']),
        // null = 그 통화에서 발음 챌린지를 안 했다(점수 없음) · 0 = 진짜 0점. 예전 서버는 없음을
        // 0 으로 뭉개 보내 「96점 하락」 같은 가짜 하락이 생겼다(서버 1c83fd9 프론트 조치 🔴2).
        score: j['score'] == null ? null : _asInt(j['score']),
        delta: j['delta'] == null ? null : _asInt(j['delta']),
        // 서버 요청(09-24 `_shared/비버톡_서버추가요청_앱_2026-09-24.md` §1) — 오기 전에는 null.
        callDate: DateTime.tryParse(j['call_date'] as String? ?? '')?.toLocal(),
      );

  /// The chart's x-axis tick, e.g. `12/21` — or `오늘` for the latest.
  final String label;

  /// The table's date cell, e.g. `12월 21일`.
  final String date;

  /// How many sentences that session covered.
  final int sentences;

  /// 0–100 session score — **null 이면 점수 없음**(발음 챌린지를 안 한 통화). 표에 「—」,
  /// 차트에 막대 없음, 평균·눈금 판정에서 뺀다. [delta] 와 같은 규칙이다.
  final int? score;

  /// Change from the session before, or null for the earliest one on record —
  /// which renders as `—`, not `0`: "no previous session" is not "no change".
  final int? delta;

  /// 세션 시각(현지). 있으면 앱이 「오늘」 판정과 날짜 표기를 한다.
  ///
  /// [label]·[date] 는 서버가 **UTC 날짜**로 만든 문자열이라 한국 시각 00~09시 세션이
  /// 전날로 찍히고, 「오늘」 은 한국어로 고정이다(09-24 실기기 「9/23 (오늘)」).
  final DateTime? callDate;

  /// 서버가 이 세션을 「오늘」로 판정했나 — [callDate] 가 없을 때만 쓰는 대체 신호.
  /// 서버 `_sessions_from_history` 가 오늘이면 [label] 을 한국어 「오늘」로 보낸다(UTC 기준).
  bool get serverSaysToday => label == '오늘';
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

  /// Builds a summary from the `GET /calls/{id}/pronunciation-report` body.
  /// Missing keys degrade to safe defaults rather than throwing (the endpoint
  /// contract is still settling — phoneme/session fields especially).
  factory LearningSummary.fromJson(Map<String, dynamic> j) => LearningSummary(
        passed: _asInt(j['passed']),
        total: _asInt(j['total']),
        // 서버 시각(UTC) → 현지 날짜. 안 바꾸면 자정 근처 리포트가 전날로 찍힌다.
        date: DateTime.tryParse(j['date'] as String? ?? '')?.toLocal() ?? DateTime.now(),
        overall: _asInt(j['overall']),
        pronunciation: _asInt(j['pronunciation']),
        fluency: _asInt(j['fluency']),
        rhythm: _asInt(j['rhythm']),
        hardestSound: j['hardest_sound'] as String? ?? '',
        hardestEvidence: j['hardest_evidence'] as String? ?? '',
        l1Interference: j['l1_interference'] as String? ?? '',
        phonemes: ((j['phonemes'] as List?) ?? const [])
            .map((e) => PhonemeStat.fromJson(e as Map<String, dynamic>))
            .toList(),
        sentences: ((j['sentences'] as List?) ?? const [])
            .map((e) => SentenceScore.fromJson(e as Map<String, dynamic>))
            .toList(),
        sessions: ((j['sessions'] as List?) ?? const [])
            .map((e) => SessionPoint.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

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
