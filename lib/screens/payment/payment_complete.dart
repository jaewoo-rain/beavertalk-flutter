import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Payment success — Figma `screen/main_payment_result__success`
/// (`2117:20454`).
///
/// A centered 100×100 3D success illustration (`assets/icons/3d/check_1.png`),
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
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _ResultIllustration(
                            asset: 'assets/icons/3d/check_1.png',
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.paymentCompleteTitle,
                            textAlign: TextAlign.center,
                            style: AppType.heading2.sb,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.paymentCompleteBody,
                            textAlign: TextAlign.center,
                            style: AppType.label1.r
                                .copyWith(color: context.c.labelNormal),
                          ),
                          const SizedBox(height: 24),
                          const _Receipt(),
                        ],
                      ),
                    ),
                  ),
                ),
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
                    text: l10n.goHome,
                    onPressed: () => _goHome(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.viewCollection,
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
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ReceiptRow(label: l10n.receiptItem, value: l10n.productName),
          const SizedBox(height: 10),
          _ReceiptRow(label: l10n.receiptAmount, value: '₩4,900'),
          const SizedBox(height: 10),
          _ReceiptRow(label: l10n.receiptMethod, value: l10n.payMethodCard),
          const SizedBox(height: 10),
          _ReceiptRow(label: l10n.receiptDate, value: '2026.06.18 14:32'),
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
    // Label left / value right (spaceBetween pins both to the edges). Both are
    // Flexible + ellipsis so a long localized value stays flush-right and shrinks
    // instead of overflowing — value never detaches to mid-row (spaceBetween),
    // and never overflows (Flexible).
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppType.label2.m.copyWith(color: context.c.labelNormal),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: AppType.label2.m,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// The 100×100 result illustration (Figma `3D/location`, `281:20343`). Per v3
/// the 3D object stands alone on the screen background — it has no tile behind
/// it, so the asset is rendered bare at its designed 100×100 box.
class _ResultIllustration extends StatelessWidget {
  const _ResultIllustration({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(asset, width: 100, height: 100, fit: BoxFit.contain),
    );
  }
}
