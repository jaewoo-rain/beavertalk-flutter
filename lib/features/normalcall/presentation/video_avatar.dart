import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import 'avatar_view.dart'
    show kEmotionHappy, kEmotionSurprised, kEmotionSad, kEmotionAngry;

/// Neural talking-avatar renderer: a small state machine over seamless,
/// neural-generated video loops that cross-fade into each other so the beaver
/// **listens** (idle), **speaks** (talk), and **reacts** to what it says
/// (emotion-specific talk clips), with the frames flowing naturally between
/// states.
///
/// Clips live under [assetDir]:
/// - `idle.mp4`   — listening (not speaking)
/// - `talk.mp4`   — speaking (neutral)
/// - `talk_happy.mp4` / `talk_surprised.mp4` / `talk_sad.mp4` / `talk_angry.mp4`
///   — speaking while reacting (optional; a missing one falls back to `talk`)
///
/// All clips start and end on the same base pose, so a cross-fade between any
/// two reads as one continuous character. At most two decoders are live (the
/// shown clip + the one fading in), staying within mobile decoder limits.
///
/// Shows [fallback] until the first clip is ready (and if none load).
class VideoAvatar extends StatefulWidget {
  /// Creates the video avatar for the clips under [assetDir].
  const VideoAvatar({
    super.key,
    required this.assetDir,
    required this.speaking,
    required this.emotion,
    this.fallback,
  });

  /// Asset dir holding the clips (e.g. `assets/avatar/baba`).
  final String assetDir;

  /// True while the character is speaking → talk (else idle).
  final ValueListenable<bool> speaking;

  /// Current emotion code (avatar_view k* constants) → reacting talk clip.
  final ValueListenable<int> emotion;

  /// Shown until the first clip is ready (and if none load).
  final Widget? fallback;

  @override
  State<VideoAvatar> createState() => _VideoAvatarState();
}

class _VideoAvatarState extends State<VideoAvatar> {
  /// Clip keys that failed to load (asset absent) → don't retry; map to `talk`.
  final Set<String> _missing = {};

  VideoPlayerController? _front; // visible clip
  String? _frontKey;
  VideoPlayerController? _back; // clip fading in over the front
  String? _backKey;
  double _backOpacity = 0;

  bool _ready = false;
  bool _failed = false;
  bool _transitioning = false;

  @override
  void initState() {
    super.initState();
    widget.speaking.addListener(_onSignal);
    widget.emotion.addListener(_onSignal);
    _init();
  }

  String _emotionKey(int e) {
    switch (e) {
      case kEmotionHappy:
        return 'talk_happy';
      case kEmotionSurprised:
        return 'talk_surprised';
      case kEmotionSad:
        return 'talk_sad';
      case kEmotionAngry:
        return 'talk_angry';
      default:
        return 'talk';
    }
  }

  /// The clip that should show for the current signals, mapping any clip already
  /// known missing down to `talk`.
  String _desiredKey() {
    if (!widget.speaking.value) return 'idle';
    final emo = _emotionKey(widget.emotion.value);
    return _missing.contains(emo) ? 'talk' : emo;
  }

  Future<void> _init() async {
    // Prefer idle as the first clip; fall back to talk.
    for (final key in const ['idle', 'talk']) {
      final c = await _tryOpen(key);
      if (c != null) {
        _front = c;
        _frontKey = key;
        if (mounted) setState(() => _ready = true);
        _onSignal();
        return;
      }
    }
    if (mounted) setState(() => _failed = true);
  }

  /// Opens + starts a looping muted clip, or returns null if its asset is absent.
  Future<VideoPlayerController?> _tryOpen(String key) async {
    final c = VideoPlayerController.asset('${widget.assetDir}/$key.mp4');
    try {
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      return c;
    } catch (_) {
      _missing.add(key);
      await c.dispose();
      return null;
    }
  }

  /// Signals changed → cross-fade to the desired clip if it isn't already shown.
  Future<void> _onSignal() async {
    if (!_ready || _transitioning) return;
    var target = _desiredKey();
    if (target == _frontKey) return;
    _transitioning = true;
    try {
      var next = await _tryOpen(target);
      // Emotion clip absent → fall back to neutral talk.
      if (next == null && target != 'talk' && target != 'idle') {
        target = 'talk';
        if (target == _frontKey) return;
        next = await _tryOpen(target);
      }
      if (next == null) return;
      if (!mounted) {
        await next.dispose();
        return;
      }
      setState(() {
        _back = next;
        _backKey = target;
        _backOpacity = 0;
      });
      await Future<void>.delayed(const Duration(milliseconds: 16));
      if (mounted) setState(() => _backOpacity = 1);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final old = _front;
      if (mounted) {
        setState(() {
          _front = _back;
          _frontKey = _backKey;
          _back = null;
          _backKey = null;
        });
      }
      await old?.dispose();
    } finally {
      _transitioning = false;
      if (mounted && _desiredKey() != _frontKey) _onSignal();
    }
  }

  @override
  void dispose() {
    widget.speaking.removeListener(_onSignal);
    widget.emotion.removeListener(_onSignal);
    _front?.dispose();
    _back?.dispose();
    super.dispose();
  }

  Widget _cover(VideoPlayerController c) {
    final size = c.value.size;
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || !_ready || _front == null) {
      return widget.fallback ?? const SizedBox.expand();
    }
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _cover(_front!),
          if (_back != null)
            AnimatedOpacity(
              opacity: _backOpacity,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _cover(_back!),
            ),
        ],
      ),
    );
  }
}
