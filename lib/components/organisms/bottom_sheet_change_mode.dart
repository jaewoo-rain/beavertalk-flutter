import 'package:flutter/material.dart';

import '../../features/normalcall/domain/entities/call_channel.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../chrome/home_indicator.dart';
import '../molecules/select_card.dart';

/// 통화 중 **대화 방식**을 고르는 시트 — Figma `BottomSheet-Changethemode`
/// (`5015:11202`).
///
/// ## 왜 [BottomSheet] 을 안 쓰나
///
/// 저 조직체의 `twoButtonCol` 은 **보조 버튼이 위**다. 이 시트는 확인 버튼이 위여야
/// 한다(Figma). 순서만 다른 변형을 저기에 끼우면 기존 15개 시트의 배치 규칙이 흔들리므로
/// 여기서 푸터를 직접 짠다 — `BottomSheetContent` 가 같은 이유로 직접 짜는 것과 같다.
///
/// ## 확인 버튼이 있는 이유
///
/// 행을 누르면 **선택만** 바뀌고 모드는 안 바뀐다. 확인을 눌러야 전환된다.
/// 캐스케이드↔라이브 전환은 세션을 다시 세우는 일이라 오탭 비용이 크다.
///
/// 시트는 **자기 상태를 들고 있다**(선택은 로컬, 적용은 [onConfirm] 한 번). 통화 상태를
/// 직접 만지지 않으므로 취소하면 아무 흔적이 남지 않는다.
class BottomSheetChangeMode extends StatefulWidget {
  /// Creates the mode sheet.
  const BottomSheetChangeMode({
    super.key,
    required this.current,
    required this.onConfirm,
    required this.onDismiss,
  });

  /// 지금 통화가 붙어 있는 통로. 시트를 열 때의 선택 상태가 된다.
  final CallChannel current;

  /// 확인을 눌렀을 때 고른 통로로 호출된다. 고른 값이 [current] 와 같으면
  /// **호출되지 않는다** — 바뀐 게 없는데 세션을 다시 세우면 안 된다.
  final ValueChanged<CallChannel> onConfirm;

  /// 닫기·스크림 탭. 아무것도 적용하지 않는다.
  final VoidCallback onDismiss;

  /// [Dim] 스크림 위에 바닥 정렬로 얹은 형태.
  static Widget modal({
    Key? key,
    required CallChannel current,
    required ValueChanged<CallChannel> onConfirm,
    required VoidCallback onDismiss,
  }) {
    return Stack(
      key: key,
      children: [
        Dim(onTap: onDismiss),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetChangeMode(
              current: current,
              onConfirm: onConfirm,
              onDismiss: onDismiss,
            ),
          ),
        ),
      ],
    );
  }

  @override
  State<BottomSheetChangeMode> createState() => _BottomSheetChangeModeState();
}

class _BottomSheetChangeModeState extends State<BottomSheetChangeMode> {
  late CallChannel _picked = widget.current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;

    return Container(
      constraints: const BoxConstraints(maxWidth: 430),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grabber.
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s12),
            child: Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: c.lineNormal,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s20,
              AppSpacing.s20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.callModeSheetTitle,
                  textAlign: TextAlign.center,
                  style: AppType.body1.sb.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  l10n.callModeSheetSubtitle,
                  textAlign: TextAlign.center,
                  style: AppType.label1.r.copyWith(color: c.labelNormal),
                ),
                const SizedBox(height: AppSpacing.s20),
                SelectCard(
                  title: l10n.callModeFreeTalk,
                  description: l10n.callModeFreeTalkDesc,
                  icon: const Text('💬', style: TextStyle(fontSize: 20)),
                  checked: _picked == CallChannel.live,
                  onChanged: (_) =>
                      setState(() => _picked = CallChannel.live),
                ),
                const SizedBox(height: AppSpacing.s8),
                SelectCard(
                  title: l10n.callModeStudy,
                  description: l10n.callModeStudyDesc,
                  icon: const Text('📝', style: TextStyle(fontSize: 20)),
                  checked: _picked == CallChannel.cascade,
                  onChanged: (_) =>
                      setState(() => _picked = CallChannel.cascade),
                ),
              ],
            ),
          ),
          // Footer — 확인이 위, 닫기가 아래(Figma). 조직체 BottomSheet 과 순서가 반대다.
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s20,
              AppSpacing.s20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.callModeChange,
                  // 바뀐 게 없으면 누를 수 없다 — 같은 모드로 세션을 다시 세우는 것은
                  // 사용자가 원한 일이 아니다.
                  disabled: _picked == widget.current,
                  onPressed: _picked == widget.current
                      ? null
                      : () => widget.onConfirm(_picked),
                ),
                const SizedBox(height: AppSpacing.s8),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.callModeKeep,
                  onPressed: widget.onDismiss,
                ),
              ],
            ),
          ),
          const HomeIndicator(variant: HomeIndicatorVariant.subTransparent),
        ],
      ),
    );
  }
}
