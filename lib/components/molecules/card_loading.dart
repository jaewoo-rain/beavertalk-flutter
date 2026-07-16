import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../atoms/skeleton.dart';

/// CardLoading — the loading stand-in for [CardBookmark], Figma `Card-Loading`
/// (`3444:910`).
///
/// Figma's own note on the component: *"새로 배운 표현 로딩(스켈레톤) 카드.
/// Card-Bookmark(335×136)와 동일한 골격이라 로드 완료 시 레이아웃 점프가 없다."*
/// That equal height is the whole point, so this mirrors [CardBookmark]'s box
/// exactly — padding `20/16`, radius 12, and the same 52 + 16 + 36 stack — and
/// takes no size arguments that could drift from it.
///
/// Use this anywhere [CardBookmark] is about to appear. Note that
/// `screen/analysis_loading` (`3569:27500`) draws its own 113-tall
/// `Card/Expression-1` instead of instancing this: that frame predates the
/// component and would jump 23px per card on load, so this is used there too.
///
/// Must sit under a [SkeletonShimmer].
class CardLoading extends StatelessWidget {
  /// Creates a learned-sentence loading card.
  const CardLoading({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Skeleton/Text (3444:912) — the sentence over its translation.
            Skeleton.bar(width: 210, height: 20),
            SizedBox(height: AppSpacing.s8),
            Skeleton.bar(width: 150, height: 16),
            SizedBox(height: AppSpacing.s16),
            // Skeleton/Action (3444:915) — speaker + bookmark, then 연습하기.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Skeleton.box(width: 24, height: 24),
                    SizedBox(width: AppSpacing.s8),
                    Skeleton.box(width: 24, height: 24),
                  ],
                ),
                Skeleton.box(width: 70, height: 36),
              ],
            ),
          ],
        ),
      );
}
