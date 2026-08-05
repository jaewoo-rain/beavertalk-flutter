import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../atoms/skeleton.dart';

/// CardBoxLoading — the loading stand-in for a `CardBox(type: record)` row,
/// Figma `Card-Box-Loading` (`3488:911`).
///
/// Figma's own note on the component: *"통화 기록 행(Card-Box / type=record)의
/// 로딩 스켈레톤. 335×88 동일 — DB 로딩 분기용."* The equal height is the point,
/// so this takes no size arguments.
///
/// Must sit under a [SkeletonShimmer].
class CardBoxLoading extends StatelessWidget {
  /// Creates a call-record loading row.
  const CardBoxLoading({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10), // no s10 token
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: const Row(
          children: [
            Skeleton.circle(size: 64),
            SizedBox(width: 6), // no s6 token
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Widths are the design's *clipped* ones: each skeleton frame
                // sets overflow-clip and holds a bar wider than itself (e.g.
                // `skeleton/Judi` is a 29-wide box over a 52-wide bar), so the
                // box is what shows.
                _Line(width: 29),
                SizedBox(height: 4),
                _Line(width: 130),
                SizedBox(height: 4),
                Row(
                  children: [
                    _Line(width: 64),
                    SizedBox(width: 4),
                    Skeleton.circle(size: 4), // the `·` between date and length
                    SizedBox(width: 4),
                    _Line(width: 61),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}

/// A 12-high bar inside the 20-high line box the design gives every text row —
/// the box, not the bar, is what sets the row's rhythm.
class _Line extends StatelessWidget {
  const _Line({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 20,
        child: Center(child: Skeleton.bar(width: width, height: 12)),
      );
}
