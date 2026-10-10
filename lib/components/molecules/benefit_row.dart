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
  const BenefitRow({
    super.key,
    this.tier = BenefitTier.pro,
    this.icon,
    required this.label,
  });

  /// Check colour; see [BenefitTier].
  final BenefitTier tier;

  /// Benefit copy, from l10n at the call site.
  final String label;

  /// 체크 대신 그릴 듀오톤 아이콘(Figma `Paywall/Benefit` `6198:1999`, 20). 주면 [tier] 는
  /// 쓰지 않는다.
  ///
  /// 아이콘은 **장식**이다 — 뜻은 라벨이 나른다. 그래서 Light 에서 초록·주황이 면 대비 3:1
  /// 아래(1.93·1.73)여도 결함이 아니다(WCAG 1.4.11 은 이해에 필요한 그래픽에만 걸림).
  /// ⚠ 라벨을 빼고 아이콘만 남기면 판정이 뒤집힌다 — 그때는 대비를 다시 재라.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final check = tier == BenefitTier.max ? c.accentForegroundOrange : c.primaryNormal;
    return Row(
      children: [
        if (icon != null)
          SizedBox.square(dimension: 20, child: icon)
        else
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
