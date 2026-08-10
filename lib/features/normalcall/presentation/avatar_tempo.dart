/// 발화 템포 판정 — 들리는 목소리의 **음절 리듬**으로 talk 클립을 고른다.
///
/// [SyncAvatar] 에서 분리한 것은 **단위 테스트가 실앱과 같은 코드를 돌리기** 위해서다
/// (표정 분류기 `avatar_emotion.dart` 와 같은 이유).
library;

import 'dart:math' as math;

/// 발화 템포 — `talk_slow.mp4` / `talk.mp4` / `talk_fast.mp4`.
const int kTalkSlow = 0;
const int kTalkNormal = 1;
const int kTalkFast = 2;

/// 들리는 목소리에서 초당 음절 수를 센다.
///
/// 말소리의 엔벨로프는 음절마다 오르내린다(보통 대화가 초당 3~7회). 그 오르내림을
/// 세면 실제 발화 속도가 나온다.
///
/// ⛔ **자막 글자 수로 재지 마라.** 자막(`output_transcript`)은 **생성 속도**로 도착하고
///    오디오는 **재생 속도**로 나온다. 이 어긋남이 v6.6 표정 깜빡임의 원인이었다.
///    엔벨로프는 컨트롤러가 이미 들리는 소리에 맞춰 준다.
///
/// ⛔ **절대 문턱으로 세지 마라.** 처음에 0.012/0.005 로 만들었더니 실기기(S8)에서
///    한 턴에 음절이 2개밖에 안 잡혀 판정 자체를 못 했다. 실통화 엔벨로프는 음절
///    사이에서 0 까지 떨어지지 않고 **봉우리의 33~45% 까지만 얕게 팬다** — 0 근처로
///    내려가는 것은 어절 사이 침묵뿐이다. 그래서 **최근 봉우리 대비 상대값**으로 센다.
///
/// 문턱을 [_onRatio]·[_offRatio] 둘로 나눈 것은 **잡음에 한 음절이 여러 번 세어지는
/// 것**을 막기 위해서다. 한 번 올라가면 [_offRatio] 아래로 내려와야 다음을 센다.
class TempoMeter {
  /// 최근 봉우리 대비 — 이 위로 오르면 음절 시작.
  static const double _onRatio = 0.55;

  /// 이 아래로 내려와야 다음 음절을 센다.
  ///
  /// 0.45 는 실측 파형(`test/avatar_tempo_test.dart` 의 `_realEnv`)으로 훑어 고른 값이다.
  /// 0.35 로 두면 골이 기준선을 **간발로 못 넘어** 한 턴에 3개만 세어진다 —
  /// 봉우리가 감쇠하는 사이 골(0.328)이 기준선(0.303) 바로 위를 스친다.
  static const double _offRatio = 0.45;

  /// 봉우리 기억의 반감기. 짧으면 한 음절 안에서 기준이 흔들리고,
  /// 길면 목소리가 커졌다 작아질 때 기준이 못 따라간다.
  static const Duration _peakHalfLife = Duration(milliseconds: 600);

  /// 이보다 조용하면 말이 아니다 — 무음 구간의 잡음을 음절로 세지 않는다.
  static const double _floor = 0.02;

  static const Duration _window = Duration(seconds: 3);

  /// 판단에 필요한 최소 음절 수. 이보다 적으면 [rate] 가 null 이다 —
  /// 표본이 모자란 채로 템포를 바꾸면 짧은 추임새 하나에 클립이 갈아끼워진다.
  static const int minSyllables = 4;

  bool _high = false;

  /// 음절이 시작된 **시각들**. 개수만 세면 창을 접을 때 값이 튄다 —
  /// 처음엔 3초마다 개수를 반으로 접었는데, 실측 파형(3.4초)이 접히는 지점에 걸려
  /// 최소치 미만으로 떨어지면서 판정 자체가 안 됐다. 시각을 남기고 창 밖만 버린다.
  final List<DateTime> _onsets = [];
  DateTime? _last;

  /// 최근 봉우리. 시간에 따라 감쇠하므로 목소리 크기가 변해도 기준이 따라간다.
  double _peak = 0;

  void feed(double level, DateTime now) {
    final prev = _last;
    _last = now;

    // 봉우리 감쇠 — 반감기 기준. 프레임 간격이 불규칙해도 시간으로 계산하므로 안전하다.
    if (prev != null) {
      final dtMs = now.difference(prev).inMicroseconds / 1000.0;
      if (dtMs > 0) {
        _peak *= math.pow(0.5, dtMs / _peakHalfLife.inMilliseconds).toDouble();
      }
    }
    if (level > _peak) _peak = level;

    if (_peak > _floor) {
      if (!_high && level > _peak * _onRatio) {
        _high = true;
        _onsets.add(now);
      } else if (_high && level < _peak * _offRatio) {
        _high = false;
      }
    } else {
      _high = false; // 무음 - 다음 소리를 새 음절로 센다.
    }

    // ⛔ 창을 **지금** 기준으로 자르지 마라. 발화가 끝난 뒤 침묵이 흐르는 동안 오래된
    //    음절만 빠져나가 남은 것이 촘촘해 보이고, 측정값이 2.5 → 4.7 로 부풀었다.
    //    **마지막 음절** 기준으로 자르면 침묵이 지나도 값이 그대로다.
    while (_onsets.length > 1 &&
        _onsets.last.difference(_onsets.first) > _window) {
      _onsets.removeAt(0);
    }
  }

  /// 최근 창의 초당 음절 수. 표본이 모자라면 null(= 판단하지 않는다).
  ///
  /// **음절 사이 간격**으로 잰다 — 마지막 음절 이후의 침묵은 분모에 넣지 않는다.
  /// 처음엔 `개수 / (지금 - 첫 음절)` 로 쟀는데, 판정 시점이 발화 종료 180ms 뒤
  /// (`_hangover`)라 침묵이 분모를 늘려 값을 깎았다 — 실기기에서 2.47 이 1.7 로
  /// 내려가 실제보다 느린 클립이 걸렸다.
  double? get rate {
    if (_onsets.length < minSyllables) return null;
    final sec =
        _onsets.last.difference(_onsets.first).inMilliseconds / 1000.0;
    return sec < 0.8 ? null : (_onsets.length - 1) / sec;
  }

  /// 클립 실측값 사이에서 자른다 — slow 1.97 · normal 2.63 · fast 3.79회/초.
  /// 경계는 이웃한 두 클립의 중간이다(2.30 · 3.21 → 2.3 · 3.2).
  static int tempoFor(double rate) {
    if (rate < 2.3) return kTalkSlow;
    if (rate < 3.2) return kTalkNormal;
    return kTalkFast;
  }

  void reset() {
    _high = false;
    _onsets.clear();
    _last = null;
    _peak = 0;
  }
}
