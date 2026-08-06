import 'dart:math' as math;
import 'dart:typed_data';

/// 에코 측정 리그의 **순수 계산부**.
///
/// 화면·마이크·재생과 분리해 둔 이유는 하나다 — 이 숫자들이 서버의 에코 게이트 상수를
/// 정하기 때문에, 여기만은 단위테스트로 고정할 수 있어야 한다.
///
/// ## 단위 (⚠ 섞으면 안 된다)
///
/// 서버 임계는 **0~1 정규화 RMS** 다:
/// ```
/// rms = sqrt(sum(x^2) / N) / 32768      // x 는 PCM16 샘플
/// ```
/// 계측 도구는 관례상 dBFS 로 내는데 둘은 다른 축이다. 환산:
/// ```
/// dBFS = 20 * log10(rms)      rms = 10^(dBFS/20)
/// ```
/// 이 파일은 **정규화 RMS 를 1차 단위로** 쓰고, dBFS 는 표시용으로만 파생한다.
/// 리포트에는 항상 둘 다, 단위를 붙여 낸다.

/// PCM16 리틀엔디언 프레임 한 덩어리의 정규화 RMS(0~1).
///
/// 홀수 바이트가 남으면 버린다(온전한 샘플만 센다). 빈 입력은 0.
double rmsOfPcm16(Uint8List bytes) {
  final n = bytes.lengthInBytes ~/ 2;
  if (n == 0) return 0.0;
  final view = ByteData.sublistView(bytes, 0, n * 2);
  var sumSq = 0.0;
  for (var i = 0; i < n; i++) {
    final s = view.getInt16(i * 2, Endian.little).toDouble();
    sumSq += s * s;
  }
  return math.sqrt(sumSq / n) / 32768.0;
}

/// 정규화 RMS → dBFS. 0(무음)은 유한한 하한으로 눌러 −infinity 가 리포트에 찍히지 않게 한다.
double rmsToDbfs(double rms) {
  if (rms <= 0) return -120.0;
  final db = 20 * (math.log(rms) / math.ln10);
  return db < -120.0 ? -120.0 : db;
}

/// dBFS → 정규화 RMS.
double dbfsToRms(double dbfs) => math.pow(10, dbfs / 20).toDouble();

/// 백분위(nearest-rank). 표본이 적을 때 보간법마다 답이 달라 혼선이 생기므로,
/// **가장 단순하고 재현 가능한 정의**를 쓴다: 정렬 후 ceil(p/100 * N) 번째 값.
///
/// [values] 는 변경하지 않는다. 빈 리스트는 0.
double percentile(List<double> values, double p) {
  if (values.isEmpty) return 0.0;
  final sorted = [...values]..sort();
  if (p <= 0) return sorted.first;
  if (p >= 100) return sorted.last;
  final rank = (p / 100.0 * sorted.length).ceil();
  final idx = (rank - 1).clamp(0, sorted.length - 1);
  return sorted[idx];
}

/// 한 구간에서 모은 RMS 표본의 요약.
class RmsStats {
  const RmsStats({
    required this.count,
    required this.median,
    required this.p5,
    required this.p95,
  });

  factory RmsStats.from(List<double> samples) => RmsStats(
        count: samples.length,
        median: percentile(samples, 50),
        p5: percentile(samples, 5),
        p95: percentile(samples, 95),
      );

  /// 표본 수. 적으면 백분위를 믿으면 안 되므로 리포트에 같이 낸다.
  final int count;

  /// 전부 **정규화 RMS(0~1)**.
  final double median;
  final double p5;
  final double p95;

  static const RmsStats empty =
      RmsStats(count: 0, median: 0, p5: 0, p95: 0);
}

/// 시간 길이 표본(ms)의 p95. ③ 버스트·④ 꼬리는 통계가 p95 **하나뿐**이다.
class DurationStats {
  const DurationStats({required this.count, required this.p95Ms});

  factory DurationStats.from(List<int> samplesMs) => DurationStats(
        count: samplesMs.length,
        p95Ms: percentile(samplesMs.map((e) => e.toDouble()).toList(), 95)
            .round(),
      );

  final int count;
  final int p95Ms;

  static const DurationStats empty = DurationStats(count: 0, p95Ms: 0);
}

/// 측정 조건. ①과 ②는 **같은 조건·같은 볼륨**에서 재야 비교가 성립한다.
enum EchoRoute {
  speakerphone('스피커폰'),
  headset('이어폰');

  const EchoRoute(this.label);
  final String label;
}

/// 프레임 RMS 열에서 **연속으로 임계를 넘은 구간**의 길이(ms)를 뽑는다.
///
/// ③ 에코 버스트가 이것이다. [frameMs] 는 프레임 하나가 차지하는 시간.
/// 끝까지 임계 위인 채로 끝나면 그 구간도 하나로 친다(잘라 버리면 긴 버스트가 사라져
/// p95 가 낙관적으로 나온다).
List<int> burstDurationsMs({
  required List<double> frameRms,
  required double threshold,
  required double frameMs,
}) {
  final out = <int>[];
  var run = 0;
  for (final v in frameRms) {
    if (v > threshold) {
      run++;
    } else if (run > 0) {
      out.add((run * frameMs).round());
      run = 0;
    }
  }
  if (run > 0) out.add((run * frameMs).round());
  return out;
}

