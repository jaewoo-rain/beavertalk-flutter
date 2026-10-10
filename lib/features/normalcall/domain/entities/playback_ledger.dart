/// 재생 엔진에 넣은 오디오의 **출처 원장**.
///
/// ## 무엇을 푸는가
///
/// 서버는 barge-in 으로 턴을 끊을 때 "사용자가 어디까지 들었나"를 알아야 한다.
/// 그런데 스피커로 나간 양을 재생 헤드(`getPlaybackHeadPosition`)로만 세면 틀린다 —
/// 클라는 큐가 빌 때마다 **자기가 만든 무음 필러**를 먹여서 AudioTrack 을 살려 두는데,
/// 재생 헤드는 그 필러까지 세기 때문이다. 필러는 턴 사이·프리버퍼 대기·starve 구간에
/// 전부 끼므로 "헤드 차이 = 들은 대사 길이"가 성립하지 않는다.
///
/// 다행히 **어느 피드가 서버발이고 어느 게 우리 필러인지는 클라가 정확히 안다.**
/// 남은 문제는 하나뿐이다: *엔진에 아직 남아 있는 잔량 중 몇 프레임이 서버발인가.*
///
/// ## 방식
///
/// 피드 순서대로 `(frames, isServer)` 세그먼트를 쌓아 둔다. 엔진은 **엄격 FIFO** 로
/// 소비하므로, 잔량(ground truth) 하나만 주어지면 꼬리에서 거꾸로 걸어 그 잔량의
/// 구성을 정확히 가를 수 있다:
///
/// ```
/// 재생된 서버 프레임 = 누적 서버 프레임 − (잔량 꼬리 안의 서버 프레임)
/// ```
///
/// ⚠ **이건 외삽이 아니다.** 잔량 실측값과, 우리가 스스로 기록한 FIFO 구성만 쓴다.
/// 잔량을 시간으로 추정한 값(예: 마지막 앵커 + 경과시간)을 넣으면 그 순간 추정치가
/// 되므로, 호출부는 ground truth 가 없을 때 그 사실을 로그로 드러내야 한다.
class PlaybackLedger {
  /// 보관할 최대 프레임 수. 엔진 깊이(최대 ~2.5초)보다 넉넉히 커야 꼬리 계산이
  /// 잘리지 않는다. 24kHz 기준 5초.
  static const int _maxRetainFrames = 24000 * 5;

  final List<_FedSegment> _segments = <_FedSegment>[];

  /// 보관 중인 세그먼트의 프레임 합(가지치기 판단용).
  int _retainedFrames = 0;

  /// 엔진에 넘긴 **서버발** 프레임 누계. 가지치기와 무관하게 계속 는다.
  int _fedServerFrames = 0;

  int get fedServerFrames => _fedServerFrames;

  /// 엔진에 넘긴 한 덩어리를 기록한다. [frames] 는 입력 프레임 수(바이트가 아니다).
  void recordFeed({required int frames, required bool server}) {
    if (frames <= 0) return;
    if (server) _fedServerFrames += frames;

    // 같은 출처가 연달아 오면 합친다 — 푸시 루프가 10ms 주기라 안 합치면 세그먼트가
    // 초당 100개씩 쌓인다.
    if (_segments.isNotEmpty && _segments.last.server == server) {
      _segments.last.frames += frames;
    } else {
      _segments.add(_FedSegment(frames: frames, server: server));
    }
    _retainedFrames += frames;
    _prune();
  }

  /// 엔진에 [remainingFrames] 가 남아 있을 때, **실제로 재생된 서버발 프레임 누계**.
  ///
  /// [remainingFrames] 는 반드시 실측값이어야 한다(네이티브 clear 의 폐기 프레임 수,
  /// 또는 Android `feed()` 가 돌려주는 큐 깊이). 단위는 **입력 프레임**(PCM24k 기준).
  ///
  /// ⚠ 플랫폼 차이: Android 는 대기큐 + `getPlaybackHeadPosition()` 미방출분까지 세지만,
  ///   iOS 는 AudioUnit 이 렌더 콜백으로 10~20ms 씩 당겨가는 pull 구조라 "미방출분"이
  ///   대기 큐 기준으로만 잡힌다. 그래서 iOS 의 잔량이 한 자릿수 ms 만큼 **작게** 나올 수
  ///   있고, 그만큼 재생량이 **과대** 보고된다. 실사용 오차 범위이므로 보정하지 않는다 —
  ///   다만 iOS 와 Android 수치를 나란히 비교할 때 이 편향을 전제로 읽어야 한다.
  int playedServerFrames(int remainingFrames) {
    var need = remainingFrames < 0 ? 0 : remainingFrames;
    var serverInTail = 0;
    for (var i = _segments.length - 1; i >= 0 && need > 0; i--) {
      final seg = _segments[i];
      final take = seg.frames < need ? seg.frames : need;
      if (seg.server) serverInTail += take;
      need -= take;
    }
    final played = _fedServerFrames - serverInTail;
    return played < 0 ? 0 : played;
  }

  /// 새 비버 턴이 열릴 때 호출한다. 턴 경계에서는 엔진이 비어 있는 게 계약이므로
  /// (마이크 재개방 조건 자체가 "오디오 배수 완료"다) 여기서 원장을 비우면
  /// [playedServerFrames] 가 곧바로 **이번 턴의** 재생량이 된다.
  void reset() {
    _segments.clear();
    _retainedFrames = 0;
    _fedServerFrames = 0;
  }

  /// 꼬리 계산에 필요한 분량만 남기고 앞을 버린다.
  void _prune() {
    while (_segments.length > 1 &&
        _retainedFrames - _segments.first.frames >= _maxRetainFrames) {
      _retainedFrames -= _segments.first.frames;
      _segments.removeAt(0);
    }
  }
}

class _FedSegment {
  _FedSegment({required this.frames, required this.server});

  int frames;

  /// true = 서버에서 받은 오디오, false = 클라가 만든 무음 필러.
  final bool server;
}
