import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../atoms/select_box.dart';
import '../molecules/avatar_card.dart';

/// AM / PM選択 value for [BottomSheetAlarmSettings].
enum Meridiem {
  /// 오전 (AM).
  am,

  /// 오후 (PM).
  pm,
}

/// A "통화 상대" (call partner) avatar entry for [BottomSheetAlarmSettings].
class AlarmPartner {
  /// Creates a call-partner item.
  const AlarmPartner({
    required this.id,
    required this.name,
    this.imageProvider,
  });

  /// Opaque identity (compared by `==`); drives selection.
  final String id;

  /// Display name under the avatar.
  final String name;

  /// Optional avatar image; a placeholder is shown when null.
  final ImageProvider<Object>? imageProvider;
}

/// BottomSheet-AlarmSettings — "새 일정 추가" (new schedule) sheet.
///
/// Figma `03_Organisms / BottomSheet-AlarmSettings` (`176:13983`), measured
/// 1:1 via MCP.
///
/// Layout (top → bottom):
/// - GNB header (`type=sub-2`): centered "새 일정 추가" title + close glyph.
/// - Body (`16/20/24` padding, gap 20):
///   - Time block (column, gap 8, centered): the large [time] text
///     (Pretendard SemiBold 40 / 1.5em / -0.025em) and a row (gap 8) of two
///     reused [Button]s — 오전 / 오후. The active one uses
///     `primary_outline_white` (primary border, white text); the inactive uses
///     `secondary_outline` (line border, secondary text). Tapping reports via
///     [onMeridiemChanged].
///   - "반복" section (label `MO/Label 1 Regular` + a row, gap 8, of 7 day
///     chips). The chips reuse the [SelectBox] atom (the Figma node renders
///     40×40 IconButtons; this implementation honors the spec's SelectBox
///     reuse — selected = primary text, unselected = secondary). Toggling
///     reports via [onDaysChanged].
///   - "통화 상대" section (label + a row, gap 16, of [AvatarCard]s). The
///     selected partner is `active`; tapping reports via [onPartnerChanged].
/// - Footer [BottomSheet] `single-button`: a 335-wide primary [Button]
///   ([saveText] → [onSave]) above a reused [HomeIndicator].
///
/// Sheet shell: 375 wide, top corners `AppRadius.lg` (24), fill
/// [AppColors.surfaceElevated]. Fully controlled — selection state flows in
/// via [meridiem] / [days] / [partner] and out via the `on*Changed` callbacks.
class BottomSheetAlarmSettings extends StatelessWidget {
  /// Creates an alarm-settings bottom sheet.
  const BottomSheetAlarmSettings({
    super.key,
    this.title,
    required this.time,
    this.onTimeTap,
    required this.meridiem,
    this.onMeridiemChanged,
    required this.days,
    this.onDaysChanged,
    required this.partners,
    this.partner,
    this.onPartnerChanged,
    this.onSave,
    this.saveText,
    this.onClose,
    this.dayLabels = const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  });

  /// Header title; falls back to the localized "Add Schedule" when null.
  final String? title;

  /// The large time string shown at the top (e.g. "8:00").
  final String time;

  /// Called when the large time text is tapped (open a time picker). When null
  /// the time is static.
  final VoidCallback? onTimeTap;

  /// Currently-selected AM/PM value.
  final Meridiem meridiem;

  /// Called with the tapped meridiem.
  final ValueChanged<Meridiem>? onMeridiemChanged;

  /// 7 booleans (Mon→Sun) — which weekday chips are selected.
  final List<bool> days;

  /// Called with `(index, newSelected)` when a day chip is toggled.
  final void Function(int index, bool selected)? onDaysChanged;

  /// The available call partners.
  final List<AlarmPartner> partners;

  /// Currently-selected partner [AlarmPartner.id], or `null`.
  final String? partner;

  /// Called with the tapped partner's [AlarmPartner.id].
  final ValueChanged<String>? onPartnerChanged;

  /// Called when the save button is pressed.
  final VoidCallback? onSave;

  /// Save button label; falls back to the localized "Save" when null.
  final String? saveText;

  /// Called when the header close glyph is tapped.
  final VoidCallback? onClose;

  /// Two-letter labels for the 7 day chips (Mon→Sun).
  final List<String> dayLabels;

