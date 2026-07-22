import 'package:flutter/material.dart';

import '../../components/atoms/skeleton.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// PaymentHistoryLoading — the placeholder `PaymentHistoryScreen` shows while
/// `GET /payments` is in flight, replacing a bare centred spinner.
///
/// Same principle as [AvatarLoading]: hold the real screen's own layout with
/// bars for the server's words, so nothing jumps when the page lands. The
/// static parts stay real — the "이번 달 결제 금액" label and the 전체/구독/캐릭터
/// filter chips are constants, not response data, and blanking them would make
/// the screen say less than it already knows.
///
/// Everything measured here comes from `payment_history.dart` and [CardLine]'s
/// own payment layout (padding 12/8, label over a 7-gap meta, value/status
/// pinned right), not from a Figma loading frame — there isn't one. The three
/// rows and two absent month headers are a **guess about quantity**; the page
/// replaces them wholesale.
///
/// Must sit under a [SkeletonShimmer] (provided here).
class PaymentHistoryLoading extends StatelessWidget {
  /// Creates the payment-history loading screen.
  const PaymentHistoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SkeletonShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.s24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: _summaryCard(context, l10n),
            ),
            const SizedBox(height: AppSpacing.s8),
            _filterRow(context, l10n),
            const SizedBox(height: AppSpacing.s12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Month header (동적: "2026년 7월") → bar.
                  const SizedBox(
                    height: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Skeleton.bar(width: 84, height: 14),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  for (var i = 0; i < 3; i++) _row(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// "이번 달 결제 금액" card (`2117:20223`) — label real, the amount a bar sized
  /// to the `title3` (24) it renders in.
  Widget _summaryCard(BuildContext context, AppLocalizations l10n) => Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16,
          AppSpacing.s16,
          AppSpacing.s16,
          AppSpacing.s24,
        ),
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.thisMonthPayment, style: AppType.body1.r),
            const SizedBox(height: AppSpacing.s8),
            const SizedBox(
              height: 32,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Skeleton.bar(width: 120, height: 24),
              ),
            ),
          ],
        ),
      );

  /// The filter chips — static labels, so shown for real (unselected). Mirrors
  /// `payment_history.dart`'s `_filterRow`/`_chip`.
  Widget _filterRow(BuildContext context, AppLocalizations l10n) {
    final labels = [
      l10n.filterAll,
      l10n.filterSubscription,
      l10n.filterCharacter,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: 14,
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.s12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: context.c.backgroundNormalAlternative,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                labels[i],
                style: AppType.label1.sb.copyWith(color: context.c.labelNormal),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// One payment row at [CardLine]'s payment box: padding 12/8, a label bar over
  /// a 7-gap meta bar on the left, amount over status pinned right. No divider —
  /// the shimmer already separates the rows and a hairline would only add noise.
  Widget _row() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Skeleton.bar(width: 140, height: 14),
                  SizedBox(height: 7),
                  Skeleton.bar(width: 92, height: 12),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeleton.bar(width: 60, height: 14),
                SizedBox(height: 7),
                Skeleton.bar(width: 40, height: 12),
              ],
            ),
          ],
        ),
      );
}
