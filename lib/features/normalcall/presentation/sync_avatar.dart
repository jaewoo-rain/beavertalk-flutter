import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import 'avatar_tempo.dart';
import 'avatar_view.dart'
    show
        kEmotionHappy,
        kEmotionSurprised,
        kEmotionSad,
        kEmotionAngry,
        kIdleWait,
        kIdleListen,
        kIdleThink;

/// Video-call avatar built from neural clips that are *designed* to interlock.
///
/// Every clip is generated with the head locked and with its **first and last
/// frame pinned to the same base pose**, so any clip can follow any other with
/// no visible seam. Measured on the shipped clips: head/body difference between
/// clips 0.78/255, boundary frames 0.66–1.21/255 — i.e. the heads are the same
/// picture, only the face animates.
///
/// - `idle.mp4`  — 아무도 말하지 않을 때. 입 다뭄·호흡·눈 깜빡임.
/// - `idle_listen.mp4` — **사용자가 말하는 중**. 고개를 끄덕이며 듣는다.
///   ★없으면 「내 말을 듣고 있나」로 보인다 — 통화 시간의 절반이 이 구간이다.
/// - `idle_think.mp4` — 응답을 기다리는 중. 시선을 옮기며 말을 고른다.
///   위 셋은 [idleKind] 로 고르며 **`idle` 슬롯 하나**를 갈아끼운다(디코더 3개 한계).
/// - `talk.mp4`  — speaking: mouth talking. Held **paused at frame 0** (mouth
///   closed) while silent, so the instant the voice is audible it starts from
///   the top with no seek latency, then loops seamlessly.
/// - `talk_slow.mp4` · `talk_fast.mp4` — 같은 발화의 느린·빠른 판.
///   [kTalkSlow]·[kTalkNormal]·[kTalkFast]. 실측 입 개폐 1.97 · 2.63 · 3.79회/초.
/// - `emo_*.mp4` — speaking with an emotion; loaded on demand and layered above
///   talk.
///
/// 템포는 [tempo] 로 주거나, [autoTempo] 를 켜면 목소리의 음절 리듬으로 고른다
/// ([TempoMeter]). 🔴 자동은 **매핑이 미검증이라 기본이 꺼짐**이다 — [autoTempo] 주석 참조.
/// ⛔ 자막(`output_transcript`) 글자 수로 재지 마라 — 자막은 **생성 속도**로 도착하고
///    오디오는 **재생 속도**로 나온다. 이 어긋남이 v6.6 표정 깜빡임의 원인이었다.
///    엔벨로프는 컨트롤러가 이미 들리는 소리에 맞춰 주므로 그대로 쓰면 된다.
///
/// Switching is a short cross-fade. Because the heads match and `talk` always
/// enters on a closed mouth, the fade has nothing visible to blend.
///
/// Timing: the trigger is the **audio envelope** (`level`), which the controller
/// aligns to what is actually audible, so the talking clip starts when the voice
/// is heard — not when the packet arrives.
class SyncAvatar extends StatefulWidget {
  /// Creates the video avatar for the clips under [assetDir].
  const SyncAvatar({
    super.key,
    required this.assetDir,
    required this.level,
    required this.speaking,
    required this.emotion,
    this.tempo,
    this.idleKind,
    this.autoTempo = false,
    this.fallback,
  });

  /// Asset dir holding `idle.mp4`, `talk.mp4` and optional `emo_*.mp4`.
  final String assetDir;

  /// Live audio envelope, 0 (silent) .. 1 (loud) — drives play/stop timing.
  final ValueListenable<double> level;

  /// True while the character holds the turn (keeps talking through pauses).
  final ValueListenable<bool> speaking;

  /// Emotion code (see avatar_view k* constants) → optional reacting clip.
  final ValueListenable<int> emotion;

  /// 발화 템포([kTalkSlow]/[kTalkNormal]/[kTalkFast]). 안 주면 [kTalkNormal] 고정.
  final ValueListenable<int>? tempo;

