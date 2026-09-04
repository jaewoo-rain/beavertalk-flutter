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
        // 🔴 **고정 높이가 아니라 최소 높이다.** 칩 줄이 늘면 카드가 그만큼 자란다.
        //    예전에는 `height: 116` 고정이라 칩이 한 줄을 넘는 순간 잘렸다 —
        //    한국어(발음·회화·워크북)만 겨우 들어갔고 **나머지 29개 로케일이 전부
        //    가로로 넘쳤다**(2026-09-04 실측, 320dp 기준).
        //    ⛔ 같은 로케일·같은 활동 수면 높이가 같으므로 스펙 §8 이 걱정한
        //      「상태별로 어긋나 리스트가 튀는」 일은 생기지 않는다.
        constraints: const BoxConstraints(minHeight: height),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s16,
          horizontal: AppSpacing.s20,
        ),
        decoration: BoxDecoration(
          color: c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          // 내용이 최소 높이보다 짧으면 spaceBetween 이 종전과 똑같이 벌려 준다.
          // 길어지면 min 이 카드를 늘린다.
          mainAxisSize: MainAxisSize.min,
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
            Row(
              // 칩이 두 줄이 돼도 「n/m →」 는 첫 줄에 붙어 있어야 읽힌다.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // 🔴 **Row 가 아니라 Wrap 이다.** 활동 이름은 로케일마다 길이가
                  //    크게 다르다(ko 「발음」 2자 ↔ de 「Aussprache」 10자).
                  //    한 줄에 밀어 넣으면 잘린다 — 넘치면 줄을 바꾼다.
                  child: Wrap(
                    spacing: AppSpacing.s4,
                    runSpacing: AppSpacing.s4,
                    children: [
                      for (final chip in chips.take(4))
                        HomeworkChip(label: chip.label, done: chip.done),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                // 칩 첫 줄(22)과 눈높이를 맞춘다.
                SizedBox(
                  height: 22,
                  child: Row(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
