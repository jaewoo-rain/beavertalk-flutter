import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';

/// Which subscription flow a [BottomSheetSubscription] presents.
///
/// Maps 1:1 to the Figma `BottomSheet-Subscription` component set (`176:14577`):
/// - [manage] — `type=manage` (title "구독 관리"): current-plan card (primary
///   border) + 사용 중인 혜택 list + 결제 정보 rows. Footer = 플랜 변경 +
///   결제내역 보기 (two stacked buttons).
/// - [changePlan] — `type=change-plan` (title "플랜 변경"): a note paragraph + a
///   Free card (subtle border) and a Pro card (primary border, "이용 중" pill).
///   Footer = 구독 취소 + Pro 계속 사용하기.
/// - [cancel] — `type=cancel` (title "구독 취소"): a note paragraph + a red-border
///   ([AppColors.error]) "취소 시 잃게 되는 혜택" card. Footer = single 구독 취소.
enum SubscriptionSheetType {
  /// Manage the active subscription.
  manage,

  /// Compare Free vs Pro plans.
  changePlan,

  /// Confirm cancellation (lost-benefits warning).
  cancel,
}

/// A single plan benefit line (a colored bullet + label).
///
/// Used by all three [SubscriptionSheetType]s; the bullet color is set by the
/// host card (mint for active plans, [AppColors.error] for the cancel warning).
class SubscriptionBenefit {
  /// Creates a benefit line with the given [label].
  const SubscriptionBenefit(this.label);

  /// The benefit text (e.g. "무제한 통화").
  final String label;
}

/// Description of the currently-active plan, shown in [SubscriptionSheetType.manage].
class SubscriptionPlanInfo {
  /// Creates plan info.
  const SubscriptionPlanInfo({
    required this.name,
    required this.priceLine,
    this.nextBillingLabel,
    this.nextBillingDate,
  });

  /// Plan name (e.g. "Pro Membership"), Heading 2 Bold.
  final String name;

  /// Price / renewal line (e.g. "\$12.9 / mo"), Body 1 Regular secondary.
  final String priceLine;

  /// Left label of the next-billing row; falls back to the localized
  /// "Next billing date" when null.
  final String? nextBillingLabel;

  /// Next-billing date (e.g. "2026.06.20."), rendered in [AppColors.primary].
  /// When null the row is omitted.
  final String? nextBillingDate;
}

/// A `(label, value)` payment-info row for [SubscriptionSheetType.manage].
typedef PaymentInfoRow = ({String label, String value});

/// A plan option (Free / Pro) shown in [SubscriptionSheetType.changePlan].
class SubscriptionPlanOption {
  /// Creates a plan option.
  const SubscriptionPlanOption({
    required this.name,
    this.priceLine,
    required this.benefits,
    this.highlighted = false,
    this.active = false,
  });

  /// Plan name (e.g. "Free" / "Pro"), Body 1 Bold white.
  final String name;

  /// Optional price line (e.g. "\$ 12.9 / 월"), Body 1 Regular secondary.
  final String? priceLine;

  /// Benefit lines for this plan.
  final List<SubscriptionBenefit> benefits;

  /// Whether to draw the [AppColors.primary] (vs [AppColors.borderSubtle])
  /// border. The active/Pro card is highlighted.
  final bool highlighted;

  /// Whether to show the "이용 중" pill (primary_outline) on the right.
  final bool active;
}

/// BottomSheetSubscription — subscription-management sheet, measured 1:1 from
/// Figma `BottomSheet-Subscription` (`176:14577`).
///
/// A bottom-anchored 375-wide sheet on [AppColors.surfaceElevated] with a top
/// [AppRadius.lg] corner radius. Composition (top → bottom):
/// 1. A header bar with a [_title] (Body 1 Bold white, centered) and a trailing
///    close (✕) wired to [onClose].
/// 2. A body (`16 20 24` padding) whose content depends on [type] — see
///    [SubscriptionSheetType].
/// 3. A footer of [Button]s (60-size) per type, then a [HomeIndicator]
///    (`sub-transparent`).
///
/// Renders only the sheet surface. Use [asModal] for the full Dim + sheet
/// overlay in a [Stack].
class BottomSheetSubscription extends StatelessWidget {
  /// Creates the subscription sheet surface.
  const BottomSheetSubscription({
    super.key,
    required this.type,
    this.plan,
    this.benefits = const [],
    this.paymentRows = const [],
    this.planOptions = const [],
    this.note,
    this.lostBenefits = const [],
    this.lostBenefitsTitle,
    this.onPrimary,
    this.onSecondary,
    this.onClose,
  });

  /// Which flow to render.
  final SubscriptionSheetType type;

  /// Active-plan card data for [SubscriptionSheetType.manage].
  final SubscriptionPlanInfo? plan;

