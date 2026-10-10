import 'echo_metrics.dart' show percentile;

/// 취소 배관 리그의 표본 하나 — `audio_cancel` 한 번에 대한 전부.
///
/// [payload] 는 `_send` 로 **나가려던 Map 그대로**다. 가공하지 않는 게 요점이다:
/// 리그 화면에 찍히는 것과 서버가 받게 될 것이 다르면, 리그로 통과시킨 뒤 서버에서
/// 어긋나는 최악의 형태가 된다.
class CancelSample {
  const CancelSample({
    required this.index,
    required this.payload,
    required this.residualInjectedBytes,
    required this.residualDiscardedBytes,
    required this.resumeDrainMs,
  });

  /// 몇 번째 반복인지(0-base).
  final int index;

  /// `playback_progress` 페이로드 원본. 회신이 안 온 경우 비어 있다.
  final Map<String, dynamic> payload;

  /// 취소 직후 일부러 흘린 바이트 — 서버 불변식상 **전량 폐기**돼야 한다.
  final int residualInjectedBytes;

  /// 실제로 폐기된 바이트(`_cancelledResidualBytes` 실측).
  final int residualDiscardedBytes;

  /// 취소 후 새 턴을 열고 오디오를 밀었을 때 Dart 큐가 다시 비워지기까지 걸린 ms.
  /// **-1 = 제한시간 안에 안 비워졌다 = 락업**.
  final int resumeDrainMs;

  /// 회신 자체가 안 왔다. 배관이 도중에 멈춘 것이므로 타이밍 통계에 넣으면 안 된다.
  bool get payloadMissing => payload.isEmpty;

  /// 취소 수신 → 실제 무음까지(ms). 없으면 null.
  int? get clientStopMs {
    final v = payload['client_stop_ms'];
    return v is int ? v : null;
  }

  /// `hal_drained` / `clear_returned` — 정지 시점을 무엇으로 쟀는지.
  String get stopMeasure => payload['stop_measure'] as String? ?? '';

  /// `native` / `estimate` — 재생량이 실측인지 외삽인지.
  String get source => payload['source'] as String? ?? '';

  /// 이번 턴에 실제로 스피커로 나간 서버발 바이트.
  int get playedServerBytes {
    final v = payload['played_server_bytes'];
    return v is int ? v : 0;
  }

  /// 잔여가 전량 폐기됐는가. 주입량과 폐기량이 정확히 같아야 한다.
  bool get residualOk => residualDiscardedBytes == residualInjectedBytes;

  /// 취소 후 재생이 되살아났는가(락업 회귀 검사).
  bool get resumeOk => resumeDrainMs >= 0;

  /// 셋 다 통과해야 이 표본이 성공이다.
  bool get ok => !payloadMissing && residualOk && resumeOk;
}

/// 목표선 — 취소 수신부터 실제 무음까지 이 안에 들어와야 한다.
///
/// 이 값이 넘으면 사용자는 "끼어들었는데 비버가 계속 말한다"로 느끼고, 동시에 그
/// 구간의 스피커 소리가 마이크로 되돌아가 STT 를 오염시킨다.
const int kCancelStopTargetMinMs = 50;
const int kCancelStopTargetMaxMs = 120;

/// 판정. 실패 건수가 하나라도 있으면 타이밍이 아무리 좋아도 통과가 아니다.
enum CancelVerdict {
  /// 표본이 없다.
  noData,

  /// 락업/잔여/무회신 중 하나라도 발생 — 타이밍 판정 이전의 문제다.
  brokenPipeline,

  /// p95 가 목표선 안.
  pass,

  /// p95 가 목표선 초과.
  tooSlow,

  /// p95 는 통과했지만 **정지 시점을 제대로 못 쟀다**(`hal_drained` 비율이 낮다).
  /// HAL 잔량이 안 잡혀 실제보다 짧게 나왔을 수 있으므로 통과로 읽으면 안 된다.
  passUnverified,
}

/// N회 반복의 요약.
///
/// ⚠ 타이밍 통계는 **회신이 온 표본만**으로 낸다. 실패 표본을 0ms 로 섞으면 분포가
/// 좋아 보이고, 정확히 그 실패가 우리가 찾는 것이다.
class CancelRigSummary {
  const CancelRigSummary({
    required this.total,
    required this.timed,
    required this.medianMs,
    required this.p95Ms,
    required this.maxMs,
    required this.halDrainedRatio,
    required this.nativeRatio,
    required this.residualFails,
    required this.resumeFails,
    required this.payloadMissing,
    required this.routeCounts,
  });

