import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../components/organisms/bottom_sheet.dart' as bt;
import '../../core/error/app_exception.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// DA1 반 나가기 시트 — Figma `overlay/hw_leave_class`(`5730:38640`).
///
/// 나가기는 **개인정보 공유 동의 철회**다. 선생님이 더 이상 결과를 볼 수 없게
/// 되고 반 명단 정보가 파기된다. 앱 계정과 개인 학습 기록은 남는다.
///
/// 되돌릴 수 없는 행동이라 확인을 한 번 받는다. 성공하면 마이페이지로 보낸다 —
/// 방금 나온 숙제 목록으로 돌아가면 빈 화면이 남는다.
Future<void> showLeaveClassSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0x00000000),
    isScrollControlled: true,
    builder: (_) => const _LeaveClassSheet(),
  );
}

class _LeaveClassSheet extends ConsumerStatefulWidget {
  const _LeaveClassSheet();

  @override
  ConsumerState<_LeaveClassSheet> createState() => _LeaveClassSheetState();
}

class _LeaveClassSheetState extends ConsumerState<_LeaveClassSheet> {
  bool _busy = false;

  Future<void> _leave() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // 과제에서 직접 읽는 쪽이 우선이다. 과제가 하나도 없는 반은 과제 목록에 안 나타나므로
    // 「내 반 목록」(`/classrooms/my`)이 다음이고, 기기에 적어 둔 값이 마지막 폴백이다.
    // 기기 값만 믿으면 재설치·다른 기기에서 참여한 학습자가 나갈 수 없다(2026-10-12 PM-DEC-523).
    final store = ref.read(joinedClassStoreProvider);
    final int? id =
        ref
            .read(myAssignmentsProvider)
            .valueOrNull
            ?.map((a) => a.classroomId)
            .firstWhere((e) => e != null, orElse: () => null) ??
        await _firstJoinedClassroomId() ??
        await store.read();

    if (id == null) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.hwLeaveFailed)));
      return;
    }

    try {
      await ref.read(classroomRepositoryProvider).leave(id);
      await store.clear();
      // 🔴 **두 축을 같이 버린다.** 과제만 버리면 마이페이지 카드가 반 이름을
      //    계속 들고 있어 「나갔는데 안 나가진」 화면이 된다(2026-09-04 실측).
      invalidateClassroomMembership(ref);
      if (!mounted) return;
      navigator.pop();
      navigator.pushNamedAndRemoveUntil(Routes.mypage, (r) => r.isFirst);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(e.fromServer ? e.message : l10n.hwLeaveFailed),
          ),
        );
    }
  }

  /// 「내 반 목록」의 첫 반 id. 숙제 화면만 열린 상태면 아직 안 읽었을 수 있어 기다린다.
  /// 목록을 못 받으면 null — 기기 저장값 폴백으로 넘어간다(실패 문구는 그 뒤 판단).
  Future<int?> _firstJoinedClassroomId() async {
    try {
      final rooms = await ref.read(myClassroomsProvider.future);
      return rooms.isEmpty ? null : rooms.first.classroomId;
    } on Exception {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;

    return bt.BottomSheet(
      layout: bt.BottomSheetLayout.twoButtonCol,
      primaryAction: bt.SheetAction(
        label: l10n.hwLeaveConfirm,
        onPressed: _busy ? null : _leave,
      ),
      secondaryAction: bt.SheetAction(
        label: l10n.hwLeaveCancel,
        onPressed: _busy ? null : () => Navigator.of(context).pop(),
      ),
      // ⛔ 좌우 여백을 주지 마라 — `bt.BottomSheet` 의 child 슬롯이 이미
      //   ContentColumn 으로 여백 주인이다(`bottom_sheet.dart:121`). 여기서 또 주면
      //   더해져서 폰 40, 태블릿에선 콘텐츠 폭이 600 캡을 깬다.
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.hwLeaveTitle,
              style: AppType.heading2.b.copyWith(color: c.labelStrong),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.hwLeaveBody,
              style: AppType.body1.r.copyWith(color: c.labelNormal),
            ),
          ],
        ),
      ),
    );
  }
}
