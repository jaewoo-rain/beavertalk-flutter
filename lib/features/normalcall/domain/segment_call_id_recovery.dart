/// 소켓을 먼저 닫아 버려 `call_ended` 를 못 받은 통화의 `call_id` 를 되짚는 정책.
///
/// ## 왜 되짚어야 하나
///
/// 통화 `call_id` 는 서버가 `call_ended` 프레임으로만 알려 준다. 그런데 **클라가 먼저
/// 끊는 경로**(수동 종료, 그리고 5분 구간 경계)에서는 그 프레임이 오지 않는다. 그래서
/// id 를 모르는 채로 끝난다.
///
/// 구간 경계에서 이걸 놓치면 다음 구간의 `continues_call_id` 가 비고, 서버는 이어가기인
/// 줄 몰라 **비버가 앞 대화를 잊는다.** 화면상 통화는 멀쩡히 이어져서 겉으로는 고장이
/// 안 보인다.
///
/// ## 어떻게 되짚나
///
/// 통화를 열 때마다 **직전 최신 id** 를 기준값으로 잡아 둔다(`_captureBaselineCallId`).
/// 그러면 `GET /calls` 의 최신 id 가 기준값보다 큰 순간, 그게 방금 끝난 그 통화다.
/// 서버가 행을 마감하는 데 시간이 걸리므로 몇 번 다시 묻는다.
library;

/// [SegmentCallIdRecovery.run] 이 서버에 「지금 최신 call_id」를 묻는 방법.
typedef LatestCallIdFetcher = Future<int?> Function();

/// 기준값보다 큰 첫 `call_id` 가 나타날 때까지 다시 묻는다.
class SegmentCallIdRecovery {
  /// 재시도 횟수와 간격을 정해 만든다. 기본값은 `call_finish.dart` 의 종료 후 복구와
  /// 같다 — 같은 서버 지연을 상대하므로 값을 따로 둘 이유가 없다.
  const SegmentCallIdRecovery({
    this.attempts = 5,
    this.gap = const Duration(milliseconds: 600),
  });

  /// 최대 몇 번 묻는가.
  final int attempts;

  /// 물음 사이의 간격.
  final Duration gap;

  /// 되짚는다. 못 찾으면 null.
  ///
  /// [baseline] 은 **그 통화를 열기 직전의** 최신 id 여야 한다. 이보다 큰 id 가
  /// 그 통화의 행이다.
  ///
  /// ⛔ [baseline] 이 null 이면(기준값을 못 잡았다) **가장 최신 id 를 그대로 믿는다.**
  ///   그 통화의 행이 아직 안 만들어졌다면 **직전 통화의 id 를 집을 수 있다** — 서버가
  ///   엉뚱한 대화를 요약해 넣게 된다. 기준값을 잡는 쪽을 먼저 고쳐라. 여기서
  ///   막지 않는 이유는, 막으면 기준값을 못 잡은 통화가 **영영** 못 이어지기 때문이다.
  ///
  /// [cancelled] 가 true 를 돌려주면 즉시 그만둔다 — 사용자가 그 사이 통화를 끊었을 때
  /// 쓸모없는 폴링을 계속할 이유가 없다.
  Future<int?> run({
    required int? baseline,
    required LatestCallIdFetcher latestCallId,
    bool Function()? cancelled,
  }) async {
    for (var i = 0; i < attempts; i++) {
      if (cancelled?.call() ?? false) return null;
      try {
        final latest = await latestCallId();
        if (latest != null && (baseline == null || latest > baseline)) {
          return latest;
        }
      } catch (_) {
        // 일시적(네트워크·서버) — 아래 재시도로 흡수한다.
      }
      if (i < attempts - 1) await Future<void>.delayed(gap);
    }
    return null;
  }
}
