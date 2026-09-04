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

  /// 이 반에 **지금 참여 중**인가. 반 목록이 정한다.
  ///
  /// 목록을 아직 못 받았으면 기다린다 — 여기서 성급히 false 로 떨어뜨리면
  /// 이미 들어와 있는 학습자에게 이름을 다시 묻게 된다.
  /// 조회가 실패하면 false 다. 건너뛰기는 **편의**이고, 못 건너뛰어도 원래
  /// 흐름으로 참여가 되기 때문이다(서버가 기존 행을 그대로 돌려준다).
  Future<bool> _alreadyJoined(int classroomId) async {
    try {
      final rooms = await ref.read(myClassroomsProvider.future);
      return rooms.any((r) => r.classroomId == classroomId);
    } catch (_) {
      return false;
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
          // ⭐ **이미 이 반의 학습자면 참여 절차를 건너뛴다**(2026-09-04 사장님 지시).
          //    이름·동의는 처음 들어올 때 받는 것이고, 이미 명단에 있는 사람에게
          //    다시 물으면 「기존 이름을 덮어쓸까」를 학습자가 판단하게 된다.
          //    서버도 이 경우 기존 행을 그대로 돌려준다(`ClassroomService.join`).
          //
          //    ⛔ 서버에 묻지 않는다 — `GET /classrooms/preview` 는 **인증 없는**
          //      경로라 「누가 물었는지」를 모른다. 반 목록은 앱이 이미 갖고 있다.
          //    ⚠ 나갔던 반은 여기 없다(`left_at` 을 서버가 거른다) — 재참여는
          //      이름·동의를 새로 받는 것이 맞다(익명화로 옛 이름은 이미 없다).
          final navigator = Navigator.of(context);
          if (await _alreadyJoined(preview.classroomId)) {
            if (!mounted) return;
            setState(() => _busy = false);
            invalidateClassroomMembership(ref);
            await navigator.pushNamedAndRemoveUntil(
              Routes.assignments,
              (r) => r.isFirst,
            );
            return;
          }
          ref.read(joinDraftProvider.notifier).setPreview(_code, preview);
          setState(() => _busy = false);
          // 위에서 잡아 둔 navigator 를 쓴다 — 참여 여부 조회가 async gap 이다.
          await navigator.pushNamed(Routes.classroomJoinConfirm);
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
