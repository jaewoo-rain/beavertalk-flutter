import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/app_scaffold.dart';
import '../../components/atoms/pressable.dart';
import '../../components/molecules/card_line.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Payment history — Figma `screen/main_mypage_payment` (`2117:20206`).
///
/// A back-only GNB (the design's title is `opacity-0`) over: a summary card
/// ("이번 달 결제 금액" + amount + next-billing line), a filter chip row
/// (전체 / 구독 / 캐릭터), then transactions grouped by month, each rendered as a
/// [CardLine] of [CardLineType.payment].
///
/// ## Data is mock
/// UI only for now. There is no payment feature in the client — no
/// `lib/features/payment/`, no repository, no DTO, and no server endpoint for
/// a transaction list. [_mockItems] stands in until that contract exists; the
/// widget already reads everything through [_Txn] so wiring a real source is a
/// swap of that one list.
class PaymentHistoryScreen extends StatefulWidget {
  /// Creates the payment-history screen.
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

/// Which transactions the chip row is showing.
enum _Filter { all, subscription, character }

/// What kind of purchase a row represents — drives [_Filter].
enum _TxnKind { subscription, character }

/// One transaction row.
class _Txn {
  const _Txn({
    required this.title,
    required this.date,
    required this.method,
    required this.amount,
    required this.kind,
  });

  /// Row label, e.g. "프리미엄 구독(월간)".
  final String title;

  /// When the charge happened — also drives the month grouping.
  final DateTime date;

  /// Payment method line, e.g. "신한카드 1234".
  final String method;

  /// Formatted amount as shown, e.g. "12.9$".
  final String amount;

  final _TxnKind kind;
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  _Filter _filter = _Filter.all;

  /// Stand-in data mirroring the Figma frame. Replace with the server list.
  static final List<_Txn> _mockItems = [
    _Txn(
      title: '프리미엄 구독(월간)',
      date: DateTime(2026, 6, 3),
      method: '신한카드 1234',
      amount: '12.9\$',
      kind: _TxnKind.subscription,
    ),
    _Txn(
      title: '프리미엄 구독(월간)',
      date: DateTime(2026, 5, 3),
      method: '신한카드 1234',
      amount: '12.9\$',
      kind: _TxnKind.subscription,
    ),
    _Txn(
      title: '캐릭터 구매',
      date: DateTime(2026, 5, 3),
      method: '신한카드 1234',
      amount: '5\$',
      kind: _TxnKind.character,
    ),
  ];

  List<_Txn> get _visible => switch (_filter) {
        _Filter.all => _mockItems,
        _Filter.subscription =>
          _mockItems.where((t) => t.kind == _TxnKind.subscription).toList(),
        _Filter.character =>
          _mockItems.where((t) => t.kind == _TxnKind.character).toList(),
      };

  /// Groups [_visible] by calendar month, newest month first, preserving the
  /// source order inside each group.
  List<MapEntry<DateTime, List<_Txn>>> get _grouped {
    final byMonth = <DateTime, List<_Txn>>{};
    for (final t in _visible) {
      final key = DateTime(t.date.year, t.date.month);
      byMonth.putIfAbsent(key, () => []).add(t);
    }
    final entries = byMonth.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final groups = _grouped;

    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Figma: the GNB title is opacity-0 — back arrow only.
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.s24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s20,
                    ),
                    child: _summaryCard(l10n),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  _filterRow(l10n),
                  const SizedBox(height: AppSpacing.s12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var g = 0; g < groups.length; g++) ...[
                          if (g > 0) const SizedBox(height: AppSpacing.s12),
                          _monthGroup(groups[g], locale),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// "이번 달 결제 금액" card (Figma `2117:20223`): fill `surfaceElevated`,
  /// radius 8, top 16 / bottom 24 / sides 16.
  Widget _summaryCard(AppLocalizations l10n) {
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
          // Mock: the month's total is not computed from a server figure.
          Text('12.9\$', style: AppType.title3.b),
          const SizedBox(height: AppSpacing.s8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.nextBillingDate,
                style: AppType.label1.r
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              _dot(4, AppColors.textSecondary),
              const SizedBox(width: 10),
              Text(
                '7월 1일',
                style: AppType.label1.r
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Filter chips (Figma `2117:20237`): fill `surface2` in both states — only
  /// the label colour changes (white when selected, `textSecondary` otherwise).
  Widget _filterRow(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: 14,
      ),
      child: Row(
        children: [
          for (final f in _Filter.values) ...[
            if (f != _Filter.values.first) const SizedBox(width: AppSpacing.s12),
            _chip(_filterLabel(f, l10n), selected: _filter == f, onTap: () {
              if (_filter != f) setState(() => _filter = f);
            }),
          ],
        ],
      ),
    );
  }

  String _filterLabel(_Filter f, AppLocalizations l10n) => switch (f) {
        _Filter.all => l10n.filterAll,
        _Filter.subscription => l10n.filterSubscription,
        _Filter.character => l10n.filterCharacter,
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

  /// One month heading + its rows. The last row drops its divider so the group
  /// doesn't end on a dangling hairline.
  Widget _monthGroup(MapEntry<DateTime, List<_Txn>> group, String locale) {
    final rows = group.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          // Locale-aware rather than a hardcoded "2026년 6월": the same screen
          // renders in 30 locales.
          intl.DateFormat.yMMMM(locale).format(group.key),
          style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s8),
        for (var i = 0; i < rows.length; i++)
          _row(rows[i], locale, showDivider: i < rows.length - 1),
      ],
    );
  }

  Widget _row(_Txn t, String locale, {required bool showDivider}) {
    final l10n = AppLocalizations.of(context);
    return CardLine(
      type: CardLineType.payment,
      label: t.title,
      // CardLine splits `meta` on `·` into dot-separated segments.
      meta: '${intl.DateFormat.MMMd(locale).format(t.date)}·${t.method}',
      value: t.amount,
      status: l10n.statusCompleted,
      showDivider: showDivider,
    );
  }

  Widget _dot(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
