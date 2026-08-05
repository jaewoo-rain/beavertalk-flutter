import 'package:flutter/material.dart' hide Badge, Banner;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/badge.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/banner.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/store/store_subscription_link.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/domain/subscription_status_resolver.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/subscription/domain/plan_prices.dart';
import '../../l10n/app_localizations.dart';
import '../../components/organisms/gnb.dart';
import '../overlays/subscription_overlays.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Subscription management — the eight state screens of spec §4-1, rendered
/// from one widget because they are one screen with state-driven parts.
///
/// Measured off the Dark originals (`4514:4739` free · `4514:5111` trial ·
/// `4514:5050` active · `4514:5081` max · `4514:4900` grace · `4652:27757`
/// hold · `4514:5193` ending · `4514:5179` expired). The layout skeleton —
/// GNB → banners → plan card → billing list → notes — never changes; only the
/// pieces spec §6-1 varies (badge, banners, slot ① and ⑦, footnotes) do.
///
/// [SubscriptionState.expired] alone renders the `trial_expired` **notice**
/// instead: no billing list, a single `See plans` path (spec §4-1 footnote).
class SubscriptionManageScreen extends ConsumerWidget {
  /// Creates the subscription management screen.
  const SubscriptionManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(subscriptionStatusProvider);
    if (status.state == SubscriptionState.expired) {
      return _TrialExpiredNotice(status: status);
    }
    return _ManageBody(status: status);
  }
}

/// `MMM d, yyyy` — the confirmed screens format dates as `Jun 20, 2026`.
/// English locale on purpose: every string on these screens is confirmed
/// English copy (work order §1-3).
String _fullDate(BuildContext context, DateTime d) =>
    localizedFullDate(context, d);

/// `MMM d` — the short form footnotes use (`Benefits run until Jun 20`).
String _shortDate(BuildContext context, DateTime d) =>
    localizedShortDate(context, d);

/// The plan-card monthly price line: server value when present, otherwise the
/// plan's list price (the design's `$12.99` / `$19.99`).
String _priceLine(AppLocalizations l10n, SubscriptionStatus status) {
  final minor = status.source?.price ??
      (status.tier == SubscriptionTier.max ? 1990 : 1290);
  return l10n.pricePerMonthLine(formatUsd(minor));
}

