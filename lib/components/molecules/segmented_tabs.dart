import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// SegmentedTabs — 알약 탭 한 줄. Figma `Tab/Pill` (`6459:46170`, selected=true|false) ·
/// 화면 `screen/record_list` `3360:71` · `record_archive` `3360:96`.
///
/// 09-26 사용자 「어떤 버튼이 눌렸는지 티가 안나」 → 검수안 A-1 확정. 예전에는 버튼
/// (`secondaryFill` / `secondaryOutline`)을 빌려 썼는데 Light 에서 둘이 같은 모양이었다.
/// 이제 버튼을 빌리지 않는 전용 알약이다:
/// - 공통: 높이 44(패딩 12/16 + 줄 20) · 반경 12 · 글자 14 · 탭 사이 12 · 테두리 없음
/// - 선택: 바탕 `Background/Elevated/Alternative` · 글자 `Label/Strong` Bold
/// - 비선택: 바탕 `Fill/Normal` · 글자 `Label/Alternative` Medium
///
/// 완전 제어형: [labels] · [activeIndex] 를 넘기고, 누르면 [onChanged] 가 그 번호로 불린다.
class SegmentedTabs extends StatelessWidget {
  /// Creates a segmented tab row.
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.activeIndex,
    this.onChanged,
  });

  /// Tab labels, left → right.
  final List<String> labels;

  /// Index of the currently-active tab.
  final int activeIndex;

  /// Called with the tapped tab's index.
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          // Flexible (not Expanded): 들어가면 제 폭(Figma `3360:83` MIN·HUG — 뒤가 비는 것이
          // 디자인), 안 들어가면 줄어들며 글자가 줄을 바꾼다.
          Flexible(
            child: TabPill(
              label: labels[i],
              selected: i == activeIndex,
              onTap: onChanged == null ? null : () => onChanged!(i),
            ),
          ),
        ],
      ],
    );
  }
}

/// `Tab/Pill` 한 칸 — [SegmentedTabs] 가 쓰고, 가로 스크롤 줄처럼 틀이 다른 곳(결제 내역
/// 필터)은 이것만 가져다 쓴다.
class TabPill extends StatelessWidget {
  /// Creates one pill.
  const TabPill({super.key, required this.label, required this.selected, this.onTap});

  /// 라벨.
  final String label;

  /// 선택됐는가.
  final bool selected;

  /// 누르면.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final radius = BorderRadius.circular(AppRadius.sm);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.backgroundElevatedAlternative : c.fillNormal,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            // 라벨은 자르지 않고 줄을 바꾼다(버튼과 같은 규칙 · 셋째 줄부터 말줄임).
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: (selected ? AppType.label1.b : AppType.label1.m).copyWith(
                color: selected ? c.labelStrong : c.labelAlternative,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
