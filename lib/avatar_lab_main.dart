// Avatar LAB — 백엔드 없이 영상통화 아바타를 실기기에서 판정한다.
//
// 왜 있나: 실통화는 서버 Vertex 자격증명(1008)이 막혀 있어 붙지 않는다. 그런데
// 판정해야 할 것은 렌더러와 표정 로직이지 서버가 아니다. 이 랩은 합성 음성 엔벨로프
// 와 실제 바바 대사를 흘려 **실앱과 같은 코드**(SyncAvatar · SentenceEmotion)를
// 그대로 돌린다.
//
// 무엇을 보나 (2026-08-04 미결):
//   ① 표정이 문장 내용을 따라가는가
//   ② 문장이 바뀔 때 표정이 깜빡이지 않는가  ← v6.5 의 유일한 위험
//
// 계측(`test/avatar_emotion_test.dart`)에 따르면 깜빡임은 **자막 델타가 오디오보다
// 얼마나 앞서 오느냐**에 전적으로 달렸다. 나란히 오면(120ms/델타) 표정이 360~720ms
// 머물러 안전하고, 생성이 앞지르면(20ms/델타) 60~120ms 로 스쳐 지나가 8턴 중 4턴이
// 깜빡인다. 실서버가 어느 쪽인지는 통화가 붙어야 알 수 있으므로, 여기서 **양쪽을
// 다 재현**해 두고 최소 유지 시간이 실제로 필요한지 눈으로 판정한다.
//
//   flutter build apk --debug --target lib/avatar_lab_main.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'features/normalcall/presentation/avatar_emotion.dart';
import 'features/normalcall/presentation/avatar_tempo.dart';
import 'features/normalcall/presentation/sync_avatar.dart';

const _dir = 'assets/avatar/baba';

/// 실측 음성 엔벨로프 한 턴치(25ms 간격). 실통화에서 뽑아 둔 파형이다.
const _env = <double>[
  0.0, 0.0, 0.0, 0.0, 0.0, 0.149, 0.573, 0.843, 0.989, 0.974, 0.785, 0.827,
  1.0, 1.0, 1.0, 0.916, 0.934, 0.752, 0.453, 0.328, 0.836, 0.904, 0.981, 0.83,
  0.851, 0.876, 0.794, 0.615, 0.328, 0.265, 0.125, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.212, 0.389, 0.93, 1.0, 0.999, 0.814, 0.853, 0.778, 0.865, 0.912,
  0.781, 0.747, 0.3, 0.34, 0.511, 0.345, 0.826, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
  0.914, 0.632, 0.389, 0.7, 1.0, 0.807, 0.767, 0.6, 0.659, 0.293, 0.239,
  0.568, 0.827, 0.913, 1.0, 0.885, 0.738, 0.569, 0.411, 0.398, 0.35, 0.155,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
];

/// 실제 바바 대사에 가까운 턴 표본(츤데레·반말). 감정이 갈리는 문장을 섞었다.
const _turns = <String>[
  '오, 이번엔 좋아! 진짜 잘했어. 계속 그렇게 해.',
  '음... 그건 좀 아쉽다. 조사를 빼먹었어. 다시 설명할게.',
  '헐 대박. 그걸 한 번에 맞췄다고? 나 놀랐어.',
  '아니 그게 아니라. 받침을 제대로 발음해야지. 답답하네 진짜.',
  '뭐야, 또 틀렸잖아. 그래도 발음은 나쁘지 않네. 다시 해봐.',
  '하하 웃기네. 근데 문법은 틀렸어. 정말?이라고 물어봐야지.',
];

const _emoName = ['중립(smug)', '기쁨', '놀람', '슬픔', '화남'];
const _tempoName = ['slow', 'normal', 'fast'];

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _Lab(),
      );
}

class _Lab extends StatefulWidget {
  const _Lab();
  @override
  State<_Lab> createState() => _LabState();
}

