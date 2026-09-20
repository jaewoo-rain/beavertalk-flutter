import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../../review/data/audio_player.dart';
import '../../review/data/speech_cache.dart';
import '../../review/domain/repositories/review_repository.dart';
import '../domain/auto_practice.dart';

/// 무채점 자동 연습을 실제로 굴리는 컨트롤러 — 상태기계 + 음성 + 타이머.
///
/// [AutoPracticeMachine] 은 시간을 모르고, 이 클래스는 규칙을 모른다. 규칙은 기계가,
/// 시간·소리는 여기가 갖는다.
///
/// 음성은 `POST /tts/speech` 로 합성해 [SpeechCache] 에 담는다. 같은 단어를 다시 들을 때
/// 합성 요금을 또 내지 않기 위해서다(백엔드 요청 2026-09-04).
///
/// ⭐ 엔진은 **구 Gemini-TTS** 다(2026-09-21 사장님 지시). 앱의 다른 TTS 경로(통화 힌트·
///    표준 발음)는 Chirp3-HD 그대로다 — 여기서만 엔진을 지정한다.
///
/// ⛔ 「다시 듣기」 버튼은 없다(2026-09-21). 자동 진행이라 누를 틈이 생기기 전에 다음
///    항목으로 넘어가고, 눌러도 되감을 지점이 이미 지나간다 — 있는 척만 하는 버튼이었다.
///
/// ⚠️ **화면이 사라지면 타이머와 재생을 둘 다 끊어야 한다.** 하나만 끊으면 돌아왔을 때
/// 소리만 나거나 진행만 뛴다. [pause] 가 둘을 함께 끊는다.
class AutoPracticeController extends ChangeNotifier {
  AutoPracticeController({
    required List<String> items,
    required ReviewRepository repository,
    required SpeechCache cache,
  })  : _items = items,
        _repo = repository,
        _cache = cache,
        _machine = AutoPracticeMachine(items.length);

  final List<String> _items;
  final ReviewRepository _repo;
  final SpeechCache _cache;
  final AutoPracticeMachine _machine;
  final _player = ReviewAudioPlayer();

  /// 취약 발음 학습이 쓰는 TTS 엔진. 서버 `CASCADE_TTS_ENGINE` 과 같은 문자열이다.
  static const _engine = 'gemini-tts';

  Timer? _timer;
  bool _disposed = false;

  /// 음성 합성이 막혀 소리 없이 진행 중인가. 화면이 안내를 띄운다.
  bool get muted => _muted;
  bool _muted = false;

  AutoPracticeState get state => _machine.state;
  String get currentItem =>
      _items.isEmpty ? '' : _items[state.index.clamp(0, _items.length - 1)];

  /// 진입 시 1회. 이미 돌고 있으면 무시한다.
  Future<void> start() async {
    if (state.isRunning) return;
    _apply(_machine.start());
    await _playCurrent();
  }

  /// 화면 이탈·앱 백그라운드. 타이머와 재생을 함께 끊는다.
  Future<void> pause() async {
    _timer?.cancel();
    _timer = null;
    await _player.stop();
    _apply(_machine.pause());
  }

  /// 돌아왔을 때 — 보던 항목의 재생부터 다시.
  Future<void> resume() async {
    if (state.phase != AutoPracticePhase.idle) return;
    _apply(_machine.resume());
    if (state.phase == AutoPracticePhase.playing) await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final text = currentItem;
    final bytes = await _bytesFor(text);
    if (_disposed) return;

    Duration? length;
    if (bytes != null) {
      try {
        await _player.playMp3Bytes(bytes);
        // 합성 음성 길이를 알 수 없으면(플러그인이 안 알려주면) 글자 수로 어림한다.
        length = _estimate(text);
      } catch (_) {
        _muted = true;
      }
    } else {
      _muted = true;
    }
    if (_disposed) return;

    // 재생 완료 신호 대신 길이만큼 기다린다. flutter_sound 의 완료 콜백은 플랫폼마다
    // 오는 시점이 갈리고, 안 올 때도 있다 — 그러면 화면이 영영 멈춘다.
    _after(length ?? _estimate(text), () {
      _apply(_machine.onPlaybackComplete());
      _after(repeatWindow(length ?? _estimate(text)), () async {
        final next = _machine.onRepeatComplete();
        _apply(next);
        if (next.phase == AutoPracticePhase.playing) await _playCurrent();
      });
    });
  }

  Future<Uint8List?> _bytesFor(String text) async {
    if (text.isEmpty) return null;
    // ⚠ 캐시 키에 엔진을 넣는다. 같은 문장이라도 엔진이 다르면 다른 소리라,
    //   빼면 통화 힌트가 Chirp3 로 채운 캐시가 여기로 그대로 나온다.
    final key = '$_engine|$text';
    final cached = _cache.get(key);
    if (cached != null) return cached;
    try {
      final bytes = await _repo.speech(text, engine: _engine);
      if (bytes != null && bytes.isNotEmpty) {
        _cache.put(key, bytes);
        return bytes;
      }
    } catch (_) {
      // 합성 실패는 학습을 멈출 이유가 아니다 — 소리 없이 글자만 보고 따라 한다.
    }
    return null;
  }

  /// 한국어 합성 음성 길이 어림 — 글자당 약 180ms + 앞뒤 여유 400ms.
  ///
  /// 정확한 길이를 재는 API 가 없다. 어림값이지만 **고정 초보다는 낫다** — 긴 문장에
  /// 짧은 틈을 주는 실수를 막는다.
  static Duration _estimate(String text) {
    final n = text.replaceAll(' ', '').length;
    return Duration(milliseconds: 400 + n * 180);
  }

  void _after(Duration d, FutureOr<void> Function() run) {
    _timer?.cancel();
    _timer = Timer(d, () {
      if (_disposed) return;
      run();
    });
  }

  /// 기계가 낸 새 상태를 화면에 알린다. 상태 자체는 기계가 들고 있어서 여기서는
  /// 보관하지 않는다 — 두 벌을 두면 어긋난다.
  void _apply(AutoPracticeState _) {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
