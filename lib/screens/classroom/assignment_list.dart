import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/card_homework.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../features/classroom/presentation/assignment_display.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'leave_class_sheet.dart';
import 'widgets/assignment_badge.dart';

/// A6 숙제 목록 — Figma `screen/hw_list`(`5684:5881`).
///
/// 세 칸으로 나눠 그린다 — 진행 중 · 예정 · 완료. 빈 칸은 머리글째 숨긴다.
/// 정렬·분류 규칙은 [groupAssignments] 가 한 곳에서 정한다.
///
/// 맨 아래 「교실에서 나가기」가 반 나가기 시트를 연다. 시안에는 설정 버튼이
/// 없다 — 사용자가 걷어내고 이 텍스트 링크로 대신했다.
class AssignmentListScreen extends ConsumerWidget {
  /// 화면을 만든다.
  const AssignmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final async = ref.watch(myAssignmentsProvider);

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.hwTitle,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  _Failed(onRetry: () => ref.invalidate(myAssignmentsProvider)),
              data: (items) => items.isEmpty
                  ? const _Empty()
                  : _Body(
                      items: items,
                      onRefresh: () async =>
                          ref.invalidate(myAssignmentsProvider),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 세 칸 목록 + 나가기 링크.
class _Body extends StatelessWidget {
  const _Body({required this.items, required this.onRefresh});

  final List<ClassroomAssignment> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final groups = groupAssignments(items, DateTime.now());

    final sections = <(String, List<ClassroomAssignment>)>[
      (l10n.hwSectionInProgress, groups[AssignmentBucket.inProgress] ?? []),
      (l10n.hwSectionUpcoming, groups[AssignmentBucket.upcoming] ?? []),
      (l10n.hwSectionDone, groups[AssignmentBucket.done] ?? []),
    ].where((s) => s.$2.isNotEmpty).toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s8,
          AppSpacing.s20,
          AppSpacing.s24,
        ),
        children: [
          for (final (title, list) in sections) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: Text(
                title,
                style: AppType.body1.b.copyWith(color: c.labelNormal),
              ),
            ),
            for (final a in list)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: _card(context, a),
              ),
            const SizedBox(height: AppSpacing.s12),
          ],
          const SizedBox(height: AppSpacing.s4),
          Center(
            child: GestureDetector(
              onTap: () => showLeaveClassSheet(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                child: Text(
                  l10n.hwLeaveClassLink,
                  style: AppType.body1.r.copyWith(color: c.labelNormal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, ClassroomAssignment a) {
    final l10n = AppLocalizations.of(context);
    final done = a.status == AssignmentStatus.done;
    return CardHomework(
      chapterLabel: assignmentTitleOf(a, l10n.hwChapterLabel),
      // 🔴 서버가 챕터 이름을 주지 않는다(학습자용 라우트에 없다). 반 이름이
      //    둘째 줄에 오는 이유다 — 없는 값을 지어내지 않는다.
      title: a.classroomName,
      dimmed: done,
      badge: assignmentBadge(context, a),
      countLabel: '${a.completedActivityCount}/${a.activityCount}',
      chips: [
        for (final act in a.activities)
          HomeworkCardChip(
            activityLabel(context, act),
            done: activityDone(a, act),
          ),
      ],
      onTap: () => Navigator.of(
        context,
      ).pushNamed(Routes.assignmentDetail, arguments: a),
    );
  }

}

/// 받은 숙제가 없다.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.hwListEmptyTitle,
              style: AppType.heading2.b.copyWith(color: c.labelStrong),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              l10n.hwListEmptyBody,
              textAlign: TextAlign.center,
              style: AppType.body1.r.copyWith(color: c.labelNormal),
            ),
          ],
        ),
      ),
    );
  }
}

/// 목록을 못 받았다.
class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.hwListFailed,
              textAlign: TextAlign.center,
              style: AppType.body1.r.copyWith(color: c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s16),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s48,
              text: l10n.hwRetry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
