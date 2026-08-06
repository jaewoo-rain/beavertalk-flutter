import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/cancel_rig_metrics.dart';

/// 표본 하나 만들기 — 기본은 "전부 정상".
CancelSample sample({
  int index = 0,
  int? clientStopMs = 80,
  String stopMeasure = 'hal_drained',
  String source = 'native',
  int playedServerBytes = 48000,
  int residualInjected = 14400,
  int? residualDiscarded,
  int resumeDrainMs = 40,
  bool missing = false,
}) =>
    CancelSample(
      index: index,
      payload: missing
          ? const {}
          : {
              'type': 'playback_progress',
              'turn_id': 'rig-$index',
              'played_server_bytes': playedServerBytes,
              'source': source,
              'sampled_at': 'stop',
              'client_stop_ms': clientStopMs,
              'stop_measure': stopMeasure,
              'platform': 'android',
              'audio_route': 'speaker',
            },
      residualInjectedBytes: residualInjected,
      residualDiscardedBytes: residualDiscarded ?? residualInjected,
      resumeDrainMs: resumeDrainMs,
    );

void main() {
  group('CancelSample', () {
    test('회신이 오면 페이로드 필드를 그대로 읽는다', () {
      final s = sample(clientStopMs: 95);
      expect(s.clientStopMs, 95);
      expect(s.stopMeasure, 'hal_drained');
      expect(s.source, 'native');
      expect(s.playedServerBytes, 48000);
      expect(s.payloadMissing, isFalse);
      expect(s.ok, isTrue);
    });

    test('회신이 없으면 타이밍이 null 이고 성공이 아니다', () {
      final s = sample(missing: true);
      expect(s.payloadMissing, isTrue);
      expect(s.clientStopMs, isNull);
      expect(s.ok, isFalse);
    });

    test('잔여가 한 바이트라도 덜 버려지면 실패다', () {
      final s = sample(residualInjected: 14400, residualDiscarded: 14398);
      expect(s.residualOk, isFalse);
      expect(s.ok, isFalse);
    });

    test('재개 드레인 -1 은 락업이다', () {
      final s = sample(resumeDrainMs: -1);
      expect(s.resumeOk, isFalse);
      expect(s.ok, isFalse);
    });

    test('드레인 0ms 는 정상이다 (즉시 비워진 것)', () {
      expect(sample(resumeDrainMs: 0).resumeOk, isTrue);
    });
  });

  group('CancelRigSummary — 실패는 타이밍에 섞이지 않는다', () {
    test('무회신 표본은 타이밍 통계에서 빠진다', () {
      final s = CancelRigSummary.of([
        sample(index: 0, clientStopMs: 100),
        sample(index: 1, missing: true),
        sample(index: 2, clientStopMs: 100),
      ]);
      expect(s.total, 3);
      expect(s.timed, 2);
      expect(s.payloadMissing, 1);
      // 0ms 로 섞였다면 중앙값이 100 아래로 내려갔을 것이다.
      expect(s.medianMs, 100);
    });

    test('실패 건수가 있으면 타이밍이 좋아도 통과가 아니다', () {
      final s = CancelRigSummary.of([
        sample(index: 0, clientStopMs: 60),
        sample(index: 1, clientStopMs: 60, resumeDrainMs: -1),
      ]);
      expect(s.p95Ms, lessThan(kCancelStopTargetMaxMs.toDouble()));
      expect(s.resumeFails, 1);
      expect(s.verdict, CancelVerdict.brokenPipeline);
    });

    test('잔여 미폐기도 배관 실패로 잡힌다', () {
      final s = CancelRigSummary.of([
        sample(index: 0, residualInjected: 100, residualDiscarded: 0),
      ]);
      expect(s.residualFails, 1);
      expect(s.brokenCount, 1);
      expect(s.verdict, CancelVerdict.brokenPipeline);
    });
  });

  group('CancelRigSummary — 판정', () {
    test('표본이 없으면 판정 불가', () {
      expect(CancelRigSummary.of([]).verdict, CancelVerdict.noData);
    });

    test('p95 가 목표선 안이고 HAL 실측이 충분하면 통과', () {
      final s = CancelRigSummary.of([
        for (var i = 0; i < 20; i++) sample(index: i, clientStopMs: 70),
      ]);
      expect(s.p95Ms, 70);
      expect(s.halDrainedRatio, 1.0);
      expect(s.verdict, CancelVerdict.pass);
    });

    test('p95 가 목표선을 넘으면 초과 — 중앙값이 좋아도 마찬가지다', () {
      // 절반이 60ms, 절반이 500ms. 중앙값만 보면 애매하지만 꼬리는 명백하다.
      final s = CancelRigSummary.of([
        for (var i = 0; i < 10; i++) sample(index: i, clientStopMs: 60),
        for (var i = 10; i < 20; i++) sample(index: i, clientStopMs: 500),
      ]);
      expect(s.p95Ms, greaterThan(kCancelStopTargetMaxMs.toDouble()));
      expect(s.verdict, CancelVerdict.tooSlow);
    });

    test('N=20 에서 p95 는 상위 1건을 안 본다 — 그래서 최댓값을 판정 옆에 붙인다', () {
      // 이게 우리가 찾는 간헐 결함의 모양이다: 19번 멀쩡하고 1번만 튄다.
      final s = CancelRigSummary.of([
        for (var i = 0; i < 19; i++) sample(index: i, clientStopMs: 60),
        sample(index: 19, clientStopMs: 500),
      ]);
      expect(s.hiddenAboveP95, 1);
      expect(s.p95Ms, 60); // ← p95 는 아무 일도 없었다고 말한다
      expect(s.maxMs, 500);
      expect(s.verdict, CancelVerdict.pass);
      // 판정 줄에는 반드시 드러나야 한다. 안 그러면 "통과" 뒤에 숨는다.
      expect(s.verdictLine, contains('최댓값 500ms'));
      expect(s.verdictLine, contains('상위 1건'));
    });

    test('N=200 이면 p95 가 상위 10건을 넘긴다 (꼬리가 잡히기 시작한다)', () {
      final s = CancelRigSummary.of([
        for (var i = 0; i < 200; i++) sample(index: i, clientStopMs: 60),
      ]);
      expect(s.hiddenAboveP95, 10);
    });

    test('최댓값도 목표선 안이면 경고를 안 붙인다', () {
      final s = CancelRigSummary.of([
        for (var i = 0; i < 20; i++) sample(index: i, clientStopMs: 60),
      ]);
      expect(s.verdictLine, isNot(contains('최댓값')));
    });

    test('HAL 실측이 절반 미만이면 통과로 읽지 않는다', () {
      final s = CancelRigSummary.of([
        for (var i = 0; i < 8; i++)
          sample(index: i, clientStopMs: 60, stopMeasure: 'clear_returned'),
        for (var i = 8; i < 10; i++) sample(index: i, clientStopMs: 60),
      ]);
      expect(s.halDrainedRatio, 0.2);
      expect(s.verdict, CancelVerdict.passUnverified);
      expect(s.verdictLine, contains('짧게 나왔을 수 있다'));
    });

    test('native 비율은 estimate 표본을 제외하고 센다', () {
      final s = CancelRigSummary.of([
        sample(index: 0, source: 'native'),
        sample(index: 1, source: 'estimate'),
      ]);
      expect(s.nativeRatio, 0.5);
    });

    test('최댓값은 실제 최댓값이다', () {
      final s = CancelRigSummary.of([
        sample(index: 0, clientStopMs: 40),
        sample(index: 1, clientStopMs: 310),
        sample(index: 2, clientStopMs: 90),
      ]);
      expect(s.maxMs, 310);
    });
  });

  group('내보내기', () {
    test('CSV 는 헤더 + 표본당 한 줄', () {
      final csv = buildCancelRigCsv([sample(index: 0), sample(index: 1)]);
      final lines = csv.trim().split('\n');
      expect(lines.length, 3);
      expect(lines.first, startsWith('i,client_stop_ms,stop_measure'));
      expect(lines[1], startsWith('0,80,hal_drained,native,48000,android,speaker'));
    });

    test('무회신 표본도 CSV 에 남는다 (조용히 사라지면 안 된다)', () {
      final csv = buildCancelRigCsv([sample(index: 7, missing: true)]);
      expect(csv, contains('\n7,,,,'));
    });

    test('리포트에 AEC 설정과 판정이 들어간다', () {
      final text = buildCancelRigReport(
        samples: [sample(index: 0, clientStopMs: 70)],
        deviceLabel: 'android 14',
        timestamp: '2026-08-07T02:00:00',
        cancelDelayMs: 1500,
        residualMs: 300,
        aecNote: 'AEC 변경 전',
      );
      expect(text, contains('AEC 설정: AEC 변경 전'));
      expect(text, contains('1500ms 에 취소'));
      expect(text, contains('client_stop_ms p95'));
      expect(text, contains('```csv'));
    });
  });
}
