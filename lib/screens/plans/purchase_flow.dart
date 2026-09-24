import '../../app/adaptive.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/benefit_row.dart';
import '../../components/molecules/stacked_button_pair.dart';
import '../../components/organisms/gnb.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
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
  /// sites), or the Premium-monthly default (Pro is no longer sold).
  PurchaseRequest get _request {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PurchaseRequest) return args;
    if (args is SubscriptionTier) return (tier: args, annual: false);
    return (tier: SubscriptionTier.max, annual: false);
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
          // 통화가 5분 시트에서 이 퍼널을 띄워 놓고 **기다리고 있는가.**
          //
          // 그렇다면 성공 화면(`depth/purchase_success_pro`)을 띄우지 않는다. 그 시안의
          // primary CTA 는 「Start a call」이라 **이미 통화 중인 사람에게 성립하지 않고**,
          // 애초에 통화 밖에서 결제한 사람을 위해 그려진 화면이다. 대신 통화 화면까지
          // 되돌려 대화를 잇는다 — 시트 카피가 약속한 「keep talking」이 그 뜻이다.
          //
          // ⛔ 이 판정을 `sessionEntitlementProvider` 를 감시하는 쪽(통화 화면)에 두지
          //   마라. 바로 위에서 그 provider 를 set 하고 **같은 동기 블록에서** 아래
          //   네비게이션이 돌기 때문에, 리스너는 microtask 로 한 박자 늦게 깬다.
          //   그러면 성공 화면이 한 번 번쩍이고 사라진다. 퍼널이 직접 갈라야 결정적이다.
          final callParked = ref.read(normalCallControllerProvider).phase ==
              CallPhase.awaitingContinue;
          if (callParked) {
            // `|| r.isFirst` 는 안전망이다 — [Navigator.popUntil] 은 술어가 끝내 참이
            // 되지 않으면 **스택을 다 비운다.** 통화 화면이 어떤 이유로든 스택에
            // 없을 때 결제한 사람을 빈 화면에 떨구는 것보다 홈이 낫다.
            Navigator.of(context).popUntil(
                (r) => r.settings.name == Routes.call || r.isFirst);
            return;
          }
          // 유료는 Premium 하나(상품·서버 코드 `max`) — 성공 화면도 하나다.
          Navigator.pushReplacementNamed(
            context,
            Routes.purchaseSuccessMax,
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
/// 단일 티어(09-22): Premium 성공 화면 하나(Figma `depth/purchase_success` `4514:5684`).
/// 옛 Pro 성공 화면이 띄우던 연간 전환 OTO(`overlay/oto_annual`)는 **껐다** — 연간은 팔되
/// 유도하지 않는다(가치 사다리 정본 §1 · §11-4).
/// [tier] 는 호출부 호환으로 남겼다. 무엇이 와도 Premium 으로 그린다.
class PurchaseSuccessScreen extends StatefulWidget {
  /// Creates a success screen for [tier].
  const PurchaseSuccessScreen({super.key, required this.tier});

  /// Which plan was just bought.
  final SubscriptionTier tier;

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> {

  /// The whole purchase funnel sits beneath this screen; going "back" into a
  /// spent paywall or the processing limbo helps no one. Every exit — system
  /// back, the X, `Start a call` — returns to the root instead.
  void _exitToRoot(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    // 페이월·플랜 비교와 **같은 네 줄**이다 — 산 것과 판 것이 같아야 한다.
    final benefits = [
      (AppIcons.duoVideo(), l10n.premiumBulletVideo),
      (AppIcons.duoChart(), l10n.premiumBulletAnalysis),
      (AppIcons.duoTarget(), l10n.premiumBulletWeakSounds),
      (AppIcons.duoBubble(), l10n.bulletProCorrections),
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
              child: ContentColumn(
                child: GestureDetector(
                  onTap: () => _exitToRoot(context),
                  child: AppIcons.close(size: 28, color: c.commonWhiteAndDark),
                ),
              ),
            ),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
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
                    l10n.successMaxTitle,
                    // Figma: 제목만 가운데 정렬(본문·혜택 줄은 왼쪽).
                    textAlign: TextAlign.center,
                    style: AppType.title3.sb.copyWith(color: c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    l10n.successMaxSub,
                    style: AppType.label1.r.copyWith(color: c.labelNormal),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  for (var i = 0; i < benefits.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    // Figma `purchase_success`(`4514:5684`): 페이월·플랜 비교와 같은 듀오톤
                    // 아이콘 줄(`Paywall/Benefit`).
                    BenefitRow(icon: benefits[i].$1, label: benefits[i].$2),
                  ],
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.lineAlternative)),
            ),
            child: ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 버튼 쌍 세로(09-24 사장님 확정) — Figma `depth/purchase_success` 순서:
                  // 「See your subscription」 위 · 「Start a video call」(gold) 아래, 버튼 사이 12 ·
                  // 안내 문구와는 6(Sticky-CTA gap 6 안에 Buttons gap 12).
                  StackedButtonPair(
                    top: Button(
                      type: BtnType.secondaryFill,
                      size: BtnSize.s60,
                      text: l10n.ctaSeeYourSubscription,
                      // Drop the spent funnel (paywall → processing → success)
                      // underneath: back from the manage screen should land on the
                      // root, not replay a completed purchase.
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, Routes.subscription, (route) => route.isFirst),
                    ),
                    bottom: Button(
                      type: BtnType.gold,
                      size: BtnSize.s60,
                      text: l10n.ctaStartAVideoCall,
                      onPressed: () => _exitToRoot(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.successMaxCaption(PlanPrices.maxMonthly),
                    textAlign: TextAlign.center,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal),
                  ),
                ],
              ),
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
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.lineAlternative)),
            ),
            child: ContentColumn(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
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