/// The manage layout shared by the seven non-expired states.
class _ManageBody extends StatelessWidget {
  const _ManageBody({required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = status.state;
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: l10n.subscriptionTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s32),
              children: [
                // Payment-trouble banner rides on top of everything —
                // grace/hold only (spec §6-1), measured above the plan card.
                if (state.showsPaymentFailureBanner) ...[
                  _dangerBanner(context, l10n),
                  const SizedBox(height: AppSpacing.s24),
                ],
                _PlanCard(status: status),
                ..._upsell(context, l10n),
                const SizedBox(height: AppSpacing.s24),
                _BillingList(status: status),
                const SizedBox(height: AppSpacing.s24),
                ..._notes(context, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dangerBanner(BuildContext context, AppLocalizations l10n) {
    final hold = status.state == SubscriptionState.onHold;
    return Banner(
      tone: BannerTone.danger,
      title: hold ? l10n.bannerPausedTitle : l10n.bannerPaymentFailedTitle,
      sub: hold ? l10n.bannerPausedSub : l10n.bannerPaymentFailedSub,
      onTap: () => showSubscriptionOverlay(
          context, SubscriptionOverlay.paymentUpdate),
    );
  }

  /// The banner below the plan card, when the state carries one.
  ///
  /// Free sells Pro (brand), Pro-tier states sell Max (gold), Max sells the
  /// annual cycle (gold). Trial and hold show none — hold because payment
  /// recovery comes first (spec §6-1), trial per the measured original
  /// (`4514:5111` carries no banner; spec §6-1's table disagrees and the
  /// design is the canon — flagged for review).
  List<Widget> _upsell(BuildContext context, AppLocalizations l10n) {
    final Banner? banner = switch (status.state) {
      SubscriptionState.free => Banner(
          tone: BannerTone.brand,
          title: l10n.bannerGoUnlimitedTitle,
          sub: l10n.bannerGoUnlimitedSub(PlanPrices.proMonthly),
          onTap: () => Navigator.pushNamed(context, Routes.paywallPro),
        ),
      SubscriptionState.activePro ||
      SubscriptionState.grace ||
      SubscriptionState.ending =>
        Banner(
          tone: BannerTone.gold,
          title: l10n.bannerMaxUpsellTitle,
          sub: l10n.bannerMaxUpsellSub(PlanPrices.maxMonthly),
          onTap: () => Navigator.pushNamed(context, Routes.paywallMax),
        ),
      SubscriptionState.activeMax => Banner(
          tone: BannerTone.gold,
          title: l10n.bannerAnnualSwitchTitle,
          sub: l10n.bannerAnnualSwitchSub(PlanPrices.maxYearly, PlanPrices.maxYearlyPerMonth),
          onTap: () => showSubscriptionOverlay(
              context, SubscriptionOverlay.annualSwitch,
              expiresAt: status.expiresAt),
        ),
      _ => null,
    };
    if (banner == null) return const [];
    return [const SizedBox(height: AppSpacing.s24), banner];
  }

  /// The caption block(s) under the billing list — copy measured per state.
  List<Widget> _notes(BuildContext context, AppLocalizations l10n) {
    final c = context.c;
    final style = AppType.caption1.r.copyWith(color: c.labelNormal);
    final state = status.state;
    final expiry = status.expiresAt;

    final lines = <String>[
      if (state == SubscriptionState.free)
        l10n.noteRestoreHint
      else if (state == SubscriptionState.trial) ...[
        if (expiry != null) l10n.noteTrialEnds(_shortDate(context, expiry)),
      ] else ...[
        l10n.noteStoreHandled,
        // The Max original carries only the store-handled line; every other
        // paid state adds the fair-use line (measured).
        if (state != SubscriptionState.activeMax) l10n.noteFairUse,
      ],
      if (state == SubscriptionState.grace) l10n.noteGrace,
      if (state == SubscriptionState.onHold) l10n.noteHold,
      if (state == SubscriptionState.ending && expiry != null)
        l10n.noteEnding(_shortDate(context, expiry)),
    ];

    return [
      for (var i = 0; i < lines.length; i++) ...[
        if (i > 0) const SizedBox(height: AppSpacing.s4),
        Text(lines[i], style: style),
      ],
    ];
  }
}

/// The plan summary card. Two measured paddings exist in the originals —
/// `card` (16/14, gap 10) on free/trial/max and `Card/status` (24/16, gap 12)
/// on active/grace/hold/ending — and both are kept as measured.
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.status});

  final SubscriptionStatus status;

