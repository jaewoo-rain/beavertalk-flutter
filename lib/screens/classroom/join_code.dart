import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/classroom/domain/entities/join_preview.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../features/classroom/presentation/join_draft_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/class_code_input.dart';
import 'widgets/join_error_note.dart';
import 'widgets/join_step_header.dart';

/// A1 참여 코드 입력 — Figma `screen/hw_join_code`(`5682:6211`).
///
/// 코드를 6자 채우면 「다음」이 열리고, 누르면 `GET /classrooms/preview` 로
/// 반을 조회한다. **조회에 성공해야 다음 화면으로 간다** — 잘못된 코드로
/// 이름까지 입력시키고 마지막에 튕기면 4화면을 되돌아가야 한다.
///
/// 라우트 인자로 코드 문자열을 주면 미리 채운다(딥링크 진입).
class JoinCodeScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const JoinCodeScreen({super.key, this.initialCode});

  /// 딥링크로 받은 코드. null 이면 빈 칸에서 시작한다.
  final String? initialCode;

  @override
  ConsumerState<JoinCodeScreen> createState() => _JoinCodeScreenState();
}

class _JoinCodeScreenState extends ConsumerState<JoinCodeScreen> {
  static const int _length = 6;

  String _code = '';
  bool _busy = false;

  /// 실패 안내. null 이면 안내가 없다.
  ({String title, String body})? _error;

  /// 딥링크로 받은 초기 코드.
  String _initial = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initial.isNotEmpty || _code.isNotEmpty) return;
    final injected =
        widget.initialCode ?? ModalRoute.of(context)?.settings.arguments;
    if (injected is String && injected.isNotEmpty) {
      _initial = injected.toUpperCase();
      _code = _initial;
    }
  }

  Future<void> _next() async {
    if (_code.length != _length || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    try {
      final result = await ref
          .read(classroomRepositoryProvider)
          .previewByCode(_code);
      if (!mounted) return;
      switch (result) {
        case JoinPreviewFound(:final preview):
          ref.read(joinDraftProvider.notifier).setPreview(_code, preview);
          setState(() => _busy = false);
          await Navigator.of(context).pushNamed(Routes.classroomJoinConfirm);
        case JoinPreviewNotFound():
          setState(() {
            _busy = false;
            _error = (
              title: l10n.hwJoinErrorNotFound,
              body: l10n.hwJoinErrorNotFoundBody,
            );
          });
        case JoinPreviewExpired():
          setState(() {
            _busy = false;
            _error = (
              title: l10n.hwJoinErrorExpired,
              body: l10n.hwJoinErrorExpiredBody,
            );
          });
      }
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        // 클라이언트 폴백 문구는 하드코딩 한국어라 30 로케일에서 튄다.
        _error = (
          title: e.fromServer ? e.message : l10n.hwJoinFailed,
          body: l10n.hwJoinErrorNotFoundBody,
        );
      });
    }
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
            disabled: _code.length != _length || _busy,
            onPressed: _next,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main2(
            progress: const GnbProgress(current: 1, total: 5),
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
                    title: l10n.hwJoinCodeTitle,
                    subtitle: l10n.hwJoinCodeSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    l10n.hwJoinCodeLabel,
                    style: AppType.label1.m.copyWith(color: c.labelNormal),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  ClassCodeInput(
                    length: _length,
                    initialValue: _initial,
                    enabled: !_busy,
                    onChanged: (v) => setState(() {
                      _code = v;
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.hwJoinCodeHelp,
                    style: AppType.caption1.r.copyWith(color: c.labelNeutral),
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
}
