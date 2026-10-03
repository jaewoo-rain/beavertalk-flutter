// 통화 음량 실측 진입점(개발 전용 · 제품 빌드에 안 들어간다).
//
//   flutter run -t lib/main_loudness_probe.dart
//
// 같은 자극음을 [미디어 / 통화 용도 / 통화 용도+게인] 으로 차례로 재생하고, 그동안 기기
// 마이크(UNPROCESSED — 에코 제거·잡음 제거·자동 게인 없음)로 받은 소리의 RMS 를 잰다.
// 같은 기기 · 같은 위치의 상대 비교라, 조건 사이의 dB 차이가 「사람이 듣는 크기 차이」의
// 대용치다. 결과는 logcat 의 `[loudness]` 줄과 화면에 남는다.
//
// ⚠ 통화 용도 모드에서는 녹음 소스를 voice_communication 으로 열면 에코 제거가 스피커
//   소리를 지워 버린다 — 음량을 재는 데는 **처리 없는 소스**여야 한다(그래서 에코 측정
//   리그를 못 쓴다: 그 리그는 일부러 통화와 같은 에코 제거 경로로 연다).
// ⚠ 자극음은 실제 비버 음성이 아니다(대역제한 잡음 + 음절 변조 · EchoStimulus).
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart' as rec;

import 'features/normalcall/data/datasources/audio_route_probe.dart';
import 'features/normalcall/domain/entities/echo_stimulus.dart';
import 'features/normalcall/domain/pcm_gain.dart';

const int _playRate = 24000;
const int _micRate = 16000;
const Duration _floorDur = Duration(seconds: 2);
const Duration _playDur = Duration(seconds: 6);

/// 재생 시작 뒤 이만큼은 버린다 — 트랙이 올라오고 스피커가 안정되는 구간.
const Duration _settle = Duration(milliseconds: 800);

class _Cond {
  const _Cond(this.label, {required this.voice, this.gainDb = 0});
  final String label;
  final bool voice;
  final double gainDb;
}

// 2차(10-03): 1차에서 통화 용도에 +6/+9dB 를 줘도 마이크에서 +0.5/+0.8dB 만 올랐다(디지털
// 로는 +6.0/+9.0). 기기 통화 경로가 레벨을 되돌리는지 가르려고 −6dB 와 미디어 +6dB 를 더 잰다.
const _conds = [
  _Cond('A-2 미디어 용도', voice: false),
  _Cond('미디어 용도 +6dB', voice: false, gainDb: 6),
  _Cond('A-1 통화 용도(현행)', voice: true),
  _Cond('통화 용도 -6dB', voice: true, gainDb: -6),
  _Cond('통화 용도 +6dB', voice: true, gainDb: 6),
  _Cond('통화 용도 +9dB', voice: true, gainDb: 9),
];
const int _rounds = 2;

// ProviderScope: 앱 진입점 규칙(missing_provider_scope)을 지킨다 — 이 화면은 프로바이더를 안 쓴다.
void main() => runApp(const ProviderScope(child: MaterialApp(home: _ProbeScreen())));

class _ProbeScreen extends StatefulWidget {
  const _ProbeScreen();
  @override
  State<_ProbeScreen> createState() => _ProbeScreenState();
}

class _ProbeScreenState extends State<_ProbeScreen> {
  final List<String> _lines = [];

