import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_typography.dart';

/// 참여 코드 6칸 입력 — Figma `CodeInput`(`screen/hw_join_code`) 실측.
///
/// 칸 49×**56**·간격 8. 정사각이 아니므로 [OtpInput](`molecules/otp_input.dart`)
/// 을 쓰지 못한다. 그쪽은 숫자 전용이기도 하다 — 참여 코드는 **영문자를 포함**한다.
///
/// 칸마다 [TextField] 를 두지 않고 **투명한 필드 하나**를 위에 덮는다. 붙여넣기와
/// 딥링크 자동 입력이 한 번에 들어오기 때문이다 — 칸을 쪼개면 6자가 첫 칸에만
/// 들어간다.
///
/// 입력은 대문자로 정규화한다. 서버가 `join_code.upper()` 로 비교하므로 화면에
/// 보이는 것과 보내는 것을 같게 맞춘다(안내문 「대소문자를 구분하지 않아요」).
class ClassCodeInput extends StatefulWidget {
  /// 입력칸을 만든다.
  const ClassCodeInput({
    super.key,
    required this.onChanged,
    this.length = 6,
    this.initialValue = '',
    this.enabled = true,
  });

  /// 값이 바뀔 때마다 부른다. 항상 대문자다.
  final ValueChanged<String> onChanged;

  /// 칸 수. 서버 계약이 6자리 고정이다.
  final int length;

  /// 딥링크로 미리 채워진 코드.
  final String initialValue;

  /// 조회 중에는 꺼서 중복 입력을 막는다.
  final bool enabled;

  @override
  State<ClassCodeInput> createState() => _ClassCodeInputState();
}

class _ClassCodeInputState extends State<ClassCodeInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String value = _controller.text;

    return GestureDetector(
      onTap: widget.enabled ? () => _focus.requestFocus() : null,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                for (var i = 0; i < widget.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _Cell(
                      char: i < value.length ? value[i] : '',
                      focused:
                          _focus.hasFocus &&
                          (i == value.length ||
                              (i == widget.length - 1 &&
                                  value.length == widget.length)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 실제 입력을 받는 필드. 보이지 않게 겹쳐 두고 칸은 위에서 그린다.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                enabled: widget.enabled,
                autofocus: true,
                maxLength: widget.length,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.visiblePassword,
                // 참여 코드는 RTL 로케일에서도 왼쪽부터 읽는다(`10 §5`).
                textDirection: TextDirection.ltr,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                  _UpperCaseFormatter(),
                ],
                onChanged: (v) {
                  setState(() {});
                  widget.onChanged(v);
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 칸 하나. 채워진 칸은 테두리가 서고, 커서가 있는 칸은 민트로 강조한다.
class _Cell extends StatelessWidget {
  const _Cell({required this.char, required this.focused});

  final String char;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final bool filled = char.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: focused ? c.primaryNormal10 : c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: focused
              ? c.primaryNormal
              : (filled ? c.lineNeutral : c.backgroundNormalAlternative),
          width: 1,
        ),
      ),
      child: Text(
        char,
        textDirection: TextDirection.ltr,
        style: AppType.title3.sb.copyWith(color: c.labelStrong),
      ),
    );
  }
}

/// 입력을 즉시 대문자로 바꾼다.
class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
