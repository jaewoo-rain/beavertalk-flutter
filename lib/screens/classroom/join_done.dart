import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../core/format/dates.dart';
import '../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../features/classroom/domain/entities/classroom_membership.dart';
import '../../features/classroom/presentation/assignment_display.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../features/classroom/presentation/join_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/info_rows_card.dart';

/// A5 참여 완료 — Figma `screen/hw_join_done`(`5682:6479`).
///
/// 참여는 이미 A4 에서 끝났다. 이 화면은 결과를 알리고 숙제 목록으로 보낸다.
/// GNB 가 없다 — 되돌아갈 곳이 없는 종착 화면이다.
///
/// 숙제 개수·가장 빠른 마감은 목록을 다시 받아 계산한다. 참여 직후라 캐시가
/// 비어 있으므로 [myAssignmentsProvider] 를 무효화해 새로 받는다.
class JoinDoneScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const JoinDoneScreen({super.key, this.membership});

  /// A4 가 넘긴 참여 결과. null 이면 라우트 인자에서 읽는다.
  final ClassroomMembership? membership;

  @override
  ConsumerState<JoinDoneScreen> createState() => _JoinDoneScreenState();
}

class _JoinDoneScreenState extends ConsumerState<JoinDoneScreen> {
  ClassroomMembership? _membership;

  @override
  void initState() {
    super.initState();
    // 참여로 명단이 바뀌었다. 옛 목록을 그대로 쓰면 방금 들어온 반의 숙제가 없다.
    Future.microtask(() => ref.invalidate(myAssignmentsProvider));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_membership != null) return;
    final injected =
        widget.membership ?? ModalRoute.of(context)?.settings.arguments;
    if (injected is ClassroomMembership) _membership = injected;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final m = _membership;
    final assignments = ref.watch(myAssignmentsProvider);
    final List<ClassroomAssignment> items = assignments.valueOrNull ?? const [];
    final next = nextDueAssignment(items, DateTime.now());
    final int openCount = items
        .where((a) => a.status != AssignmentStatus.done)
        .length;

    return AppScaffold(
      background: c.backgroundNormalNormal,
      bottomBar: BottomCtaBar(
        child: SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.hwJoinDoneCta,
            onPressed: () {
              // 참여가 끝났으니 초안을 비운다 — 남기면 다음 참여에 옛 이름이 뜬다.
              ref.read(joinDraftProvider.notifier).clear();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(Routes.assignments, (r) => r.isFirst);
            },
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.primaryNormal14,
                  ),
                  child: Center(
                    child: AppIcons.check(size: 56, color: c.primaryNormal),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s20),
              Text(
                l10n.hwJoinDoneTitle(m?.classroomName ?? ''),
                textAlign: TextAlign.center,
                style: AppType.title3.b.copyWith(color: c.labelStrong),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                // 아직 목록을 못 받은 동안 「숙제가 없어요」라고 말하면 안 된다 —
                // 곧 3개가 뜰 수도 있다. 값이 도착하기 전에는 줄을 비운다.
                !assignments.hasValue
                    ? ''
                    : openCount == 0
                    ? l10n.hwJoinDoneNoAssignment
                    : l10n.hwJoinDoneSubtitle(openCount),
                textAlign: TextAlign.center,
                style: AppType.body1.r.copyWith(color: c.labelNormal),
              ),
              const SizedBox(height: AppSpacing.s20),
              InfoRowsCard(
                rows: [
                  if (next != null)
                    InfoRow(
                      l10n.hwJoinDoneNextDue,
                      localizedShortDate(context, next.dueAt),
                    ),
                  InfoRow(l10n.hwJoinDoneRosterName, m?.rosterName ?? ''),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
