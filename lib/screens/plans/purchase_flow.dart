import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/benefit_row.dart';
import '../../components/organisms/gnb.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/domain/iap_service.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/subscription/domain/plan_prices.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../overlays/subscription_overlays.dart';

/// `depth/purchase_processing` (`4514:5654`) — receipt-confirmation limbo.
///
/// Kicks the (mock) store purchase on entry and rides the [IapService]
/// purchase stream: `purchased` → the tier's success screen, `canceled` /
/// `failed` → back to the paywall (their sheets are the P4 overlay layer).
/// No cancel affordance by design — the OS payment sheet already had one.
class PurchaseProcessingScreen extends ConsumerStatefulWidget {
  /// Creates the processing screen.
  const PurchaseProcessingScreen({super.key});

  @override
  ConsumerState<PurchaseProcessingScreen> createState() =>
      _PurchaseProcessingScreenState();
}

class _PurchaseProcessingScreenState
    extends ConsumerState<PurchaseProcessingScreen> {
  StreamSubscription<IapPurchase>? _sub;
  bool _kicked = false;

  /// What to buy — a [PurchaseRequest] argument, or a bare tier (legacy call
  /// sites), or the Pro-monthly default.
  PurchaseRequest get _request {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PurchaseRequest) return args;
    if (args is SubscriptionTier) return (tier: args, annual: false);
    return (tier: SubscriptionTier.pro, annual: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_kicked) return;
    _kicked = true;
    final iap = ref.read(iapServiceProvider);
    final request = _request;
    final tier = request.tier;
    _sub = iap.purchases.listen((p) {
      if (!mounted) return;
      switch (p.state) {
        case IapPurchaseState.purchased:
        case IapPurchaseState.restored:
          // Record what was actually bought — the server has no plan field and
          // the mock rail never reaches it, so without this every screen keeps
          // rendering the resolver's assumed Pro (the "bought Max, shows Pro"
          // bug). Then drop the server caches so a real backend refetches.
          ref.read(sessionEntitlementProvider.notifier).state = tier;
          ref.invalidate(serverSubscriptionStatusProvider);
          ref.invalidate(subscriptionsProvider);
          Navigator.pushReplacementNamed(
            context,
            tier == SubscriptionTier.max
                ? Routes.purchaseSuccessMax
                : Routes.purchaseSuccessPro,
            // The success screen suppresses the annual OTO when the purchase
            // was already annual (spec §8-2).
            arguments: request.annual,
          );
        case IapPurchaseState.canceled:
        case IapPurchaseState.failed:
          _onFailed(p.state, request);
        case IapPurchaseState.pending:
          break;
      }
    });
    // Fire the purchase after the listener is attached. The cycle picks the
    // product: the paywall's annual selection and the OTO's yearly switch
    // used to be dropped here, quietly buying monthly every time.
    unawaited(_kick(iap, request));
  }

  /// Asks the store for the chosen product and starts the payment sheet.
  ///
  /// Every way this can go wrong ends on the failure sheet. This screen blocks
  /// the back key — the flow is supposed to leave through the purchase stream
  /// — so a store query that throws or comes back empty would otherwise strand
  /// the member on a spinner with no way out. That was survivable against a
  /// mock rail that could not fail; a real one goes offline.
  Future<void> _kick(IapService iap, PurchaseRequest request) async {
    final id = switch ((request.tier, request.annual)) {
      (SubscriptionTier.max, true) => IapProductIds.maxYearly,
      (SubscriptionTier.max, false) => IapProductIds.maxMonthly,
      (_, true) => IapProductIds.proYearly,
      (_, false) => IapProductIds.proMonthly,
    };
    try {
      final products = await iap.getProducts(IapProductIds.subscriptions);
      final product = products.where((p) => p.id == id).firstOrNull;
      if (product == null) {
        if (mounted) _onStoreError(request);
        return;
      }
      await iap.purchase(product);
    } catch (_) {
      if (mounted) _onStoreError(request);
    }
  }

  /// The store could not be asked, or does not sell this — `purchase_failed —
  /// 스토어 오류`.
  ///
  /// Deliberately **not** the declined sheet. Nothing was declined: no payment
  /// was ever attempted. Offering "update your payment method" here points the
  /// member at a card that is perfectly fine and hides the real cause.
  void _onStoreError(PurchaseRequest request) {
    final navCtx = Navigator.of(context, rootNavigator: true).context;
    Navigator.pop(context);
    showSubscriptionOverlay(navCtx, SubscriptionOverlay.purchaseFailedStore,
        retryTier: request.tier, retryAnnual: request.annual);
  }

  /// Back to the paywall beneath, then the matching `purchase_failed` sheet
  /// over it (P4). The retry CTA rebuys the same tier AND cycle.
  void _onFailed(IapPurchaseState state, PurchaseRequest request) {
    if (!mounted) return;
    final navCtx = Navigator.of(context, rootNavigator: true).context;
    final overlay = state == IapPurchaseState.canceled
        ? SubscriptionOverlay.purchaseFailedCanceled
        : SubscriptionOverlay.purchaseFailedDeclined;
    Navigator.pop(context);
    showSubscriptionOverlay(navCtx, overlay,
        retryTier: request.tier, retryAnnual: request.annual);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    // Back is blocked while the receipt is being confirmed — leaving here
    // could strand a charge with no result screen. The flow exits through the
    // purchase stream (success screen or back-to-paywall), never the back key.
    return PopScope(
      canPop: false,
      child: AppScaffold(
        background: c.backgroundNormalNormal,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: c.primaryNormal,
                  backgroundColor: c.primaryNormal10,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(l10n.processingTitle,
                  style: AppType.heading2.sb.copyWith(color: c.labelStrong)),
              const SizedBox(height: AppSpacing.s16),
              Text(l10n.processingSub,
                  style: AppType.label1.r.copyWith(color: c.labelNormal)),
            ],
          ),
        ),
      ),
    );
  }
}

