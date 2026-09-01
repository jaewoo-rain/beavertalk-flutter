import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/badge.dart' show BadgeTone;
import '../../components/atoms/button.dart';
import '../../components/atoms/looping_video.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/banner.dart';
import '../../components/molecules/bullet_row.dart';
import '../../components/molecules/plan_row.dart';
import '../../components/molecules/plan_summary_card.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/subscription/domain/plan_prices.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../overlays/subscription_overlays.dart';

/// Which paywall this is.
enum PaywallVariant {
  /// `depth/paywall_pro` (`4514:5294`) — the warm entry.
  pro,

  /// `depth/paywall_pro__limit` (`4658:28112`) — reached **only** by burning
  /// the daily cap (spec §8-1). Hot entry: a non-interactive banner naming
  /// what ran out and a one-line headline instead of the story.
  proLimit,

  /// `depth/paywall_max` (`4514:5481`) — the gold one.
  max,
}

/// Which cap ran out — picks the limit banner copy (spec §8-1). One screen,
/// two wordings.
enum LimitKind {
  /// `That was today's call`.
  call,

  /// `That was today's check`.
  check,
}

/// Billing cycle choice on a paywall. Selection only — tapping a row never
/// navigates (spec §14).
enum _Cycle { monthly, annual }

/// The three paywalls in one screen — same skeleton (close-GNB → [banner] →
/// header → plan card → plan rows → disclosure/footnote → footer links) with
/// variant-driven content, all measured 2026-08-03.
class PaywallScreen extends ConsumerStatefulWidget {
  /// Creates a paywall.
  const PaywallScreen({super.key, required this.variant, this.limitKind});

  /// Which paywall.
  final PaywallVariant variant;

  /// Which cap ran out; only meaningful on [PaywallVariant.proLimit].
  /// Falls back to [LimitKind.call].
  final LimitKind? limitKind;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  _Cycle _cycle = _Cycle.monthly;

  /// Whether the leave guard already ran. Once per visit: the first back/X
  /// asks ("지금 나가면 구독할 수 없어요"), a second one respects the answer
  /// without nagging.
  bool _leaveGuardShown = false;

  bool get _isMax => widget.variant == PaywallVariant.max;

