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

  /// 배지 폭 상한. 이 너비를 넘는 문안은 말줄임으로 접힌다.
  ///
  /// 160 은 가장 좁은 사용처에서 역산했다 — 320dp 화면의 숙제 카드 안쪽 폭이
  /// 약 280 이고, 옆의 장 표기와 간격(8)이 최소 100 은 남아야 「3과」가 읽힌다.
  static const double _maxWidth = 160;

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

    // 배지는 **스스로 폭 상한을 진다.**
    //
    // 세 사용처(과제 상세·과제 목록·수업 카드)가 전부 배지를 flex 밖에 둔다.
    // flex 밖 자식은 무제약 폭으로 배치되므로 배지는 번역이 아무리 길어도
    // 그대로 자라고, 옆의 [Expanded] 가 음수 공간을 받아 행이 넘쳤다
    // (320dp 실측: 버마어 `HomeworkCard` 17px 초과).
    //
    // ⛔ 라벨에 [Flexible] 만 붙이면 못 고친다 — 무제약 폭에서 flex 자식은
    //    `RenderFlex ... unbounded` 로 죽는다. 상한을 먼저 씌워 안쪽 제약을
    //    유한하게 만들어야 [Flexible] 이 성립한다.
    //
    // 사용처를 고치지 않고 아톰에서 닫는 이유: 세 곳 다 같은 구조라 한 곳만
    // 고치면 나머지 둘이 같은 사고를 다시 낸다. 22 높이 알약이라 폭 상한은
    // 디자인상으로도 정당하다.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: Container(
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
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.caption2.m.copyWith(color: fg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
