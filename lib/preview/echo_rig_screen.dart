import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../features/normalcall/data/datasources/audio_route_probe.dart';
import '../features/normalcall/domain/entities/echo_metrics.dart';
import '../features/normalcall/domain/entities/echo_report.dart';
import '../features/normalcall/domain/entities/echo_stimulus.dart';

/// 에코 측정 리그 (개발자 전용, `/dev/echo-rig`).
///
/// 서버의 에코 2차 방어 상수를 정하기 위한 실측 도구다. 현재 서버 기본값 0.05
/// (≈ −26 dBFS)는 실측 전 보수적 추정이라 이 리그의 결과로 교체된다.
///
/// ⚠ **통화 경로를 쓰지 않는다.** 자기 recorder/player 를 직접 열고 닫는다 —
/// 계측 도구가 통화 상태기계를 건드리면 둘 다 못 믿게 된다.
///
/// 화려할 이유가 없는 화면이다. 숫자가 정확히 읽히고, 단계를 틀린 순서로 밟을 수 없고,
/// 결과를 그대로 내보낼 수 있으면 된다.
class EchoRigScreen extends StatefulWidget {
  const EchoRigScreen({super.key});

  @override
  State<EchoRigScreen> createState() => _EchoRigScreenState();
}

/// 측정 단계. 순서가 곧 정확도라 화면이 순서를 강제한다.
enum _Step {
  idle('대기', '조건을 고르고 시작하세요'),
  noiseFloor('0. 환경소음', '재생 없음 · 말하지 마세요'),
  echo('1. 에코 ①③', '비버 소리 재생 중 · **말하지 마세요**'),
  speech('2. 발화 ②', '재생 없음 · 평소 크기로 말하세요'),
  tail('3. 꼬리 ④', '재생이 곧 멈춥니다 · 말하지 마세요'),
  done('완료', '결과를 확인하고 내보내세요');

  const _Step(this.title, this.hint);
  final String title;
  final String hint;
}

class _EchoRigScreenState extends State<EchoRigScreen> {
  // 통화 경로와 같은 규격 — 다른 규격으로 재면 그 숫자는 통화에 못 쓴다.
  static const int _micRate = 16000;
  static const int _playRate = 24000;

  /// 마이크 프레임 하나가 차지하는 시간. flutter_sound 의 청크 크기가 고정이 아니라,
  /// 실제로는 프레임마다 바이트 수로 계산한다(아래 [_frameMsOf]).
  static const int _chunkTargetMs = 20;

  /// 각 단계 길이. 백분위를 믿으려면 표본이 충분해야 한다.
  static const Duration _noiseFloorDur = Duration(seconds: 3);
  static const Duration _echoDur = Duration(seconds: 15);
  static const Duration _speechDur = Duration(seconds: 15);
  static const Duration _tailDur = Duration(seconds: 3);

  EchoRoute _route = EchoRoute.speakerphone;

  /// [AEC] 통화 용도 오디오로 잴지. **라우트와 함께 표본을 가르는 두 번째 축이다** —
  /// 같은 스피커폰이라도 AEC 전/후는 다른 표본이다. 섞으면 임계를 못 잡는다.
  bool _voiceCallAudio = false;

  /// 우리가 모드를 켰는가. 켠 쪽만 되돌린다 — 안 켠 모드를 NORMAL 로 돌리면
  /// 시스템 통화가 잡고 있던 모드를 밟는다.
  bool _voiceModeSet = false;

  /// 측정 시점의 오디오 상태 스냅샷. 리포트에 그대로 실린다.
  Map<String, dynamic> _diag = const {};

  _Step _step = _Step.idle;
  String? _error;

  FlutterSoundRecorder? _recorder;
  StreamController<Uint8List>? _micCtl;
  StreamSubscription<Uint8List>? _micSub;
  Timer? _pumpTimer;
  EchoStimulus? _stimulus;
  bool _playing = false;
  bool _pcmReady = false;

  /// 단계별 수집 버퍼. 프레임 RMS 를 시간순으로 담는다(③④가 순서를 쓴다).
  final List<double> _floorRms = [];
  final List<double> _echoRms = [];
  final List<double> _speechRms = [];
  final List<double> _tailRms = [];

  /// 현재 수집 대상.
  List<double>? _sink;

  /// 프레임 길이 실측 평균(ms) — ③④를 시간으로 환산할 때 쓴다.
  double _frameMs = _chunkTargetMs.toDouble();

  /// 조건별 결과 누적(스피커폰/이어폰 각각 한 번씩 재서 둘 다 리포트에 넣는다).
  final List<EchoRigResult> _results = [];

  double _liveRms = 0.0;

  /// 네이티브가 읽은 실제 출력 라우트. 사람이 고른 조건과 어긋나면 경고한다 —
  /// 이어폰을 꽂은 채 "스피커폰"으로 재면 그 측정은 통째로 못 쓴다.
  String _detectedRoute = '';

