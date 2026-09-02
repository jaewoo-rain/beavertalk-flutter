import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../components/atoms/homework_chip.dart';
import '../../../components/molecules/card_class.dart';
import '../../../features/classroom/presentation/assignment_display.dart';
import '../../../features/classroom/presentation/classroom_providers.dart';
import '../../../l10n/app_localizations.dart';
import 'assignment_badge.dart';

/// 마이페이지의 수업 카드 — Figma `Card/Class`(`5730:37906`).
///
/// 숙제 카드 시스템이 **숙제 화면 밖에서 쓰이는 유일한 지점**이다. 이 카드
/// 하나가 ClassCard · ProgressRing · Badge · Chip 넷을 동시에 소비한다.
///
/// 반이 없으면 참여 코드 입력으로, 있으면 숙제 목록으로 보낸다. 목록을 아직
/// 못 받았을 때도 **참여 전 모습으로 먼저 그린다** — 마이페이지가 카드 자리를
/// 비워 두면 형제 카드들의 리듬이 끊긴다.
class HomeworkClassCard extends ConsumerWidget {
  /// 카드를 만든다.
  const HomeworkClassCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(myAssignmentsProvider).valueOrNull ?? const [];
    final next = nextDueAssignment(items, DateTime.now());

    if (items.isEmpty || next == null) {
      return CardClass.empty(
        headerLabel: l10n.hwMyClass,
        emptyTitle: l10n.hwClassEmptyTitle,
        emptySubtitle: l10n.hwClassEmptySubtitle,
        ctaLabel: l10n.hwClassEmptyCta,
        onCta: () => Navigator.of(context).pushNamed(Routes.classroomJoin),
      );
    }

    return CardClass.active(
      headerLabel: l10n.hwMyClass,
      // 🔴 목록 응답에 기관명이 없다. 참여 때 본 값을 다시 받을 길이 없어
      //    반 이름을 쓴다 — 지어내지 않는다.
      institution: next.classroomName,
      badge: assignmentBadge(context, next),
      chapterLabel: l10n.hwChapterLabel(
        next.chapter.toString().padLeft(2, '0'),
      ),
      // 챕터 이름도 서버가 주지 않는다. 둘째 칸은 비워 둔다.
      chapterTitle: null,
      chips: [
        for (final act in next.activities)
          HomeworkChip(
            label: activityLabel(context, act),
            done: activityDone(next, act),
          ),
      ],
      completed: next.completedActivityCount,
      total: next.activityCount,
      ctaLabel: l10n.hwClassContinueCta,
      onCta: () => Navigator.of(context).pushNamed(Routes.assignments),
    );
  }
}
