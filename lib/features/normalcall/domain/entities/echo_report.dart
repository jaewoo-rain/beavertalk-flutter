import 'echo_metrics.dart';

/// 측정 결과를 **사람이 옮겨 적다 틀리지 않게** 텍스트로 만든다.
///
/// 이 리포트가 그대로 백엔드로 넘어가 서버 상수가 된다. 그래서 규칙이 둘 있다:
///   1. **모든 숫자에 단위를 붙인다.** 서버 임계는 0~1 정규화 RMS 인데 계측 관례는
///      dBFS 라, 단위 없는 숫자 하나가 26dB 짜리 오해를 만든다
///   2. **판정과 한계를 숨기지 않는다.** 에너지로 못 가르는 결과도, 미검증 항목도
///      리포트 본문에 찍는다
String buildEchoReport({
  required List<EchoRigResult> results,
  required String deviceLabel,
  required String timestamp,
}) {
  final b = StringBuffer();

  b.writeln('# BeaverTalk 에코 측정 리포트');
  b.writeln();
  b.writeln('- 측정: $timestamp');
  b.writeln('- 기기: $deviceLabel');
  b.writeln();
  b.writeln('## 단위 (⚠ 반드시 확인)');
  b.writeln();
  b.writeln('- `rms` = **0~1 정규화 RMS** = `sqrt(sum(x^2)/N) / 32768`  ← **서버 임계가 쓰는 단위**');
  b.writeln('- `dBFS` = `20*log10(rms)` (표시용). 역환산 `rms = 10^(dBFS/20)`');
  b.writeln('- 지속시간은 전부 **ms**');
  b.writeln();

  for (final r in results) {
    b.writeln('---');
    b.writeln();
    b.writeln('## 조건: ${r.route.label}');
    b.writeln();
    b.writeln('자극음: ${r.stimulusNote}');
    b.writeln();
    b.writeln('| 항목 | 통계 | rms (0~1) | dBFS | 표본 |');
    b.writeln('|---|---|---|---|---|');
    _row(b, '0 환경소음', '중앙값', r.noiseFloor.median, r.noiseFloor.count);
    _row(b, '① 에코', '중앙값', r.echo.median, r.echo.count);
    _row(b, '① 에코', '**p95**', r.echo.p95, r.echo.count);
    _row(b, '② 사용자 발화', '중앙값', r.speech.median, r.speech.count);
    _row(b, '② 사용자 발화', '**p5**', r.speech.p5, r.speech.count);
    b.writeln();
    b.writeln('| 항목 | 통계 | 값 | 표본 | 비고 |');
    b.writeln('|---|---|---|---|---|');
    b.writeln('| ③ 에코 버스트 | **p95** | ${r.burst.p95Ms} ms | ${r.burst.count} '
        '| ⚠ 실기기 미검증 |');
    b.writeln('| ④ 정지 후 꼬리 | **p95** | ${r.tail.p95Ms} ms | ${r.tail.count} '
        '| ⚠ 실기기 미검증${r.tailSettled ? '' : ' · **관측구간에 잘림(하한 아님)**'} |');
    b.writeln();

    b.writeln('### 판정');
    b.writeln();
    if (r.energyGateUnusable) {
      b.writeln('⛔ **에너지만으로는 에코와 사용자 발화를 가를 수 없다.**');
      b.writeln();
      b.writeln('`echo_p95 (${_f(r.echo.p95)}) >= speech_p5 (${_f(r.speech.p5)})` —');
      b.writeln('에코가 사용자의 가장 작은 목소리보다 크거나 같다. 임계를 에코 위로 올리면');
      b.writeln('작게 말하는 사용자가 통째로 씹히고, 내리면 에코가 barge-in 으로 오인된다.');
      b.writeln();
      b.writeln('→ 서버는 **에너지 게이트를 끄고 전사 기반 확인(confirm=transcript)** 으로 전환한다.');
      b.writeln('→ 이건 측정 실패가 아니다. 설계 분기를 고르는 결과다.');
    } else {
      b.writeln('✅ 에너지로 가를 수 있다 — `echo_p95 (${_f(r.echo.p95)})'
          ' < speech_p5 (${_f(r.speech.p5)})`');
      b.writeln();
      b.writeln('서버 상수 후보:');
      b.writeln();
      b.writeln('```');
      b.writeln('CASCADE_BARGEIN_RMS    = ${_f(r.suggestedBargeInRms)}   '
          '# 0~1 정규화 RMS (= sqrt(echo_p95 * speech_p5))');
      b.writeln('CASCADE_BARGEIN_MIN_MS = ${r.suggestedMinMs}   '
          '# max(150, burst_p95)');
      b.writeln('CASCADE_ECHO_TAIL_MS   = ${r.tail.p95Ms}   # tail_p95');
      b.writeln('```');
      b.writeln();
      b.writeln('⚠ MIN_MS 와 TAIL_MS 는 ③④에서 나온 값이라 **실기기 미검증** 상태다.');
    }
    b.writeln();
  }

  b.writeln('---');
  b.writeln();
  b.writeln('## 이 리포트의 한계');
  b.writeln();
  b.writeln('- ③④는 환경소음 기반 임계로 판정한다. 정의는 확정이지만 실제 에코 파형에서');
  b.writeln('  런이 어떻게 끊기는지는 실기기 세션으로만 확인된다 — **미검증**으로 읽어라');
  b.writeln('- 자극음이 실제 서버 TTS 가 아니면 플랫폼 AEC 의 적응 거동이 달라질 수 있다.');
  b.writeln('  각 조건의 "자극음" 항목을 확인할 것');
  b.writeln('- ①과 ②는 같은 조건·같은 볼륨에서 연속 측정된 값이어야 비교가 성립한다');

  return b.toString();
}

void _row(StringBuffer b, String item, String stat, double rms, int count) {
  b.writeln('| $item | $stat | ${_f(rms)} | ${rmsToDbfs(rms).toStringAsFixed(1)} | $count |');
}

String _f(double v) => v.toStringAsFixed(5);
