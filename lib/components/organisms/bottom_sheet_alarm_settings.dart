import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../molecules/avatar_card.dart';

/// AM / PM選択 value for [BottomSheetAlarmSettings].
enum Meridiem {
  /// 오전 (AM).
  am,

  /// 오후 (PM).
  pm,
}

/// The 빠른 시작 presets (`3665:12361`) — one-tap seeds for the form below.
///
/// Client-side only: each is just a `(hour, minute, meridiem, days)` the sheet's
/// host applies. No endpoint serves these, and none needs to.
enum AlarmPreset {
  /// 아침 루틴 · 평일 8:00 — Mon–Fri.
  morning,

  /// 저녁 정리 · 매일 21:00 — every day.
  evening,

  /// 직접 설정 · 자유롭게 — seeds nothing; the user drives the form.
  custom,
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
/// Figma `BottomSheet-AlarmSettings_new` (`3665:12460`), as presented by
/// `screen/etc_alarm__add` (`3665:12018`). This is the 2026-07-16 redesign; it
/// replaces `176:13983` outright rather than sitting beside it.
///
/// Layout (top → bottom):
/// - GNB header: centered title + close glyph.
/// - Body (`16/20/24` padding, gap 20):
///   - **빠른 시작** (`3665:12359`) — a label over three [_QuickStartCard]s
///     (row, gap 10, each `flex:1`, 91 tall). Picking one seeds the time and
///     days below; see [AlarmPreset].
///   - **시간과 요일** (`3665:12388`) — one bounded card holding the [time]
///     (Title 1, left), a compact 오전/오후 [_MeridiemSegment] (120×38, right,
///     same row) and the seven day chips beneath. The old sheet stacked these
///     as three loose sections under a "반복" label the frame no longer has.
///   - **통화 상대** (`3665:12411`) — a row (gap 16) of [AvatarCard]s carrying
///     사용 중 / 보유 중 badges.
///   - **요약** (`3665:12419`) — a check glyph + "주 N회 · 한 달이면 M번…",
///     derived here from [days]; nothing on the server backs it.
/// - Footer: a 335-wide primary [Button] ([saveText] → [onSave]).
///
/// Sheet shell: top corners `AppRadius.lg` (24), fill
/// `Background/Elevated/Alternative`. Fully controlled — selection state flows in via
/// [meridiem] / [days] / [partner] / [preset] and out via the `on*Changed`
/// callbacks.
///
/// **On 사용 중 / 보유 중.** The frame badges the selected card 사용 중 and the
/// rest 보유 중. There is no "equipped character" concept anywhere in the app
/// (`OwnedCharacter` has no such field), and the badge tracks selection exactly
/// in the frame — so 사용 중 means *the partner picked in this sheet*. If it was
/// meant to mean a globally-equipped character, that needs a server field and a
/// decision; it is called out in
/// `docs/2026-07-16_1835_확정디자인-최신화-v2dark.md`.
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
    this.preset,
    this.onPresetChanged,
    this.onSave,
    this.saveText,
    this.onClose,
    this.dayLabels,
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

  /// The highlighted 빠른 시작 card, or null when the form matches no preset.
  final AlarmPreset? preset;

  /// Called with the tapped preset. The host applies its time/days.
  final ValueChanged<AlarmPreset>? onPresetChanged;

  /// Called when the save button is pressed.
  final VoidCallback? onSave;

  /// Save button label; falls back to the localized "Save" when null.
  final String? saveText;

  /// Called when the header close glyph is tapped.
  final VoidCallback? onClose;

