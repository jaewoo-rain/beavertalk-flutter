import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// 과제 유형 칩 — Figma `숙제/Chip`(`5667:29731`) 실측.
///
/// 높이 20 · 알약 · `Caption 2 Medium`. 끝낸 유형은 초록 면에 체크가 붙는다.
/// 좌우 패딩 8, 체크를 켜면 왼쪽만 6 이다.
///
/// 숙제 카드의 발음·회화·워크북 세 칩이 이것이다. **개수를 늘려 다른 뜻을 담지
/// 마라** — 칩은 과제가 요구하는 활동만 말한다.
class HomeworkChip extends StatelessWidget {
  /// 칩을 만든다.
  const HomeworkChip({super.key, required this.label, this.done = false});

  /// 유형 이름(발음·회화·워크북). 화면이 로케일로 넘긴다.
  final String label;

  /// 끝냈는지. 워크북은 서버에 완료 신호가 없어 항상 false 다.
  final bool done;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final Color bg = done ? c.primaryNormal10 : c.fillNormal;
    final Color fg = done ? c.primaryForeground : c.labelNeutral;

    return Container(
      height: 20,
      padding: EdgeInsets.only(left: done ? 6 : 8, right: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (done) ...[
            AppIcons.check(size: 12, color: fg),
            const SizedBox(width: 2),
          ],
          Text(label, style: AppType.caption2.m.copyWith(color: fg)),
        ],
      ),
    );
  }
}