  void _say(String s) {
    debugPrint('[loudness] $s');
    if (mounted) setState(() => _lines.add(s));
  }

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    if (!(await Permission.microphone.request()).isGranted) {
      _say('마이크 권한 없음 — 중단');
      return;
    }
    final results = <String, List<double>>{};
    for (var r = 1; r <= _rounds; r++) {
      for (final c in _conds) {
        final db = await _measure(c, r);
        if (db != null) (results[c.label] ??= []).add(db);
      }
    }
    _say('=== 요약(재생 dBFS 중앙값 · $_rounds회 평균 · A-1 대비) ===');
    final base = _avg(results['A-1 통화 용도(현행)']);
    for (final c in _conds) {
      final v = _avg(results[c.label]);
      if (v == null) continue;
      final d = base == null ? '' : ' (A-1 대비 ${(v - base) >= 0 ? '+' : ''}${(v - base).toStringAsFixed(1)} dB)';
      _say('${c.label}: ${v.toStringAsFixed(1)} dBFS$d');
    }
    _say('DONE');
  }

  double? _avg(List<double>? xs) =>
      xs == null || xs.isEmpty ? null : xs.reduce((a, b) => a + b) / xs.length;

  /// 한 조건: 모드 세우기 → 재생기 열기 → 마이크 열기 → 바닥 소음 → 재생 → 정리.
  Future<double?> _measure(_Cond c, int round) async {
    Map<String, dynamic> diag = const {};
    final recorder = rec.AudioRecorder();
    StreamSubscription<Uint8List>? sub;
    final frames = <double>[];
    var collecting = false;
    Timer? pump;
    try {
      if (c.voice) diag = await AudioRouteProbe.setVoiceCallMode(true);
      await FlutterPcmSound.setup(
        sampleRate: _playRate,
        channelCount: 1,
        iosAudioCategory: IosAudioCategory.playAndRecord,
        androidVoiceCallAudio: c.voice,
      );
      if (!c.voice) diag = await AudioRouteProbe.audioDiag();
      // iOS: 통화와 같은 범주(playAndRecord + 스피커 기본 + BT)로 맞추고 모드만 가른다 —
      // 통화 용도 = voiceChat(현행 통화), 미디어 용도 = default. 재생기 setup 이 범주를
      // 옵션 없이 다시 써서 defaultToSpeaker 가 지워지므로(리시버로 빠짐) **setup 뒤에** 세운다.
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final session = await AudioSession.instance;
        await session.configure(AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.defaultToSpeaker |
                  AVAudioSessionCategoryOptions.allowBluetooth,
          avAudioSessionMode:
              c.voice ? AVAudioSessionMode.voiceChat : AVAudioSessionMode.defaultMode,
        ));
        await session.setActive(true);
        diag = {'mode': c.voice ? 'voiceChat' : 'default', 'route': 'ios'};
      }

      // iOS: 위에서 세운 세션을 녹음기가 덮어쓰지 않게 한다(Android 에선 쓰이지 않는다).
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await recorder.ios?.manageAudioSession(false);
      }
      final stream = await recorder.startStream(const rec.RecordConfig(
        encoder: rec.AudioEncoder.pcm16bits,
        sampleRate: _micRate,
        numChannels: 1,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
        androidConfig: rec.AndroidRecordConfig(
          audioSource: rec.AndroidAudioSource.unprocessed,
          audioManagerMode: rec.AudioManagerMode.modeNormal,
          speakerphone: false,
          manageBluetooth: false,
        ),
        audioInterruption: rec.AudioInterruptionMode.none,
      ));
      sub = stream.listen((b) {
        if (collecting) frames.add(_rms(b));
      });

      // 바닥 소음.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      collecting = true;
      await Future<void>.delayed(_floorDur);
      collecting = false;
      final floor = _medianDb(frames);
      frames.clear();

      // 재생.
      final stim = EchoStimulus(sampleRate: _playRate);
      final gain = dbToGain(c.gainDb);
      pump = Timer.periodic(const Duration(milliseconds: 10), (_) {
        final chunk = applyPcmGain(stim.nextChunk(_playRate ~/ 50), gain);
        unawaited(FlutterPcmSound.feed(
          PcmArrayInt16(bytes: ByteData.sublistView(chunk)),
        ).catchError((Object _) => null));
      });
      await Future<void>.delayed(_settle);
      collecting = true;
      await Future<void>.delayed(_playDur - _settle);
      collecting = false;
      final play = _medianDb(frames);

      _say('[$round] ${c.label}: 재생 ${play.toStringAsFixed(1)} dBFS · '
          '바닥 ${floor.toStringAsFixed(1)} dBFS · mode=${diag['mode']} '
          'speakerphone=${diag['speakerphone']} route=${diag['route']} '
          'music=${diag['music_vol']}/${diag['music_vol_max']} '
          'voice=${diag['voice_vol']}/${diag['voice_vol_max']}');
      return play;
    } catch (e) {
      _say('[$round] ${c.label}: 실패 $e');
      return null;
    } finally {
      pump?.cancel();
      await sub?.cancel();
      try {
        await recorder.stop();
      } catch (_) {}
      await recorder.dispose();
      await FlutterPcmSound.release();
      if (c.voice) await AudioRouteProbe.setVoiceCallMode(false);
      // 다음 조건이 이전 트랙 잔향을 안 듣게 쉰다.
      await Future<void>.delayed(const Duration(milliseconds: 700));
    }
  }

  /// ⚠ 플러그인이 주는 버퍼는 짝수 오프셋이 보장되지 않는다 — `Int16List.sublistView` 는
  ///   거기서 RangeError 를 낸다(첫 실행 실측). 바이트로 읽는다.
  static double _rms(Uint8List b) {
    final n = b.lengthInBytes ~/ 2;
    if (n == 0) return 0;
    final bd = ByteData.sublistView(b);
    var acc = 0.0;
    for (var i = 0; i < n; i++) {
      final x = bd.getInt16(i * 2, Endian.little) / 32768.0;
      acc += x * x;
    }
    return math.sqrt(acc / n);
  }

  static double _medianDb(List<double> rms) {
    if (rms.isEmpty) return double.negativeInfinity;
    final dbs = rms.map((r) => r <= 0 ? -120.0 : 20 * math.log(r) / math.ln10).toList()..sort();
    return dbs[dbs.length ~/ 2];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('loudness probe')),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [for (final l in _lines) Text(l)],
        ),
      );
}
