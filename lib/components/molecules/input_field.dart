import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Available render sizes for [InputField] (the nominal control height in px).
///
/// Measured 1:1 from Figma `InputField` set `175:8234`. Each size pins the
/// vertical/horizontal content padding, the optional left-icon box, and the
/// placeholder/value typography so the rendered height matches the design.
enum InputFieldSize {
  /// 56px tall. Padding 16×20, 20px icon, Body 1 (16px) text.
  size56(height: 56, padV: 16, padH: 20, iconSize: 20, gap: 6, isBody1: true),

  /// 52px tall. Padding 16×20, 20px icon, Label 1 (14px) text.
  size52(height: 52, padV: 16, padH: 20, iconSize: 20, gap: 6, isBody1: false),

  /// 48px tall. Padding 14×20, 20px icon, Label 1 (14px) text.
  size48(height: 48, padV: 14, padH: 20, iconSize: 20, gap: 6, isBody1: false),

  /// 38px tall. Padding 9×16, 16px icon, Label 1 (14px) text.
  size38(height: 38, padV: 9, padH: 16, iconSize: 16, gap: 4, isBody1: false);

  const InputFieldSize({
    required this.height,
    required this.padV,
    required this.padH,
    required this.iconSize,
    required this.gap,
    required this.isBody1,
  });

  /// Nominal control height in logical pixels.
  final double height;

  /// Vertical content padding (top == bottom).
  final double padV;

  /// Horizontal content padding (left == right).
  final double padH;

  /// Left-icon box edge length in logical pixels.
  final double iconSize;

  /// Gap between the left icon and the text in logical pixels.
  final double gap;

  /// Whether the value/placeholder uses Body 1 (16px) vs Label 1 (14px).
  final bool isBody1;
}

