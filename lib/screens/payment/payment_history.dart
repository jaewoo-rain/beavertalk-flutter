import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../core/error/app_exception.dart';
import '../../core/format/money.dart';
import '../../components/molecules/card_line.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../features/payment/domain/entities/payment.dart';
import '../../features/payment/presentation/providers/payment_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import 'payment_history_loading.dart';
import '../../core/format/dates.dart';

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
///
/// Page 1 comes from [paymentPageProvider]; later pages load as the list nears
/// its end (QA F032 — older payments used to be unreachable past the first 10).
/// If page 1 doesn't fill the screen there is no scroll to trigger that, so the
/// next page is fetched right after the frame instead.
class PaymentHistoryScreen extends ConsumerStatefulWidget {
  /// Creates the payment-history screen.
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  PaymentFilter _filter = PaymentFilter.all;

  final _scroll = ScrollController();

  /// Pages 2.. for [_filter], in order. Page 1 stays in [paymentPageProvider].
  final List<PaymentPage> _more = [];
  bool _loadingMore = false;
  bool _moreFailed = false;

  /// Bumped on every reset, so a page that lands after a tab switch or a retry
  /// is dropped instead of being appended to the wrong list.
  int _generation = 0;

  /// How close to the end (px) the next page starts loading.
  static const double _loadAheadPx = 240;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _resetMore() {
    _generation++;
    _more.clear();
    _loadingMore = false;
    _moreFailed = false;
  }

  void _onScroll() {
    if (_scroll.hasClients && _scroll.position.extentAfter < _loadAheadPx) {
      _loadMore();
    }
  }

  /// The last page seen so far — page 1 or the latest of [_more].
  PaymentPage? _lastPage() {
    if (_more.isNotEmpty) return _more.last;
    return ref.read(paymentPageProvider(_filter)).valueOrNull;
  }

  Future<void> _loadMore() async {
    final last = _lastPage();
    if (last == null || !last.hasMore || _loadingMore || _moreFailed) return;
    final gen = _generation;
    final filter = _filter;
    setState(() => _loadingMore = true);
    try {
      final page = await ref
          .read(paymentRepositoryProvider)
          .listPayments(filter: filter, page: last.page + 1);
      if (!mounted || gen != _generation) return;
      setState(() {
        _more.add(page);
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted || gen != _generation) return;
      setState(() {
        _loadingMore = false;
        _moreFailed = true;
      });
    }
  }

  /// Page 1 may not fill the viewport (tablets, or a short page) — then nothing
  /// scrolls and [_onScroll] never fires, so ask for the next page directly.
  void _fillViewport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      if (_scroll.position.maxScrollExtent <= 0) _loadMore();
    });
  }

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
              error: (e, _) => NetworkErrorView(
                message: e is AppException && e.fromServer ? e.message : null,
                onRetry: () {
                  setState(_resetMore);
                  ref.invalidate(paymentPageProvider(_filter));
                },
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
    // Later pages can repeat a row when a payment lands between requests (the
    // server pages by offset) — keep the first copy.
    final seen = <int>{};
    final items = [
      for (final p in [page, ..._more])
        for (final item in p.items)
          if (seen.add(item.id)) item,
    ];
    final groups = _groupByMonth(items);
    final last = _more.isEmpty ? page : _more.last;
    if (last.hasMore && !_loadingMore && !_moreFailed) _fillViewport();

    return SingleChildScrollView(
      controller: _scroll,
      padding: const EdgeInsets.only(bottom: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s24),
          ContentColumn(
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
            ContentColumn(
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
          // The server pages at 10 (`has_more`); the next page loads as the
          // list nears its end ([_onScroll] · [_fillViewport]).
          if (_loadingMore) ...[
            const SizedBox(height: AppSpacing.s16),
            const Center(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ] else if (_moreFailed) ...[
            const SizedBox(height: AppSpacing.s16),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _moreFailed = false);
                  _loadMore();
                },
                child: Text(l10n.retry),
              ),
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

  /// 필터 줄 — 기록 · 보관함과 같은 알약([TabPill] · Figma `Tab/Pill` `6459:46170`).
  ///
  /// 예전 칩(Figma `2117:20237`)은 두 상태 모두 바탕 `surface2` 이고 글자색만 달라 무엇이
  /// 골라졌는지 안 보였다(09-26 바텀시트·버튼 전수조사 · 사용자 결정 Tab/Pill 재사용).
  Widget _filterRow(AppLocalizations l10n) {
    // 칩 줄도 본문 컬럼 선에서 시작한다(정본 `Top Navigation` 은 x=105).
    return ContentColumn(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in PaymentFilter.values) ...[
              if (f != PaymentFilter.values.first)
                const SizedBox(width: AppSpacing.s12),
              TabPill(
                label: _filterLabel(f, l10n),
                selected: _filter == f,
                onTap: () {
                  if (_filter == f) return;
                  setState(() {
                    _filter = f;
                    _resetMore();
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _filterLabel(PaymentFilter f, AppLocalizations l10n) => switch (f) {
        PaymentFilter.all => l10n.filterAll,
        PaymentFilter.subscribe => l10n.filterSubscription,
        PaymentFilter.character => l10n.filterCharacter,
      };

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
          key == null
              ? l10n.undatedPayments
              : asciiDigits(intl.DateFormat.yMMMM(locale).format(key)),
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
      if (date != null) asciiDigits(intl.DateFormat.MMMd(locale).format(date)),
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

