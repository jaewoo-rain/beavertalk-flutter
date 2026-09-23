import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';
import '../../theme/app_typography.dart';
import '../atoms/toggle.dart';
import '../layout/need_based_rows.dart';

/// The three line-row layouts of [CardLine].
enum CardLineType {
  /// A two-column payment receipt row: label + meta on the left, value + status
  /// on the right.
  payment,

  /// A label/value row with a trailing chevron (e.g. a settings entry).
  ///
  /// 높이 하한 56px(내용이 넘으면 늘어난다).
  defaultRow,

  /// A label row with a trailing [AppToggle].
  ///
  /// 높이 하한 56px(내용이 넘으면 늘어난다).
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
/// * [CardLineType.defaultRow] — a min-56px row: [label]/[value] (Body 1 Regular,
///   white) space-between, with a trailing 24px chevron.
/// * [CardLineType.defaultToggle] — a min-56px row: [label] (Body 1 Regular, white)
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
  /// (e.g. `"완료"`), rendered in `Status/Positive`.
  final String? status;

  /// Current toggle value for [CardLineType.defaultToggle].
  final bool checked;

  /// Toggle callback for [CardLineType.defaultToggle]. When null the toggle is
  /// non-interactive.
  final ValueChanged<bool>? onChanged;

  /// 정본 행 높이. **고정이 아니라 하한이다.**
  ///
  /// 예전에는 `SizedBox(height: 56)` 이었는데, 그러면 글꼴 배율 1.3배나 긴
  /// 번역에서 내용이 56을 넘어가는 순간 넘친 줄이 **통째로 잘린다**. 실측
  /// (2026-09-22, 네팔어 · 배율 200%→상한 1.3): 설정 이메일 행이
  /// `soardick@gmail.` 로, 가입일 라벨은 둘째 줄이 잘려 나왔다.
  ///
  /// 잘림은 넘침보다 나쁘다 — 화면 안에 남아서 **틀린 내용으로 읽힌다.**
  /// 그래서 56은 지키되 위로 열어 둔다(`minHeight`).
  static const double _rowHeight = 56;

  // A divider colour is mode-aware, so this can no longer be a static
  // const — it is built per context instead.
  static BoxDecoration _divider(BuildContext context) => BoxDecoration(
    border: Border(
      bottom: BorderSide(color: context.c.lineAlternative, width: 0.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardLineType.payment:
        return _buildPayment(context);
      case CardLineType.defaultRow:
        return _buildDefaultRow(context);
      case CardLineType.defaultToggle:
        return _buildDefaultToggle(context);
    }
  }

  Widget _buildPayment(BuildContext context) {
    return DecoratedBox(
      decoration: _divider(context),
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
                    style: AppType.label1.r.copyWith(color: context.c.labelStrong),
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
            //
            // ⛔ 금액과 상태를 한 줄로 자르지 마라 — 「1.790.0…」 은 틀린 금액이고,
            //   잘린 결제 상태는 잘못된 사실이다. 이 Column 은 비유연이라 제 크기를
            //   가지므로, 줄만 늘려도 넘치지 않는다.
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null)
                  Text(
                    value!,
                    textAlign: TextAlign.end,
                    style: AppType.label1.sb.copyWith(color: context.c.labelStrong),
                  ),
                if (status != null) ...[
                  const SizedBox(height: 7),
                  Text(
                    status!,
                    textAlign: TextAlign.end,
                    style: AppType.label1.r.copyWith(color: context.c.statusPositive),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultRow(BuildContext context) {
    return DecoratedBox(
      decoration: showDivider ? _divider(context) : const BoxDecoration(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _rowHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // 라벨 왼쪽 끝 · 값 오른쪽 끝(Figma justify-between). 폭은 **글자 폭대로** 나눈다
                // (LabelValueRow) — Flexible 둘은 짧은 칸이 남긴 폭을 긴 칸이 못 써서 「Lernsprache」
                // 가 줄을 바꾸는데 옆 「한국어」 는 67px 가 남았다(09-24 전수조사 A).
                child: value == null
                    ? Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.body1.r.copyWith(color: context.c.labelStrong),
                      )
                    : LabelValueRow(
                        label: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppType.body1.r.copyWith(color: context.c.labelStrong),
                        ),
                        // 값은 자르지 않는다 — 금액·상태가 잘리면 거짓이 된다.
                        value: Text(
                          value!,
                          textAlign: TextAlign.end,
                          style:
                              AppType.body1.r.copyWith(color: context.c.labelStrong),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              AppIcons.chevronRight(
                size: 24,
                color: context.c.labelStrong,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultToggle(BuildContext context) {
    return DecoratedBox(
      decoration: showDivider ? _divider(context) : const BoxDecoration(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _rowHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  // 설정 항목 이름. 행 높이는 이미 하한이라 두 줄이 들어간다
                  // (de 「Benachrichtigung」 전수감사 1건).
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body1.r.copyWith(color: context.c.labelStrong),
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
            decoration: BoxDecoration(
              color: context.c.labelDisabled,
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
        style: AppType.label1.r.copyWith(color: context.c.labelNormal),
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
      color: context.c.backgroundNormalDeep,
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
