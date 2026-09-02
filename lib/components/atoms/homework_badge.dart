import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// 숙제 배지의 색 갈래 — Figma `숙제/Badge` 의 `tone` 변이와 1:1.
///
/// 색은 **상태 하나에만** 붙는다(스펙 §7 「색 사용」). 초록은 완료, 주황은 마감
/// 임박, 빨강은 미제출, 회색은 중립이다. 이 표에 없는 뜻으로 색을 늘리지 마라.
enum HomeworkBadgeTone {
  /// 회색 — 마감이 아직 멀다(`D-5`).
  neutral,

  /// 초록 — 완료.
  success,

  /// 주황 — 마감 임박(`D-1 · 밤 11시`).
  warning,

  /// 빨강 — 미제출(`미제출 · 2일 지남`).
  danger,
}

/// 숙제 배지 — Figma `숙제/Badge`(`5667:29723`) 실측.
///
/// 높이 22 · 알약 · 텍스트 `Caption 2 Medium`. 좌우 패딩 9, 체크를 켜면 왼쪽만
/// 7 로 줄어 글리프와 글자의 시각 간격이 맞는다.
class HomeworkBadge extends StatelessWidget {
  /// 배지를 만든다. [label] 문안은 화면이 로케일로 조립해 넘긴다.
  const HomeworkBadge({
    super.key,
    required this.tone,
    required this.label,
    this.showCheck = false,
  });

  /// 색 갈래.
  final HomeworkBadgeTone tone;

  /// 표시 문안. **서버가 만들지 않는다** — 마감 표기는 앱이 조립한다.
  final String label;

  /// 앞에 체크 글리프를 붙일지. 완료 배지에서만 켠다.
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (Color bg, Color fg) = switch (tone) {
      HomeworkBadgeTone.neutral => (c.fillNormal, c.labelNeutral),
      HomeworkBadgeTone.success => (c.primaryNormal10, c.primaryForeground),
      HomeworkBadgeTone.warning => (
        c.statusCautionarySurface,
        c.accentForegroundOrange,
      ),
      HomeworkBadgeTone.danger => (c.statusNegative6, c.accentForegroundRed),
    };

    return Container(
      height: 22,
      padding: EdgeInsets.only(left: showCheck ? 7 : 9, right: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showCheck) ...[
            AppIcons.check(size: 16, color: fg),
            const SizedBox(width: 2),
          ],
          Text(label, style: AppType.caption2.m.copyWith(color: fg)),
        ],
      ),
    );
  }
}
