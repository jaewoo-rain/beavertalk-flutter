import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../molecules/stacked_button_pair.dart';

/// A single button inside a [DialogBasic].
///
/// [type] is optional: when `null` the button is [BtnType.secondaryFill] (the
/// Figma default). The emphasised button names its type explicitly — which one
/// that is, and whether it sits on top or below, is a per-screen Figma decision.
class DialogAction {
  /// Creates a dialog action.
  const DialogAction({
    required this.label,
    this.onPressed,
    this.type,
  });

  /// Button label.
  final String label;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Explicit button style; `null` falls back to [BtnType.secondaryFill].
  final BtnType? type;
}

/// DialogBasic — Figma `03_Organisms / Dialog-Basic` (`175:12790`).
///
/// A centered modal card measured 1:1 from Figma:
/// - Width `335`, padding `24` (vertical) / `16` (horizontal),
///   radius [AppRadius.xs] (8), fill `Background/Elevated/Normal` (#2F3340).
/// - Body column: `16px` gap between the header block and the action block.
/// - Header block: centered column, `8px` gap.
///   - [title] in `AppType.body1.sb` (white).
///   - [description] in `AppType.label1.r` (`Label/Normal`).
/// - [actions]: one full-width button (`state=variant3`), or two buttons
///   **stacked** top→bottom in list order (column, gap 12, each full width).
///
/// 두 버튼은 항상 위아래다(09-24 사장님 확정 「양옆에 나란히 놓인 버튼 쌍을 전부 위아래로
/// 쌓습니다」 — 다국어 잘림 방지). 옛 `state=default` 가로 1:1(gap 8)은 없어졌다. 순서는
/// 화면마다 Figma 를 따른다 — 보통 보조 위 · 주요 아래, 예외는 주요 위(페이월 이탈 방지 등).
/// 그래서 슬롯 이름(주요·보조)이 아니라 **목록 순서**로 받는다.
///
/// This widget renders only the card; lay it over a [Dim] scrim to present it
/// (see [DialogBasicDemo] or use [showDialogBasic]).
///
/// ```dart
/// DialogBasic(
///   title: '정말 삭제할까요?',
///   description: '이 작업은 되돌릴 수 없습니다.',
///   actions: [
///     DialogAction(label: '취소', onPressed: () {}),                 // 위
///     DialogAction(label: '삭제', type: BtnType.primaryFill, onPressed: () {}), // 아래
///   ],
/// )
/// ```
class DialogBasic extends StatelessWidget {
  /// Creates a DialogBasic card.
  const DialogBasic({
    super.key,
    required this.title,
    this.description,
    required this.actions,
  }) : assert(actions.length == 1 || actions.length == 2);

  /// Title text — `AppType.body1.sb`, white, centered.
  final String title;

  /// Optional body text — `AppType.label1.r`, `Label/Normal`.
  final String? description;

  /// One or two actions, top → bottom.
  final List<DialogAction> actions;

  // Figma 카드 폭 335는 상수로 남기지 않았다. 그건 **폰 375에서** 좌우 20을 뺀
  // 값이고, [ContentColumn.narrow] 가 같은 값을 폭에서 다시 만든다(폰 335,
  // 태블릿 480). 두 곳에 적어 두면 한쪽만 고쳐진다.

  Widget _button(DialogAction action) {
    return Button(
      type: action.type ?? BtnType.secondaryFill,
      size: BtnSize.s48,
      text: action.label,
      onPressed: action.onPressed,
    );
  }

  Widget _buildActions() {
    if (actions.length == 1) return _button(actions.first);
    return StackedButtonPair(
      top: _button(actions[0]),
      bottom: _button(actions[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 카드 폭은 폰 335 → 태블릿 480(정본 「오버레이는 480 중앙 정렬」).
    //
    // 폭 제한이 [Material] **바깥**에 있어야 한다. 안에 두면 배경과 둥근 모서리는
    // 전폭으로 칠해지고 글자만 안으로 들어가, 카드가 아니라 화면을 가로지르는
    // 띠가 된다(태블릿 렌더에서 실제로 그렇게 나왔다).
    return ContentColumn.narrow(
      child: Material(
        // 카드 면 = `Background/Elevated/Dialog`(Light #FFFFFF · Dark #2F3340) — [DialogConfirmIcon]
        // 과 같다. 예전 `backgroundElevatedNormal` 은 Dark 값이 같아 티가 안 났는데, 09-26 Light
        // 값이 Figma #CBCCD3 으로 바뀌자 확인창이 진회색이 됐다(통합 세션 실기기 · e36222e).
        color: context.c.backgroundElevatedDialog,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header block (title + optional description), centered, gap 8.
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style:
                        AppType.body1.sb.copyWith(color: context.c.labelStrong),
                  ),
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description!,
                      textAlign: TextAlign.center,
                      style: AppType.label1.r
                          .copyWith(color: context.c.labelNormal),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a [DialogBasic] over a [Dim] scrim using Flutter's [showDialog].
///
/// Returns the value passed to `Navigator.pop` (e.g. from an action's
/// `onPressed`), or `null` if dismissed by tapping the scrim.
Future<T?> showDialogBasic<T>(
  BuildContext context, {
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
          child: DialogBasic(
            title: title,
            description: description,
            actions: actions,
          ),
        ),
      ],
    ),
  );
}

/// Gallery demo for [DialogBasic]: the pair and the single button laid over a [Dim] scrim
/// inside a [Stack]. Registration into the gallery is handled separately.
class DialogBasicDemo extends StatelessWidget {
  /// Creates the demo.
  const DialogBasicDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Stack(
        children: [
          // Dim scrim behind the dialogs.
          const Dim(),
          // Both layouts, scrollable so they all fit.
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DialogBasic(
                    title: '제목이 들어갈 자리입니다.',
                    description: '내용이 들어갈 자리입니다. 내용이 들어갈 자리입니다. '
                        '내용이 들어갈 자리입니다.',
                    actions: [
                      DialogAction(label: '취소', onPressed: () {}),
                      DialogAction(
                        label: '확인',
                        type: BtnType.primaryFill,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DialogBasic(
                    title: '제목이 들어갈 자리입니다.',
                    description: '내용이 들어갈 자리입니다. 내용이 들어갈 자리입니다. '
                        '내용이 들어갈 자리입니다.',
                    actions: [DialogAction(label: '확인', onPressed: () {})],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
