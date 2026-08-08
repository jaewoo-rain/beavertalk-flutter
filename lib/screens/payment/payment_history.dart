import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/app_scaffold.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/money.dart';
import '../../components/atoms/pressable.dart';
import '../../components/molecules/card_line.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/gnb.dart';
import '../../features/payment/domain/entities/payment.dart';
import '../../features/payment/presentation/providers/payment_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import 'payment_history_loading.dart';

/// Payment history — Figma `screen/main_mypage_payment` (`2117:20206`).
///
/// A back-only GNB (the design's title is `opacity-0`) over: a summary card
/// ("이번 달 결제 금액" + month total + next-billing line), a filter chip row
/// (전체 / 구독 / 캐릭터), then transactions grouped by month, each rendered as a
/// [CardLine] of [CardLineType.payment].
///
/// Backed by `GET /payments?type=&page=` — the tab chips map 1:1 onto the
/// server's `type` filter, so switching tabs refetches rather than filtering
/// client-side (the server pages at 10 and only the active tab's page is held).
class PaymentHistoryScreen extends ConsumerStatefulWidget {
  /// Creates the payment-history screen.
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  PaymentFilter _filter = PaymentFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(paymentPageProvider(_filter));

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Figma: the GNB title is opacity-0 — back arrow only.
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          Expanded(
            child: async.when(
              // The page's own layout held with bars, not a spinner in an empty
              // screen, so the summary and rows don't jump in when they land.
              loading: () => const PaymentHistoryLoading(),
              // Was the only one of the seven that dropped the server's reason
              // and always showed the generic copy. Aligned with the rest.
              error: (e, _) => NetworkErrorView(
                message: e is AppException ? e.message : l10n.paymentsLoadError,
                onRetry: () => ref.invalidate(paymentPageProvider(_filter)),
              ),
              data: (page) => _body(l10n, page),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(AppLocalizations l10n, PaymentPage page) {
    final locale = Localizations.localeOf(context).toString();
    final groups = _groupByMonth(page.items);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: _summaryCard(l10n, page.monthTotal, locale),
          ),
          const SizedBox(height: AppSpacing.s8),
          _filterRow(l10n),
          const SizedBox(height: AppSpacing.s12),
          if (groups.isEmpty)
            // Placed, not centered: this sits in the scrolling page below the
            // summary card and filter chips. The 80 gap is the Figma one
            // (`4864:9331` puts Empty at y152 under a 72-tall filter rail).
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s80),
              child: EmptyBlock(body: l10n.noPayments),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var g = 0; g < groups.length; g++) ...[
                    if (g > 0) const SizedBox(height: AppSpacing.s12),
                    _monthGroup(l10n, groups[g], locale),
                  ],
                ],
              ),
            ),
          // The server pages at 10 (`has_more`); surfaced rather than silently
          // truncating the list. Load-more is not wired yet — see the handoff.
          if (page.hasMore) ...[
            const SizedBox(height: AppSpacing.s16),
            Text(
              l10n.morePaymentsExist,
              textAlign: TextAlign.center,
              style: AppType.label2.r.copyWith(color: context.c.labelDisabled),
            ),
          ],
        ],
      ),
    );
  }

  /// "이번 달 결제 금액" card (Figma `2117:20223`).
  Widget _summaryCard(AppLocalizations l10n, int monthTotal, String locale) {
    return Container(
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
          Text(_money(monthTotal, locale), style: AppType.title3.b),
        ],
      ),
    );
  }

  /// Filter chips (Figma `2117:20237`): fill `surface2` in both states — only
  /// the label colour changes.
  Widget _filterRow(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: 14,
      ),
      child: Row(
        children: [
          for (final f in PaymentFilter.values) ...[
            if (f != PaymentFilter.values.first)
              const SizedBox(width: AppSpacing.s12),
            _chip(_filterLabel(f, l10n), selected: _filter == f, onTap: () {
              if (_filter != f) setState(() => _filter = f);
            }),
          ],
        ],
      ),
    );
  }

  String _filterLabel(PaymentFilter f, AppLocalizations l10n) => switch (f) {
        PaymentFilter.all => l10n.filterAll,
        PaymentFilter.subscribe => l10n.filterSubscription,
        PaymentFilter.character => l10n.filterCharacter,
      };

  Widget _chip(String label,
      {required bool selected, required VoidCallback onTap}) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: context.c.backgroundNormalAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: AnimatedDefaultTextStyle(
          duration: AppMotion.fast,
          curve: AppMotion.toggle,
          style: AppType.label1.sb.copyWith(
            color: selected ? context.c.labelStrong : context.c.labelNormal,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  /// Groups by calendar month, newest first. Rows with no `payment_date` can't
  /// be bucketed, so they collect under a null key rendered last.
  List<MapEntry<DateTime?, List<Payment>>> _groupByMonth(List<Payment> items) {
    final byMonth = <DateTime?, List<Payment>>{};
    for (final p in items) {
      final d = p.date;
      final key = d == null ? null : DateTime(d.year, d.month);
      byMonth.putIfAbsent(key, () => []).add(p);
    }
    final dated = byMonth.entries.where((e) => e.key != null).toList()
      ..sort((a, b) => b.key!.compareTo(a.key!));
    final undated = byMonth.entries.where((e) => e.key == null);
    return [...dated, ...undated];
  }

  Widget _monthGroup(
    AppLocalizations l10n,
    MapEntry<DateTime?, List<Payment>> group,
    String locale,
  ) {
    final rows = group.value;
    final key = group.key;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          // Locale-aware: this screen renders in 30 locales.
          key == null ? l10n.undatedPayments : intl.DateFormat.yMMMM(locale).format(key),
          style: AppType.label1.r.copyWith(color: context.c.labelNormal),
        ),
        const SizedBox(height: AppSpacing.s8),
        for (var i = 0; i < rows.length; i++)
          _row(l10n, rows[i], locale, showDivider: i < rows.length - 1),
      ],
    );
  }

  Widget _row(
    AppLocalizations l10n,
    Payment p,
    String locale, {
    required bool showDivider,
  }) {
    // `description` and `card_info` are server-authored and nullable; a row with
    // neither still shows its amount rather than being dropped.
    final date = p.date;
    final meta = [
      if (date != null) intl.DateFormat.MMMd(locale).format(date),
      if (p.cardInfo != null && p.cardInfo!.isNotEmpty) p.cardInfo!,
    ].join('·'); // CardLine splits on `·` into dot-separated segments.

    return CardLine(
      type: CardLineType.payment,
      label: p.description ?? _categoryLabel(l10n, p.category),
      meta: meta.isEmpty ? null : meta,
      value: _money(p.price, locale),
      status: l10n.statusCompleted,
      showDivider: showDivider,
    );
  }

  /// Fallback label when the server sends no description.
  String _categoryLabel(AppLocalizations l10n, PaymentCategory c) =>
      switch (c) {
        PaymentCategory.subscribe => l10n.filterSubscription,
        PaymentCategory.character => l10n.filterCharacter,
        PaymentCategory.unknown => l10n.paymentLabelFallback,
      };

  /// Formats USD cents as "$10" — the same convention as the avatar and
  /// checkout screens (`avatar.dart` `_priceLabel`).
  ///
  /// Zero renders as "$0", not "Free": that label belongs to a free *product*
  /// (`priceFree` on a character card). A month with no charges has a total of
  /// zero — calling it "Free" reads as if the plan itself were free. This is
  /// why the shared [formatUsd] never returns the "Free" wording itself.
  String _money(int minor, String locale) => formatUsd(minor, locale: locale);
}

