import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/badge.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/bullet_row.dart';
import '../../components/molecules/plan_summary_card.dart';
import '../../components/organisms/gnb.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/subscription/domain/plan_prices.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Plan comparison — `depth/plans_compare` (`4514:5226`), measured 2026-08-03.
///
/// Three [PlanSummaryCard]s: Pro (mint border, `Go unlimited`), Max (gold
/// border, `Recommended`, struck anchor, `Turn on video`) and Free (flat, no
/// CTA — there is nothing to buy). The design shows the Free-member variant;
/// the only state-driven part is which card wears `Current` and drops its CTA.
class PlansCompareScreen extends ConsumerWidget {
  /// Creates the plan comparison screen.
  const PlansCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final tier = ref.watch(subscriptionStatusProvider).tier;
    // Kicks the store catalog query and rebuilds this subtree when it lands.
    // Child widgets read [PlanPrices] statically, so this one watch is what
    // turns list prices into the member's real storefront prices — and what
    // makes a console-side discount show up without an app release.
    ref.watch(storePricesProvider);

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: l10n.currentPlanTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s32),
              children: [
                PlanSummaryCard(
                  title: l10n.planPro,
                  price: PlanPrices.proMonthly,
                  perMonthUnit: l10n.perMonthUnit,
                  badgeTone:
                      tier == SubscriptionTier.pro ? BadgeTone.neutral : null,
                  badgeLabel:
                      tier == SubscriptionTier.pro ? l10n.badgeCurrent : null,
                  tagline: l10n.planTaglinePro,
                  taglineColor: c.primaryNormal,
                  bulletTone: BulletTone.pro,
                  bullets: [
                    l10n.bulletProCalls,
                    l10n.bulletProLength,
                    l10n.bulletProScoring,
                    l10n.bulletProCorrections,
                    l10n.bulletProBeaverCalls,
                  ],
                  face: c.primaryNormal10,
                  border: c.primaryNormal,
                  cta: tier == SubscriptionTier.pro ? null : l10n.ctaGoUnlimited,
                  ctaType: BtnType.primaryFill,
                  onCta: () => Navigator.pushNamed(context, Routes.paywallPro),
                ),
                const SizedBox(height: AppSpacing.s24),
                PlanSummaryCard(
                  title: l10n.planMax,
                  price: PlanPrices.maxMonthly,
                  anchorPrice: PlanPrices.maxMonthlyAnchor,
                  perMonthUnit: l10n.perMonthUnit,
                  badgeTone: tier == SubscriptionTier.max
                      ? BadgeTone.neutral
                      : BadgeTone.gold,
                  badgeLabel: tier == SubscriptionTier.max
                      ? l10n.badgeCurrent
                      : l10n.badgeRecommended,
                  tagline: l10n.planTaglineMax,
                  taglineColor: c.accentForegroundOrange,
                  bulletTone: BulletTone.max,
                  bullets: [
                    l10n.bulletMaxVideo,
                    l10n.bulletMaxEverything,
                    l10n.bulletMaxCharacters,
                    l10n.bulletMaxStudyBook,
                    l10n.bulletMaxWeeklyReport,
                  ],
                  face: c.statusCautionarySurface,
                  border: c.statusCautionary,
                  cta: tier == SubscriptionTier.max ? null : l10n.ctaTurnOnVideo,
                  ctaType: BtnType.gold,
                  onCta: () => Navigator.pushNamed(context, Routes.paywallMax),
                ),
                const SizedBox(height: AppSpacing.s24),
                PlanSummaryCard(
                  title: l10n.planFree,
                  price: PlanPrices.free,
                  badgeTone:
                      tier == SubscriptionTier.free ? BadgeTone.neutral : null,
                  badgeLabel:
                      tier == SubscriptionTier.free ? l10n.badgeCurrent : null,
                  tagline: l10n.planTaglineFree,
                  taglineColor: c.labelNormal,
                  bulletTone: BulletTone.free,
                  bullets: [
                    l10n.bulletFreeCall,
                    l10n.bulletFreeCheck,
                    l10n.bulletFreeAccent,
                    l10n.bulletFreeCharacter,
                  ],
                  face: c.backgroundSurfaceAlternative,
                ),
                const SizedBox(height: AppSpacing.s24),
                Text(l10n.noteCallLength,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal)),
                const SizedBox(height: AppSpacing.s4),
                Text(l10n.noteFairUse,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
