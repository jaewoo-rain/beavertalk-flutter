import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
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

/// Plan comparison — `depth/plans_compare` (`4514:5226`, 09-22 단일 티어).
///
/// 카드 두 장: Premium(금색, 「Turn on video」) · Free(평평, CTA 없음 — 살 것이 없다).
/// 어느 카드가 `Current` 를 달고 CTA 를 떨어뜨리는지만 상태로 갈린다.
/// 옛 Pro 카드(「Go unlimited」)는 없앴다 — Pro 는 더 팔지 않는다.
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
    // turns list prices into the member's real storefront prices.
    ref.watch(storePricesProvider);
    final premium = tier == SubscriptionTier.max;

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: l10n.currentPlanTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s32),
                children: [
                  PlanSummaryCard(
                    title: l10n.planMax,
                    price: PlanPrices.maxMonthly,
                    perMonthUnit: l10n.perMonthUnit,
                    badgeTone: premium ? BadgeTone.neutral : null,
                    badgeLabel: premium ? l10n.badgeCurrent : null,
                    tagline: l10n.planTaglineMax,
                    taglineColor: c.accentForegroundOrange,
                    bulletTone: BulletTone.max,
                    bullets: [
                      l10n.premiumBulletVideo,
                      l10n.premiumBulletAnalysis,
                      l10n.premiumBulletWeakSounds,
                      l10n.bulletProCorrections,
                    ],
                    face: c.statusCautionarySurface,
                    border: c.statusCautionary,
                    cta: premium ? null : l10n.ctaTurnOnVideo,
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
                      // 「억양 체크 무제한」 줄은 뺐다 — 한도 시트의 「하루 1번」과
                      // 같은 「check」로 읽혀 모순된다. 사실 확인 전까지 약속하지 않는다(P16).
                      l10n.bulletFreeCharacter,
                    ],
                    face: c.backgroundSurfaceAlternative,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(l10n.noteCallLength,
                      style: AppType.caption1.r.copyWith(color: c.labelNormal)),
                  const SizedBox(height: AppSpacing.s4),
                  Text(l10n.noteCharactersSeparate,
                      style: AppType.caption1.r.copyWith(color: c.labelNormal)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
