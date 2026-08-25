/// 통화 계측 이벤트 — 링버퍼 + 클래스별 쿼터 (2026-08-25).
///
/// ## ⛔ 왜 만들었나
/// 서버는 **체감 지연을 잴 수 없다.** `gemini-3.1-flash-live-preview` 가 학습자 전사의
/// 마지막 조각을 자기 응답과 **같이** 내보내서 "학습자가 말을 끝낸 시각"이 서버에 안
/// 남는다(실측: 5분 통화 12턴 전부 끝기준 0.00초). 그 원점은 **여기, 클라의 로컬 VAD**
/// 에만 있다.
///
/// 그리고 지금까지 아무도 아무것도 못 보고 있었다 — Live 프로토콜에 `user_turn_end` 가
/// 없어서 `_recordResponseTime` 이 매번 즉시 반환했고, 설령 보냈어도 서버 유니온에
/// `client_timing` 이 없어 버려졌다. 둘 다 2026-08-24 에 고쳤고, 이 파일이 그 위에 선다.
///
/// ## 설계 규율 셋
/// - **핫패스는 append 만.** 직렬화·문자열 조립·await 금지. 계측이 재려던 지연을
///   우리가 만들면 본말전도다.
/// - **버릴 때는 알린다.** 상한을 넘으면 조용히 사라지지 않고 [dropped] 로 센다.
/// - **버리는 순서를 정해 둔다.** 주기 롤업(`win`)·영상 디코더(`vid_dec`) 가 먼저 죽고,
///   턴·마커·언더런·소켓·요약은 **절대 안 버린다** — 그게 진단의 뼈대다.
library;

/// 이벤트 1건. `e`(이름) + 나머지 필드.
///
/// ⛔ 클래스를 나누지 마라. 서버가 dict 를 그대로 받아 흘리도록 계약을 짰다
/// (`ClientDiag.events` 가 discriminated union 이 **아닌** 이유와 같다) — 여기서 타입을
/// 굳히면 그 유연성을 클라 쪽에서 도로 없애는 셈이다.
typedef CallDiagEvent = Map<String, Object?>;

/// 버릴 때 먼저 죽는 순서. 낮을수록 먼저 버린다.
///
/// ⛔ 이 표를 "중요도"로 읽지 마라. **없으면 진단이 불가능해지는가**로 정한 것이다.
/// `win` 은 5초마다 다시 오므로 하나 잃어도 추세가 남지만, `turn_done` 하나를 잃으면
/// 그 턴의 재생 대조가 영영 안 된다.
int diagClassRank(String name) {
  switch (name) {
    case 'win':
      return 0; // 주기 롤업 — 다음 창이 곧 온다
    case 'vid_dec':
    case 'vid_swap':
    case 'vid_emo':
      return 1; // 영상 내부 상태 — 굵은 사건(vid_talk)만 남으면 대략 읽힌다
    case 'mic_gate':
    case 'voice_on':
      return 2; // 보조 축
    default:
      return 3; // 턴·마커·언더런·소켓·요약 — 버리지 않는다
  }
}

/// 통화 1건의 계측 버퍼.
///
/// 링버퍼가 아니라 **쿼터 기반 절단**을 쓴다. 오래된 것부터 버리면(링) 통화 **초반**이
/// 사라지는데, 우리가 제일 자주 보는 것이 "붙자마자 이상하다"라 초반이 가장 값지다.
class CallDiagBuffer {
  CallDiagBuffer({this.maxEvents = 1000, this.maxPerBatch = 60});

  /// 통화당 총 상한. 넘으면 [diagClassRank] 낮은 것부터 버린다.
  final int maxEvents;

  /// 배치 한 번에 실을 최대 건수. 프레임 2KB 상한과 짝이다.
  final int maxPerBatch;

  final List<CallDiagEvent> _pending = <CallDiagEvent>[];

  /// 상한으로 버린 누적 건수. **0 이 아니면 서버가 warning 으로 올린다.**
  int dropped = 0;

  /// 이 통화에서 만든 총 이벤트 수(버린 것 포함).
  int produced = 0;

  int get pendingCount => _pending.length;
  bool get isEmpty => _pending.isEmpty;

  /// 이벤트 1건 적재. **핫패스에서 불린다 — 여기서 무거운 일을 하지 마라.**
  void add(String name, int t, [Map<String, Object?>? fields]) {
    produced++;
    if (_pending.length >= maxEvents) {
      // 자리가 없다. 지금 것보다 덜 중요한 걸 하나 찾아 밀어낸다.
      final rank = diagClassRank(name);
      final victim = _findVictim(rank);
      if (victim < 0) {
        dropped++; // 나보다 덜 중요한 게 없다 → 내가 버려진다
        return;
      }
      _pending.removeAt(victim);
      dropped++;
    }
    final ev = <String, Object?>{'e': name, 't': t};
    if (fields != null) ev.addAll(fields);
    _pending.add(ev);
  }

  /// [rank] 보다 낮은 등급의 **가장 오래된** 항목 위치. 없으면 -1.
  int _findVictim(int rank) {
    for (var i = 0; i < _pending.length; i++) {
      final e = _pending[i]['e'];
      if (e is String && diagClassRank(e) < rank) return i;
    }
    return -1;
  }

  /// 다음 배치로 보낼 만큼 꺼낸다(FIFO). 남은 것은 다음 배치로.
  List<CallDiagEvent> take([int? limit]) {
    final n = (limit ?? maxPerBatch).clamp(0, _pending.length);
    if (n == 0) return const <CallDiagEvent>[];
    final out = _pending.sublist(0, n);
    _pending.removeRange(0, n);
    return out;
  }

  /// [take] 로 꺼낸 것을 **순서 그대로** 되돌린다.
  ///
  /// ⛔ 왜 필요한가: 프레임이 2KB 상한을 넘으면 싱크가 건수를 줄여 다시 만든다. 그때
  /// 꺼냈던 것을 버리면 **상한을 넘겼다는 이유로 계측이 조용히 사라진다** — 하필 이벤트가
  /// 몰린 구간, 즉 제일 보고 싶은 구간이 그렇게 없어진다. 되돌려서 다음 배치로 보낸다.
  void putBack(List<CallDiagEvent> events) {
    if (events.isEmpty) return;
    _pending.insertAll(0, events);
  }

  void clear() {
    _pending.clear();
    dropped = 0;
    produced = 0;
  }
}
