import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../molecules/stacked_button_pair.dart';
import 'dialog_basic.dart' show DialogAction;

/// `Dialog/Confirm-Icon` — Figma 컴포넌트 `6198:29743`(섹션 `6198:1990`).
///
/// 아이콘을 머리에 단 확인 창. 첫 사용처는 페이월 이탈 방지(`paywall_exit_guard`
/// Mobile `6192:29141` · Tablet `6238:48555`, 09-24 사장님 「Figma 대로 해」).
/// ```
/// ┌──────────────────────────┐   카드 · 패딩 24/16 · 모서리 8 · `Background/Elevated/Dialog`
/// │          [icon 48]        │   ┐
/// │        제목(16 Bold)       │   │ Copy · 가운데 · gap 8
/// │      본문(14 Regular)      │   ┘
/// │                           │   16
/// │ [      위 버튼 48       ] │   ┐ Buttons · 세로 · gap 12 · 전폭
/// │ [      아래 버튼 48     ] │   ┘
/// └──────────────────────────┘
/// ```
/// [DialogBasic] 과 다른 점: 머리 아이콘 · 제목 Bold · 카드 면 토큰(Dialog). 버튼 색은 각
/// [DialogAction.type] 이 정하고, 안 주면 secondary_fill 이다.
class DialogConfirmIcon extends StatelessWidget {
  /// Creates the card.
  const DialogConfirmIcon({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.actions,
  }) : assert(actions.length == 1 || actions.length == 2);

  /// 머리 아이콘(48).
  final Widget icon;

  /// 제목.
  final String title;

  /// 본문 — 여러 줄 허용.
  final String? description;

  /// 위→아래 버튼.
  final List<DialogAction> actions;

  Widget _button(DialogAction a) => Button(
        type: a.type ?? BtnType.secondaryFill,
        size: BtnSize.s48,
        text: a.label,
        onPressed: a.onPressed,
      );

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return ContentColumn.narrow(
      child: Material(
        color: c.backgroundElevatedDialog,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: SizedBox.square(dimension: 48, child: icon)),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppType.body1.b.copyWith(color: c.labelStrong),
              ),
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: AppType.label1.r.copyWith(color: c.labelNormal),
                ),
              ],
              const SizedBox(height: 16),
              if (actions.length == 1)
                _button(actions.first)
              else
                StackedButtonPair(
                  top: _button(actions[0]),
                  bottom: _button(actions[1]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [DialogConfirmIcon] 을 [Dim] 위에 띄운다. 스크림을 누르면 닫힌다(`null`).
Future<T?> showDialogConfirmIcon<T>(
  BuildContext context, {
  required Widget icon,
  required String title,
  String? description,
  required List<DialogAction> actions,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.transparent, // Dim provides the scrim.
    builder: (context) => Stack(
      children: [
        Dim(onTap: () => Navigator.of(context).maybePop()),
        Center(
          child: DialogConfirmIcon(
            icon: icon,
            title: title,
            description: description,
            actions: actions,
          ),
        ),
      ],
    ),
  );
}
