import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../features/normalcall/data/datasources/audio_route_probe.dart';
import '../features/normalcall/domain/entities/cancel_rig_metrics.dart';
import '../features/normalcall/domain/entities/echo_stimulus.dart';
import '../features/normalcall/presentation/normalcall_controller.dart';

/// 취소 배관 리그 (개발자 전용, `/dev/cancel-rig`).
///
/// ## 무엇을 재는가
///
/// **`client_stop_ms` — `audio_cancel` 수신부터 스피커가 실제로 조용해지기까지(ms).**
/// 목표선은 50~120ms 이고, **p95** 로 판정한다(중앙값이 아니다 — 문제는 꼬리에서 난다).
///
/// ## 왜 서버 없이 재도 되는가
///
/// 저 구간은 **전부 클라 내부**다. 서버가 기여하는 건 RTT 뿐이고 그건 이번 측정
/// 대상이 아니다. 그래서 프레임을 클라 안에서 주입해도 **나오는 숫자는 진짜다.**
/// 대용품이 아니다.
///
/// ## ⛔ 주입은 `_onWsData` 로만
///
/// [NormalCallController.debugInjectWsFrame] 하나로만 들어간다. `_clearPlayback()`
/// 이나 `_onAudioCancel()` 을 직접 부르면 **실제로는 안 도는 경로**를 검증한 게 된다.
/// 이 경로로 넣으면 파싱·디스패치·게이팅·원장·`clear()`·회신 구성까지 한 줄도
/// 우회하지 않는다.
///
/// ## 진짜 목적은 간헐 결함이다
///
/// 여기서 잡으려는 두 결함(네이티브 **영구 락업**, **미write 바이트 누락**)은 둘 다
/// 단위 테스트로는 안 잡히고 실기기에서 가끔만 난다. **1회 성공은 아무것도 증명하지
/// 않는다** — 그래서 수백 회 반복을 전제로 만들었다.
class CancelRigScreen extends ConsumerStatefulWidget {
  const CancelRigScreen({super.key});

  @override
  ConsumerState<CancelRigScreen> createState() => _CancelRigScreenState();
}

class _CancelRigScreenState extends ConsumerState<CancelRigScreen> {
  // 통화 경로와 같은 규격 — 다른 규격으로 재면 그 숫자는 통화에 못 쓴다.
  static const int _rate = 24000;
  static const int _bytesPerMs = _rate * 2 ~/ 1000; // PCM16 mono = 48 B/ms

  /// 취소 직후 일부러 더 흘릴 시간. 서버 페이서가 즉시 멎지 않는 현실을 재현한다 —
  /// 이 구간의 바이트는 **전량 폐기**돼야 한다.
  static const int _residualMs = 300;

  /// 취소 후 새 턴을 열고 밀어 넣을 오디오 길이(락업 회귀 검사용).
  ///
  /// 900ms 프리버퍼 쿠션을 넘겨야 재생이 실제로 시작된다. 그보다 짧게 주면 큐가 안
  /// 빠지는 이유가 "락업"인지 "쿠션 미달"인지 구분이 안 된다 — 그래서 넉넉히 준다.
  static const int _resumeMs = 1200;

  /// 큐가 다시 비워지기를 기다리는 상한. 정상이면 펌프 한두 틱(40ms)이면 끝난다.
  static const Duration _drainLimit = Duration(milliseconds: 1500);

  /// 회신([playback_progress]) 대기 상한.
  static const Duration _payloadLimit = Duration(seconds: 2);

  /// 다음 반복 전에 엔진에 남은 오디오가 다 나가도록 기다리는 시간.
  /// 안 기다리면 이전 턴의 잔량이 다음 표본의 `played_server_bytes` 와
  /// `client_stop_ms` 에 섞여 반복이 서로 독립이 아니게 된다.
  static const int _settleMs = 500;

  // ── 설정 ──────────────────────────────────────────────────────────────────

  int _iterations = 20;

