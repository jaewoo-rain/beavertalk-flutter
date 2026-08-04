import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// Face/label colour pairing of a [Badge] — the Figma `tone=*` variant
/// (`Badge` `4204:551`).
///
/// Every pair keeps the face-vs-text token split (work order §1-2): faces come
/// from `Status/*` / alpha tokens, text from `*/Foreground` or the label ramp.
enum BadgeTone {
  /// Grey pill — `Current` on the Free manage screen.
  neutral,

  /// Mint on a mint-14 face — `Renewing`.
  brand,

  /// Solid gold face, black label — the Max tier chip.
  gold,

  /// Gold-tinted face, orange label — `Trial`.
  goldSubtle,

  /// Green on a green-4 face — success states.
  positive,

  /// Red on a red-6 face — `Past due` / `Paused`.
  negative,
}

/// Status pill — Figma `Badge` (`4204:551`), measured 2026-08-03.
///
/// A min-26px-high pill, 10px side padding, Caption 1 SemiBold label. Purely
/// presentational: mapping a `SubscriptionBadge` domain value to a tone and an
/// l10n label is the screen's job, not this atom's.
class Badge extends StatelessWidget {
  /// Creates a badge.
  const Badge({super.key, required this.tone, required this.label});

  /// Colour pairing; see [BadgeTone].
  final BadgeTone tone;

  /// Pill text. Comes from l10n at the call site — never hardcoded copy.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (Color bg, Color fg) = switch (tone) {
      BadgeTone.neutral => (c.backgroundElevatedNormal, c.labelNormal),
      BadgeTone.brand => (c.primaryNormal14, c.primaryNormal),
      BadgeTone.gold => (c.statusCautionary, c.staticBlack),
      BadgeTone.goldSubtle =>
        (c.statusCautionarySurface, c.accentForegroundOrange),
      // The Figma variant paints this label `Status/Positive`. In Dark that is
      // the same value as `Accent/Foreground/Green`, but in Light it is a face
      // colour that fails contrast as text (1.82:1) — the exact trap work
      // order §1-2 calls out. Foreground token, deliberately.
      BadgeTone.positive => (c.statusPositive4, c.accentForegroundGreen),
      BadgeTone.negative => (c.statusNegative6, c.accentForegroundRed),
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: Text(label, style: AppType.caption1.sb.copyWith(color: fg)),
    );
  }
}
