import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../icons/app_icons.dart';
import 'bottom_sheet.dart' show SheetAction;

/// Which management action a [SubscriptionActionSheet] presents — the three
/// `BottomSheet-Subscription` variants the redesign added (spec §3-2, measured
/// off `4648:27262` / `4649:27076` / `4652:27523`).
///
/// The legacy `BottomSheetSubscription` organism kept the pre-redesign
/// manage/change-plan/cancel sheets (Korean copy, old node structure; deleted
/// with the P4 cleanup). These
/// three are structurally different — a centred note plus one framed block —
/// so they live in their own organism rather than being grafted onto the old
/// one. That is a deliberate departure from work order §3-3's "extend the
/// enum" wording: the old variants share nothing with these but a name.
enum SubscriptionActionVariant {
  /// `cancel` — the red what-you-lose framing before handing off to the store.
  cancel,

  /// `payment-update` — the three-step payment recovery walkthrough.
  paymentUpdate,

  /// `resubscribe` — the green what-you-keep framing of un-cancelling.
  resubscribe,
}

/// A row inside the framed block.
class SubscriptionActionRow {
  /// Creates a row.
  const SubscriptionActionRow(this.label);

  /// Row copy, from l10n.
  final String label;
}

/// The subscription action sheet — GNB (title + close) → centred note →
/// framed block (accent title + marked rows) → CTA pair.
///
/// Colour rule per variant: cancel frames in red with X marks, resubscribe in
/// green (`Status/Positive-4` face) with checks, payment-update in neutral
/// with chevrons. Block titles use the `*/Foreground` text tokens — the
/// measured cancel title carries `Status/Negative`, but §1-2 forbids status
/// colours as text (Light contrast), so `Accent/Foreground/Red` stands in,
/// identical in spirit and near-identical in Dark.
class SubscriptionActionSheet extends StatelessWidget {
  /// Creates an action sheet.
  const SubscriptionActionSheet({
    super.key,
    required this.variant,
    required this.title,
    required this.body,
    required this.blockTitle,
    required this.rows,
    required this.primaryAction,
    this.secondaryAction,
    this.onClose,
  });

  /// Which action; drives the block's colours and marks.
  final SubscriptionActionVariant variant;

  /// GNB title.
  final String title;

  /// Centred note under the GNB. Dates inside are server values.
  final String body;

  /// Framed block heading (`What you lose` / `How to fix it` / …).
  final String blockTitle;

  /// Block rows.
  final List<SubscriptionActionRow> rows;

  /// Main CTA.
  final SheetAction primaryAction;

  /// Quiet CTA. Only dismisses — closing never changes state (spec §7-2).
  final SheetAction? secondaryAction;

  /// The GNB close (X). Same contract as every dismissal.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (Color frame, Color? face, Color heading, Widget Function() mark) =
        switch (variant) {
      SubscriptionActionVariant.cancel => (
          c.statusNegative,
          null,
          c.accentForegroundRed,
          () => AppIcons.close(size: 20, color: c.accentForegroundRed),
        ),
      SubscriptionActionVariant.paymentUpdate => (
          c.labelNormal,
          null,
          c.labelStrong,
          () => AppIcons.chevronRight(size: 20, color: c.labelNormal),
        ),
      SubscriptionActionVariant.resubscribe => (
          c.statusPositive,
          c.statusPositive4,
          c.accentForegroundGreen,
          () => AppIcons.check(size: 20, color: c.accentForegroundGreen),
        ),
    };

    return Container(
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // GNB: balanced 28px slots, real close on the right (measured).
          ContentColumn(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                const SizedBox(width: 28),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppType.body1.sb
                        .copyWith(color: c.commonWhiteAndDark),
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child:
                      AppIcons.close(size: 28, color: c.commonWhiteAndDark),
                ),
              ],
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s16, bottom: AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style:
                      AppType.label1.r.copyWith(color: c.commonWhiteAndDark),
                ),
                const SizedBox(height: AppSpacing.s8),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  decoration: BoxDecoration(
                    color: face,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: frame),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(blockTitle,
                          style:
                              AppType.label1.sb.copyWith(color: heading)),
                      for (final row in rows) ...[
                        const SizedBox(height: AppSpacing.s8),
                        Row(
                          children: [
                            mark(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                row.label,
                                style: AppType.label1.r
                                    .copyWith(color: c.commonWhiteAndDark),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: 0),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: primaryAction.label,
                onPressed: primaryAction.onPressed,
              ),
            ),
          ),
          if (secondaryAction != null)
            ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: 0),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: secondaryAction!.label,
                  onPressed: secondaryAction!.onPressed,
                ),
              ),
            ),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
