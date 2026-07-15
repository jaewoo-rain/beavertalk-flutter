import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/app_scaffold.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/pressable.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/gnb.dart';
import '../../features/payment/domain/entities/payment.dart';
import '../../features/payment/presentation/providers/payment_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

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
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Figma: the GNB title is opacity-0 — back arrow only.
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          Expanded(
            child: async.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => _ErrorState(
                message: l10n.paymentsLoadError,
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
            child: _summaryCard(l10n, page.monthTotal),
          ),
          const SizedBox(height: AppSpacing.s8),
          _filterRow(l10n),
          const SizedBox(height: AppSpacing.s12),
          if (groups.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s80),
              child: Text(
                l10n.noPayments,
                textAlign: TextAlign.center,
                style:
                    AppType.label1.r.copyWith(color: AppColors.textSecondary),
              ),
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
              style: AppType.label2.r.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ],
      ),
    );
  }

  /// "이번 달 결제 금액" card (Figma `2117:20223`).
  Widget _summaryCard(AppLocalizations l10n, int monthTotal) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s24,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.thisMonthPayment, style: AppType.body1.r),
          const SizedBox(height: AppSpacing.s8),
          Text(_money(l10n, monthTotal), style: AppType.title3.b),
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
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: AnimatedDefaultTextStyle(
          duration: AppMotion.fast,
          curve: AppMotion.toggle,
          style: AppType.label1.sb.copyWith(
            color: selected ? AppColors.text : AppColors.textSecondary,
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
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
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
      value: _money(l10n, p.price),
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

  /// Formats whole currency units as "₩4,900" — the same convention as the
  /// avatar and checkout screens (`avatar.dart` `_priceLabel`).
  ///
  /// Zero renders as "₩0", not "무료": that label belongs to a free *product*
  /// (`priceFree` on a character card). A month with no charges has a total of
  /// zero — calling it "무료" reads as if the plan itself were free.
  String _money(AppLocalizations l10n, int amount) {
    final digits = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '₩$buf';
  }
}

/// Load failure + retry, matching the avatar screen's error state.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppType.body2.r.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s16),
            Button(
              type: BtnType.secondaryFill,
              size: BtnSize.s44,
              text: l10n.retry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
