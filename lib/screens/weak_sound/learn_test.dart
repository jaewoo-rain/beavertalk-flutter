import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/atoms/button.dart';
import '../../components/atoms/mic_button.dart';
import '../../core/error/app_exception.dart';
import '../../features/review/data/audio_recorder.dart';
import '../../features/review/data/wav_writer.dart';
import '../../features/weak_sound/domain/entities/sound_lesson.dart';
import '../../features/weak_sound/presentation/sound_key_arg.dart';
import '../../features/weak_sound/presentation/weak_sound_providers.dart';
import '../../features/weak_sound/presentation/widgets/learn_scaffold.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learn_result.dart';

/// 4단계 · 평가 — Figma `14~16 · learn/4_test`, 예외는 E4·E6·E7.
///
/// **여기서만 점수가 움직인다.** 앞 세 단계는 무채점이다.
/// 채점은 서버가 한다 — 앱은 녹음을 올리고 결과를 받는다(클라가 점수를 계산해 보내면
/// 위조를 막을 수 없다).
///
/// 재도전은 몇 번이든 허용한다. 실패를 벌하는 화면이 아니라 연습을 마무리하는 화면이다.
class LearnTestScreen extends ConsumerStatefulWidget {
  const LearnTestScreen({super.key, this.soundKey});

  final String? soundKey;

  @override
  ConsumerState<LearnTestScreen> createState() => _LearnTestScreenState();
}

enum _Phase {
  /// 말하기 전(Figma 14).
  ready,

  /// 녹음 중(Figma 15).
  recording,

  /// 업로드·채점 대기(Figma 16).
  scoring,

  /// 실패 — 사유를 보이고 재시도를 준다(E4·E6·E7).
  failed,
}

class _LearnTestScreenState extends ConsumerState<LearnTestScreen> {
  final _recorder = ReviewAudioRecorder();
  _Phase _phase = _Phase.ready;
  String? _error;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggle(String soundKey) async {
    if (_phase == _Phase.scoring) return;
    if (_phase == _Phase.recording) {
      await _stopAndSubmit(soundKey);
      return;
    }
    setState(() {
      _phase = _Phase.recording;
      _error = null;
    });
    try {
      await _recorder.start();
    } on StateError catch (e) {
      // 마이크 권한 거부(Figma E6). 녹음기가 사용자 문구로 던진다.
      setState(() {
        _phase = _Phase.failed;
        _error = e.message;
      });
    } catch (_) {
      setState(() {
        _phase = _Phase.failed;
        _error = '마이크를 열지 못했어요.';
      });
    }
  }

  Future<void> _stopAndSubmit(String soundKey) async {
    setState(() => _phase = _Phase.scoring);
    final pcm = await _recorder.stop();
    if (pcm.isEmpty) {
      // Figma E4 — 인식 실패. 녹음이 비었으면 올려 봐야 0점이 나온다.
      setState(() {
        _phase = _Phase.failed;
        _error = '소리가 들어오지 않았어요. 다시 말해 볼까요?';
      });
      return;
    }
    try {
      final result = await ref
          .read(weakSoundRepositoryProvider)
          .assess(soundKey, pcm16ToWav(pcm));
      if (!mounted) return;
      // 목록의 점수가 바뀌었다 — 돌아갔을 때 옛 점수를 보이지 않게 버린다.
      ref.invalidate(weakSoundListProvider);
      ref.invalidate(soundLessonProvider(soundKey));
      unawaited(Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => LearnResultScreen(soundKey: soundKey, result: result),
        ),
      ));
    } on AppException catch (e) {
      // Figma E7 — 채점 오류(네트워크·서버).
      if (!mounted) return;
      setState(() {
        _phase = _Phase.failed;
        _error = e.message;
      });
    } catch (_) {
      // 예상 못 한 예외도 화면을 「채점 중」에 묶어 두면 안 된다 — 사용자는 영영 기다린다.
      if (!mounted) return;
      setState(() {
        _phase = _Phase.failed;
        _error = '채점에 실패했어요. 다시 시도해 주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = resolveSoundKey(context, widget.soundKey);
    if (key == null) return const MissingSoundKey();
    return LearnScaffold(
      soundKey: key,
      step: 4,
      // 채점 중에는 나가기 확인을 띄우지 않는다 — 어차피 버튼이 잠겨 있다.
      confirmExit: _phase != _Phase.scoring,
      builder: (context, lesson) => _Body(
        lesson: lesson,
        phase: _phase,
        error: _error,
        level: _recorder.amplitude,
        onMic: () => _toggle(key),
        onRetry: () => setState(() {
          _phase = _Phase.ready;
          _error = null;
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.lesson,
    required this.phase,
    required this.error,
    required this.level,
    required this.onMic,
    required this.onRetry,
  });

  final SoundLesson lesson;
  final _Phase phase;
  final String? error;
  final Stream<double> level;
  final VoidCallback onMic;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '아래 문장을 소리 내어 읽어 주세요',
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: c.labelNormal),
        ),
        const SizedBox(height: AppSpacing.s20),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s20),
          decoration: BoxDecoration(
            color: c.backgroundNormalNormal,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              Text(
                lesson.test.text,
                textAlign: TextAlign.center,
                style: AppType.heading2.b.copyWith(color: c.labelStrong),
              ),
              if (lesson.test.pronunciation != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '[${lesson.test.pronunciation}]',
                  textAlign: TextAlign.center,
                  style: AppType.body1.b.copyWith(color: c.primaryForeground),
                ),
              ],
              if (lesson.test.translationEn != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  lesson.test.translationEn!,
                  textAlign: TextAlign.center,
                  style: AppType.body2.r.copyWith(color: c.labelNormal),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        if (phase == _Phase.scoring)
          Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.s16),
              Text('채점하고 있어요',
                  style: AppType.body2.r.copyWith(color: c.labelNormal)),
            ],
          )
        else if (phase == _Phase.failed)
          Column(
            children: [
              Text(
                error ?? '문제가 생겼어요.',
                textAlign: TextAlign.center,
                style: AppType.body2.r.copyWith(color: c.statusNegative),
              ),
              const SizedBox(height: AppSpacing.s16),
              Button(
                type: BtnType.primaryFill,
                size: BtnSize.s48,
                text: '다시 시도',
                onPressed: onRetry,
              ),
            ],
          )
        else
          Column(
            children: [
              StreamBuilder<double>(
                stream: level,
                builder: (context, snap) => MicButton(
                  recording: phase == _Phase.recording,
                  level: snap.data,
                  onTap: onMic,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                phase == _Phase.recording ? '다 읽었으면 눌러 주세요' : '눌러서 시작해요',
                style: AppType.body2.r.copyWith(color: c.labelNormal),
              ),
            ],
          ),
      ],
    );
  }
}