  bool get _compact => switch (status.state) {
        SubscriptionState.free ||
        SubscriptionState.trial ||
        SubscriptionState.activeMax =>
          true,
        _ => false,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final state = status.state;

    final title = switch (state) {
      SubscriptionState.free => l10n.planFree,
      SubscriptionState.trial => l10n.planMaxTrial,
      SubscriptionState.activeMax => l10n.planMax,
      _ => status.tier == SubscriptionTier.max ? l10n.planMax : l10n.planPro,
    };

    final (BadgeTone badgeTone, String badgeLabel) = switch (state) {
      SubscriptionState.free => (BadgeTone.neutral, l10n.badgeCurrent),
      SubscriptionState.trial => (BadgeTone.gold, l10n.badgeTrial),
      SubscriptionState.activePro => (BadgeTone.brand, l10n.badgeRenewing),
      SubscriptionState.activeMax => (BadgeTone.gold, l10n.badgeRenewing),
      SubscriptionState.grace => (BadgeTone.negative, l10n.badgePastDue),
      SubscriptionState.onHold => (BadgeTone.negative, l10n.badgePaused),
      SubscriptionState.ending => (BadgeTone.neutral, l10n.badgeCanceling),
      SubscriptionState.expired => (BadgeTone.neutral, l10n.badgeCurrent),
    };

    final expiry = status.expiresAt;
    final subtitle = switch (state) {
      SubscriptionState.free => l10n.freePlanPriceLine,
      SubscriptionState.trial =>
        expiry == null ? l10n.planMaxTrial : l10n.freeUntilDate(_fullDate(context, expiry)),
      _ => _priceLine(l10n, status),
    };

    final (String rowLabel, String rowValue) = switch (state) {
      // TODO(server): today's usage is not on any endpoint yet; 0-of-1 is the
      // Free default until the usage counter ships (see plan doc §5).
      SubscriptionState.free => (l10n.todaysCalls, l10n.callsUsedOfLimit(0, 1)),
      SubscriptionState.trial => (
          l10n.firstPaymentLabel,
          expiry == null ? '—' : _fullDate(context, expiry),
        ),
      SubscriptionState.grace => (
          l10n.retryingUntilLabel,
          // Server value, never computed locally (spec §11-3).
          status.retryingUntil == null ? '—' : _fullDate(context, status.retryingUntil!),
        ),
      SubscriptionState.onHold => (
          l10n.pausedSinceLabel,
          status.pausedSince == null ? '—' : _fullDate(context, status.pausedSince!),
        ),
      SubscriptionState.ending => (
          l10n.planEndsLabel(
              status.tier == SubscriptionTier.max ? l10n.planMax : l10n.planPro),
          expiry == null ? '—' : _fullDate(context, expiry),
        ),
      _ => (
          l10n.nextPaymentLabel,
          expiry == null ? '—' : _fullDate(context, expiry),
        ),
    };

    return Container(
      padding: _compact
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: c.backgroundSurfaceAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppType.headline1.sb.copyWith(color: c.labelStrong),
                ),
              ),
              const SizedBox(width: 8),
              Badge(tone: badgeTone, label: badgeLabel),
            ],
          ),
          SizedBox(height: _compact ? 10 : 12),
          Text(
            subtitle,
            style: AppType.body2.r.copyWith(color: c.labelNormal),
          ),
          SizedBox(height: _compact ? 10 : 12),
          Container(height: 1, color: c.lineAlternative),
          SizedBox(height: _compact ? 10 : 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  rowLabel,
                  style: AppType.label1.r.copyWith(color: c.labelNormal),
                ),
              ),
              const SizedBox(width: 8),
              // Flexible + ellipsis, not a bare Text: the wordier locales'
              // usage line ("0 of 1 used") ran the row off the right edge
              // (hi/ur/kk overflowed up to 93px in the 320-wide sweep).
              Flexible(
                child: Text(
                  rowValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppType.label1.sb.copyWith(color: c.labelStrong),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The seven-row, two-group billing list — spec §5, identical in every state.
///
/// Rows are never hidden; only slot ① and ⑦ change label and destination,
/// and both of those decisions live on the domain extension
/// ([SubscriptionStateX]), not here.
class _BillingList extends StatelessWidget {
  const _BillingList({required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = status.state;

    String slotLabel(BillingSlotLabel label) => switch (label) {
          BillingSlotLabel.changePlan => l10n.billingChangePlan,
          BillingSlotLabel.compareAllPlans => l10n.billingCompareAllPlans,
          BillingSlotLabel.cancelSubscription => l10n.billingCancelSubscription,
          BillingSlotLabel.resubscribe => l10n.billingResubscribe,
        };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _groupTitle(context, l10n.billingGroupPlanPurchases),
        const SizedBox(height: AppSpacing.s16),
        _card(context, [
          _BillingRow(
            label: slotLabel(state.planSlotLabel),
            destination: state.planSlotDestination,
          ),
          _BillingRow(
            label: l10n.billingBuyACharacter,
            destination: BillingDestination.characterOffer,
          ),
          _BillingRow(
            label: l10n.billingRestorePurchases,
            destination: state.restoreDestination,
          ),
          _BillingRow(
            label: l10n.billingPaymentHistory,
            destination: BillingDestination.paymentHistory,
            last: true,
          ),
        ]),
        const SizedBox(height: AppSpacing.s24),
        _groupTitle(context, l10n.billingGroupInTheStore),
        const SizedBox(height: AppSpacing.s16),
        _card(context, [
          const _BillingRow(
            label: null,
            labelKey: _StoreRowLabel.manage,
            destination: BillingDestination.manageInStore,
            external: true,
          ),
          const _BillingRow(
            label: null,
            labelKey: _StoreRowLabel.refund,
            destination: BillingDestination.refundHelp,
            external: true,
          ),
          _BillingRow(
            label: slotLabel(state.statusSlotLabel),
            destination: state.statusSlotDestination,
            external: true,
            last: true,
            expiresAt: status.expiresAt,
          ),
        ]),
      ],
    );
  }

  Widget _groupTitle(BuildContext context, String text) => Text(
        text,
        style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
      );

  Widget _card(BuildContext context, List<Widget> rows) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.c.backgroundSurfaceAlternative,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: rows),
      );
}

/// Store-group rows whose labels are fixed (not slot-driven).
enum _StoreRowLabel { manage, refund }

