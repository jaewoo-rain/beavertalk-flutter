import 'dart:math' as math;
import 'dart:typed_data';

/// 통화 재생 음량 보정 — PCM16 샘플에 [gain] 배를 곱하고, 풀스케일 근처 봉우리는
/// 부드럽게 눌러 하드 클리핑(지직거림) 없이 담는다.
///
/// ## 통화 재생에 붙인다 (A2 · 10-03 사용자 「앱 수정 해」 · PM-DEC-352)
///
/// 원음(Gemini Live)은 말하는 구간 RMS −17.5 dBFS · 피크 −2.1 dBFS 로 정상이고, Note20 통화
/// 출력은 미디어 최대보다 2dB 크다(`11_앱서비스_하네스/_workspace/2026-10-03_통화음량/
/// 03_측정결과_Note20.md` §6). 남은 여지는 「눌러 담아 평균을 올리기」 뿐이라 +6dB 를 줘도
/// 체감은 약 +3dB 다. 사용자가 그걸 택했다. 값·끄기는 [kCallPlaybackGainDb]·[kCallPlaybackGainOn].
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

/// 통화 재생 게인(dB) — 값을 바꾸는 곳은 여기 하나다(PM-DEC-352 · 범위 4~6).
///
/// Note20 실측(실제 비버 음성): +6dB → 체감 +3.1dB · +9dB → +3.6dB. 원음 피크가 −2dBFS 라
/// 이 이상 올려도 리미터가 눌러 담을 뿐 커지지 않고 압축감만 는다.
const double kCallPlaybackGainDb = 5.0;

/// 끄기 스위치 — false 면 통화 재생이 원음 그대로다(되돌리기는 이것만 끄면 된다).
const bool kCallPlaybackGainOn = true;

/// 게인을 거는 출력인가 — **내장 스피커일 때만**(10-06 결함 ③).
///
/// 사용자 「블루투스 연결됐을 때 음량이 너무 큼(최대로 키우면 귀 찢어질 거 같음)」. +5dB 는
/// 스피커폰이 작다는 불만(A2)을 풀려고 넣었는데 출력과 상관없이 걸려, 귀에 바로 닿는
/// 이어폰·BT 에서도 커졌다. 출력을 모르면(`''`) 걸지 않는다 — 크게 틀리는 것보다 원음이 낫다.
bool playbackGainApplies(String route) => route == 'speaker';

double _tanh(double v) {
  final e = math.exp(2 * v);
  return (e - 1) / (e + 1);
}