  /// 대기 상태([kIdleWait]/[kIdleListen]/[kIdleThink]). 안 주면 [kIdleWait] 고정.
  ///
  /// 사용자가 말하는 동안 [kIdleListen](끄덕임), 응답을 기다리는 동안
  /// [kIdleThink](생각)로 바뀐다. 자산이 없는 캐릭터는 조용히 `idle` 로 폴백한다.
  final ValueListenable<int>? idleKind;

  /// 목소리의 음절 리듬을 재서 템포를 **자동으로** 고를지.
  ///
  /// 🔴 **기본이 꺼짐인 이유** — 기계(측정·교체)는 실기기(S8)에서 확인했으나
  /// **매핑이 아직 검증되지 않았다.** 실측 파형을 0.6·1.0·1.5배로 흘렸더니 측정값이
  /// 2.50 · 1.9 · 3.1 로 나와 **단조가 아니다**(느린데 빠르다고 판정). 3초 창이
  /// 발화 길이에 따라 다른 구간을 담기 때문이다. 창을 발화 전체로 바꾸면 단조는
  /// 회복되지만 절대값이 내려가 문턱([TempoMeter.tempoFor])을 다시 잡아야 하고,
  /// **그 기준은 실통화 음성이 있어야 정한다**(서버 Vertex 1008 미해결).
  /// 그때까지는 켜지 마라 — 틀린 템포가 걸리느니 normal 고정이 낫다.
  final bool autoTempo;

  /// Shown until the clips are ready (and if they fail to load).
  final Widget? fallback;

  @override
  State<SyncAvatar> createState() => _SyncAvatarState();
}

class _SyncAvatarState extends State<SyncAvatar> {
  VideoPlayerController? _idle;
  VideoPlayerController? _talk;
  VideoPlayerController? _emo; // 현재 화면에 보이는 감정 컨트롤러(캐시를 가리킴)
  int _emoCode = 0;
  bool _emoLoading = false;

  // 감정 클립 캐시: 코드→컨트롤러. 한 번 열면 유지하고 opacity로만 전환한다.
  // (기존엔 감정이 바뀔 때마다 _open+dispose 해서 매 턴 ExoPlayer(H.264/AAC 디코더)를
  //  생성/해제 → 메인 아이솔레이트 멈칫 → 오디오 피드 콜백 언더런 → 재생 깨짐. 캐싱으로 제거.)
  final Map<int, VideoPlayerController> _emoCache = {};

  bool _ready = false;
  bool _failed = false;

  /// Visible layers (cross-faded).
  double _talkOpacity = 0;
  double _emoOpacity = 0;

  /// True while the talking clip should be on screen.
  bool _talking = false;

  /// Debounce closing the mouth so short gaps between words don't flap it.
  Timer? _stopTimer;

  static const Duration _fadeIn = Duration(milliseconds: 80);
  static const Duration _fadeOut = Duration(milliseconds: 220);

  /// Envelope above this counts as audible voice. Deliberately low: speech
  /// onsets ramp up, and waiting for a louder frame pushed the picture ~100ms
  /// past the sound (perceptible — the tolerance for late video is ~125ms).
  static const double _onThreshold = 0.004;

  /// Silence this long ends the talking clip.
  static const Duration _hangover = Duration(milliseconds: 180);

  static const Map<int, String> _talkAsset = {
    kTalkSlow: 'talk_slow',
    kTalkNormal: 'talk',
    kTalkFast: 'talk_fast',
  };

  /// 지금 열려 있는 talk 클립의 템포.
  int _talkTempo = kTalkNormal;

  /// 발화 중에 정해진 템포는 여기 적어 두고 **말이 끝난 뒤** 갈아끼운다 —
  /// 문장 한가운데서 바꾸면 입 모양이 튄다.
  int? _pendingTempo;

  final TempoMeter _meter = TempoMeter();
  bool _talkSwapping = false;