class _LabState extends State<_Lab> {
  final level = ValueNotifier<double>(0);
  final speaking = ValueNotifier<bool>(false);
  final emotion = ValueNotifier<int>(0);

  /// 최소 유지 시간을 켤지. 끄면 v6.5, 켜면 현재 실앱(v6.6)과 같다.
  bool _hold = true;

  /// 자막 델타가 오디오보다 앞서 도착하는 상황을 재현할지.
  bool _leadAudio = false;

  SentenceEmotion _emo = SentenceEmotion(minHold: Duration.zero);
  Timer? _tick;
  int _turn = 0, _i = 0, _deltaAt = 0;
  String _subtitle = '';
  List<String> _deltas = const [];

  /// 관찰값 — 표정이 화면에 머문 시간. 이게 짧을수록 깜빡인다.
  DateTime? _changedAt;
  int _lastDwellMs = -1;
  int _flickers = 0;

  /// 발화 속도 배수. 실측 엔벨로프를 빠르게·느리게 흘려 세 템포를 전부 태운다.
  /// 1.0 = 실통화에서 뽑은 원본 속도.
  double _speed = 1.0;
  double _pos = 0;

  /// 랩이 **같은 코드로 직접** 재는 음절률. SyncAvatar 안의 판정과 일치해야 한다
  /// (표정 분류기를 랩에서 직접 돌리는 것과 같은 이유).
  final TempoMeter _tempoMeter = TempoMeter();
  double? _measuredRate;
  int _tempoGuess = kTalkNormal;

  /// 수동 클립 선택. null 이면 미터가 고른다(autoTempo).
  /// ★자동 판정이 아직 단조가 아니라(0.6x 가 1.0x 보다 빠르게 측정됨) **클립 자체를
  ///  비교하려면 수동이 필요하다**. 판정과 감상을 섞지 않는다.
  int? _manualTempo;
  final ValueNotifier<int> _tempoOverride = ValueNotifier<int>(kTalkNormal);

  static const _stepMs = 25; // 엔벨로프 한 칸

  @override
  void initState() {
    super.initState();
    _startTurn();
    _tick = Timer.periodic(const Duration(milliseconds: _stepMs), (_) => _step());
  }

  void _rebuildClassifier() {
    _emo = SentenceEmotion(
      minHold: _hold ? SentenceEmotion.kDefaultMinHold : Duration.zero,
    );
    _flickers = 0;
    _lastDwellMs = -1;
    _startTurn();
  }

  void _startTurn() {
    _emo.reset();
    emotion.value = 0;
    _changedAt = null;
    _subtitle = '';
    _i = 0;
    _pos = 0;
    _deltaAt = 0;
    final line = _turns[_turn % _turns.length];
    _deltas = [
      for (var i = 0; i < line.length; i += 3)
        line.substring(i, (i + 3).clamp(0, line.length)),
    ];
  }

  void _step() {
    // 1) 음성 엔벨로프 — 실앱의 avatarLevel/avatarSpeaking 과 같은 신호.
    //    _speed 로 흘리는 속도를 바꾼다(빠른 말·느린 말 재현).
    _pos += _speed;
    _i = _pos.floor();
    if (_i < _env.length) {
      level.value = _env[_i];
      speaking.value = true;
    } else {
      level.value = 0;
      speaking.value = false;
    }
    // 랩도 같은 미터를 돌려 화면에 보인다. 위젯 내부 판정과 어긋나면 둘 중 하나가 틀린 것.
    _tempoMeter.feed(level.value, DateTime.now());
    final r = _tempoMeter.rate;
    if (r != null) {
      _measuredRate = r;
      _tempoGuess = TempoMeter.tempoFor(r);
    }

    // 2) 자막 델타 — 실앱의 output_transcript. 앞서 오는 경우를 토글로 재현한다.
    //    실시간이면 대략 120ms 에 3글자, 생성선행이면 25ms 마다 쏟아진다.
    final everyNSteps = _leadAudio ? 1 : 5;
    if (_i % everyNSteps == 0 && _deltaAt < _deltas.length) {
      final d = _deltas[_deltaAt++];
      _subtitle += d;
      final next = _emo.feed(d);
      if (next != null) _applyEmotion(next);
    }
    final released = _emo.tick();
    if (released != null) _applyEmotion(released);

    // 3) 입모양 — 자막이 아무리 앞서 와도 전진은 **엔벨로프 온셋**에만 걸린다.
    //    표정과 같은 문제(도착 시점 vs 재생 시점)를 구조적으로 피한다.

    if (_i > _env.length + 40) {
      _turn++;
      _startTurn();
    }
    if (mounted) setState(() {});
  }

