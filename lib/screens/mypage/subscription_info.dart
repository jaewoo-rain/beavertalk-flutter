import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/bottom_sheet_subscription.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

/// Subscription management — Figma `screen/main_mypage_payment` (`2117:20206`).
/// Surfaces the [BottomSheetSubscription] (manage) with the user's current plan.
class SubscriptionInfoScreen extends StatelessWidget {
  /// Creates the subscription info screen.
  const SubscriptionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: AppColors.surface,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: BottomSheetSubscription(
          type: SubscriptionSheetType.manage,
          plan: SubscriptionPlanInfo(
            name: l10n.proMembership,
            priceLine: l10n.pricePerMonth,
            nextBillingDate: '2026.07.01.',
          ),
          benefits: [
            SubscriptionBenefit(l10n.benefitUnlimitedCalls),
            SubscriptionBenefit(l10n.benefitDetailedAnalysis),
            SubscriptionBenefit(l10n.benefitAllCharacters),
            SubscriptionBenefit(l10n.benefitNoAds),
          ],
          onPrimary: () => Navigator.pop(context),
          onSecondary: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
