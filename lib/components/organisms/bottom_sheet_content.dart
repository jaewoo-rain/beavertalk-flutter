import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../icons/app_icons.dart';
import '../molecules/benefit_row.dart';
import 'bottom_sheet.dart' show SheetAction;

/// Content form of a [BottomSheetContent] — the Figma `content=*` variant
/// (`BottomSheet-Content` `4399:2039`).
///
/// The old `note` variant is gone: it became structurally identical to [none]
/// and the design merged them (spec §3-1). Do not re-add it.
enum SheetContentType {
  /// Header + CTA only.
  none,

  /// A read-only card of label/value rows.
  rows,

  /// Avatar + name + last topic + usage — the call-limit sheet.
  preview,

  /// Day-streak cells + a caption — the habit framing of the limit sheet.
  streak,

  /// A video-call preview card + price line — the Max video upsell.
  video,
}

/// Result mark at the top of a notice sheet — Figma `Mark` (`4365:31487`).
///
/// Only result sheets (purchase success/failure, restore) turn this on
/// (spec §7-2).
enum SheetMarkTone {
  /// Mint check on a mint-14 disc.
  success,

  /// Red exclamation on a red-6 disc.
  error,
}

/// One row of the [SheetContentType.rows] card.
class SheetRowData {
  /// Creates a row.
  const SheetRowData({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  /// Left text, `Common/White & Dark`.
  final String label;

  /// Right text — `Label/Normal`, or `Primary/Normal` when [highlighted].
  final String value;

  /// Whether [value] gets the mint highlight (e.g. the best score).
  final bool highlighted;
}

/// Payload of the [SheetContentType.preview] card.
class SheetPreviewData {
  /// Creates preview data.
  const SheetPreviewData({
    required this.avatar,
    required this.name,
    required this.topic,
    required this.usage,
  });

  /// 40px avatar; clipped to a circle by the sheet.
  final Widget avatar;

  /// Character name (Label 2 SemiBold).
  final String name;

  /// Last-conversation line (Caption 1).
  final String topic;

  /// Usage line under the divider (e.g. `4:58 of 5:00 used`).
  final String usage;
}

/// One day cell of the [SheetContentType.streak] card.
class SheetStreakDay {
  /// Creates a day cell.
  const SheetStreakDay({required this.label, this.done = true});

  /// Day label (`Mon`).
  final String label;

  /// Whether the check is lit (mint) or quiet (`Label/Assistive`).
  final bool done;
}

/// The generic sheet shell — Figma `BottomSheet-Content` (`4399:2039`).
///
/// Fifteen of the nineteen subscription overlays are instances of this one
/// component (work order §3-2), so its shape is load-bearing: grabber → mark →
/// header → content → benefit → caption → CTA, with the CTA block stacking the
/// primary action **above** the secondary (unlike the legacy `BottomSheet`
/// organism, whose two-button column is secondary-first — that is why the CTA
/// is built here rather than delegated).
///
/// This is the sheet body only. Presenting it modally, the dim scrim and the
/// close conventions (dim tap closes, sheet body does nothing, closing never
/// changes subscription state — spec §7-2) belong to the overlay layer (P4),
/// which is also where every dismiss path must converge.
class BottomSheetContent extends StatelessWidget {
  /// Creates a content sheet.
  const BottomSheetContent({
    super.key,
    this.type = SheetContentType.none,
    required this.title,
    required this.body,
    this.mark,
    this.rows = const [],
    this.preview,
    this.streakDays = const [],
    this.streakNote,
    this.videoPreview,
    this.videoPriceOriginal,
    this.videoPrice,
    this.benefitLabel,
    this.benefitTier = BenefitTier.pro,
    this.caption,
    required this.primaryAction,
    this.secondaryAction,
  });

  /// Content form; see [SheetContentType].
  final SheetContentType type;

  /// Sheet title. 20px on [SheetContentType.none]/[SheetContentType.video],
  /// 18px on the card forms — the Figma variants differ and both are kept.
  final String title;

  /// Supporting paragraph under the title.
  final String body;

  /// Result mark, or null for none.
  final SheetMarkTone? mark;

  /// Rows for [SheetContentType.rows].
  final List<SheetRowData> rows;

  /// Payload for [SheetContentType.preview].
  final SheetPreviewData? preview;

  /// Day cells for [SheetContentType.streak].
  final List<SheetStreakDay> streakDays;

  /// Caption inside the streak card (`You're using it every day. …`).
  final String? streakNote;

  /// Preview widget inside the [SheetContentType.video] card. Null draws the
  /// placeholder composition (avatar disc + self-view).
  final Widget? videoPreview;

  /// Struck anchor price of the video sheet (`$29.99`) — rendered in body
  /// colour with a strikethrough, per work order §6-4.
  final String? videoPriceOriginal;

  /// Live price line of the video sheet (`$23.99 per month`).
  final String? videoPrice;

  /// Benefit line, or null for none.
  final String? benefitLabel;

  /// Benefit check colour.
  final BenefitTier benefitTier;

  /// Price/cancel caption under the content, or null for none.
  final String? caption;

  /// Main CTA — always present, always on top.
  final SheetAction primaryAction;

  /// Quiet CTA below the main one (`Not now` / `Close`). These only ever
  /// dismiss; spec §7-2 forbids a closing action from changing any state.
  final SheetAction? secondaryAction;

  /// Max sheet width — matches the legacy `BottomSheet.maxWidth` phone cap.
  static const double maxWidth = 430;

  bool get _onCard => type != SheetContentType.none;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    // The `none` sheet is a floating card (elevated surface, thin grabber);
    // the card forms sit on the screen background with a heavier grabber —
    // both pairs measured off the component set.
    final bg =
        _onCard ? c.backgroundNormalNormal : c.backgroundElevatedAlternative;
    final grabber = _onCard ? c.backgroundElevatedNormal : c.lineNormal;

    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: _onCard ? 40 : 36,
              height: 4,
              decoration: BoxDecoration(
                color: grabber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (mark != null) ...[
                  Center(child: _Mark(tone: mark!)),
                  const SizedBox(height: 16),
                ],
                _header(context),
                ..._content(context),
                if (benefitLabel != null) ...[
                  const SizedBox(height: 16),
                  BenefitRow(tier: benefitTier, label: benefitLabel!),
                ],
                if (caption != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    caption!,
                    textAlign: TextAlign.center,
                    style: AppType.caption1.r.copyWith(color: c.labelNormal),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: primaryAction.label,
                onPressed: primaryAction.onPressed,
              ),
            ),
          ),
          if (secondaryAction != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  type: BtnType.secondaryFill,
                  size: BtnSize.s60,
                  text: secondaryAction!.label,
                  onPressed: secondaryAction!.onPressed,
                ),
              ),
            ),
          // Bottom safe-area inset — clears the OS gesture bar, replacing the
          // design frame's fake HomeIndicator (same trade as `BottomSheet`).
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 24),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final c = context.c;
    final big = type == SheetContentType.none || type == SheetContentType.video;
    final titleStyle = (big ? AppType.heading2 : AppType.headline1)
        .sb
        .copyWith(color: c.labelStrong);
    return Column(
      children: [
        Text(title, textAlign: TextAlign.center, style: titleStyle),
        SizedBox(height: big ? 6 : 8),
        Text(
          body,
          textAlign: TextAlign.center,
          style: AppType.label1.r.copyWith(color: c.labelNormal),
        ),
      ],
    );
  }

  List<Widget> _content(BuildContext context) {
    final c = context.c;
    switch (type) {
      case SheetContentType.none:
        return const [];

      case SheetContentType.rows:
        return [
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: c.backgroundNormalAlternative,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  _RowLine(data: rows[i], last: i == rows.length - 1),
              ],
            ),
          ),
        ];

      case SheetContentType.preview:
        final p = preview;
        if (p == null) return const [];
        return [
          const SizedBox(height: 16),
          _card(context, [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipOval(child: p.avatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: AppType.label2.sb
                            .copyWith(color: c.commonWhiteAndDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.topic,
                        style:
                            AppType.caption1.r.copyWith(color: c.labelNormal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _divider(context),
            const SizedBox(height: 12),
            Text(
              p.usage,
              style: AppType.caption1.r.copyWith(color: c.labelNormal),
            ),
          ]),
        ];

      case SheetContentType.streak:
        return [
          const SizedBox(height: 16),
          _card(context, [
            Row(
              children: [
                for (var i = 0; i < streakDays.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: _DayCell(day: streakDays[i])),
                ],
              ],
            ),
            if (streakNote != null) ...[
              const SizedBox(height: 12),
              _divider(context),
              const SizedBox(height: 12),
              Text(
                streakNote!,
                style: AppType.caption1.r.copyWith(color: c.labelNormal),
              ),
            ],
          ]),
        ];

      case SheetContentType.video:
        return [
          const SizedBox(height: 16),
          Container(
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: c.backgroundElevatedAlternative,
              borderRadius: BorderRadius.circular(12),
            ),
            child: videoPreview ?? const _VideoPlaceholder(),
          ),
          if (videoPrice != null) ...[
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  if (videoPriceOriginal != null) ...[
                    TextSpan(
                      text: videoPriceOriginal,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: c.labelNormal,
                      ),
                    ),
                    const TextSpan(text: '  '),
                  ],
                  TextSpan(text: videoPrice),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppType.caption1.r.copyWith(color: c.labelNormal),
            ),
          ],
        ];
    }
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _divider(BuildContext context) =>
      Container(height: 1, color: context.c.lineAlternative);
}

