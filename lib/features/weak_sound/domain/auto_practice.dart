/// 무채점 자동 연습의 상태기계 — 단어 단계(04~08)·문장 단계(09~13) 공용.
///
/// 이 단계에는 **마이크가 없다.** 사용자는 화면을 보며 입으로 따라 하고, 앱은 원어민
/// 음성을 재생한 뒤 따라 말할 틈을 주고 다음 항목으로 넘어간다. 점수도 없다.
/// (사용자 확정 2026-09-18: 「점수와 마이크 등 귀찮은 부분을 없애는 거야」)
///
/// ```
/// idle ─(start)→ playing(i=0)
/// playing ─(재생 끝)→ repeating(i)
/// repeating ─(대기 끝)→ i+1 있으면 playing(i+1), 없으면 done
/// ```
///
/// 위젯에서 떼어 낸 이유는 **여기가 가장 틀리기 쉬운 곳**이라서다. 타이머·재생·화면
/// 이탈이 겹치면 소리만 나고 진행이 멈추거나, 진행만 뛰고 소리가 없는 상태가 생긴다.
/// 순수 Dart 로 두면 그 조합을 테스트로 고정할 수 있다.
library;

/// 자동 연습이 지금 무엇을 하고 있는가.
enum AutoPracticePhase {
  /// 아직 시작 전(Figma 04·09 — 「시작 전」).
  idle,

  /// 원어민 음성 재생 중(Figma 05·10).
  playing,

  /// 사용자가 따라 말하는 구간(Figma 06·11). 녹음하지 않는다.
  repeating,

  /// 전부 끝(Figma 08·13 — 「끝(점수 없음)」).
  done,
}

/// 상태 1장 — 위젯이 그대로 그린다.
class AutoPracticeState {
  const AutoPracticeState({
    required this.phase,
    required this.index,
    required this.total,
  });

  const AutoPracticeState.initial(this.total)
      : phase = AutoPracticePhase.idle,
        index = 0;

  final AutoPracticePhase phase;

  /// 현재 항목 번호(0부터). [AutoPracticePhase.done] 이면 마지막 항목을 가리킨다.
  final int index;

  final int total;

  /// 「3 / 4」 표기용 — 1부터 센다.
  int get displayIndex => index + 1;

  bool get isLast => index >= total - 1;
  bool get isRunning =>
      phase == AutoPracticePhase.playing || phase == AutoPracticePhase.repeating;

  AutoPracticeState _copy({AutoPracticePhase? phase, int? index}) =>
      AutoPracticeState(
        phase: phase ?? this.phase,
        index: index ?? this.index,
        total: total,
      );
}

/// 따라 말하기 구간의 길이를 원어민 음성 길이에서 정한다.
///
/// ⛔ **고정 초를 쓰지 마라.** 「가방」과 「그 가방에 고기가 가득 있어요」에 같은 틈을 주면
/// 짧은 쪽은 지루하고 긴 쪽은 말하는 중에 잘린다.
///
/// 음성 길이의 [factor] 배에 [floor] 를 하한으로 둔다. 사람이 따라 말하는 속도는 듣기보다
/// 느려서 1.0배로는 모자라고, 아주 짧은 단어는 하한이 없으면 깜빡이듯 지나간다.
Duration repeatWindow(
  Duration? nativeAudio, {
  double factor = 1.35,
  Duration floor = const Duration(milliseconds: 1200),
}) {
  if (nativeAudio == null || nativeAudio == Duration.zero) return floor;
  final scaled = Duration(
    microseconds: (nativeAudio.inMicroseconds * factor).round(),
  );
  return scaled < floor ? floor : scaled;
}

/// 상태 전이만 담당하는 기계. 타이머·오디오는 호출부(위젯)가 소유한다.
///
/// 이 분리가 핵심이다 — 기계는 시간을 모르고, 위젯은 규칙을 모른다. 그래서 기계는
/// 테스트에서 시계 없이 돌아간다.
class AutoPracticeMachine {
  AutoPracticeMachine(int total)
      : assert(total >= 0),
        _state = AutoPracticeState.initial(total);

  AutoPracticeState _state;
  AutoPracticeState get state => _state;

  /// 첫 항목 재생으로 들어간다. 항목이 0개면 곧바로 [AutoPracticePhase.done].
  AutoPracticeState start() {
    if (_state.total == 0) {
      return _state = _state._copy(phase: AutoPracticePhase.done);
    }
    return _state = _state._copy(phase: AutoPracticePhase.playing, index: 0);
  }

  /// 원어민 음성 재생이 끝났다 → 따라 말하기 구간.
  ///
  /// 재생 중이 아닐 때 들어오면 무시한다. 재생 실패·중복 완료 콜백이 상태를 앞으로
  /// 밀지 않게 하려는 것이다(오디오 플러그인은 완료를 두 번 알릴 수 있다).
  AutoPracticeState onPlaybackComplete() {
    if (_state.phase != AutoPracticePhase.playing) return _state;
    return _state = _state._copy(phase: AutoPracticePhase.repeating);
  }

  /// 따라 말하기 구간이 끝났다 → 다음 항목 재생, 또는 완료.
  AutoPracticeState onRepeatComplete() {
    if (_state.phase != AutoPracticePhase.repeating) return _state;
    if (_state.isLast) {
      return _state = _state._copy(phase: AutoPracticePhase.done);
    }
    return _state = _state._copy(
      phase: AutoPracticePhase.playing,
      index: _state.index + 1,
    );
  }

  /// 화면 이탈·앱 백그라운드 — 진행을 멈추고 [AutoPracticePhase.idle] 로 돌린다.
  ///
  /// 인덱스는 **유지한다.** 돌아왔을 때 처음부터가 아니라 보던 항목부터 잇는다.
  AutoPracticeState pause() {
    if (!_state.isRunning) return _state;
    return _state = _state._copy(phase: AutoPracticePhase.idle);
  }

  /// [pause] 이후 재개 — 보던 항목의 재생부터 다시 한다.
  ///
  /// 따라 말하기 구간에서 멈췄어도 **재생부터** 시작한다. 돌아온 사용자는 방금 들은 것을
  /// 기억하지 못한다고 보는 편이 안전하다.
  AutoPracticeState resume() {
    if (_state.phase != AutoPracticePhase.idle) return _state;
    if (_state.total == 0) {
      return _state = _state._copy(phase: AutoPracticePhase.done);
    }
    return _state = _state._copy(phase: AutoPracticePhase.playing);
  }
}