  /// 턴 시작 후 취소까지. 900ms 쿠션을 넘겨야 실제 재생 중에 취소하는 게 된다.
  int _cancelDelayMs = 1500;

  /// AEC(통화 용도 오디오) 스위치 — **선언이 아니라 실제로 켜고 끈다.**
  ///
  /// 조작자가 "변경 후"라고 고르기만 하고 빌드는 변경 전인 사고를 원천 차단한다.
  /// 리빌드 없이 한 자리에서 전/후를 재야 두 측정 사이에 빌드가 안 끼어든다 —
  /// 끼면 "무엇 때문에 달라졌는지"를 못 가린다.
  bool _voiceCallAudio = false;

  String get _aecNote => _voiceCallAudio ? _aecAfter : _aecBefore;
  static const String _aecBefore =
      'AEC 변경 전 (AudioTrack USAGE_MEDIA / CONTENT_TYPE_MUSIC, mode NORMAL)';
  static const String _aecAfter =
      'AEC 변경 후 (USAGE_VOICE_COMMUNICATION + MODE_IN_COMMUNICATION)';

  /// 재생 개통 직후 읽은 오디오 상태(모드·스피커폰·라우트·볼륨). 리포트에 그대로 실린다.
  Map<String, dynamic> _diag = const {};

  // ── 진행 상태 ─────────────────────────────────────────────────────────────

  bool _running = false;
  int _done = 0;
  String? _error;
  final List<CancelSample> _samples = [];

  // ── 주입 펌프 ─────────────────────────────────────────────────────────────

  NormalCallController get _ctl =>
      ref.read(normalCallControllerProvider.notifier);

  EchoStimulus? _stimulus;
  Timer? _pumpTimer;
  Stopwatch? _pumpClock;
  int _pumpSentBytes = 0;

  /// 취소 이후 주입한 바이트(폐기돼야 할 양). 컨트롤러가 실제로 버린 양과 비교한다.
  int _residualInjected = 0;
  bool _countingResidual = false;

  Completer<Map<String, dynamic>>? _payloadWait;

  @override
  void initState() {
    super.initState();
    unawaited(_open());
  }

  @override
  void dispose() {
    _stopPump();
    NormalCallController.debugOutboundSink = null;
    // 화면을 벗어나도 엔진이 살아 있으면 다음 통화가 setup() 을 두 번 타게 된다.
    unawaited(_ctl.debugClosePlayback());
    super.dispose();
  }

  Future<void> _open() async {
    try {
      // `_send` 로 나가려던 프레임을 가로챈다. 소켓이 없어 그냥 두면 회신이 조용히
      // 사라진다 — 리그가 재려는 값이 바로 그 안에 있다.
      NormalCallController.debugOutboundSink = _onOutbound;
      await _ctl.debugOpenPlayback(voiceCallAudio: _voiceCallAudio);
      _stimulus = EchoStimulus(sampleRate: _rate);
      // 개통 **후**에 읽는다 — 모드·라우팅이 트랙 생성 시점에 정해지므로, 그 전에
      // 읽으면 적용 전 상태를 리포트에 박게 된다.
      final diag = await AudioRouteProbe.audioDiag();
      if (mounted) setState(() => _diag = diag);
    } catch (e) {
      if (mounted) setState(() => _error = '재생 엔진 개통 실패: $e');
    }
  }

  /// AEC 스위치를 실제로 바꾼다. 엔진을 닫았다 다시 열어야 새 오디오 속성이 먹는다 —
  /// AudioTrack 은 만들어지는 시점의 속성으로 라우팅이 굳는다.
  Future<void> _switchAec(bool voice) async {
    setState(() {
      _voiceCallAudio = voice;
      _error = null;
      // 설정이 바뀌면 앞의 표본과 같은 조건이 아니다. 섞이면 원인을 못 가른다.
      _samples.clear();
      _done = 0;
      _diag = const {};
    });
    _stopPump();
    await _ctl.debugClosePlayback();
    await _open();
  }

