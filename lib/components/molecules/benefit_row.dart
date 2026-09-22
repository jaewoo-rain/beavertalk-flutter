import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// Which plan a [BenefitRow]'s check speaks for — mint (Free·legacy Pro) or
/// orange (Premium).
enum BenefitTier {
  /// Mint check (`Primary/Normal`).
  pro,

  /// Premium check — `Accent/Foreground/Orange`(Light `#9C5800` 5.51:1).
  ///
  /// `Status/Cautionary` 금색은 흰 면 위에서 1.69:1 로 사라진다(P17, 사용자
  /// 결정 2026-09-22). 금색은 면(배지·테두리)에만 쓰고 체크는 전경 토큰으로 그린다.
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
    final check = tier == BenefitTier.max ? c.accentForegroundOrange : c.primaryNormal;
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