  static const Map<int, String> _emoAsset = {
    kEmotionHappy: 'emo_happy',
    kEmotionSurprised: 'emo_surprised',
    kEmotionSad: 'emo_sad',
    kEmotionAngry: 'emo_angry',
  };

  /// 대기 클립 3종. **하나의 슬롯**에서 갈아끼운다(디코더 3개 한계).
  static const Map<int, String> _idleAsset = {
    kIdleWait: 'idle',
    kIdleListen: 'idle_listen',
    kIdleThink: 'idle_think',
  };

  /// 지금 열려 있는 대기 클립의 종류.
  int _idleKind = kIdleWait;
  bool _idleSwapping = false;

  @override
  void initState() {
    super.initState();
    widget.level.addListener(_onLevel);
    widget.emotion.addListener(_onEmotion);
    widget.speaking.addListener(_onLevel);
    widget.tempo?.addListener(_onTempo);
    widget.idleKind?.addListener(_onIdleKind);
    _talkTempo = widget.tempo?.value ?? kTalkNormal;
    _idleKind = widget.idleKind?.value ?? kIdleWait;
    _load();
  }

  Future<void> _load() async {
    // 컨트롤러는 둘 다 열어 둔다(초기화 유지 = 전환이 즉시다). 다만 **재생은 보이는
    // 쪽만** 한다 — 아래 _applyPlayback 참조.
    _idle = await _open(_idleAsset[_idleKind] ?? 'idle', loop: true, play: true);
    // 대기 자산이 없는 캐릭터는 기본 idle 로 되돌린다(talk 템포와 같은 폴백).
    if (_idle == null && _idleKind != kIdleWait) {
      _idleKind = kIdleWait;
      _idle = await _open('idle', loop: true, play: true);
    }
    _talk = await _open(_talkAsset[_talkTempo] ?? 'talk', loop: true, play: true);
    // 템포 자산이 없는 캐릭터(아직 talk.mp4 하나뿐인 bibi 등)는 기본으로 되돌린다.
    if (_talk == null && _talkTempo != kTalkNormal) {
      _talkTempo = kTalkNormal;
      _talk = await _open('talk', loop: true, play: true);
    }
    if (!mounted) return;
    setState(() {
      _ready = _idle != null || _talk != null;
      _failed = !_ready;
      // Apply whatever state the voice already asked for while we were loading.
      if (_ready && _talking) _talkOpacity = 1;
    });
    if (_ready && _talking) _syncEmotionLayer();
    await _applyPlayback();
  }

  /// 화면에 보이는 클립만 재생한다.
  ///
  /// 이 기기의 하드웨어 H.264 디코더는 동시 2~3개가 한계다. idle·talk·감정을 전부
  /// 돌리면 서로를 굶겨 그림이 얼어붙는다(2026-08-02 S8 실기기에서 재현).
  /// 컨트롤러 자체는 살려 두므로 전환은 opacity + play() 한 번으로 끝난다.
  Future<void> _applyPlayback() async {
    final showEmo = _talking && _emoOpacity > 0 && _emo != null;
    final showTalk = _talking && !showEmo;
    await _setPlaying(_idle, !_talking);
    await _setPlaying(_talk, showTalk);
    for (final c in _emoCache.values) {
      await _setPlaying(c, showEmo && identical(c, _emo));
    }
  }

  Future<void> _setPlaying(VideoPlayerController? c, bool on) async {
    if (c == null || !c.value.isInitialized) return;
    try {
      if (on && !c.value.isPlaying) {
        await c.play();
      } else if (!on && c.value.isPlaying) {
        await c.pause();
      }
    } catch (_) {
      // 이미 정리된 컨트롤러 — 조용히 넘어간다.
    }
  }

  Future<VideoPlayerController?> _open(String name,
      {required bool loop, required bool play}) async {
    final c = VideoPlayerController.asset('${widget.assetDir}/$name.mp4');
    try {
      await c.initialize();
      await c.setLooping(loop);
      await c.setVolume(0);
      if (play) await c.play();
      return c;
    } catch (_) {
      await c.dispose();
      return null;
    }
  }

