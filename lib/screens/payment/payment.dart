import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_box.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
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
  /// 신용/체크카드.
  card('신용/체크카드'),

  /// 카카오페이.
  kakao('카카오페이'),

  /// Apple Pay.
  apple('Apple Pay');

  const _PayMethod(this.label);

  /// Display label (Figma copy).
  final String label;
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PayMethod _method = _PayMethod.card;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: '결제하기',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── 주문 상품 ──
                  Text('주문 상품', style: AppType.body2.sb),
                  const SizedBox(height: 16),
                  _ProductCard(),
                  const SizedBox(height: 16),
                  // ── 결제 수단 ──
                  Text('결제 수단', style: AppType.body2.sb),
                  const SizedBox(height: 16),
                  for (final m in _PayMethod.values) ...[
                    _MethodRow(
                      label: m.label,
                      selected: _method == m,
                      onTap: () => setState(() => _method = m),
                    ),
                    if (m != _PayMethod.values.last)
                      const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 16),
                  // ── 결제 금액 요약 ──
                  _AmountSummary(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: '결제하기',
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
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
                Text('Annoying Beaver 아바타', style: AppType.body2.sb),
                const SizedBox(height: 4),
                Text(
                  '프리미엄 캐릭터 · 영구 소장',
                  style: AppType.label2.r
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '₩4,900',
            style: AppType.body2.sb.copyWith(color: AppColors.primary),
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: selected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            _RadioMark(selected: selected),
            const SizedBox(width: 12),
            Text(label, style: AppType.body2.r),
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
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.transparent,
        border: selected
            ? null
            : Border.all(color: AppColors.lineStrong, width: 1.5),
      ),
      child: selected
          ? AppIcons.check(size: 14, color: AppColors.onPrimary)
          : null,
    );
  }
}

/// The "amount-summary" card (Figma `amount-summary`): two secondary rows
/// (상품 금액 / 할인) and a bold "총 결제 금액" row with the total in `primary`.
class _AmountSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _row('상품 금액', '₩4,900'),
          const SizedBox(height: 8),
          _row('할인', '-₩0'),
          const SizedBox(height: 8),
          _row('총 결제 금액', '₩4,900', total: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool total = false}) {
    final labelStyle = total
        ? AppType.body1.sb
        : AppType.label1.r.copyWith(color: AppColors.textSecondary);
    final valueStyle = total
        ? AppType.body1.sb.copyWith(color: AppColors.primary)
        : AppType.label1.sb;
    return Row(
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        Text(value, style: valueStyle),
      ],
    );
  }
}