  /// "사용 중인 혜택" list for [SubscriptionSheetType.manage].
  final List<SubscriptionBenefit> benefits;

  /// "결제 정보" rows for [SubscriptionSheetType.manage].
  final List<PaymentInfoRow> paymentRows;

  /// Plan options (Free / Pro) for [SubscriptionSheetType.changePlan].
  final List<SubscriptionPlanOption> planOptions;

  /// Intro paragraph for change-plan / cancel (Label 1 Regular white).
  final String? note;

  /// Lost-benefit lines for [SubscriptionSheetType.cancel].
  final List<SubscriptionBenefit> lostBenefits;

  /// Title of the cancel warning card; falls back to the localized default
  /// when null.
  final String? lostBenefitsTitle;

  /// Primary footer action: 플랜 변경 (manage) / 구독 취소 (change-plan & cancel).
  final VoidCallback? onPrimary;

  /// Secondary footer action: 결제내역 보기 (manage) / Pro 계속 사용하기 (change-plan).
  final VoidCallback? onSecondary;

  /// Close / dismiss action: the header ✕ and the scrim.
  final VoidCallback? onClose;

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap; the
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double maxWidth = 430;

  String _title(AppLocalizations l10n) {
    switch (type) {
      case SubscriptionSheetType.manage:
        return l10n.subscriptionManage;
      case SubscriptionSheetType.changePlan:
        return l10n.changePlan;
      case SubscriptionSheetType.cancel:
        return l10n.cancelSubscription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(l10n),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: _body(l10n),
          ),
          _footer(l10n),
          // Bottom safe-area inset — clears the real OS gesture bar (replaces
          // the former embedded fake HomeIndicator).
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Header (GNB sub-2: centered title + trailing close) ──────────────────
  Widget _header(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const SizedBox(width: 28, height: 28),
          Expanded(
            child: Text(
              _title(l10n),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.body1.sb.copyWith(color: AppColors.text),
            ),
          ),
          Semantics(
            button: true,
            label: l10n.close,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 28,
                height: 28,
                child: AppIcons.close(size: 24, color: AppColors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Body per type ────────────────────────────────────────────────────────
  Widget _body(AppLocalizations l10n) {
    switch (type) {
      case SubscriptionSheetType.manage:
        return _manageBody(l10n);
      case SubscriptionSheetType.changePlan:
        return _changePlanBody(l10n);
      case SubscriptionSheetType.cancel:
        return _cancelBody(l10n);
    }
  }

  Widget _manageBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (plan != null) _planCard(plan!, l10n),
        if (benefits.isNotEmpty) ...[
          const SizedBox(height: 16),
          _section(l10n.benefitsInUse, [
            for (final b in benefits)
              _benefitLine(b.label, AppColors.primary24, AppColors.text),
          ]),
        ],
        if (paymentRows.isNotEmpty) ...[
          const SizedBox(height: 16),
          _section(l10n.paymentInfo, [
            for (final r in paymentRows) _kvRow(r.label, r.value),
          ]),
        ],
      ],
    );
  }

  Widget _planCard(SubscriptionPlanInfo plan, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            plan.name,
            style: AppType.heading2.sb.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: 4),
          Text(
            plan.priceLine,
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
          ),
          if (plan.nextBillingDate != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    plan.nextBillingLabel ?? l10n.nextBillingDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    plan.nextBillingDate!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppType.body1.r.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _changePlanBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note != null)
          Text(
            note!,
            style: AppType.label1.r.copyWith(color: AppColors.text),
          ),
        const SizedBox(height: 8),
        for (var i = 0; i < planOptions.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _planOptionCard(planOptions[i], l10n),
        ],
      ],
    );
  }

  Widget _planOptionCard(SubscriptionPlanOption option, AppLocalizations l10n) {
    final bulletColor =
        option.highlighted ? AppColors.primary : AppColors.text;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color:
              option.highlighted ? AppColors.primary : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.name,
                      style: AppType.body1.sb.copyWith(color: AppColors.text),
                    ),
                    if (option.priceLine != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        option.priceLine!,
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              if (option.active) Flexible(child: _activePill(l10n)),
            ],
          ),
          if (option.benefits.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final b in option.benefits)
              _benefitLine(b.label, bulletColor, AppColors.text),
          ],
        ],
      ),
    );
  }

  /// "In use" pill — primary_outline size 36.
  Widget _activePill(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: AppColors.primary),
      ),
      child: Text(
        l10n.inUse,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.label2.sb.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _cancelBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note != null)
          Text(
            note!,
            style: AppType.label1.r.copyWith(color: AppColors.text),
          ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: AppColors.error),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lostBenefitsTitle ?? l10n.lostBenefitsTitle,
                style: AppType.label1.r.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: 8),
              for (final b in lostBenefits)
                _benefitLine(b.label, AppColors.error, AppColors.text),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared bits ──────────────────────────────────────────────────────────
  Widget _section(String title, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppType.label1.sb.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  /// A bullet (✓/×-style glyph in [bulletColor]) + label (in [labelColor]).
  Widget _benefitLine(String label, Color bulletColor, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcons.check(size: 16, color: bulletColor),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: AppType.label1.r.copyWith(color: labelColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kvRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.label1.r.copyWith(color: AppColors.text),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppType.label1.r.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer per type ───────────────────────────────────────────────────────
  Widget _footer(AppLocalizations l10n) {
    switch (type) {
      case SubscriptionSheetType.manage:
        return _stackedButtons(l10n.changePlan, l10n.viewBillingHistory);
      case SubscriptionSheetType.changePlan:
        return _stackedButtons(l10n.cancelSubscription, l10n.keepUsingPro);
      case SubscriptionSheetType.cancel:
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Button(
            type: BtnType.secondaryWhite,
            size: BtnSize.s60,
            text: l10n.cancelSubscription,
            onPressed: onPrimary,
          ),
        );
    }
  }

  /// Two stacked secondary_fill buttons (each in its own 12-top-padded slot,
  /// matching the Figma `two-button-col` layout).
  Widget _stackedButtons(String primary, String secondary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: primary,
            onPressed: onPrimary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: secondary,
            onPressed: onSecondary,
          ),
        ),
      ],
    );
  }

  /// Full modal overlay: a [Dim] scrim with the sheet bottom-anchored.
  Widget asModal() {
    return Dim(
      onTap: onClose,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(child: this),
      ),
    );
  }
}

