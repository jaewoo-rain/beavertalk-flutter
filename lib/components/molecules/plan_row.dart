import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// Accent family of a [PlanRow] — mint for Free/Pro contexts, gold for Max
/// (spec §14: Max 맥락의 선택 표시는 골드).
enum PlanRowTier {
  /// Mint selection (`Primary/Normal`).
  pro,

  /// Gold selection (`Status/Cautionary`).
  max,
}

/// A paywall plan option row — Figma `Plan-Row` (`4206:588`).
///
/// Min 76px tall, 24/16 padding, radius 12. Selected rows get a 1.5px accent
/// border on an accent-10 face; unselected rows sit flat on
/// `Background/Surface/Alternative`. A 22px radio hangs on the right.
///
/// Tapping **only changes selection** — spec §14 is explicit that plan rows
/// never navigate. The paywall screen owns which row is selected; this widget
/// just reports the tap.
class PlanRow extends StatelessWidget {
  /// Creates a plan row.
  const PlanRow({
    super.key,
    this.tier = PlanRowTier.pro,
    required this.selected,
    required this.title,
    required this.price,
    this.priceOriginal,
    this.onTap,
  });

  /// Accent family; see [PlanRowTier].
  final PlanRowTier tier;

  /// Whether this row is the chosen one.
  final bool selected;

  /// Row title (e.g. `Monthly`), from l10n.
  final String title;

  /// Price line (e.g. `$100.00 · $8.33 per month`).
  final String price;

  /// Struck-through anchor price rendered before [price] (e.g. `$154.80`).
  ///
  /// Same `Label/Normal` colour as the live price — work order §6-4: the
  /// strikethrough does the distinguishing, dimming it breaks contrast.
  final String? priceOriginal;

  /// Selection callback. Null renders the row inert.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final accent =
        tier == PlanRowTier.max ? c.statusCautionary : c.primaryNormal;
    final face = tier == PlanRowTier.max
        ? c.statusCautionarySurface
        : c.primaryNormal10;

    final priceStyle = AppType.label1.r.copyWith(color: c.labelNormal);
    final struck = priceOriginal;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 76),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 22.5 : 24,
          vertical: selected ? 14.5 : 16,
        ),
        decoration: BoxDecoration(
          color: selected ? face : c.backgroundSurfaceAlternative,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: accent, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppType.body2.sb.copyWith(color: c.labelStrong),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        if (struck != null) ...[
                          TextSpan(
                            text: struck,
                            style: priceStyle.copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: c.labelNormal,
                            ),
                          ),
                          const TextSpan(text: ' '),
                        ],
                        TextSpan(text: price),
                      ],
                    ),
                    style: priceStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _Radio(selected: selected, accent: accent, tier: tier),
          ],
        ),
      ),
    );
  }
}

/// The 22px selection mark: an accent-filled disc with a check when selected,
/// a `Line/Normal` ring when not.
class _Radio extends StatelessWidget {
  const _Radio({
    required this.selected,
    required this.accent,
    required this.tier,
  });

  final bool selected;
  final Color accent;
  final PlanRowTier tier;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    if (!selected) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c.lineNormal, width: 1.5),
        ),
      );
    }
    // Check colour: On-Primary flips with the theme so the mint disc keeps its
    // mark visible in Light (#007A55 fill → white check); gold stays a
    // Static/Black mark on both modes, like every label on a gold face.
    final mark = tier == PlanRowTier.max ? c.staticBlack : c.primaryOnPrimary;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
      child: Center(child: AppIcons.check(size: 16, color: mark)),
    );
  }
}
