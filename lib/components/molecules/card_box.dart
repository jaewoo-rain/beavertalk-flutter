import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// The three layouts of [CardBox].
enum CardBoxType {
  /// A conversation record: avatar + title + subtitle + a date/duration meta
  /// row (Label 1 Regular, white, 4×4 white dot separators).
  record,

  /// A purchasable item: avatar + title (with a leading volume icon) + a
  /// trait meta row (Caption 1, 2×2 white dots) + price, plus a trailing
  /// action button.
  purchase,

  /// Like [purchase] but with a pink error-tinted fill (`error` @ 6%) and an
  /// `error` border. The price shows a struck-through original [price] plus a
  /// [discountPrice] in `error`.
  purchaseDiscount,
}

/// CardBox — an elevated content box measured 1:1 from Figma (`Card-Box`
/// set `176:15524`).
///
/// Measured spec (shared): `radius` 8 ([AppRadius.xs]), `10px` padding.
/// `record`/`purchase` use the [AppColors.surfaceElevated] fill;
/// `purchase-discount` uses an `error`-tinted fill (white-on-pink @ 6%) with a
/// 1px [AppColors.error] border. The avatar is a 64px circle.
///
/// * [CardBoxType.record] — avatar + a column of title (Label 1 SemiBold),
///   [subtitle] (Label 1 Regular), and a [meta] row (Label 1 Regular, white)
///   with 4×4 white dot separators.
/// * [CardBoxType.purchase] — avatar + a column of title (Label 1 SemiBold,
///   with a leading 16px volume icon), [meta] row (Caption 1 Regular, 2×2 white
///   dots), and [price] (Label 1 Regular, white). Trailing [action] button.
/// * [CardBoxType.purchaseDiscount] — as `purchase` with the discount styling;
///   [price] is struck-through `textSecondary`, [discountPrice] is `error` bold.
class CardBox extends StatelessWidget {
  /// Creates a card box of the given [type].
  const CardBox({
    super.key,
    required this.type,
    required this.title,
    this.avatar,
    this.subtitle,
    this.meta,
    this.price,
    this.discountPrice,
    this.action,
  });

  /// Which box layout to render.
  final CardBoxType type;

  /// The bold title text.
  final String title;

  /// Optional 64px circular avatar (e.g. an [Image] or [DecoratedBox]).
  ///
  /// When null a neutral placeholder circle is shown.
  final Widget? avatar;

  /// Secondary line under the title.
  ///
  /// For [CardBoxType.record] this is a single Label 1 Regular line; for the
  /// purchase variants it is rendered as a Caption 1 trait list.
  final String? subtitle;

  /// Meta segments shown in a dot-separated row.
  ///
  /// For [CardBoxType.record] these use 4×4 white dots; for the purchase
  /// variants the [subtitle] already carries the 2×2-dotted trait list, so
  /// `meta` is unused there.
  final List<String>? meta;

  /// Price text (the original price for the discount variant).
  final String? price;

  /// Discounted price, only used by [CardBoxType.purchaseDiscount].
  final String? discountPrice;

  /// Trailing action widget (typically a button) for the purchase variants.
  final Widget? action;

  bool get _isDiscount => type == CardBoxType.purchaseDiscount;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = _isDiscount
        ? BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.06),
            border: Border.all(color: AppColors.error),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          )
        : BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: type == CardBoxType.record
            ? _buildRecord()
            : _buildPurchase(),
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatar != null) {
      return ClipOval(
        child: SizedBox(width: 64, height: 64, child: avatar),
      );
    }
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildRecord() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppType.label1.sb.copyWith(color: AppColors.text),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppType.label1.r.copyWith(color: AppColors.text),
                ),
              ],
              if (meta != null && meta!.isNotEmpty) ...[
                const SizedBox(height: 4),
                _DottedRow(
                  segments: meta!,
                  style: AppType.label1.r.copyWith(color: AppColors.text),
                  dotSize: 4,
                  dotColor: AppColors.text,
                  gap: 4,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchase() {
    final traits = subtitle == null
        ? const <String>[]
        : subtitle!
            .split('·')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.volume_up_outlined,
                    size: 16,
                    color: AppColors.text,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style:
                          AppType.label1.sb.copyWith(color: AppColors.text),
                    ),
                  ),
                ],
              ),
              if (traits.isNotEmpty) ...[
                const SizedBox(height: 4),
                _DottedRow(
                  segments: traits,
                  style:
                      AppType.caption1.r.copyWith(color: AppColors.text),
                  dotSize: 2,
                  dotColor: AppColors.text,
                  gap: 3,
                ),
              ],
              const SizedBox(height: 4),
              _buildPriceRow(),
            ],
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 8),
          action!,
        ],
      ],
    );
  }

  Widget _buildPriceRow() {
    if (_isDiscount) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (price != null)
            Text(
              price!,
              style: AppType.label1.r.copyWith(
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.textSecondary,
              ),
            ),
          if (price != null && discountPrice != null)
            const SizedBox(width: 4),
          if (discountPrice != null)
            Text(
              discountPrice!,
              style: AppType.label1.sb.copyWith(color: AppColors.error),
            ),
        ],
      );
    }
    return Text(
      price ?? '',
      style: AppType.label1.r.copyWith(color: AppColors.text),
    );
  }
}

/// A dot-separated horizontal row of text [segments].
class _DottedRow extends StatelessWidget {
  const _DottedRow({
    required this.segments,
    required this.style,
    required this.dotSize,
    required this.dotColor,
    required this.gap,
  });

  final List<String> segments;
  final TextStyle style;
  final double dotSize;
  final Color dotColor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < segments.length; i++) {
      if (i > 0) {
        children.add(SizedBox(width: gap));
        children.add(
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
        children.add(SizedBox(width: gap));
      }
      children.add(Text(segments[i], style: style));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Gallery demo exposing every [CardBox] variant.
class CardBoxDemo extends StatelessWidget {
  /// Creates the CardBox gallery demo.
  const CardBoxDemo({super.key});

  Widget _button() => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedNormal,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Text(
            '구매',
            style: AppType.label2.sb.copyWith(color: AppColors.text),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CardBox(
              type: CardBoxType.record,
              title: 'Judi',
              subtitle: '강아지 산책과 음악 취향',
              meta: ['2026.01.01.', '10분 38초'],
            ),
            const SizedBox(height: 16),
            CardBox(
              type: CardBoxType.purchase,
              title: 'Judi',
              subtitle: 'Warm·Calm·Soft',
              price: '10\$',
              action: _button(),
            ),
            const SizedBox(height: 16),
            CardBox(
              type: CardBoxType.purchaseDiscount,
              title: 'Judi',
              subtitle: 'Warm·Calm·Soft',
              price: '10\$',
              discountPrice: '5\$',
              action: _button(),
            ),
          ],
        ),
      ),
    );
  }
}
