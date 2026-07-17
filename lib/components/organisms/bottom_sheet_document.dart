import 'package:flutter/material.dart' hide BottomSheet;

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/dim.dart';
import 'bottom_sheet.dart';

/// Body sizing of a [BottomSheetDocument], measured 1:1 from the Figma
/// component set `BottomSheet-Document` (`175:18500`).
///
/// Each value maps to a Figma `size=*` variant and drives the body padding,
/// inner gap and (for [max]) a fixed scroll height:
/// - [min] — body padding `16 / 20 / 60`, gap `8`, hug height.
/// - [normal] — body padding `16 / 20 / 24`, gap `20`, hug height.
/// - [max] — body padding `16 / 20 / 24`, gap `32`, **fixed body height 574**
///   (the body scrolls).
enum BottomSheetDocumentSize {
  /// Compact: short title + description.
  min,

  /// Medium: scrolling body that grows to fit content.
  normal,

  /// Tall: fixed-height (574) scrolling body for long documents.
  max,
}

/// Internal per-size body layout spec, measured from Figma `175:18500`.
class _DocSpec {
  const _DocSpec({
    required this.padTop,
    required this.padH,
    required this.padBottom,
    required this.gap,
    this.fixedHeight,
  });

  final double padTop;
  final double padH;
  final double padBottom;
  final double gap;

  /// Fixed body height for the [BottomSheetDocumentSize.max] variant.
  final double? fixedHeight;
}

/// BeaverTalk document bottom sheet — Figma `03_Organisms /
/// BottomSheet-Document` (`175:18500`).
///
/// A scrollable-document sheet composed of three stacked regions, measured 1:1
/// from Figma:
/// 1. A `GNB / sub-2` header (title + close affordance), padding `14 / 20`,
///    top corners rounded to [AppRadius.xl] (32).
/// 2. A scrolling body whose padding / gap / height follow [size]; see
///    [BottomSheetDocumentSize].
/// 3. A button footer reusing [BottomSheet] (`single-button`, size-60 primary)
///    with its trailing `sub-transparent` home indicator.
///
/// The sheet background is `Background/Elevated/Alternative` and the sheet itself is
/// clipped to a top radius of [AppRadius.lg] (24).
///
/// ```dart
/// BottomSheetDocument(
///   title: '이용약관',
///   size: BottomSheetDocumentSize.max,
///   action: SheetAction(label: '동의', onPressed: () {}),
///   child: Text(longDocumentBody),
/// )
/// ```
class BottomSheetDocument extends StatelessWidget {
  /// Creates a document bottom sheet.
  const BottomSheetDocument({
    super.key,
    required this.title,
    this.size = BottomSheetDocumentSize.normal,
    this.child,
    this.action,
    this.onClose,
  });

  /// Header title (Figma `GNB / sub-2`, body1 white).
  final String title;

  /// Body sizing token; see [BottomSheetDocumentSize].
  final BottomSheetDocumentSize size;

  /// Scrollable body content.
  final Widget? child;

  /// Footer primary action (size-60 `single-button` primary).
  final SheetAction? action;

  /// Close-button tap callback (top-right of the header).
  final VoidCallback? onClose;

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap; the
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double maxWidth = 430;

  // ── Per-size body spec, measured from Figma 175:18500 ──────────────────────
  static const Map<BottomSheetDocumentSize, _DocSpec> _specs = {
    BottomSheetDocumentSize.min:
        _DocSpec(padTop: 16, padH: 20, padBottom: 60, gap: 8),
    BottomSheetDocumentSize.normal:
        _DocSpec(padTop: 16, padH: 20, padBottom: 24, gap: 20),
    BottomSheetDocumentSize.max:
        _DocSpec(padTop: 16, padH: 20, padBottom: 24, gap: 32, fixedHeight: 574),
  };

