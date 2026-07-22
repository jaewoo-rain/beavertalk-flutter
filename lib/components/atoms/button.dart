import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Visual style of a [Button], measured 1:1 from Figma component set
/// `Button` (`45:45158`).
///
/// Each value maps to a Figma `type=*` variant:
/// - [primaryFill] — `bg primary / text onPrimary(black)`
/// - [primaryOutline] — `bg surface / border primary / text primary`
/// - [primaryOutlineWhite] — `bg surface / border primary / text white`
/// - [secondaryFill] — `bg surface2 / text white`
/// - [secondaryOutline] — `bg surface2 / border surface2 / text textSecondary`
/// - [secondaryWhite] — `bg surfaceElevated / border surface2 / text white`
/// - [secondaryElevated] — `bg surfaceElevatedNormal / text white`
/// - [disabled] — `bg surface / border borderSubtle / text textTertiary`
enum BtnType {
  primaryFill,
  primaryOutline,
  primaryOutlineWhite,
  secondaryFill,
  secondaryOutline,
  secondaryWhite,

  /// Like [secondaryFill] but a shade lighter — `Background/Elevated/Normal`
  /// (#2F3340) instead of `surface2` (#252932).
  ///
  /// The 연습하기 button inside `Card-Bookmark` (`176:15497`, in both the
  /// analysis and archive instances) is filled this way. It sits on the card's
  /// own #1F222A, where `secondaryFill` would be only one step lighter than the
  /// card and read as flat.
  secondaryElevated,
  disabled,
}

/// Height token of a [Button] (the Figma `size=*` variant).
///
/// Drives padding, corner radius, label typography and icon box — all measured
/// from the Figma component set. See [_Spec] for the exact per-size values.
enum BtnSize { s60, s48, s44, s36, s32, s28, s24 }

/// Internal per-(size) layout spec, measured from Figma `45:45158`.
///
/// `radius` here is the dominant value for the size; a few `(type, size)` cells
/// deviate (e.g. `disabled` keeps r8 at small sizes, `secondary_fill` uses r4 at
/// 32/24) — those are resolved in [_radius]. `r6` has no [AppRadius] token, so a
/// raw `6.0` is used (consider adding `AppRadius.xxs = 6` to the token set).
class _Spec {
  const _Spec({
    required this.padV,
    required this.padH,
    required this.radius,
    required this.icon,
  });

  final double padV;
  final double padH;
  final double radius;
  final double icon;
}

