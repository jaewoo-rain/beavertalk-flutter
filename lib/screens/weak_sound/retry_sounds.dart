import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/gnb.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../features/weak_sound/domain/entities/weak_sound_item.dart';
import '../../features/weak_sound/presentation/retry_practiced.dart';
import '../../features/weak_sound/presentation/widgets/weak_sound_card.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../home/learning_summary.dart';

/// 「자주 틀린 소리」 목록(A5 · Figma M2 `6564:15449` · M18 `6564:15584` · M19 `6564:15695`)에
/// 넘기는 인자.
class RetrySoundsArgs {
  /// Creates the arguments.
  const RetrySoundsArgs({required this.callId, this.callTitle});

  /// 리포트를 다시 받을 통화 — 학습을 마치고 돌아오면 점수(M18)를 새로 받는다.
  final int callId;

  /// 통화 제목(요약) — 부제 「{제목} 통화에서 …」. 없으면 제목 없는 부제.
  final String? callTitle;
}

/// 리포트에서 모은 「자주 틀린 소리」를 연습하는 목록.
///
/// 카드 탭 → 취약 발음 학습 4단계(0918 · 화면 그대로) → 결과 「목록으로」 → 여기(M18 ·
/// 리포트를 다시 받아 점수 갱신). 이번에 연 목록의 소리를 모두 마치면 M19 — 부제가
/// 「모두 연습했어요」로 바뀌고 「리포트로 돌아가기」가 붙는다. 뒤로 → 리포트(M1).
class RetrySoundsScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const RetrySoundsScreen({super.key});

  @override
  ConsumerState<RetrySoundsScreen> createState() => _RetrySoundsScreenState();
}

class _RetrySoundsScreenState extends ConsumerState<RetrySoundsScreen> {
  @override
  void initState() {
    super.initState();
    // 이번 방문 기준이다 — 지난 방문의 「마침」 기록이 M19 를 미리 켜지 않게 비운다.
    // 빌드 중에 공급자를 바꾸면 안 되므로 첫 프레임 뒤에 한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(retryPracticedProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! RetrySoundsArgs) {
      return Scaffold(
        backgroundColor: c.backgroundNormalNormal,
        body: SafeArea(child: Gnb.main(onBack: () => Navigator.of(context).maybePop())),
      );
    }
    final async = ref.watch(pronunciationReportProvider(args.callId));
    final practiced = ref.watch(retryPracticedProvider);
    // 다시 받는 동안에도 지난 값을 그린다 — 학습에서 돌아올 때마다 목록이 깜빡이지 않게.
    final sounds = async.valueOrNull?.retrySounds;
    final allDone = sounds != null &&
        sounds.isNotEmpty &&
        sounds.every((s) => practiced.contains(s.soundKey));
    return Scaffold(
      backgroundColor: c.backgroundNormalNormal,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gnb.main(
              title: l10n.wsRetryListTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: sounds != null
                  ? _List(
                      sounds: sounds,
                      subtitle: allDone
                          ? l10n.wsRetryListAllDone
                          : _subtitle(l10n, args.callTitle),
                      onOpen: (soundKey) => _open(args.callId, soundKey),
                    )
                  : async.hasError
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.s20),
                            child: EmptyBlock(
                              title: l10n.wsListLoadFailed,
                              body: l10n.wsRetryLater,
                              ctaText: l10n.wsRetry,
                              onCta: () => ref.invalidate(
                                pronunciationReportProvider(args.callId),
                              ),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
            ),
            if (allDone)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20,
                  AppSpacing.s12,
                  AppSpacing.s20,
                  AppSpacing.s20,
                ),
                child: Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.wsRetryBackToReport,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _subtitle(AppLocalizations l10n, String? title) {
    final t = title?.trim() ?? '';
    return t.isEmpty ? l10n.wsRetryListSub : l10n.wsRetryListSubWithCall(t);
  }

  /// 학습 4단계로 간다. 돌아오면(결과 「목록으로」 · 뒤로) 리포트를 다시 받아 점수를 갱신한다.
  Future<void> _open(int callId, String soundKey) async {
    await Navigator.of(context).pushNamed(Routes.weakSoundLearn, arguments: soundKey);
    if (mounted) ref.invalidate(pronunciationReportProvider(callId));
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.sounds,
    required this.subtitle,
    required this.onOpen,
  });

  final List<RetrySound> sounds;
  final String subtitle;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s16,
        AppSpacing.s20,
        AppSpacing.s40,
      ),
      children: [
        Text(
          l10n.wsRetryListSection,
          style: AppType.headline1.b.copyWith(color: c.labelStrong),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(subtitle, style: AppType.label2.r.copyWith(color: c.labelNormal)),
        const SizedBox(height: AppSpacing.s12),
        for (var i = 0; i < sounds.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s8),
          WeakSoundCard(
            item: weakSoundItemOf(sounds[i]),
            onTap: () => onOpen(sounds[i].soundKey),
          ),
        ],
      ],
    );
  }
}

/// 리포트의 「자주 틀린 소리」 → 취약 발음 목록 카드 모양. 점수 계산이 같으므로(서버 `_score_view`)
/// 그대로 옮긴다. 규칙 과는 키가 `onset_`/`coda_` 로 시작하지 않는다.
WeakSoundItem weakSoundItemOf(RetrySound s) => WeakSoundItem(
      soundKey: s.soundKey,
      label: s.label,
      cardDesc: s.cardDesc,
      type: s.soundKey.startsWith('onset_') || s.soundKey.startsWith('coda_')
          ? 'sound'
          : 'rule',
      score: s.score,
    );
