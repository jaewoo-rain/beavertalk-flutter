import 'dart:math' as math;
import 'dart:typed_data';

/// 비버 자극음 — 에코를 일으키기 위해 스피커로 내보낼 신호.
///
/// ## 왜 순음(tone)이 아닌가
///
/// 플랫폼 AEC(Android AcousticEchoCanceler, Apple VPIO)는 **입력 신호에 적응**하는
/// 필터다. 정현파 하나를 내보내면 좁은 대역에 대해서만 수렴해서, 실제 대화에서보다
/// 훨씬 좋은(=낙관적인) 에코 감쇠가 나온다. 그 숫자로 서버 임계를 잡으면 실사용에서
/// 에코가 임계를 넘는다.
///
/// 그래서 음성에 가까운 신호를 만든다:
///   - **300~3400Hz 대역 제한** — 전화 대역. AEC 와 스피커가 실제로 다루는 범위
///   - **4Hz 음절 변조** — 사람 말의 음절 속도. AEC 가 겪는 진폭 변화를 흉내
///
/// ⚠ **진짜 무음 구간은 일부러 넣지 않는다**(변조 하한이 0.15 이지 0 이 아니다).
///   ④ 꼬리는 "재생이 멎은 뒤의 잔향"인데, 정지 시점은 리그가 정한다 — 자극음 안에
///   무음이 있으면 하필 그 구간에서 잘렸을 때 **잴 잔향 자체가 없어** 꼬리가 0 으로 나온다.
///   그래서 정지 순간까지 계속 소리가 나 있어야 한다. 실제 TTS 클립으로 교체할 때도
///   같은 제약이 걸린다.
///
/// ## ⚠ 그래도 실제 TTS 는 아니다
///
/// 이건 근사다. 실제 서버 TTS 클립이 확보되면 **교체해야 한다**. 리포트에 어느 자극음을
/// 썼는지 반드시 남긴다.
class EchoStimulus {
  EchoStimulus({required this.sampleRate, int seed = 1234})
      : _rng = math.Random(seed);

  /// 재생 엔진과 같은 레이트여야 한다(통화 경로는 24kHz).
  final int sampleRate;

  final math.Random _rng;

  /// 대역제한용 1차 필터 상태.
  double _lpState = 0.0;
  double _hpState = 0.0;

  /// 음절 변조 위상(라디안).
  double _synPhase = 0.0;

  /// 이 자극음이 무엇인지 — 리포트에 그대로 실린다.
  static const String note =
      '합성 음성형 자극음(300~3400Hz 대역제한 잡음 + 4Hz 음절변조). '
      '⚠ 실제 서버 TTS 아님 — AEC 적응 거동이 다를 수 있다';

  /// [frames] 개의 PCM16 모노 샘플을 만든다. [amplitude] 는 0~1 풀스케일 대비.
  ///
  /// 풀스케일로 내보내면 스피커가 클리핑하면서 **비선형 왜곡**이 생기고, 그건 어떤 AEC 도
  /// 못 지운다 — 실사용보다 나쁜 쪽으로 치우친 값이 나온다. 기본값을 여유 있게 둔다.
  Int16List nextChunk(int frames, {double amplitude = 0.5}) {
    final out = Int16List(frames);
    // 4Hz = 음절 속도.
    final synStep = 2 * math.pi * 4.0 / sampleRate;
    for (var i = 0; i < frames; i++) {
      // 백색 잡음 → 저역통과(≈3.4kHz) → 고역통과(≈300Hz) 로 전화 대역만 남긴다.
      final white = _rng.nextDouble() * 2 - 1;
      _lpState += (white - _lpState) * _alpha(3400);
      _hpState += (_lpState - _hpState) * _alpha(300);
      final band = _lpState - _hpState;

      // 음절 변조: 0.15~1.0 사이로 흔든다. 완전히 0 으로 떨어뜨리지 않는 건
      // 문장 내부의 무성 구간도 에너지가 완전히 사라지진 않기 때문이다.
      final syn = 0.15 + 0.85 * (0.5 + 0.5 * math.sin(_synPhase));
      _synPhase += synStep;
      if (_synPhase > 2 * math.pi) _synPhase -= 2 * math.pi;

      final v = (band * syn * amplitude * 32767).clamp(-32768.0, 32767.0);
      out[i] = v.toInt();
    }
    return out;
  }

  /// 1차 RC 필터 계수.
  double _alpha(double cutoffHz) {
    final rc = 1.0 / (2 * math.pi * cutoffHz);
    final dt = 1.0 / sampleRate;
    return dt / (rc + dt);
  }
}
