import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/pressable.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_box.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Payment checkout — Figma `screen/main_payment_checkout` (`2117:20419`).
///
/// A `main` GNB ("결제하기") over a scrollable body: an "주문 상품" section
/// (a [CardBox]-style product card), a "결제 수단" radio list of payment methods
/// (a selected method gains a 1.5px `primary` border + checked checkbox), and an
/// "총 결제 금액" amount summary. A pinned full-width "결제하기" primary button
/// routes to [Routes.paymentComplete].
class PaymentScreen extends StatefulWidget {
  /// Creates the payment checkout screen.
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

/// The selectable payment methods shown on the checkout screen.
enum _PayMethod {
  /// Credit / debit card.
  card,

  /// KakaoPay.
  kakao,

  /// Apple Pay.
  apple;

  /// Display label for this method under the given localizations.
  String label(AppLocalizations l10n) {
    switch (this) {
      case _PayMethod.card:
        return l10n.payMethodCard;
      case _PayMethod.kakao:
        return l10n.payMethodKakao;
      case _PayMethod.apple:
        return l10n.payMethodApple;
    }
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PayMethod _method = _PayMethod.card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.checkout,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s20,
                AppSpacing.s20,
                AppSpacing.s20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Order summary ──
                  Text(l10n.orderSummary, style: AppType.body2.sb),
                  const SizedBox(height: AppSpacing.s16),
                  _ProductCard(),
                  const SizedBox(height: AppSpacing.s16),
                  // ── Payment method ──
                  Text(l10n.paymentMethod, style: AppType.body2.sb),
                  const SizedBox(height: AppSpacing.s16),
                  for (final m in _PayMethod.values) ...[
                    _MethodRow(
                      label: m.label(l10n),
                      selected: _method == m,
                      onTap: () => setState(() => _method = m),
                    ),
                    // 16, not 12 — v3's Body is a single column with a uniform
                    // 16 gap between every child, so the method rows sit on the
                    // same rhythm as the section labels and cards around them.
                    if (m != _PayMethod.values.last)
                      const SizedBox(height: AppSpacing.s16),
                  ],
                  const SizedBox(height: AppSpacing.s16),
                  // ── Amount summary ──
                  _AmountSummary(),
                ],
              ),
            ),
          ),
          Padding(
            // v3 `BottomSheet`: pt 12 / px 20 / pb 0 — the space below the CTA
            // is the home-indicator inset, which AppScaffold's SafeArea already
            // supplies. The old 24 stacked on top of it and pushed the button up.
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s12,
              AppSpacing.s20,
              0,
            ),
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: l10n.pay,
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.paymentComplete),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "주문 상품" card (Figma `product-card`): title + trait line on the left,
/// price in `primary` on the right. Fill `surfaceElevated`, radius 16.
class _ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.productName, style: AppType.body2.sb),
                const SizedBox(height: 4),
                Text(
                  l10n.productTrait,
                  style: AppType.label2.r
                      .copyWith(color: context.c.labelNormal),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '₩4,900',
            style: AppType.body2.sb.copyWith(color: context.c.primaryNormal),
          ),
        ],
      ),
    );
  }
}

/// A single payment-method radio row (Figma `method/*`). A checkbox-style
/// indicator on the left + label; when [selected] the row gains a 1.5px
/// `primary` border and a checked indicator. Fill `surfaceElevated`, radius 12.
class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      // Selection is signalled by the border only — per Figma the fill stays
      // `surfaceElevated` in both states. The border used to snap on; it now
      // cross-fades, and Pressable adds the press scale + haptic (this is a
      // money screen, so confirming the tap landed matters).
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.toggle,
        // Figma `method/*`: min-height 56 — keeps rows a consistent height
        // regardless of label wrapping.
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            // Painted in both states so the colour animates instead of a
            // null→Border pop shifting the row by 1.5px.
            color: selected ? context.c.primaryNormal : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _RadioMark(selected: selected),
            // Figma `Checkbox`: the mark/label gap is 8 — the row's own 12 gap
            // applies outside the checkbox group, not between its parts.
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: Text(
                label,
                style: AppType.body2.r,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A 22×22 checkbox-style indicator mirroring the Figma Checkbox
/// (size=22, style=circle): a `primary` filled disc with a check when selected,
/// otherwise a bordered empty circle.
class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.toggle,
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Figma: unselected is a `surface2` disc with a `textSecondary` hairline,
        // not a transparent hole — the mark reads as a filled control in both
        // states and only the colours swap.
        color: selected ? context.c.primaryNormal : context.c.backgroundNormalAlternative,
        border: Border.all(
          color: selected ? context.c.primaryNormal : context.c.labelNormal,
          width: 1,
        ),
      ),
      // The check is present in BOTH states per Figma (muted when unselected,
      // dark-on-green when selected) — it does not appear on selection, it
      // recolours. Previously the unselected row had no glyph at all.
      //
      // Cross-faded rather than swapped: the disc colour animates, so a hard
      // glyph swap would flash a dark check against the not-yet-green disc.
      // AppIcons.check takes no key, so the switcher is keyed via KeyedSubtree.
      child: AnimatedSwitcher(
        duration: AppMotion.fast,
        child: KeyedSubtree(
          key: ValueKey<bool>(selected),
          child: AppIcons.check(
            size: 14,
            color: selected ? context.c.primaryOnPrimary : context.c.labelNormal,
          ),
        ),
      ),
    );
  }
}

/// The "amount-summary" card (Figma `amount-summary`): two secondary rows
/// (상품 금액 / 할인) and a bold "총 결제 금액" row with the total in `primary`.
class _AmountSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(context, l10n.amountItemPrice, '₩4,900'),
          const SizedBox(height: 8),
          _row(context, l10n.amountDiscount, '-₩0'),
          const SizedBox(height: 8),
          _row(context, l10n.amountTotal, '₩4,900', total: true),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool total = false}) {
    final labelStyle = total
        ? AppType.body1.sb
        : AppType.label1.r.copyWith(color: context.c.labelNormal);
    final valueStyle = total
        ? AppType.body1.sb.copyWith(color: context.c.primaryNormal)
        : AppType.label1.sb;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}
