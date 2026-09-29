import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// OtpInput — a local one-time-code (OTP) field of [length] digit boxes.
///
/// Extracted from `screen/auth_findpw_code` (`2117:19868`). Renders [length]
/// 68×68 `Background/Normal/Alternative` boxes; typing a digit auto-advances focus to the
/// next box, and deleting steps focus back. Reports the joined value via
/// [onChanged], and fires [onCompleted] once every box is filled.
///
/// Three things the soft keyboard needs (09-29 iPhone build 46 · QA F118 · F119):
/// - typing into a filled box **replaces** its digit — `maxLength: 1` used to
///   reject the new digit, so a corrected box kept the wrong one;
/// - deleting a box's digit moves focus to the previous box, so repeated
///   backspace walks back — iOS sends no key event on an empty box;
/// - a whole code arriving at once (paste · the keyboard's code suggestion)
///   is spread across the boxes instead of being cut to its first digit.
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

  void _set(int i, String digit) => _controllers[i].value = TextEditingValue(
        text: digit,
        selection: TextSelection.collapsed(offset: digit.length),
      );

  void _onChanged(int i, String raw) {
    if (raw.length > 1 && raw.length >= widget.length - i) {
      // A whole code at once — fill from this box onward.
      final digits = raw.substring(raw.length - (widget.length - i));
      for (var k = 0; k < digits.length; k++) {
        _set(i + k, digits[k]);
      }
      _nodes[widget.length - 1].requestFocus();
    } else {
      // A typed digit replaces the box's old one (the new one is last).
      final digit = raw.isEmpty ? '' : raw.characters.last;
      if (digit != raw) _set(i, digit);
      if (digit.isNotEmpty && i < widget.length - 1) {
        _nodes[i + 1].requestFocus();
      } else if (digit.isEmpty && i > 0) {
        // Deleted this box's digit — step back so the next backspace deletes
        // the previous one.
        _nodes[i - 1].requestFocus();
      }
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
            color: focused ? context.c.primaryNormal10 : context.c.backgroundNormalAlternative,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: focused
                  ? context.c.primaryNormal
                  : (filled ? context.c.lineNeutral : context.c.backgroundNormalAlternative),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            keyboardType: TextInputType.number,
            // The first box offers the keyboard's one-time-code suggestion.
            autofillHints: i == 0 ? const [AutofillHints.oneTimeCode] : null,
            textAlign: TextAlign.center,
            cursorColor: context.c.primaryNormal,
            style: AppType.title3.sb,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              _onChanged(i, v);
              setState(() {});
            },
            onTap: () => setState(() {}),
            decoration: const InputDecoration(
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
