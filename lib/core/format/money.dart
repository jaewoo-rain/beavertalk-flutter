/// Money parsing and display for the app's single currency: **USD**.
///
/// The server sends amounts as Decimal strings (`"10.00"`, `"9.99"`) with no
/// currency field — the unit is a project-level agreement, not something the
/// wire tells us. See `docs/2026-07-27_1730_서버-요청_샘플음성-이미지-금액.md`
/// for the decision record.
///
/// Amounts are carried as **minor units (cents)** in an `int`, never as a
/// `double`: cent-accurate arithmetic on binary floating point is a rounding
/// bug waiting to happen. `"9.99"` is 999, not 9.99.
///
/// This replaces three copy-pasted `₩`-prefixing helpers (avatar, mypage,
/// payment history) that each parsed to whole units and dropped the cents.
library;

/// Parses a server money value into **minor units (cents)**.
///
/// Accepts the Decimal strings the API actually sends (`"10.00"`, `"0.00"`),
/// plus int/double for tolerance. Returns 0 for null or unparseable input —
/// the same lenient contract the previous `parseKrw` had, so a malformed field
/// renders as free rather than crashing a list.
///
/// ```
/// parseMoneyMinor('10.00') == 1000
/// parseMoneyMinor('9.99')  == 999
/// parseMoneyMinor(10)      == 1000
/// parseMoneyMinor(null)    == 0
/// ```
int parseMoneyMinor(Object? value) {
  if (value == null) return 0;
  if (value is int) return value * 100;
  if (value is double) return (value * 100).round();
  final parsed = double.tryParse(value.toString());
  if (parsed == null) return 0;
  // Round rather than truncate: 9.99 * 100 is 998.9999... in binary floating
  // point, which truncation would turn into $9.98.
  return (parsed * 100).round();
}

/// Formats [minor] cents as a USD display string.
///
/// Whole dollars drop the cents (`$10`, matching the Figma price label);
/// anything with a remainder keeps two digits (`$9.99`). Thousands are grouped.
///
/// ```
/// formatUsd(1000)    == r'$10'
/// formatUsd(999)     == r'$9.99'
/// formatUsd(0)       == r'$0'
/// formatUsd(1234567) == r'$12,345.67'
/// formatUsd(-500)    == r'-$5'
/// ```
String formatUsd(int minor) {
  final negative = minor < 0;
  final abs = minor.abs();
  final dollars = abs ~/ 100;
  final cents = abs % 100;

  final digits = dollars.toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  if (cents != 0) {
    buf.write('.');
    buf.write(cents.toString().padLeft(2, '0'));
  }
  return '${negative ? '-' : ''}\$$buf';
}
