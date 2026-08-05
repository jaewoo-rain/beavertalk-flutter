import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/echo_metrics.dart';
import 'package:beavertalk/features/normalcall/domain/entities/echo_report.dart';

/// 이 숫자들이 그대로 서버의 에코 게이트 상수가 된다. 특히 **단위**가 틀리면
/// 26dB 짜리 오해가 그대로 배포된다.
void main() {
  group('RMS / 단위 환산', () {
    test('풀스케일 사인은 정규화 RMS ≈ 0.707', () {
      const n = 4800;
      final b = ByteData(n * 2);
      for (var i = 0; i < n; i++) {
        final v = (math.sin(2 * math.pi * 100 * i / 24000) * 32767).round();
        b.setInt16(i * 2, v, Endian.little);
      }
      final rms = rmsOfPcm16(b.buffer.asUint8List());
      expect(rms, closeTo(0.707, 0.01));
    });

    test('무음은 0, 빈 입력도 0', () {
      expect(rmsOfPcm16(Uint8List(200)), 0.0);
      expect(rmsOfPcm16(Uint8List(0)), 0.0);
    });

    test('홀수 바이트는 버린다 (온전한 샘플만 센다)', () {
      expect(() => rmsOfPcm16(Uint8List(3)), returnsNormally);
    });

    test('dBFS ↔ 정규화 RMS 왕복', () {
      for (final rms in [0.05, 0.001, 0.5, 1.0]) {
        expect(dbfsToRms(rmsToDbfs(rms)), closeTo(rms, 1e-9));
      }
    });

    test('서버 기본값 0.05 는 약 −26 dBFS — 문서와 일치해야 한다', () {
      expect(rmsToDbfs(0.05), closeTo(-26.0, 0.1));
    });

    test('무음의 dBFS 는 −infinity 가 아니라 유한한 하한', () {
      expect(rmsToDbfs(0.0), -120.0);
      expect(rmsToDbfs(0.0).isFinite, isTrue);
    });
  });

  group('백분위 (nearest-rank)', () {
    final v = [for (var i = 1; i <= 100; i++) i.toDouble()];

    test('p50 / p5 / p95', () {
      expect(percentile(v, 50), 50);
      expect(percentile(v, 5), 5);
      expect(percentile(v, 95), 95);
    });

    test('경계와 빈 입력', () {
      expect(percentile(v, 0), 1);
      expect(percentile(v, 100), 100);
      expect(percentile([], 95), 0.0);
    });

    test('원본을 정렬로 훼손하지 않는다', () {
      final src = [3.0, 1.0, 2.0];
      percentile(src, 50);
      expect(src, [3.0, 1.0, 2.0]);
    });
  });

  group('③ 버스트 검출', () {
    test('임계를 연속으로 넘은 구간만 센다', () {
      final runs = burstDurationsMs(
        frameRms: [0, 0, 5, 5, 5, 0, 0, 5, 0],
        threshold: 1,
        frameMs: 20,
      );
      expect(runs, [60, 20]);
    });

    test('끝까지 임계 위면 그 구간도 센다 — 자르면 긴 버스트가 사라져 p95 가 낙관적이 된다', () {
      final runs = burstDurationsMs(
        frameRms: [0, 5, 5, 5],
        threshold: 1,
        frameMs: 20,
      );
      expect(runs, [60]);
    });

    test('전부 임계 아래면 버스트 없음', () {
      expect(
        burstDurationsMs(frameRms: [0, 0, 0], threshold: 1, frameMs: 20),
        isEmpty,
      );
    });
  });

  group('④ 꼬리', () {
    test('연속 settleFrames 개가 임계 아래여야 복귀로 친다', () {
      // 인덱스 3부터 3개 연속 아래 → 3 * 20ms
      final ms = tailMs(
        frameRms: [5, 5, 5, 0, 0, 0],
        threshold: 1,
        frameMs: 20,
        settleFrames: 3,
      );
      expect(ms, 60);
    });

    test('한 프레임만 내려간 것은 복귀가 아니다 (진폭 변동에 안 속는다)', () {
      final ms = tailMs(
        frameRms: [5, 0, 5, 0, 0, 0],
        threshold: 1,
        frameMs: 20,
        settleFrames: 3,
      );
      expect(ms, 60); // 인덱스 3부터가 진짜 복귀
    });

    test('끝까지 안 내려가면 관측 구간 전체를 반환 (하한이 아님)', () {
      final frames = [5.0, 5.0, 5.0];
      final ms = tailMs(frameRms: frames, threshold: 1, frameMs: 20);
      expect(ms, 60);
    });
  });

  group('⭐ 미리 정해진 판정 — energyGateUnusable', () {
    EchoRigResult make({required double echoP95, required double speechP5}) {
      return EchoRigResult(
        route: EchoRoute.speakerphone,
        noiseFloor: RmsStats.empty,
        echo: RmsStats(count: 100, median: echoP95 / 2, p5: 0, p95: echoP95),
        speech: RmsStats(count: 100, median: speechP5 * 2, p5: speechP5, p95: 0),
        burst: const DurationStats(count: 5, p95Ms: 320),
        tail: const DurationStats(count: 1, p95Ms: 180),
        tailSettled: true,
        stimulusNote: 'test',
      );
    }

    test('에코가 사용자 최소 발화보다 크면 에너지로 못 가른다', () {
      expect(make(echoP95: 0.09, speechP5: 0.05).energyGateUnusable, isTrue);
    });

    test('같아도 못 가른다 (>= 이다)', () {
      expect(make(echoP95: 0.05, speechP5: 0.05).energyGateUnusable, isTrue);
    });

    test('에코가 더 작으면 가를 수 있다', () {
      expect(make(echoP95: 0.01, speechP5: 0.05).energyGateUnusable, isFalse);
    });

    test('임계 후보는 기하평균 — 산술평균이 아니다 (청감이 로그 지각)', () {
      final r = make(echoP95: 0.01, speechP5: 0.09);
      expect(r.suggestedBargeInRms, closeTo(0.03, 1e-9)); // √(0.01*0.09)
      expect(r.suggestedBargeInRms, isNot(closeTo(0.05, 1e-9))); // 산술평균이면 0.05
    });

    test('MIN_MS 는 150 을 하한으로 둔다', () {
      final short = EchoRigResult(
        route: EchoRoute.headset,
        noiseFloor: RmsStats.empty,
        echo: const RmsStats(count: 1, median: 0, p5: 0, p95: 0.01),
        speech: const RmsStats(count: 1, median: 0, p5: 0.05, p95: 0),
        burst: const DurationStats(count: 3, p95Ms: 40),
        tail: DurationStats.empty,
        tailSettled: true,
        stimulusNote: 'test',
      );
      expect(short.suggestedMinMs, 150);
      expect(make(echoP95: 0.01, speechP5: 0.05).suggestedMinMs, 320);
    });
  });

  group('리포트', () {
    EchoRigResult sample({required bool unusable}) => EchoRigResult(
          route: EchoRoute.speakerphone,
          noiseFloor: const RmsStats(count: 150, median: 0.002, p5: 0, p95: 0),
          echo: RmsStats(
              count: 750, median: 0.01, p5: 0, p95: unusable ? 0.09 : 0.01),
          speech: const RmsStats(count: 750, median: 0.2, p5: 0.05, p95: 0),
          burst: const DurationStats(count: 12, p95Ms: 320),
          tail: const DurationStats(count: 1, p95Ms: 180),
          tailSettled: true,
          stimulusNote: 'test-stimulus',
        );

    test('모든 숫자에 단위가 붙는다 — 단위 없는 숫자가 제일 나쁘다', () {
      final r = buildEchoReport(
        results: [sample(unusable: false)],
        deviceLabel: 'test',
        timestamp: '2026-08-05T20:00:00',
      );
      expect(r, contains('0~1 정규화 RMS'));
      expect(r, contains('dBFS'));
      expect(r, contains('rms = 10^(dBFS/20)'));
    });

    test('가를 수 있으면 서버 상수 후보를 찍는다', () {
      final r = buildEchoReport(
        results: [sample(unusable: false)],
        deviceLabel: 'test',
        timestamp: 't',
      );
      expect(r, contains('CASCADE_BARGEIN_RMS'));
      expect(r, contains('CASCADE_BARGEIN_MIN_MS = 320'));
      expect(r, contains('CASCADE_ECHO_TAIL_MS   = 180'));
    });

    test('못 가르는 결과를 숨기지 않고 전사 확인 전환을 명시한다', () {
      final r = buildEchoReport(
        results: [sample(unusable: true)],
        deviceLabel: 'test',
        timestamp: 't',
      );
      expect(r, contains('에너지만으로는'));
      expect(r, contains('confirm=transcript'));
      expect(r, contains('측정 실패가 아니다'));
      // 못 가르는데 상수를 제안하면 안 된다.
      expect(r, isNot(contains('CASCADE_BARGEIN_RMS')));
    });

    test('③④가 미검증임을 본문에 표기한다', () {
      final r = buildEchoReport(
        results: [sample(unusable: false)],
        deviceLabel: 'test',
        timestamp: 't',
      );
      expect(r, contains('미검증'));
    });

    test('꼬리가 관측구간에 잘리면 그 사실을 표기한다', () {
      final cut = EchoRigResult(
        route: EchoRoute.headset,
        noiseFloor: RmsStats.empty,
        echo: const RmsStats(count: 1, median: 0, p5: 0, p95: 0.01),
        speech: const RmsStats(count: 1, median: 0, p5: 0.05, p95: 0),
        burst: DurationStats.empty,
        tail: const DurationStats(count: 1, p95Ms: 3000),
        tailSettled: false,
        stimulusNote: 'test',
      );
      final r = buildEchoReport(
          results: [cut], deviceLabel: 'test', timestamp: 't');
      expect(r, contains('관측구간에 잘림'));
    });
  });
}
