import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../atoms/toggle.dart';

/// 알람 목록의 한 줄 — Figma `Row-Alarm` (`6179:4634`, state=on|off).
///
/// iOS 알람처럼 **목록형**이다(예전 카드형 `CardAlarm` 을 대체).
/// ```
/// Baba                       ← 통화 상대(Caption 1)
/// 8:00                  [●]  ← 시각(Title 3 Regular) · 켜기/끄기
/// 평일                       ← 반복 요약(Caption 1)
/// ```
/// 꺼지면 글자 셋이 `Label/Assistive` 로 흐려진다. 줄 사이 선은 [RowAlarmGroup] 이 긋는다.
///
/// ⛔ 높이를 고정하지 마라. 세 줄 모두 글자라 배율이 크면 자란다(정본 109 는 결과값).
class RowAlarm extends StatelessWidget {
  /// 한 줄을 만든다.
  const RowAlarm({
    super.key,
    required this.partner,
    required this.time,
    required this.summary,
    required this.active,
    this.onChanged,
    this.onTap,
  });

  /// 통화 상대 이름.
  final String partner;

  /// 시각 — 「8:00」.
  final String time;

  /// 반복 요약 — 「평일」.
  final String summary;

  /// 켜져 있는가.
  final bool active;

  /// 토글.
  final ValueChanged<bool>? onChanged;

  /// 줄을 누르면(편집).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final sub = active ? c.labelNormal : c.labelAssistive;
    final main = active ? c.labelStrong : c.labelAssistive;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름·요약은 식별자라 자르지 않는다 — 길면 줄을 바꾼다.
                  Text(partner, style: AppType.caption1.r.copyWith(color: sub)),
                  // 시각은 이 줄의 주인공이다 — Figma `Row-Alarm`(`6179:28978`)의
                  // `MO/Title 3/Regular` 는 **40 / 줄높이 52** 다.
                  //
                  // ⚠ 앱의 `AppType.title3` 는 24/32 라 이름이 같아도 **다른 크기**다.
                  //   그걸 쓰는 바람에 행이 정본 109 → 74 로 눌려 세 줄이 서로 붙어
                  //   보였다(2026-09-23 사장님 지적 「객체가 서로 몰려있다」).
                  //   앱 스케일을 건드리면 다른 화면이 같이 움직이므로 여기서만 값을 준다.
                  Text(
                    time,
                    style: AppType.title3.r.copyWith(
                      fontSize: 40,
                      height: 52 / 40,
                      letterSpacing: -2.82,
                      color: main,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(summary, style: AppType.caption1.r.copyWith(color: sub)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AppToggle(value: active, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

/// [RowAlarm] 묶음 — Figma `Group/Alarms`: 떠 있는 면 · 모서리 14 · 줄마다 아래 선
/// (`Line/Alternative`). 마지막 줄의 선은 모서리에 잘려 보이지 않는다(정본도 같다).
class RowAlarmGroup extends StatelessWidget {
  /// 묶음을 만든다.
  const RowAlarmGroup({super.key, required this.children});

  /// 줄들.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Material(
        color: c.backgroundElevatedAlternative,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: i == children.length - 1
                      ? null
                      : Border(bottom: BorderSide(color: c.lineAlternative)),
                ),
                child: children[i],
              ),
          ],
        ),
      ),
    );
  }
}