/// 재생을 멈춘 뒤 잔향이 [threshold] 아래로 **안정적으로** 내려갈 때까지의 시간(ms).
///
/// 한 프레임만 내려가도 끝났다고 보면 진폭 변동에 속는다. [settleFrames] 개가 연속으로
/// 임계 아래여야 복귀로 친다. 끝까지 안 내려가면 관측 구간 전체를 반환한다(하한이 아니라
/// **관측된 최소치**라는 뜻이므로, 리포트에서 그렇게 표기해야 한다).
int tailMs({
  required List<double> frameRms,
  required double threshold,
  required double frameMs,
  int settleFrames = 3,
}) {
  var below = 0;
  for (var i = 0; i < frameRms.length; i++) {
    if (frameRms[i] <= threshold) {
      below++;
      if (below >= settleFrames) {
        // 복귀가 시작된 지점 = 연속 구간의 첫 프레임.
        final firstBelow = i - settleFrames + 1;
        return (firstBelow * frameMs).round();
      }
    } else {
      below = 0;
    }
  }
  return (frameRms.length * frameMs).round();
}

/// 한 조건(스피커폰/이어폰)에 대한 측정 결과 전체.
class EchoRigResult {
  const EchoRigResult({
    required this.route,
    required this.noiseFloor,
    required this.echo,
    required this.speech,
    required this.burst,
    required this.tail,
    required this.tailSettled,
    required this.stimulusNote,
    this.detectedRoute = '',
    this.voiceCallAudio = false,
    this.audioDiag = const {},
  });

  /// 이 표본을 **통화 용도 오디오(AEC 켬)** 상태에서 쟀는가.
  ///
  /// ⚠ 이건 조건의 일부다 — AEC 를 켜면 잔여 에코가 통째로 달라진다. 끈 상태로 잰
  /// 숫자로 서버 임계를 잡으면 임계가 너무 헐거워진다. 그래서 라우트와 **함께**
  /// 표본을 가르는 키다(같은 라우트라도 AEC 전/후는 다른 표본이다).
  final bool voiceCallAudio;

  /// 측정 시점의 오디오 상태 스냅샷(모드·스피커폰·라우트·볼륨). Android 만 채워진다.
  final Map<String, dynamic> audioDiag;

  /// 조작자가 **고른** 조건(스피커폰/이어폰).
  final EchoRoute route;

  /// [AudioRouteProbe] 가 실제로 답한 라우트. 못 읽으면 `''`.
  ///
  /// ⚠ **이건 `route` 와 다른 값이다.** 통화 세션의 `start.aec` 도, 취소 리그의
  /// `audio_route` 도 전부 이 프로브를 소스로 쓴다. 여기에만 조작자의 선택을 싣고
  /// 프로브 값을 안 실으면, **실측으로 임계를 잡아 놓고 실제 세션은 다른 분류로 도는**
  /// 사고가 난다 — 예: 조작자는 "이어폰"으로 쟀는데 프로브는 speaker 로 보고 있었고,
  /// 서버는 그 세션을 speaker 정책으로 돌린다. 그래서 둘을 같이 싣고 어긋나면 밝힌다.
  final String detectedRoute;

  /// 고른 조건과 프로브가 어긋났는가. 어긋났으면 이 표본으로 임계를 잡으면 안 된다.
  bool get routeMismatch {
    if (detectedRoute.isEmpty) return false; // 못 읽은 것은 어긋난 것과 다르다
    final expected = route == EchoRoute.headset ? 'headset' : 'speaker';
    return detectedRoute != expected;
  }

  /// 0단계에서 잰 환경 소음. ③④ 판정 임계의 기준이자, 사후 검증용 근거.
  final RmsStats noiseFloor;

  /// ① 비버 발화 중 사용자 침묵 구간.
  final RmsStats echo;

  /// ② 사용자 정상 발화.
  final RmsStats speech;

  /// ③ 에코 버스트 지속(p95).
  final DurationStats burst;

  /// ④ 정지 후 꼬리(p95).
  final DurationStats tail;

  /// ④ 측정에서 잔향이 실제로 임계 아래로 복귀했는가. false 면 p95 는 하한이 아니라
  /// **관측 구간에 잘린 값**이다 — 리포트가 그렇게 밝혀야 한다.
  final bool tailSettled;

  /// 자극음이 실제 TTS 였는지, 합성음이었는지.
  final String stimulusNote;

  /// ⭐ 미리 정해진 판정: 에코 p95 가 사용자 최소 발화(p5) 이상이면
  /// **에너지만으로는 둘을 못 가른다.** 서버는 에너지 게이트를 끄고 전사 확인으로 간다.
  ///
  /// 이 값이 true 로 나와도 실패가 아니다. 설계 분기를 고르는 정보다.
  bool get energyGateUnusable => echo.p95 >= speech.p5;

  /// 서버가 쓸 기하평균 임계 후보(정규화 RMS). 청감이 로그 지각이라 산술평균이 아니다.
  ///
  /// [energyGateUnusable] 이면 의미가 없으므로 리포트에서 함께 읽어야 한다.
  double get suggestedBargeInRms => math.sqrt(echo.p95 * speech.p5);

  /// 서버가 쓸 최소 지속(ms). 짧은 에코 스파이크를 barge-in 으로 오인하지 않기 위한 하한 150ms.
  int get suggestedMinMs => math.max(150, burst.p95Ms);
}
