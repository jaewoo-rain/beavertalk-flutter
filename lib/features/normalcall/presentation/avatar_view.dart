import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

/// Emotion codes shared by the controller (transcript classifier) and this
/// renderer. 0 = neutral/smug (the resting face), 1..4 map to sprite files.
const int kEmotionNeutral = 0;
const int kEmotionHappy = 1;
const int kEmotionSurprised = 2;
const int kEmotionSad = 3;
const int kEmotionAngry = 4;

/// Emotion code → sprite file stem within the character's asset dir.
const Map<int, String> _emotionStem = {
  kEmotionHappy: 'e_happy',
  kEmotionSurprised: 'e_surprised',
  kEmotionSad: 'e_sad',
  kEmotionAngry: 'e_angry',
};

/// Returns the avatar sprite asset dir for a character, or null when the
/// character has no rigged sprite set (→ caller falls back to a static image).
///
/// Currently only characters with a generated sprite set under
/// `assets/avatar/<key>/` are listed here; add a key when its sprites ship.
String? avatarAssetDirFor(int? characterId, String? name) {
  // ⭐ **이름으로 매핑한다. id 는 쓰지 않는다.**
  //
  // 옛 코드는 `characterId` 를 1순위로 썼는데, 서버의 캐릭터 id 가 **환경마다 다르다**:
  //     prod: 1 BABA · 2 BIBI ·  9 Popo · 10 Rara · 11 Dudu
  //     dev : 1 BABA · 2 BIBI ·  3 Popo ·  4 Rara ·  5 Dudu
  // prod 기준으로 하드코딩하면 dev 에서 Popo 가 Rara 영상을 연다. 서버에 캐릭터가
  // 추가·재배치돼도 앱이 조용히 틀린 얼굴을 고른다.
  //
  // 이름은 그 캐릭터의 정체성이라 환경이 바뀌어도 안 흔들린다. 서버 IAP 상품 매핑도
  // 같은 이유로 id 대신 이름으로 조회한다(iap_catalog.resolve).
  //
  // 서버 표기가 'BABA'/'Baba' 로 섞여 있어 **대소문자 무시**로 맞춘다. 한국어 표기는
  // CallKit·알람 페이로드가 현지화된 이름을 실어 보낼 때를 위한 보조.
  const byName = <String, String>{
    'baba': 'baba', '바바': 'baba',
    'bibi': 'bibi', '비비': 'bibi',
    'popo': 'popo', '포포': 'popo',
    'rara': 'rara', '라라': 'rara',
    'dudu': 'dudu', '두두': 'dudu',
  };

  final n = (name ?? '').trim().toLowerCase();
  if (n.isEmpty) return null;   // 이름을 모르면 정적 이미지 폴백(틀린 얼굴보다 낫다)

  // 정확히 일치 먼저 — 부분 일치는 다른 이름을 잘못 삼킬 수 있다.
  final exact = byName[n];
  if (exact != null) return 'assets/avatar/$exact';

  // "비비 선생님" 처럼 수식어가 붙은 경우를 위한 부분 일치.
  for (final e in byName.entries) {
    if (n.contains(e.key)) return 'assets/avatar/${e.value}';
  }
  return null;
}

/// Real-time talking-avatar renderer for a call character.
///
/// Design (see docs/2026-07-23_2106_영상통화-아바타-립싱크-플랜.md):
/// Gemini Live returns raw PCM with no viseme/phoneme timing, so the mouth is
/// driven by the audio **envelope** and the expression by the **transcript**.
/// The controller publishes `level` (0=closed..1=wide, from the PCM about to
/// play), `speaking`, and `emotion` (from a keyword classifier on the beaver's
/// line). This widget cross-fades a pre-rendered mouth ramp by `level`, overlays
/// an emotion frame between phrases (it yields to the talking mouth as `level`
/// rises), and adds idle blinks + breathing. Sprites are generated once and ship
/// as static assets, so it runs fully offline at 60fps.
class BeaverAvatar extends StatefulWidget {
  /// Creates the talking avatar for the sprite set under [assetDir].
  const BeaverAvatar({
    super.key,
    required this.assetDir,
    required this.level,
    required this.speaking,
    required this.emotion,
    required this.shape,
  });