  @override
  Widget build(BuildContext context) {
    final spec = _specs[size]!;

    final bodyPadding = EdgeInsets.fromLTRB(
      spec.padH,
      spec.padTop,
      spec.padH,
      spec.padBottom,
    );

    Widget body = SingleChildScrollView(
      padding: bodyPadding,
      child: child ?? const SizedBox.shrink(),
    );

    // `max` pins the scrolling body to a fixed height; the others hug content.
    if (spec.fixedHeight != null) {
      body = SizedBox(height: spec.fixedHeight, child: body);
    } else {
      body = Flexible(child: body);
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Sub2Header(title: title, onClose: onClose),
          body,
          BottomSheet(
            layout: BottomSheetLayout.singleButton,
            primaryAction:
                action ?? SheetAction(label: AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );
  }

  /// Presents the document sheet as a modal: a [Dim] scrim with the sheet
  /// bottom-aligned inside a [Stack].
  static Widget modal({
    Key? key,
    required BottomSheetDocument sheet,
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

/// `GNB / sub-2` header (`175:17896`) used by [BottomSheetDocument].
///
/// Measured from Figma: padding `14 / 20`, title [AppType.body1] (SemiBold,
/// white), and a 28×28 close icon on the trailing edge. A matching 28px spacer
/// leads so the title stays optically centered. Top corners are rounded to
/// [AppRadius.xl] (32) but the parent sheet clips them to its own radius.
class _Sub2Header extends StatelessWidget {
  const _Sub2Header({required this.title, this.onClose});

  final String title;
  final VoidCallback? onClose;

  static const double _iconBox = 28;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading spacer mirrors the trailing close icon (invisible in Figma).
          const SizedBox(width: _iconBox, height: _iconBox),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppType.body1.sb.copyWith(color: AppColors.text),
            ),
          ),
          SizedBox(
            width: _iconBox,
            height: _iconBox,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: _iconBox,
              onPressed: onClose,
              icon: AppIcons.close(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gallery demo for [BottomSheetDocument]: every [BottomSheetDocumentSize]
/// presented inside a 375-wide phone frame, bottom-aligned over a [Dim] scrim.
class BottomSheetDocumentDemo extends StatelessWidget {
  /// Creates the demo.
  const BottomSheetDocumentDemo({super.key});

  static const _variants = <(String, BottomSheetDocumentSize, double)>[
    ('min', BottomSheetDocumentSize.min, 320),
    ('normal', BottomSheetDocumentSize.normal, 420),
    ('max', BottomSheetDocumentSize.max, 760),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            for (final (label, size, frameH) in _variants) ...[
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
                height: frameH,
                child: BottomSheetDocument.modal(
                  onDismiss: () {},
                  sheet: BottomSheetDocument(
                    title: '개인정보 처리방침',
                    size: size,
                    onClose: () {},
                    action: SheetAction(label: '동의', onPressed: () {}),
                    child: Text(
                      _sampleBody(size),
                      style: AppType.label1.r
                          .copyWith(color: context.c.labelNormal),
                    ),
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

  static String _sampleBody(BottomSheetDocumentSize size) {
    const para =
        '회원제 서비스 이용에 따른 본인확인, 개인식별, 불량회원의 부정 이용방지와 비인가 '
        '사용 방지, 가입의사 확인, 불만처리 등 민원처리, 고지사항 전달.\n\n';
    switch (size) {
      case BottomSheetDocumentSize.min:
        return '회원님의 개인정보 보호를 위해 장기간 비밀번호를 유지 중인 경우 '
            '비밀번호 변경을 안내해 드리고 있습니다.';
      case BottomSheetDocumentSize.normal:
        return para * 2;
      case BottomSheetDocumentSize.max:
        return para * 8;
    }
  }

  /// A 375-wide phone frame with the modal overlay [Stack] inside.
  static Widget _phoneFrame(BuildContext context, {required Widget child, required double height}) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: SizedBox(
          width: 375,
          height: height,
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