  @override
  void dispose() {
    _teardown();
    super.dispose();
  }

  // ── 측정 진행 ─────────────────────────────────────────────────────────────

  /// 사람이 고른 조건과 실제 라우트가 맞는가. 라우트를 못 읽으면(빈 문자열) 판정하지
  /// 않는다 — 모르는 걸 불일치로 몰면 정상 측정을 막는다.
  String? get _routeMismatch {
    if (_detectedRoute.isEmpty) return null;
    final isSpeaker = _detectedRoute == 'speaker';
    if (_route == EchoRoute.speakerphone && !isSpeaker) {
      return '실제 출력은 "$_detectedRoute" 입니다 — 스피커폰 측정이 아닙니다';
    }
    if (_route == EchoRoute.headset && isSpeaker) {
      return '실제 출력은 스피커입니다 — 이어폰이 연결돼 있지 않습니다';
    }
    return null;
  }

  Future<void> _start() async {
    setState(() => _error = null);
    final granted = await Permission.microphone.request();
    if (!granted.isGranted) {
      setState(() => _error = '마이크 권한이 필요합니다');
      return;
    }
    try {
      await _openMic();
      await _openPlayer();
    } catch (e) {
      setState(() => _error = '오디오 초기화 실패: $e');
      await _teardown();
      return;
    }

    // 재생을 연 뒤에 읽어야 실제 통화와 같은 라우트가 잡힌다.
    _detectedRoute = await AudioRouteProbe.currentRoute();
    if (mounted) setState(() {});

    _floorRms.clear();
    _echoRms.clear();
    _speechRms.clear();
    _tailRms.clear();

    await _runStep(_Step.noiseFloor, _floorRms, _noiseFloorDur, play: false);
    await _runStep(_Step.echo, _echoRms, _echoDur, play: true);
    // 꼬리는 재생을 **멈추는 순간**부터 잰다. 그 시각을 우리가 알기 때문에 ④는
    // 시작점만큼은 정확하다 — 불확실한 건 "언제 내려갔나"뿐이다.
    _stopPlayback();
    await _runStep(_Step.tail, _tailRms, _tailDur, play: false);
    await _runStep(_Step.speech, _speechRms, _speechDur, play: false);

    await _teardown();
    _finish();
  }

  Future<void> _runStep(
    _Step step,
    List<double> sink,
    Duration dur, {
    required bool play,
  }) async {
    if (!mounted) return;
    setState(() {
      _step = step;
      _sink = sink;
    });
    if (play) _startPlayback();
    await Future<void>.delayed(dur);
    _sink = null;
  }

  void _finish() {
    // ③④ 판정 임계: 그 자리에서 잰 환경소음 기준. 상수로 박으면 조용한 방과
    // 시끄러운 카페에서 다른 답이 나온다.
    final floor = RmsStats.from(_floorRms);
    final threshold = _burstThreshold(floor.median);

    final bursts = burstDurationsMs(
      frameRms: _echoRms,
      threshold: threshold,
      frameMs: _frameMs,
    );
    final tail = tailMs(
      frameRms: _tailRms,
      threshold: threshold,
      frameMs: _frameMs,
    );
    // 관측 구간 끝까지 안 내려갔으면 그 값은 하한이 아니라 잘린 값이다.
    final settled = tail < (_tailRms.length * _frameMs).round();

    setState(() {
      _results
        // ⚠ (라우트, AEC) **두 축**으로 지운다. 라우트만 보고 지우면 AEC 후 스피커를
        //   재는 순간 AEC 전 스피커 결과가 사라진다 — 비교할 짝을 잃는다.
        ..removeWhere(
            (r) => r.route == _route && r.voiceCallAudio == _voiceCallAudio)
        ..add(EchoRigResult(
          route: _route,
          voiceCallAudio: _voiceCallAudio,
          audioDiag: _diag,
          noiseFloor: floor,
          echo: RmsStats.from(_echoRms),
          speech: RmsStats.from(_speechRms),
          burst: DurationStats.from(bursts),
          tail: DurationStats.from([tail]),
          tailSettled: settled,
          stimulusNote: EchoStimulus.note,
          // 조작자가 고른 조건이 아니라 **프로브가 답한 값**이다. 통화 세션의
          // `start.aec` 와 같은 소스여야 실측 임계가 실제 세션에 그대로 적용된다.
          detectedRoute: _detectedRoute,
        ));
      _step = _Step.done;
    });
  }

