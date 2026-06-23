import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../atoms/select_box.dart';
import '../chrome/home_indicator.dart';
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
    this.title = '새 일정 추가',
    required this.time,
    required this.meridiem,
    this.onMeridiemChanged,
    required this.days,
    this.onDaysChanged,
    required this.partners,
    this.partner,
    this.onPartnerChanged,
    this.onSave,
    this.saveText = '저장',
    this.onClose,
    this.dayLabels = const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  });

  /// Header title (Figma default: "새 일정 추가").
  final String title;

  /// The large time string shown at the top (e.g. "8:00").
  final String time;

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

  /// Save button label.
  final String saveText;

  /// Called when the header close glyph is tapped.
  final VoidCallback? onClose;

  /// Two-letter labels for the 7 day chips (Mon→Sun).
  final List<String> dayLabels;

  static const double _sheetWidth = 375;
  static const double _contentWidth = 335;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: _sheetWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _timeBlock(),
                  const SizedBox(height: 20),
                  _repeatSection(),
                  const SizedBox(height: 20),
                  _partnerSection(),
                ],
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  /// GNB `sub-2` header: centered title, close glyph on the right.
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
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
              icon: const Icon(Icons.close, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  /// Big time text + 오전/오후 toggle buttons.
  Widget _timeBlock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
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
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _meridiemButton(Meridiem.am, '오전')),
            const SizedBox(width: 8),
            Expanded(child: _meridiemButton(Meridiem.pm, '오후')),
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

  /// "반복" label + 7 reused [SelectBox] day chips.
  Widget _repeatSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '반복',
          style: AppType.label1.r.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (int i = 0; i < 7; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: Center(
                  child: SelectBox(
                    label: i < dayLabels.length ? dayLabels[i] : '',
                    selected: i < days.length && days[i],
                    bold: true,
                    onChanged: onDaysChanged == null
                        ? null
                        : (v) => onDaysChanged!(i, v),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// "통화 상대" label + a row of reused [AvatarCard]s.
  Widget _partnerSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '통화 상대',
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
  Widget _footer() {
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
                text: saveText,
                onPressed: onSave,
              ),
            ),
          ),
        ),
        const HomeIndicator(variant: HomeIndicatorVariant.subTransparent),
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
