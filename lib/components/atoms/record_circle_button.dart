import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
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
  });

  /// Centered glyph builder (e.g. [AppIcons.mic], [AppIcons.redo]).
  final AppIconBuilder icon;

  /// Tap handler. When null the button is inert.
  final VoidCallback? onTap;

  /// Accessible label.
  final String? semanticLabel;

  /// Diameter (Figma 96).
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.text, // white fill
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.green700, width: 4),
          ),
          alignment: Alignment.center,
          child: icon(size: 40, color: AppColors.green700),
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
