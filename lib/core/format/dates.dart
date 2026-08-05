import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-following date labels for the subscription surfaces.
///
/// These exist because three screens each grew their own
/// `DateFormat('MMM d, yyyy', 'en_US')` — an English date in 30 UI languages.
/// `GlobalMaterialLocalizations` (wired in `main.dart`) initializes intl's
/// date symbols for the active locale, so formatting by the ambient locale is
/// safe here.

/// `Jun 20, 2026` — the full form the manage screen and sheets use.
String localizedFullDate(BuildContext context, DateTime d) =>
    DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(d);

/// `Jun 20` — the short form footnotes use.
String localizedShortDate(BuildContext context, DateTime d) =>
    DateFormat.MMMd(Localizations.localeOf(context).toString()).format(d);