/// Gallery demo: every [SubscriptionSheetType], each bottom-anchored over a dim
/// backdrop in a [Stack].
class BottomSheetSubscriptionDemo extends StatelessWidget {
  /// Creates the demo.
  const BottomSheetSubscriptionDemo({super.key});

  static const _note =
      '2026년 6월 20일까지 Pro 혜택을 계속 사용할 수 있고 그 이후 자동으로 무료 플랜으로 전환됩니다.';

  BottomSheetSubscription _sheet(SubscriptionSheetType type) {
    switch (type) {
      case SubscriptionSheetType.manage:
        return BottomSheetSubscription(
          type: type,
          plan: const SubscriptionPlanInfo(
            name: 'Pro 멤버십',
            priceLine: '\$ 12.9 / 월 자동 갱신',
            nextBillingDate: '2026.06.20.',
          ),
          benefits: const [
            SubscriptionBenefit('무제한 통화'),
            SubscriptionBenefit('상세 발음 및 문법 분석'),
            SubscriptionBenefit('모든 캐릭터 사용 가능'),
            SubscriptionBenefit('광고 제거'),
          ],
          paymentRows: const [
            (label: '결제 수단', value: 'Visa 1234'),
            (label: '최근 결제', value: '2026.05.20.'),
          ],
          onPrimary: () {},
          onSecondary: () {},
          onClose: () {},
        );
      case SubscriptionSheetType.changePlan:
        return BottomSheetSubscription(
          type: type,
          note: _note,
          planOptions: const [
            SubscriptionPlanOption(
              name: 'Free',
              benefits: [
                SubscriptionBenefit('하루 1통화 · 5분 제한'),
                SubscriptionBenefit('기본 캐릭터 사용 가능'),
              ],
            ),
            SubscriptionPlanOption(
              name: 'Pro',
              priceLine: '\$ 12.9 / 월',
              highlighted: true,
              active: true,
              benefits: [
                SubscriptionBenefit('무제한 통화'),
                SubscriptionBenefit('상세 발음 및 문법 분석'),
                SubscriptionBenefit('모든 캐릭터 사용 가능'),
                SubscriptionBenefit('광고 제거'),
              ],
            ),
          ],
          onPrimary: () {},
          onSecondary: () {},
          onClose: () {},
        );
      case SubscriptionSheetType.cancel:
        return BottomSheetSubscription(
          type: type,
          note: _note,
          lostBenefits: const [
            SubscriptionBenefit('무제한 통화'),
            SubscriptionBenefit('상세 발음 및 문법 분석'),
            SubscriptionBenefit('모든 캐릭터 사용 가능'),
          ],
          onPrimary: () {},
          onClose: () {},
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    const items = <(String, SubscriptionSheetType, double)>[
      ('manage', SubscriptionSheetType.manage, 640),
      ('change-plan', SubscriptionSheetType.changePlan, 700),
      ('cancel', SubscriptionSheetType.cancel, 560),
    ];
    return ColoredBox(
      color: AppColors.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final (label, type, h) in items) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: AppType.label2.sb
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              SizedBox(
                height: h,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: ColoredBox(color: AppColors.scrim),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _sheet(type),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
