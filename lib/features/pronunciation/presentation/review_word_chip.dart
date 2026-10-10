import 'package:flutter/material.dart';

import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../review/domain/entities/review_feedback.dart';
import '../domain/phoneme_diagram.dart';

/// 오류 단어는 유지하되 실제 목표 자모가 있을 때만 교정 도식을 연다.
class ReviewWordChip extends StatelessWidget {
  const ReviewWordChip({
    super.key,
    required this.word,
    required this.worst,
    required this.charIndex,
    required this.misses,
    required this.onOpen,
  });

  final String word;
  final CharScore worst;
  final int charIndex;
  final List<PhonemeMiss> misses;
  final void Function(PhonemeDiagram target, PhonemeDiagram? current) onOpen;

  @override
  Widget build(BuildContext context) {
    PhonemeDiagram? target;
    PhonemeDiagram? current;
    for (final miss in misses) {
      if (miss.charIndex != charIndex) continue;
      if (miss.expected.trim().isEmpty) break;
      final parts = splitJamo(worst.char);
      final pair = diagramPair(
        miss.expected,
        miss.actual,
        isCoda:
            parts != null &&
            parts.coda.isNotEmpty &&
            parts.coda == miss.expected,
      );
      target = pair.target;
      current = pair.current;
      break;
    }
    final actualTarget = target;
    final c = context.c;
    final low = worst.grade == CharGrade.low;
    final dot = low ? c.statusNegative : c.statusCautionary;
    return GestureDetector(
      onTap: actualTarget == null ? null : () => onOpen(actualTarget, current),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: low ? c.statusNegative6 : c.backgroundSurfaceAlternative,
          border: Border.all(
            color: low ? c.statusNegative : c.lineNeutral,
            width: low ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(word, style: AppType.label2.b.copyWith(color: c.labelNormal)),
          ],
        ),
      ),
    );
  }
}
