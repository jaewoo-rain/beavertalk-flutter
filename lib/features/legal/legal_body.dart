import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Renders a legal Markdown document ([data]) with a custom dark-theme
/// [MarkdownStyleSheet], approximating the beavertalk.im /terms · /policy look:
///
/// * `#`  page title — biggest (Title 2 Bold, white)
/// * `##` section     — Headline 1 SemiBold, white (source uppercase reads as
///   emphasis)
/// * `###` sub-section — Body 1 SemiBold, white
/// * body — Body 2 Regular in secondary grey with a comfortable line height
/// * `**bold**` — brighter + heavier (Body 2 SemiBold, white)
/// * `-` bullets — secondary grey
///
/// The [Markdown] widget scrolls itself. Edit the copy in `legal_texts.dart`.
class LegalBody extends StatelessWidget {
  /// Creates a legal body rendering the Markdown [data].
  const LegalBody({super.key, required this.data});

  /// The raw Markdown document to render.
  final String data;

  @override
  Widget build(BuildContext context) {
    // Body line height tightened from body2's native ~1.47 to 1.38 for denser,
    // website-like legal copy. Applied to every body-level (body2) style so
    // paragraphs, bold labels, and list items share one line height. Titles
    // (h1/h2/h3) keep their own metrics.
    const bodyHeight = 1.38;
    final sheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      // Page title (`#`) — biggest.
      h1: AppType.title2.b.copyWith(color: AppColors.text),
      h1Padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      // Section heading (`##`) — white; source uppercase reads as emphasis.
      h2: AppType.headline1.sb.copyWith(color: AppColors.text),
      h2Padding:
          const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s4),
      // Sub-section heading (`###`) — smaller.
      h3: AppType.body1.sb.copyWith(color: AppColors.text),
      h3Padding: const EdgeInsets.only(top: AppSpacing.s12),
      // Body — readable secondary grey.
      p: AppType.body2.r
          .copyWith(color: context.c.labelNormal, height: bodyHeight),
      // Emphasis — brighter + heavier on the dark theme.
      strong:
          AppType.body2.sb.copyWith(color: AppColors.text, height: bodyHeight),
      em: AppType.body2.r.copyWith(
        color: context.c.labelNormal,
        fontStyle: FontStyle.italic,
        height: bodyHeight,
      ),
      // Bullet / ordered lists.
      listBullet: AppType.body2.r
          .copyWith(color: context.c.labelNormal, height: bodyHeight),
      listIndent: AppSpacing.s20,
      // Inline links (if any appear in the copy).
      a: AppType.body2.r.copyWith(
        color: context.c.primaryNormal,
        decoration: TextDecoration.underline,
        height: bodyHeight,
      ),
      blockSpacing: AppSpacing.s12,
    );

    return Markdown(
      data: data,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s20, AppSpacing.s16, AppSpacing.s20, AppSpacing.s24),
      styleSheet: sheet,
    );
  }
}
