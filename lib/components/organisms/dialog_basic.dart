import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';

/// The action layout of a [DialogBasic], measured 1:1 from the Figma component
/// set `Dialog-Basic` (`175:12790`).
///
/// - [twoHorizontal] — `state=default`: two buttons side-by-side (row, gap 8),
///   both [BtnType.secondaryFill].
/// - [twoVertical] — `state=variant2`: two stacked buttons (column, gap 12),
///   the top one [BtnType.primaryFill], the bottom [BtnType.secondaryFill].
/// - [single] — `state=variant3`: one full-width [BtnType.secondaryFill] button.
enum DialogBasicVariant { twoHorizontal, twoVertical, single }

/// A single button inside a [DialogBasic].
///
/// [type] is optional: when `null`, [DialogBasic] picks the Figma default for
/// the slot (e.g. primary for the top button of [DialogBasicVariant.twoVertical],
/// secondary elsewhere).
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

  /// Explicit button style; `null` falls back to the variant's Figma default.
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
/// - Actions per [variant]; see [DialogBasicVariant].
///
/// Actions are supplied either via [actions] (a list of [DialogAction]) or via
/// the convenience [primary] / [secondary] pair. When both are given, [actions]
/// wins. The [Button] atom is reused for every action.
///
/// This widget renders only the card; lay it over a [Dim] scrim to present it
/// (see [DialogBasicDemo] or use [showDialogBasic]).
///
/// ```dart
/// DialogBasic(
///   title: '정말 삭제할까요?',
///   description: '이 작업은 되돌릴 수 없습니다.',
///   variant: DialogBasicVariant.twoVertical,
///   actions: [
///     DialogAction(label: '삭제', onPressed: () {}),
///     DialogAction(label: '취소', onPressed: () {}),
///   ],
/// )
/// ```
class DialogBasic extends StatelessWidget {
  /// Creates a DialogBasic card.
  const DialogBasic({
    super.key,
    required this.title,
    this.description,
    this.variant = DialogBasicVariant.twoHorizontal,
    this.actions,
    this.primary,
    this.secondary,
  });

  /// Title text — `AppType.body1.sb`, white, centered.
  final String title;

  /// Optional body text — `AppType.label1.r`, `Label/Normal`.
  final String? description;

  /// Action layout; see [DialogBasicVariant].
  final DialogBasicVariant variant;

  /// Explicit action list. Takes precedence over [primary] / [secondary].
  final List<DialogAction>? actions;

  /// Convenience primary action (used when [actions] is null).
  final DialogAction? primary;

  /// Convenience secondary action (used when [actions] is null).
  final DialogAction? secondary;

  // Figma 카드 폭 335는 상수로 남기지 않았다. 그건 **폰 375에서** 좌우 20을 뺀
  // 값이고, [ContentColumn.narrow] 가 같은 값을 폭에서 다시 만든다(폰 335,
  // 태블릿 480). 두 곳에 적어 두면 한쪽만 고쳐진다.

  /// Resolves the effective actions from [actions] or [primary]/[secondary].
  ///
  /// For the two-button variants the convenience pair maps to
  /// `[primary, secondary]` (top→bottom / left→right per Figma); for [single]
  /// it uses whichever of [primary]/[secondary] is provided.
  List<DialogAction> _resolveActions() {
    if (actions != null) return actions!;
    switch (variant) {
      case DialogBasicVariant.single:
        final a = primary ?? secondary;
        return a == null ? const [] : [a];
      case DialogBasicVariant.twoHorizontal:
      case DialogBasicVariant.twoVertical:
        return [
          ?primary,
          ?secondary,
        ];
    }
  }

  /// Default [BtnType] for the action at [index] within the current [variant],
  /// per Figma. Only [DialogBasicVariant.twoVertical] uses a primary slot.
  BtnType _defaultType(int index) {
    if (variant == DialogBasicVariant.twoVertical && index == 0) {
      return BtnType.primaryFill;
    }
    return BtnType.secondaryFill;
  }

  Widget _button(DialogAction action, int index) {
    return Button(
      type: action.type ?? _defaultType(index),
      size: BtnSize.s48,
      text: action.label,
      onPressed: action.onPressed,
    );
  }

  Widget _buildActions() {
    final list = _resolveActions();
    if (list.isEmpty) return const SizedBox.shrink();

    switch (variant) {
      case DialogBasicVariant.twoHorizontal:
        // Row, gap 8, each button fills half the width. (No cross-axis stretch:
        // the buttons are fixed-height [BtnSize.s48], and stretch would demand a
        // bounded height — which breaks when the dialog is laid out inline.)
        return Row(
          children: [
            for (var i = 0; i < list.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _button(list[i], i)),
            ],
          ],
        );
      case DialogBasicVariant.twoVertical:
        // Column, gap 12.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < list.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _button(list[i], i),
            ],
          ],
        );
      case DialogBasicVariant.single:
        // Single full-width button.
        return _button(list.first, 0);
    }
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
        color: context.c.backgroundElevatedNormal,
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
  DialogBasicVariant variant = DialogBasicVariant.twoHorizontal,
  List<DialogAction>? actions,
  DialogAction? primary,
  DialogAction? secondary,
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
            variant: variant,
            actions: actions,
            primary: primary,
            secondary: secondary,
          ),
        ),
      ],
    ),
  );
}

/// Gallery demo for [DialogBasic]: all three variants laid over a [Dim] scrim
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
          // The three variants, scrollable so they all fit.
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
                    variant: DialogBasicVariant.twoHorizontal,
                    primary: DialogAction(label: '취소', onPressed: () {}),
                    secondary: DialogAction(label: '확인', onPressed: () {}),
                  ),
                  const SizedBox(height: 24),
                  DialogBasic(
                    title: '제목이 들어갈 자리입니다.',
                    description: '내용이 들어갈 자리입니다. 내용이 들어갈 자리입니다. '
                        '내용이 들어갈 자리입니다.',
                    variant: DialogBasicVariant.twoVertical,
                    primary: DialogAction(label: '확인', onPressed: () {}),
                    secondary: DialogAction(label: '취소', onPressed: () {}),
                  ),
                  const SizedBox(height: 24),
                  DialogBasic(
                    title: '제목이 들어갈 자리입니다.',
                    description: '내용이 들어갈 자리입니다. 내용이 들어갈 자리입니다. '
                        '내용이 들어갈 자리입니다.',
                    variant: DialogBasicVariant.single,
                    primary: DialogAction(label: '확인', onPressed: () {}),
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