  /// 컨트롤러가 서버로 보내려던 제어 프레임. `playback_progress` 만 잡는다.
  void _onOutbound(Map<String, dynamic> msg) {
    if (msg['type'] != 'playback_progress') return;
    final w = _payloadWait;
    if (w != null && !w.isCompleted) w.complete(Map<String, dynamic>.from(msg));
  }

  /// 서버가 실시간으로 보내는 것처럼 PCM24k 를 민다.
  ///
  /// 10ms 타이머로 깨어나되 **보낼 양은 벽시계로 계산한다**(경과 ms × 48B). 청크 개수로
  /// 세면 타이머 지터만큼 실시간보다 빠르거나 느려지고, 그러면 큐 깊이가 실제 통화와
  /// 달라져 취소 시 폐기량이 통째로 달라진다.
  void _startPump() {
    _pumpClock = Stopwatch()..start();
    _pumpSentBytes = 0;
    _pumpTimer?.cancel();
    _pumpTimer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      final clock = _pumpClock;
      final s = _stimulus;
      if (clock == null || s == null) return;
      var want = clock.elapsedMilliseconds * _bytesPerMs - _pumpSentBytes;
      want -= want % 2; // 프레임 경계
      if (want <= 0) return;
      final chunk = s.nextChunk(want ~/ 2);
      final bytes = Uint8List.view(
        chunk.buffer,
        chunk.offsetInBytes,
        chunk.lengthInBytes,
      );
      _pumpSentBytes += bytes.lengthInBytes;
      if (_countingResidual) _residualInjected += bytes.lengthInBytes;
      // ⛔ FlutterPcmSound.feed() 를 직접 부르지 않는다 — 소켓과 같은 관문으로만.
      _ctl.debugInjectWsFrame(bytes);
    });
  }

  void _stopPump() {
    _pumpTimer?.cancel();
    _pumpTimer = null;
    _pumpClock = null;
  }

  void _inject(Map<String, dynamic> frame) =>
      _ctl.debugInjectWsFrame(jsonEncode(frame));

  Future<void> _sleep(int ms) => Future<void>.delayed(Duration(milliseconds: ms));

  // ── 측정 ──────────────────────────────────────────────────────────────────

  Future<void> _runAll() async {
    setState(() {
      _running = true;
      _error = null;
      _done = 0;
      _samples.clear();
    });
    try {
      for (var i = 0; i < _iterations && _running && mounted; i++) {
        final sample = await _runOne(i);
        if (!mounted) return;
        setState(() {
          _samples.add(sample);
          _done = i + 1;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = '측정 중 실패: $e');
    } finally {
      _stopPump();
      if (mounted) setState(() => _running = false);
    }
  }

  Future<CancelSample> _runOne(int i) async {
    final turnId = 'rig-$i';

    // ① 턴을 연다. 문자열이므로 _handleControl 이 파싱부터 실물로 탄다.
    _inject({'type': 'turn_start', 'turn_id': turnId});
    _startPump();
    await _sleep(_cancelDelayMs);

    // ② 취소. 컨트롤러가 여기서 스톱워치를 잡고 clear() 를 돌린다.
    //    `_cancelledResidual=true` / `_cancelledResidualBytes=0` 은 await 이전에
    //    세워지므로, 이 호출이 돌아온 뒤 주입분은 전부 폐기 대상이다.
    _payloadWait = Completer<Map<String, dynamic>>();
    _residualInjected = 0;
    _inject({'type': 'audio_cancel', 'turn_id': turnId});
    _countingResidual = true;

    // ③ 잔여를 일부러 더 흘린다 — 서버 불변식을 리그가 재현하는 자리다.
    await _sleep(_residualMs);
    _stopPump();
    _countingResidual = false;
    final injected = _residualInjected;
    // ⚠ 이 값은 다음 `turn_start` 에서 0 으로 리셋된다. 반드시 지금 읽는다.
    final discarded = _ctl.debugCancelledResidualBytes;

    // ④ 회신 수거. 안 오면 배관이 도중에 멈춘 것이므로 빈 Map 으로 남긴다
    //    (0ms 로 채우면 분포가 좋아 보이고, 정확히 그 실패가 우리가 찾는 것이다).
    Map<String, dynamic> payload = const {};
    try {
      payload = await _payloadWait!.future.timeout(_payloadLimit);
    } on TimeoutException {
      // payload 는 비운 채로 둔다.
    }
    _payloadWait = null;

    // ⑤ 락업 회귀 검사 — 취소 뒤 재생이 실제로 되살아나는가.
    //    네이티브가 in-flight 를 부풀린 채 굳으면 pump 가 Dart 큐에서 아무것도 못
    //    가져가고, 큐가 단조 증가한다. 그게 관측량이다.
    _inject({'type': 'turn_start', 'turn_id': '$turnId-resume'});
    _startPump();
    await _sleep(_resumeMs);
    _stopPump();
    final drainMs = await _awaitDrain();
    _inject({'type': 'turn_end', 'turn_id': '$turnId-resume'});

    // ⑥ 엔진 잔량이 다 나갈 때까지 기다린다 — 반복끼리 독립이어야 한다.
    await _sleep(_resumeMs + _settleMs);

    return CancelSample(
      index: i,
      payload: payload,
      residualInjectedBytes: injected,
      residualDiscardedBytes: discarded,
      resumeDrainMs: drainMs,
    );
  }

  /// Dart 링버퍼가 다시 비워지기까지 걸린 ms. 상한 안에 못 비우면 **-1(락업)**.
  Future<int> _awaitDrain() async {
    final sw = Stopwatch()..start();
    while (sw.elapsed < _drainLimit) {
      if (_ctl.debugQueuedBytes < 2) return sw.elapsedMilliseconds;
      await _sleep(25);
    }
    return -1;
  }

  // ── 내보내기 ──────────────────────────────────────────────────────────────

  Future<void> _export() async {
    final text = buildCancelRigReport(
      samples: _samples,
      deviceLabel:
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      timestamp: DateTime.now().toIso8601String(),
      cancelDelayMs: _cancelDelayMs,
      residualMs: _residualMs,
      aecNote: _aecNote,
      audioDiag: _diag,
    );
    // 로그로도 남긴다 — 파일 공유가 막힌 기기에서도 값을 건질 수 있게.
    debugPrint('=== CANCEL RIG REPORT ===\n$text');
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/cancel_rig_report.md');
      await f.writeAsString(text);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(f.path)], text: 'BeaverTalk 취소 배관 리포트'),
      );
    } catch (e) {
      if (mounted) setState(() => _error = '내보내기 실패(로그에는 남았습니다): $e');
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final summary = CancelRigSummary.of(_samples);
    final estSec =
        (_iterations * (_cancelDelayMs + _residualMs + _resumeMs * 2 + _settleMs)) ~/
            1000;
    return Scaffold(
      appBar: AppBar(title: const Text('취소 배관 리그')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'audio_cancel 수신 → 실제 무음까지(client_stop_ms)를 잽니다.\n'
              '서버 없이 클라 안에서 프레임을 주입하지만, 이 구간은 전부 클라 내부라 '
              '나오는 숫자는 실측값입니다.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            _label('반복 횟수 (1회 성공은 아무것도 증명하지 않습니다)'),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 20, label: Text('20')),
                ButtonSegment(value: 50, label: Text('50')),
                ButtonSegment(value: 200, label: Text('200')),
              ],
              selected: {_iterations},
              onSelectionChanged: _running
                  ? null
                  : (s) => setState(() => _iterations = s.first),
            ),
            const SizedBox(height: 12),
            _label('취소 시점 (턴 시작 후) — 900ms 프리버퍼를 넘겨야 실제 재생 중 취소입니다'),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1000, label: Text('1.0s')),
                ButtonSegment(value: 1500, label: Text('1.5s')),
                ButtonSegment(value: 2500, label: Text('2.5s')),
              ],
              selected: {_cancelDelayMs},
              onSelectionChanged: _running
                  ? null
                  : (s) => setState(() => _cancelDelayMs = s.first),
            ),
            const SizedBox(height: 12),
            _label('AEC(통화 용도 오디오) — 실제로 켜고 끕니다. 바꾸면 표본이 초기화됩니다'),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('변경 전')),
                ButtonSegment(value: true, label: Text('변경 후')),
              ],
              selected: {_voiceCallAudio},
              onSelectionChanged:
                  _running ? null : (s) => unawaited(_switchAec(s.first)),
            ),
            if (_diag.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '지금 상태 — 모드 ${_diag['mode']} · 스피커폰 ${_diag['speakerphone']} · '
                '출력 ${_diag['route'] == '' ? '(못 읽음)' : _diag['route']}\n'
                '볼륨 미디어 ${_diag['music_vol']}/${_diag['music_vol_max']} · '
                '통화 ${_diag['voice_vol']}/${_diag['voice_vol_max']}',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ],
            const SizedBox(height: 8),
            Text('예상 소요 약 $estSec초', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _running ? () => setState(() => _running = false) : _runAll,
                    child: Text(_running ? '중지 ($_done/$_iterations)' : '측정 시작'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _samples.isEmpty || _running ? null : _export,
                  child: const Text('내보내기'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_samples.isNotEmpty) ...[
              const SizedBox(height: 24),
              _summaryCard(summary),
              const SizedBox(height: 16),
              _label('최근 표본 (서버로 나가려던 페이로드 그대로)'),
              ..._samples.reversed.take(8).map(_sampleTile),
            ],
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 12)),
      );

  Widget _summaryCard(CancelRigSummary s) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.verdictLine,
                style: const TextStyle(fontWeight: FontWeight.bold, height: 1.4)),
            const SizedBox(height: 8),
            _row('표본', '${s.timed} / ${s.total}'),
            _row('client_stop_ms 중앙값', '${s.medianMs.toStringAsFixed(0)} ms'),
            _row('client_stop_ms p95', '${s.p95Ms.toStringAsFixed(0)} ms'),
            _row('client_stop_ms 최댓값', '${s.maxMs.toStringAsFixed(0)} ms'),
            _row('p95 가 안 보는 상위 표본', '${s.hiddenAboveP95} 건'),
            _row('stop_measure = hal_drained',
                '${(s.halDrainedRatio * 100).toStringAsFixed(0)} %'),
            _row('source = native',
                '${(s.nativeRatio * 100).toStringAsFixed(0)} %'),
            _row('락업(재생 안 살아남)', '${s.resumeFails} 건'),
            _row('잔여 미폐기', '${s.residualFails} 건'),
            _row('무회신', '${s.payloadMissing} 건'),
            _row(
              '출력 라우트',
              s.routeCounts.entries.map((e) => '${e.key} ${e.value}').join(' · ') +
                  (s.routeChanged ? ' ⚠바뀜' : ''),
            ),
          ],
        ),
      );

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(fontSize: 13)),
            Text(v,
                style: const TextStyle(
                    fontSize: 13, fontFeatures: [FontFeature.tabularFigures()])),
          ],
        ),
      );

  Widget _sampleTile(CancelSample s) {
    final bad = !s.ok;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '#${s.index}  '
        '${s.payloadMissing ? '무회신' : '${s.clientStopMs}ms'}  '
        '${s.stopMeasure}  ${s.source}  '
        'played=${s.payloadMissing ? '-' : s.playedServerBytes}B  '
        'route=${s.payload['audio_route'] == '' ? '(못읽음)' : s.payload['audio_route'] ?? '-'}\n'
        '     잔여 ${s.residualDiscardedBytes}/${s.residualInjectedBytes}B'
        '${s.residualOk ? '' : ' ❌미폐기'}  '
        '재개 ${s.resumeOk ? '${s.resumeDrainMs}ms' : '❌락업'}',
        style: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: bad ? Colors.red : null,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
