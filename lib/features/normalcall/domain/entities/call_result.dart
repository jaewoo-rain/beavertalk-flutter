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
    this.isNative = false,
    this.pairedSentenceId,
    this.nuance,
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

  /// 현지인 표현 짝인가(서버 `kind == "native"`). 기본 문장은 false.
  ///
  /// 서버 `premium` 브랜치(09-23)부터 배운 표현마다 원어민이 실제로 쓰는 말이 하나씩
  /// 붙어 온다(예: 배고파요 → 뱃가죽이 등에 붙을 것 같아요). 순서는 「기본1·짝1·기본2·짝2…」.
  final bool isNative;

  /// 짝이 되는 기본 문장의 [sentenceId]. 기본 문장·북마크 목록에서는 null.
  final int? pairedSentenceId;

  /// 현지인 표현의 뉘앙스 설명(학습자 모국어). 기본 문장에서는 null.
  final String? nuance;
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
    this.quizItems = const [],
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

  /// Sentences learned/spoken during the call — 서버가 준 순서 그대로(기본·짝 교차).
  final List<LearnedSentence> sentences;

  /// 배운 표현 수 — 현지인 짝([LearnedSentence.isNative])은 세지 않는다.
  ///
  /// 3개를 배우면 서버는 6개(기본 3 + 짝 3)를 준다. `sentences.length` 로 세면
  /// 「새로운 표현 6개」 라는 틀린 숫자가 나온다.
  int get learnedCount => sentences.where((s) => !s.isNative).length;

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

  /// **표현학습** 통화에서 다룬 표현과 그 퀴즈 결과.
  ///
  /// ⭐ [usedItems] 와 **동시에 차지 않는다** — 두 칸은 서로 다른 코스의 것이다.
  ///   표현학습은 `item_evidence` 사슬을 안 쓰므로 [usedItems] 가 비고, 대신 이것이
  ///   찬다(서버 `CallResult.quiz_items` 주석). 다른 콜타입에서는 빈 배열이다.
  ///
  /// ⚠ [QuizItem.passed] 가 false 인 것은 «틀렸다» 가 **아니다** — «아직 못 뗐다» 다.
  ///   드릴만 하고 퀴즈까지 못 간 항목도 false 로 온다(다음 통화 앞으로 온다).
  ///
  /// 비어 있으면 화면은 그 칸을 **안 그린다**.
  final List<QuizItem> quizItems;

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
        quizItems: quizItems,
      );
}

/// 표현학습에서 다룬 표현 1건과 그 퀴즈 결과.
class QuizItem {
  /// 항목 하나를 담는다.
  const QuizItem({
    required this.itemId,
    required this.surface,
    this.meaning,
    required this.passed,
    this.failed = false,
  });

  /// 커리큘럼 항목 id.
  final int itemId;

  /// 표면형(예: `안녕히 가세요`).
  final String surface;

  /// 학습자 모국어 뜻. 옛 통화(2026-09-10 이전 스냅샷)에는 없다 → null.
  final String? meaning;

  /// 이 통화에서 퀴즈를 **통과**했나. → «맞혔어요»
  final bool passed;

  /// 이 통화의 퀴즈에서 **틀렸나**(정답 공개를 받았다). → «다시 볼 표현»
  ///
  /// ⭐ [passed]·[failed] 둘 다 false 면 **아직 퀴즈를 안 본 것**이다 — 드릴만 하고
  ///   퀴즈까지 못 간 항목. 그건 «틀렸다» 가 아니라 «다음에 이어서» 다.
  /// ⚠ `!passed` 로 대신하지 마라 — 위 둘을 가르는 유일한 칸이다. [passed] 면 항상
  ///   false 다(단조). 옛 스냅샷엔 키가 없어 false 로 온다.
  final bool failed;
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