/// One 56px label/value line of the rows card. The last row draws no divider —
/// the rule every card in this redesign obeys (spec §5-6).
class _RowLine extends StatelessWidget {
  const _RowLine({required this.data, required this.last});

  final SheetRowData data;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: last
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(color: c.lineAlternative, width: 0.5),
              ),
            ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data.label,
              style: AppType.label1.r.copyWith(color: c.commonWhiteAndDark),
            ),
          ),
          Text(
            data.value,
            style: AppType.label1.r.copyWith(
              color: data.highlighted ? c.primaryNormal : c.labelNormal,
            ),
          ),
        ],
      ),
    );
  }
}

/// One 64px streak day cell.
class _DayCell extends StatelessWidget {
  const _DayCell({required this.day});

  final SheetStreakDay day;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: c.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcons.check(
            size: 20,
            color: day.done ? c.primaryNormal : c.labelAssistive,
          ),
          const SizedBox(height: 6),
          Text(
            day.label,
            style: AppType.caption2.m.copyWith(color: c.labelNormal),
          ),
        ],
      ),
    );
  }
}

/// 56px result disc — Figma `Mark` (`4365:31487`).
class _Mark extends StatelessWidget {
  const _Mark({required this.tone});

  final SheetMarkTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final success = tone == SheetMarkTone.success;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: success ? c.primaryNormal14 : c.statusNegative6,
      ),
      child: Center(
        child: success
            ? AppIcons.check(size: 32, color: c.primaryNormal)
            // `alert` is now a canonical asset (`assets/icons/alert.svg`,
            // exported from `4395:1387`); colour is the host's call per the
            // icon's own Figma note.
            : AppIcons.alert(size: 32, color: c.accentForegroundRed),
      ),
    );
  }
}

/// The default video-card composition: a 68px avatar disc centred, a 42×56
/// self-view pill top-right — mirroring the Figma placeholder.
class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Stack(
      children: [
        Center(
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.backgroundElevatedNormal,
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 42,
            height: 56,
            decoration: BoxDecoration(
              color: c.backgroundElevatedNormal,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
