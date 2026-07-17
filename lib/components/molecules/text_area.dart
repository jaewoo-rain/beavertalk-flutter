import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Visual style for [TextArea], measured 1:1 from Figma `TextArea` set
/// `175:11371`.
enum TextAreaStyle {
  /// Full 1px border (`lineStrong`) with `surface2` fill, `radius md`, 16px
  /// inner padding.
  box,

  /// Bottom-only 1px border (`lineStrong`); no fill, no radius.
  underline,
}

/// A controlled multi-line text field measured 1:1 from Figma
/// (`TextArea` set `175:11371`).
///
/// The widget is **controlled** in either of two equivalent ways:
///
/// * pass a [controller] you own, **or**
/// * pass [value] together with [onChanged] (an internal controller is kept in
///   sync with [value]).
///
/// Provide at most one of [controller] / [value]; passing both throws.
///
/// Visual spec (measured):
/// * box — fill `surface2`, full 1px `lineStrong` border, `radius md` (16px),
///   16px padding on every edge.
/// * underline — no fill, 1px `lineStrong` border on the bottom edge only,
///   16px vertical padding, no horizontal padding.
///
/// The placeholder ([hintText]) renders in `textSecondary` using Label 1
/// Regular (14px); entered text renders white. When [maxLength] is set an
/// optional `current/max` counter (Label 2 Regular, `textSecondary`) is shown
/// bottom-right, matching the Figma `0/200` element.
class TextArea extends StatefulWidget {
  /// Creates a controlled multi-line text area.
  ///
  /// Supply either [controller] or ([value] + [onChanged]) — not both.
  const TextArea({
    super.key,
    this.controller,
    this.value,
    this.onChanged,
    this.hintText,
    this.style = TextAreaStyle.box,
    this.enabled = true,
    this.maxLength,
    this.minLines = 4,
    this.maxLines = 8,
    this.focusNode,
  }) : assert(
          controller == null || value == null,
          'Provide either `controller` or `value`, not both.',
        );

  /// An externally owned controller. Mutually exclusive with [value].
  final TextEditingController? controller;

  /// The current text, for the `value` + [onChanged] controlled form.
  final String? value;

  /// Called whenever the user edits the text.
  final ValueChanged<String>? onChanged;

  /// Placeholder shown when the field is empty (`textSecondary`).
  final String? hintText;

  /// The visual style — bordered box or bottom underline. Defaults to box.
  final TextAreaStyle style;

  /// Whether the field accepts input.
  final bool enabled;

  /// Optional max character count. When set, enforces the limit and shows a
  /// `current/max` counter bottom-right.
  final int? maxLength;

  /// Minimum visible lines (controls the initial height). Defaults to 4.
  final int minLines;

  /// Maximum visible lines before scrolling. Defaults to 8.
  final int maxLines;

  /// Optional external focus node.
  final FocusNode? focusNode;

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.value ?? '');
    _ownsController = widget.controller == null;
    _controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant TextArea old) {
    super.didUpdateWidget(old);
    if (widget.controller != old.controller) {
      _controller.removeListener(_onChanged);
      if (_ownsController) _controller.dispose();
      _controller = widget.controller ??
          TextEditingController(text: widget.value ?? '');
      _ownsController = widget.controller == null;
      _controller.addListener(_onChanged);
    } else if (_ownsController &&
        widget.value != null &&
        widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value!,
        selection: TextSelection.collapsed(offset: widget.value!.length),
        composing: TextRange.empty,
      );
    }
  }

  void _onChanged() {
    // Repaint the counter as the text length changes.
    if (widget.maxLength != null) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isBox = widget.style == TextAreaStyle.box;

    final TextStyle textStyle = AppType.label1.r.copyWith(
      color: widget.enabled ? AppColors.text : AppColors.textTertiary,
    );
    final TextStyle hintStyle = AppType.label1.r.copyWith(
      color: widget.enabled ? context.c.labelNormal : AppColors.textTertiary,
    );

    final field = TextField(
      controller: _controller,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      style: textStyle,
      cursorColor: context.c.primaryNormal,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      // We render our own counter, so hide the built-in one.
      buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
          null,
      inputFormatters: widget.maxLength != null
          ? [LengthLimitingTextInputFormatter(widget.maxLength)]
          : null,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        isDense: true,
        isCollapsed: true,
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: hintStyle,
      ),
    );

    final BoxDecoration decoration = isBox
        ? BoxDecoration(
            color: context.c.backgroundNormalAlternative,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: context.c.lineNormal, width: 1),
          )
        : BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.c.lineNormal, width: 1),
            ),
          );

    final EdgeInsets padding = isBox
        ? const EdgeInsets.all(16)
        : const EdgeInsets.symmetric(vertical: 16);

    Widget? counter;
    if (widget.maxLength != null) {
      counter = Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${_controller.text.characters.length}/${widget.maxLength}',
            style: AppType.label2.r.copyWith(color: context.c.labelNormal),
          ),
        ),
      );
    }

    return Container(
      decoration: decoration,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          field,
          ?counter,
        ],
      ),
    );
  }
}

/// Gallery demo exposing both [TextArea] styles (with and without a counter).
class TextAreaDemo extends StatefulWidget {
  /// Creates the text-area gallery demo.
  const TextAreaDemo({super.key});

  @override
  State<TextAreaDemo> createState() => _TextAreaDemoState();
}

class _TextAreaDemoState extends State<TextAreaDemo> {
  final _box = TextEditingController();
  final _boxCounter = TextEditingController();
  final _underline = TextEditingController();
  final _underlineCounter = TextEditingController();

  @override
  void dispose() {
    _box.dispose();
    _boxCounter.dispose();
    _underline.dispose();
    _underlineCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget section(String title, Widget child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppType.label2.m.copyWith(color: context.c.labelNormal)),
            const SizedBox(height: 12),
            child,
            const SizedBox(height: 24),
          ],
        );

    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            section(
              'box',
              TextArea(controller: _box, hintText: '내용을 입력해주세요'),
            ),
            section(
              'box — with counter',
              TextArea(
                controller: _boxCounter,
                hintText: '내용을 입력해주세요',
                maxLength: 200,
              ),
            ),
            section(
              'underline',
              TextArea(
                style: TextAreaStyle.underline,
                controller: _underline,
                hintText: '내용을 입력해주세요',
              ),
            ),
            section(
              'underline — with counter',
              TextArea(
                style: TextAreaStyle.underline,
                controller: _underlineCounter,
                hintText: '내용을 입력해주세요',
                maxLength: 200,
              ),
            ),
            section(
              'box — disabled',
              TextArea(
                controller: TextEditingController(text: '비활성화 상태'),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
