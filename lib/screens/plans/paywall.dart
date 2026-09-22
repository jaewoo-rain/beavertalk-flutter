import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
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
///
/// ⭐ **단일 티어(2026-09-22 · 가치 사다리 정본 §11-4).** 유료는 Premium 하나다 —
/// 스토어 상품 `bt_max_*` · 서버 플랜 코드 `max` 는 그대로, **표시 이름만** Premium.
/// [pro]·[max] 는 옛 라우트(`/paywall/pro`·`/paywall/max`)를 살리려고 남긴 값이고 **둘 다
/// 같은 Premium 페이월**을 그린다. Pro 는 더 팔지 않는다.
enum PaywallVariant {
  /// 옛 `depth/paywall_pro` 라우트 — 이제 Premium 페이월과 같다.
  pro,

  /// `depth/paywall_premium__limit` (`4658:28112`) — reached **only** by burning
  /// the daily cap (spec §8-1). Hot entry: a non-interactive banner naming
  /// what ran out and a one-line headline instead of the story.
  proLimit,

  /// `depth/paywall_premium` (`4514:5481`).
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

  /// 한도 진입인가(배너 + 한 줄 헤드라인 + 법적 링크). 나머지는 전부 같은 Premium 페이월.
  bool get _isLimit => widget.variant == PaywallVariant.proLimit;

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
    // Kicks the store catalog query and rebuilds this subtree when it lands.
    // Child widgets read [PlanPrices] statically, so this one watch is what
    // turns list prices into the member's real storefront prices — and what
    // makes a console-side discount show up without an app release.
    ref.watch(storePricesProvider);

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
                  if (!_isLimit) ...[
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
                  // 캐릭터는 구독에 들어 있지 않다(정본 v3.1). 「무제한」·공정사용 각주는 없앴다 —
                  // Premium 은 하루 최대 3통화 · 한 번에 15분이다(09-22 확정).
                  Text(
                    l10n.noteCharactersSeparate,
                    textAlign: TextAlign.center,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal),
                  ),
                  if (_isLimit) ...[
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
    if (_isLimit) {
      // Hot entries get the short bridge (spec §8-1): one line, no story.
      return [
        Text(l10n.paywallLimitHeadline,
            style: AppType.title3.sb.copyWith(color: c.labelStrong)),
      ];
    }
    // ⚠ 정본의 둘째 줄 「튜터 1시간 $25 = Premium 한 달 $23.99」 는 **아직 그리지 않는다.**
    //   $25 는 달러 고정 사실인데 옆 가격은 스토어 현지가라, 원화·루피 사용자에게는 서로 다른
    //   통화를 비교하는 문장이 된다(남은판단 P12). 통화별 비교값이 정해지면 되살린다.
    return [
      Text(l10n.paywallMaxTitle,
          style: AppType.title2.sb.copyWith(color: c.labelStrong)),
    ];
  }

  /// Premium 카드 — 불릿 4개는 정본 고정(가치 사다리 §4-1 · 출시 게이트 5: 만들지 않은 것은
  /// 올리지 않는다 — 학습서·주간 리포트·「모든 캐릭터」 는 뺐다).
  Widget _planCard(AppLocalizations l10n, AppColorTokens c) {
    return PlanSummaryCard(
      title: l10n.planMax,
      price: PlanPrices.maxMonthly,
      perMonthUnit: l10n.perMonthUnit,
      tagline: l10n.premiumBulletVideo,
      taglineColor: c.accentForegroundOrange,
      bulletTone: BulletTone.max,
      bullets: [
        l10n.premiumBulletVideo,
        l10n.premiumBulletAnalysis,
        l10n.premiumBulletWeakSounds,
        l10n.bulletProCorrections,
      ],
      bulletIcons: [
        AppIcons.duoVideo(),
        AppIcons.duoChart(),
        AppIcons.duoTarget(),
        AppIcons.duoBubble(),
      ],
      face: c.statusCautionarySurface,
      border: c.statusCautionary,
    );
  }

  List<Widget> _planRows(AppLocalizations l10n) {
    // 가격은 스토어 현지가(PlanPrices ← storePricesProvider). 정가 취소선($29.99 앵커)은
    // 뺐다 — 정본에 없고, 스토어 현지가 옆에 달러 앵커를 두면 틀린 비교가 된다.
    return [
      PlanRow(
        tier: PlanRowTier.max,
        selected: _cycle == _Cycle.monthly,
        title: l10n.planMonthly,
        price: l10n.maxMonthlyPriceLine(PlanPrices.maxMonthly),
        onTap: () => setState(() => _cycle = _Cycle.monthly),
      ),
      const SizedBox(height: AppSpacing.s12),
      PlanRow(
        tier: PlanRowTier.max,
        selected: _cycle == _Cycle.annual,
        title: l10n.planAnnual,
        price: l10n.maxAnnualPriceLine(
            PlanPrices.maxYearly, PlanPrices.maxYearlyPerMonth),
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
          onTap: () => runRestoreFlow(context),
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
              type: BtnType.gold,
              size: BtnSize.s60,
              text: _isLimit ? l10n.ctaGetPremium : l10n.ctaTurnOnVideo,
              // Tier AND cycle travel as the route argument — the tier alone
              // was the "bought Max, screen said Pro" bug, and a dropped cycle
              // meant the annual selection quietly bought monthly.
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.purchaseProcessing,
                arguments: (
                  // 유료는 Premium 하나 — 상품·서버 코드는 `max` 그대로다.
                  tier: SubscriptionTier.max,
                  annual: _cycle == _Cycle.annual,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              // 무료체험은 출시 때 끈다(정본 §8-2 · 스토어 「첫 주 무료」 오퍼 종료) — 체험 안내
              // 문구 분기는 뺐다. 오퍼가 남아 있으면 StoreKit 이 고지 없이 적용하므로 콘솔에서
              // 먼저 꺼야 한다(앱이 할 일이 아니다).
              l10n.ctaCaptionMax(PlanPrices.maxMonthly),
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

