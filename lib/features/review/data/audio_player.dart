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
  /// 재생된 음성의 **실제 길이**를 돌려준다(플러그인이 모르면 null). 자동 연습은 이
  /// 값으로 재생 대기와 따라 말하기 구간을 정한다 — 글자 수 어림값은 「가」 같은 한 자와
  /// 「값」 처럼 받침이 겹친 한 자를 같은 길이로 보아 어긋난다.
  ///
  /// ⚠ [playBytes] is **not** interchangeable: it declares `pcm16WAV`, and mp3
  /// bytes under that codec play as noise or not at all.
  Future<Duration?> playMp3Bytes(Uint8List mp3Bytes) async {
    final player = await _ensureOpen();
    await player.stopPlayer();
    return player.startPlayer(fromDataBuffer: mp3Bytes, codec: Codec.mp3);
  }

  /// Plays native audio from [url]. Throws on failure (e.g. an unplayable
  /// storage key); the caller treats playback as best-effort.
  ///
  /// 재생된 음성의 **실제 길이**를 돌려준다(플러그인이 모르면 null) — [playMp3Bytes] 와
  /// 같은 계약이다. 자동 연습이 미리 구운 URL 과 온디맨드 합성 중 어느 쪽으로 재생하든
  /// 같은 값으로 타이밍을 잡아야 해서다.
  Future<Duration?> playUrl(String url) async {
    final player = await _ensureOpen();
    await player.stopPlayer();
    return player.startPlayer(fromURI: url);
  }

  /// 재생만 멈춘다 — 플레이어는 열어 둔다. 멱등.
  ///
  /// [dispose] 와 다르다. 자동 연습처럼 **멈췄다 다시 재생하는** 흐름에서 dispose 를 쓰면
  /// 다음 재생마다 플레이어를 새로 열어야 하고, 그 사이 지연이 그대로 침묵이 된다.
  Future<void> stop() async {
    try {
      await _player?.stopPlayer();
    } catch (_) {
      // best-effort — 이미 멈춰 있을 수 있다.
    }
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
