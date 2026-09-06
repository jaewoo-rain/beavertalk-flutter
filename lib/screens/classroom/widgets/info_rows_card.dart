import 'package:flutter/widgets.dart';

import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

/// 라벨 · 값 한 줄.
@immutable
class InfoRow {
  /// 행을 만든다.
  const InfoRow(this.label, this.value);

  /// 왼쪽 라벨.
  final String label;

  /// 오른쪽 값.
  final String value;
}

/// 읽기 전용 라벨·값 카드 — Figma `Card/ClassPreview`·`Card/JoinSummary`.
///
/// 공용 [CardLine](`molecules/card_line.dart`) 을 쓰지 않는다. 그쪽 `defaultRow`
/// 는 꼬리에 셰브런이 붙어 **눌리는 줄로 읽힌다** — 여기 네 줄은 안내일 뿐 아무
/// 데도 가지 않는다.
///
/// [title] 을 주면 위에 이름 줄과 구분선이 붙는다(A2 의 반 이름).
class InfoRowsCard extends StatelessWidget {
  /// 카드를 만든다.
  const InfoRowsCard({super.key, required this.rows, this.title});

  /// 표시할 줄들.
  final List<InfoRow> rows;

  /// 머리 줄. 반 이름은 **선생님이 쓴 원문 그대로** 넣는다(번역 금지).
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
              child: Text(
                title!,
                style: AppType.body1.b.copyWith(color: c.labelStrong),
              ),
            ),
            Container(height: 1, color: c.lineAlternative),
          ],
          for (final row in rows)
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  Text(
                    row.label,
                    style: AppType.label1.r.copyWith(color: c.labelNormal),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Text(
                      row.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: AppType.label1.m.copyWith(color: c.labelStrong),
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