  /// Sprite asset directory, e.g. `assets/avatar/baba` (see [avatarAssetDirFor]).
  final String assetDir;

  /// Live mouth-open target, 0 (closed) .. 1 (wide). ~10Hz; smoothed to 60fps.
  final ValueListenable<double> level;

  /// True while the character is speaking (gates blink cadence).
  final ValueListenable<bool> speaking;

  /// Current emotion code (see the k* constants). Drives the expression overlay.
  final ValueListenable<int> emotion;

  /// Mouth shape, −1 (round OO) .. 0 (AH) .. +1 (wide EE). Used only when the
  /// character ships `v_oo`/`v_ee` sprites; otherwise ignored (open/close ramp).
  final ValueListenable<double> shape;

  @override
  State<BeaverAvatar> createState() => _BeaverAvatarState();
}

class _BeaverAvatarState extends State<BeaverAvatar>
    with SingleTickerProviderStateMixin {
  final List<ui.Image?> _mouth = List<ui.Image?>.filled(4, null);
  ui.Image? _blink;
  final Map<int, ui.Image> _emotion = {};
  // Region masks (RGBA alpha): where the mouth moves / where expressions change.
  // Drive region-only compositing so the mouth (lip-sync) and eyes (emotion)
  // animate independently over a stable base face — no whole-frame ghosting.
  ui.Image? _maskMouth;
  ui.Image? _maskEyes;
  // Optional vowel-shape sprites (round OO / wide EE). When present the mouth
  // forms shapes; when absent it falls back to the open/close ramp (v0..v3).
  ui.Image? _mouthOO;
  ui.Image? _mouthEE;
  // Dense RIFE-interpolated open ramp (m0 closed .. mN wide). When present the
  // mouth plays as a smooth flipbook (true frame interpolation, no dissolve).
  final List<ui.Image> _ramp = [];
  // Body-idle loop frames (b0..bN, RIFE-interpolated). When present the base
  // face animates a subtle body idle; the mouth/eyes overlays ride on top.
  final List<ui.Image> _body = [];
  bool _loaded = false;

  late final Ticker _ticker;
  final _painterState = _PainterState();
  final _repaint = ValueNotifier<int>(0);

  final _rng = math.Random();
  Duration _last = Duration.zero;
  double _nextBlinkSec = 2.5;
  double _blinkT = 0;
  double _elapsedSec = 0;

  static const double _blinkDur = 0.14;

  @override
  void initState() {
    super.initState();
    _loadSprites();
    _ticker = createTicker(_onTick)..start();
  }

  Future<void> _loadSprites() async {
    final dir = widget.assetDir;
    for (var i = 0; i < 4; i++) {
      _mouth[i] = await _tryDecode('$dir/v$i.png');
    }
    _blink = await _tryDecode('$dir/blink.png');
    for (final entry in _emotionStem.entries) {
      final img = await _tryDecode('$dir/${entry.value}.png');
      if (img != null) _emotion[entry.key] = img;
    }
    _maskMouth = await _tryDecode('$dir/mask_mouth.png');
    _maskEyes = await _tryDecode('$dir/mask_eyes.png');
    _mouthOO = await _tryDecode('$dir/v_oo.png');
    _mouthEE = await _tryDecode('$dir/v_ee.png');
    // Dense open ramp m0..mN (as many as ship); stop at the first gap.
    for (var i = 0; i < 24; i++) {
      final img = await _tryDecode('$dir/m$i.png');
      if (img == null) break;
      _ramp.add(img);
    }
    for (var i = 0; i < 48; i++) {
      final img = await _tryDecode('$dir/b$i.png');
      if (img == null) break;
      _body.add(img);
    }
    if (mounted) setState(() => _loaded = _mouth[0] != null);
  }

  /// Decodes an asset image, or returns null if it is absent (a character may
  /// ship a partial sprite set — missing frames are simply skipped).
  Future<ui.Image?> _tryDecode(String asset) async {
    try {
      final data = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      return null;
    }
  }

  void _onTick(Duration elapsed) {
    final dt = _last == Duration.zero
        ? 0.016
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _elapsedSec += dt;

    // Smooth the coarse (~10Hz) RMS target into fluid motion; open fast, close
    // a touch slower so the mouth reads as speech, not strobe.
    final target = widget.level.value.clamp(0.0, 1.0);
    final cur = _painterState.level;
    _painterState.level += (target - cur) * (target > cur ? 0.45 : 0.22);

    // Ease the emotion-overlay presence toward the current emotion.
    _painterState.emotion = widget.emotion.value;
    final emoTarget = _painterState.emotion == kEmotionNeutral ? 0.0 : 1.0;
    _painterState.emoPresence +=
        (emoTarget - _painterState.emoPresence) * 0.12;

    // Blink scheduler on a randomized cadence.
    if (_blinkT > 0) {
      _blinkT -= dt;
    } else if (_elapsedSec >= _nextBlinkSec) {
      _blinkT = _blinkDur;
      final speaking = widget.speaking.value;
      _nextBlinkSec = _elapsedSec +
          (speaking ? 3.5 : 2.2) + _rng.nextDouble() * (speaking ? 4.0 : 3.0);
    }
    final bt = (_blinkT / _blinkDur).clamp(0.0, 1.0);
    _painterState.blink = 1.0 - (2.0 * bt - 1.0).abs();

    // Gentle idle breathing.
    _painterState.breathe = math.sin(_elapsedSec * 1.6) * 0.012;

    // Mouth vowel shape (OO..AH..EE), smoothed.
    _painterState.shape +=
        (widget.shape.value.clamp(-1.0, 1.0) - _painterState.shape) * 0.3;

    // Head micro-motion: slow idle sway/tilt + a subtle nod on speech, so the
    // avatar reads as alive, not a poster with a moving mouth.
    _painterState.headRot = math.sin(_elapsedSec * 0.55) * 0.020 +
        math.sin(_elapsedSec * 1.3) * 0.006;
    _painterState.headDx = math.sin(_elapsedSec * 0.43) * 0.010;
    _painterState.headDy =
        math.sin(_elapsedSec * 0.9) * 0.006 + _painterState.level * 0.016;

    // Subtle chest breathing (vertical scale, 1.0 → ~1.016 and back).
    _painterState.bodyBreath = (math.sin(_elapsedSec * 0.85) * 0.5 + 0.5) * 0.016;

    // Body-idle loop (when body frames ship): a slow ~6s ping-pong so the torso
    // and arms drift subtly, appropriate for a video call.
    if (_body.length >= 2) {
      final phase = (_elapsedSec / 6.0) % 1.0;
      final tri = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
      final pos = tri * (_body.length - 1);
      _painterState.bodyFrame = pos.floor().clamp(0, _body.length - 2);
      _painterState.bodyBlend = pos - _painterState.bodyFrame;
    }

    _repaint.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    for (final im in _mouth) {
      im?.dispose();
    }
    _blink?.dispose();
    for (final im in _emotion.values) {
      im.dispose();
    }
    _maskMouth?.dispose();
    _maskEyes?.dispose();
    _mouthOO?.dispose();
    _mouthEE?.dispose();
    for (final im in _ramp) {
      im.dispose();
    }
    for (final im in _body) {
      im.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.expand();
    return RepaintBoundary(
      child: CustomPaint(
        painter: _BeaverPainter(
          mouth: _mouth,
          blink: _blink,
          emotion: _emotion,
          maskMouth: _maskMouth,
          maskEyes: _maskEyes,
          mouthOO: _mouthOO,
          mouthEE: _mouthEE,
          ramp: _ramp,
          body: _body,
          state: _painterState,
          repaint: _repaint,
        ),
        size: Size.infinite,
      ),
    );
  }
}

/// Mutable frame state shared between the ticker and painter (avoids rebuilding
/// the tree at 60fps; the painter repaints off its [Listenable]).
class _PainterState {
  double level = 0; // smoothed mouth-open 0..1
  double blink = 0; // 0..1 blink envelope
  double breathe = 0; // small +/- scale
  int emotion = 0; // current emotion code
  double emoPresence = 0; // eased 0..1 presence of the emotion overlay
  double shape = 0; // smoothed mouth shape −1 (OO) .. 0 (AH) .. +1 (EE)
  double headRot = 0; // head tilt (radians)
  double headDx = 0; // head sway x (fraction of size)
  double headDy = 0; // head bob y (fraction of size)
  double bodyBreath = 0; // subtle chest/body breathing (vertical scale delta)
  int bodyFrame = 0; // current body-idle frame index (when body frames ship)
  double bodyBlend = 0; // cross-fade fraction to bodyFrame+1
}

class _BeaverPainter extends CustomPainter {
  _BeaverPainter({
    required this.mouth,
    required this.blink,
    required this.emotion,
    required this.maskMouth,
    required this.maskEyes,
    required this.mouthOO,
    required this.mouthEE,
    required this.ramp,
    required this.body,
    required this.state,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<ui.Image?> mouth;
  final ui.Image? blink;
  final Map<int, ui.Image> emotion;
  final ui.Image? maskMouth;
  final ui.Image? maskEyes;
  final ui.Image? mouthOO;
  final ui.Image? mouthEE;
  final List<ui.Image> ramp;
  final List<ui.Image> body;
  final _PainterState state;

  @override
  void paint(Canvas canvas, Size size) {
    final base = mouth[0];
    if (base == null) return;
    // Clip so cover-fit overflow (square sprite in a non-square band) is cropped.
    canvas.clipRect(Offset.zero & size);

    final level = state.level.clamp(0.0, 1.0);
    final sw = base.width.toDouble();
    final sh = base.height.toDouble();

    // Cover-fit + idle breathing: map the sprite space (sw×sh) so it covers the
    // box, centered, with a subtle breathing scale. Everything below is drawn in
    // sprite coordinates; masks (same geometry) align exactly.
    // Head micro-motion around a pivot near the neck (center-bottom): sway,
    // tilt and a speech nod, applied before the cover-fit so the whole face
    // moves together and reads as alive.
    canvas.save();
    final px = size.width / 2 + state.headDx * size.width;
    final py = size.height * 0.9;
    canvas.translate(px, py + state.headDy * size.height);
    canvas.rotate(state.headRot);
    canvas.translate(-px, -py);

    // Body breathing: subtle vertical expansion anchored near the belly, so the
    // chest rises/falls. Applied to the whole composite → masks stay aligned.
    final by = size.height * 0.80;
    canvas.translate(0, by);
    canvas.scale(1.0, 1.0 + state.bodyBreath);
    canvas.translate(0, -by);

    // Cover-fit + idle breathing.
    final cover = math.max(size.width / sw, size.height / sh);
    final scale = cover * (1.0 + state.breathe);
    final dw = sw * scale;
    final dh = sh * scale;
    canvas.translate((size.width - dw) / 2, (size.height - dh) / 2);
    canvas.scale(scale, scale);
    final rect = Rect.fromLTWH(0, 0, sw, sh);

    // 1) Base — the subtle body-idle loop (torso/arms drift) when body frames
    //    ship, else the still closed face. Drawn once (never globally blended).
    if (body.length >= 2) {
      final bf = state.bodyFrame.clamp(0, body.length - 2);
      _img(canvas, body[bf], rect, 1.0);
      if (state.bodyBlend > 0) _img(canvas, body[bf + 1], rect, state.bodyBlend);
    } else {
      _img(canvas, base, rect, 1.0);
    }

    // 2) Mouth region only (masked, so the rest of the face is untouched).
    final mm = maskMouth;
    final oo = mouthOO;
    final ee = mouthEE;
    if (mm != null && ramp.length >= 2) {
      // Dense RIFE-interpolated flipbook: pick the two nearest frames and light
      // cross-fade. Adjacent frames are true in-betweens (near-identical), so
      // this is smooth, not a dissolve. Masked to the mouth region.
      final pos = level * (ramp.length - 1);
      final i = pos.floor().clamp(0, ramp.length - 2);
      final frac = (pos - i).clamp(0.0, 1.0);
      canvas.saveLayer(rect, Paint());
      _img(canvas, ramp[i], rect, 1.0);
      if (frac > 0) _img(canvas, ramp[i + 1], rect, frac);
      _applyMask(canvas, mm, rect);
      canvas.restore();
    } else if (mm != null && oo != null && ee != null) {
      // Vowel-shape model: base(closed) → an open-vowel frame at opacity=level.
      // The open frame morphs AH → OO (round) / EE (wide) by [shape].
      final ah = mouth[mouth.length - 1] ?? base;
      final shape = state.shape.clamp(-1.0, 1.0);
      canvas.saveLayer(rect, Paint());
      _img(canvas, ah, rect, level);
      if (shape < 0) {
        _img(canvas, oo, rect, level * (-shape));
      } else if (shape > 0) {
        _img(canvas, ee, rect, level * shape);
      }
      _applyMask(canvas, mm, rect);
      canvas.restore();
    } else if (mm != null) {
      // Open/close ramp (no shape sprites), masked.
      final pos = level * (mouth.length - 1);
      final i = pos.floor().clamp(0, mouth.length - 2);
      final frac = (pos - i).clamp(0.0, 1.0);
      canvas.saveLayer(rect, Paint());
      _img(canvas, mouth[i], rect, 1.0);
      if (frac > 0) _img(canvas, mouth[i + 1], rect, frac);
      _applyMask(canvas, mm, rect);
      canvas.restore();
    } else {
      // No mask → whole-frame ramp fallback.
      final pos = level * (mouth.length - 1);
      final i = pos.floor().clamp(0, mouth.length - 2);
      final frac = (pos - i).clamp(0.0, 1.0);
      _img(canvas, mouth[i], rect, 1.0);
      if (frac > 0) _img(canvas, mouth[i + 1], rect, frac);
    }

    // 3) Eyes/brow region only: emotion + blink, masked so the mouth (lip-sync)
    //    is untouched → the beaver talks AND emotes at the same time.
    final me = maskEyes;
    final emoImg = emotion[state.emotion];
    if (me != null) {
      if (emoImg != null && state.emoPresence > 0.01) {
        canvas.saveLayer(rect, Paint());
        _img(canvas, emoImg, rect, state.emoPresence.clamp(0.0, 1.0));
        _applyMask(canvas, me, rect);
        canvas.restore();
      }
      if (state.blink > 0.01 && blink != null) {
        canvas.saveLayer(rect, Paint());
        _img(canvas, blink!, rect, state.blink.clamp(0.0, 1.0));
        _applyMask(canvas, me, rect);
        canvas.restore();
      }
    } else {
      // No mask → old whole-frame overlay (emotion yields to the talking mouth).
      if (emoImg != null && state.emoPresence > 0.01) {
        _img(canvas, emoImg, rect, state.emoPresence * (1.0 - level));
      }
      if (state.blink > 0.01 && blink != null) {
        _img(canvas, blink!, rect, state.blink);
      }
    }

    canvas.restore();
  }

  /// Draws [img] into [dst] (sprite space) at [opacity].
  void _img(Canvas canvas, ui.Image? img, Rect dst, double opacity) {
    if (img == null) return;
    final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    canvas.drawImageRect(
      img,
      src,
      dst,
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(0, 0, 0, opacity.clamp(0.0, 1.0)),
    );
  }

  /// Keeps only the region where [mask]'s alpha is set (feathered), using
  /// `dstIn` — call inside a `saveLayer` right after drawing the content.
  void _applyMask(Canvas canvas, ui.Image mask, Rect dst) {
    final src = Rect.fromLTWH(0, 0, mask.width.toDouble(), mask.height.toDouble());
    canvas.drawImageRect(
      mask,
      src,
      dst,
      Paint()..blendMode = BlendMode.dstIn,
    );
  }

  @override
  bool shouldRepaint(covariant _BeaverPainter oldDelegate) => false;
}