  /// Labels for the 7 day chips (Mon→Sun). Defaults to the **locale's own**
  /// narrow weekday names, which is what makes the frame's 월 화 수 목 금 토 일
  /// come out right in Korean and still read in the other 29 locales — a
  /// hardcoded Korean row would be nonsense in most of them.
  final List<String>? dayLabels;

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
      color: context.c.backgroundElevatedAlternative,
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
            _header(context, l10n),
            // The redesign made the body tall enough (quick-start cards, the
            // time card, the partner row and the summary) that it no longer
            // clears a short viewport — it overflowed a 600-high one by 73.
            // Flexible + a scroll view keeps the sheet hugging its content
            // wherever there is room, and scrolls instead of clipping where
            // there isn't; the header and the save button stay put either way.
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _quickStartSection(context, l10n),
                      const SizedBox(height: 20),
                      _timeAndDaysCard(context, l10n),
                      const SizedBox(height: 20),
                      _partnerSection(context, l10n),
                      const SizedBox(height: 20),
                      _summary(context, l10n),
                    ],
                  ),
                ),
              ),
            ),
            _footer(context, l10n),
          ],
        ),
      ),
    );
  }

  /// GNB `sub-2` header: centered title, close glyph on the right.
  Widget _header(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const SizedBox(width: 28, height: 28),
          Expanded(
            child: Text(
              title ?? l10n.addSchedule,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
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
              icon: AppIcons.close(color: context.c.labelStrong),
            ),
          ),
        ],
      ),
    );
  }

  /// 빠른 시작 (`3665:12359`) — label + three preset cards.
  Widget _quickStartSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.quickStart,
          style: AppType.label1.r.copyWith(color: context.c.labelStrong),
        ),
        const SizedBox(height: AppSpacing.s8),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _QuickStartCard(
                  icon: AppIcons.sun,
                  title: l10n.presetMorning,
                  subtitle: l10n.presetMorningSub,
                  selected: preset == AlarmPreset.morning,
                  onTap: _presetTap(AlarmPreset.morning),
                ),
              ),
              const SizedBox(width: 10), // no s10 token
              Expanded(
                child: _QuickStartCard(
                  icon: AppIcons.moon,
                  title: l10n.presetEvening,
                  subtitle: l10n.presetEveningSub,
                  selected: preset == AlarmPreset.evening,
                  onTap: _presetTap(AlarmPreset.evening),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickStartCard(
                  icon: AppIcons.sliders,
                  title: l10n.presetCustom,
                  subtitle: l10n.presetCustomSub,
                  selected: preset == AlarmPreset.custom,
                  onTap: _presetTap(AlarmPreset.custom),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  VoidCallback? _presetTap(AlarmPreset p) =>
      onPresetChanged == null ? null : () => onPresetChanged!(p);

  /// 시간과 요일 (`3665:12388`) — one card holding the time + meridiem row over
  /// the day chips. The frame flattens it to a 335×116 vector; the fill is
  /// `background/normal/alternative`.
  Widget _timeAndDaysCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      // 16/12 with a 14 gap, not 16 all round: the frame puts the clock 12
      // below the card's top and the chips 12 above its bottom, which is what
      // lands it on 116 (16 all round rendered 126).
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16, AppSpacing.s12, AppSpacing.s16, AppSpacing.s12),
      decoration: BoxDecoration(
        color: context.c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTimeTap,
                  child: Text(
                    time,
                    maxLines: 1,
                    // Title 1 Regular 32/1.375. The frame dropped the old 40px
                    // SemiBold centred clock for this: left-aligned, sharing
                    // its row with the segment.
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 32,
                      height: 1.375,
                      letterSpacing: -0.81,
                      color: context.c.labelStrong,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              _MeridiemSegment(
                meridiem: meridiem,
                amLabel: l10n.am,
                pmLabel: l10n.pm,
                onChanged: onMeridiemChanged,
              ),
            ],
          ),
          const SizedBox(height: 14), // no s14 token
          _dayChips(context),
        ],
      ),
    );
  }

  /// The seven day chips (`3665:12396`), 34 tall.
  ///
  /// Chips display Monday-first but [days] is Sunday-indexed (0=Sun..6=Sat,
  /// matching `Alarm.days`, the server's `days_of_week` and both schedulers), so
  /// each visual slot maps through [_visualToDataIndex]. A Mon-first index fed
  /// straight into a Sun-indexed array shifts every alarm by a day.
  Widget _dayChips(BuildContext context) {
    final labels = dayLabels ?? _narrowWeekdays(context);
    return Row(
      children: [
        for (int i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(width: 5), // no s5 token
          Expanded(
            child: _DayChip(
              label: i < labels.length ? labels[i] : '',
              selected: _visualToDataIndex[i] < days.length &&
                  days[_visualToDataIndex[i]],
              onTap: onDaysChanged == null
                  ? null
                  : () => onDaysChanged!(
                        _visualToDataIndex[i],
                        !days[_visualToDataIndex[i]],
                      ),
            ),
          ),
        ],
      ],
    );
  }

  /// The locale's narrow weekday names, reordered Monday-first.
  ///
  /// The frame spells the row 월 화 수 목 금 토 일, which is only right in
  /// Korean — this screen renders in 30 locales, so the names come from the
  /// locale itself and Korean lands on the frame's exactly. `intl` indexes them
  /// 0=Sun, the same order as [days].
  List<String> _narrowWeekdays(BuildContext context) {
    final symbols = intl.DateFormat.yMd(
      Localizations.localeOf(context).toString(),
    ).dateSymbols.NARROWWEEKDAYS;
    return [for (final i in _visualToDataIndex) symbols[i]];
  }

  /// 요약 (`3665:12419`) — derived from [days] alone; nothing on the server
  /// backs it. With no day picked there is no "주 N회" to state, so it asks for
  /// one rather than claiming 주 0회.
  Widget _summary(BuildContext context, AppLocalizations l10n) {
    final count = days.where((d) => d).length;
    final text = count == 0
        ? l10n.alarmSummaryNone
        : l10n.alarmSummary(count, count * 4);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIcons.check(size: 12, color: context.c.primaryStrong),
        const SizedBox(width: 9), // no s9 token
        Flexible(
          child: Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppType.caption1.r.copyWith(color: context.c.primaryStrong),
          ),
        ),
      ],
    );
  }

  /// "Character" label + a row of reused [AvatarCard]s.
  Widget _partnerSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.callPartner,
          style: AppType.label1.r.copyWith(color: context.c.labelStrong),
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
                  // 사용 중 on the picked card, 보유 중 on the rest
                  // (`3665:12415`). See the class doc: this tracks *this
                  // sheet's* selection, not a global equip state — there is no
                  // such concept in the app.
                  statusLabel: partners[i].id == partner
                      ? l10n.partnerInUse
                      : l10n.partnerOwned,
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
  Widget _footer(BuildContext context, AppLocalizations l10n) {
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

/// One 빠른 시작 card (`3665:12362`) — icon over a title and its subtitle.
///
/// Selected takes a 1.5px `primary/strong` border over a 4%-primary wash and
/// whitens the title; unselected is a 1px `label/neutral` hairline with both
/// lines muted. The 1.5 vs 1 border is the frame's, and it is why the row sits
/// in an [IntrinsicHeight] — the extra half-pixel would otherwise make the
/// selected card taller than its neighbours.
class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    this.onTap,
  });

  final AppIconBuilder icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      // 91 in the frame; a min instead of a fixed height so a locale with a
      // longer preset name grows the card rather than overflowing it.
      constraints: const BoxConstraints(minHeight: 91),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: selected ? context.c.primaryNormal4 : null,
        // 16. ⚠️ Figma's radius scale is shifted one step from [AppRadius]'s —
        // Figma `lg` is 16 where [AppRadius.lg] is 24. Read the number, not the
        // name.
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: selected ? context.c.primaryStrong : context.c.labelNeutral,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon(
            size: 24,
            color: selected ? context.c.primaryStrong : context.c.labelNormal,
          ),
          const SizedBox(height: 10), // no s10 token
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppType.label2.r.copyWith(
              color: selected ? context.c.labelStrong : context.c.labelNormal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppType.caption2.r.copyWith(
              color: selected ? context.c.labelNormal : context.c.labelNeutral,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return Semantics(
      button: true,
      selected: selected,
      label: '$title, $subtitle',
      child: Material(
        color: Colors.transparent,
        // Must match the card's own 16, or the ripple leaks past its corners.
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }
}

/// The 오전 / 오후 segmented control (`3665:12391`) — a 120×38 track with a
/// 57×32 thumb that slides under the selected half.
///
/// New here: the old sheet spent two full-width 60-high outline [Button]s on
/// this. The frame wants a compact control sharing the clock's row.
class _MeridiemSegment extends StatelessWidget {
  const _MeridiemSegment({
    required this.meridiem,
    required this.amLabel,
    required this.pmLabel,
    this.onChanged,
  });

  final Meridiem meridiem;
  final String amLabel;
  final String pmLabel;
  final ValueChanged<Meridiem>? onChanged;

  static const double _trackW = 120, _trackH = 38, _pad = 3;

  @override
  Widget build(BuildContext context) {
    const half = (_trackW - _pad * 2) / 2;
    final isAm = meridiem == Meridiem.am;
    return Container(
      width: _trackW,
      height: _trackH,
      padding: const EdgeInsets.all(_pad),
      decoration: BoxDecoration(
        // The track sinks to `surface` (#181A20) — darker than the card it
        // sits on, not lighter.
        color: context.c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: isAm ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: half,
              height: _trackH - _pad * 2,
              decoration: BoxDecoration(
                // primaryStrong, not primary — this card's mint is #00E8A2
                // throughout (thumb and selected chips alike).
                color: context.c.primaryStrong,
                borderRadius: BorderRadius.circular(6), // no r6 token
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: _half(context, amLabel, isAm, Meridiem.am)),
              Expanded(child: _half(context, pmLabel, !isAm, Meridiem.pm)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _half(BuildContext context, String label, bool on, Meridiem value) => Semantics(
        button: true,
        selected: on,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onChanged == null ? null : () => onChanged!(value),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.label2.r.copyWith(
                // On the mint thumb the label must go dark, not white.
                color: on ? context.c.primaryOnPrimary : context.c.labelNormal,
              ),
            ),
          ),
        ),
      );
}

/// One day chip inside the 시간과 요일 card (`3665:12397`) — 34 tall, the label
/// centred. Selected fills primary with a dark label; unselected is a
/// `surface2` box with a muted one.
class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Same pairing as the segment: primaryStrong on, `surface` off.
        color: selected ? context.c.primaryStrong : context.c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.caption1.r.copyWith(
          color: selected ? context.c.primaryOnPrimary : context.c.labelNormal,
        ),
      ),
    );
    if (onTap == null) return chip;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: chip,
      ),
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
  AlarmPreset? _preset = AlarmPreset.custom;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
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
                preset: _preset,
                onPresetChanged: (p) => setState(() => _preset = p),
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
