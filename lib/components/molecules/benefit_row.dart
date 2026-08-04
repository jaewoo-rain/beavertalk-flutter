import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// Which plan a [BenefitRow]'s check speaks for — mint for Pro, gold for Max.
enum BenefitTier {
  /// Mint check (`Primary/Normal`).
  pro,

  /// Gold check (`Status/Cautionary`).
  max,
}

/// One benefit line with a leading check — Figma `Benefit-Row` (`4204:563`).
///
/// 20px check, 12px gap, Label 1 Regular text in `Common/White & Dark`. Height
/// hugs the label — the Figma component notes that fixing it clips wrapped
/// labels, so nothing here constrains the vertical axis.
class BenefitRow extends StatelessWidget {
  /// Creates a benefit row.
  const BenefitRow({super.key, this.tier = BenefitTier.pro, required this.label});

  /// Check colour; see [BenefitTier].
  final BenefitTier tier;

  /// Benefit copy, from l10n at the call site.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final check = tier == BenefitTier.max ? c.statusCautionary : c.primaryNormal;
    return Row(
      children: [
        AppIcons.check(size: 20, color: check),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppType.label1.r.copyWith(color: c.commonWhiteAndDark),
          ),
        ),
      ],
    );
  }
}
