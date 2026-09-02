import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/homework_chip.dart';
import '../atoms/pressable.dart';
import '../icons/app_icons.dart';

/// 숙제 리스트 카드가 그리는 칩 1개.
@immutable
class HomeworkCardChip {
  /// 칩을 만든다.
  const HomeworkCardChip(this.label, {this.done = false});

  /// 유형 이름.
  final String label;

  /// 끝냈는지.
  final bool done;
}

/// 숙제 리스트 카드 — Figma `숙제/HomeworkCard`(`5671:5291`) 실측.
///
/// 335×**116 고정**·r12·`Background/Elevated/Alternative`·패딩 16/20·간격 10.
/// 높이를 Hug 로 두면 상태별로 어긋나 리스트 스크롤이 튄다(스펙 §8).
///
/// **카드 전체가 탭 영역이다.** 우측 화살표는 장식이며 별도 히트 영역을 만들지
/// 않는다 — 116 은 44dp 탭 타깃을 이미 넘는다.
///
/// 상태는 [badge] 하나로만 말한다. 액센트 바는 사용자가 걷어냈다(2026-09-01).
class CardHomework extends StatelessWidget {
  /// 카드를 만든다.
  const CardHomework({
    super.key,
    required this.chapterLabel,
    required this.title,
    required this.chips,
    required this.countLabel,
    required this.badge,
    this.dimmed = false,
    this.onTap,
  });

  /// 챕터 표기(예: `Chapter 03`). 숫자는 RTL 에서도 LTR 로 읽혀야 한다.
  final String chapterLabel;

  /// 챕터 이름. 길면 한 줄에서 말줄임한다 — 넘치면 카드 폭을 밀어낸다.
  final String title;

  /// 과제가 요구하는 활동 칩. 최대 4개까지 그린다.
  final List<HomeworkCardChip> chips;

  /// `완료수/전체수` 표기. 화면이 조립해 넘긴다.
  final String countLabel;

  /// 상태 배지.
  final Widget badge;

  /// 완료 카드인지 — 제목·챕터를 한 단 낮춘 색으로 그린다.
  final bool dimmed;

  /// 카드 탭. null 이면 눌리지 않는다.
  final VoidCallback? onTap;

  /// Figma 고정 높이.
  static const double height = 116;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final Color titleColor = dimmed ? c.labelNeutral : c.labelStrong;

    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s16,
          horizontal: AppSpacing.s20,
        ),
        decoration: BoxDecoration(
          color: c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 22,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      chapterLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.label1.b.copyWith(color: titleColor),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  badge,
                ],
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.label1.b.copyWith(color: titleColor),
            ),
            SizedBox(
              height: 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final (i, chip) in chips.take(4).indexed) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.s4),
                          HomeworkChip(label: chip.label, done: chip.done),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        countLabel,
                        style: AppType.caption1.r.copyWith(
                          color: c.labelNeutral,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      AppIcons.arrowRight(size: 16, color: c.labelNeutral),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
