import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../components/organisms/bottom_sheet_subscription.dart';
import '../../theme/app_colors.dart';

/// Subscription management — Figma `screen/main_mypage_payment` (`2117:20206`).
/// Surfaces the [BottomSheetSubscription] (manage) with the user's current plan.
class SubscriptionInfoScreen extends StatelessWidget {
  /// Creates the subscription info screen.
  const SubscriptionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: BottomSheetSubscription(
          type: SubscriptionSheetType.manage,
          plan: const SubscriptionPlanInfo(
            name: 'Pro 멤버십',
            priceLine: '\$12.9 / 월',
            nextBillingDate: '2026.07.01.',
          ),
          benefits: const [
            SubscriptionBenefit('무제한 통화'),
            SubscriptionBenefit('상세 발음 및 문법 분석'),
            SubscriptionBenefit('모든 캐릭터 사용 가능'),
            SubscriptionBenefit('광고 제거'),
          ],
          onPrimary: () => Navigator.pop(context),
          onSecondary: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