  /// Envelope changed → start/stop the talking clip in step with the voice.
  ///
  /// Runs even before the clips finish initializing: the beaver can start
  /// speaking while the decoders are still warming up, and dropping those
  /// signals is what made the picture arrive ~0.7s late on the first turn.
  /// The desired state is tracked regardless and applied the moment we're ready.
  void _onLevel() {
    final audible = widget.level.value > _onThreshold;
    final turnOpen = widget.speaking.value;
    // 말하는 동안 음절을 세어 둔다. 쓰는 건 말이 끝난 뒤다(_stopTalking).
    if (widget.autoTempo) _meter.feed(widget.level.value, DateTime.now());

    if (audible) {
      // Onset: the voice is audible right now → show the talking clip. This is
      // the precise trigger, aligned to what is actually being heard.
      _stopTimer?.cancel();
      _stopTimer = null;
      if (!_talking) _startTalking();
      return;
    }
    if (_talking && turnOpen) {
      // Mid-turn pause (between sentences). The beaver still holds the turn, so
      // stay on the talking clip — dropping to idle here made the picture flap
      // several times inside one utterance.
      _stopTimer?.cancel();
      _stopTimer = null;
      return;
    }
    if (_talking && _stopTimer == null) {
      // Turn is over (or never opened) and it has gone quiet → back to idle.
      _stopTimer = Timer(_hangover, () {
        _stopTimer = null;
        if (widget.level.value <= _onThreshold && !widget.speaking.value) {
          _stopTalking();
        }
      });
    }
  }

  void _startTalking() {
    _talking = true;
    if (kDebugMode) debugPrint('[avatar] TALK on (level ${widget.level.value})');
    // 컨트롤러는 이미 열려 있다 — 보이게 하고 재생만 켠다. 새 디코더도 seek도 없다.
    if (mounted) setState(() => _talkOpacity = 1);
    _applyPlayback();
    _syncEmotionLayer();
  }

  void _stopTalking() {
    _talking = false;
    if (kDebugMode) debugPrint('[avatar] TALK off');
    if (mounted) {
      setState(() {
        _talkOpacity = 0;
        _emoOpacity = 0;
      });
    }
    _applyPlayback();
    _settleTempo();
    _rewindTalk();
  }

  /// 다음 발화가 **입 다문 첫 프레임**에서 시작하도록 되감는다.
  ///
  /// 이게 없으면 talk 은 **지난번에 멈춘 임의 프레임**에서 재개된다 — 일시정지만 하고
  /// 위치를 안 되돌리기 때문이다. 클래스 주석의 「frame 0 에 멈춰 대기」는 **첫 발화
  /// 한 번만** 참이었다(2026-08-08 확인).
  ///
  /// 실측 — idle↔talk 프레임 차이가 임의 위치끼리는 평균 **11.39**, f0 끼리는 **1.60** 이다.
  /// 신규 클립은 입을 15,600 까지 벌리므로(구자산 8,248) 임의 재개 시 **입을 벌린 채**
  /// 튀어나온다.
  ///
  /// ⛔ 되감기를 [_startTalking] 에 두지 마라 — 재생 직전 seek 는 첫 프레임을 지연시킨다.
  /// ⛔ **페이드가 끝난 뒤에** 되감아야 한다. 화면에 보이는 중에 seek 하면 그림이 튄다.
  void _rewindTalk() {
    Future.delayed(_fadeOut + const Duration(milliseconds: 120), () async {
      if (!mounted || _talking) return; // 그새 다시 말하기 시작했으면 건드리지 않는다
      try {
        await _talk?.seekTo(Duration.zero);
        await _emo?.seekTo(Duration.zero);
      } catch (_) {
        // 이미 정리된 컨트롤러 — 조용히 넘어간다.
      }
    });
  }

