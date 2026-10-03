import 'dart:math' as math;
import 'dart:typed_data';

/// 통화 재생 음량 보정 — PCM16 샘플에 [gain] 배를 곱하고, 풀스케일 근처 봉우리는
/// 부드럽게 눌러 하드 클리핑(지직거림) 없이 담는다.
///
/// ## 지금은 측정 전용이다 — 통화 재생에 붙이지 않았다
///
/// A2(10-03 사용자 「통화음량 고치고」)에서 「재생 직전 PCM 을 키운다」(수정안 A)를 재려고
/// 만들었다. Note20 실측: 통화 용도 경로에 +6/+9dB 를 넣어도 스피커 출력은 +0.5~+3.5dB 로
/// 회차 편차 안이었다 — 기기 통화 음성 처리가 레벨을 다시 맞춘다. 그래서 A 는 넣지 않기로
/// 했다(PM-DEC-348 · `11_앱서비스_하네스/_workspace/2026-10-03_통화음량/03_측정결과_Note20.md`).
/// 쓰는 곳은 `lib/main_loudness_probe.dart` 뿐이다. 아이폰 측정 결과에 따라 iOS 전용으로
/// 붙일 수 있어 남겨 둔다.
///
/// ## 리미터
///
/// [kneeThreshold] 아래는 그대로 곱한다(선형). 그 위는 tanh 로 눌러 풀스케일에 다가가기만
/// 하고 넘지 않는다 — 단순 clamp 는 봉우리를 평평하게 잘라 지직거림을 만든다.
/// 원음이 이미 크면 실제로 커지는 폭이 [gain] 보다 작다(그게 리미터의 일이다).
///
/// [gain] 이 1.0 이면 원본을 그대로 돌려준다(복사 없음).
Int16List applyPcmGain(
  Int16List samples,
  double gain, {
  double kneeThreshold = 0.8,
}) {
  if (gain == 1.0) return samples;
  final out = Int16List(samples.length);
  final t = kneeThreshold;
  for (var i = 0; i < samples.length; i++) {
    final x = samples[i] / 32768.0 * gain;
    final a = x.abs();
    final y = a <= t ? a : t + (1 - t) * _tanh((a - t) / (1 - t));
    final v = (x.isNegative ? -y : y) * 32768;
    out[i] = v.round().clamp(-32768, 32767);
  }
  return out;
}

/// 데시벨 → 선형 배율.
double dbToGain(double db) => math.pow(10, db / 20).toDouble();

double _tanh(double v) {
  final e = math.exp(2 * v);
  return (e - 1) / (e + 1);
}