/// A text button (optionally with leading/trailing icons), implementing the
/// BeaverTalk Figma `Button` component set (`45:45158`) 1:1.
///
/// 7 [BtnType] styles × 7 [BtnSize] heights, all colors/typography/radii pulled
/// from design tokens ([AppColorTokens] / [AppType] / [AppRadius]).
///
/// The button renders disabled (non-interactive, no ripple) when [disabled] is
/// `true` **or** when [type] is [BtnType.disabled]. A disabled button keeps its
/// `disabled` visual palette regardless of the requested [type].
///
/// ```dart
/// Button(
///   type: BtnType.primaryFill,
///   size: BtnSize.s48,
///   text: '회화 학습',
///   onPressed: () {},
/// )
/// ```
class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.type,
    this.size = BtnSize.s48,
    this.leftIcon,
    this.rightIcon,
    required this.text,
    this.onPressed,
    this.disabled = false,
  });

  /// Visual style; see [BtnType].
  final BtnType type;

  /// Height token; see [BtnSize]. Defaults to [BtnSize.s48].
  final BtnSize size;

  /// Optional leading icon, sized to the size's icon box ([_Spec.icon]).
  final Widget? leftIcon;

  /// Optional trailing icon, sized to the size's icon box ([_Spec.icon]).
  final Widget? rightIcon;

  /// Button label.
  final String text;

  /// Tap callback. Ignored when the button is disabled.
  final VoidCallback? onPressed;

  /// Forces the disabled palette and disables interaction.
  final bool disabled;

  /// Whether the button is non-interactive (explicit flag or `disabled` type).
  bool get _isDisabled => disabled || type == BtnType.disabled;

  /// Effective visual style — collapses to [BtnType.disabled] when inactive.
  BtnType get _effectiveType => _isDisabled ? BtnType.disabled : type;

  // ── Per-size layout (padding / dominant radius / text / icon) ──────────────
  // Measured from Figma 45:45158 (depth-2 node read).
  static const Map<BtnSize, _Spec> _specs = {
    BtnSize.s60: _Spec(padV: 18, padH: 16, radius: AppRadius.md, icon: 24), // 16
    BtnSize.s48: _Spec(padV: 14, padH: 16, radius: AppRadius.sm, icon: 20), // 12
    BtnSize.s44: _Spec(padV: 12, padH: 16, radius: AppRadius.sm, icon: 20), // 12
    BtnSize.s36: _Spec(padV: 9, padH: 12, radius: AppRadius.xs, icon: 16), // 8
    BtnSize.s32: _Spec(padV: 7, padH: 12, radius: 6, icon: 16), // r6 — no token
    BtnSize.s28: _Spec(padV: 6, padH: 8, radius: 6, icon: 16),
    BtnSize.s24: _Spec(padV: 4, padH: 8, radius: 6, icon: 16),
  };

  /// Resolved label [TextStyle] for the current `(size, effectiveType)`.
  ///
  /// Weight follows Figma: most sizes use SemiBold; size 32 uses Regular for
  /// `label2`; size 28 mixes Medium (primary_outline_white / secondary_fill /
  /// secondary_white) with SemiBold (the rest); size 24 uses Regular `caption1`.
  TextStyle _textStyle() {
    final t = _effectiveType;
    switch (size) {
      case BtnSize.s60:
        return AppType.body1.sb; // MO/Body 1/Normal - Bold
      case BtnSize.s48:
      case BtnSize.s44:
        return AppType.label1.sb; // MO/Label 1/Normal - Bold
      case BtnSize.s36:
        return AppType.label2.sb; // MO/Label 2/Bold
      case BtnSize.s32:
        return AppType.label2.r; // MO/Label 2/Regular
      case BtnSize.s28:
        // Medium for the three "soft" variants, SemiBold otherwise.
        final medium = t == BtnType.primaryOutlineWhite ||
            t == BtnType.secondaryFill ||
            t == BtnType.secondaryWhite;
        return medium ? AppType.caption1.m : AppType.caption1.sb;
      case BtnSize.s24:
        return AppType.caption1.r; // MO/Caption 1/Regular
    }
  }

  /// Corner radius for the current `(size, effectiveType)`.
  ///
  /// Resolves the per-cell deviations measured in Figma where a few variants
  /// diverge from the size's dominant radius.
  double _radius() {
    final t = _effectiveType;
    final base = _specs[size]!.radius;
    switch (size) {
      case BtnSize.s32:
        // primary_* = 6 (base); secondary_fill = 4; outline/disabled = 8.
        if (t == BtnType.secondaryFill) return 4;
        if (t == BtnType.secondaryOutline || t == BtnType.disabled) {
          return AppRadius.xs; // 8
        }
        return base; // 6
      case BtnSize.s28:
        if (t == BtnType.disabled) return AppRadius.xs; // 8
        return base; // 6
      case BtnSize.s24:
        if (t == BtnType.secondaryFill) return 4;
        if (t == BtnType.disabled) return AppRadius.xs; // 8
        return base; // 6
      default:
        return base;
    }
  }

  /// Fill color for the current effective type.
  Color _fill(AppColorTokens c) {
    switch (_effectiveType) {
      case BtnType.primaryFill:
        return c.primaryNormal;
      case BtnType.primaryOutline:
      case BtnType.primaryOutlineWhite:
      case BtnType.disabled:
        return c.backgroundNormalNormal;
      case BtnType.secondaryFill:
      case BtnType.secondaryOutline:
        return c.backgroundNormalAlternative;
      case BtnType.secondaryWhite:
        return c.backgroundElevatedAlternative;
      case BtnType.secondaryElevated:
        return c.backgroundElevatedNormal;
    }
  }

  /// Border color for the current effective type, or `null` for no stroke.
  Color? _border(AppColorTokens c) {
    switch (_effectiveType) {
      case BtnType.primaryFill:
        return c.primaryNormal;
      case BtnType.primaryOutline:
      case BtnType.primaryOutlineWhite:
        return c.primaryNormal;
      case BtnType.secondaryFill:
      case BtnType.secondaryElevated:
        return null; // no stroke in Figma
      case BtnType.secondaryOutline:
        return c.backgroundNormalAlternative;
      case BtnType.secondaryWhite:
        return c.backgroundNormalAlternative;
      case BtnType.disabled:
        return c.lineAlternative;
    }
  }

  /// Label/icon foreground color for the current effective type.
  Color _foreground(AppColorTokens c) {
    switch (_effectiveType) {
      case BtnType.primaryFill:
        return c.primaryOnPrimary; // black
      case BtnType.primaryOutline:
        return c.primaryNormal;
      case BtnType.primaryOutlineWhite:
        return c.labelStrong; // white
      case BtnType.secondaryFill:
      case BtnType.secondaryElevated:
        return c.labelStrong; // white
      case BtnType.secondaryOutline:
        return c.labelNormal;
      case BtnType.secondaryWhite:
        return c.labelStrong; // white
      case BtnType.disabled:
        return c.labelDisabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spec = _specs[size]!;
    // The palette helpers below take the token set rather than reading a
    // static: they are plain methods with no context of their own.
    final c = context.c;
    final fg = _foreground(c);
    final border = _border(c);
    final radius = BorderRadius.circular(_radius());

    final children = <Widget>[];
    if (leftIcon != null) {
      children.add(_sizedIcon(leftIcon!, spec.icon, fg));
    }
    children.add(
      Flexible(
        child: Text(
          text,
          style: _textStyle().copyWith(color: fg),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
    if (rightIcon != null) {
      children.add(_sizedIcon(rightIcon!, spec.icon, fg));
    }

    final content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: spec.padV,
        horizontal: spec.padH,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _withGap(children, 4), // Figma gap = 4
      ),
    );

    return Material(
      color: _fill(c),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: border == null
            ? BorderSide.none
            : BorderSide(color: border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // The ripple is visual only — it gives no physical confirmation. Every
        // CTA in the app routes through this widget, so the tick is added once
        // here instead of at 38 call sites. Disabled buttons stay silent.
        onTap: _isDisabled || onPressed == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onPressed!();
              },
        borderRadius: radius,
        child: content,
      ),
    );
  }

  /// Constrains [child] to a square icon box and tints it via [IconTheme].
  static Widget _sizedIcon(Widget child, double box, Color color) {
    return SizedBox(
      width: box,
      height: box,
      child: IconTheme.merge(
        data: IconThemeData(color: color, size: box),
        child: child,
      ),
    );
  }

  /// Inserts a [gap]-wide [SizedBox] between each child.
  static List<Widget> _withGap(List<Widget> items, double gap) {
    if (items.length < 2) return items;
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) out.add(SizedBox(width: gap));
      out.add(items[i]);
    }
    return out;
  }
}

