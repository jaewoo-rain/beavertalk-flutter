import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// The validation state of a [FieldValidation], driving the box border colour
/// and the helper-text colour.
///
/// Each value maps 1:1 to a Figma status token:
/// * [error] → `Semantics/Status/Negative` (#FF7070).
/// * [success] → `Semantics/Status/Positive` (#1ED45A).
/// * [warning] → `Semantics/Status/Warning` (#FFA938).
enum FieldValidationState {
  /// Negative / error state — red border + red helper text.
  error,

  /// Positive / success state — green border + green helper text.
  success,

  /// Warning state — amber border + amber helper text.
  warning;

  /// The status token for this state, in the current mode.
  ///
  /// Resolved from a [BuildContext] rather than held as an enum field: an enum
  /// value is `const`, so it could only ever carry one mode's colour — which is
  /// exactly how this used to hardcode the Dark palette.
  Color color(BuildContext context) => switch (this) {
        FieldValidationState.error => context.c.statusNegative,
        FieldValidationState.success => context.c.statusPositive,
        FieldValidationState.warning => context.c.statusCautionary,
      };
}

/// A field wrapper that surrounds an arbitrary input ([child]) with a status
/// box and renders one or more helper messages beneath it.
///
/// Measured 1:1 from Figma `FieldValidation` set `175:11301`:
/// * Outer layout — vertical column, 8px gap between box and helper block.
/// * Box — fill `surface2` (#252932), `radius md` (16px), 1px border in the
///   [state] status colour, padding 16px vertical / 20px horizontal.
/// * Helper block — vertical column, 4px gap between messages.
/// * Helper text — `MO/Label 2/Regular` (Label 2) in the [state] status colour.
///
/// Provide the actual input via [child] (e.g. an `InputField`, `Dropdown`, or
/// any widget). Supply helper copy through [helperText] for a single line, or
/// [messages] for several lines; if both are given, [helperText] is prepended.
/// When neither is provided the helper block is omitted entirely.
class FieldValidation extends StatelessWidget {
  /// Creates a status-wrapped field with optional helper text.
  const FieldValidation({
    super.key,
    required this.state,
    required this.child,
    this.helperText,
    this.messages,
  });

  /// The validation state controlling the border and helper-text colour.
  final FieldValidationState state;

  /// The field placed inside the status box (e.g. an input row).
  final Widget child;

  /// A single helper message shown beneath the box.
  ///
  /// When [messages] is also supplied this line is shown first.
  final String? helperText;

  /// Multiple helper messages, each rendered on its own line (4px apart).
  final List<String>? messages;

  List<String> get _lines => <String>[
        ?helperText,
        ...?messages,
      ];

  @override
  Widget build(BuildContext context) {
    final List<String> lines = _lines;
    final TextStyle helperStyle =
        AppType.label2.r.copyWith(color: state.color(context));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Status box — surface2 fill, 1px status border, radius md.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: context.c.backgroundNormalAlternative,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: state.color(context), width: 1),
          ),
          child: child,
        ),
        if (lines.isNotEmpty) ...[
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < lines.length; i++) ...[
                if (i > 0) const SizedBox(height: 4),
                Text(lines[i], style: helperStyle),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// A neutral sample field used by [FieldValidationDemo] to fill the status box.
class _SampleField extends StatelessWidget {
  const _SampleField();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcons.lock(size: 24, color: context.c.labelNormal),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '비밀번호를 입력해주세요',
            style: AppType.label1.r.copyWith(color: context.c.labelNormal),
          ),
        ),
        const SizedBox(width: 6),
        AppIcons.eye(
          size: 20,
          color: context.c.labelDisabled,
        ),
      ],
    );
  }
}

/// Gallery demo exposing every [FieldValidation] state.
class FieldValidationDemo extends StatelessWidget {
  /// Creates the field-validation gallery demo.
  const FieldValidationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 335,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              FieldValidation(
                state: FieldValidationState.error,
                messages: [
                  '로그인 정보가 일치하지 않습니다. 다시 입력해 주세요.',
                  '비밀번호가 짧습니다.',
                ],
                child: _SampleField(),
              ),
              SizedBox(height: 24),
              FieldValidation(
                state: FieldValidationState.success,
                helperText: '아주 좋은 비밀번호 입니다.',
                child: _SampleField(),
              ),
              SizedBox(height: 24),
              FieldValidation(
                state: FieldValidationState.warning,
                helperText: '보통 수준으로 일반적입니다.',
                child: _SampleField(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
