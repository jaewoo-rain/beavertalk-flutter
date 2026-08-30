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
        kEmotionLaugh,
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
    this.silentEmotion = false,
    this.fallback,
    this.onDiag,
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

  /// 목소리 없이도 감정 클립을 튼다.
  ///
  /// 통화에서는 감정이 **발화에 얹히는 표정**이라 `_talking` 중에만 보이는 것이 맞다.
  /// 그런데 학습 화면의 반응 밴드는 **소리가 없다** — 채점 결과를 얼굴 하나로만
  /// 말한다. 거기서는 `level` 을 아무도 안 쓰므로 `_onLevel` 의
  /// `audible`(`level > _onThreshold`)이 영영 거짓이고, `_startTalking` 이 안 불려
  /// `_syncEmotionLayer` 가 `!_talking` 으로 즉시 빠져나간다.
  /// ⇒ **정답/오답에 emo_happy·emo_angry 가 한 번도 안 떴다**(2026-08-30 실기기
  ///   실측 — `[avatar] TALK on` 로그 0건, 로드된 클립은 idle·talk·idle_listen·
  ///   idle_think 뿐).
  ///
  /// 기본값은 `false` — 통화 화면과 아바타 랩의 거동을 그대로 둔다.
  final bool silentEmotion;

  /// Shown until the clips are ready (and if they fail to load).
  final Widget? fallback;

  /// [계측] 영상 쪽에서 일어난 일을 밖으로 흘린다. **UI 는 이걸로 아무것도 바꾸지 않는다.**
  ///
  /// ⛔ 왜 필요한가: 사장님이 실기기에서 보시는 증상 — 「웃는 게 두어 번 반복되다 갑자기
  ///   멈추고, 말할 차례가 되니 듣는 영상으로 넘어간다」 — 은 **전부 이 위젯 안에서**
  ///   일어난다. 그런데 이 위젯의 로그는 죄다 `kDebugMode` 뒤라 릴리즈에서 사라진다.
  ///   서버는 마커를 보냈다는 것까지만 알고, 그게 화면에서 어떻게 됐는지는 아무도 모른다.
  ///   ⇒ 그 구간을 잇는 유일한 실이다.
  /// ⚠ 널이면 계측이 없을 뿐 동작은 같다(R5).
  final void Function(String event, [Map<String, Object?>? fields])? onDiag;

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
    // ⭐ 파일명만 `emo_` 접두사가 없다 — 11종 세트에서 감정과 따로 만들어졌기 때문이다.
    //   ⛔ 이름을 맞추려고 자산을 개명하지 마라. 5캐릭터 × 앱스토어 자산이 걸린다.
    kEmotionLaugh: 'laugh',
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
    // ⛔ [_diagSink] 참조 — 해제 뒤에도 디코더 반납을 남기려면 지금 받아야 한다.
    _diagSink = widget.onDiag;
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
    // 무음 감정(학습 반응 밴드)에서는 `_talking` 이 영영 false 다 — 그때도 튼다.
    final emoAllowed = _talking || widget.silentEmotion;
    final showEmo = emoAllowed && _emoOpacity > 0 && _emo != null;
    final showTalk = _talking && !showEmo;
    // ⚠ idle 은 감정 밑에서 **계속 돌린다.** 여기서 멈추면 감정이 페이드로 걷힐 때
    //   그 밑이 정지 프레임으로 드러난다(같은 증상을 talk 쪽에서 이미 한 번 밟았다).
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

  /// 지금 살아 있는 [VideoPlayerController] 수 = **하드웨어 디코더 점유 수**.
  ///
  /// ## 왜 세는가 — 「3개를 안 넘는다」가 지금까지 **주석에만** 있었다
  ///
  /// 파일 곳곳에 「⛔ 네 번째 컨트롤러를 열지 마라」가 적혀 있지만 **아무도 세지 않았다.**
  /// 그래서 멈춤이 돌아왔을 때 그것이 한계 초과인지 다른 원인인지 가릴 외부 증거가 한 줄도
  /// 없었다(2026-08-15 실기기: 캐스케이드 통화 중 영상 멈춤).
  /// ⇒ 규칙을 **셈으로** 바꾼다. 넘으면 로그에 남고, 로그가 곧 판정이다.
  static int _decoders = 0;

  /// [widget.onDiag] 의 **해제 이후에도 쓸 수 있는** 사본.
  ///
  /// ⛔ [dispose] 가 `unawaited(_release(...))` 로 비동기 해제를 걸기 때문에,
  ///   그 안에서 `widget` 을 만지면 이미 사라진 State 의 필드를 읽게 된다
  ///   (디버에선 assert, 릴리즈엔 조용한 오동작). 통화 끝나는 순간의
  ///   디코더 반납은 **가장 보고 싶은 구간**이라 그걸 버릴 수 없다.
  ///   ⇒ 콜백을 initState 에서 미리 받아 둔다.
  void Function(String, [Map<String, Object?>?])? _diagSink;

  /// 디코더 수를 **서버로** 보낸다.
  ///
  /// ## ⛔⛔ 왜 고쳐야 했나 — 이 셀이 릴리즈에선 통째로 안 돌았다
  ///
  /// 이 셀은 「멈춤이 한계초과 때문인지 가릴 외부 증거」를 만들려고 지은 것인데
  /// (2026-08-15), 정작 출력이 `kDebugMode` 안에 갇혀 있었다. 사장님이 쓰시는
  /// **릴리즈 빌드에선 한 줄도 안 남는다.**
  ///
  /// 그래서 2026-08-27 실기기 멈춤(call 1224, 비버가 말하는 도중)을 조사할 때
  /// 로그에 `vid_dec` 가 0건이었고, 나는 그 침묵을 「초과 없음」으로 읽었다.
  /// **안 보내는 것과 없는 것을 구분할 수 없었다** — 계측이 스스로 거짓을 말한
  /// 셀 중 또 하나다.
  ///
  /// ⚠ `n` 은 **이 앱 전체**의 살아 있는 컨트롤러 수다(static). 하드웨어 디코더는
  ///   프로세스 단위 자원이라 그게 맞는 세기다.
  void _diagDecoders(String name, String delta) {
    _diagSink?.call('vid_dec', {
      'n': _decoders,
      'd': delta,
      'name': name,
      if (_decoders > 3) 'over': true,
    });
  }

  void _countOpen(String name) {
    _decoders++;
    _diagDecoders(name, '+');
    if (kDebugMode) {
      debugPrint('[avatar] decoder +1 → $_decoders ($name)'
          '${_decoders > 3 ? '  ⛔ 한계초과' : ''}');
    }
  }

  /// 트리에서 빠졌으나 **아직 해제되지 않은** 컨트롤러들.
  ///
  /// ## 왜 목록이 필요한가 — 2026-08-15 실기기에서 한계초과 2건이 남았다
  ///
  /// 교체는 옛것을 페이드(340ms) 뒤에 해제한다. 그런데 대기 상태는 턴마다
  /// `듣기 → 생각 → 대기` 로 **연달아** 바뀌고, 실측 간격이 그보다 짧다:
  ///
  ///     16:56:55.674  +1 → 3 (idle_think)
  ///     16:56:56.060  +1 → 4 (idle)   ⛔ 386ms 뒤 — 앞의 옛것이 아직 대기 중
  ///
  /// `_idleSwapping` 은 `_open` 이 끝나면 풀리므로 이 창을 못 막는다.
  /// ⇒ 대기 중인 옛것은 **이미 트리에서 빠져 있으므로** 새로 열기 전에 즉시 해제해도
  ///   안전하다(v6.4 의 금지 대상은 «그려지는 중»이지 «대기 중»이 아니다).
  final List<VideoPlayerController> _retiring = [];

  /// 옛 컨트롤러를 대기열에 넣고 페이드가 끝나면 해제한다.
  void _retire(VideoPlayerController? c, String why) {
    if (c == null) return;
    _retiring.add(c);
    Future.delayed(_fadeOut + const Duration(milliseconds: 120), () {
      if (_retiring.remove(c)) unawaited(_release(c, why));
    });
  }

  /// 대기 중인 옛 컨트롤러를 **지금** 해제한다 — 새로 열기 전에 자리를 비운다.
  Future<void> _flushRetiring(String why) async {
    if (_retiring.isEmpty) return;
    final now = List.of(_retiring);
    _retiring.clear();
    for (final c in now) {
      await _release(c, '$why(대기분 조기해제)');
    }
  }

  /// 컨트롤러를 해제하고 셈을 줄인다.
  ///
  /// ⛔ 그리는 중인 텍스처를 해제하면 화면이 굳는다(2026-08-02 실기기, v6.4 에서 확정).
  ///   그래서 호출자는 **참조를 먼저 끊고** 이 함수를 부른다.
  Future<void> _release(VideoPlayerController? c, String why) async {
    if (c == null) return;
    try {
      await c.dispose();
    } catch (_) {
      // 이미 정리된 컨트롤러 — 조용히 넘어간다.
    }
    _decoders--;
    _diagDecoders(why, '-');
    if (kDebugMode) debugPrint('[avatar] decoder -1 → $_decoders ($why)');
  }

  Future<VideoPlayerController?> _open(String name,
      {required bool loop, required bool play}) async {
    final c = VideoPlayerController.asset('${widget.assetDir}/$name.mp4');
    try {
      await c.initialize();
      _countOpen(name);
      await c.setLooping(loop);
      await c.setVolume(0);
      if (play) await c.play();
      return c;
    } catch (_) {
      await c.dispose();
      return null;
    }
  }

  /// 새 컨트롤러를 열기 **전에** 감정 슬롯을 비운다 — 4번째를 만들지 않기 위해서다.
  ///
  /// ## 왜 필요한가 — 「열고 나서 나중에 해제」가 겹침을 만든다
  ///
  /// 교체 자리(`_swapIdle`·`_swapTalk`·감정 전환)는 전부 **새것을 먼저 열고 옛것을
  /// 페이드 뒤에 해제**한다. 그 규율 자체는 옳다(v6.4 가 그걸로 멈춤을 고쳤다).
  /// 그러나 그 340ms 동안 **컨트롤러가 하나 더 있다.** 감정 클립이 한 번이라도 뜬
  /// 뒤에는
  ///
  ///     idle + talk + emo + (새로 여는 것) = **4개**
  ///
  /// 가 되어 하드 한계(2~3개)를 넘는다. 통화 초반에는 감정이 아직 없어 3개라 멀쩡하고,
  /// **감정이 한 번 뜬 뒤부터** 교체마다 4개가 된다 — 「하다가 중간에 멈춘다」의 형태다.
  ///
  /// ⇒ 감정은 **선택적인 층**이다(없어도 talk 가 화면을 채운다). 자리가 모자라면 감정을
  ///   먼저 내린다. 다음 발화에서 다시 열리고, 그때는 idle+talk+emo = 3 이다.
  ///
  /// ⛔ 트리에서 뺀 **다음 프레임에** 해제한다. 지금 그려지는 텍스처를 지우면 굳는다.
  Future<void> _freeEmoSlot(String why) async {
    // ⚠ 미뤄 둔 감정은 자리를 비우는 순간 무효다 — 그 감정이 가리키던 맥락이 사라졌다.
    _emoPending = null;
    if (_emoCache.isEmpty) return;
    _disarmEmoFinish();
    final stale = _emoCache.values.toList();
    _emoCache.clear();
    _emoCode = 0;
    _emo = null;
    if (mounted) {
      setState(() => _emoOpacity = 0);
      // ⛔ 위와 같은 이유 — 감정을 내린 순간부터 talk 이 멈춰 있다. 새 감정을 여는 데
      //   수백 ms 가 걸리므로 그 사이 화면이 정지 프레임이 된다.
      await _applyPlayback();
      // 참조를 끊은 뒤 한 프레임을 넘겨야 렌더러가 그 텍스처를 놓는다.
      await WidgetsBinding.instance.endOfFrame;
    }
    for (final c in stale) {
      await _release(c, why);
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
    widget.onDiag?.call('vid_talk', {'on': true, 'emo': _emoCode});
    if (kDebugMode) debugPrint('[avatar] TALK on (level ${widget.level.value})');
    // 컨트롤러는 이미 열려 있다 — 보이게 하고 재생만 켠다. 새 디코더도 seek도 없다.
    if (mounted) setState(() => _talkOpacity = 1);
    _applyPlayback();
    _syncEmotionLayer();
  }

  void _stopTalking() {
    _talking = false;
    // ⚠ 여기서 `_emoOpacity` 가 **0 으로 뚝 떨어진다**(페이드 없음). 감정 클립이
    //   `loop:true` 라 같은 동작을 반복하다 이 지점에서 잘리는 것이, 사장님이 보신
    //   「웃다가 갑자기 멈춘다」의 그 순간이다. 고치지 않고 **시각만 남긴다** —
    //   증상과 시각이 붙어야 처방을 고를 수 있다.
    widget.onDiag?.call('vid_talk', {'on': false, 'emo': _emoCode});
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
  ///
  /// ⭐ 열기 **전에** [_freeEmoSlot] 으로 자리를 만든다. 이 교체는 턴마다 세 번
  ///   일어나므로(대기→듣기→생각→대기), 겹침을 그대로 두면 감정이 한 번 뜬 뒤부터
  ///   **매 턴 세 번씩** 한계를 넘는다.
  Future<void> _swapIdle(int kind) async {
    if (kind == _idleKind || _idleSwapping || !_ready) return;
    final name = _idleAsset[kind];
    if (name == null) return;
    _idleSwapping = true;
    await _flushRetiring('idle 교체');
    await _freeEmoSlot('idle 교체 자리 확보');
    final next = await _open(name, loop: true, play: false);
    _idleSwapping = false;
    if (next == null) return; // 그 캐릭터엔 해당 대기 자산이 없다 — 쓰던 것을 유지한다.
    if (!mounted) {
      await _release(next, 'idle 교체 중 unmount');
      return;
    }
    final stale = _idle;
    setState(() {
      _idle = next;
      _idleKind = kind;
    });
    // ⛔⛔ **`_applyPlayback` 앞이다.** 예전엔 뒤에 있었고, 그 사이(재생 상태를 세 컨트롤러에
    //   적용하는 await 여러 번)에 감정이 열리면 **디코더가 4개**가 됐다 —
    //   idle옛것 + idle새것 + talk + 감정. 실측 call 1211 에서 5회:
    //       +1 → 3 (idle_listen) → +1 → 4 (emo_sad) ⛔ → -1 → 3 (idle 옛것)
    //   그 창에서는 옛것이 아직 [_retiring] 에 **들어가기 전**이라 감정 경로의
    //   `_flushRetiring` 이 비울 것을 못 찾았다.
    // ⭐ 여기로 옮기면 창이 사라진다. 안전한 이유: `setState` 로 `_idle` 이 이미 새것을
    //   가리키므로 `stale` 은 **트리에서 빠졌고**, `_applyPlayback` 도 `stale` 을 안 만진다.
    //   ⛔ v6.4 의 금지(«그려지는 중»인 것을 즉시 해제하지 마라)는 그대로다 —
    //     `_retire` 는 즉시 해제가 아니라 **페이드 뒤 해제**를 예약할 뿐이다.
    _retire(stale, 'idle 옛것');
    await _applyPlayback();
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
    await _flushRetiring('talk 교체');
    await _freeEmoSlot('talk 교체 자리 확보');
    final next = await _open(name, loop: true, play: false);
    _talkSwapping = false;
    if (next == null) return; // 그 캐릭터엔 해당 템포 자산이 없다 — 쓰던 것을 유지한다.
    if (!mounted) {
      await _release(next, 'talk 교체 중 unmount');
      return;
    }
    final stale = _talk;
    setState(() {
      _talk = next;
      _talkTempo = tempo;
    });
    // ⛔ 위 [_swapIdle] 과 같은 이유 — 옛것을 대기열에 **먼저** 넣는다.
    //   (지금은 autoTempo 가 꺼져 있어 이 경로가 안 돌지만, 켜는 순간 같은 병이 난다.)
    _retire(stale, 'talk 옛것');
    await _applyPlayback();
  }

  void _onEmotion() {
    if (!_ready) return;
    _syncEmotionLayer();
  }

  /// 앞 감정을 여는 동안 도착한 **가장 최근** 감정. 없으면 null.
  ///
  /// ⛔ 큐가 아니라 **한 칸**이다 — 표정은 누적값이 아니라 현재 상태다.
  int? _emoPending;

  /// 미뤄 둔 감정이 있으면 지금 적용한다.
  ///
  /// ⚠ 위젯의 **현재** 값과 다를 때만 돈다. 그 사이 서버가 또 바꿨다면
  ///   `widget.emotion` 쪽이 최신이고, 그건 [_onEmotion] 이 이미 처리했다.
  Future<void> _drainPendingEmo() async {
    final pending = _emoPending;
    _emoPending = null;
    if (pending == null || pending == _emoCode) return;
    await _syncEmotionLayer();
  }

  /// 지금 감시 중인 감정 클립과 그 리스너(중복 등록 방지용 참조).
  VideoPlayerController? _emoWatched;
  VoidCallback? _emoFinishWatch;

  /// 감정 클립이 **끝까지 재생되면** 스스로 내려가고 말하는 얼굴로 돌아간다.
  ///
  /// ⛔ `loop:false` 와 한 몸이다. 루프만 끄면 클립이 **마지막 프레임에 얼어붙어**
  ///   그 턴 내내 남는다 — 반복되던 것이 정지 화면으로 바뀔 뿐 나아지지 않는다.
  /// ⚠ 타이머로 재지 않는다. 클립 길이는 캐릭터·감정마다 다르고 디코더가 늦으면
  ///   실제 재생이 더 걸린다. **컨트롤러가 알려주는 위치**가 유일하게 맞는 근거다.
  void _armEmoFinish(VideoPlayerController c) {
    _disarmEmoFinish();
    void onTick() {
      final v = c.value;
      if (!v.isInitialized) return;
      final dur = v.duration;
      if (dur <= Duration.zero) return;
      // 마지막 프레임 언저리에서 판정한다 — position 이 duration 에 정확히 안 닿는다.
      if (v.position < dur - const Duration(milliseconds: 80)) return;
      _disarmEmoFinish();
      widget.onDiag?.call('vid_emo_end', {'code': _emoCode});
      if (!mounted) return;
      // 감정만 내린다. talk 은 [_applyPlayback] 이 다시 켠다 — 그게 「말하는 얼굴」이다.
      setState(() => _emoOpacity = 0);
      unawaited(_applyPlayback());
    }
    _emoWatched = c;
    _emoFinishWatch = onTick;
    c.addListener(onTick);
  }

  void _disarmEmoFinish() {
    final w = _emoWatched;
    final f = _emoFinishWatch;
    _emoWatched = null;
    _emoFinishWatch = null;
    if (w != null && f != null) {
      try {
        w.removeListener(f);
      } catch (_) {
        // 이미 해제된 컨트롤러 — 무시한다(R5).
      }
    }
  }

  /// Loads (once) and shows the clip for the current emotion while talking.
  Future<void> _syncEmotionLayer() async {
    if (!_ready) return; // don't contend with the idle/talk decoders warming up
    final code = widget.emotion.value;
    final name = _emoAsset[code];
    // [SyncAvatar.silentEmotion] 이면 발화 없이도 연다 — 학습 반응 밴드는 무음이다.
    final gated = !_talking && !widget.silentEmotion;
    if (gated || name == null) {
      if (_emoOpacity != 0 && mounted) {
        setState(() => _emoOpacity = 0);
        // ⛔⛔ **여기서 talk 을 다시 켜야 한다.** [_applyPlayback] 이 감정을 보일 때
        //   talk 을 `pause()` 해 두기 때문에(showTalk = _talking && !showEmo),
        //   감정만 숨기면 그 밑에서 **멈춘 프레임**이 드러난다 — 소리는 계속 나는데
        //   입이 안 움직인다. 사장님 실측: "표정 하고 갑자기 표정이 사라질 때가 있다,
        //   표정 다 했으면 무표정이 아니라 말하는 표정이어야 하잖아"(2026-08-26).
        // ⚠ 다시 켜는 곳이 [_startTalking]·[_stopTalking]·새 감정 열기 셋뿐이라,
        //   `neutral` 마커부터 **그 턴이 끝날 때까지** 얼어 있었다(실측 8~13초).
        await _applyPlayback();
      }
      return;
    }
    if (_emoCode != code || _emo == null) {
      var next = _emoCache[code];
      if (next == null) {
        if (_emoLoading) {
          // ⭐ **버리지 않고 미룬다.** 예전엔 그냥 반환해서 그 감정이 영영 안 떴다 —
          //   앞 감정을 여는 데 수백 ms 가 걸리므로, 그 사이 온 마커는 전부 사라졌다.
          // ⛔ 큐로 쌓지 않는다. 표정은 **누적되는 값이 아니라 현재 상태**라, 밀린 것을
          //   차례로 다 트는 것은 틀린 그림이다(happy→sad→happy 를 다 재생하면 마지막
          //   문장에서 엉뚱한 얼굴이 남는다). ⇒ **최신 하나만** 들고 있다가 잇는다.
          _emoPending = code;
          widget.onDiag?.call('vid_emo_defer', {'code': code});
          return;
        }
        _emoLoading = true;
        // ★감정은 **한 개만** 살려 둔다. 캐시를 쌓으면 idle·talk 까지 더해 디코더가
        // 최대 6개가 되고, 하드웨어 한계(2~3개)를 넘어 화면이 얼었다(2026-08-02 S8).
        //
        // ⛔ 예전엔 새것을 **먼저 열고** 옛것을 페이드 뒤에 해제했다. 해제 순서는 옳았지만
        //   (v6.4) 그 340ms 동안 idle + talk + 옛감정 + 새감정 = **4개**가 됐다.
        //   ⇒ 옛 감정을 **먼저 내리고**(트리에서 뺀 뒤 다음 프레임에 해제) 그다음에 연다.
        //   그 사이 화면은 talk 이 채운다 — 같은 발화의 기본 클립이라 튀지 않는다.
        await _freeEmoSlot('감정 교체 자리 확보');
        // ⛔ **대기 중인 옛것도 비운다.** `_freeEmoSlot` 은 감정 캐시만 치우므로,
        //   직전에 idle 을 갈아끼웠다면 그 옛 컨트롤러가 아직 [_retiring] 에 있다
        //   ⇒ idle + talk + idle옛것 + 새감정 = **4개**. 하드 한계 2~3 초과다.
        //   실측 call 1207 의 `decoder +1 → 4 ⛔한계초과` 2회가 정확히 이 자리다:
        //     decoder +1 → 3 (idle_listen) → TALK on → +1 → 4 (emo_happy) ⛔
        //     → -1 → 3 (idle 옛것)          ← 옛것이 그제서야 풀린다
        //   ⚠ `_swapIdle`·`_swapTalk` 은 이미 이걸 부른다(c37e8b4). **감정 경로만
        //     빠져 있었다** — 같은 수정에서 세 자리 중 하나를 놓친 것이다.
        await _flushRetiring('감정 열기');
        // ⛔ **loop:false 다.** 예전엔 `loop:true` 라 감정이 그 턴 내내 같은 동작을
        //   되풀이했다 — 사장님 실측: "웃다가 웃다가를 계속 반복하다가 문장이 끝날
        //   때도 있고"(2026-08-25). 감정은 **그 문장의 반응**이지 턴 전체의 상태가
        //   아니다. 한 번 보여주고 말하는 얼굴로 돌아간다.
        //   ⇒ happy → talk → sad → talk (사장님이 정한 모델, 2026-08-26)
        next = await _open(name, loop: false, play: true);
        _emoLoading = false;
        if (!mounted) {
          await _release(next, '감정 교체 중 unmount');
          return;
        }
        if (next == null) return;
        _emoCache[code] = next;
        _emo = next;
        _emoCode = code;
        widget.onDiag?.call('vid_emo', {'code': code, 'cached': false});
        _armEmoFinish(next);
        if (mounted) setState(() => _emoOpacity = 1);
        await _applyPlayback();
        // 여는 동안 다음 감정이 왔다면 지금 잇는다(위 [_emoPending] 참조).
        await _drainPendingEmo();
        return;
      }
      _emo = next;
      _emoCode = code;
      widget.onDiag?.call('vid_emo', {'code': code, 'cached': true});
    }
    final e = _emo;
    if (e == null) return;
    // ⭐ 캐시에서 다시 꺼낸 클립은 **끝에 멈춰 있다**(loop:false). 되감지 않으면
    //   같은 감정이 두 번째로 왔을 때 마지막 프레임 한 장만 보이고 끝난다.
    try {
      await e.seekTo(Duration.zero);
    } catch (_) {
      // 이미 정리된 컨트롤러 — 아래 _applyPlayback 이 걸러 낸다.
    }
    _armEmoFinish(e);
    if (mounted) setState(() => _emoOpacity = 1);
    await _applyPlayback();
  }

  @override
  void dispose() {
    _disarmEmoFinish();
    widget.level.removeListener(_onLevel);
    widget.speaking.removeListener(_onLevel);
    widget.emotion.removeListener(_onEmotion);
    widget.tempo?.removeListener(_onTempo);
    widget.idleKind?.removeListener(_onIdleKind);
    _stopTimer?.cancel();
    // ⛔ [_release] 로 해제한다 — 셈이 [_decoders] 하나로 모여야 다음 통화의 시작값이
    //   0 이 된다. 여기서만 `dispose()` 를 직접 부르면 통화를 걸 때마다 셈이 남아
    //   두 번째 통화부터 「한계초과」가 거짓으로 뜬다(계측이 스스로 거짓말을 한다).
    // ⛔ [_retiring] 도 같이 비운다. 통화를 끊는 순간 대기 중이던 옛것이 남아 있으면
    //   그 타이머는 위젯이 사라진 뒤에 돌고, 그때까지 디코더를 물고 있다.
    final leaving = <VideoPlayerController?>[
      _idle,
      _talk,
      ..._emoCache.values,
      ..._retiring,
    ];
    _retiring.clear();
    _idle = null;
    _talk = null;
    _emo = null; // _emo 는 캐시를 가리키므로 목록에 또 넣지 않는다(중복 해제 방지)
    _emoCache.clear();
    for (final c in leaving) {
      unawaited(_release(c, '위젯 해제'));
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
