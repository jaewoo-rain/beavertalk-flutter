import 'package:flutter/material.dart';
import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';

/// RecordCircleButton — a 96px white circle with a green-700 ring and a centered
/// green-700 glyph. The shared record-control affordance used by the learning
/// flow: the idle mic (Figma `mic` 37:41772) and the retry control on
/// `screen/learning_next` (`2117:20147`), both white-filled with a
/// `#00B57E` ring.
class RecordCircleButton extends StatelessWidget {
  /// Creates a record-control circle button.
  const RecordCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.size = 96,
    this.cautionary = false,
  });

  /// Centered glyph builder (e.g. [AppIcons.mic], [AppIcons.redo]).
  final AppIconBuilder icon;

  /// Tap handler. When null the button is inert.
  final VoidCallback? onTap;

  /// Accessible label.
  final String? semanticLabel;

  /// Diameter (Figma 96).
  final double size;

  /// Ring and glyph in `Status/Cautionary` instead of `Primary/Heavy` — the
  /// retry after a recognition failure (Figma `learning/9_failed` `5236:8536`).
  /// A plain retry after a result stays mint: only a failure is flagged.
  final bool cautionary;

  @override
  Widget build(BuildContext context) {
    final tone = cautionary ? context.c.statusCautionary : context.c.primaryHeavy;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            // Static/White, not Label/Strong: this is the white disc inside a
            // mint ring, and it must stay white in Light too.
            color: context.c.staticWhite,
            shape: BoxShape.circle,
            border: Border.all(color: tone, width: 4),
          ),
          alignment: Alignment.center,
          child: icon(size: 40, color: tone),
        ),
      ),
    );
  }
}

/// Gallery demo for [RecordCircleButton].
class RecordCircleButtonDemo extends StatelessWidget {
  /// Creates the demo.
  const RecordCircleButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RecordCircleButton(icon: AppIcons.mic, onTap: _noop, semanticLabel: 'mic'),
          SizedBox(width: 24),
          RecordCircleButton(
              icon: AppIcons.redo, onTap: _noop, semanticLabel: 'retry'),
        ],
      ),
    );
  }

  static void _noop() {}
}