/// `depth/purchase_success_pro` / `_max` (`4514:5666` / `4514:5684`).
///
/// Close-GNB, success mark, headline, three unlocked-benefit rows and a
/// sticky CTA pair. Pro is mint; Max is gold end to end.
///
/// The Pro variant also fires the one-time-offer: `overlay/oto_annual` 0.8s
/// after entry (spec §8-2) — once per app run, monthly purchases only.
class PurchaseSuccessScreen extends StatefulWidget {
  /// Creates a success screen for [tier].
  const PurchaseSuccessScreen({super.key, required this.tier});

  /// Which plan was just bought.
  final SubscriptionTier tier;

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> {
  /// Once per app run — the OTO never nags (spec §8-2: 신규 결제 직후 1회).
  static bool _otoShownThisRun = false;

  SubscriptionTier get tier => widget.tier;

  bool get _isMax => tier == SubscriptionTier.max;

  /// Whether the purchase that landed here was annual — the processing screen
  /// hands it through as the route argument. Annual buyers never see the
  /// annual OTO (spec §8-2: 월간 신규 결제 직후 1회).
  bool get _wasAnnual =>
      ModalRoute.of(context)?.settings.arguments as bool? ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isMax || _otoShownThisRun || _wasAnnual) return;
    _otoShownThisRun = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      showSubscriptionOverlay(context, SubscriptionOverlay.otoAnnual);
    });
  }

  /// The whole purchase funnel sits beneath this screen; going "back" into a
  /// spent paywall or the processing limbo helps no one. Every exit — system
  /// back, the X, `Start a call` — returns to the root instead.
  void _exitToRoot(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final benefits = _isMax
        ? [
            l10n.successMaxBenefit1,
            l10n.successMaxBenefit2,
            l10n.successMaxBenefit3
          ]
        : [
            l10n.successProBenefit1,
            l10n.successProBenefit2,
            l10n.successProBenefit3
          ];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitToRoot(context);
      },
      child: AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: GestureDetector(
                  onTap: () => _exitToRoot(context),
                  child: AppIcons.close(size: 28, color: c.commonWhiteAndDark),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.primaryNormal14,
                  ),
                  child: AppIcons.check(size: 32, color: c.primaryNormal),
                ),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  _isMax ? l10n.successMaxTitle : l10n.successProTitle,
                  style: AppType.title3.sb.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  _isMax ? l10n.successMaxSub : l10n.successProSub,
                  style: AppType.label1.r.copyWith(color: c.labelNormal),
                ),
                const SizedBox(height: AppSpacing.s24),
                for (var i = 0; i < benefits.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  BenefitRow(
                    tier: _isMax ? BenefitTier.max : BenefitTier.pro,
                    label: benefits[i],
                  ),
                ],
              ],
            ),
          ),
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
                  type: _isMax ? BtnType.gold : BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: _isMax ? l10n.ctaStartAVideoCall : l10n.ctaStartACall,
                  onPressed: () => _exitToRoot(context),
                ),
                const SizedBox(height: 6),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaSeeYourSubscription,
                  // Drop the spent funnel (paywall → processing → success)
                  // underneath: back from the manage screen should land on the
                  // root, not replay a completed purchase.
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, Routes.subscription, (route) => route.isFirst),
                ),
                const SizedBox(height: 6),
                Text(
                  _isMax ? l10n.successMaxCaption(PlanPrices.maxMonthly) : l10n.successProCaption(PlanPrices.proMonthly),
                  textAlign: TextAlign.center,
                  style: AppType.caption1.r.copyWith(color: c.labelNormal),
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
      ),
    );
  }
}

/// `depth/plans_error` (`4514:5639`) — the store did not answer.
class PlansErrorScreen extends StatelessWidget {
  /// Creates the plans-error screen.
  const PlansErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
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
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.statusNegative6,
                    ),
                    child:
                        AppIcons.alert(size: 32, color: c.accentForegroundRed),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Text(l10n.plansErrorTitle,
                      style:
                          AppType.heading2.sb.copyWith(color: c.labelStrong)),
                  const SizedBox(height: AppSpacing.s20),
                  Text(l10n.plansErrorSub,
                      style: AppType.label1.r.copyWith(color: c.labelNormal)),
                ],
              ),
            ),
          ),
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
                  text: l10n.ctaTryAgain,
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, Routes.plansCompare),
                ),
                const SizedBox(height: 6),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.billingRestorePurchases,
                  onPressed: () => runRestoreFlow(context),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.plansErrorCaption,
                  textAlign: TextAlign.center,
                  style: AppType.caption1.r.copyWith(color: c.labelNormal),
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

