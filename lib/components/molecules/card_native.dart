import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/icon_toggle.dart';
import '../icons/app_icons.dart';

/// CardNative — 배운 표현의 **현지인 표현 짝** 카드. Figma `Card-Native`
/// (Mobile `6177:28979` · Tablet `6238:49288`, `screen/analysis` `6177:28225`).
///
/// ```
/// ┌ Elevated/Alternative · 테두리 1px Primary/Normal-10 · 모서리 12 · 패딩 16/20 ┐
/// │ [native 16] 현지인                  ← Caption 1 Bold 12 · Primary/Normal    │
/// │ 뱃가죽이 등에 붙을 것 같아요           ← Label 1 Bold 14 · Label/Strong        │
/// │ So hungry my stomach touches my back  ← Caption 1 Regular 12 · Label/Normal │
/// │ [🔊][🔖]                  [연습하기]  ← 기본 카드(CardBookmark)와 같은 줄     │
/// └───────────────────────────────────────────────────────────────────────┘
/// ```
///
/// [gloss] 는 서버 `nuance`(학습자 모국어 뉘앙스 설명)다 — Figma 에 따로 뉘앙스 줄이 없고
/// 이 뜻 줄이 정본 자리다. 길면 줄 수 제한 없이 감싼다. 비어 있으면 줄째 뺀다.
///
/// 높이 136(버튼 있음): 패딩 32 + 라벨 16 + 4 + 표현 20 + 4 + 뜻 16 + 8 + 버튼 줄 36.
class CardNative extends StatelessWidget {
  /// Creates a native-expression pair card.
  const CardNative({
    super.key,
    required this.label,
    required this.expression,
    this.gloss,
    required this.bookmarked,
    this.onBookmarkTap,
    this.onSpeakerTap,
    this.actionText,
    this.onAction,
  });

  /// 라벨 문구(「현지인」).
  final String label;

  /// 현지인 표현(한국어).
  final String expression;

  /// 뜻·뉘앙스 줄. null·빈 문자열이면 그리지 않는다.
  final String? gloss;

  /// 북마크 여부.
  final bool bookmarked;

  /// 북마크 토글.
  final VoidCallback? onBookmarkTap;

  /// 스피커.
  final VoidCallback? onSpeakerTap;

  /// 오른쪽 버튼 문구(「연습하기」). null 이면 버튼 없음.
  final String? actionText;

  /// 오른쪽 버튼.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final g = gloss;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        border: Border.all(color: c.primaryNormal10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Figma 라벨 줄은 HUG(왼쪽 정렬) — Row+Flexible 은 행 끝에 빈 폭을 남긴다(R11).
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AppIcons.duoNative(
                    bubble: c.primaryNormal24,
                    pin: c.primaryNormal,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(text: label),
              ],
            ),
            style: AppType.caption1.b.copyWith(color: c.primaryNormal),
          ),
          const SizedBox(height: 4),
          Text(expression, style: AppType.label1.b.copyWith(color: c.labelStrong)),
          if (g != null && g.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(g, style: AppType.caption1.r.copyWith(color: c.labelNormal)),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: onSpeakerTap,
                behavior: HitTestBehavior.opaque,
                child: AppIcons.volume(size: 24, color: c.labelStrong),
              ),
              const SizedBox(width: 8),
              IconToggle(
                value: bookmarked,
                onIcon: AppIcons.bookmarkFill,
                offIcon: AppIcons.bookmarkLine,
                onColor: c.primaryNormal,
                offColor: c.labelStrong,
                onTap: onBookmarkTap,
              ),
              if (actionText != null) ...[
                const SizedBox(width: 8),
                // 짝 카드는 연결선(12+10)만큼 기본 카드보다 좁다 — `Spacer` 뒤의 버튼은 폭을
                // 못 받아 긴 언어(fi·fr·my·uz @320)에서 넘쳤다. 남은 폭을 주면 Button 이 스스로
                // 두 줄로 바꾼다. 버튼은 오른쪽 끝(Figma 양 끝 정렬).
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Button(
                      type: BtnType.secondaryElevated,
                      size: BtnSize.s36,
                      text: actionText!,
                      onPressed: onAction,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 기본 카드 아래 현지인 짝 줄 — Figma `Native Row`(`6177:28977`): HORIZONTAL gap 10 ·
/// [Connector 12×36] + [CardNative FILL]. 연결선은 위쪽 기본 카드에서 내려오는 「└」
/// (아래·왼쪽 2px `Primary/Normal-24` · 왼쪽 아래 모서리 8).
class NativePairRow extends StatelessWidget {
  /// Creates the connector + card row.
  const NativePairRow({super.key, required this.card});

  /// 짝 카드([CardNative]).
  final Widget card;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPaint(
          size: const Size(12, 36),
          painter: _ConnectorPainter(context.c.primaryNormal24),
        ),
        const SizedBox(width: 10),
        Expanded(child: card),
      ],
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  _ConnectorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 2.0;
    const radius = 8.0;
    // 선의 중심이 테두리 안쪽 1px 에 오도록 반 두께만큼 들인다(Figma 안쪽 선).
    const h = stroke / 2;
    final path = Path()
      ..moveTo(h, 0)
      ..lineTo(h, size.height - radius)
      ..arcToPoint(
        Offset(radius, size.height - h),
        radius: const Radius.circular(radius - h),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - h);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) => old.color != color;
}
