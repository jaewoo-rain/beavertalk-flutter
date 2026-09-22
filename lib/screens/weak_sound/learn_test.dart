import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/atoms/mic_analysis.dart';
import '../../components/atoms/mic_button.dart';
import '../../components/atoms/record_circle_button.dart';
import '../../components/organisms/bottom_sheet.dart' show SheetAction;
import '../../components/organisms/bottom_sheet_content.dart';
import '../../components/icons/app_icons.dart';
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
import '../../l10n/app_localizations.dart';

/// 4단계 · 평가 — Figma `14~16 · learn/4_test`, 예외는 E4·E7(화면 안) · E6(시트).
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

  /// 실패 — 사유를 보이고 재시도를 준다(E4·E7). E6 은 시트라 여기 오지 않는다.
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
    final l10n = AppLocalizations.of(context);
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
    } on StateError {
      // 마이크 권한 거부(Figma E6 `6093:14239`) — 화면 안 오류 줄이 아니라 **시트**다.
      // 권한은 이 화면에서 못 고치고 설정으로 가야 하므로, 할 일(설정 열기)을 버튼으로 준다.
      // 녹음기의 `StateError` 는 권한 거부 하나뿐이다(`audio_recorder.dart:60`) — 다른
      //   StateError 가 생기면 여기서 권한 시트가 잘못 뜬다. 녹음기를 고치면 이 자리도 본다.
      // ⛔ 녹음기의 `StateError.message` 를 그대로 띄우지 마라 — 한국어로 박힌 문구라
      //   전 언어에서 한국어가 나온다. 문구는 l10n 에서 가져온다.
      setState(() {
        _phase = _Phase.ready;
        _error = null;
      });
      if (mounted) unawaited(_showMicPermissionSheet());
    } catch (_) {
      setState(() {
        _phase = _Phase.failed;
        _error = l10n.wsMicFailed;
      });
    }
  }

  Future<void> _stopAndSubmit(String soundKey) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _phase = _Phase.scoring);
    final pcm = await _recorder.stop();
    if (pcm.isEmpty) {
      // Figma E4 — 인식 실패. 녹음이 비었으면 올려 봐야 0점이 나온다.
      setState(() {
        _phase = _Phase.failed;
        _error = l10n.wsNoSound;
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
        _error = l10n.wsScoreFailed;
      });
    }
  }

  /// E6 — 마이크 권한 없음 시트. 「설정 열기」는 OS 앱 설정으로 보낸다.
  Future<void> _showMicPermissionSheet() {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
      isScrollControlled: true,
      builder: (sheetCtx) => BottomSheetContent(
        title: l10n.micPermissionNeededTitle,
        body: l10n.wsMicPermissionBody,
        primaryAction: SheetAction(
          label: l10n.openSettings,
          onPressed: () {
            Navigator.pop(sheetCtx);
            unawaited(openAppSettings());
          },
        ),
        secondaryAction: SheetAction(
          label: l10n.ctaNotNow,
          onPressed: () => Navigator.pop(sheetCtx),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = resolveSoundKey(context, widget.soundKey);
    if (key == null) return const MissingSoundKey();
    return LearnScaffold(
      soundKey: key,
      step: 4,
      // 마이크를 화면 아래에 붙이기 위해 스크롤을 쓰지 않는다(learn_scaffold 참조).
      scrollable: false,
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
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.wsReadAloud,
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
        // 마이크는 **화면 아래**다. 가운데 있으면 아래 절반이 비고, 한 손으로 쥐었을 때
        // 엄지가 닿지 않는다(실기기 확인 2026-09-21).
        const Spacer(),
        // 마이크 3상태는 **기존 발음 학습(`learning_intro.dart`)과 같은 부품**을 쓴다.
        // 녹음=MicButton · 채점=MicAnalysis · 실패=RecordCircleButton(redo).
        // 세 상태가 같은 96 앵커를 차지해 전환할 때 레이아웃이 튀지 않는다.
        if (phase == _Phase.scoring)
          Column(
            children: [
              Text(l10n.wsScoring,
                  style: AppType.body2.r.copyWith(color: c.labelNormal)),
              const SizedBox(height: AppSpacing.s16),
              const MicAnalysis(),
            ],
          )
        else if (phase == _Phase.failed)
          Column(
            children: [
              Text(
                error ?? l10n.wsSomethingWrong,
                textAlign: TextAlign.center,
                style: AppType.body2.r.copyWith(color: c.statusNegative),
              ),
              const SizedBox(height: AppSpacing.s16),
              RecordCircleButton(
                icon: AppIcons.redo,
                semanticLabel: l10n.wsRetry,
                onTap: onRetry,
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
                  level: phase == _Phase.recording ? snap.data : null,
                  onTap: onMic,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                phase == _Phase.recording ? l10n.wsTapWhenDone : l10n.wsTapToStart,
                style: AppType.body2.r.copyWith(color: c.labelNormal),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.s24),
      ],
    );
  }
}
