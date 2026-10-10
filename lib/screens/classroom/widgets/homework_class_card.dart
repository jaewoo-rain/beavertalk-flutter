import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../components/atoms/homework_chip.dart';
import '../../../components/molecules/card_class.dart';
import '../../../features/classroom/presentation/assignment_display.dart';
import '../../../features/classroom/domain/entities/classroom_assignment.dart';
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

  /// 마감이 가장 늦은 과제. 없으면 null.
  ///
  /// 다 끝낸 학습자에게 보여줄 것이 없으면 카드가 참여 전 모습으로 되돌아간다.
  ClassroomAssignment? _latest(List<ClassroomAssignment> items) {
    if (items.isEmpty) return null;
    final sorted = [...items]..sort((x, y) => y.dueAt.compareTo(x.dueAt));
    return sorted.first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(myAssignmentsProvider).valueOrNull ?? const [];
    // 🔴 **반 유무는 반 목록이 정한다.** 예전에는 「할 숙제가 있는가」로 판정해서
    //    숙제를 다 끝내면 이 카드가 참여코드 입력으로 돌아갔고, 학습자는 앱을
    //    켤 때마다 코드를 다시 쳤다(2026-09-04 사용자 보고).
    final joined = ref.watch(myClassroomsProvider).valueOrNull ?? const [];
    // 할 일이 남았으면 그것을, 다 했으면 **가장 최근 과제**를 보여준다. 반은
    // 있는데 카드가 빈 것보다 「다 했다」가 정확하다.
    final next = nextDueAssignment(items, DateTime.now()) ?? _latest(items);

    if (joined.isEmpty && next == null) {
      return CardClass.empty(
        headerLabel: l10n.hwMyClass,
        emptyTitle: l10n.hwClassEmptyTitle,
        emptySubtitle: l10n.hwClassEmptySubtitle,
        ctaLabel: l10n.hwClassEmptyCta,
        onCta: () => Navigator.of(context).pushNamed(Routes.classroomJoin),
      );
    }

    if (next == null) {
      // 반은 있는데 과제가 아직 없다. **참여 전 모습으로 되돌리지 않는다** —
      // 코드를 다시 치라는 뜻이 되기 때문이다. 목록으로 보낸다.
      return CardClass.empty(
        headerLabel: l10n.hwMyClass,
        emptyTitle: joined.first.name,
        emptySubtitle: l10n.hwListEmptyBody,
        ctaLabel: l10n.hwClassContinueCta,
        onCta: () => Navigator.of(context).pushNamed(Routes.assignments),
      );
    }

    return CardClass.active(
      headerLabel: l10n.hwMyClass,
      // 🔴 목록 응답에 기관명이 없다. 참여 때 본 값을 다시 받을 길이 없어
      //    반 이름을 쓴다 — 지어내지 않는다.
      institution: next.classroomName,
      badge: assignmentBadge(context, next),
      chapterLabel: assignmentTitleOf(next, l10n.hwChapterLabel),
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
