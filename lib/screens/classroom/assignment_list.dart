import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../features/classroom/domain/entities/classroom_membership.dart';
import '../../features/classroom/presentation/assignment_display.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'language_consent_prompt.dart';
import 'leave_class_sheet.dart';
import 'widgets/homework_list_parts.dart';

/// A6 숙제 목록 — 정본 `12_숙제`(`5679:24798`) 미완료 `6705:16616` · 완료 `6705:16740` ·
/// 과제 0개 `6705:16911` · 반 여러 개 `6705:16963`.
///
/// 위에서부터 반 정보 머리 · 「미완료 / 완료」 탭 · 선택한 탭의 카드(또는 빈 안내).
/// 정렬·분류는 [tabAssignments] 가 [groupAssignments] 를 그대로 따른다.
///
/// 반이 둘 이상이면 머리의 반 이름을 눌러 반을 고른다. 머리·탭·목록·빈 안내·GNB 나가기가
/// 모두 **고른 반 기준**이다(2026-10-13 확정 §2-7). 처음 고른 반은 기기에 남긴 마지막
/// 반(`JoinedClassStore`)이고, 없으면 `/classrooms/my` 의 첫 반이다.
///
/// 반 나가기는 GNB 오른쪽 아이콘이다. 🔴 과제가 0개여도 GNB 는 같으므로 나갈 길이 늘
/// 있다(PM-DEC-522·523 결함 재발 방지).
class AssignmentListScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const AssignmentListScreen({super.key});

  @override
  ConsumerState<AssignmentListScreen> createState() =>
      _AssignmentListScreenState();
}

class _AssignmentListScreenState extends ConsumerState<AssignmentListScreen> {
  Future<void>? _refreshing;

  /// 첫 진입은 늘 미완료 탭이다. 미완료가 0개여도 자동으로 넘기지 않는다(§2-6).
  AssignmentTab _tab = AssignmentTab.todo;

  /// 고른 반 id. null 이면 아직 기기 값을 못 읽었거나 없다 — 첫 반을 쓴다.
  int? _pickedId;

