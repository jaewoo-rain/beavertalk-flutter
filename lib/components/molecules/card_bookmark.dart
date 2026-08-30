import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/icon_toggle.dart';
import '../icons/app_icons.dart';

/// CardBookmark — a learned/saved sentence card, measured from Figma
/// `Card-Bookmark` (`176:14676`, as instanced at `3583:34466` in
/// `screen/analysis` and `3360:115` in `screen/record_archive`).
///
/// An `Background/Elevated/Alternative` box (radius 12, padding `16/20`) holding the
/// [korean] sentence (Label 1 SemiBold, white) over its [native] translation
/// (Caption 1 Regular, secondary), then a footer row of a speaker glyph + a
/// toggleable bookmark glyph and — optionally — a trailing [actionText]
/// [Button]. 116 tall with [highlight] unset **and [actionText] set**; without
/// the button the footer row collapses to the 24px glyphs and the card is 104,
/// which is 12 short of what [CardLoading] reserves. Every frame that instances
/// this card has the button.
///
/// The two instances differ by 4px (116 vs 120) purely in how they style the
/// highlighted span — analysis underlines it at 14px, the archive bumps it to
/// 16px. No server field carries that span, so [highlight] is null in practice
/// and both render at 116.
///
/// Used by both the 대화 기록 detail (analysis, "연습하기" action + bookmark
/// toggle) and the 보관 archive (whole-card tap → that sentence's review).
class CardBookmark extends StatelessWidget {
  /// Creates a bookmark/sentence card.
  const CardBookmark({
    super.key,
    required this.korean,
    required this.native,
    required this.bookmarked,
    this.highlight,
    this.onBookmarkTap,
    this.onSpeakerTap,
    this.actionText,
    this.onAction,
    this.onTap,
  });

  /// The learned sentence (Korean).
  final String korean;

  /// Optional substring of [korean] to underline (the learned expression, per
  /// Figma). When null or not found, [korean] renders plain.
  final String? highlight;

  /// The translation shown under [korean].
  final String native;

  /// Whether this sentence is bookmarked (filled vs outline glyph).
  final bool bookmarked;

  /// Tapped when the bookmark glyph is pressed. When null the glyph is static.
  final VoidCallback? onBookmarkTap;

  /// Tapped when the speaker glyph is pressed.
  final VoidCallback? onSpeakerTap;

  /// Optional trailing button label (e.g. "연습하기"). Hidden when null.
  final String? actionText;

  /// Tapped when the trailing action button is pressed.
  final VoidCallback? onAction;

  /// Tapped when the whole card is pressed (e.g. open the sentence's review).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _koreanText(context.c.labelStrong),
          const SizedBox(height: 4),
          Text(
            native,
            style: AppType.caption1.r.copyWith(color: context.c.labelNormal),
          ),
          // Figma Card-Bookmark: a single gap-xs (8) between the text block and
          // the footer row — no divider (`176:14677` wraps both in one gap-8
          // column).
          const SizedBox(height: 8),
          Row(
            children: [
              _glyph(AppIcons.volume, onSpeakerTap, color: context.c.labelStrong),
              const SizedBox(width: 8),
              // 즉시 갈아 끼우면 껐다 켠 티가 안 난다 — 교차 페이드 + 팝.
              IconToggle(
                value: bookmarked,
                onIcon: AppIcons.bookmarkFill,
                offIcon: AppIcons.bookmarkLine,
                onColor: context.c.primaryNormal,
                offColor: context.c.labelStrong,
                onTap: onBookmarkTap,
              ),
              const Spacer(),
              if (actionText != null)
                Button(
                  // `176:15497` fills this with Elevated/Normal (#2F3340), not
                  // the #252932 `secondaryFill` gives — on the card's own
                  // #1F222A that one step would barely register.
                  type: BtnType.secondaryElevated,
                  size: BtnSize.s36,
                  text: actionText!,
                  onPressed: onAction,
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: card),
    );
  }

  /// The Korean line, underlining [highlight] (the learned expression) when set.
  Widget _koreanText(Color base_) {
    final base = AppType.label1.sb.copyWith(color: base_);
    final h = highlight;
    if (h == null || h.isEmpty || !korean.contains(h)) {
      return Text(korean, style: base);
    }
    final i = korean.indexOf(h);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: korean.substring(0, i)),
          TextSpan(
            text: h,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(text: korean.substring(i + h.length)),
        ],
      ),
    );
  }

  /// A 24px tappable footer glyph (no ripple box when [onTap] is null).
  Widget _glyph(
    AppIconBuilder icon,
    VoidCallback? onTap, {
    required Color color,
  }) {
    final glyph = icon(size: 24, color: color);
    if (onTap == null) return glyph;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: glyph,
    );
  }
}
