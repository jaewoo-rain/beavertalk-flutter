import 'package:flutter/widgets.dart';

import '../../../components/atoms/homework_badge.dart';
import '../../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../../features/classroom/presentation/assignment_display.dart';
import '../../../l10n/app_localizations.dart';

/// 과제 상태 배지를 만든다 — 스펙 §7 「마감 표기」 그대로.
///
/// | 상황 | 표기 | tone |
/// |---|---|---|
/// | 마감 지남 | `미제출 · N일 지남` | danger |
/// | D-3 이내 | `D-n` | warning |
/// | D-4 이상 | `D-n` | neutral |
/// | 완료 | `완료` | success |
///
/// **문안은 서버가 만들지 않는다.** 여기가 30 로케일 조립 지점이다.
HomeworkBadge assignmentBadge(
  BuildContext context,
  ClassroomAssignment a, {
  DateTime? now,
}) {
  final l10n = AppLocalizations.of(context);
  final at = now ?? DateTime.now();

  if (a.status == AssignmentStatus.done) {
    return HomeworkBadge(
      tone: HomeworkBadgeTone.success,
      label: l10n.hwBadgeDone,
      showCheck: true,
    );
  }

  // 닫힌 과제는 제출을 받지 않는다. 「D-2」로 그리면 아직 할 수 있다고 읽힌다.
  // 완료 배지보다 뒤에 두는 이유 — 끝낸 과제가 닫혔으면 「완료」가 맞는 말이다.
  if (a.isClosed) {
    return HomeworkBadge(
      tone: HomeworkBadgeTone.neutral,
      label: l10n.hwBadgeClosed,
    );
  }

  final days = daysUntilDue(a.dueAt, at);

  if (a.overdue) {
    final late = -days;
    return HomeworkBadge(
      tone: HomeworkBadgeTone.danger,
      // 같은 날 안에서 시각만 지난 경우는 「N일 지남」이 0 이라 어색하다.
      label: late > 0 ? l10n.hwBadgeOverdueDays(late) : l10n.hwBadgeOverdue,
    );
  }

  if (days == 0) {
    return HomeworkBadge(
      tone: HomeworkBadgeTone.warning,
      label: l10n.hwBadgeDueToday,
    );
  }

  return HomeworkBadge(
    tone: days <= kUrgentDays
        ? HomeworkBadgeTone.warning
        : HomeworkBadgeTone.neutral,
    label: l10n.hwBadgeDday(days),
  );
}

/// 완료 배지 하나. 과제 카드가 활동별 완료를 표시할 때 쓴다.
///
/// [assignmentBadge] 는 과제 전체의 상태를 말하고, 이쪽은 **활동 한 건**이
/// 끝났다는 뜻이다. 둘을 한 함수로 묶으면 호출부에서 뜻이 헷갈린다.
HomeworkBadge assignmentBadgeDone(BuildContext context) {
  return HomeworkBadge(
    tone: HomeworkBadgeTone.success,
    label: AppLocalizations.of(context).hwBadgeDone,
    showCheck: true,
  );
}

/// 활동 코드를 로케일 이름으로. 칩·과제 카드가 함께 쓴다.
String activityLabel(BuildContext context, AssignmentActivity activity) {
  final l10n = AppLocalizations.of(context);
  return switch (activity) {
    AssignmentActivity.speaking => l10n.hwActivitySpeaking,
    AssignmentActivity.conversation => l10n.hwActivityConversation,
    AssignmentActivity.workbook => l10n.hwActivityWorkbook,
  };
}

/// 활동이 끝났는지 — 칩의 체크를 켤지 판정한다.
///
/// ⛔ 규칙을 여기에 두지 마라. 정본은 `ClassroomAssignment.isActivityDone` 이고
///    이 함수는 호출부 편의를 위한 얇은 위임이다. 예전에 판정이 두 벌이라
///    상세는 「완료」인데 목록은 `0/3` 이었다(2026-09-04).
bool activityDone(ClassroomAssignment a, AssignmentActivity activity) =>
    a.isActivityDone(activity);
