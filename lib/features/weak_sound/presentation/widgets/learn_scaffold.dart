import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/molecules/empty_state.dart';
import '../../../../components/organisms/dialog_basic.dart';
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/sound_lesson.dart';
import '../weak_sound_providers.dart';
import 'learn_header.dart';

/// 학습 4단계가 공유하는 껍데기 — 고정 헤더 + 스크롤 본문 + 고정 푸터.
///
/// 네 화면이 같은 과(`soundLessonProvider`)를 본다. 단계마다 다시 받지 않는 이유는
/// 단어→단어 자동진행에 네트워크가 끼면 흐름이 끊기기 때문이다(서버도 4단계를 한 번에
/// 내려준다).
///
/// 나가기(닫기·시스템 뒤로)는 **확인을 받는다**(Figma E3). 연습 중에 실수로 닫으면
/// 처음부터 다시 해야 하는데, 그건 사용자가 의도한 적 없는 손실이다.
class LearnScaffold extends ConsumerWidget {
  const LearnScaffold({
    super.key,
    required this.soundKey,
    required this.step,
    required this.builder,
    this.footer,
    this.confirmExit = true,
  });

  final String soundKey;

  /// 1~4.
  final int step;

  /// 과가 도착한 뒤의 본문.
  final Widget Function(BuildContext context, SoundLesson lesson) builder;

  /// 아래 고정 버튼. null 이면 푸터를 두지 않는다(자동진행 화면).
  final Widget Function(BuildContext context, SoundLesson lesson)? footer;

  /// 나가기 확인 다이얼로그를 띄울지. 결과 화면처럼 잃을 것이 없으면 false.
  final bool confirmExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    final async = ref.watch(soundLessonProvider(soundKey));
    return PopScope(
      canPop: !confirmExit,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmLeave(context)) {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: c.backgroundSurfaceAlternative,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              LearnHeader(
                title: async.valueOrNull?.label ?? '',
                step: step,
                onClose: () async {
                  if (!confirmExit || await _confirmLeave(context)) {
                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
              ),
              Expanded(
                child: async.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      child: EmptyBlock(
                        title: '학습을 불러오지 못했어요',
                        body: '잠시 후 다시 시도해 주세요.',
                        ctaText: '다시 시도',
                        onCta: () =>
                            ref.invalidate(soundLessonProvider(soundKey)),
                      ),
                    ),
                  ),
                  data: (lesson) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20,
                      AppSpacing.s24,
                      AppSpacing.s20,
                      AppSpacing.s24,
                    ),
                    child: builder(context, lesson),
                  ),
                ),
              ),
              if (footer != null && async.valueOrNull != null)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20,
                      AppSpacing.s8,
                      AppSpacing.s20,
                      AppSpacing.s8,
                    ),
                    child: footer!(context, async.value!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 나가기 확인 — Figma E3.
///
/// 「계속하기」를 주 버튼에 둔다. 실수로 닫는 쪽을 막는 것이 이 다이얼로그의 목적이고,
/// 주 버튼은 눈이 먼저 가는 자리이기 때문이다.
/// 스크림을 눌러 닫으면 `null` 이 오는데, 그때는 **나가지 않는다** — 의사를 밝힌 적이
/// 없는 동작을 나가기로 해석하지 않는다.
Future<bool> _confirmLeave(BuildContext context) async {
  final result = await showDialogBasic<bool>(
    context,
    title: '학습을 그만둘까요?',
    description: '지금 나가면 이번 연습은 저장되지 않아요.',
    primary: DialogAction(
      label: '계속하기',
      onPressed: () => Navigator.of(context).pop(false),
    ),
    secondary: DialogAction(
      label: '나가기',
      onPressed: () => Navigator.of(context).pop(true),
    ),
  );
  return result ?? false;
}