/// A controlled single-line text field measured 1:1 from Figma
/// (`InputField` set `175:8234`).
///
/// Wrap a Material [TextField] with the BeaverTalk design tokens. The widget is
/// **controlled** in either of two equivalent ways:
///
/// * pass a [controller] you own, **or**
/// * pass [value] together with [onChanged] (an internal controller is kept in
///   sync with [value]).
///
/// Provide at most one of [controller] / [value]; passing both throws.
///
/// Visual spec (measured), all states share `radius md` (16px) and a 1px stroke:
/// * default — fill `surface2`, border `surface2` (i.e. borderless look).
/// * focus — fill `surface2`, border `primary`.
/// * typing — fill `primary10`, border `primary` (focus + non-empty text).
/// * filled — fill `surface2`, border `surface2` (blurred with a value).
/// * disabled — fill `surface2`, border `borderSubtle`, text `textTertiary`.
///
/// The placeholder ([hintText]) renders in `textSecondary`; entered text and the
/// caret render in white (`primary` caret). Flutter has no hover state, so the
/// Figma `hover` variant is intentionally omitted.
class InputField extends StatefulWidget {
  /// Creates a controlled input field.
  ///
  /// Supply either [controller] or ([value] + [onChanged]) — not both.
  const InputField({
    super.key,
    this.controller,
    this.value,
    this.onChanged,
    this.hintText,
    this.leftIcon,
    this.enabled = true,
    this.size = InputFieldSize.size56,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
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

  /// Optional leading icon, sized to the variant's icon box.
  final Widget? leftIcon;

  /// Whether the field accepts input. When false it renders the disabled style.
  final bool enabled;

  /// The render size (height / padding / typography). Defaults to 56px.
  final InputFieldSize size;

  /// Keyboard type forwarded to the inner [TextField].
  final TextInputType? keyboardType;

  /// Whether to obscure the text (e.g. passwords).
  final bool obscureText;

  /// Called when the user submits via the keyboard action.
  final ValueChanged<String>? onSubmitted;

  /// Optional external focus node. One is created internally when omitted.
  final FocusNode? focusNode;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;
  bool _ownsController = false;
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.value ?? '');
    _ownsController = widget.controller == null;

    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant InputField old) {
    super.didUpdateWidget(old);

    if (widget.controller != old.controller) {
      if (_ownsController) _controller.dispose();
      _controller = widget.controller ??
          TextEditingController(text: widget.value ?? '');
      _ownsController = widget.controller == null;
    } else if (_ownsController &&
        widget.value != null &&
        widget.value != _controller.text) {
      // Keep the internal controller in sync with the controlled `value`.
      _controller.value = _controller.value.copyWith(
        text: widget.value!,
        selection: TextSelection.collapsed(offset: widget.value!.length),
        composing: TextRange.empty,
      );
    }

    if (widget.focusNode != old.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (_ownsFocusNode) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _ownsFocusNode = widget.focusNode == null;
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (_focused != _focusNode.hasFocus) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InputFieldSize spec = widget.size;
    final bool hasText = _controller.text.isNotEmpty;

    // Resolve fill + border per the measured state matrix.
    final Color fill;
    final Color border;
    if (!widget.enabled) {
      fill = AppColors.surface2;
      border = AppColors.borderSubtle;
    } else if (_focused && hasText) {
      // typing
      fill = AppColors.primary10;
      border = AppColors.primary;
    } else if (_focused) {
      // focus
      fill = AppColors.surface2;
      border = AppColors.primary;
    } else {
      // default / filled — both share surface2 fill + surface2 (borderless) edge
      fill = AppColors.surface2;
      border = AppColors.surface2;
    }

    final TextStyle baseStyle = (spec.isBody1 ? AppType.body1 : AppType.label1).r;
    final TextStyle textStyle = baseStyle.copyWith(
      color: widget.enabled ? AppColors.text : AppColors.textTertiary,
    );
    final TextStyle hintStyle = baseStyle.copyWith(
      color: widget.enabled ? AppColors.textSecondary : AppColors.textTertiary,
    );

    Widget? icon;
    if (widget.leftIcon != null) {
      icon = Padding(
        padding: EdgeInsets.only(right: spec.gap),
        child: IconTheme.merge(
          data: IconThemeData(
            size: spec.iconSize,
            color: widget.enabled ? AppColors.textSecondary : AppColors.textTertiary,
          ),
          child: SizedBox(
            width: spec.iconSize,
            height: spec.iconSize,
            child: Center(child: widget.leftIcon),
          ),
        ),
      );
    }

    final TextField field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      style: textStyle,
      cursorColor: AppColors.primary,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged == null
          ? (_) => setState(() {})
          : (v) {
              widget.onChanged!(v);
              setState(() {});
            },
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        isCollapsed: true,
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: hintStyle,
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: spec.height,
      padding: EdgeInsets.symmetric(
        horizontal: spec.padH,
        vertical: spec.padV,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ?icon,
          Expanded(child: field),
        ],
      ),
    );
  }
}

/// Gallery demo exposing every [InputField] size and state.
class InputFieldDemo extends StatefulWidget {
  /// Creates the input-field gallery demo.
  const InputFieldDemo({super.key});

  @override
  State<InputFieldDemo> createState() => _InputFieldDemoState();
}

class _InputFieldDemoState extends State<InputFieldDemo> {
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController _ctrl(String key, [String initial = '']) =>
      _controllers.putIfAbsent(key, () => TextEditingController(text: initial));

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget section(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppType.label2.m.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            ...children.expand((w) => [w, const SizedBox(height: 12)]),
            const SizedBox(height: 12),
          ],
        );

    Widget sizeBlock(String label, InputFieldSize size) => section(label, [
          InputField(
            size: size,
            controller: _ctrl('$label-default'),
            hintText: '디폴트',
            leftIcon: const Icon(Icons.search),
          ),
          InputField(
            size: size,
            controller: _ctrl('$label-filled', '입력 완료 했을 경우'),
            leftIcon: const Icon(Icons.search),
          ),
          InputField(
            size: size,
            controller: _ctrl('$label-noicon'),
            hintText: '아이콘 없음',
          ),
          InputField(
            size: size,
            enabled: false,
            controller: _ctrl('$label-disabled', '비활성화 처리 상태'),
            leftIcon: const Icon(Icons.search),
          ),
        ]);

    return ColoredBox(
      color: AppColors.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeBlock('size 56', InputFieldSize.size56),
            sizeBlock('size 52', InputFieldSize.size52),
            sizeBlock('size 48', InputFieldSize.size48),
            sizeBlock('size 38', InputFieldSize.size38),
          ],
        ),
      ),
    );
  }
}
