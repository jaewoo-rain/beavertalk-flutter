import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';

/// Plays short review clips: the user's recorded WAV bytes ("Me"), or a native
/// audio URL ("Native") when one is available.
///
/// A thin wrapper over [FlutterSoundPlayer] that opens lazily and can be reused
/// for multiple plays; call [dispose] from the owning widget.
class ReviewAudioPlayer {
  FlutterSoundPlayer? _player;

  Future<FlutterSoundPlayer> _ensureOpen() async {
    final existing = _player;
    if (existing != null) return existing;
    final player = FlutterSoundPlayer();
    await player.openPlayer();
    _player = player;
    return player;
  }

  /// Plays the user's recorded clip from in-memory WAV [wavBytes].
  /// Throws on failure (caller surfaces a message).
  Future<void> playBytes(Uint8List wavBytes) async {
    final player = await _ensureOpen();
    await player.stopPlayer();
    await player.startPlayer(
      fromDataBuffer: wavBytes,
      codec: Codec.pcm16WAV,
    );
  }

  /// Plays mp3 bytes held in memory — `POST /tts/speech` answers with the audio
  /// itself rather than a URL, so there is nothing to hand [playUrl].
  ///
  /// ⚠ [playBytes] is **not** interchangeable: it declares `pcm16WAV`, and mp3
  /// bytes under that codec play as noise or not at all.
  Future<void> playMp3Bytes(Uint8List mp3Bytes) async {
    final player = await _ensureOpen();
    await player.stopPlayer();
    await player.startPlayer(fromDataBuffer: mp3Bytes, codec: Codec.mp3);
  }

  /// Plays native audio from [url]. Throws on failure (e.g. an unplayable
  /// storage key); the caller treats playback as best-effort.
  Future<void> playUrl(String url) async {
    final player = await _ensureOpen();
    await player.stopPlayer();
    await player.startPlayer(fromURI: url);
  }

  /// Stops and releases the player. Idempotent.
  Future<void> dispose() async {
    try {
      await _player?.stopPlayer();
    } catch (_) {
      // best-effort
    }
    try {
      await _player?.closePlayer();
    } catch (_) {
      // best-effort
    }
    _player = null;
  }
}
