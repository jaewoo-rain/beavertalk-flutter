import 'package:flutter/material.dart';

import '../../../components/icons/app_icons.dart';
import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

// 숙제 상세 카드 썸네일(2026-10-12 확정 · Figma `6692:17033`). 둘 다 **장식**이라 누를
// 수 없고 스크린리더도 건너뛴다. 과제 데이터로 바뀌지 않는 고정 그림이다(인계 명세 §7 —
// 서버 변경 없이 되는 쪽으로 정함 · PM-DEC-535).

/// 회화 카드 썸네일 — 통화 화면 축소 목업(`6692:17054`, 사용자 제작 `6688:51243`).
///
/// 캐릭터 화면 사진 한 장 + 통화 버튼 줄(힌트 · 자막 · 마이크 · 종료). 통화 화면을
/// 그대로 옮긴 그림이라 테마와 무관하게 밝은 판이다 — 색도 시안 값 그대로다.
class CallThumbnail extends StatelessWidget {
  /// 썸네일을 만든다.
  const CallThumbnail({super.key});

  /// 목업 바탕 — 시안 `#F6FCFF`(통화 화면 Light 바탕).
  static const Color _surface = Color(0xFFF6FCFF);

  /// 보조 버튼 바탕 — 시안 `rgba(112,115,125,0.05)`.
  static const Color _buttonFill = Color(0x0D70737D);

  /// 종료 버튼 — 시안 `#E52121`.
  static const Color _endFill = Color(0xFFE52121);

  /// 보조 버튼 글리프 — 시안 `#333333`.
  static const Color _glyph = Color(0xFF333333);

  /// 시안 사진 칸 비율 270.49 × 152.15.
  static const double _photoAspect = 270.492 / 152.154;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.426),
        child: ColoredBox(
          color: _surface,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 시안은 카드 안 폭 295 에 사진 270.49 — 같은 비율로 줄이고 늘린다.
              final scale = constraints.maxWidth / 295;
              final button = 40.394 * scale;
              final icon = 20.197 * scale;
              Widget circle(Color fill, Widget child) => Container(
                width: button,
                height: button,
                decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: child,
              );
              return Column(
                children: [
                  SizedBox(height: 12 * scale),
                  SizedBox(
                    width: 270.492 * scale,
                    child: AspectRatio(
                      aspectRatio: _photoAspect,
                      child: Image.asset(
                        'assets/images/hw_call_thumb.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 23.082 * scale,
                      vertical: 11.54 * scale,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        circle(
                          _buttonFill,
                          AppIcons.lightbulb(size: icon, color: _glyph),
                        ),
                        circle(_buttonFill, AppIcons.cc(size: icon, color: _glyph)),
                        circle(_buttonFill, AppIcons.mic(size: icon, color: _glyph)),
                        circle(
                          _endFill,
                          AppIcons.callEnd(size: icon, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 워크북 카드 썸네일 — 원고지 6칸 × 3줄(`6692:17203`).
///
/// 예문은 「우리 같이 한국어를 공부해요.」 고정이다. 앞 여섯 글자는 쓴 글자(`Label/Strong`),
/// 나머지는 따라 쓰기(`Label/Assistive` Regular). 띄어쓰기는 빈 칸 하나.
class WorkbookThumbnail extends StatelessWidget {
  /// 썸네일을 만든다.
  const WorkbookThumbnail({super.key});

  static const double _cell = 36;

  /// (글자, 쓴 글자인지). 빈 문자열은 띄어쓰기 칸.
  static const List<List<(String, bool)>> _rows = [
    [('우', true), ('리', true), ('', true), ('같', true), ('이', true), ('', true)],
    [('한', true), ('국', true), ('어', false), ('를', false), ('', false), ('', false)],
    [('공', false), ('부', false), ('해', false), ('요', false), ('.', false), ('', false)],
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: c.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: BoxDecoration(
            color: c.backgroundElevatedAlternative,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: c.lineNeutral),
          ),
          alignment: Alignment.center,
          // 좁은 화면에서는 원고지째 줄인다 — 칸을 자르면 원고지로 안 읽힌다.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final row in _rows)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final (ch, written) in row)
                        _Cell(char: ch, written: written),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.char, required this.written});

  final String char;
  final bool written;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SizedBox(
      width: WorkbookThumbnail._cell,
      height: WorkbookThumbnail._cell,
      child: CustomPaint(
        painter: _CellPainter(line: c.lineNormal),
        child: Center(
          child: Text(
            char,
            textScaler: TextScaler.noScaling,
            style: (written ? AppType.title3.m : AppType.title3.r).copyWith(
              color: written ? c.labelStrong : c.labelAssistive,
              height: 1.334,
            ),
          ),
        ),
      ),
    );
  }
}

/// 칸 테두리(실선) + 가운데 세로 보조선(점선) — 둘 다 `Line/Normal` 1.
class _CellPainter extends CustomPainter {
  _CellPainter({required this.line});

  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = line
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & size, p);
    final x = size.width / 2;
    const dash = 2.0;
    for (double y = 0; y < size.height; y += dash * 2) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dash), p);
    }
  }

  @override
  bool shouldRepaint(_CellPainter old) => old.line != line;
}
