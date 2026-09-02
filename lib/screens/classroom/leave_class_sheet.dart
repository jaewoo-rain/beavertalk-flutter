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

    // 목록 응답에 `classroom_id` 가 없어 참여 때 적어 둔 값을 쓴다. 서버가 뒤에
    // 필드를 채우면 과제에서 직접 읽는 쪽이 우선이다.
    final store = ref.read(joinedClassStoreProvider);
    final int? id =
        ref
            .read(myAssignmentsProvider)
            .valueOrNull
            ?.map((a) => a.classroomId)
            .firstWhere((e) => e != null, orElse: () => null) ??
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
      ref.invalidate(myAssignmentsProvider);
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20,
          AppSpacing.s8,
          AppSpacing.s20,
          0,
        ),
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