  /// 환경소음보다 확실히 위여야 에코로 친다. 배수만 쓰면 무향실처럼 조용한 방에서
  /// 임계가 0 에 붙고, 절대값만 쓰면 시끄러운 방에서 상시 참이 된다 — 둘 다 건다.
  double _burstThreshold(double floorMedian) {
    final byRatio = floorMedian * 3;
    final byOffset = floorMedian + dbfsToRms(-60);
    return byRatio > byOffset ? byRatio : byOffset;
  }

  // ── 오디오 ────────────────────────────────────────────────────────────────

  Future<void> _openMic() async {
    final ctl = StreamController<Uint8List>();
    _micCtl = ctl;
    _micSub = ctl.stream.listen(_onMicFrame);
    final rec = FlutterSoundRecorder();
    _recorder = rec;
    await rec.openRecorder();
    await rec.startRecorder(
      toStream: ctl.sink,
      codec: Codec.pcm16,
      sampleRate: _micRate,
      numChannels: 1,
      // 통화와 같은 설정으로 열어야 같은 AEC 경로를 잰다.
      enableVoiceProcessing: true,
      enableEchoCancellation: true,
    );
  }

  Future<void> _openPlayer() async {
    // [AEC] 통화 용도 오디오로 열지. **켜야 플랫폼 AEC 가 참조할 다운링크가 생긴다** —
    // 끈 상태로 잰 잔여 에코로 서버 임계를 잡으면 임계가 너무 헐거워진다.
    //
    // ⚠ setup() **전에** 모드를 세운다. AudioTrack 은 만들어지는 시점의 모드로
    //   라우팅이 굳으므로 뒤에 바꾸면 이번 트랙에는 안 먹는다.
    //
    // ⛔ 통화 컨트롤러를 거치지 않는다 — 이 리그가 자기 recorder/player 를 직접 여는
    //   건 의도한 격리다. 계측 도구가 통화 상태기계를 건드리면 둘 다 못 믿게 된다.
    //   AEC 를 붙이면서도 그 경계를 그대로 둔다.
    if (_voiceCallAudio) {
      _diag = await AudioRouteProbe.setVoiceCallMode(true);
      _voiceModeSet = true;
    }
    await FlutterPcmSound.setup(
      sampleRate: _playRate,
      channelCount: 1,
      iosAudioCategory: IosAudioCategory.playAndRecord,
      androidVoiceCallAudio: _voiceCallAudio,
    );
    _pcmReady = true;
    _stimulus = EchoStimulus(sampleRate: _playRate);
    // 개통 후에 읽어야 실제 적용된 상태가 잡힌다.
    _diag = await AudioRouteProbe.audioDiag();
  }

  void _startPlayback() {
    if (!_pcmReady) return;
    _playing = true;
    // 10ms 주기로 밀어 넣어 엔진이 마르지 않게 한다(통화 경로의 푸시 모델과 같은 방식).
    _pumpTimer?.cancel();
    _pumpTimer = Timer.periodic(const Duration(milliseconds: 10), (_) async {
      if (!_playing) return;
      final s = _stimulus;
      if (s == null) return;
      final chunk = s.nextChunk(_playRate ~/ 50); // 20ms
      try {
        await FlutterPcmSound.feed(
          PcmArrayInt16(bytes: ByteData.sublistView(chunk)),
        );
      } catch (_) {
        // 엔진이 내려가는 중 — 계측이 재생을 죽이면 안 된다.
      }
    });
  }

  void _stopPlayback() {
    _playing = false;
    _pumpTimer?.cancel();
    _pumpTimer = null;
    // 큐에 남은 자극음까지 즉시 버려야 "정지 시각"이 실제 정지와 일치한다.
    // 이게 없으면 ④가 통째로 부풀어 무의미해진다.
    unawaited(FlutterPcmSound.clear());
  }

  void _onMicFrame(Uint8List bytes) {
    final rms = rmsOfPcm16(bytes);
    // 프레임 길이 실측: PCM16 모노라 바이트 → 샘플 → ms.
    final ms = (bytes.lengthInBytes / 2) / _micRate * 1000.0;
    if (ms > 0) _frameMs = ms;
    _sink?.add(rms);
    if (mounted) setState(() => _liveRms = rms);
  }

  Future<void> _teardown() async {
    _stopPlayback();
    await _micSub?.cancel();
    _micSub = null;
    try {
      await _recorder?.stopRecorder();
    } catch (_) {}
    try {
      await _recorder?.closeRecorder();
    } catch (_) {}
    _recorder = null;
    await _micCtl?.close();
    _micCtl = null;
    if (_pcmReady) {
      try {
        await FlutterPcmSound.release();
      } catch (_) {}
      _pcmReady = false;
    }
    // [AEC] 트랙을 내린 **뒤에** 모드를 되돌린다. 먼저 되돌리면 마지막 소리가
    // 리시버로 샌다. 우리가 켠 경우에만 — 안 켠 모드를 밟지 않는다.
    if (_voiceModeSet) {
      _voiceModeSet = false;
      await AudioRouteProbe.setVoiceCallMode(false);
    }
  }

