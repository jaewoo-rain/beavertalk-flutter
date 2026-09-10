import 'dart:typed_data';

import '../entities/review_feedback.dart';

/// Pronunciation-review capabilities the app depends on. Implemented in the
/// data layer.
///
/// Returns entities and throws [AppException]
/// (see `core/error/app_exception.dart`) on failure. No dio/JSON leaks here.
abstract interface class ReviewRepository {
  /// Submits a recorded utterance ([wavBytes]: a complete WAV, PCM16/16k/mono)
  /// for [sentenceId] and returns the scored [ReviewFeedback].
  ///
  /// [applyScore] True(복습)면 문장 공식점수에 반영, False(연습)면 데이터는 저장·채점
  /// 하되 공식점수는 불변(미반영).
  Future<ReviewFeedback> submitAudio(
    int sentenceId,
    Uint8List wavBytes, {
    bool applyScore = true,
  });

  /// Fetches the sentence's standard-pronunciation audio URL via on-demand TTS
  /// (`POST /sentences/{id}/tts`). Returns a playable URL, or null when the
  /// server can't synthesize it. Throws [AppException] on transport failure.
  Future<String?> sentenceTtsUrl(int sentenceId);

  /// Synthesizes **raw text** (`POST /tts/speech`) and returns the mp3 bytes —
  /// for sentences with no row on the server, such as the in-call hint
  /// examples. The voice is the member's own character, which the server
  /// resolves from the token; no character is passed in.
  ///
  /// Returns null when the server couldn't synthesize (503 — its upstream TTS
  /// is down; the caller falls back to a message). Throws [AppException] on
  /// other failures.
  Future<Uint8List?> speech(String text);
}
