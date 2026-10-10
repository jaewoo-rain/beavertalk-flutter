import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../icons/app_icons.dart';
import '../layout/need_based_rows.dart';

/// 알람 「반복 선택」 — 알람 추가·수정 시트 **안의 하위 화면**(09-24 사용자 확정).
///
/// 정본 Figma `BottomSheet/AlarmRepeat`: Mobile `screen/etc_alarm__add_repeat` `6180:4764`
/// (시트 `6357:13496`) · Tablet `6238:50587`(시트 `6357:41572`).
/// ```
/// [Handle]                     ← 바깥 시트(BottomSheetAlarmAdd)가 그린다
/// [<]      반복      [  ]      ← Header 44 · 뒤로 칸 30 · 제목 가운데(같은 폭을 끝에 비움)
/// ┌ 일요일              ✓ ┐    ← Group/Days · r12 · 줄 52 · 패딩 0/16 · 아래 선(마지막 제외)
/// │ 월요일                │
/// │ …(토요일까지 7줄)      │
/// └──────────────────────┘
/// [          완료          ]   ← Button 60 primary_fill
/// ```
/// VERTICAL gap 16 · 높이는 내용에 맞춘다(빈 Spacer 없음).
///
/// - 요일은 **일요일부터**(서버 `Alarm.days` 0=일과 같은 순서)이고, 「~마다」 없이 요일 이름만
///   쓴다(사장님 지시). 줄 전체가 누름 영역이다.
/// - 체크는 고른 요일에만 보인다. 자리는 늘 잡아 둔다 — 체크가 켜지고 꺼질 때 글자가 밀리지 않게.
/// - 옛 인라인 요일 칩(`Panel/Repeat`, P2)을 대체한다.
class BottomSheetAlarmRepeat extends StatelessWidget {
  /// Creates the repeat picker body.
  const BottomSheetAlarmRepeat({
    super.key,
    required this.title,
    required this.doneText,
    required this.backLabel,
    required this.dayNames,
    required this.days,
    required this.onDayToggled,
    required this.onBack,
    required this.onDone,
  });

  /// 제목(「반복」).
  final String title;

  /// 아래 버튼(「완료」).
  final String doneText;

  /// 뒤로 버튼의 접근성 이름.
  final String backLabel;

  /// 요일 이름 7개, **일요일부터**(`AlarmDays.fullNames`).
  final List<String> dayNames;

  /// 7개, 일요일부터(0=일).
  final List<bool> days;

  /// 줄을 누르면 — 데이터 인덱스(0=일).
  final void Function(int index, bool on) onDayToggled;

  /// 「<」.
  final VoidCallback onBack;

  /// 「완료」.
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // 「<」 = 셰브런 24 를 180° 돌린 것(Figma BackSlot). 오른쪽→왼쪽 언어에서는 뒤로가 오른쪽을 본다.
    final chevron = AppIcons.chevronRight(size: 24, color: c.labelStrong);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: CenteredTitleRow(
            leading: Semantics(
              button: true,
              label: backLabel,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBack,
                child: SizedBox(
                  width: 30,
                  height: 44,
                  child: Center(
                    child: rtl ? chevron : RotatedBox(quarterTurns: 2, child: chevron),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.body1.b.copyWith(color: c.labelStrong),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: c.backgroundNormalNormal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 7; i++)
                  _DayRow(
                    name: dayNames[i],
                    on: days[i],
                    last: i == 6,
                    onTap: () => onDayToggled(i, !days[i]),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: doneText,
          onPressed: onDone,
        ),
      ],
    );
  }
}

/// `Row-Day` — 줄 52 · 패딩 0/16 · [요일 FILL] [체크 20].
class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.name,
    required this.on,
    required this.last,
    required this.onTap,
  });

  final String name;
  final bool on;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Semantics(
      button: true,
      checked: on,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: last
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: c.lineAlternative)),
                ),
          child: Row(
            children: [
              // 요일 이름은 남은 폭을 다 쓴다(Figma FILL) — 긴 이름(ru 「Воскресенье」)도 자르지 않는다.
              Expanded(
                child: Text(
                  name,
                  style: AppType.body2.r.copyWith(color: c.labelStrong),
                ),
              ),
              const SizedBox(width: 8),
              Opacity(
                opacity: on ? 1 : 0,
                child: AppIcons.check(size: 20, color: c.primaryNormal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