/// One 56px billing row: label, trailing `›` (in-app) or `↗` (leaves the app),
/// a 0.5px divider on every row **but the last** (spec §5-6).
class _BillingRow extends StatelessWidget {
  const _BillingRow({
    required this.label,
    this.labelKey,
    required this.destination,
    this.external = false,
    this.last = false,
    this.expiresAt,
  });

  final String? label;
  final _StoreRowLabel? labelKey;
  final BillingDestination destination;
  final bool external;
  final bool last;

  /// Expiry date for the overlays that quote one (server value).
  final DateTime? expiresAt;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final text = label ??
        switch (labelKey!) {
          _StoreRowLabel.manage => l10n.billingManageInTheStore,
          _StoreRowLabel.refund => l10n.billingRefundHelp,
        };
    return GestureDetector(
      onTap: () => _open(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: last
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: c.lineAlternative, width: 0.5),
                ),
              ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: AppType.label1.r.copyWith(color: c.commonWhiteAndDark),
              ),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: external
                    ? AppIcons.externalLink(size: 20, color: c.labelNormal)
                    : AppIcons.chevronRight(size: 20, color: c.labelNormal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Routes a [BillingDestination]. Screens push; overlays present as modal
  /// sheets over this screen (spec §7 — the background stays put).
  void _open(BuildContext context) {
    switch (destination) {
      case BillingDestination.manageInStore:
        // The store's own subscription page — external by definition. Product
        // id does not exist yet, so the account-level fallback URL is used
        // (spec §15-1).
        launchUrl(
          StoreSubscriptionLink.forCurrentPlatform(),
          mode: LaunchMode.externalApplication,
        );
      case BillingDestination.paymentHistory:
        Navigator.pushNamed(context, Routes.paymentHistory);
      case BillingDestination.plansCompare:
        Navigator.pushNamed(context, Routes.plansCompare);
      case BillingDestination.planChangeUpgrade:
        Navigator.pushNamed(context, Routes.planChangeUpgrade);
      case BillingDestination.planChangeDowngrade:
        Navigator.pushNamed(context, Routes.planChangeDowngrade);
      case BillingDestination.characterOffer:
        showSubscriptionOverlay(context, SubscriptionOverlay.characterOffer);
      case BillingDestination.restoreSuccess:
        showSubscriptionOverlay(context, SubscriptionOverlay.restoreSuccess);
      case BillingDestination.restoreEmpty:
        showSubscriptionOverlay(context, SubscriptionOverlay.restoreEmpty);
      case BillingDestination.refundHelp:
        showSubscriptionOverlay(context, SubscriptionOverlay.refundHelp);
      case BillingDestination.notEligible:
        showSubscriptionOverlay(context, SubscriptionOverlay.notEligible);
      case BillingDestination.cancelDownsell:
        showSubscriptionOverlay(context, SubscriptionOverlay.cancelDownsell,
            expiresAt: expiresAt);
      case BillingDestination.cancelSubscription:
        showSubscriptionOverlay(
            context, SubscriptionOverlay.cancelSubscription,
            expiresAt: expiresAt);
      case BillingDestination.resubscribe:
        showSubscriptionOverlay(context, SubscriptionOverlay.resubscribe,
            expiresAt: expiresAt);
    }
  }
}

/// `depth/trial_expired` (`4514:5179`) — the notice screen, not a manage
/// surface: a centred error mark, two lines, and a sticky CTA pair. No
/// billing list by design (spec §4-1).
class _TrialExpiredNotice extends StatelessWidget {
  const _TrialExpiredNotice({required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: l10n.plansTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.statusNegative6,
                    ),
                    child: Center(
                      child: AppIcons.alert(
                          size: 32, color: c.accentForegroundRed),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    l10n.trialExpiredTitle,
                    style: AppType.heading2.sb.copyWith(color: c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    l10n.trialExpiredSub,
                    style: AppType.label1.r.copyWith(color: c.labelNormal),
                  ),
                ],
              ),
            ),
          ),
          // Sticky CTA — top hairline, 12px shelf, 6px between buttons, all
          // measured off the original.
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20, AppSpacing.s12, AppSpacing.s20, 0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.lineAlternative)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.seePlans,
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.plansCompare),
                ),
                const SizedBox(height: 6),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.billingRestorePurchases,
                  onPressed: () => showSubscriptionOverlay(
                      context, SubscriptionOverlay.restoreSuccess),
                ),
              ],
            ),
          ),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
