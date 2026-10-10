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
      // 높이 하한. 라벨이 두 줄이 될 수 있으므로 고정이면 둘째 줄이 잘린다.
      constraints: const BoxConstraints(minHeight: 20),
      padding: EdgeInsets.only(left: done ? 6 : 8, right: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      // 칩 하나가 한 줄보다 길면 **[Wrap] 이 못 구한다.**
      //
      // 칩들은 `card_homework`·`card_class` 에서 [Wrap] 에 담긴다. Wrap 은 자식
      // **사이에서만** 줄을 바꾼다 — 자식 하나가 한 줄 폭을 넘으면 그 자식이
      // 그대로 넘친다. 라벨은 로케일 차가 큰 자리라(ko 「워크북」 4자 ↔ my
      // 「လေ့ကျင့်ခန်းစာအုပ်」) 실제로 넘쳤다(320dp 실측: 제약 201.1 에 218.1 요구
      // → 17px 초과).
      //
      // Wrap 자식은 유한한 maxWidth 를 받으므로 [Flexible] 이 성립한다
      // (무제약 자리에 놓이는 `HomeworkBadge` 와 다르다 — 그쪽은 폭 상한을
      // 스스로 진다).
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (done) ...[
            AppIcons.check(size: 12, color: fg),
            const SizedBox(width: 2),
          ],
          Flexible(
            child: Text(
              label,
              // 활동 이름은 자르지 않는다. 칩은 높이가 하한이 아니므로
              // `card_homework` 의 Wrap 안에서 두 줄이 되면 칩이 세로로 커진다.
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption2.m.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}
