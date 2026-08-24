import 'package:intl/intl.dart';

/// One product's price as the store reports it.
///
/// A plain value type on purpose: `PlanPrices` must not import the IAP layer,
/// or domain and data end up importing each other in a circle.
class StorePrice {
  /// Creates a store price.
  const StorePrice({
    required this.display,
    required this.raw,
    required this.currencyCode,
  });

  /// The store's own formatted string — `$15.99`, `₩22,000`. Shown verbatim.
  final String display;

  /// The same amount as a number, for arithmetic only.
  final double raw;

  /// ISO-4217 code behind [raw].
  final String currencyCode;
}

/// The one place a plan price is read from.
///
/// ## Why this exists
///
/// Prices used to live inside the copy: 30 ARB files carried `$12.90` inside
/// full sentences, and four screens repeated the same literals as constants.
/// Changing a price meant editing ~30 files and hoping none was missed — and
/// one round of that is how `$154.80` (the annual anchor) drifted out of step
/// with the monthly price it is derived from.
///
/// Now the copy carries a `{price}` placeholder and the number comes from
/// here.
///
/// ## The store is the authority; these constants are the fallback
///
/// Work order v2 §6-4. Every getter answers with the **store's own localized
/// price** once [adopt] has been handed a catalog, and falls back to the
/// registered US list price until then — first frame, offline, web.
///
/// This is what lets a discount ship without an app release. A scheduled price
/// drop on App Store Connect changes what the store reports, [adopt] takes it,
/// and every screen quotes the new number. Hardcoding instead would leave the
/// app advertising full price while the member is charged less — the same
/// 3.1.2 mismatch as the reverse, and the reason a console-only discount would
/// otherwise still drag an app review behind it.
///
/// It is also the only way a member outside the US sees a true price: the
/// constants are USD list prices and are wrong for every other storefront.
abstract final class PlanPrices {
  // ---------------------------------------------------------- list fallbacks

  static const _listProMonthly = r'$15.99';
  static const _listProYearly = r'$117.99';
  static const _listMaxMonthly = r'$23.99';
  static const _listMaxYearly = r'$188.99';
  static const _listProYearlyAnchor = r'$191.88';
  static const _listProYearlySaved = r'$73.89';
  static const _listProYearlyPerMonth = r'$9.83';
  static const _listMaxYearlyPerMonth = r'$15.75';
  static const _listMaxMonthlyAnchor = r'$29.99';
  static const _listCharacterFrom = r'$11.99';

  static _StorePrices? _store;

  /// Whether the quoted prices are the store's own. False means every getter
  /// is answering with a USD list price.
  static bool get isStoreBacked => _store != null;

  /// Takes the store's catalog as the price of record.
  ///
  /// All four subscription prices are required together. A screen quoting a
  /// store monthly price beside a fallback annual anchor would be comparing
  /// two currencies — the advertised saving would be nonsense, and in a
  /// non-USD storefront wildly so.
  static void adopt({
    required StorePrice proMonthly,
    required StorePrice proYearly,
    required StorePrice maxMonthly,
    required StorePrice maxYearly,
    StorePrice? characterFrom,
  }) {
    _store = _StorePrices(
      proMonthly: proMonthly,
      proYearly: proYearly,
      maxMonthly: maxMonthly,
      maxYearly: maxYearly,
      characterFrom: characterFrom,
    );
  }

  /// Drops back to list prices.
  ///
  /// Sign-out and tests. A storefront belongs to a store account, so one
  /// member's prices must not outlive their session.
  static void reset() => _store = null;

  // ------------------------------------------------------------- store first

  /// Pro, billed monthly.
  static String get proMonthly =>
      _store?.proMonthly.display ?? _listProMonthly;

  /// Pro, billed yearly.
  static String get proYearly => _store?.proYearly.display ?? _listProYearly;

  /// Max, billed monthly.
  static String get maxMonthly =>
      _store?.maxMonthly.display ?? _listMaxMonthly;

  /// Max, billed yearly.
  static String get maxYearly => _store?.maxYearly.display ?? _listMaxYearly;

  /// Twelve months of Pro at the monthly rate — the struck anchor next to the
  /// annual price. **Derived**: monthly × 12.
  static String get proYearlyAnchor {
    final s = _store;
    return s == null
        ? _listProYearlyAnchor
        : s.derive(s.proMonthly.raw * 12);
  }

  /// What the annual plan saves against [proYearlyAnchor].
  static String get proYearlySaved {
    final s = _store;
    return s == null
        ? _listProYearlySaved
        : s.derive(s.proMonthly.raw * 12 - s.proYearly.raw);
  }

  /// Pro annual, expressed per month. **Derived**: annual ÷ 12.
  static String get proYearlyPerMonth {
    final s = _store;
    return s == null
        ? _listProYearlyPerMonth
        : s.derive(s.proYearly.raw / 12);
  }

  /// Max annual, expressed per month. **Derived**: annual ÷ 12.
  static String get maxYearlyPerMonth {
    final s = _store;
    return s == null
        ? _listMaxYearlyPerMonth
        : s.derive(s.maxYearly.raw / 12);
  }

  /// The struck anchor shown beside Max monthly.
  ///
  /// Marketing copy, not a former price: no store reports "what this used to
  /// cost", so it stays a constant even when everything else comes from the
  /// store. ☞ It is a USD figure — hide it, never convert it, if a non-USD
  /// storefront ever needs one.
  static String get maxMonthlyAnchor => _listMaxMonthlyAnchor;

  /// Cheapest a character ever costs.
  ///
  /// 대표 결정 2026-08-24: characters sell at list price. The earlier `$5.99`
  /// advertised a product that does not exist on either store — a 3.1.2
  /// misstatement, and unbuyable at the quoted price by construction.
  static String get characterFrom =>
      _store?.characterFrom?.display ?? _listCharacterFrom;

  /// What the Free plan costs. Not a store product; here so the comparison
  /// screen quotes it from the same place as everything else.
  static const free = r'$0.00';
}

/// The store's answer, plus the formatter that keeps derived figures in the
/// same currency as the products they came from.
class _StorePrices {
  _StorePrices({
    required this.proMonthly,
    required this.proYearly,
    required this.maxMonthly,
    required this.maxYearly,
    this.characterFrom,
  });

  final StorePrice proMonthly;
  final StorePrice proYearly;
  final StorePrice maxMonthly;
  final StorePrice maxYearly;

  /// Null when no character product was in the catalog — a query that asked
  /// only for subscriptions, or a build where every character is free.
  final StorePrice? characterFrom;

  /// Formats a computed amount in the storefront's currency.
  ///
  /// Stores only format prices they actually sell, and anchors and per-month
  /// figures are arithmetic on top of those. Reusing the product's currency
  /// code keeps `₩` with `₩` and the right number of decimals — KRW has none,
  /// USD has two, and hardcoding either is visibly wrong in the other.
  String derive(double amount) =>
      NumberFormat.simpleCurrency(name: proMonthly.currencyCode).format(amount);
}