  factory CancelRigSummary.of(List<CancelSample> samples) {
    final ms = <double>[];
    var halDrained = 0;
    var native = 0;
    var residualFails = 0;
    var resumeFails = 0;
    var missing = 0;
    final routes = <String, int>{};

    for (final s in samples) {
      if (!s.residualOk) residualFails++;
      if (!s.resumeOk) resumeFails++;
      if (s.payloadMissing) {
        missing++;
        continue;
      }
      final v = s.clientStopMs;
      if (v != null) ms.add(v.toDouble());
      if (s.stopMeasure == 'hal_drained') halDrained++;
      if (s.source == 'native') native++;
      final r = s.payload['audio_route'] as String? ?? '';
      final key = r.isEmpty ? '(못 읽음)' : r;
      routes[key] = (routes[key] ?? 0) + 1;
    }

    final timed = ms.length;
    return CancelRigSummary(
      total: samples.length,
      timed: timed,
      medianMs: timed == 0 ? 0 : percentile(ms, 50),
      p95Ms: timed == 0 ? 0 : percentile(ms, 95),
      maxMs: timed == 0 ? 0 : ms.reduce((a, b) => a > b ? a : b),
      halDrainedRatio: timed == 0 ? 0 : halDrained / timed,
      nativeRatio: timed == 0 ? 0 : native / timed,
      residualFails: residualFails,
      resumeFails: resumeFails,
      payloadMissing: missing,
      routeCounts: routes,
    );
  }

  /// 시도한 총 횟수.
  final int total;

  /// 그중 타이밍을 낼 수 있었던(회신이 온) 횟수.
  final int timed;

  final double medianMs;
  final double p95Ms;
  final double maxMs;

  /// 정지 시점을 HAL 잔량까지 실측한 비율(0~1). 낮으면 `client_stop_ms` 가 실제보다
  /// 짧게 나왔을 수 있다.
  final double halDrainedRatio;

  /// 재생량이 네이티브 실측인 비율(0~1). 낮으면 서버가 `played_server_bytes` 를
  /// 외삽값으로 받는다.
  final double nativeRatio;

  final int residualFails;
  final int resumeFails;
  final int payloadMissing;

  /// 라우트별 표본 수. **AEC 를 바꾸면 여기가 먼저 움직인다** — 통화 용도 오디오는
  /// 헤드셋이 없으면 리시버로 빠지려 하므로, `speaker` 였던 게 `receiver` 로 넘어가면
  /// "에코는 줄었는데 소리가 작아졌다"의 정체가 바로 이것이다. 측정이 끝난 뒤가 아니라
  /// 요약에서 바로 보여야 한다.
  final Map<String, int> routeCounts;

  /// 라우트가 측정 도중 바뀌었는가. 바뀌었으면 앞뒤 숫자를 한 덩어리로 못 읽는다.
  bool get routeChanged => routeCounts.length > 1;

  /// 배관 자체가 깨진 건수. 여기 하나라도 있으면 타이밍 판정은 의미가 없다.
  int get brokenCount => residualFails + resumeFails + payloadMissing;

  /// **p95 가 못 보는 표본 수.**
  ///
  /// nearest-rank 정의상 p95 는 상위 `N - ceil(0.95N)` 개를 통째로 넘긴다. N=20 이면
  /// 그게 딱 **1건**이라, 20회 중 한 번만 500ms 가 나와도 p95 는 아무 일도 없었다고
  /// 말한다. 우리가 찾는 게 정확히 그 간헐 1건이므로, 판정 옆에 이걸 같이 드러낸다
  /// (50회 이상 돌리면 2건 이상이 되어 꼬리가 p95 에 잡히기 시작한다).
  int get hiddenAboveP95 => timed - (0.95 * timed).ceil();

  CancelVerdict get verdict {
    if (total == 0 || timed == 0) return CancelVerdict.noData;
    if (brokenCount > 0) return CancelVerdict.brokenPipeline;
    if (p95Ms > kCancelStopTargetMaxMs) return CancelVerdict.tooSlow;
    // HAL 잔량을 절반도 못 쟀으면 숫자가 낙관적으로 치우쳐 있다. 통과로 읽지 않는다.
    if (halDrainedRatio < 0.5) return CancelVerdict.passUnverified;
    return CancelVerdict.pass;
  }

  /// 판정을 사람이 읽는 한 줄로. 숨기지 않고 그대로 쓴다.
  ///
  /// p95 가 목표선 안이어도 **최댓값이 넘으면 반드시 덧붙인다** — 안 그러면 p95 가
  /// 넘겨버린 간헐 1건이 "통과" 뒤에 숨는다([hiddenAboveP95]).
  String get verdictLine {
    final base = _verdictBase;
    if (verdict != CancelVerdict.brokenPipeline &&
        maxMs > kCancelStopTargetMaxMs &&
        p95Ms <= kCancelStopTargetMaxMs) {
      return '$base\n⚠ 최댓값 ${maxMs.toStringAsFixed(0)}ms 는 목표 초과다 — '
          'p95 는 상위 $hiddenAboveP95건을 안 본다. 반복을 늘려 재확인해라';
    }
    return base;
  }

