import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../components/organisms/bottom_sheet.dart' as bt;
import '../../core/error/app_exception.dart';
import '../../features/classroom/domain/entities/classroom_membership.dart';
import '../../features/classroom/domain/language_share.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 반 화면에 들어갈 때 한 번 — 모국어 공개 재동의 또는 처리방침 개정 안내(PM-DEC-543).
///
/// - 10-13 전 동의 화면(모국어 비공개)으로 들어온 학습자에게는 재동의 시트를 띄운다.
///   '동의' 는 서버에 새 버전을 남기고, '동의 안 함' 은 아무것도 보내지 않는다 —
///   반은 그대로 쓰고 모국어만 교사에게 안 보인다. 시트가 개정 안내도 겸한다.
/// - 이미 새 화면으로 동의한 학습자에게는 개정 안내만 띄운다.
/// - 서버가 동의 버전을 안 주면(옛 서버) 아무것도 띄우지 않는다.
///
/// 띄운 사실은 [ClassroomConsentStore] 에 남겨 다시 띄우지 않는다. 실패해도 반 화면은
/// 그대로 쓴다 — 안내 하나 때문에 숙제를 막지 않는다.
Future<void> maybeShowClassroomConsentPrompt(
  BuildContext context,
  WidgetRef ref,
  List<JoinedClassroom> rooms,
) async {
  // 서버가 동의 버전을 안 주면 기기 기록을 읽을 것도 없다.
  if (rooms.isEmpty || rooms.any((r) => !r.reportsLanguageShare)) return;
  final store = ref.read(classroomConsentStoreProvider);
  final ClassroomConsentPrompt prompt;
  try {
    prompt = pickClassroomConsentPrompt(
      rooms,
      answered: await store.answered(),
      noticeSeen: await store.noticeSeen(),
    );
  } catch (_) {
    return;
  }
  if (!context.mounted) return;
  switch (prompt) {
    case NoConsentPrompt():
      return;
    case PrivacyNoticePrompt():
      await _markNoticeSeen(ref);
      if (!context.mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0x00000000),
        isScrollControlled: true,
        builder: (_) => const PrivacyNoticeSheet(),
      );
    case LanguageReconsentPrompt(:final classroom):
      await _markNoticeSeen(ref);
      if (!context.mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0x00000000),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (_) => LanguageReconsentSheet(classroom: classroom),
      );
  }
}

Future<void> _markNoticeSeen(WidgetRef ref) async {
  try {
    await ref.read(classroomConsentStoreProvider).markNoticeSeen();
  } catch (_) {
    // 남기지 못하면 다음 진입에 한 번 더 뜰 뿐이다.
  }
}

/// 처리방침 링크 한 줄. 시트를 닫지 않고 위에 문서를 연다.
class _PolicyLink extends StatelessWidget {
  const _PolicyLink();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Semantics(
      link: true,
      // InkWell 은 Material 조상이 있어야 그려진다 — 시트 밖(i18n 하네스)에서도 그리게 둔다.
      child: GestureDetector(
        key: const ValueKey('hw-policy-link'),
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pushNamed(Routes.privacy),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
          child: Text(
            l10n.privacyTitle,
            style: AppType.label1.m.copyWith(
              color: c.primaryNormal,
              decoration: TextDecoration.underline,
              decorationColor: c.primaryNormal,
            ),
          ),
        ),
      ),
    );
  }
}

/// 모국어 공개 재동의 시트.
class LanguageReconsentSheet extends ConsumerStatefulWidget {
  /// [classroom] 에 다시 묻는다.
  const LanguageReconsentSheet({super.key, required this.classroom});

  /// 물을 반.
  final JoinedClassroom classroom;

  @override
  ConsumerState<LanguageReconsentSheet> createState() =>
      _LanguageReconsentSheetState();
}

class _LanguageReconsentSheetState
    extends ConsumerState<LanguageReconsentSheet> {
  bool _busy = false;

  Future<void> _answer({required bool agree}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final id = widget.classroom.classroomId;
    if (agree) {
      try {
        await ref
            .read(classroomRepositoryProvider)
            .setLanguageConsent(id, kLanguageShareVersion);
        ref.invalidate(myClassroomsProvider);
      } on AppException catch (e) {
        // 남기지 못했으면 답한 것으로 치지 않는다 — 다음 진입에 다시 묻는다.
        if (!mounted) return;
        setState(() => _busy = false);
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(
                e.fromServer ? e.message : l10n.hwLangConsentFailed,
              ),
            ),
          );
        return;
      }
    }
    try {
      await ref.read(classroomConsentStoreProvider).markAnswered(id);
    } catch (_) {
      // 남기지 못하면 다음 진입에 한 번 더 묻는다.
    }
    if (!mounted) return;
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return bt.BottomSheet(
      layout: bt.BottomSheetLayout.twoButtonCol,
      primaryAction: bt.SheetAction(
        label: l10n.hwLangConsentAgree,
        onPressed: _busy ? null : () => _answer(agree: true),
      ),
      secondaryAction: bt.SheetAction(
        label: l10n.hwLangConsentDecline,
        onPressed: _busy ? null : () => _answer(agree: false),
      ),
      // 좌우 여백은 `bt.BottomSheet` 가 준다(`leave_class_sheet.dart` 와 같은 규약).
      child: _ScrollableBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.hwLangConsentTitle,
              style: AppType.heading2.b.copyWith(color: c.labelStrong),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.hwLangConsentBody(widget.classroom.name),
              style: AppType.body1.r.copyWith(color: c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s4),
            const _PolicyLink(),
          ],
        ),
      ),
    );
  }
}

/// 처리방침 개정 안내(새 화면으로 이미 동의한 학습자).
class PrivacyNoticeSheet extends StatelessWidget {
  /// 안내 시트를 만든다.
  const PrivacyNoticeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return bt.BottomSheet(
      layout: bt.BottomSheetLayout.singleButton,
      primaryAction: bt.SheetAction(
        label: l10n.hwPolicyNoticeOk,
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: _ScrollableBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.hwPolicyNoticeTitle,
              style: AppType.heading2.b.copyWith(color: c.labelStrong),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.hwPolicyNoticeBody(kPrivacyRevisionDate),
              style: AppType.body1.r.copyWith(color: c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s4),
            const _PolicyLink(),
          ],
        ),
      ),
    );
  }
}

/// 시트 본문. 긴 언어·긴 반 이름에서 화면을 넘으면 본문만 스크롤한다 — 버튼은 늘 보인다.
///
/// 거절해도 반을 쓸 수 있다는 문장은 고지 요소라 줄이지 않는다(320×640 de·fr·fil 에서
/// 26px 넘쳤다 · i18n_overflow_test).
class _ScrollableBody extends StatelessWidget {
  const _ScrollableBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpacing.s8),
        child: child,
      ),
    );
  }
}