  /// 말이 끝난 지금 템포를 정한다. **여기서만** 갈아끼운다 — idle 이 보이는 순간이라
  /// 교체가 화면에 드러나지 않는다.
  void _settleTempo() {
    var want = _pendingTempo;
    _pendingTempo = null;
    if (want == null && widget.autoTempo) {
      final r = _meter.rate;
      if (r != null) {
        want = TempoMeter.tempoFor(r);
        if (kDebugMode) {
          debugPrint('[avatar] 음절 ${r.toStringAsFixed(2)}/s → 템포 $want');
        }
      }
      _meter.reset();
    }
    if (want != null) _swapTalk(want);
  }

  void _onTempo() {
    final t = widget.tempo?.value;
    if (t == null) return;
    if (_talking) {
      _pendingTempo = t;
      return;
    }
    _swapTalk(t);
  }

  void _onIdleKind() {
    final k = widget.idleKind?.value;
    if (k != null) _swapIdle(k);
  }

  /// 대기 클립을 갈아끼운다 — `idle` **슬롯 하나**를 계속 재사용한다.
  ///
  /// ⛔ 네 번째 컨트롤러를 열지 마라. idle + talk + 감정으로 이미 셋이고,
  ///    하드 디코더 한계(2~3개)를 넘으면 화면이 얼어붙는다(v6.1~6.3 멈춤의 원인).
  /// ⛔ 옛 컨트롤러를 먼저 해제하지 마라 — 그리는 중인 텍스처를 지우면 화면이 굳는다.
  ///    새것으로 갈아끼우고 **페이드가 끝난 뒤** 해제한다(`_swapTalk` 와 같은 규율).
  /// 🟡 말하는 중에도 갈아끼운다 — 그때 idle 은 talk 에 가려 보이지 않으므로
  ///    교체가 화면에 드러나지 않는다. 오히려 말이 끝나기 전에 준비되어야 한다.
  Future<void> _swapIdle(int kind) async {
    if (kind == _idleKind || _idleSwapping || !_ready) return;
    final name = _idleAsset[kind];
    if (name == null) return;
    _idleSwapping = true;
    final next = await _open(name, loop: true, play: false);
    _idleSwapping = false;
    if (next == null) return; // 그 캐릭터엔 해당 대기 자산이 없다 — 쓰던 것을 유지한다.
    if (!mounted) {
      await next.dispose();
      return;
    }
    final stale = _idle;
    setState(() {
      _idle = next;
      _idleKind = kind;
    });
    await _applyPlayback();
    if (stale != null) {
      Future.delayed(_fadeOut + const Duration(milliseconds: 120), () async {
        await stale.dispose();
      });
    }
  }

  /// talk 클립을 다른 템포로 갈아끼운다.
  ///
  /// ⛔ 옛 컨트롤러를 먼저 해제하면 **해제된 텍스처를 그리다 화면이 굳는다** —
  ///    감정 클립에서 실기기로 겪은 그대로다(2026-08-02). 새것으로 갈아끼우고
  ///    페이드가 끝난 뒤에 지운다.
  /// ⛔ 세 템포를 동시에 열어 두지 마라. 이 기기의 하드웨어 디코더는 2~3개가 한계이고
  ///    idle + talk + 감정으로 이미 셋이다.
  Future<void> _swapTalk(int tempo) async {
    if (tempo == _talkTempo || _talkSwapping || !_ready) return;
    final name = _talkAsset[tempo];
    if (name == null) return;
    _talkSwapping = true;
    final next = await _open(name, loop: true, play: false);
    _talkSwapping = false;
    if (next == null) return; // 그 캐릭터엔 해당 템포 자산이 없다 — 쓰던 것을 유지한다.
    if (!mounted) {
      await next.dispose();
      return;
    }
    final stale = _talk;
    setState(() {
      _talk = next;
      _talkTempo = tempo;
    });
    await _applyPlayback();
    if (stale != null) {
      Future.delayed(_fadeOut + const Duration(milliseconds: 120), () async {
        await stale.dispose();
      });
    }
  }