  void _applyEmotion(int code) {
    final now = DateTime.now();
    final since = _changedAt;
    if (since != null) {
      _lastDwellMs = now.difference(since).inMilliseconds;
      if (_lastDwellMs < 250) _flickers++; // 눈에 깜빡임으로 보이는 구간
    }
    _changedAt = now;
    emotion.value = code;
  }

  @override
  void dispose() {
    _tick?.cancel();
    level.dispose();
    speaking.dispose();
    emotion.dispose();
    _tempoOverride.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SyncAvatar(
                // 수동이 걸리면 그 클립을 고정한다. 아니면 미터가 고른다.
                autoTempo: _manualTempo == null,
                tempo: _manualTempo == null ? null : _tempoOverride,
                assetDir: _dir,
                level: level,
                speaking: speaking,
                emotion: emotion,
                fallback: const ColoredBox(color: Color(0xFF2A2233)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF14101A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _subtitle.isEmpty ? '…' : _subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '표정 ${_emoName[emotion.value]}   ·   '
                    '직전 유지 ${_lastDwellMs < 0 ? '—' : '$_lastDwellMs ms'}   ·   '
                    '깜빡임(<250ms) $_flickers회',
                    style: TextStyle(
                      color: _lastDwellMs >= 0 && _lastDwellMs < 250
                          ? const Color(0xFFFF6B6B)
                          : const Color(0xFF9BE7A0),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '음절 ${_measuredRate == null ? '—' : _measuredRate!.toStringAsFixed(2)}/s'
                    '   ·   템포 ${_tempoName[_tempoGuess]}'
                    '   ·   재생속도 ${_speed.toStringAsFixed(1)}x',
                    style: const TextStyle(
                        color: Color(0xFF7FD4FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Text('클립 ',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                      for (var t = 0; t < 3; t++)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(_tempoName[t],
                                style: const TextStyle(fontSize: 12)),
                            selected: _manualTempo == t,
                            onSelected: (on) => setState(() {
                              _manualTempo = on ? t : null;
                              if (on) _tempoOverride.value = t;
                            }),
                          ),
                        ),
                      const Text('  (해제=자동)',
                          style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('말속도 ',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                      for (final s in const [0.6, 1.0, 1.5])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text('${s}x',
                                style: const TextStyle(fontSize: 12)),
                            selected: (_speed - s).abs() < 0.01,
                            onSelected: (_) => setState(() => _speed = s),
                          ),
                        ),
                    ],
                  ),
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('자막이 오디오보다 앞서 도착',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    subtitle: const Text('켜면 생성이 재생을 앞지르는 상황을 재현한다',
                        style: TextStyle(color: Colors.white38, fontSize: 11)),
                    value: _leadAudio,
                    onChanged: (v) => setState(() {
                      _leadAudio = v;
                      _rebuildClassifier();
                    }),
                  ),
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('표정 최소 유지 400ms',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    subtitle: const Text('켠 쪽이 현재 실앱(v6.6). 끄면 v6.5',
                        style: TextStyle(color: Colors.white38, fontSize: 11)),
                    value: _hold,
                    onChanged: (v) => setState(() {
                      _hold = v;
                      _rebuildClassifier();
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
