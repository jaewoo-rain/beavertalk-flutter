import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/atoms/button.dart';
import '../../../../components/molecules/empty_state.dart';
import '../../../../components/organisms/dialog_basic.dart';
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/sound_lesson.dart';
import '../weak_sound_providers.dart';
import 'learn_header.dart';
import '../../../../l10n/app_localizations.dart';

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
    this.confirmExit,
    this.scrollable = true,
  });

  final String soundKey;

  /// 1~4.
  final int step;

  /// 과가 도착한 뒤의 본문.
  final Widget Function(BuildContext context, SoundLesson lesson) builder;

  /// 아래 고정 버튼. null 이면 푸터를 두지 않는다(자동진행 화면).
  final Widget Function(BuildContext context, SoundLesson lesson)? footer;

  /// 나가기 확인 다이얼로그를 띄울지. 안 주면 **1단계에서만** 띄운다.
  ///
  /// 뒤로가기의 뜻이 단계마다 다르다 — 1단계에서 뒤로 가면 **학습을 떠나** 목록으로
  /// 돌아가지만, 2~4단계에서는 **앞 단계로** 갈 뿐이라 잃는 것이 없다. 안 잃는 곳에서
  /// 「저장되지 않아요」를 묻는 것은 겁만 주는 짓이다(2026-09-21 사용자 지적).
  final bool? confirmExit;

  /// 본문을 스크롤로 감쌀지.
  ///
  /// ⛔ 자동 연습·평가 화면은 **false** 다. 그 화면들은 주 동작(다음 버튼·마이크)을
  ///    화면 아래에 붙여야 하는데, 스크롤로 감싸면 내용 높이만큼만 차지해 동작이
  ///    화면 한가운데 떠 버린다(실기기 확인 2026-09-21). false 면 본문이 남은 높이를
  ///    그대로 받아 `Spacer` 로 아래에 붙일 수 있다.
  final bool scrollable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final async = ref.watch(soundLessonProvider(soundKey));
    final confirm = confirmExit ?? (step == 1);
    return PopScope(
      canPop: !confirm,
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
                onBack: () async {
                  if (!confirm || await _confirmLeave(context)) {
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
                        title: l10n.wsLessonLoadFailed,
                        body: l10n.wsRetryLater,
                        ctaText: l10n.wsRetry,
                        onCta: () =>
                            ref.invalidate(soundLessonProvider(soundKey)),
                      ),
                    ),
                  ),
                  data: (lesson) {
                    const pad = EdgeInsets.fromLTRB(
                      AppSpacing.s20,
                      AppSpacing.s24,
                      AppSpacing.s20,
                      AppSpacing.s24,
                    );
                    final body = builder(context, lesson);
                    if (scrollable) {
                      return SingleChildScrollView(padding: pad, child: body);
                    }
                    // 높이를 꽉 채우되 **넘치면 스크롤한다.**
                    //
                    // 그냥 Padding 으로 두면 Spacer 가 남은 높이를 먹어 아래 고정은
                    // 되지만, 긴 평가 문장이나 작은 화면에서 내용이 넘치는 순간
                    // 노란 줄무늬(overflow)가 뜬다. minHeight + IntrinsicHeight 면
                    // 평소엔 Spacer 가 살아 있고, 넘칠 때만 스크롤로 내려앉는다.
                    return LayoutBuilder(
                      builder: (context, box) => SingleChildScrollView(
                        padding: pad,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: box.maxHeight -
                                pad.top -
                                pad.bottom,
                          ),
                          child: IntrinsicHeight(child: body),
                        ),
                      ),
                    );
                  },
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
                    // 전폭이다. Padding 은 자식을 늘려 주지 않아서, 감싸지 않으면
                    // 버튼이 글자 폭(Hug)으로 쪼그라든다(실기기 확인 2026-09-21).
                    child: SizedBox(
                      width: double.infinity,
                      child: footer!(context, async.value!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 나가기 확인 — Figma E3 (`6093:14169`).
///
/// 버튼 순서는 정본을 따른다 — **나가기 위 · 계속하기 아래**(E3, 09-24 버튼 쌍 세로 확정).
/// 「계속하기」가 primary_fill 이다.
///
/// 스크림을 눌러 닫으면 `null` 이 오는데, 그때는 **나가지 않는다** — 의사를 밝힌 적이
/// 없는 동작을 나가기로 해석하지 않는다.
Future<bool> _confirmLeave(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialogBasic<bool>(
    context,
    title: l10n.wsQuitTitle,
    description: l10n.wsQuitBody,
    actions: [
      DialogAction(
        label: l10n.wsQuit,
        onPressed: () => Navigator.of(context).pop(true),
      ),
      DialogAction(
        label: l10n.wsContinue,
        type: BtnType.primaryFill,
        onPressed: () => Navigator.of(context).pop(false),
      ),
    ],
  );
  return result ?? false;
}
