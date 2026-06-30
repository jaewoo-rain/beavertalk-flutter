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

/// Full analysis result for a finished call.
class CallResult {
  const CallResult({
    required this.callId,
    this.summary,
    this.rating,
    required this.average,
    required this.sentences,
  });

  /// Server call id.
  final int callId;

  /// Human-readable summary of the call, or null.
  final String? summary;

  /// Optional 1–5 rating; null when not yet rated.
  final int? rating;

  /// Average pronunciation scores (may be placeholder zeros/nulls).
  final ScoreAverage average;

  /// Sentences learned/spoken during the call.
  final List<LearnedSentence> sentences;
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
