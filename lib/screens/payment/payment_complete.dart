import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Payment success — Figma `screen/main_payment_result__success`
/// (`2117:20454`).
///
/// A centered success illustration (✅ stand-in for the Figma 3D asset — mock),
/// a "결제가 완료되었어요" heading + sub copy, and a receipt card listing the
/// 상품 / 결제 금액 / 결제 수단 / 결제 일시. The bottom is the Figma
/// `two-button-row`: a secondary "홈으로" and a primary "보관함 보기"; both
/// return to [Routes.home] in this mock.
class PaymentCompleteScreen extends StatelessWidget {
  /// Creates the payment-complete screen.
  const PaymentCompleteScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.home, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _ResultIllustration(emoji: '✅'),
                  const SizedBox(height: 24),
                  Text(
                    '결제가 완료되었어요',
                    textAlign: TextAlign.center,
                    style: AppType.heading2.sb,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '아바타가 보관함에 추가되었어요.',
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  const _Receipt(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    type: BtnType.secondaryOutline,
                    size: BtnSize.s60,
                    text: '홈으로',
                    onPressed: () => _goHome(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: '보관함 보기',
                    onPressed: () => _goHome(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The receipt card (Figma `receipt`): four label/value rows, fill
/// `surfaceElevated`, radius 16.
class _Receipt extends StatelessWidget {
  const _Receipt();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _ReceiptRow(label: '상품', value: 'Annoying Beaver 아바타'),
          SizedBox(height: 10),
          _ReceiptRow(label: '결제 금액', value: '₩4,900'),
          SizedBox(height: 10),
          _ReceiptRow(label: '결제 수단', value: '신용/체크카드'),
          SizedBox(height: 10),
          _ReceiptRow(label: '결제 일시', value: '2026.06.18 14:32'),
        ],
      ),
    );
  }
}

/// A single receipt row: secondary label on the left, white value on the right
/// (both `Label 2 Medium` per Figma).
class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppType.label2.m.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(value, style: AppType.label2.m),
      ],
    );
  }
}

/// A 100×100 result illustration tile — emoji stand-in for the Figma 3D asset
/// (mock; no asset bundled).
class _ResultIllustration extends StatelessWidget {
  const _ResultIllustration({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 56)),
      ),
    );
  }
}
