import 'package:flutter/material.dart' hide Badge;

import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/badge.dart';
import '../atoms/button.dart';
import 'bullet_row.dart';

/// A plan summary card — the `card/pro` / `card/max` / `card/free` block
/// shared by `plans_compare` (`4514:5232…`) and the paywalls (`4608:9721`,
/// `4608:9771`).
///
/// Header (title · badge · price column) → tagline → bullet list → optional
/// CTA. 20/20 padding, radius 12, 16 gaps — measured. The paywalls use it
/// without a CTA (their CTA is the sticky bar); `plans_compare` puts one in
/// the card.
class PlanSummaryCard extends StatelessWidget {
  /// Creates a plan card.
  const PlanSummaryCard({
    super.key,
    required this.title,
    required this.price,
    this.anchorPrice,
    this.perMonthUnit,
    this.badgeTone,
    this.badgeLabel,
    required this.tagline,
    required this.taglineColor,
    required this.bulletTone,
    required this.bullets,
    required this.face,
    this.border,
    this.cta,
    this.ctaType,
    this.onCta,
  });

  final String title;
  final String price;

  /// Struck list price above [price]. Body colour + strikethrough (§6-4).
  final String? anchorPrice;

  /// The localized `per month` unit under the price, or null to omit it
  /// (the Free card shows a bare `$0.00`).
  final String? perMonthUnit;

  final BadgeTone? badgeTone;
  final String? badgeLabel;
  final String tagline;
  final Color taglineColor;
  final BulletTone bulletTone;
  final List<String> bullets;
  final Color face;
  final Color? border;
  final String? cta;
  final BtnType? ctaType;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    // Figma strokes overlap padding; Flutter's don't — compensate.
    final hasBorder = border != null;
    final pad = hasBorder ? 18.5 : 20.0;
    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: face,
        borderRadius: BorderRadius.circular(12),
        border: hasBorder ? Border.all(color: border!, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Flexible + ellipsis: at narrow widths the title +
                    // badge + price stack shared one line and ran the inner
                    // row off the right edge (the 320px sweep overflowed
                    // even in English). The badge keeps its full width; the
                    // title yields.
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppType.headline2.sb.copyWith(color: c.labelStrong),
                      ),
                    ),
                    if (badgeTone != null && badgeLabel != null) ...[
                      const SizedBox(width: 8),
                      // Flexible + scale-down: the pill is otherwise fixed
                      // width, and on a 320px viewport the wordier badge
                      // labels spill past the price column. At the design
                      // width (375) nothing scales.
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Badge(tone: badgeTone!, label: badgeLabel!),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (anchorPrice != null)
                    Text(
                      anchorPrice!,
                      style: AppType.caption1.r.copyWith(
                        color: c.labelNormal,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: c.labelNormal,
                      ),
                    ),
                  Text(
                    price,
                    style: AppType.headline2.sb.copyWith(color: c.labelStrong),
                  ),
                  if (perMonthUnit != null)
                    Text(
                      perMonthUnit!,
                      style: AppType.caption2.r.copyWith(color: c.labelNormal),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(tagline, style: AppType.label2.r.copyWith(color: taglineColor)),
          const SizedBox(height: AppSpacing.s16),
          for (var i = 0; i < bullets.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s8),
            BulletRow(tone: bulletTone, label: bullets[i]),
          ],
          if (cta != null) ...[
            const SizedBox(height: AppSpacing.s16),
            SizedBox(
              width: double.infinity,
              child: Button(
                type: ctaType ?? BtnType.primaryFill,
                size: BtnSize.s48,
                text: cta!,
                onPressed: onCta,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