/// Gallery demo for [Button]: every [BtnType] across representative [BtnSize]s,
/// plus icon and disabled showcases. Registration into the gallery registry is
/// handled separately — do not wire it here.
class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});

  static const _types = <(String, BtnType)>[
    ('primary_fill', BtnType.primaryFill),
    ('primary_outline', BtnType.primaryOutline),
    ('primary_outline_white', BtnType.primaryOutlineWhite),
    ('secondary_fill', BtnType.secondaryFill),
    ('secondary_outline', BtnType.secondaryOutline),
    ('secondary_white', BtnType.secondaryWhite),
    ('disabled', BtnType.disabled),
  ];

  static const _sizes = <(String, BtnSize)>[
    ('60', BtnSize.s60),
    ('48', BtnSize.s48),
    ('36', BtnSize.s36),
    ('28', BtnSize.s28),
    ('24', BtnSize.s24),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // type × representative-size matrix
            for (final (typeLabel, type) in _types) ...[
              Text(
                typeLabel,
                style: AppType.label2.sb.copyWith(color: context.c.labelNormal),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final (sizeLabel, size) in _sizes)
                    Button(
                      type: type,
                      size: size,
                      text: '회화 학습 $sizeLabel',
                    ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            // icon showcase
            Text(
              'with icons',
              style: AppType.label2.sb.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s48,
                  text: '왼쪽 아이콘',
                  leftIcon: const Icon(Icons.bolt),
                  onPressed: () {},
                ),
                Button(
                  type: BtnType.primaryOutline,
                  size: BtnSize.s48,
                  text: '오른쪽 아이콘',
                  rightIcon: AppIcons.arrowRight(color: context.c.labelStrong),
                  onPressed: () {},
                ),
                Button(
                  type: BtnType.secondaryWhite,
                  size: BtnSize.s36,
                  text: '양쪽',
                  leftIcon: const Icon(Icons.star),
                  rightIcon: AppIcons.chevronRight(color: context.c.labelStrong),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            // disabled showcase (via flag, not type)
            Text(
              'disabled flag (any type → disabled palette)',
              style: AppType.label2.sb.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s48,
                  text: '비활성',
                  disabled: true,
                  onPressed: () {},
                ),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s48,
                  text: '비활성',
                  disabled: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}