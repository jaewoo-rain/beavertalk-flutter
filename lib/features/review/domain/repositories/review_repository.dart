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
  Future<ReviewFeedback> submitAudio(int sentenceId, Uint8List wavBytes);

  /// Fetches the sentence's standard-pronunciation audio URL via on-demand TTS
  /// (`POST /sentences/{id}/tts`). Returns a playable URL, or null when the
  /// server can't synthesize it. Throws [AppException] on transport failure.
  Future<String?> sentenceTtsUrl(int sentenceId);
}
