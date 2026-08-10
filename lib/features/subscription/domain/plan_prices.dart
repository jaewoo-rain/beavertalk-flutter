/// The one place a plan price is written down.
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
/// here. Change a price in this file and every locale follows.
///
/// ## These are stand-ins, not the authority
///
/// Work order v2 §6-4: **the store is the price authority.** The moment the
/// real IAP SDK lands, these come from `IapProduct.localizedPrice`, which is
/// already localized and currency-correct per storefront. Until then they are
/// the registered list prices for the US storefront
/// (`docs/2026-08-04_2018_IAP_상품등록_ID체계_설계서.md` §3-5), and every one
/// of them is wrong for a member shopping from another country.
abstract final class PlanPrices {
  /// Pro, billed monthly.
  static const proMonthly = r'$15.99';

  /// Pro, billed yearly.
  static const proYearly = r'$117.99';

  /// Max, billed monthly.
  static const maxMonthly = r'$23.99';

  /// Max, billed yearly.
  static const maxYearly = r'$188.99';

  /// Twelve months of Pro at the monthly rate — the struck anchor next to the
  /// annual price. **Derived**: [proMonthly] × 12.
  static const proYearlyAnchor = r'$191.88';

  /// What the annual plan saves against [proYearlyAnchor].
  static const proYearlySaved = r'$73.89';

  /// Pro annual, expressed per month. **Derived**: [proYearly] ÷ 12.
  static const proYearlyPerMonth = r'$9.83';

  /// Max annual, expressed per month. **Derived**: [maxYearly] ÷ 12.
  static const maxYearlyPerMonth = r'$15.75';

  /// The struck anchor shown beside Max monthly.
  static const maxMonthlyAnchor = r'$29.99';

  /// Cheapest a character ever costs — the discounted price (설계서 §3-2).
  static const characterFrom = r'$5.99';

  /// What the Free plan costs. Not a store product; here so the comparison
  /// screen quotes it from the same place as everything else.
  static const free = r'$0.00';
}
