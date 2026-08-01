import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';

/// Payment failure — Figma `screen/main_payment_result__fail` (`2117:20478`).
///
/// A centered 100×100 3D failure illustration (`assets/icons/3d/error.png`),
/// a "결제에 실패했어요" heading + sub copy. The bottom is the Figma
/// `two-button-row`: a secondary "홈으로" (returns to [Routes.home]) and a
/// primary "다시 시도" (pops back to checkout to retry).
class PaymentFailedScreen extends StatelessWidget {
  /// Creates the payment-failed screen.
  const PaymentFailedScreen({super.key});

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
                        children: [
                          // Failure illustration (Figma `3D/location`,
                          // `281:20345`). Per v3 the 3D object stands alone on
                          // the screen background — no tile behind it — so the
                          // asset is rendered bare at its designed 100×100 box.
                          Image.asset(
                            'assets/icons/3d/error.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.paymentFailedTitle,
                            textAlign: TextAlign.center,
                            style: AppType.heading2.sb,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.paymentFailedBody,
                            textAlign: TextAlign.center,
                            style: AppType.label1.r
                                .copyWith(color: context.c.labelNormal),
                          ),
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
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    type: BtnType.primaryFill,
                    size: BtnSize.s60,
                    text: l10n.retry,
                    onPressed: () => Navigator.pop(context),
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