  // ── 내보내기 ──────────────────────────────────────────────────────────────

  Future<void> _export() async {
    final text = buildEchoReport(
      results: _results,
      deviceLabel: '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      timestamp: DateTime.now().toIso8601String(),
    );
    // 로그로도 남긴다 — 파일 공유가 막힌 기기에서도 값을 건질 수 있게.
    debugPrint('=== ECHO RIG REPORT ===\n$text');
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/echo_report.md');
      await f.writeAsString(text);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(f.path)], text: 'BeaverTalk 에코 측정 리포트'),
      );
    } catch (e) {
      if (mounted) setState(() => _error = '내보내기 실패(로그에는 남았습니다): $e');
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final running = _step != _Step.idle && _step != _Step.done;
    return Scaffold(
      appBar: AppBar(title: const Text('에코 측정 리그')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '서버 에코 게이트 상수를 정하기 위한 실측 도구입니다.\n'
              '① 에코와 ② 발화는 같은 조건·같은 볼륨에서 연속으로 측정해야 비교가 성립합니다.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            SegmentedButton<EchoRoute>(
              segments: [
                for (final r in EchoRoute.values)
                  ButtonSegment(value: r, label: Text(r.label)),
              ],
              selected: {_route},
              onSelectionChanged:
                  running ? null : (s) => setState(() => _route = s.first),
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('AEC 끔')),
                ButtonSegment(value: true, label: Text('AEC 켬')),
              ],
              selected: {_voiceCallAudio},
              onSelectionChanged: running
                  ? null
                  : (s) => setState(() => _voiceCallAudio = s.first),
            ),
            const SizedBox(height: 8),
            const Text(
              '⚠ 볼륨은 실사용 크기로 맞추고, 측정 중에는 바꾸지 마세요.\n'
              '⚠ AEC 를 켜면 출력이 리시버로 빠질 수 있습니다 — 아래 "실제 출력"을 확인하세요.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            if (_detectedRoute.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('실제 출력: $_detectedRoute', style: const TextStyle(fontSize: 12)),
            ],
            if (_routeMismatch != null) ...[
              const SizedBox(height: 4),
              Text('⛔ ${_routeMismatch!}',
                  style: const TextStyle(color: Colors.red, height: 1.4)),
            ],
            const Divider(height: 32),
            Text(_step.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_step.hint, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 16),
            // 진행 중 현재 입력 레벨 — 마이크가 죽었는지 사람이 즉시 알 수 있게.
            LinearProgressIndicator(value: (_liveRms * 8).clamp(0.0, 1.0)),
            const SizedBox(height: 4),
            Text(
              'live rms ${_liveRms.toStringAsFixed(5)} (0~1)  ·  '
              '${rmsToDbfs(_liveRms).toStringAsFixed(1)} dBFS',
              style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: running ? null : _start,
              child: Text(running ? '측정 중…' : '${_route.label} 측정 시작'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const Divider(height: 32),
            ..._results.map(_resultCard),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _export,
                child: const Text('리포트 내보내기'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultCard(EchoRigResult r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.route.label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _line('환경소음 중앙값', r.noiseFloor.median),
            _line('① 에코 중앙값', r.echo.median),
            _line('① 에코 p95', r.echo.p95, bold: true),
            _line('② 발화 중앙값', r.speech.median),
            _line('② 발화 p5', r.speech.p5, bold: true),
            const SizedBox(height: 4),
            Text('③ 버스트 p95  ${r.burst.p95Ms} ms  (표본 ${r.burst.count}) ⚠미검증'),
            Text('④ 꼬리 p95  ${r.tail.p95Ms} ms'
                '${r.tailSettled ? '' : ' (관측구간에 잘림)'} ⚠미검증'),
            const SizedBox(height: 8),
            if (r.energyGateUnusable)
              const Text(
                '⛔ 에너지로는 못 가름 — 서버는 전사 확인으로 전환.\n'
                '측정 실패가 아니라 설계 분기 정보입니다.',
                style: TextStyle(color: Colors.red, height: 1.4),
              )
            else
              Text(
                '✅ 에너지로 가를 수 있음\n'
                'CASCADE_BARGEIN_RMS = ${r.suggestedBargeInRms.toStringAsFixed(5)} (0~1)\n'
                'CASCADE_BARGEIN_MIN_MS = ${r.suggestedMinMs}\n'
                'CASCADE_ECHO_TAIL_MS = ${r.tail.p95Ms}',
                style: const TextStyle(height: 1.4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, double rms, {bool bold = false}) {
    return Text(
      '$label  ${rms.toStringAsFixed(5)} (0~1)  ·  '
      '${rmsToDbfs(rms).toStringAsFixed(1)} dBFS',
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : null,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
