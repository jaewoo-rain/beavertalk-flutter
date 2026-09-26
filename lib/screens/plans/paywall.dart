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
import '../../components/organisms/dialog_basic.dart' show DialogAction;
import '../../components/organisms/dialog_confirm_icon.dart';
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
/// [max] 는 옛 라우트(`/paywall/max`)를 살리려고 남긴 값이고 Premium 페이월을 그린다.
/// Pro 는 더 팔지 않는다 — `pro` 값과 `/paywall/pro` 라우트는 도달 경로가 없어
/// 09-26 지웠다(PM-DEC-010).
enum PaywallVariant {
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
  /// asks (「무료로 계속 쓸 수 있어요」), a second one leaves without nagging.
  bool _leaveGuardShown = false;

  /// 한도 진입인가(배너 + 한 줄 헤드라인 + 법적 링크). 나머지는 전부 같은 Premium 페이월.
  bool get _isLimit => widget.variant == PaywallVariant.proLimit;

  /// Back/X on a paywall — the deepest point a member can still walk away
  /// from a subscription, so leaving gets one retention prompt.
  ///
  /// Figma `paywall_exit_guard`(Mobile `6192:29141` · Tablet `6238:48555`, `Dialog/Confirm-Icon`)
  /// — 09-24 사장님 「Figma 대로 해」:
  /// - 위 「Get Premium」(primary_fill) → 결제 진행(`depth/purchase_processing`) — 아래 CTA 와 같은 곳.
  /// - 아래 「Maybe later」(secondary_fill) → **페이월을 바로 떠난다**(09-24 사장님 「응 그렇게 해」 —
  ///   처음엔 Figma BACK 대로 창만 닫았으나, 누르고도 X 를 한 번 더 눌러야 나가는 게 문제였다).
  /// - 스크림은 창만 닫는다(Figma BACK · 뜻을 밝히지 않은 동작을 나가기로 읽지 않는다).
  ///   한 번 보여 준 뒤의 back/X 는 묻지 않고 나간다.
  Future<void> _handleClose() async {
    if (_leaveGuardShown) {
      Navigator.pop(context);
      return;
    }
    _leaveGuardShown = true;
    final l10n = AppLocalizations.of(context);
    final choice = await showDialogConfirmIcon<bool>(
      context,
      icon: AppIcons.duoHeart(),
      title: l10n.paywallGuardTitle,
      description: l10n.paywallGuardBody,
      // 주요 버튼이 위인 예외(사장님 의도, 09-24).
      actions: [
        DialogAction(
          label: l10n.ctaGetPremium,
          type: BtnType.primaryFill,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        DialogAction(
          label: l10n.ctaMaybeLater,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
    if (!mounted) return;
    if (choice == true) {
      _startPurchase();
    } else if (choice == false) {
      Navigator.pop(context); // 「Maybe later」 — 페이월을 떠난다.
    }
  }

  /// 결제 진행 — 아래 CTA 와 이탈 방지 창의 「Get Premium」이 같은 곳으로 간다.
  ///
  /// Tier AND cycle travel as the route argument — the tier alone was the
  /// "bought Max, screen said Pro" bug, and a dropped cycle meant the annual
  /// selection quietly bought monthly.
  void _startPurchase() => Navigator.pushNamed(
        context,
        Routes.purchaseProcessing,
        arguments: (
          // 유료는 Premium 하나 — 상품·서버 코드는 `max` 그대로다.
          tier: SubscriptionTier.max,
          annual: _cycle == _Cycle.annual,
        ),
      );

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
                    // 히어로 = Bibi 영상 루프(09-23 사장님 결정). 정본 `image 1`
                    // (`4514:5491` · Tablet `6268:44867`) — 16:9 · 모서리 0 · 위아래 gap 24.
                    // 사용자가 고른 파트너와 무관하게 **항상 Bibi**다. 정본은 정지 이미지지만
                    // 영상 반복 재생으로 정했고, 영상 배경(연보라 회색)과 Figma 흰 배경의 톤
                    // 차이는 수용했다. 아바타 클립이 1280×720 이라 칸 비율과 같다.
                    LoopingVideo(
                      asset: 'assets/avatar/bibi/idle.mp4',
                      aspectRatio: AppLayout.videoAspect,
                      placeholderColor: c.backgroundSurfaceAlternative,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s24),
                  ..._planRows(l10n),
                  const SizedBox(height: AppSpacing.s24),
                  // 캐릭터는 구독에 들어 있지 않다(정본 v3.1). 「무제한」·공정사용 각주는 없앴다 —
                  // Premium 은 하루 합산 15분 · 그 안에서는 횟수 제한 없음(09-23 확정).
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
    // 정본 둘째 줄 「튜터 1시간 $25 · Premium 한 달 {price}」 (`4514:5489` · Tablet `6268:44851`)
    // — Header VERTICAL gap 8 · Label 1 Regular 14 · Label/Normal · FILL.
    // ⚠ $25 는 달러 고정 사실이고 옆 가격은 스토어 현지가다. 원화·루피 사용자에게는 서로 다른
    //   통화를 비교하는 문장이 되므로 가격이 USD 일 때만 그린다(남은판단 P12).
    return [
      Text(l10n.paywallMaxTitle,
          style: AppType.title2.sb.copyWith(color: c.labelStrong)),
      if (PlanPrices.maxQuotedInUsd) ...[
        const SizedBox(height: AppSpacing.s8),
        Text(l10n.paywallTutorCompare(PlanPrices.maxMonthly),
            style: AppType.label1.r.copyWith(color: c.labelNormal)),
      ],
    ];
  }

  /// Premium 카드 — 불릿 4개는 정본 고정(가치 사다리 §4-1 · 출시 게이트 5: 만들지 않은 것은
  /// 올리지 않는다 — 학습서·주간 리포트·「모든 캐릭터」 는 뺐다).
  Widget _planCard(AppLocalizations l10n, AppColorTokens c) {
    return PlanSummaryCard(
      title: l10n.planMax,
      price: PlanPrices.maxMonthly,
      perMonthUnit: l10n.perMonthUnit,
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
              onPressed: _startPurchase,
            ),
            const SizedBox(height: 6),
            Text(
              // 무료체험은 출시 때 끈다(정본 §8-2 · 스토어 「첫 주 무료」 오퍼 종료) — 체험 안내
              // 문구 분기는 뺐다. 오퍼가 남아 있으면 StoreKit 이 고지 없이 적용하므로 콘솔에서
              // 먼저 꺼야 한다(앱이 할 일이 아니다).
              // 고지는 **고른 주기**를 따른다(QA F040) — 연간을 골라도 「월 $23.99」 가 남아
              // 결제 직전 금액·주기 고지가 선택과 달랐다(App Review 3.1.2 · 과금 고지 오류).
              _cycle == _Cycle.annual
                  ? l10n.ctaCaptionMaxYearly(PlanPrices.maxYearly)
                  : l10n.ctaCaptionMax(PlanPrices.maxMonthly),
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

