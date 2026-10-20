import 'package:flutter/material.dart';

import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_typography.dart';

/// 대본 읽기 시제품(PM-DEC-877 · 시험 서버 scriptrd)의 대본 카드.
///
/// 서버가 보내는 `script_line` · `script_result` · `script_end` 로만 그린다. 운영 서버는 이 메시지를
/// 보내지 않으므로 운영 통화에서는 카드가 뜨지 않는다(빈 상자). 대조·판정·클립 선택은 서버 몫이다.
class ScriptCard extends StatefulWidget {
  const ScriptCard({super.key});

  /// 지금 카드 상태. null 이면 그리지 않는다.
  static final ValueNotifier<ScriptCardState?> state = ValueNotifier(null);

  /// 통화 컨트롤러가 받은 서버 메시지를 그대로 넘긴다.
  static void apply(Map<String, dynamic> msg) {
    final type = msg['type'];
    final cur = state.value;
    if (type == 'script_line') {
      state.value = ScriptCardState(
        n: (msg['n'] as num?)?.toInt() ?? 0,
        total: (msg['total'] as num?)?.toInt() ?? 0,
        ko: '${msg['ko'] ?? ''}',
        roman: '${msg['roman'] ?? ''}',
        en: '${msg['en'] ?? ''}',
        attempt: (msg['attempt'] as num?)?.toInt() ?? 1,
      );
    } else if (type == 'script_result' && cur != null) {
      state.value = cur.copyWith(result: '${msg['result'] ?? ''}');
    } else if (type == 'script_end') {
      state.value = (cur ?? const ScriptCardState(n: 0, total: 0, ko: '', roman: '', en: '', attempt: 1))
          .copyWith(ended: true);
    }
  }

  @override
  State<ScriptCard> createState() => _ScriptCardState();
}

class ScriptCardState {
  const ScriptCardState({
    required this.n,
    required this.total,
    required this.ko,
    required this.roman,
    required this.en,
    required this.attempt,
    this.result,
    this.ended = false,
  });

  final int n;
  final int total;
  final String ko;
  final String roman;
  final String en;
  final int attempt;

  /// 마지막 대조 결과(pass·close·fail·skip). 새 줄이 오면 비운다.
  final String? result;
  final bool ended;

  ScriptCardState copyWith({String? result, bool? ended}) => ScriptCardState(
        n: n,
        total: total,
        ko: ko,
        roman: roman,
        en: en,
        attempt: attempt,
        result: result ?? this.result,
        ended: ended ?? this.ended,
      );
}

class _ScriptCardState extends State<ScriptCard> {
  @override
  void initState() {
    super.initState();
    ScriptCard.state.value = null; // 새 통화 화면 — 지난 통화 카드를 지운다
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScriptCardState?>(
      valueListenable: ScriptCard.state,
      builder: (context, s, _) {
        if (s == null) return const SizedBox.shrink();
        final c = context.c;
        final retry = s.result == 'fail';
        final skip = s.result == 'skip';
        final ok = s.result == 'pass' || s.result == 'close';
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            decoration: BoxDecoration(
              color: c.backgroundNormalNormal.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: retry ? Colors.redAccent : (skip ? Colors.amber : (ok ? c.primaryNormal : c.labelAssistive)),
                width: retry || skip || ok ? 2 : 1,
              ),
            ),
            child: s.ended
                ? Text('대본 끝', textAlign: TextAlign.center, style: AppType.body1.sb.copyWith(color: c.labelStrong))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text('${s.n}/${s.total}', style: AppType.label1.sb.copyWith(color: c.labelNormal)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: s.total > 0 ? (s.n - 1) / s.total : 0,
                                minHeight: 6,
                                color: c.primaryNormal,
                                backgroundColor: c.labelAssistive.withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                          if (ok) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check_circle, size: 18, color: c.primaryNormal),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(s.ko, style: AppType.title3.sb.copyWith(color: skip ? Colors.amber.shade800 : c.labelStrong)),
                      if (s.roman.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(s.roman, style: AppType.label1.r.copyWith(color: c.labelNeutral)),
                      ],
                      if (s.en.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(s.en, style: AppType.label1.r.copyWith(color: c.labelAlternative)),
                      ],
                      if (retry || s.attempt >= 2) ...[
                        const SizedBox(height: 8),
                        Text('다시 읽어 보세요', style: AppType.label1.sb.copyWith(color: Colors.redAccent)),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
