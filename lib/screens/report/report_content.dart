import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/text_area.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/report/domain/entities/report_reason.dart';
import '../../features/report/presentation/report_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 신고 화면에 넘기는 인자.
///
/// 통화 종료 화면에서는 방금 끝난 통화의 `callId` 가 있고, 기록 목록에서는
/// 특정 통화를 지목하지 않으므로 null 이다.
typedef ReportArgs = ({int? callId, ReportSource source});

/// AI 생성 콘텐츠 신고 — Google Play 생성형 AI 정책 대응 화면.
///
/// 정책은 "AI로 콘텐츠를 생성하는 앱은 사용자가 **앱을 벗어나지 않고** 불쾌한
/// 콘텐츠를 신고·플래그할 수 있는 기능을 포함해야 한다"고 요구하고, 텍스트
/// 챗봇이 명시적 적용 대상이다. 비버톡은 AI 캐릭터와 음성으로 대화하므로 정면
/// 대상이며, 이 화면이 없으면 첫 릴리스가 정책 반려된다.
///
/// **접수는 이 화면 안에서 끝난다.** 메일 앱이나 웹 폼으로 넘기지 않는다 —
/// 그건 "앱을 벗어남"으로 볼 여지가 있다. 제출에 성공하면 같은 화면이 접수 완료
/// 상태로 바뀐다.
class ReportContentScreen extends ConsumerStatefulWidget {
  /// 신고 화면을 만든다. 인자는 라우트의 `arguments` 로도 받는다.
  const ReportContentScreen({super.key, this.args});

  /// 직접 주입되는 인자(테스트·직접 push 용). null 이면 라우트 인자를 읽는다.
  final ReportArgs? args;

  @override
  ConsumerState<ReportContentScreen> createState() =>
      _ReportContentScreenState();
}

class _ReportContentScreenState extends ConsumerState<ReportContentScreen> {
  /// 고른 사유. null 이면 제출 버튼이 비활성이다.
  ReportReason? _reason;

  /// 자유 입력.
  final _detail = TextEditingController();

  /// 제출 중이면 true — 중복 접수를 막는다.
  bool _sending = false;

  /// 접수가 끝나면 true — 같은 화면이 완료 안내로 바뀐다.
  bool _done = false;

  /// 라우트에서 읽은 인자.
  ReportArgs _resolved = (callId: null, source: ReportSource.recordList);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final injected = widget.args;
    if (injected != null) {
      _resolved = injected;
      return;
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ReportArgs) _resolved = args;
  }

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  /// 신고를 접수한다. 실패는 스낵바로만 알리고 화면을 유지한다 — 사용자가 쓴
  /// 내용을 날리지 않기 위해서다.
  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(reportRepositoryProvider).submit(
            reason: reason,
            source: _resolved.source,
            callId: _resolved.callId,
            detail: _detail.text,
          );
      if (!mounted) return;
      setState(() {
        _sending = false;
        _done = true;
      });
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      final l10n = AppLocalizations.of(context);
      // 클라이언트가 만든 폴백 문구는 하드코딩 한국어라 30개 로케일에서 한국어가
      // 튀어나온다. 서버가 쓴 문구일 때만 그대로 보여준다.
      final text = e.fromServer ? e.message : l10n.reportFailed;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.reportTitle,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(child: _done ? _doneBody(l10n) : _formBody(l10n)),
        ],
      ),
    );
  }

  /// 사유 선택 + 자유 입력 + 제출.
  Widget _formBody(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, AppSpacing.s8, AppSpacing.s20, AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.reportPrompt,
                  style:
                      AppType.title3.b.copyWith(color: context.c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.reportGuide,
                  style: AppType.body2.r
                      .copyWith(color: context.c.labelAlternative),
                ),
                const SizedBox(height: AppSpacing.s24),
                for (final r in ReportReason.values) ...[
                  _reasonRow(r, l10n),
                  const SizedBox(height: AppSpacing.s8),
                ],
                const SizedBox(height: AppSpacing.s16),
                TextArea(
                  controller: _detail,
                  hintText: l10n.reportDetailHint,
                  maxLength: 500,
                  minLines: 3,
                  maxLines: 6,
                  enabled: !_sending,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s24),
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: _sending ? l10n.loadingShort : l10n.reportSubmit,
            disabled: _reason == null || _sending,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }

  /// 사유 1줄. 라디오처럼 하나만 선택된다.
  Widget _reasonRow(ReportReason r, AppLocalizations l10n) {
    final selected = _reason == r;
    return Semantics(
      button: true,
      selected: selected,
      label: r.label(l10n),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _sending ? null : () => setState(() => _reason = r),
        child: Container(
          // 44dp 미만이면 탭 타깃 권고에 걸린다. 56으로 여유를 둔다.
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            // 테두리를 selected 여부로 통째로 없애면 두께가 0↔1 로 흔들려 1px
            // 튄다. 색만 바꾸고 두께는 항상 1로 둔다.
            border: Border.all(
              color: selected ? context.c.primaryNormal : context.c.lineNeutral,
            ),
            color: selected
                ? context.c.primaryNormal10
                : context.c.backgroundElevatedAlternative,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  r.label(l10n),
                  style: AppType.body1.r.copyWith(
                    color: selected
                        ? context.c.primaryNormal
                        : context.c.labelNormal,
                  ),
                ),
              ),
              if (selected)
                AppIcons.check(size: 24, color: context.c.primaryNormal),
            ],
          ),
        ),
      ),
    );
  }

  /// 접수 완료 안내. 여기서 흐름이 끝나고 이전 화면으로 돌아간다.
  Widget _doneBody(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: AppSpacing.s80,
                  height: AppSpacing.s80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.c.primaryNormal10,
                  ),
                  alignment: Alignment.center,
                  child:
                      AppIcons.check(size: 32, color: context.c.primaryNormal),
                ),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  l10n.reportDoneTitle,
                  textAlign: TextAlign.center,
                  style:
                      AppType.title3.b.copyWith(color: context.c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.reportDoneBody,
                  textAlign: TextAlign.center,
                  style: AppType.body2.r
                      .copyWith(color: context.c.labelAlternative),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20, 0, AppSpacing.s20, AppSpacing.s24),
          child: Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: l10n.confirm,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
