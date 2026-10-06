import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_sound/flutter_sound.dart';

/// Plays short review clips: the user's recorded WAV bytes ("Me"), or a native
/// audio URL ("Native") when one is available.
///
/// A thin wrapper over [FlutterSoundPlayer] that opens lazily and can be reused
/// for multiple plays; call [dispose] from the owning widget.
class ReviewAudioPlayer {
  /// [download] 는 시험용으로만 바꾼다 — URL 을 받아 바이트를 돌려준다.
  ReviewAudioPlayer({Future<Uint8List> Function(String url)? download})
      : _download = download ?? _defaultDownload;

  FlutterSoundPlayer? _player;
  final Future<Uint8List> Function(String url) _download;

  /// 재생 시작을 기다리는 상한.
  ///
  /// ⛔ flutter_sound 는 재생을 못 열면 **실패도 완료도 알리지 않는 경로**가 있다 —
  ///   iOS `FlautoPlayer.mm` 의 원격 URL 분기(다운로드 완료 콜백에서 `play` 가 실패하면
  ///   `stop` 만 하고 `startPlayerCompleted` 를 부르지 않는다)와 버퍼 분기(`play` 실패 시
  ///   같은 모양). 그러면 `startPlayer` 의 Future 가 영원히 안 끝나 화면이 멈춘다
  ///   (10-06 실기기: 자주 틀린 소리 「잘 들어 보세요」에서 정지 · 대체 합성으로도 못 감).
  static const Duration _startTimeout = Duration(seconds: 8);

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
    await _start(wavBytes, Codec.pcm16WAV);
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
  Future<Duration?> playMp3Bytes(Uint8List mp3Bytes) =>
      _start(mp3Bytes, Codec.mp3);

  /// Plays native audio from [url]. Throws on failure (e.g. an unplayable
  /// storage key); the caller treats playback as best-effort.
  ///
  /// 재생된 음성의 **실제 길이**를 돌려준다(플러그인이 모르면 null) — [playMp3Bytes] 와
  /// 같은 계약이다. 자동 연습이 미리 구운 URL 과 온디맨드 합성 중 어느 쪽으로 재생하든
  /// 같은 값으로 타이밍을 잡아야 해서다.
  ///
  /// ⭐ URL 을 플러그인에 넘기지 않고 **직접 받아** 메모리에서 재생한다. flutter_sound 의
  ///   iOS 원격 분기는 404·만료·네트워크 실패에서 아무 신호도 안 내고 멈춘다(위
  ///   [_startTimeout] 주석). 여기서 받으면 실패가 곧바로 예외가 되어, 호출부가 대체
  ///   경로(온디맨드 합성 등)로 넘어간다.
  Future<Duration?> playUrl(String url) async {
    final bytes = await _download(url);
    final codec = codecOf(bytes);
    if (codec == null) {
      throw const FormatException('재생할 수 없는 음성 형식(mp3·wav 아님)');
    }
    return _start(bytes, codec);
  }

  /// 메모리 버퍼 재생 — 시작을 [_startTimeout] 까지만 기다린다. 넘기면 멈추고 예외.
  Future<Duration?> _start(Uint8List bytes, Codec codec) async {
    final player = await _ensureOpen();
    await player.stopPlayer();
    try {
      return await player
          .startPlayer(fromDataBuffer: bytes, codec: codec)
          .timeout(_startTimeout);
    } on TimeoutException {
      await stop();
      rethrow;
    }
  }

  /// 앞 바이트로 형식을 가른다 — 확장자·Content-Type 은 믿지 않는다(굽는 쪽이 엔진
  /// 응답에 따라 mp3/wav 를 고른다). 모르면 null.
  static Codec? codecOf(Uint8List b) {
    if (b.length < 4) return null;
    // RIFF....WAVE
    if (b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46) {
      return Codec.pcm16WAV;
    }
    // ID3 태그 또는 MPEG 프레임 동기(0xFFE)
    if (b[0] == 0x49 && b[1] == 0x44 && b[2] == 0x33) return Codec.mp3;
    if (b[0] == 0xFF && (b[1] & 0xE0) == 0xE0) return Codec.mp3;
    return null;
  }

  static Future<Uint8List> _defaultDownload(String url) async {
    // ⛔ 앱 API 클라이언트를 쓰지 않는다 — 서명 URL 에 인증 헤더가 붙으면 스토리지가 거절한다.
    final dio = Dio(BaseOptions(
      responseType: ResponseType.bytes,
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 10),
    ));
    try {
      final res = await dio.get<List<int>>(url);
      final data = res.data;
      if (data == null || data.isEmpty) {
        throw const FormatException('음성 파일이 비어 있음');
      }
      return Uint8List.fromList(data);
    } finally {
      dio.close();
    }
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
