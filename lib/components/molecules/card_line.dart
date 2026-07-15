import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_typography.dart';
import '../atoms/toggle.dart';

/// The three line-row layouts of [CardLine].
enum CardLineType {
  /// A two-column payment receipt row: label + meta on the left, value + status
  /// on the right.
  payment,

  /// A label/value row with a trailing chevron (e.g. a settings entry).
  ///
  /// Defaults to a fixed 56px height.
  defaultRow,

  /// A label row with a trailing [AppToggle].
  ///
  /// Defaults to a fixed 56px height.
  defaultToggle,
}

/// CardLine — a single list line measured 1:1 from Figma (`Card-Line`
/// set `176:15525`).
///
/// Measured spec (shared): a bottom-only divider of `borderSubtle`
/// (Line/Normal/Alternative, white @ 6%) at 0.5px and `8px 12px` padding.
///
/// * [CardLineType.payment] — a column laying out one space-between row.
///   The left side stacks [label] (Label 1 Regular, white) over a [meta] row
///   (Label 1 Regular, `textSecondary`) separated by a 2×2 `textTertiary` dot;
///   `meta` is split on `·` into segments. The right side stacks [value]
///   (Label 1 SemiBold, white) over [status] (Label 1 Regular, `success`).
/// * [CardLineType.defaultRow] — a 56px row: [label]/[value] (Body 1 Regular,
///   white) space-between, with a trailing 24px chevron.
/// * [CardLineType.defaultToggle] — a 56px row: [label] (Body 1 Regular, white)
///   with a trailing [AppToggle] driven by [checked]/[onChanged].
class CardLine extends StatelessWidget {
  /// Creates a card line of the given [type].
  const CardLine({
    super.key,
    required this.type,
    required this.label,
    this.value,
    this.meta,
    this.status,
    this.checked = false,
    this.onChanged,
    this.showDivider = true,
  });

  /// Whether to draw the bottom hairline divider. Set `false` for the last row
  /// in a grouped card (Figma groups rows in a card; only inner rows divide).
  final bool showDivider;

  /// Which line layout to render.
  final CardLineType type;

  /// The primary label text (left side of every variant).
  final String label;

  /// The value text.
  ///
  /// Used as the bold amount in [CardLineType.payment] and as the right-hand
  /// value in [CardLineType.defaultRow].
  final String? value;

  /// Secondary meta line for [CardLineType.payment], split on `·` into
  /// dot-separated segments (e.g. `"6월 3일·신한카드 1234"`).
  final String? meta;

  /// Status text shown under [value] in [CardLineType.payment]
  /// (e.g. `"완료"`), rendered in [AppColors.success].
  final String? status;

  /// Current toggle value for [CardLineType.defaultToggle].
  final bool checked;

  /// Toggle callback for [CardLineType.defaultToggle]. When null the toggle is
  /// non-interactive.
  final ValueChanged<bool>? onChanged;

  static const double _rowHeight = 56;

  static const BoxDecoration _divider = BoxDecoration(
    border: Border(
      bottom: BorderSide(color: AppColors.borderSubtle, width: 0.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardLineType.payment:
        return _buildPayment();
      case CardLineType.defaultRow:
        return _buildDefaultRow();
      case CardLineType.defaultToggle:
        return _buildDefaultToggle();
    }
  }

  Widget _buildPayment() {
    return DecoratedBox(
      decoration: _divider,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          // Left takes all remaining width; right hugs its content.
          //
          // Both sides used to be Flexible(flex: 1), which splits the free space
          // exactly 50/50 regardless of need — so an amount as short as "12.9$"
          // still reserved half the row, squeezing the label/meta column into
          // the other half and ellipsizing meta text that had room to spare
          // ("신한카드 1234" → "신한카드 12…"). Figma has both sides shrink-to-fit
          // under justify-between, i.e. the value never claims unused width.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label1.r.copyWith(color: AppColors.text),
                  ),
                  if (meta != null) ...[
                    const SizedBox(height: 7),
                    _MetaRow(meta: meta!),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Not flexed: sizes to the amount/status, staying pinned right.
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null)
                  Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label1.sb.copyWith(color: AppColors.text),
                  ),
                if (status != null) ...[
                  const SizedBox(height: 7),
                  Text(
                    status!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label1.r.copyWith(color: AppColors.success),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultRow() {
    return DecoratedBox(
      decoration: showDivider ? _divider : const BoxDecoration(),
      child: SizedBox(
        height: _rowHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  // Keep the original label-left / value-right split; only wrap
                  // the two texts in Flexible + ellipsis so long translations
                  // shrink in place instead of overflowing (design preserved).
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppType.body1.r.copyWith(color: AppColors.text),
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          value!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style:
                              AppType.body1.r.copyWith(color: AppColors.text),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AppIcons.chevronRight(
                size: 24,
                color: AppColors.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultToggle() {
    return DecoratedBox(
      decoration: showDivider ? _divider : const BoxDecoration(),
      child: SizedBox(
        height: _rowHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body1.r.copyWith(color: AppColors.text),
                ),
              ),
              const SizedBox(width: 10),
              AppToggle(value: checked, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dot-separated meta row for [CardLineType.payment].
///
/// Segments are split on `·`; a 2×2 [AppColors.textTertiary] dot separates them.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.meta});

  final String meta;

  @override
  Widget build(BuildContext context) {
    final segments = meta
        .split('·')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final children = <Widget>[];
    for (var i = 0; i < segments.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: 4));
        children.add(
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: AppColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
        );
        children.add(const SizedBox(width: 4));
      }
      final text = Text(
        segments[i],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
      );
      // Only the last segment may shrink. Wrapping every segment in Flexible
      // split the row evenly between them, so "6월 3일 · 신한카드 1234" gave the
      // short date as much width as the long card name and clipped the name
      // ("신한카드 12…") even with space left over. Leading segments are the
      // stable ones (a date), so they keep their intrinsic width and any real
      // overflow lands on the trailing segment.
      children.add(i == segments.length - 1 ? Flexible(child: text) : text);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Gallery demo exposing every [CardLine] variant.
class CardLineDemo extends StatefulWidget {
  /// Creates the CardLine gallery demo.
  const CardLineDemo({super.key});

  @override
  State<CardLineDemo> createState() => _CardLineDemoState();
}

class _CardLineDemoState extends State<CardLineDemo> {
  bool _toggleA = true;
  bool _toggleB = false;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CardLine(
              type: CardLineType.payment,
              label: '프리미엄 구독(월간)',
              meta: '6월 3일·신한카드 1234',
              value: '12.9\$',
              status: '완료',
            ),
            const SizedBox(height: 16),
            const CardLine(
              type: CardLineType.defaultRow,
              label: 'User Language',
              value: 'English(US)',
            ),
            const SizedBox(height: 16),
            CardLine(
              type: CardLineType.defaultToggle,
              label: 'User Language',
              checked: _toggleA,
              onChanged: (v) => setState(() => _toggleA = v),
            ),
            CardLine(
              type: CardLineType.defaultToggle,
              label: '텍스트 내용 텍스트 내용',
              checked: _toggleB,
              onChanged: (v) => setState(() => _toggleB = v),
            ),
          ],
        ),
      ),
    );
  }
}