  void _onEmotion() {
    if (!_ready) return;
    _syncEmotionLayer();
  }

  /// Loads (once) and shows the clip for the current emotion while talking.
  Future<void> _syncEmotionLayer() async {
    if (!_ready) return; // don't contend with the idle/talk decoders warming up
    final code = widget.emotion.value;
    final name = _emoAsset[code];
    if (!_talking || name == null) {
      if (_emoOpacity != 0 && mounted) setState(() => _emoOpacity = 0);
      return;
    }
    if (_emoCode != code || _emo == null) {
      var next = _emoCache[code];
      if (next == null) {
        if (_emoLoading) return;
        _emoLoading = true;
        next = await _open(name, loop: true, play: true);
        _emoLoading = false;
        if (!mounted) {
          await next?.dispose();
          return;
        }
        if (next == null) return;
        // ★감정은 **한 개만** 살려 둔다. 캐시를 계속 쌓으면 idle·talk 까지 더해
        // 디코더가 최대 6개가 되고, 하드웨어 한계(2~3개)를 넘어 화면이 얼었다
        // (2026-08-02 S8 실기기). 이제 최대 3개 = idle + talk + 감정 1.
        //
        // ⛔ 여기서 바로 해제하면 안 된다. 지금 이 순간 `_emo`(그리고 위젯 트리)가
        // 옛 컨트롤러를 가리키고 있어서, 먼저 해제하면 **해제된 텍스처를 그리다 화면이
        // 굳는다**(2026-08-02 실기기에서 "말하다 멈춤"으로 나타남).
        // 새 컨트롤러로 갈아끼우고 페이드가 끝난 뒤에 해제한다.
        final stale = _emoCache.entries
            .where((e) => e.key != code)
            .map((e) => e.value)
            .toList();
        _emoCache
          ..clear()
          ..[code] = next;
        _emo = next;
        _emoCode = code;
        if (mounted) setState(() => _emoOpacity = 1);
        await _applyPlayback();
        if (stale.isNotEmpty) {
          Future.delayed(_fadeOut + const Duration(milliseconds: 120), () async {
            for (final c in stale) {
              await c.dispose();
            }
          });
        }
        return;
      }
      _emo = next;
      _emoCode = code;
    }
    final e = _emo;
    if (e == null) return;
    if (mounted) setState(() => _emoOpacity = 1);
    await _applyPlayback();
  }

  @override
  void dispose() {
    widget.level.removeListener(_onLevel);
    widget.speaking.removeListener(_onLevel);
    widget.emotion.removeListener(_onEmotion);
    widget.tempo?.removeListener(_onTempo);
    widget.idleKind?.removeListener(_onIdleKind);
    _stopTimer?.cancel();
    _idle?.dispose();
    _talk?.dispose();
    for (final c in _emoCache.values) {
      c.dispose(); // _emo 는 캐시를 가리키므로 별도 dispose 하지 않는다(중복 방지)
    }
    super.dispose();
  }

  Widget _cover(VideoPlayerController c) {
    final s = c.value.size;
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: s.width, height: s.height, child: VideoPlayer(c)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || !_ready) return widget.fallback ?? const SizedBox.expand();
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_idle != null) _cover(_idle!),
          if (_talk != null)
            AnimatedOpacity(
              opacity: _talkOpacity,
              duration: _talkOpacity > 0 ? _fadeIn : _fadeOut,
              curve: Curves.easeInOut,
              child: _cover(_talk!),
            ),
          if (_emo != null)
            AnimatedOpacity(
              opacity: _emoOpacity,
              duration: _talkOpacity > 0 ? _fadeIn : _fadeOut,
              curve: Curves.easeInOut,
              child: _cover(_emo!),
            ),
        ],
      ),
    );
  }
}
