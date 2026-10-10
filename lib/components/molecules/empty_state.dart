import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';

/// Which type ramp an empty block draws at.
///
/// The two scales are the difference between Figma's `Empty/Screen` and
/// `Empty/Card`: the same title/body/CTA structure, sized for a whole screen
/// or for a block sitting inside a card.
enum EmptyScale {
  /// `Empty/Screen` — title [AppType.headline1], body [AppType.label1],
  /// CTA [BtnSize.s60].
  screen,

  /// `Empty/Card` — title [AppType.body2], body [AppType.label2],
  /// CTA [BtnSize.s44].
  card,
}

/// The empty-state copy block: an optional title, a body line, an optional CTA.
/// Figma `Empty/Card` variant `type=inline` (`4784:7138`) — the block with no
/// surface of its own.
///
/// Sizes itself to its content and does **not** center; the caller places it.
/// Use it where an empty region sits in a scrolling page that already has its
/// own spacing (the payment history list, the avatar sections). For a region
/// that should fill and center, use [EmptyScreen].
///
/// [title] is optional because several existing empty states only ever had one
/// string, and the work order is explicit that no new copy may be invented to
/// fill the slot — a missing title means the arb has no title, not that one
/// should be written.
class EmptyBlock extends StatelessWidget {
  /// Creates an empty-state copy block.
  const EmptyBlock({
    super.key,
    this.title,
    this.body,
    this.ctaText,
    this.onCta,
    this.scale = EmptyScale.screen,
    this.ctaSize,
    this.ctaType = BtnType.primaryFill,
  })  : assert(
          (ctaText == null) == (onCta == null),
          'A CTA needs both its label and its action',
        ),
        assert(title != null || body != null, 'An empty state needs some copy');

  /// Heading line, or null when the copy is a single sentence.
  final String? title;

  /// The explanatory line, or null when the copy is a title alone.
  ///
  /// Both slots are optional because Figma's `Empty/*` instances hide whichever
  /// they do not need — the analysis expressions card shows a Title with the
  /// Body hidden, the archive shows the reverse. At least one must be present.
  final String? body;

  /// CTA label, or null for the no-CTA variants.
  final String? ctaText;

  /// CTA action. Must accompany [ctaText].
  final VoidCallback? onCta;

  /// Type ramp — see [EmptyScale].
  final EmptyScale scale;

  /// Overrides the CTA height. Defaults to 60 on [EmptyScale.screen] and 44 on
  /// [EmptyScale.card]; the mypage cards use 60 to match the button their
  /// populated state draws.
  final BtnSize? ctaSize;

  /// CTA emphasis. Defaults to the filled brand button, which is right when the
  /// empty state owns the screen. Cards that sit two-to-a-page drop to
  /// [BtnType.secondaryElevated] — only one action per screen gets the mint.
  final BtnType ctaType;

  bool get _isScreen => scale == EmptyScale.screen;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = (_isScreen ? AppType.headline1 : AppType.body2)
        .sb
        .copyWith(color: context.c.labelStrong);
    final TextStyle bodyStyle = (_isScreen ? AppType.label1 : AppType.label2)
        .r
        .copyWith(color: context.c.labelNormal);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Text(title!, textAlign: TextAlign.center, style: titleStyle),
          // Figma draws 8 here on Empty/Screen. Empty/Card is inconsistent
          // between its own variants (6 on `no-cta`, 12 on `with-cta`); 8 keeps
          // one rhythm rather than encoding that split.
          if (body != null) const SizedBox(height: AppSpacing.s8),
        ],
        if (body != null)
          Text(body!, textAlign: TextAlign.center, style: bodyStyle),
        if (ctaText != null) ...[
          SizedBox(height: _isScreen ? AppSpacing.s20 : AppSpacing.s12),
          Button(
            type: ctaType,
            size: ctaSize ?? (_isScreen ? BtnSize.s60 : BtnSize.s44),
            text: ctaText!,
            onPressed: onCta,
          ),
        ],
      ],
    );
  }
}

/// Figma `Empty/Screen` (`4780:7055`) — an [EmptyBlock] that fills its box and
/// centers, scrolling when the box is shorter than the content.
///
/// This is what a tab body or a list region becomes when the request succeeded
/// and returned nothing. It is **not** an error state: a failed request draws
/// `NetworkErrorView` instead. Figma carries a `type=error` variant here too,
/// but wiring it would give the app two ways to render the same failure, so
/// this widget deliberately covers only the empty half.
class EmptyScreen extends StatelessWidget {
  /// Creates a centered, full-box empty state.
  const EmptyScreen({
    super.key,
    this.title,
    this.body,
    this.ctaText,
    this.onCta,
  });

  /// Heading line, or null when the copy is a single sentence.
  final String? title;

  /// The explanatory line, or null when the title stands alone.
  final String? body;

  /// CTA label, or null when there is nothing to offer.
  final String? ctaText;

  /// CTA action. Must accompany [ctaText].
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: ContentColumn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EmptyBlock(
                    title: title,
                    body: body,
                    ctaText: ctaText,
                    onCta: onCta,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma `Empty/Card` (`4780:28644`) — an [EmptyBlock] on a card surface.
///
/// For a card whose contents have not arrived yet, where the card itself should
/// stay on screen so the section keeps its shape. Omitting [title] gives the
/// `type=compact` variant, omitting [ctaText] gives `type=no-cta`.
class EmptyCard extends StatelessWidget {
  /// Creates a card-surfaced empty state.
  const EmptyCard({
    super.key,
    this.title,
    this.body,
    this.ctaText,
    this.onCta,
    this.ctaSize,
    this.ctaType = BtnType.primaryFill,
  });

  /// Heading line, or null for the compact variant.
  final String? title;

  /// The explanatory line, or null when the title stands alone.
  final String? body;

  /// CTA label, or null for the no-CTA variant.
  final String? ctaText;

  /// CTA action. Must accompany [ctaText].
  final VoidCallback? onCta;

  /// Overrides the CTA height — see [EmptyBlock.ctaSize].
  final BtnSize? ctaSize;

  /// CTA emphasis — see [EmptyBlock.ctaType].
  final BtnType ctaType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: EmptyBlock(
        title: title,
        body: body,
        ctaText: ctaText,
        onCta: onCta,
        ctaSize: ctaSize,
        ctaType: ctaType,
        scale: EmptyScale.card,
      ),
    );
  }
}

/// Figma `Empty/Row` (`4780:28645`) — one centered line at row height, for a
/// table or list that has its rows' worth of space reserved but nothing to put
/// in it.
class EmptyRow extends StatelessWidget {
  /// Creates a single-line row placeholder.
  const EmptyRow({super.key, required this.label});

  /// The line to show.
  final String label;

  /// Figma row height (`4780:28645` is 41 tall).
  static const double height = 41;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppType.label2.r.copyWith(color: context.c.labelNormal),
        ),
      ),
    );
  }
}
