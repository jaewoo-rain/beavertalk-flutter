import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import 'avatar_view.dart'
    show kEmotionHappy, kEmotionSurprised, kEmotionSad, kEmotionAngry;

/// Video-call avatar built from neural clips that are *designed* to interlock.
///
/// Every clip is generated with the head locked and with its **first and last
/// frame pinned to the same base pose**, so any clip can follow any other with
/// no visible seam. Measured on the shipped clips: head/body difference between
/// clips 0.78/255, boundary frames 0.66–1.21/255 — i.e. the heads are the same
/// picture, only the face animates.
///
/// - `idle.mp4`  — listening: mouth closed, blinks, breathing. Always playing.
/// - `talk.mp4`  — speaking: mouth talking. Held **paused at frame 0** (mouth
///   closed) while silent, so the instant the voice is audible it starts from
///   the top with no seek latency, then loops seamlessly.
/// - `emo_*.mp4` — speaking with an emotion; loaded on demand and layered above
///   talk.
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

  /// Shown until the clips are ready (and if they fail to load).
  final Widget? fallback;

  @override
  State<SyncAvatar> createState() => _SyncAvatarState();
}

class _SyncAvatarState extends State<SyncAvatar> {
  VideoPlayerController? _idle;
  VideoPlayerController? _talk;
  VideoPlayerController? _emo;
  int _emoCode = 0;
  bool _emoLoading = false;

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

  static const Map<int, String> _emoAsset = {
    kEmotionHappy: 'emo_happy',
    kEmotionSurprised: 'emo_surprised',
    kEmotionSad: 'emo_sad',
    kEmotionAngry: 'emo_angry',
  };

  @override
  void initState() {
    super.initState();
    widget.level.addListener(_onLevel);
    widget.emotion.addListener(_onEmotion);
    widget.speaking.addListener(_onLevel);
    _load();
  }

  Future<void> _load() async {
    // Both clips run continuously. Starting a paused decoder costs 100–300ms on
    // Android, which is exactly the lag that made the picture switch late — so
    // nothing is ever paused; only opacity changes.
    _idle = await _open('idle', loop: true, play: true);
    _talk = await _open('talk', loop: true, play: true);
    if (!mounted) return;
    setState(() {
      _ready = _idle != null || _talk != null;
      _failed = !_ready;
      // Apply whatever state the voice already asked for while we were loading.
      if (_ready && _talking) _talkOpacity = 1;
    });
    if (_ready && _talking) _syncEmotionLayer();
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
    // The clip is already rolling — reveal it. No decoder start, no seek.
    if (mounted) setState(() => _talkOpacity = 1);
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
      if (_emoLoading) return;
      _emoLoading = true;
      final old = _emo;
      final next = await _open(name, loop: true, play: true);
      _emoLoading = false;
      if (!mounted) {
        await next?.dispose();
        return;
      }
      _emo = next;
      _emoCode = code;
      await old?.dispose();
      if (next == null) return;
    }
    final e = _emo;
    if (e == null) return;
    if (mounted) setState(() => _emoOpacity = 1);
  }

  @override
  void dispose() {
    widget.level.removeListener(_onLevel);
    widget.speaking.removeListener(_onLevel);
    widget.emotion.removeListener(_onEmotion);
    _stopTimer?.cancel();
    _idle?.dispose();
    _talk?.dispose();
    _emo?.dispose();
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
