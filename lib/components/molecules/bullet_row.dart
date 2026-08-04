import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// Dot colour of a [BulletRow] — the Figma `tone=*` variant.
///
/// Measured off `Bullet-Row` (`4204:577`) with `get_variable_defs`:
/// grey `Label/Neutral`, mint `Primary/Normal`, gold `Status/Cautionary`.
enum BulletTone {
  /// Grey dot — the Free column of a plan card.
  free,

  /// Mint dot — Pro benefits.
  pro,

  /// Gold dot — Max benefits.
  max,
}

/// One dotted benefit line inside a plan card — Figma `Bullet-Row`
/// (`4204:577`).
///
/// A 4px dot in a 4×16 slot, 8px gap, Caption 1 Regular text in
/// `Common/White & Dark`. Height hugs the label (wrapping grows the row).
class BulletRow extends StatelessWidget {
  /// Creates a bullet row.
  const BulletRow({super.key, this.tone = BulletTone.free, required this.label});

  /// Dot colour; see [BulletTone].
  final BulletTone tone;

  /// Line copy, from l10n at the call site.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final dot = switch (tone) {
      BulletTone.free => c.labelNeutral,
      BulletTone.pro => c.primaryNormal,
      BulletTone.max => c.statusCautionary,
    };
    return Row(
      children: [
        SizedBox(
          width: 4,
          height: 16,
          child: Center(
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppType.caption1.r.copyWith(color: c.commonWhiteAndDark),
          ),
        ),
      ],
    );
  }
}
