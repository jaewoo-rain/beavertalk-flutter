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
/// The equal height is the point; the 136 is not. **That note is now false
/// against its own file**: `Card-Bookmark` was restyled (a 14px sentence over a
/// 12px translation, gap 8) and measures 116 in `screen/analysis` and 120 in
/// `screen/record_archive`, while `Card-Loading` still sits at 136 and
/// `screen/analysis_loading` draws its own 113-tall `Card/Expression-1` — four
/// heights for one skeleton whose only job is to not jump.
///
/// So this matches **[CardBookmark] itself (116)**, not the stale component:
/// copying the 136 would mint a 20px jump per card. The bar sizes are still
/// Figma's (210×20, 150×16, 70×36) — only the gaps follow the card this stands
/// in for. Design owes `Card-Loading` an update either way.
///
/// Use this anywhere [CardBookmark] is about to appear. Takes no size arguments
/// that could drift from it. Must sit under a [SkeletonShimmer].
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
            // 20 + 4 + 16 is the card's own line box stack (Label 1 over
            // Caption 1), so the two lines land where the real text will.
            Skeleton.bar(width: 210, height: 20),
            SizedBox(height: AppSpacing.s4),
            Skeleton.bar(width: 150, height: 16),
            SizedBox(height: AppSpacing.s8),
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
