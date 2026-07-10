import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/dim.dart';

/// One feedback option in [BottomSheetFeedback].
class FeedbackOption {
  /// Creates a feedback option.
  const FeedbackOption({required this.value, required this.icon});

  /// Opaque identity (compared by `==`); drives selection.
  final String value;

  /// The 24px glyph shown inside the option card's circle.
  final IconData icon;
}

/// BottomSheet-Feedback — 3-option feedback sheet (👎 / 👍 / 😍).
///
/// Figma `03_Organisms / BottomSheet-Feedback` (`176:15420`), measured 1:1 via
/// MCP.
///
/// Layout (top → bottom):
/// - Header row (`16/20` padding, space-between): an invisible 24px spacer on
///   the left and a 24px close glyph on the right (tap → [onClose]).
/// - Options row (335 wide, centered, gap 16): three option cards. Each card is
///   built directly here (the [icon] differs per option, so the thumbs-only
///   ThumbsUp atom is not reused) but matches ThumbsUp's geometry and `active`
///   styling 1:1:
///   - Card 101×112, `borderRadius` 20, padding `28×24`, 1px stroke.
///   - Inner circle 56×56 (pill radius) holding a 24px icon.
///   - selected → stroke + icon [AppColors.primary], inner fill
///     [AppColors.primary10].
///   - unselected → stroke + inner fill [AppColors.borderSubtle], icon
///     [AppColors.textSecondary].
///   Default ordering per spec: 좌 👎 / 중 👍 / 우 😍 (using
///   `Icons.thumb_down` / `Icons.thumb_up` / `Icons.sentiment_very_satisfied`).
/// - Footer: a 335-wide primary "선택 완료" button ([confirmText] → [onConfirm])
///   above a reused [HomeIndicator].
///
/// Sheet shell: 375 wide, top corners `AppRadius.lg` (24), fill
/// [AppColors.surfaceElevated]. Controlled — pass [value] (the selected
/// [FeedbackOption.value]) and react to [onChanged].
class BottomSheetFeedback extends StatelessWidget {
  /// Creates a feedback bottom sheet.
  const BottomSheetFeedback({
    super.key,
    this.options = defaultOptions,
    required this.value,
    this.onChanged,
    this.onConfirm,
    this.confirmText = '선택 완료',
    this.onClose,
  });

  /// The default 3 options: 👎 / 👍 / 😍 (left → right).
  static const List<FeedbackOption> defaultOptions = [
    FeedbackOption(value: 'bad', icon: Icons.thumb_down),
    FeedbackOption(value: 'good', icon: Icons.thumb_up),
    FeedbackOption(value: 'love', icon: Icons.sentiment_very_satisfied),
  ];

  /// The feedback options to render (left → right).
  final List<FeedbackOption> options;

  /// Currently-selected [FeedbackOption.value], or `null` for none.
  final String? value;

  /// Called with the tapped option's [FeedbackOption.value].
  final ValueChanged<String>? onChanged;

  /// Called when the confirm button is pressed.
  final VoidCallback? onConfirm;

  /// Confirm button label (Figma: "선택 완료").
  final String confirmText;

  /// Called when the header close glyph is tapped.
  final VoidCallback? onClose;

  /// Max sheet width — matches [AppScaffold]'s 430px phone-column cap; the
  /// sheet otherwise fills its host width (Figma reference device: 375).
  static const double _maxWidth = 430;
  static const double _contentWidth = 335;

  @override
  Widget build(BuildContext context) {
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
            _header(),
            // Options row.
            Center(
              child: SizedBox(
                width: _contentWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < options.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      _OptionCard(
                        icon: options[i].icon,
                        selected: options[i].value == value,
                        onTap: onChanged == null
                            ? null
                            : () => onChanged!(options[i].value),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  /// Header row: invisible spacer + close glyph (right-aligned).
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24, height: 24),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 24,
              splashRadius: 18,
              onPressed: onClose,
              icon: AppIcons.close(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer: primary confirm button (335 wide) + home indicator.
  Widget _footer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: _contentWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.md),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: onConfirm,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      confirmText,
                      textAlign: TextAlign.center,
                      style: AppType.body1.sb.copyWith(
                        color: AppColors.onPrimary,
                        letterSpacing: -0.4, // Figma -0.025em × 16
                      ),
                    ),
                  ),
                ),
              ),
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

/// A single feedback option card — ThumbsUp geometry, per-option icon.
///
/// Built directly (not via the ThumbsUp atom) because the icon varies; the
/// `selected` palette matches ThumbsUp `active` 1:1.
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  static const double _width = 101;
  static const double _height = 112;
  static const double _innerSize = 56;
  static const double _iconSize = 24;
  static const double _outerRadius = 20;

  @override
  Widget build(BuildContext context) {
    final Color stroke =
        selected ? AppColors.primary : AppColors.borderSubtle;
    final Color innerFill =
        selected ? AppColors.primary10 : AppColors.borderSubtle;
    final Color iconColor =
        selected ? AppColors.primary : AppColors.textSecondary;

    final content = Container(
      width: _width,
      height: _height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: stroke),
        borderRadius: BorderRadius.circular(_outerRadius),
      ),
      child: Container(
        width: _innerSize,
        height: _innerSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: innerFill,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: _iconSize, color: iconColor),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_outerRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(_outerRadius),
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}

/// Gallery demo: [BottomSheetFeedback] over a [Dim], bottom-aligned.
class BottomSheetFeedbackDemo extends StatefulWidget {
  /// Creates the demo.
  const BottomSheetFeedbackDemo({super.key});

  @override
  State<BottomSheetFeedbackDemo> createState() =>
      _BottomSheetFeedbackDemoState();
}

class _BottomSheetFeedbackDemoState extends State<BottomSheetFeedbackDemo> {
  String _value = 'good';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        children: [
          Dim(onTap: () {}),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetFeedback(
              value: _value,
              onChanged: (v) => setState(() => _value = v),
              onConfirm: () {},
              onClose: () {},
            ),
          ),
        ],
      ),
    );
  }
}
