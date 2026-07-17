import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
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
///   (`Accent/Foreground/Red`) "취소 시 잃게 되는 혜택" card. Footer = single 구독 취소.
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
/// host card (mint for active plans, `Accent/Foreground/Red` for the cancel warning).
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

  /// Next-billing date (e.g. "2026.06.20."), rendered in `Primary/Normal`.
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

  /// Whether to draw the `Primary/Normal` (vs `Line/Alternative`)
  /// border. The active/Pro card is highlighted.
  final bool highlighted;

  /// Whether to show the "이용 중" pill (primary_outline) on the right.
  final bool active;
}

/// BottomSheetSubscription — subscription-management sheet, measured 1:1 from
/// Figma `BottomSheet-Subscription` (`176:14577`).
///
/// A bottom-anchored 375-wide sheet on `Background/Elevated/Alternative` with a top
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
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context, l10n),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: _body(context, l10n),
          ),
          _footer(context, l10n),
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
  Widget _header(BuildContext context, AppLocalizations l10n) {
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
              style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
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
  Widget _body(BuildContext context, AppLocalizations l10n) {
    switch (type) {
      case SubscriptionSheetType.manage:
        return _manageBody(context, l10n);
      case SubscriptionSheetType.changePlan:
        return _changePlanBody(context, l10n);
      case SubscriptionSheetType.cancel:
        return _cancelBody(context, l10n);
    }
  }

  Widget _manageBody(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (plan != null) _planCard(context, plan!, l10n),
        if (benefits.isNotEmpty) ...[
          const SizedBox(height: 16),
          _section(context, l10n.benefitsInUse, [
            for (final b in benefits)
              _benefitLine(context, b.label, context.c.primaryNormal24, AppColors.text),
          ]),
        ],
        if (paymentRows.isNotEmpty) ...[
          const SizedBox(height: 16),
          _section(context, l10n.paymentInfo, [
            for (final r in paymentRows) _kvRow(context, r.label, r.value),
          ]),
        ],
      ],
    );
  }

  Widget _planCard(BuildContext context, SubscriptionPlanInfo plan, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: context.c.primaryNormal),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            plan.name,
            style: AppType.heading2.sb.copyWith(color: context.c.labelStrong),
          ),
          const SizedBox(height: 4),
          Text(
            plan.priceLine,
            style: AppType.body1.r.copyWith(color: context.c.labelNormal),
          ),
          if (plan.nextBillingDate != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                // Label absorbs the slack; the date keeps its intrinsic width.
                // Both were Flexible(flex: 1), which hands each exactly half the
                // row no matter how short one is — so a long label clipped while
                // the date sat on unused space (and vice versa).
                Expanded(
                  child: Text(
                    plan.nextBillingLabel ?? l10n.nextBillingDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body1.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  plan.nextBillingDate!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body1.r.copyWith(color: context.c.primaryNormal),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _changePlanBody(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note != null)
          Text(
            note!,
            style: AppType.label1.r.copyWith(color: context.c.labelStrong),
          ),
        const SizedBox(height: 8),
        for (var i = 0; i < planOptions.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _planOptionCard(context, planOptions[i], l10n),
        ],
      ],
    );
  }

  Widget _planOptionCard(BuildContext context, SubscriptionPlanOption option, AppLocalizations l10n) {
    final bulletColor =
        option.highlighted ? context.c.primaryNormal : AppColors.text;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color:
              option.highlighted ? context.c.primaryNormal : context.c.lineAlternative,
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
                      style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
                    ),
                    if (option.priceLine != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        option.priceLine!,
                        style: AppType.label1.r
                            .copyWith(color: context.c.labelNormal),
                      ),
                    ],
                  ],
                ),
              ),
              // Non-flex: the name Column is Expanded (absorbs slack), so the
              // pill stays hugged to the right. Wrapping it in Flexible made the
              // two split the row 50/50, floating the pill toward the middle.
              if (option.active) _activePill(context, l10n),
            ],
          ),
          if (option.benefits.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final b in option.benefits)
              _benefitLine(context, b.label, bulletColor, AppColors.text),
          ],
        ],
      ),
    );
  }

  /// "In use" pill — primary_outline size 36.
  Widget _activePill(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: context.c.primaryNormal),
      ),
      child: Text(
        l10n.inUse,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.label2.sb.copyWith(color: context.c.primaryNormal),
      ),
    );
  }

  Widget _cancelBody(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note != null)
          Text(
            note!,
            style: AppType.label1.r.copyWith(color: context.c.labelStrong),
          ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: context.c.accentForegroundRed),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lostBenefitsTitle ?? l10n.lostBenefitsTitle,
                style: AppType.label1.r.copyWith(color: context.c.accentForegroundRed),
              ),
              const SizedBox(height: 8),
              for (final b in lostBenefits)
                _benefitLine(context, b.label, context.c.accentForegroundRed, AppColors.text,
                    lost: true),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared bits ──────────────────────────────────────────────────────────
  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppType.label1.sb.copyWith(color: context.c.labelNormal),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  /// A bullet + label (in [labelColor]) with the glyph in [bulletColor].
  ///
  /// [lost] flips the glyph from a check to an ×. The cancel sheet lists
  /// "취소 시 잃게 되는 혜택" — benefits you give up — so a check there read as
  /// "kept", the opposite of the intent. Figma `176:14575` marks those rows ×.
  Widget _benefitLine(context, 
    String label,
    Color bulletColor,
    Color labelColor, {
    bool lost = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lost
              ? AppIcons.close(size: 16, color: bulletColor)
              : AppIcons.check(size: 16, color: bulletColor),
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

  Widget _kvRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Same fix as the plan card's billing row: an even Flexible split gave
          // "결제 수단" half the row and clipped "Visa 1234" beside empty space.
          // Label takes the slack; the value keeps its natural width.
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.label1.r.copyWith(color: context.c.labelStrong),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.label1.r.copyWith(color: context.c.labelStrong),
          ),
        ],
      ),
    );
  }

  // ── Footer per type ───────────────────────────────────────────────────────
  Widget _footer(BuildContext context, AppLocalizations l10n) {
    switch (type) {
      case SubscriptionSheetType.manage:
        return _stackedButtons(context, l10n.changePlan, l10n.viewBillingHistory);
      case SubscriptionSheetType.changePlan:
        return _stackedButtons(context, l10n.cancelSubscription, l10n.keepUsingPro);
      case SubscriptionSheetType.cancel:
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Button(
            // Figma `176:14575` fills this button with `#252932` (surface2) —
            // that is `secondaryFill`, and it matches the other two sheets'
            // footers. `secondaryWhite` fills with `surfaceElevated`, the very
            // colour of the sheet behind it, so the button read as a bare
            // outline instead of a filled control.
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: l10n.cancelSubscription,
            onPressed: onPrimary,
          ),
        );
    }
  }

  /// Two stacked secondary_fill buttons (each in its own 12-top-padded slot,
  /// matching the Figma `two-button-col` layout).
  Widget _stackedButtons(BuildContext context, String primary, String secondary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // Without this the Column defaults to CrossAxisAlignment.center, which
      // lets each Button hug its label and float centred — the footer CTAs are
      // full-width (fill) like every other sheet action. Every other Column in
      // this file already stretches; this one was the outlier.
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
      color: context.c.backgroundNormalDeep,
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
                        .copyWith(color: context.c.labelNormal),
                  ),
                ),
              ),
              SizedBox(
                height: h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: context.c.materialDim),
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
