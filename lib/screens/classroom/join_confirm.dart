import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/presentation/join_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/info_rows_card.dart';
import 'widgets/join_step_header.dart';

/// A2 반 확인 — Figma `screen/hw_join_confirm`(`5682:6263`).
///
/// 코드로 조회한 반을 그대로 보여주고 「네, 맞아요」를 받는다. 반 이름은
/// **선생님이 쓴 원문**이며 번역하지 않는다(서버 계약의 명시 조항).
class JoinConfirmScreen extends ConsumerWidget {
  /// 화면을 만든다.
  const JoinConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final preview = ref.watch(joinDraftProvider).preview;

    // 코드 조회를 건너뛰고 들어올 수 없는 화면이다. 방어적으로 되돌린다.
    if (preview == null) {
      return AppScaffold(
        background: c.backgroundNormalNormal,
        body: const SizedBox.shrink(),
      );
    }

    return AppScaffold(
      background: c.backgroundNormalNormal,
      // 하단 인셋은 [BottomCtaBar] 가 한 곳에서 정한다 — 화면마다 손으로 짜면
      // 기기별 안전영역이 어긋난다.
      bottomBar: BottomCtaBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.hwJoinConfirmYes,
              onPressed: () =>
                  Navigator.of(context).pushNamed(Routes.classroomJoinProfile),
            ),
            const SizedBox(height: AppSpacing.s12),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: l10n.hwJoinConfirmRetry,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 2, total: 5),
            onClose: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s8,
                AppSpacing.s20,
                AppSpacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  JoinStepHeader(
                    title: l10n.hwJoinConfirmTitle,
                    subtitle: l10n.hwJoinConfirmSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  InfoRowsCard(
                    title: preview.name,
                    rows: [
                      if (preview.institution != null)
                        InfoRow(
                          l10n.hwJoinFieldInstitution,
                          preview.institution!,
                        ),
                      if (preview.teacherDisplayName != null)
                        InfoRow(
                          l10n.hwJoinFieldTeacher,
                          preview.teacherDisplayName!,
                        ),
                      InfoRow(
                        l10n.hwJoinFieldLearners,
                        '${preview.learnerCount} / ${preview.capacity}',
                      ),
                      if (preview.term != null)
                        InfoRow(l10n.hwJoinFieldTerm, preview.term!),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    l10n.hwJoinConfirmNote,
                    style: AppType.caption1.r.copyWith(color: c.labelNeutral),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
