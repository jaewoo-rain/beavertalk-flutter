import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/benefit_row.dart';
import '../../components/organisms/gnb.dart';
import '../../core/format/dates.dart';
import '../../features/subscription/domain/entities/subscription_state.dart';
import '../../features/subscription/domain/subscription_status_resolver.dart';
import '../../features/subscription/presentation/providers/subscription_state_providers.dart';
import '../../features/subscription/domain/plan_prices.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Direction of a plan change.
enum PlanChangeDirection {
  /// `depth/plan_change_upgrade` (`4514:5552`) — Pro → Max. Applies
  /// immediately; unused Pro time is credited (proration mode: immediate,
  /// spec §11-3 decision).
  upgrade,

  /// `depth/plan_change_downgrade` (`4514:5582`) — Max → Pro. Applies at the
  /// end of the paid term; nothing changes today.
  downgrade,
}

/// The plan-change confirmation screens, both directions.
class PlanChangeScreen extends ConsumerWidget {
  /// Creates a plan-change screen.
  const PlanChangeScreen({super.key, required this.direction});

  /// Which way the plan moves.
  final PlanChangeDirection direction;

  String _date(BuildContext context, DateTime? d) =>
      d == null ? '—' : localizedFullDate(context, d);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final status = ref.watch(subscriptionStatusProvider);
    final date = _date(context, status.expiresAt);
    final up = direction == PlanChangeDirection.upgrade;
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
            title: l10n.changePlanTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              children: up
                  ? _upgradeBody(context, l10n, c, date)
                  : _downgradeBody(context, l10n, c, status, date),
            ),
          ),
          _cta(context, l10n, c, up),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  List<Widget> _upgradeBody(BuildContext context, AppLocalizations l10n,
      AppColorTokens c, String date) {
    return [
      Text(l10n.moveToMaxTitle,
          style: AppType.title3.sb.copyWith(color: c.labelStrong)),
      const SizedBox(height: AppSpacing.s24),
      // The gold Max intro card — 16/14 padding, 10 gap (measured).
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.statusCautionarySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.statusCautionary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.planMax,
                      style:
                          AppType.headline1.sb.copyWith(color: c.labelStrong)),
                ),
                Text(l10n.maxPriceShort(PlanPrices.maxMonthly),
                    style: AppType.body2.sb
                        .copyWith(color: c.accentForegroundOrange)),
              ],
            ),
            const SizedBox(height: 10),
            Text(l10n.moveToMaxCardSub,
                style: AppType.label2.r.copyWith(color: c.labelNormal)),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.s24),
      _sectionTitle(c, l10n.whatHappensNow),
      const SizedBox(height: AppSpacing.s16),
      _rowsCard(c, [
        (l10n.maxStartsLabel, l10n.immediately),
        (l10n.unusedProTime, l10n.creditedTowardMax),
        (
          l10n.nextPaymentLabel,
          l10n.nextPaymentMaxValue(PlanPrices.maxMonthly, date)
        ),
      ]),
    ];
  }

  List<Widget> _downgradeBody(BuildContext context, AppLocalizations l10n,
      AppColorTokens c, SubscriptionStatus status, String date) {
    final shortDate = status.expiresAt == null
        ? '—'
        : localizedShortDate(context, status.expiresAt!);
    return [
      Text(l10n.moveToProTitle,
          style: AppType.title3.sb.copyWith(color: c.labelStrong)),
      const SizedBox(height: AppSpacing.s24),
      Text(l10n.moveToProSub,
          style: AppType.label1.r.copyWith(color: c.labelNormal)),
      const SizedBox(height: AppSpacing.s24),
      _sectionTitle(c, l10n.whatHappensNow),
      const SizedBox(height: AppSpacing.s16),
      _rowsCard(c, [
        (l10n.maxRunsUntil, date),
        (l10n.proStarts, date),
        (
          l10n.nextPaymentLabel,
          l10n.nextPaymentProValue(PlanPrices.proMonthly, date)
        ),
      ]),
      const SizedBox(height: AppSpacing.s24),
      _sectionTitle(c, l10n.whatYouKeep),
      const SizedBox(height: AppSpacing.s16),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: c.backgroundSurfaceAlternative,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BenefitRow(label: l10n.keepBenefitCalls),
            const SizedBox(height: AppSpacing.s12),
            BenefitRow(label: l10n.keepBenefitCharacters),
            const SizedBox(height: AppSpacing.s12),
            Container(height: 1, color: c.lineAlternative),
            const SizedBox(height: AppSpacing.s12),
            Text(
              l10n.downgradeWarning(shortDate),
              style: AppType.label2.r
                  .copyWith(color: c.accentForegroundOrange),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _sectionTitle(AppColorTokens c, String text) =>
      Text(text, style: AppType.body1.sb.copyWith(color: c.labelStrong));

  Widget _rowsCard(AppColorTokens c, List<(String, String)> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.backgroundSurfaceAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) ...[
              const SizedBox(height: 10),
              Container(height: 1, color: c.lineAlternative),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: Text(rows[i].$1,
                      style:
                          AppType.label1.r.copyWith(color: c.labelNormal)),
                ),
                const SizedBox(width: 8),
                // Flexible + ellipsis: long localized values (dates, "billed
                // once a year" lines) overflowed the 320px sweep.
                Flexible(
                  child: Text(rows[i].$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style:
                          AppType.label1.r.copyWith(color: c.labelStrong)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _cta(BuildContext context, AppLocalizations l10n, AppColorTokens c,
      bool up) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20, AppSpacing.s12, AppSpacing.s20, 0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.lineAlternative)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Button(
            type: up ? BtnType.gold : BtnType.primaryFill,
            size: BtnSize.s60,
            text: up ? l10n.ctaSwitchToMax : l10n.ctaSwitchToPro,
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.purchaseProcessing,
              arguments:
                  up ? SubscriptionTier.max : SubscriptionTier.pro,
            ),
          ),
          const SizedBox(height: 6),
          if (up)
            Text(
              l10n.upgradeCaption,
              textAlign: TextAlign.center,
              style: AppType.caption1.r.copyWith(color: c.labelNormal),
            )
          else
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s60,
              text: l10n.ctaKeepMax,
              onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}

/// `depth/winback_survey` (`4514:5615`) — the exit survey after a lapse.
///
/// Skip bar instead of a GNB; five single-select reasons; `Send` submits (a
/// server hook, later), `Not now` just leaves. Nothing here touches
/// subscription state — the caption says so out loud.
class WinbackSurveyScreen extends StatefulWidget {
  /// Creates the winback survey.
  const WinbackSurveyScreen({super.key});

  @override
  State<WinbackSurveyScreen> createState() => _WinbackSurveyScreenState();
}

class _WinbackSurveyScreenState extends State<WinbackSurveyScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final reasons = [
      l10n.winbackReasonExpensive,
      l10n.winbackReasonUnused,
      l10n.winbackReasonMissing,
      l10n.winbackReasonOtherApp,
      l10n.winbackReasonElse,
    ];
    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Text(l10n.winbackSkip,
                        style: AppType.body1.sb
                            .copyWith(color: c.labelNormal)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.s20,
                  AppSpacing.s24, AppSpacing.s20, AppSpacing.s24),
              children: [
                Text(l10n.winbackTitle,
                    style: AppType.title3.sb.copyWith(color: c.labelStrong)),
                const SizedBox(height: AppSpacing.s8),
                Text(l10n.winbackSub,
                    style: AppType.body2.r.copyWith(color: c.labelNormal)),
                const SizedBox(height: AppSpacing.s24),
                Text(l10n.winbackQuestion,
                    style: AppType.body1.sb.copyWith(color: c.labelStrong)),
                const SizedBox(height: AppSpacing.s16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: c.backgroundSurfaceAlternative,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < reasons.length; i++)
                        _ReasonRow(
                          label: reasons[i],
                          selected: _selected == i,
                          last: i == reasons.length - 1,
                          onTap: () => setState(() => _selected = i),
                        ),
                    ],
                  ),
                ),
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
                  type: BtnType.primaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaSend,
                  // TODO(server): submit the reason once an endpoint exists.
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: AppSpacing.s8),
                Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: l10n.ctaNotNow,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.winbackCaption,
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

/// One 56px single-select row with the 22px radio, last row divider-free.
class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.label,
    required this.selected,
    required this.last,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return GestureDetector(
      onTap: onTap,
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
              child: Text(label,
                  style:
                      AppType.label1.r.copyWith(color: c.commonWhiteAndDark)),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: selected
                  ? BoxDecoration(
                      shape: BoxShape.circle, color: c.primaryNormal)
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.backgroundNormalAlternative,
                      border: Border.all(color: c.labelAlternative),
                    ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.primaryOnPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
