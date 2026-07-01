import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../icons/app_icons.dart';

/// CardBookmark — a learned/saved sentence card, measured from Figma
/// `Card-Bookmark` (`2224:21261`).
///
/// An [AppColors.surfaceElevated] box (radius 12, padding `16/20`) holding the
/// [korean] sentence (Body 1 SemiBold, white) over its [native] translation
/// (Body 1 Regular, secondary), a hairline divider, then a footer row of a
/// speaker glyph + a toggleable bookmark glyph and — optionally — a trailing
/// [actionText] [Button].
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
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _koreanText(),
          const SizedBox(height: 4),
          Text(
            native,
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderSubtle,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _glyph(AppIcons.volume, onSpeakerTap),
              const SizedBox(width: 8),
              _glyph(
                bookmarked ? AppIcons.bookmarkFill : AppIcons.bookmarkLine,
                onBookmarkTap,
                color: bookmarked ? AppColors.primary : AppColors.text,
              ),
              const Spacer(),
              if (actionText != null)
                Button(
                  type: BtnType.secondaryFill,
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
  Widget _koreanText() {
    final base = AppType.body1.sb.copyWith(color: AppColors.text);
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
    Color color = AppColors.text,
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
