import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// OtpInput — a local one-time-code (OTP) field of [length] digit boxes.
///
/// Extracted from `screen/auth_findpw_code` (`2117:19868`). Renders [length]
/// 68×68 `Background/Normal/Alternative` boxes. Reports the code via
/// [onChanged], and fires [onCompleted] once every box is filled.
///
/// **One hidden text field, [length] drawn boxes** (09-30 · QA F118 · F119 ·
/// F121 · F122 · PM). The boxes only draw the field's digits; the keyboard
/// talks to a single field, so the soft keyboard behaves like any text field:
/// - backspace deletes the last digit, on every platform — iOS sends no key
///   event on an empty per-box field, which is why box-by-box fields could
///   not step back (F118);
/// - the next digit goes to the first empty box, so a deleted digit is
///   retyped where it was (F122), and one typed digit never spills into a
///   later box (F121);
/// - a pasted or suggested code (`oneTimeCode` autofill) fills the boxes in
///   order and is cut at [length] (F119).
///
/// Tapping any box focuses the field with the caret at the end.
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
  final _controller = TextEditingController();
  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_keepCaretAtEnd);
    _node.addListener(_repaint);
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  void _repaint() => setState(() {});

  /// The boxes have no caret of their own — a caret moved into the middle
  /// would make the next digit land in an earlier box than the one shown.
  void _keepCaretAtEnd() {
    final v = _controller.value;
    if (v.selection.isCollapsed && v.selection.baseOffset != v.text.length) {
      _controller.selection = TextSelection.collapsed(offset: v.text.length);
    }
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    // Equal-width boxes that flex to fit any width (6-digit codes would
    // overflow a fixed 68px box on narrow screens), capped at 68px tall.
    final code = _controller.text;
    return Stack(
      children: [
        Row(
          children: [
            for (var i = 0; i < widget.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _box(i, code)),
            ],
          ],
        ),
        // The field that actually takes input — laid over the boxes so a tap
        // anywhere on them opens the keyboard, but never painted.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _node,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              showCursor: false,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              onChanged: _onChanged,
              onTap: _keepCaretAtEnd,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _box(int i, String code) {
    final digit = i < code.length ? code[i] : '';
    // The box the next digit goes to (the last one once the code is full).
    final active =
        i == (code.length < widget.length ? code.length : widget.length - 1);
    final focused = _node.hasFocus && active;
    final filled = digit.isNotEmpty;
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: focused
              ? context.c.primaryNormal10
              : context.c.backgroundNormalAlternative,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: focused
                ? context.c.primaryNormal
                : (filled
                    ? context.c.lineNeutral
                    : context.c.backgroundNormalAlternative),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(digit, style: AppType.title3.sb),
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
