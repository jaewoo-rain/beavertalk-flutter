import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/checkbox.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/classroom/domain/entities/classroom_membership.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../features/classroom/presentation/join_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/join_error_note.dart';
import 'widgets/join_step_header.dart';

/// A4 공유 동의 — Figma `screen/hw_join_consent`(`5682:6376`).
///
/// 공유되는 것과 되지 않는 것을 나란히 보여주고 체크를 받는다. **동의 없이는
/// 참여시키지 않는다** — 서버도 `share_consent=false` 를 400 으로 거절하지만,
/// 거절을 보고 되돌아오게 두지 않고 버튼을 잠근다.
///
/// 여기서 참여 요청을 보낸다(A5 는 결과 화면이다).
class JoinConsentScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const JoinConsentScreen({super.key});

  @override
  ConsumerState<JoinConsentScreen> createState() => _JoinConsentScreenState();
}

class _JoinConsentScreenState extends ConsumerState<JoinConsentScreen> {
  bool _busy = false;
  ({String title, String body})? _error;

  Future<void> _join() async {
    final draft = ref.read(joinDraftProvider);
    if (!draft.consent || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    try {
      final result = await ref
          .read(classroomRepositoryProvider)
          .join(
            joinCode: draft.code,
            rosterName: draft.rosterName,
            shareConsent: draft.consent,
            studentNo: draft.studentNo,
          );
      if (!mounted) return;
      switch (result) {
        case JoinSucceeded(:final membership):
          // 목록 응답에 `classroom_id` 가 없다. 나가기가 이 값을 요구하므로
          // 아는 지금 적어 둔다(`joined_class_store.dart`).
          await ref.read(joinedClassStoreProvider).save(membership.classroomId);
          if (!mounted) return;
          setState(() => _busy = false);
          await Navigator.of(
            context,
          ).pushNamed(Routes.classroomJoinDone, arguments: membership);
        case JoinClassFull():
          setState(() {
            _busy = false;
            _error = (
              title: l10n.hwJoinErrorFull,
              body: l10n.hwJoinErrorFullBody,
            );
          });
      }
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = (
          title: e.fromServer ? e.message : l10n.hwJoinFailed,
          body: l10n.hwJoinErrorFullBody,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final draft = ref.watch(joinDraftProvider);

    return AppScaffold(
      background: c.backgroundNormalNormal,
      bottomBar: BottomCtaBar(
        child: SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.hwJoinConsentCta,
            disabled: !draft.consent || _busy,
            onPressed: _join,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 4, total: 5),
            onClose: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s8,
                AppSpacing.s20,
                AppSpacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  JoinStepHeader(
                    title: l10n.hwJoinConsentTitle,
                    subtitle: l10n.hwJoinConsentSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _heading(context, l10n.hwJoinConsentSharedHeading),
                  _list(
                    context,
                    shared: true,
                    items: [
                      l10n.hwJoinConsentShared1,
                      l10n.hwJoinConsentShared2,
                      l10n.hwJoinConsentShared3,
                      l10n.hwJoinConsentShared4,
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _heading(context, l10n.hwJoinConsentNotSharedHeading),
                  _list(
                    context,
                    shared: false,
                    items: [
                      l10n.hwJoinConsentNotShared1,
                      l10n.hwJoinConsentNotShared2,
                      l10n.hwJoinConsentNotShared3,
                      l10n.hwJoinConsentNotShared4,
                      l10n.hwJoinConsentNotShared5,
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  AppCheckbox(
                    value: draft.consent,
                    label: l10n.hwJoinConsentAgree,
                    onChanged: (v) =>
                        ref.read(joinDraftProvider.notifier).setConsent(v),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.s16),
                    JoinErrorNote(title: _error!.title, body: _error!.body),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: Text(
        text,
        style: AppType.label1.b.copyWith(color: context.c.labelNormal),
      ),
    );
  }

  /// 공유 여부 목록. 초록 체크는 공유됨, 빨강 X 는 공유되지 않음이다.
  Widget _list(
    BuildContext context, {
    required bool shared,
    required List<String> items,
  }) {
    final c = context.c;
    final Color tone = shared ? c.primaryForeground : c.accentForegroundRed;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s8,
        horizontal: AppSpacing.s16,
      ),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            SizedBox(
              height: 32,
              child: Row(
                children: [
                  shared
                      ? AppIcons.check(size: 20, color: tone)
                      : AppIcons.close(size: 20, color: tone),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text(
                      item,
                      style: AppType.label1.r.copyWith(color: c.labelStrong),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
