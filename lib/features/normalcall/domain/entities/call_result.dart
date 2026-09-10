// Post-call analysis entities for a normal (practice) call. Pure Dart —
// no Flutter/dio/JSON knowledge. Consumed by the analysis screen after a
// call ends.

/// Average pronunciation scores for a call.
///
/// All fields are nullable because scores are placeholders right after a call
/// (pronunciation grading happens in a later practice stage), so the server may
/// return `0`/`null`.
class ScoreAverage {
  const ScoreAverage({
    this.totalScore,
    this.pronunciation,
    this.fluency,
    this.rhythm,
  });

  /// Overall score, or null when not yet graded.
  final double? totalScore;

  /// Pronunciation score, or null when not yet graded.
  final double? pronunciation;

  /// Fluency score, or null when not yet graded.
  final double? fluency;

  /// Rhythm score, or null when not yet graded.
  final double? rhythm;
}

/// A sentence the learner produced/encountered during the call.
class LearnedSentence {
  const LearnedSentence({
    required this.sentenceId,
    this.korean,
    this.native,
    this.voiceUrl,
    this.isBookmarked = false,
  });

  /// Server primary key for this sentence.
  final int sentenceId;

  /// The Korean sentence, or null.
  final String? korean;

  /// The native-language translation, or null.
  final String? native;

  /// TTS audio URL for the expression playback; null when not available.
  final String? voiceUrl;

  /// Whether the learner has bookmarked this sentence.
  final bool isBookmarked;
}

/// The partner's short remark left right after the call ("Baba의 한마디").
class CharacterNote {
  const CharacterNote({required this.text});

  /// The remark body, as authored by the server.
  final String text;
}

/// Full analysis result for a finished call.
class CallResult {
  const CallResult({
    required this.callId,
    this.summary,
    this.rating,
    this.callDate,
    this.totalTime,
    required this.average,
    required this.sentences,
    this.character,
    this.callSequence,
    this.note,
    this.usedItems = const [],
  });

  /// Server call id.
  final int callId;

  /// Human-readable summary of the call, or null.
  final String? summary;

  /// Optional 1–5 rating; null when not yet rated.
  final int? rating;

  /// When the call took place, or null when the server doesn't provide it.
  final DateTime? callDate;

  /// Call duration in seconds, or null when the server doesn't provide it.
  final int? totalTime;

  /// Average pronunciation scores (may be placeholder zeros/nulls).
  final ScoreAverage average;

  /// Sentences learned/spoken during the call.
  final List<LearnedSentence> sentences;

  // ── Fields the v2 analysis design renders (Figma `screen/analysis__확정`) ──
  //
  // Every one of these is nullable and **the server does not send any of them
  // yet** — see `docs/2026-07-16_1145_analysis-확정디자인-정합.md` for the proposed
  // payload. They are declared (and parsed in the DTO) ahead of the server so
  // that wiring them up later needs no client change. Until then each stays null
  // and the screen hides that section outright rather than showing a placeholder.

  /// The conversation partner. `GET /calls` sends this per row, but
  /// `/calls/{id}/result` does not — so the avatar/name have no source here yet.
  final CallCharacterBrief? character;

  /// Which call this is with the partner, e.g. 3 → "3번째 통화".
  final int? callSequence;

  /// The partner's post-call remark, or null.
  final CharacterNote? note;

  /// 이 통화에서 학습자가 **스스로 쓴** 커리큘럼 항목.
  ///
  /// ⭐ 「학습한 표현」([sentences])과 다른 것이다. 그쪽은 물어봤거나 고쳐 받았거나
  ///   따라 말한 것이고, 이쪽은 **대화 중에 스스로 꺼내 쓴 것**이다. 자유대화를
  ///   매끄럽게 하면 [sentences] 가 비는데(분석 지시문이 셋으로만 정의한다) 그때도
  ///   보여줄 것이 있어야 한다 — 서버 체크판이 이미 잡아 둔 값이다.
  ///
  /// 비어 있으면 화면은 그 칸을 **안 그린다**. 근거가 없는 칸은 비운다.
  final List<UsedItem> usedItems;

  /// Returns a copy with [callDate]/[totalTime] overridden — used to graft the
  /// date/duration (which the `/result` endpoint omits) from the call detail.
  CallResult copyWith({DateTime? callDate, int? totalTime}) => CallResult(
        callId: callId,
        summary: summary,
        rating: rating,
        callDate: callDate ?? this.callDate,
        totalTime: totalTime ?? this.totalTime,
        average: average,
        sentences: sentences,
        character: character,
        callSequence: callSequence,
        note: note,
        usedItems: usedItems,
      );
}

/// 통화에서 스스로 쓴 항목 1건.
class UsedItem {
  /// 항목 하나를 담는다.
  const UsedItem({required this.itemId, required this.surface, this.quote});

  /// 커리큘럼 항목 id.
  final int itemId;

  /// 표면형(예: `가다`).
  final String surface;

  /// 학습자가 실제로 한 말. 서버가 인용을 못 남겼으면 null 이다 — 지어내지 않는다.
  final String? quote;
}

/// A character as it appears in a call list summary (lightweight brief).
class CallCharacterBrief {
  const CallCharacterBrief({
    required this.characterId,
    required this.name,
    this.imageUrl,
  });

  /// Server character id.
  final int characterId;

  /// Display name shown as the record title.
  final String name;

  /// Avatar image URL, or null (falls back to a static asset).
  final String? imageUrl;
}

/// One row of `GET /calls` — a past call as shown in the record list.
class CallSummary {
  const CallSummary({
    required this.callId,
    required this.character,
    this.callDate,
    this.totalTime,
    this.summary,
    this.rating,
  });

  /// Server call id; passed to the analysis flow on tap.
  final int callId;

  /// The conversation partner for this call.
  final CallCharacterBrief character;

  /// When the call took place (ISO datetime), or null.
  final DateTime? callDate;

  /// Call duration in seconds, or null.
  final int? totalTime;

  /// Human-readable summary of the call, or null.
  final String? summary;

  /// Optional 1–5 rating; null when not rated.
  final int? rating;
}

/// Lifecycle of a call's post-call analysis.
///
/// [unknown] also covers any status string the client does not recognize.
enum CallAnalysisStatus {
  /// The call is still in progress.
  ongoing,

  /// The call ended and analysis is being computed.
  analyzing,

  /// Analysis finished; the result is ready.
  done,

  /// Analysis failed.
  failed,

  /// Unknown/unrecognized status.
  unknown;

  /// Parses a server status string into a [CallAnalysisStatus].
  ///
  /// Unrecognized or null values map to [CallAnalysisStatus.unknown].
  static CallAnalysisStatus parse(String? value) {
    switch (value) {
      case 'ongoing':
        return CallAnalysisStatus.ongoing;
      case 'analyzing':
        return CallAnalysisStatus.analyzing;
      case 'done':
        return CallAnalysisStatus.done;
      case 'failed':
        return CallAnalysisStatus.failed;
      default:
        return CallAnalysisStatus.unknown;
    }
  }
}
