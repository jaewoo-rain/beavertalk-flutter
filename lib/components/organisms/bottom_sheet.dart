import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';

/// Footer layout of a [BottomSheet], measured 1:1 from the Figma component set
/// `BottomSheet` (`175:18138`).
///
/// Each value maps to a Figma `state=*` variant:
/// - [singleButton] — one full-width [BtnType.primaryFill] button.
/// - [singleButtonSub] — one full-width [BtnType.secondaryFill] button
///   (Figma `state=single-button-sub`).
/// - [twoButtonCol] — two full-width buttons stacked vertically; the secondary
///   action sits above the primary action.
/// - [twoButtonRow] — two buttons side by side (secondary outline + primary),
///   each filling half the row with a 10px gap.
enum BottomSheetLayout {
  /// Single full-width primary button.
  singleButton,

  /// Single full-width secondary (filled) button.
  singleButtonSub,

  /// Two full-width buttons stacked in a column (secondary on top).
  twoButtonCol,

  /// Two buttons in a row (secondary outline + primary).
  twoButtonRow,
}

/// A single sheet action — its [label] and tap [onPressed] callback.
///
/// Used for the [BottomSheet.primaryAction] and [BottomSheet.secondaryAction]
/// slots. Pass `null` to [onPressed] to render a non-interactive button.
class SheetAction {
  /// Creates a sheet action.
  const SheetAction({required this.label, this.onPressed});

  /// Button label text.
  final String label;

  /// Tap callback; `null` leaves the button non-interactive.
  final VoidCallback? onPressed;
}

/// BeaverTalk button-footer bottom sheet — Figma `03_Organisms / BottomSheet`
/// (`175:18138`).
///
/// Renders optional [child] content above a button footer, followed by a
/// `sub-transparent` [HomeIndicator]. The footer arrangement is driven by
/// [layout]; see [BottomSheetLayout]. Measured from Figma:
/// - Footer padding `12 / 20 / 0` (top / horizontal / bottom), inter-button
///   gap `10`.
/// - Buttons use [BtnSize.s60] (the size-60 [Button]).
/// - Sheet background `Background/Elevated/Alternative` with a top radius of
///   [AppRadius.lg] (24).
/// - Trailing [HomeIndicator] in [HomeIndicatorVariant.subTransparent].
///
/// Use [BottomSheet.modal] to overlay the sheet on a [Dim] scrim inside a
/// [Stack], bottom-aligned.
///
/// ```dart
/// BottomSheet(
///   layout: BottomSheetLayout.twoButtonRow,
///   primaryAction: SheetAction(label: '확인', onPressed: () {}),
///   secondaryAction: SheetAction(label: '취소', onPressed: () {}),
///   child: const Text('정말 삭제하시겠어요?'),
/// )
/// ```
class BottomSheet extends StatelessWidget {
  /// Creates a button-footer bottom sheet.
  const BottomSheet({
    super.key,
    required this.layout,
    this.primaryAction,
    this.secondaryAction,
    this.child,
  });

  /// Footer button arrangement; see [BottomSheetLayout].
  final BottomSheetLayout layout;

  /// Primary (right / bottom / sole) action.
  final SheetAction? primaryAction;

  /// Secondary (left / top) action — only used by the two-button layouts.
  final SheetAction? secondaryAction;

  /// Optional content rendered above the footer (inside the sheet body).
  final Widget? child;

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap. The
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double maxWidth = 430;

  /// Footer top padding (Figma `12`).
  static const double _footerTop = 12;

  /// Footer horizontal padding (Figma `20`).
  static const double _footerH = 20;

  /// Inter-button gap (Figma `10`).
  static const double _gap = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (child != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(_footerH, 20, _footerH, 0),
              child: child,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(_footerH, _footerTop, _footerH, 0),
            child: _footer(context),
          ),
          // Bottom safe-area inset — clears the real OS gesture bar (replaces
          // the former embedded fake HomeIndicator).
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Builds the footer for the current [layout].
  Widget _footer(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (layout) {
      case BottomSheetLayout.singleButton:
        return _fullButton(context, 
          BtnType.primaryFill,
          primaryAction ?? SheetAction(label: l10n.confirm),
        );
      case BottomSheetLayout.singleButtonSub:
        return _fullButton(context, 
          BtnType.secondaryFill,
          primaryAction ?? SheetAction(label: l10n.confirm),
        );
      case BottomSheetLayout.twoButtonCol:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _fullButton(context, 
              BtnType.secondaryFill,
              secondaryAction ?? SheetAction(label: l10n.cancel),
            ),
            const SizedBox(height: _gap),
            _fullButton(context, 
              BtnType.primaryFill,
              primaryAction ?? SheetAction(label: l10n.confirm),
            ),
          ],
        );
      case BottomSheetLayout.twoButtonRow:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _button(context, 
                BtnType.secondaryOutline,
                secondaryAction ?? SheetAction(label: l10n.cancel),
              ),
            ),
            const SizedBox(width: _gap),
            Expanded(
              child: _button(context, 
                BtnType.primaryFill,
                primaryAction ?? SheetAction(label: l10n.confirm),
              ),
            ),
          ],
        );
    }
  }

  /// A full-width size-60 button.
  Widget _fullButton(BuildContext context, BtnType type, SheetAction action) {
    return SizedBox(width: double.infinity, child: _button(context, type, action));
  }

  /// A size-60 [Button] for the given [type] and [action].
  Widget _button(BuildContext context, BtnType type, SheetAction action) {
    return Button(
      type: type,
      size: BtnSize.s60,
      text: action.label,
      onPressed: action.onPressed,
    );
  }

  /// Presents [sheet] as a modal: a [Dim] scrim with the sheet bottom-aligned
  /// inside a [Stack]. Drop the result directly as a full-screen overlay.
  static Widget modal({
    Key? key,
    required BottomSheet sheet,
    VoidCallback? onDismiss,
  }) {
    return Stack(
      key: key,
      children: [
        Dim(onTap: onDismiss),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Align(alignment: Alignment.bottomCenter, child: sheet),
        ),
      ],
    );
  }
}

/// Gallery demo for [BottomSheet]: every [BottomSheetLayout] presented inside a
/// 375-wide phone frame, bottom-aligned over a [Dim] scrim.
class BottomSheetDemo extends StatelessWidget {
  /// Creates the demo.
  const BottomSheetDemo({super.key});

  static const _variants = <(String, BottomSheetLayout)>[
    ('single-button', BottomSheetLayout.singleButton),
    ('single-button-sub', BottomSheetLayout.singleButtonSub),
    ('two-button-col', BottomSheetLayout.twoButtonCol),
    ('two-button-row', BottomSheetLayout.twoButtonRow),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            for (final (label, layout) in _variants) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: AppType.label2.sb
                        .copyWith(color: context.c.labelNormal),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _phoneFrame(context, 
                child: BottomSheet.modal(
                  onDismiss: () {},
                  sheet: BottomSheet(
                    layout: layout,
                    primaryAction:
                        SheetAction(label: '확인', onPressed: () {}),
                    secondaryAction:
                        SheetAction(label: '취소', onPressed: () {}),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  /// A 375-wide phone frame with the modal overlay [Stack] inside.
  static Widget _phoneFrame(BuildContext context, {required Widget child}) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: SizedBox(
          width: 375,
          height: 320,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: context.c.backgroundNormalNormal)),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