  /// Visual chip slot (Monday-first) → Sun-indexed [days] index
  /// (Mo→1, Tu→2, We→3, Th→4, Fr→5, Sa→6, Su→0). Keeps the Mon-first display
  /// while storing to the Sun-indexed model the server/schedulers expect.
  static const List<int> _visualToDataIndex = [1, 2, 3, 4, 5, 6, 0];

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap; the
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double _maxWidth = 430;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            _header(l10n),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _timeBlock(l10n),
                  const SizedBox(height: 20),
                  _repeatSection(l10n),
                  const SizedBox(height: 20),
                  _partnerSection(l10n),
                ],
              ),
            ),
            _footer(l10n),
          ],
        ),
      ),
    );
  }

  /// GNB `sub-2` header: centered title, close glyph on the right.
  Widget _header(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const SizedBox(width: 28, height: 28),
          Expanded(
            child: Text(
              title ?? l10n.addSchedule,
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

  /// Big time text + AM/PM toggle buttons.
  Widget _timeBlock(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTimeTap,
          child: Text(
            time,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w600, // SemiBold
              fontSize: 40,
              height: 1.5, // 1.5em
              letterSpacing: -1.0, // ≈ -0.025em × 40
              color: AppColors.text,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _meridiemButton(Meridiem.am, l10n.am)),
            const SizedBox(width: 8),
            Expanded(child: _meridiemButton(Meridiem.pm, l10n.pm)),
          ],
        ),
      ],
    );
  }

  /// One 오전/오후 button — active uses primary_outline_white, inactive uses
  /// secondary_outline (matching Figma `45:45142` / `165:627`).
  Widget _meridiemButton(Meridiem m, String label) {
    final selected = meridiem == m;
    return Button(
      type: selected ? BtnType.primaryOutlineWhite : BtnType.secondaryOutline,
      size: BtnSize.s60,
      text: label,
      onPressed:
          onMeridiemChanged == null ? null : () => onMeridiemChanged!(m),
    );
  }

  /// "Repeat" label + 7 reused [SelectBox] day chips.
  Widget _repeatSection(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.repeat,
          style: AppType.label1.r.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Chips display Monday-first (dayLabels) but the [days] array is
            // Sunday-indexed (0=Sun..6=Sat, matching Alarm.days + the server +
            // both schedulers). Map each visual slot to its data index so a
            // tapped weekday stores/reads the correct day (a Mon-first index
            // fed straight into a Sun-indexed array shifts every alarm by a day).
            for (int i = 0; i < 7; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: SelectBox(
                  label: i < dayLabels.length ? dayLabels[i] : '',
                  selected: _visualToDataIndex[i] < days.length &&
                      days[_visualToDataIndex[i]],
                  bold: true,
                  expand: true,
                  onChanged: onDaysChanged == null
                      ? null
                      : (v) => onDaysChanged!(_visualToDataIndex[i], v),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// "Character" label + a row of reused [AvatarCard]s.
  Widget _partnerSection(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.callPartner,
          style: AppType.label1.r.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < partners.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                AvatarCard(
                  name: partners[i].name,
                  active: partners[i].id == partner,
                  imageProvider: partners[i].imageProvider,
                  onTap: onPartnerChanged == null
                      ? null
                      : () => onPartnerChanged!(partners[i].id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Footer: primary save button (335 wide) + home indicator.
  Widget _footer(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: SizedBox(
            width: double.infinity,
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: saveText ?? l10n.save,
              onPressed: onSave,
            ),
          ),
        ),
        // Bottom safe-area inset — clears the real OS gesture bar (replaces the
        // former embedded fake HomeIndicator).
        const SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: AppSpacing.s24),
          child: SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Gallery demo: [BottomSheetAlarmSettings] over a [Dim], bottom-aligned.
class BottomSheetAlarmSettingsDemo extends StatefulWidget {
  /// Creates the demo.
  const BottomSheetAlarmSettingsDemo({super.key});

  @override
  State<BottomSheetAlarmSettingsDemo> createState() =>
      _BottomSheetAlarmSettingsDemoState();
}

class _BottomSheetAlarmSettingsDemoState
    extends State<BottomSheetAlarmSettingsDemo> {
  static const List<AlarmPartner> _partners = [
    AlarmPartner(id: 'a', name: 'Beaver'),
    AlarmPartner(id: 'b', name: 'Otter'),
    AlarmPartner(id: 'c', name: 'Fox'),
    AlarmPartner(id: 'd', name: 'Bear'),
  ];

  Meridiem _meridiem = Meridiem.am;
  final List<bool> _days = [true, false, false, false, false, false, false];
  String _partner = 'a';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        children: [
          Dim(onTap: () {}),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: BottomSheetAlarmSettings(
                time: '8:00',
                meridiem: _meridiem,
                onMeridiemChanged: (m) => setState(() => _meridiem = m),
                days: _days,
                onDaysChanged: (i, v) => setState(() => _days[i] = v),
                partners: _partners,
                partner: _partner,
                onPartnerChanged: (id) => setState(() => _partner = id),
                onSave: () {},
                onClose: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
