import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../molecules/country_select.dart';

/// Shared flag rendering for a country/language row. Uses [CountryFlag] SVG
/// assets (ISO 3166-1 alpha-2) so flags render identically on every platform —
/// emoji regional-indicator glyphs do not render on Windows / many Androids.
/// Sized 36×24 (3:2, rounded 4) to match the Figma flag slot.
CountryFlag countryFlag(String countryCode) => CountryFlag.fromCountryCode(
      countryCode,
      theme: const ImageTheme(
        height: 24,
        width: 36,
        shape: RoundedRectangle(4),
      ),
    );

/// A single selectable country entry for [BottomSheetCountrySelect].
///
/// [code] is an opaque value used to identify the row (it is what flows
/// through [BottomSheetCountrySelect.value] / `onChanged`); [name] and
/// [countryCode] are forwarded to the reused [CountrySelect] molecule, the
/// latter rendered as a cross-platform SVG flag via [countryFlag].
class CountryItem {
  /// Creates a country list item.
  const CountryItem({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  /// Opaque identity of the row (e.g. locale "en"); compared by `==`.
  final String code;

  /// Display name shown next to the flag.
  final String name;

  /// ISO 3166-1 alpha-2 country code (e.g. "KR"), rendered as an SVG flag.
  final String countryCode;
}

/// BottomSheet-CountrySelect — country picker sheet.
///
/// Figma `03_Organisms / BottomSheet-CountrySelect` (`176:12212`), measured
/// 1:1 via MCP.
///
/// Layout (top → bottom):
/// - GNB header (`type=sub-2`): `14px 20px` padding, centered [title] in
///   `MO/Body 1 - Bold` (≈ [AppType.body1] SemiBold, white), with an invisible
///   28px spacer on the left and a 28px close glyph on the right (tap →
///   [onClose] / dismiss).
/// - Body frame: `16/20/24` padding, holds a vertical list (335 wide) of
///   reused [CountrySelect] rows. The selected row gets `primary10` fill + 1px
///   `primary` border + check (handled by [CountrySelect.selected]).
/// - Footer [BottomSheet] `single-button`: a 335-wide primary-fill [Button]
///   ("Confirm" → [onConfirm]) above a reused [HomeIndicator].
///
/// Sheet shell: 375 wide, top corners `AppRadius.lg` (24), fill
/// [AppColors.surfaceElevated]. Controlled component: pass [value] (the
/// selected [CountryItem.code]) and react to [onChanged]; the widget never
/// mutates its own selection.
class BottomSheetCountrySelect extends StatelessWidget {
  /// Creates a country-select bottom sheet.
  const BottomSheetCountrySelect({
    super.key,
    this.title,
    required this.items,
    required this.value,
    this.onChanged,
    this.onConfirm,
    this.confirmText,
    this.onClose,
    this.showHomeIndicator = true,
  });

  /// Header title. When null, falls back to the localized "Select a country"
  /// (`AppLocalizations.selectACountry`).
  final String? title;

  /// The countries to list, rendered top-to-bottom as [CountrySelect] rows.
  final List<CountryItem> items;

  /// Currently-selected [CountryItem.code], or `null` for no selection.
  final String? value;

  /// Called with the tapped row's [CountryItem.code].
  final ValueChanged<String>? onChanged;

  /// Called when the confirm button is pressed.
  final VoidCallback? onConfirm;

  /// Confirm button label. When null, falls back to the localized "Confirm"
  /// (`AppLocalizations.confirm`).
  final String? confirmText;

  /// Called when the header close glyph is tapped.
  final VoidCallback? onClose;

  /// Whether to add trailing bottom safe-area padding for the OS gesture bar.
  /// Keep `true` for the full-bleed gallery preview; pass `false` when the host
  /// already provides its own bottom [SafeArea] (e.g. a real modal sheet).
  final bool showHomeIndicator;

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap; the
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double _maxWidth = 430;
  static const double _contentWidth = 335;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectiveTitle = title ?? l10n.selectACountry;
    final effectiveConfirm = confirmText ?? l10n.confirm;
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(effectiveTitle),
            // Body — country list.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Center(
                child: SizedBox(
                  width: _contentWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final item in items)
                        CountrySelect(
                          name: item.name,
                          flag: countryFlag(item.countryCode),
                          selected: item.code == value,
                          onSelect: onChanged == null
                              ? null
                              : () => onChanged!(item.code),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _footer(effectiveConfirm),
          ],
        ),
      ),
    );
  }

  /// GNB `sub-2` header: centered title, close glyph on the right.
  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Invisible 28px spacer balancing the close glyph (centers title).
          const SizedBox(width: 28, height: 28),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.body1.sb.copyWith(color: AppColors.text),
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 24,
              splashRadius: 20,
              onPressed: onClose,
              icon: AppIcons.close(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer: primary confirm button (335 wide) + home indicator.
  Widget _footer(String confirmText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Center(
            child: SizedBox(
              width: _contentWidth,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: confirmText,
                onPressed: onConfirm,
              ),
            ),
          ),
        ),
        // Bottom safe-area inset — clears the real OS gesture bar (replaces the
        // former embedded fake HomeIndicator).
        if (showHomeIndicator)
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: AppSpacing.s24),
            child: SizedBox.shrink(),
          ),
      ],
    );
  }
}

/// Gallery demo: [BottomSheetCountrySelect] over a [Dim], bottom-aligned.
class BottomSheetCountrySelectDemo extends StatefulWidget {
  /// Creates the demo.
  const BottomSheetCountrySelectDemo({super.key});

  @override
  State<BottomSheetCountrySelectDemo> createState() =>
      _BottomSheetCountrySelectDemoState();
}

class _BottomSheetCountrySelectDemoState
    extends State<BottomSheetCountrySelectDemo> {
  static const List<CountryItem> _items = [
    CountryItem(code: 'KR', name: '대한민국', countryCode: 'KR'),
    CountryItem(code: 'US', name: '미국', countryCode: 'US'),
    CountryItem(code: 'JP', name: '일본', countryCode: 'JP'),
    CountryItem(code: 'CN', name: '중국', countryCode: 'CN'),
    CountryItem(code: 'GB', name: '영국', countryCode: 'GB'),
  ];

  String _value = 'US';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        children: [
          // Faux content behind the dim.
          const Positioned.fill(
            child: Center(
              child: Text(
                'Background',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
          ),
          Dim(onTap: () {}),
          // Bottom-aligned sheet.
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetCountrySelect(
              items: _items,
              value: _value,
              onChanged: (code) => setState(() => _value = code),
              onConfirm: () {},
              onClose: () {},
            ),
          ),
        ],
      ),
    );
  }
}
