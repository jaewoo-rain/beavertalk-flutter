import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_task.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/assignment_badge.dart';

/// A7 숙제 상세 — Figma `screen/hw_detail`(`5685:6129`).
///
/// 과제가 요구하는 활동을 카드로 늘어놓는다. 카드 순서는 서버가 준
/// `activities` 순서를 그대로 따른다 — 앱이 다시 정렬하면 선생님이 낸 순서와
/// 어긋난다.
///
/// 🔴 **발음과 워크북은 아직 실행할 수 없다.**
/// - 발음 — 과제 문장 목록 엔드포인트(`GET .../items`)가 서버에 없다. 문장이
///   없으면 `LearningArgs` 를 만들 수 없다.
/// - 워크북 — `assignment.workbook_url` 컬럼이 아직 없다.
///
/// 눌리는 척하는 버튼을 두지 않고 **비활성 + 이유**로 그린다. 서버가 열리면
/// 이 두 분기만 채우면 된다.
class AssignmentDetailScreen extends ConsumerWidget {
  /// 화면을 만든다.
  const AssignmentDetailScreen({super.key, this.assignment});

  /// 목록이 넘긴 과제. null 이면 라우트 인자에서 읽는다.
  final ClassroomAssignment? assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final args = ModalRoute.of(context)?.settings.arguments;
    final ClassroomAssignment? a =
        assignment ?? (args is ClassroomAssignment ? args : null);

    if (a == null) {
      return AppScaffold(
        background: c.backgroundNormalNormal,
        body: const SizedBox.shrink(),
      );
    }

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.hwChapterLabel(a.chapter.toString().padLeft(2, '0')),
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s8,
                AppSpacing.s20,
                AppSpacing.s24,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        a.classroomName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label1.r.copyWith(color: c.labelNeutral),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    assignmentBadge(context, a),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                for (final act in a.activities)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                    child: _taskCard(context, a, act),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(
    BuildContext context,
    ClassroomAssignment a,
    AssignmentActivity act,
  ) {
    final l10n = AppLocalizations.of(context);
    final bool done = activityDone(a, act);
    final Widget? badge = done ? assignmentBadgeDone(context) : null;

    switch (act) {
      case AssignmentActivity.speaking:
        return CardTask(
          icon: AppIcons.soundWave,
          title: l10n.hwActivitySpeaking,
          badge: badge,
          // 🔴 문장 목록 API 가 없어 실행할 수 없다. 이유를 설명에 적는다.
          description: l10n.hwSpeakingUnavailable,
          result: PronunciationResult(
            score: 0,
            state: PronunciationState.inactive,
            hint: l10n.hwSpeakingNoScore,
            // 지표 세 칸은 값이 없어도 자리를 지킨다 — 칸이 사라지면 채점 뒤
            // 카드 높이가 튄다.
            metrics: [
              PronunciationMetric(label: l10n.pronunciation, value: '-'),
              PronunciationMetric(label: l10n.fluency, value: '-'),
              PronunciationMetric(label: l10n.rhythm, value: '-'),
            ],
          ),
          ctaLabel: done ? l10n.hwCtaResult : l10n.hwCtaStudy,
          ctaType: done ? BtnType.secondaryFill : BtnType.primaryFill,
          // 문장 목록 API 가 없어 실행할 수 없다. 색만 살아 있으면 거짓말이다.
          ctaDisabled: true,
          onCta: null,
        );

      case AssignmentActivity.conversation:
        return CardTask(
          icon: AppIcons.chat,
          title: l10n.hwActivityConversation,
          badge: badge,
          description: l10n.hwTaskConversationDesc,
          ctaLabel: done ? l10n.hwCtaResult : l10n.hwCtaStudy,
          ctaType: done ? BtnType.secondaryFill : BtnType.primaryFill,
          // 통화는 서버가 스스로 과제에 묶는다(`submission_service.link_call`).
          // 앱은 평소 통화를 시작하기만 하면 된다.
          onCta: () => Navigator.of(context).pushNamed(Routes.callLoading),
        );

      case AssignmentActivity.workbook:
        return CardTask(
          icon: AppIcons.book,
          title: l10n.hwActivityWorkbook,
          // 🔴 `workbook_url` 이 서버 응답에 없다.
          description: l10n.hwWorkbookUnavailable,
          ctaLabel: l10n.hwCtaDownload,
          ctaType: BtnType.secondaryFill,
          ctaRightIcon: Builder(
            builder: (ctx) =>
                AppIcons.externalLink(size: 20, color: ctx.c.labelStrong),
          ),
          // `workbook_url` 이 없어 열 곳이 없다.
          ctaDisabled: true,
          onCta: null,
        );
    }
  }

  /// 워크북 링크가 생기면 이 경로로 연다. 지금은 호출자가 없다.
  static Future<void> openWorkbook(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    // 앱 안에서 PDF 를 그리지 않는다 — 뷰어를 들이면 30 로케일 폰트가 따라온다.
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
