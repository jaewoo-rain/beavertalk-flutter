import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// 알람 통화 모드 카드 — Figma 컴포넌트 세트 `Card-CallMode` `6179:4647`
/// (props `mode`=학습|자유 대화 · `selected`). 알람 추가 시트의 `CallMode` 그룹
/// (`6222:20794`, VERTICAL gap 8)에 두 장이 세로로 쌓인다.
///
/// ```
/// ┌ r12 · 패딩 12/14 · HORIZONTAL gap 10 · 세로 가운데 ──────────┐
/// │ [아이콘 24]  학습                ← Body 2 Bold                │
/// │              커리큘럼 표현 연습   ← Caption 1 Regular · Label/Normal │
/// └─────────────────────────────────────────────────────────┘
/// ```
///
/// - 선택: 채움 `Primary/Normal-10` · 테두리 `Primary/Normal` 1.5 · 제목·아이콘 `Primary/Normal`
/// - 미선택: 채움 `Background/Normal/Normal` · 테두리 `Line/Alternative` 1 · 제목 `Label/Strong` ·
///   아이콘 `Icon/Neutral` → 앱 토큰에 없어 가장 가까운 `labelNeutral`(app designer 09-24)
/// - ⚠ Figma 는 테두리 굵기 차이로 높이가 67/66 으로 흔들린다 — 여기서는 테두리를 **앞면 장식**
///   으로 그려 레이아웃에 넣지 않는다. 두 상태 높이가 같다.
class CardCallMode extends StatelessWidget {
  /// Creates a call-mode card.
  const CardCallMode({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  /// 아이콘(24, 색은 이 카드가 정한다) — `AppIcons.book` · `AppIcons.chat`.
  final AppIconBuilder icon;

  /// 제목(「학습」·「자유 대화」).
  final String title;

  /// 설명 한 줄.
  final String subtitle;

  /// 고른 모드인가.
  final bool selected;

  /// 누르면.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final radius = BorderRadius.circular(12);
    final accent = selected ? c.primaryNormal : c.labelStrong;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected ? c.primaryNormal10 : c.backgroundNormalNormal,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: selected ? c.primaryNormal : c.lineAlternative,
                width: selected ? 1.5 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                icon(size: 24, color: selected ? c.primaryNormal : c.labelNeutral),
                const SizedBox(width: 10),
                // 글자 묶음은 남은 폭을 다 쓴다 — 긴 번역은 줄을 바꾼다(자르지 않는다).
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: AppType.body2.b.copyWith(color: accent)),
                      Text(
                        subtitle,
                        style: AppType.caption1.r.copyWith(color: c.labelNormal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
