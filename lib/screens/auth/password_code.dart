import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// Password-recovery step 2 — enter the 4-digit verification code.
///
/// Figma `screen/auth_findpw_code` (`2117:19861`). A [GnbType.main] header
/// ("코드입력"), a guidance line, a local 4-box OTP field ([_OtpInput]) with
/// auto-advance, a mock countdown / resend row, and a primary "입력 완료" button
/// that advances to [Routes.passwordComplete].
///
/// Mock only: any 4 digits are accepted; the countdown is cosmetic.
class PasswordCodeScreen extends StatefulWidget {
  /// Creates the password-code screen.
  const PasswordCodeScreen({super.key});

  @override
  State<PasswordCodeScreen> createState() => _PasswordCodeScreenState();
}

class _PasswordCodeScreenState extends State<PasswordCodeScreen> {
  /// Total seconds in the (mock) entry window — Figma copy says "2분".
  static const int _windowSeconds = 120;

  String _code = '';
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restartCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartCountdown() {
    _timer?.cancel();
    _remaining = _windowSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
        return;
      }
      setState(() => _remaining--);
    });
  }

  /// `m:ss` formatting of the remaining seconds.
  String get _clock {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  bool get _complete => _code.length == 4;

  void _submit() {
    if (!_complete) return;
    Navigator.of(context).pushNamed(Routes.passwordComplete);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: '코드입력',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '복구 코드가 귀하에게 전송되었습니다.\n'
                    '전달 받은 코드를 2분 안에 입력 하셔야 합니다.',
                    style: AppType.label1.r
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  _OtpInput(
                    onChanged: (v) => setState(() => _code = v),
                    onCompleted: (_) => _submit(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Text(
                        '코드를 못 받으셨나요?',
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _restartCountdown,
                        child: Text(
                          '코드 재전송',
                          style: AppType.label1.sb
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _clock,
                        style: AppType.label1.r
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      text: '입력 완료',
                      disabled: !_complete,
                      onPressed: _submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A local 4-box one-time-code (OTP) field.
///
/// Renders four 68×68 surface2 boxes (Figma `2117:19868`). Typing a digit
/// auto-advances focus to the next box; backspace on an empty box steps back.
/// Reports the joined value via [onChanged], and [onCompleted] once all four
/// digits are present. Not tied to any backend — purely local state.
class _OtpInput extends StatefulWidget {
  const _OtpInput({this.onChanged, this.onCompleted});

  /// The number of code boxes / digits.
  static const int length = 4;

  /// Called with the joined code on every edit.
  final ValueChanged<String>? onChanged;

  /// Called with the joined code once all boxes are filled.
  final ValueChanged<String>? onCompleted;

  @override
  State<_OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<_OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(_OtpInput.length, (_) => TextEditingController());
    _nodes = List.generate(_OtpInput.length, (_) => FocusNode());
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
    if (digit.isNotEmpty && i < _OtpInput.length - 1) {
      _nodes[i + 1].requestFocus();
    }
    final value = _value;
    widget.onChanged?.call(value);
    if (value.length == _OtpInput.length) {
      widget.onCompleted?.call(value);
    }
  }

  /// Backspace on an empty box hops focus to the previous box.
  KeyEventResult _onKey(int i, FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[i].text.isEmpty &&
        i > 0) {
      _nodes[i - 1].requestFocus();
      _controllers[i - 1].clear();
      widget.onChanged?.call(_value);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < _OtpInput.length; i++) _box(i),
      ],
    );
  }

  Widget _box(int i) {
    final focused = _nodes[i].hasFocus;
    final filled = _controllers[i].text.isNotEmpty;
    return SizedBox(
      width: 68,
      height: 68,
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
