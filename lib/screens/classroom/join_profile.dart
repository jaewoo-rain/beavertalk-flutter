import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/molecules/input_field.dart';
import '../../components/organisms/gnb.dart';
import '../../features/classroom/presentation/join_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/join_step_header.dart';

/// A3 이름·학번 — Figma `screen/hw_join_profile`(`5682:6325`).
///
/// 여기서 받는 이름은 **반 명단용**이라 앱 계정 이름과 별개다. 기본값을 앱
/// 이름으로 채우지 않는다 — 출석부와 맞출 이름은 보통 여권 표기라 앱에서 쓰는
/// 별명과 다르다.
///
/// 학번은 선택이다. 비우면 요청에서 키 자체가 빠진다.
class JoinProfileScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const JoinProfileScreen({super.key});

  @override
  ConsumerState<JoinProfileScreen> createState() => _JoinProfileScreenState();
}

class _JoinProfileScreenState extends ConsumerState<JoinProfileScreen> {
  final _name = TextEditingController();
  final _studentNo = TextEditingController();

  @override
  void initState() {
    super.initState();
    final draft = ref.read(joinDraftProvider);
    _name.text = draft.rosterName;
    _studentNo.text = draft.studentNo;
  }

  @override
  void dispose() {
    _name.dispose();
    _studentNo.dispose();
    super.dispose();
  }

  void _next() {
    ref
        .read(joinDraftProvider.notifier)
        .setProfile(
          rosterName: _name.text.trim(),
          studentNo: _studentNo.text.trim(),
        );
    Navigator.of(context).pushNamed(Routes.classroomJoinConsent);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;

    return AppScaffold(
      background: c.backgroundNormalNormal,
      bottomBar: BottomCtaBar(
        child: SizedBox(
          width: double.infinity,
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.next,
            disabled: _name.text.trim().isEmpty,
            onPressed: _next,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 3, total: 5),
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
                    title: l10n.hwJoinProfileTitle,
                    subtitle: l10n.hwJoinProfileSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  _field(
                    context,
                    label: l10n.hwJoinNameLabel,
                    help: l10n.hwJoinNameHelp,
                    controller: _name,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  _field(
                    context,
                    label: l10n.hwJoinStudentNoLabel,
                    help: l10n.hwJoinStudentNoHelp,
                    controller: _studentNo,
                    // 학번은 RTL 로케일에서도 왼쪽부터 읽는다(`10 §5`).
                    ltr: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 라벨 + 입력칸 + 도움말 한 벌.
  Widget _field(
    BuildContext context, {
    required String label,
    required String help,
    required TextEditingController controller,
    bool ltr = false,
  }) {
    final c = context.c;
    final field = InputField(
      controller: controller,
      onChanged: (_) => setState(() {}),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppType.label1.m.copyWith(color: c.labelNormal)),
        const SizedBox(height: AppSpacing.s12),
        if (ltr)
          Directionality(textDirection: TextDirection.ltr, child: field)
        else
          field,
        const SizedBox(height: AppSpacing.s8),
        Text(help, style: AppType.caption1.r.copyWith(color: c.labelNeutral)),
      ],
    );
  }
}
