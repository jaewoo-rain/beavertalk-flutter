import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// OtpInput — a local one-time-code (OTP) field of [length] digit boxes.
///
/// Extracted from `screen/auth_findpw_code` (`2117:19868`). Renders [length]
/// 68×68 [AppColors.surface2] boxes; typing a digit auto-advances focus to the
/// next box, and backspace on an empty box steps focus back. Reports the joined
/// value via [onChanged], and fires [onCompleted] once every box is filled.
///
/// Purely local state — not tied to any backend.
class OtpInput extends StatefulWidget {
  /// Creates an OTP input.
  const OtpInput({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
  });

  /// The number of code boxes / digits.
  final int length;

  /// Called with the joined code on every edit.
  final ValueChanged<String>? onChanged;

  /// Called with the joined code once all boxes are filled.
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _onChanged(int i, String raw) {
    // Keep only the last typed digit per box.
    final digit = raw.isEmpty ? '' : raw.characters.last;
    if (digit != raw) {
      _controllers[i].value = TextEditingValue(
        text: digit,
        selection: TextSelection.collapsed(offset: digit.length),
      );
    }
    if (digit.isNotEmpty && i < widget.length - 1) {
      _nodes[i + 1].requestFocus();
    }
    final value = _value;
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
  }

  /// Backspace on an empty box hops focus to the previous box.
  KeyEventResult _onKey(int i, FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[i].text.isEmpty &&
        i > 0) {
      // setState so the previous box's filled/focused styling (read in build)
      // updates immediately instead of desyncing until the next rebuild.
      setState(() {
        _nodes[i - 1].requestFocus();
        _controllers[i - 1].clear();
      });
      widget.onChanged?.call(_value);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // Equal-width boxes that flex to fit any width (6-digit codes would
    // overflow a fixed 68px box on narrow screens), capped at 68px tall.
    return Row(
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _box(i)),
        ],
      ],
    );
  }

  Widget _box(int i) {
    final focused = _nodes[i].hasFocus;
    final filled = _controllers[i].text.isNotEmpty;
    return AspectRatio(
      aspectRatio: 1,
      child: Focus(
        onKeyEvent: (node, event) => _onKey(i, node, event),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: focused ? AppColors.primary10 : AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: focused
                  ? AppColors.primary
                  : (filled ? AppColors.border : AppColors.surface2),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            cursorColor: AppColors.primary,
            style: AppType.title3.sb,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              _onChanged(i, v);
              setState(() {});
            },
            onTap: () => setState(() {}),
            decoration: const InputDecoration(
              counterText: '',
              isCollapsed: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

/// Gallery demo for [OtpInput].
class OtpInputDemo extends StatelessWidget {
  const OtpInputDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: OtpInput(length: 6),
    );
  }
}