  String get _verdictBase {
    switch (verdict) {
      case CancelVerdict.noData:
        return '판정 불가 — 표본 없음';
      case CancelVerdict.brokenPipeline:
        return '❌ 배관 실패 $brokenCount건 '
            '(락업 $resumeFails · 잔여미폐기 $residualFails · 무회신 $payloadMissing) '
            '— 타이밍 판정 이전의 문제다';
      case CancelVerdict.tooSlow:
        return '❌ p95 ${p95Ms.toStringAsFixed(0)}ms > 목표 ${kCancelStopTargetMaxMs}ms';
      case CancelVerdict.passUnverified:
        return '⚠ p95 ${p95Ms.toStringAsFixed(0)}ms 는 목표 안이지만 '
            'HAL 잔량 실측이 ${(halDrainedRatio * 100).toStringAsFixed(0)}% 뿐이다 '
            '— 실제보다 짧게 나왔을 수 있다';
      case CancelVerdict.pass:
        return '✅ p95 ${p95Ms.toStringAsFixed(0)}ms ≤ 목표 ${kCancelStopTargetMaxMs}ms '
            '(HAL 실측 ${(halDrainedRatio * 100).toStringAsFixed(0)}%)';
    }
  }
}

/// 표본을 CSV 로. 한 줄 = 한 번의 취소.
String buildCancelRigCsv(List<CancelSample> samples) {
  final b = StringBuffer(
    'i,client_stop_ms,stop_measure,source,played_server_bytes,platform,'
    'audio_route,turn_id,residual_injected_bytes,residual_discarded_bytes,'
    'residual_ok,resume_drain_ms,resume_ok\n',
  );
  for (final s in samples) {
    b.writeln([
      s.index,
      s.clientStopMs ?? '',
      s.stopMeasure,
      s.source,
      s.payloadMissing ? '' : s.playedServerBytes,
      s.payload['platform'] ?? '',
      s.payload['audio_route'] ?? '',
      s.payload['turn_id'] ?? '',
      s.residualInjectedBytes,
      s.residualDiscardedBytes,
      s.residualOk,
      s.resumeDrainMs,
      s.resumeOk,
    ].join(','));
  }
  return b.toString();
}

/// 사람이 읽는 리포트. 숫자에는 전부 단위를 붙인다.
///
/// [aecNote] 는 **반드시** 채운다 — AEC 설정을 바꾸면 라우팅·볼륨·지연이 같이 변해
/// 측정치가 통째로 달라진다. 어느 설정에서 잰 값인지 안 적으면 전후 비교가 불가능하다.
String buildCancelRigReport({
  required List<CancelSample> samples,
  required String deviceLabel,
  required String timestamp,
  required int cancelDelayMs,
  required int residualMs,
  required String aecNote,
  Map<String, dynamic> audioDiag = const {},
}) {
  final s = CancelRigSummary.of(samples);
  final b = StringBuffer()
    ..writeln('# 취소 배관 측정 리포트')
    ..writeln()
    ..writeln('- 기기: $deviceLabel')
    ..writeln('- 시각: $timestamp')
    ..writeln('- AEC 설정: $aecNote')
    // AEC 를 바꾸면 라우팅·볼륨이 같이 움직인다. 측정치만 있고 이게 없으면
    // "에코는 줄었는데 소리가 리시버로 빠졌다"를 나중에야 알게 된다.
    ..writeln('- 오디오 상태: ${audioDiag.isEmpty ? '(못 읽음 — Android 아님/실패)' : audioDiag}')
    ..writeln('- 조건: 턴 시작 후 ${cancelDelayMs}ms 에 취소 '
        '→ 잔여 ${residualMs}ms 추가 주입(전량 폐기돼야 함)')
    ..writeln('- 프레임 주입 경로: `_onWsData` (소켓과 동일 관문). '
        '서버 없이 로컬 주입이지만 `client_stop_ms` 는 전부 클라 내부 구간이라 실측값이다.')
    ..writeln()
    ..writeln('## 판정')
    ..writeln()
    ..writeln(s.verdictLine)
    ..writeln()
    ..writeln('## 요약 (${s.timed}/${s.total} 표본)')
    ..writeln()
    ..writeln('| 항목 | 값 |')
    ..writeln('|---|---|')
    ..writeln('| client_stop_ms 중앙값 | ${s.medianMs.toStringAsFixed(0)} ms |')
    ..writeln('| client_stop_ms p95 | ${s.p95Ms.toStringAsFixed(0)} ms |')
    ..writeln('| client_stop_ms 최댓값 | ${s.maxMs.toStringAsFixed(0)} ms |')
    ..writeln('| p95 가 안 보는 상위 표본 | ${s.hiddenAboveP95} 건 |')
    ..writeln('| stop_measure = hal_drained | '
        '${(s.halDrainedRatio * 100).toStringAsFixed(0)} % |')
    ..writeln('| source = native | ${(s.nativeRatio * 100).toStringAsFixed(0)} % |')
    ..writeln('| 락업(재생 안 살아남) | ${s.resumeFails} 건 |')
    ..writeln('| 잔여 미폐기 | ${s.residualFails} 건 |')
    ..writeln('| 무회신 | ${s.payloadMissing} 건 |')
    ..writeln('| 출력 라우트 | ${s.routeCounts.entries.map((e) => '${e.key} ${e.value}건').join(' · ')}'
        '${s.routeChanged ? ' ⚠ 측정 도중 바뀜' : ''} |')
    ..writeln()
    ..writeln('## 표본')
    ..writeln()
    ..writeln('```csv')
    ..write(buildCancelRigCsv(samples))
    ..writeln('```');
  return b.toString();
}