  @override
  void initState() {
    super.initState();
    if (!ref.read(myAssignmentsProvider).isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.invalidate(myAssignmentsProvider);
      });
    }
    unawaited(_restorePicked());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_consentPrompt());
    });
  }

  /// 모국어 재동의 또는 처리방침 개정 안내를 한 번 띄운다(PM-DEC-543).
  Future<void> _consentPrompt() async {
    try {
      final rooms = await ref.read(myClassroomsProvider.future);
      if (!mounted) return;
      await maybeShowClassroomConsentPrompt(context, ref, rooms);
    } catch (_) {
      // 반 목록을 못 받으면 이번에는 묻지 않는다.
    }
  }

  Future<void> _restorePicked() async {
    try {
      final saved = await ref.read(joinedClassStoreProvider).read();
      if (!mounted || saved == null || _pickedId != null) return;
      setState(() => _pickedId = saved);
    } catch (_) {
      // 기기 값을 못 읽으면 첫 반으로 둔다.
    }
  }

  Future<void> _refresh() {
    return _refreshing ??= _reload();
  }

  Future<void> _reload() async {
    try {
      ref.invalidate(myAssignmentsProvider);
      ref.invalidate(myClassroomsProvider);
      await ref.read(myAssignmentsProvider.future);
    } catch (_) {
      // The provider error renders the existing retry UI.
    } finally {
      _refreshing = null;
    }
  }

  Future<void> _pickClass(List<JoinedClassroom> rooms, int selectedId) async {
    final picked = await showClassPickerSheet(
      context,
      classrooms: rooms,
      selectedId: selectedId,
    );
    if (picked == null || picked == selectedId || !mounted) return;
    setState(() => _pickedId = picked);
    try {
      // 다음 진입도 이 반으로 연다. 나가기 시트의 마지막 폴백과 같은 칸이다.
      await ref.read(joinedClassStoreProvider).save(picked);
    } catch (_) {
      // 남기지 못해도 지금 화면은 바뀌었다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final async = ref.watch(myAssignmentsProvider);
    // 반 정보 머리 — 반 목록을 못 받았으면 머리만 빠지고 목록은 그대로 그린다.
    final joined = ref.watch(myClassroomsProvider).valueOrNull ?? const [];
    JoinedClassroom? classroom;
    for (final room in joined) {
      if (room.classroomId == _pickedId) classroom = room;
    }
    classroom ??= joined.isEmpty ? null : joined.first;
    final room = classroom;

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.hwTitle,
            onBack: () => Navigator.of(context).pop(),
            trailing: _LeaveClassButton(classroomId: room?.classroomId),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  _Failed(onRetry: () => ref.invalidate(myAssignmentsProvider)),
              data: (items) => _Body(
                // 반이 여럿이면 고른 반의 과제만 — 반 id 가 없는 옛 응답은 버리지 않는다.
                items: room == null || joined.length < 2
                    ? items
                    : [
                        for (final a in items)
                          if (a.classroomId == null ||
                              a.classroomId == room.classroomId)
                            a,
                      ],
                classroom: room,
                onPickClass: room != null && joined.length >= 2
                    ? () => _pickClass(joined, room.classroomId)
                    : null,
                tab: _tab,
                onTab: (t) => setState(() => _tab = t),
                onRefresh: _refresh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 반 정보 머리 + 탭 + 카드(또는 빈 안내).
class _Body extends StatelessWidget {
  const _Body({
    required this.items,
    required this.classroom,
    required this.onPickClass,
    required this.tab,
    required this.onTab,
    required this.onRefresh,
  });

  final List<ClassroomAssignment> items;
  final JoinedClassroom? classroom;
  final VoidCallback? onPickClass;
  final AssignmentTab tab;
  final ValueChanged<AssignmentTab> onTab;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final list = tabAssignments(items, DateTime.now())[tab] ?? const [];
    final room = classroom;

    // 빈 안내 문구 — §2-6 표 4경우. 받은 과제 자체가 0개면 탭과 무관하게 같은 안내다.
    final (String, String?) empty = items.isEmpty
        ? (l10n.hwListEmptyTitle, l10n.hwListEmptyBody)
        : tab == AssignmentTab.todo
        ? (l10n.hwTabTodoEmptyTitle, null)
        : (l10n.hwTabDoneEmptyTitle, null);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (room != null) ...[
                    HomeworkClassHeader(
                      classroom: room,
                      onPickClass: onPickClass,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                  ],
                  HomeworkTabs(
                    labels: [l10n.hwTabTodo, l10n.hwSectionDone],
                    activeIndex: tab.index,
                    onChanged: (i) => onTab(AssignmentTab.values[i]),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                ],
              ),
            ),
          ),
          if (list.isEmpty)
            // 안내는 탭 아래 **남은 높이**의 가운데다(`6705:16911`).
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyNote(title: empty.$1, body: empty.$2),
            )
          else
            SliverToBoxAdapter(
              child: ContentColumn(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final a in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                        child: HomeworkListCard(
                          assignment: a,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(Routes.assignmentDetail, arguments: a),
                        ),
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

/// 빈 안내 — 제목 Heading 2 Bold `Label/Strong` · 본문 Body 1 Regular `Label/Neutral` · 간격 8.
///
/// 일러스트·버튼·나가기 글자 링크는 없다(§2-6). 나가기는 GNB 아이콘이 맡는다.
class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.title, this.body});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Center(
      child: ContentColumn.narrow(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.heading2.b.copyWith(color: c.labelStrong),
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: AppType.body1.r.copyWith(color: c.labelNeutral),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// GNB 오른쪽 「교실에서 나가기」 아이콘(`6677:18202` · 24 · `Icon/Strong`).
///
/// 글자가 없으므로 옛 링크 문구(`hwLeaveClassLink`)를 스크린리더 라벨로 쓴다.
/// [classroomId] 는 고른 반이다 — 반 목록을 못 받았으면 null 이고 시트가 스스로 찾는다.
class _LeaveClassButton extends StatelessWidget {
  const _LeaveClassButton({this.classroomId});

  final int? classroomId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Semantics(
      button: true,
      label: l10n.hwLeaveClassLink,
      excludeSemantics: true,
      child: GestureDetector(
        key: const ValueKey('hw-leave-class'),
        onTap: () => showLeaveClassSheet(context, classroomId: classroomId),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 28,
          height: 28,
          child: Center(child: AppIcons.exit(size: 24, color: c.labelStrong)),
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
      child: ContentColumn.narrow(
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