  /// Back/X on a paywall — the deepest point a member can still walk away
  /// from a subscription, so leaving gets one retention prompt. Dim tap and
  /// "Keep looking" stay; "Leave anyway" pops for real.
  Future<void> _handleClose() async {
    if (_leaveGuardShown) {
      Navigator.pop(context);
      return;
    }
    _leaveGuardShown = true;
    final l10n = AppLocalizations.of(context);
    final leave = await showDialogBasic<bool>(
      context,
      title: l10n.paywallLeaveTitle,
      description: l10n.paywallLeaveBody,
      variant: DialogBasicVariant.twoHorizontal,
      primary: DialogAction(
        label: l10n.ctaKeepLooking,
        onPressed: () => Navigator.of(context).pop(false),
      ),
      secondary: DialogAction(
        label: l10n.ctaLeaveAnyway,
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    if (leave == true && mounted) Navigator.pop(context);
  }

  /// Which cap ran out — the widget parameter, or the route argument the
  /// free-limit sheets pass (`'call'` / `'check'`), or call.
  LimitKind _effectiveLimitKind(BuildContext context) {
    if (widget.limitKind != null) return widget.limitKind!;
    final args = ModalRoute.of(context)?.settings.arguments;
    return args == 'check' ? LimitKind.check : LimitKind.call;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;

    return PopScope(
      canPop: false,
      // System back runs the same leave guard as the X.
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleClose();
      },
      child: AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          // Paywall GNB: a lone close glyph, left-aligned (measured — not the
          // back-arrow `Gnb.main`).
          SizedBox(
            height: 56,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ContentColumn(
                child: GestureDetector(
                  onTap: _handleClose,
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Center(
                      child:
                          AppIcons.close(size: 28, color: c.commonWhiteAndDark),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
                children: [
                  if (widget.variant == PaywallVariant.proLimit) ...[
                    // Non-interactive by design: no chevron, no tap. The banner
                    // states a fact; the CTA does the selling (spec §8-1).
                    Banner(
                      tone: BannerTone.neutral,
                      title: _effectiveLimitKind(context) == LimitKind.call
                          ? l10n.limitBannerCallTitle
                          : l10n.limitBannerCheckTitle,
                      sub: _effectiveLimitKind(context) == LimitKind.call
                          ? l10n.limitBannerCallSub
                          : l10n.limitBannerCheckSub,
                      showChevron: false,
                    ),
                    const SizedBox(height: AppSpacing.s24),
                  ],
                  ..._header(l10n, c),
                  const SizedBox(height: AppSpacing.s24),
                  _planCard(l10n, c),
                  if (_isMax) ...[
                    const SizedBox(height: AppSpacing.s24),
                    // Hero is a **video**, not a still. The file is a
                    // placeholder to be swapped later, so [LoopingVideo] falls
                    // back to a plain box rather than failing when the asset
                    // is missing — dropping in a new mp4 at the same path is
                    // the whole handover.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LoopingVideo(
                        asset: 'assets/videos/paywall_max_hero.mp4',
                        // 375 / 210.9375 은 정확히 16:9 다. 폭을 따라 커진다.
                        aspectRatio: AppLayout.videoAspect,
                        placeholderColor: c.backgroundSurfaceAlternative,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s24),
                  ..._planRows(l10n),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    _isMax ? l10n.noteMaxCharacters : l10n.noteFairUse,
                    textAlign: TextAlign.center,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal),
                  ),
                  if (!_isMax) ...[
                    const SizedBox(height: AppSpacing.s24),
                    _footerLinks(l10n, c),
                  ],
                ],
              ),
            ),
          ),
          _stickyCta(l10n, c),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
      ),
    );
  }

  List<Widget> _header(AppLocalizations l10n, AppColorTokens c) {
    switch (widget.variant) {
      case PaywallVariant.pro:
        final title = AppType.title3.sb.copyWith(color: c.labelStrong);
        return [
          Text(l10n.paywallProTitle1, style: title),
          const SizedBox(height: AppSpacing.s4),
          Text(l10n.paywallProTitle2, style: title),
          const SizedBox(height: AppSpacing.s4),
          Text(l10n.paywallProSub,
              style: AppType.label1.r.copyWith(color: c.labelNormal)),
        ];
      case PaywallVariant.proLimit:
        // Hot entries get the short bridge (spec §8-1): one line, no story.
        return [
          Text(l10n.paywallLimitHeadline,
              style: AppType.title3.sb.copyWith(color: c.labelStrong)),
        ];
      case PaywallVariant.max:
        return [
          Text(l10n.paywallMaxTitle,
              style: AppType.title2.sb.copyWith(color: c.labelStrong)),
          const SizedBox(height: AppSpacing.s8),
          Text(l10n.paywallMaxSub,
              style: AppType.label1.r.copyWith(color: c.labelNormal)),
        ];
    }
  }

  Widget _planCard(AppLocalizations l10n, AppColorTokens c) {
    if (_isMax) {
      return PlanSummaryCard(
        title: l10n.planMax,
        price: PlanPrices.maxMonthly,
        anchorPrice: PlanPrices.maxMonthlyAnchor,
        perMonthUnit: l10n.perMonthUnit,
        badgeTone: BadgeTone.gold,
        badgeLabel: l10n.badgeRecommended,
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
      );
    }
    return PlanSummaryCard(
      title: l10n.planPro,
      price: PlanPrices.proMonthly,
      perMonthUnit: l10n.perMonthUnit,
      tagline: l10n.planTaglinePro,
      taglineColor: c.primaryNormal,
      bulletTone: BulletTone.pro,
      bullets: [
        l10n.bulletProCalls,
        l10n.bulletProLength,
        l10n.bulletProScoring,
        l10n.bulletProCorrections,
        l10n.bulletProBeaverCalls,
        // The sixth row — the character-permanence promise added in the
        // redesign (spec §16-3: 5행 → 6행).
        l10n.bulletProCharactersForever,
      ],
      face: c.primaryNormal10,
      border: c.primaryNormal,
    );
  }

  List<Widget> _planRows(AppLocalizations l10n) {
    final tier = _isMax ? PlanRowTier.max : PlanRowTier.pro;
    return [
      PlanRow(
        tier: tier,
        selected: _cycle == _Cycle.monthly,
        title: l10n.planMonthly,
        price: _isMax ? l10n.maxMonthlyPriceLine(PlanPrices.maxMonthly) : l10n.proMonthlyPriceLine(PlanPrices.proMonthly),
        priceOriginal: _isMax ? PlanPrices.maxMonthlyAnchor : null,
        onTap: () => setState(() => _cycle = _Cycle.monthly),
      ),
      const SizedBox(height: AppSpacing.s12),
      PlanRow(
        tier: tier,
        selected: _cycle == _Cycle.annual,
        title: l10n.planAnnual,
        price: _isMax ? l10n.maxAnnualPriceLine(PlanPrices.maxYearly, PlanPrices.maxYearlyPerMonth) : l10n.proAnnualPriceLine(PlanPrices.proYearly, PlanPrices.proYearlyPerMonth),
        priceOriginal: _isMax ? null : PlanPrices.proYearlyAnchor,
        onTap: () => setState(() => _cycle = _Cycle.annual),
      ),
    ];
  }

  Widget _footerLinks(AppLocalizations l10n, AppColorTokens c) {
    final style = AppType.caption1.r.copyWith(color: c.labelNormal);
    // Wrap, not Row: three legal links on one line overflowed by 108px even
    // in English (the i18n sweep missed it — the ListView never builds this
    // below the 640px fold). Legal links must stay readable, so the long
    // locales break onto a second centred line instead of ellipsizing.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () => showSubscriptionOverlay(
              context, SubscriptionOverlay.restoreSuccess),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 6, vertical: AppSpacing.s12),
            child: Text(l10n.billingRestorePurchases, style: style),
          ),
        ),
        Text(' · ', style: style),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.terms),
          child: Text(l10n.footerTerms, style: style),
        ),
        Text(' · ', style: style),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.privacy),
          child: Text(l10n.footerPrivacy, style: style),
        ),
      ],
    );
  }

  /// Whether the 7-day Max trial may be announced on this screen.
  ///
  /// The store is the real authority — an introductory offer is once per
  /// account per subscription group, and only StoreKit / Play Billing can say
  /// whether this account already used it. Until the SDK lands this
  /// approximates it as "has never been on a paid plan", which errs toward
  /// hiding the line: promising a free trial to someone who already spent it
  /// is a 3.1.2 misstatement, not a cosmetic slip.
  bool get _trialEligible {
    // Gate one: can the rail answer at all? The mock cannot, so today this is
    // always false and the trial line never ships. That is the intended
    // state — see [IapService.reportsIntroEligibility].
    if (!ref.watch(iapServiceProvider).reportsIntroEligibility) return false;
    // Gate two: **replace this when a real rail lands.** "Never been on a paid
    // plan" is not eligibility — a member who took the trial, cancelled, and
    // whose server row lapsed reads as free here. Ask the store per product.
    return ref.watch(subscriptionStatusProvider).state == SubscriptionState.free;
  }

  Widget _stickyCta(AppLocalizations l10n, AppColorTokens c) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.lineAlternative)),
      ),
      child: ContentColumn(
        padding: const EdgeInsets.only(top: AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Button(
              type: _isMax ? BtnType.gold : BtnType.primaryFill,
              size: BtnSize.s60,
              text: _isMax ? l10n.ctaTurnOnVideo : l10n.ctaGoUnlimited,
              // Tier AND cycle travel as the route argument — the tier alone
              // was the "bought Max, screen said Pro" bug, and a dropped cycle
              // meant the annual selection quietly bought monthly.
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.purchaseProcessing,
                arguments: (
                  tier: _isMax ? SubscriptionTier.max : SubscriptionTier.pro,
                  annual: _cycle == _Cycle.annual,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isMax
                  ? (_trialEligible ? l10n.ctaCaptionMaxTrial(PlanPrices.maxMonthly) : l10n.ctaCaptionMax(PlanPrices.maxMonthly))
                  : l10n.ctaCaptionPro(PlanPrices.proMonthly),
              textAlign: TextAlign.center,
              style: AppType.caption1.r.copyWith(color: c.labelNormal),
            ),
            // App Review 3.1.2 wants five things on the purchase screen: title,
            // length, price, **that it auto-renews**, and how to cancel. The
            // caption above carried four of them; this is the fifth. Its own
            // line rather than an infix — spliced mid-sentence it reads wrong in
            // half the locales.
            Text(
              l10n.ctaCaptionAutoRenew,
              textAlign: TextAlign.center,
              style: AppType.caption1.r.copyWith(color: c.labelAlternative),
            ),
          ],
        ),
      ),
    );
  }
}

