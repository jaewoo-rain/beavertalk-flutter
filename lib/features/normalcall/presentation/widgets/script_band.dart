import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_typography.dart';

/// 대본 읽기 통화의 자막 띠(PM-DEC-893 · 사용자 확정 시안 · Figma `6807:20465`).
///
/// 원래 자막 자리에 화면 전체 폭 띠 하나를 그린다. 바바가 말하면 파랑, 학습자 차례면 빨강이다.
/// 서버(시험 서버 scriptrd)가 클립 재생 시작 시각에 맞춰 보내는 메시지로만 그린다.
/// - `script_beaver` — 바바 줄(뜻 · 한국어 · 로마자)
/// - `script_line` — 학습자 줄. `attempt` 2 면 다시 읽기(바탕 투명도 0.9)
/// - `script_say` — 바바 영어 클립 문장. `sec` 뒤 직전 줄로 돌아간다(`end` 는 그대로 둔다)
///
/// 운영 서버는 이 메시지를 보내지 않으므로 운영 통화에서는 [state] 가 늘 null 이다.
class ScriptBand extends StatelessWidget {
  const ScriptBand({super.key});

  /// 지금 띠. null 이면 대본 읽기 통화가 아니다(종전 자막·힌트를 그린다).
  static final ValueNotifier<ScriptBandState?> state = ValueNotifier(null);

  static ScriptBandState? _line;
  static Timer? _sayTimer;

  /// 새 통화 화면 — 지난 통화의 띠를 지운다.
  static void reset() {
    _sayTimer?.cancel();
    _sayTimer = null;
    _line = null;
    state.value = null;
  }

  /// 통화 컨트롤러가 받은 서버 메시지를 그대로 넘긴다.
  static void apply(Map<String, dynamic> msg) {
    final type = msg['type'];
    String s(String k) => '${msg[k] ?? ''}';
    if (type == 'script_beaver' || type == 'script_line') {
      final beaver = type == 'script_beaver';
      _sayTimer?.cancel();
      _line = ScriptBandState(
        beaver: beaver,
        ko: s('ko'),
        roman: s('roman'),
        gloss: beaver ? s('gloss') : s('en'),
        retry: !beaver && ((msg['attempt'] as num?)?.toInt() ?? 1) >= 2,
      );
      state.value = _line;
    } else if (type == 'script_say') {
      _sayTimer?.cancel();
      state.value = ScriptBandState.say(s('text'));
      final sec = (msg['sec'] as num?)?.toDouble() ?? 0;
      if (msg['kind'] != 'end' && _line != null && sec > 0) {
        _sayTimer = Timer(Duration(milliseconds: (sec * 1000).round()), () {
          if (_line != null) state.value = _line;
        });
      }
    }
    // script_result · script_end 는 소리(클립)가 상태를 보여 준다 — 띠는 위 세 메시지로만 바뀐다.
  }

  /// 한국어를 어절 중간에서 끊지 않게 글자 사이에 WORD JOINER 를 넣는다(요청서 §3 「좋/아해요」 금지).
  static String keepWords(String text) =>
      text.split(' ').map((w) => w.split('').join('⁠')).join(' ');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScriptBandState?>(
      valueListenable: state,
      builder: (context, s, _) {
        if (s == null) return const SizedBox.shrink();
        final c = context.c;
        final base = s.beaver ? c.accentForegroundBlue : c.accentBackgroundRed;
        final white = c.staticWhite;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (s.sayText == null && s.gloss.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(s.gloss,
                    textAlign: TextAlign.center, style: AppType.headline2.b.copyWith(color: base)),
              ),
              const SizedBox(height: 4),
            ],
            Container(
              key: const ValueKey('script-band'),
              width: double.infinity,
              color: base.withValues(alpha: s.retry ? 0.9 : 0.8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: s.sayText != null
                  ? Text(s.sayText!,
                      textAlign: TextAlign.center, style: AppType.headline1.b.copyWith(color: white))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(keepWords(s.ko),
                            textAlign: TextAlign.center, style: AppType.heading2.b.copyWith(color: white)),
                        if (s.roman.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text('/${s.roman}/',
                              textAlign: TextAlign.center, style: AppType.label1.m.copyWith(color: white)),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class ScriptBandState {
  const ScriptBandState({
    required this.beaver,
    required this.ko,
    required this.roman,
    required this.gloss,
    this.retry = false,
  }) : sayText = null;

  /// 바바 영어 클립 문장(01) — 파랑 띠 · 뜻 없음.
  const ScriptBandState.say(String text)
      : beaver = true,
        ko = '',
        roman = '',
        gloss = '',
        retry = false,
        sayText = text;

  final bool beaver;
  final String ko;
  final String roman;
  final String gloss;

  /// 1회 틀린 뒤 같은 줄(04) — 바탕 투명도 0.9.
  final bool retry;
  final String? sayText;
}
