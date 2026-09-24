import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../icons/app_icons.dart';
import 'bottom_sheet_alarm_settings.dart' show AlarmPartner;
import '../layout/need_based_rows.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../molecules/card_call_mode.dart';
import 'bottom_sheet_alarm_repeat.dart';

/// 알람 추가·편집 시트 — Figma `BottomSheet/AlarmAdd` (`screen/etc_alarm__add`
/// `6222:20710` · 반복 펼침 `6180:4764` · 상대 펼침 `6180:4865`).
///
/// ```
/// 취소        알람 추가
/// [ 07 ]  [ 59 ]          ← 24시간 휠 두 개(시·분)
/// [ 08 ]  [ 00 ]  ← 선택 띠
/// [ 09 ]  [ 01 ]
/// [ 학습 · 커리큘럼 표현 연습 ]  ← 통화 모드 카드 2장(Figma CallMode 6222:20794)
/// [ 자유 대화 · 주제 없이 대화 ]
/// ┌ 반복          평일 › ┐   ← 누르면 시트 **안에서** 「반복 선택」 화면이 밀려 들어온다
/// │ 통화 상대      Baba › │   ← 누르면 캐릭터 줄이 펼쳐진다
/// └──────────────────────┘
/// [          저장          ]
/// ```
///
/// 반복은 09-24 사용자 확정으로 인라인 요일 칩 → 하위 화면([BottomSheetAlarmRepeat],
/// Figma `6180:4764`)이 됐다. 오른쪽→왼쪽으로 250ms 밀려 들어오고, 「<」·「완료」·시스템 뒤로가
/// 시트 본문으로 되돌린다(시트는 닫히지 않는다).
///
/// 이 위젯은 **값을 들고 있지 않는다**(상태는 부르는 쪽). 펼침 여부만 제 것이다.
class BottomSheetAlarmAdd extends StatefulWidget {
  /// 시트를 만든다.
  const BottomSheetAlarmAdd({
    super.key,
    required this.title,
    required this.cancelText,
    required this.saveText,
    required this.repeatLabel,
    required this.partnerLabel,
    required this.hour24,
    required this.minute,
    required this.onTimeChanged,
    required this.days,
    required this.dayNames,
    required this.repeatDoneText,
    required this.repeatBackLabel,
    required this.daysSummary,
    required this.onDayToggled,
    required this.partners,
    required this.partner,
    required this.onPartnerChanged,
    required this.onSave,
    required this.onCancel,
    required this.callMode,
    required this.onCallModeChanged,
    required this.learnModeTitle,
    required this.learnModeSubtitle,
    required this.chatModeTitle,
    required this.chatModeSubtitle,
    this.initiallyOpen,
    this.initiallyRepeat = false,
  });

  /// 머리 제목(「알람 추가」·「알람 수정」).
  final String title;

  /// 왼쪽 위 「취소」.
  final String cancelText;

  /// 아래 버튼.
  final String saveText;

  /// 설정 줄 라벨 — 「반복」·「통화 상대」.
  final String repeatLabel;
  final String partnerLabel;

  /// 0–23 · 0–59.
  final int hour24;
  final int minute;

  /// 휠이 멈추면.
  final void Function(int hour24, int minute) onTimeChanged;

  /// 7개, **일요일부터**(0=일).
  final List<bool> days;

  /// 요일 이름 7개, 일요일부터(`AlarmDays.fullNames`) — 「반복 선택」 화면 줄.
  final List<String> dayNames;

  /// 「반복 선택」 화면의 「완료」 · 뒤로 버튼 접근성 이름.
  final String repeatDoneText;
  final String repeatBackLabel;

  /// 「반복」 줄 오른쪽 값(「평일」).
  final String daysSummary;

  /// 칩을 누르면 — 데이터 인덱스(0=일).
  final void Function(int index, bool on) onDayToggled;

  /// 통화 상대 후보.
  final List<AlarmPartner> partners;

  /// 지금 고른 상대 id.
  final String partner;

  /// 상대를 고르면.
  final ValueChanged<String> onPartnerChanged;

  /// 저장 · 취소.
  final VoidCallback onSave;
  final VoidCallback onCancel;

  /// 이 알람 통화의 모드 — 서버 `Alarm.call_type`(09-24 배포).
  final AlarmCallMode callMode;

  /// 모드 카드를 누르면.
  final ValueChanged<AlarmCallMode> onCallModeChanged;

  /// 모드 카드 문구 — 학습 · 자유 대화(Figma `Card-CallMode` `6179:4647`).
  final String learnModeTitle;
  final String learnModeSubtitle;
  final String chatModeTitle;
  final String chatModeSubtitle;

  /// 처음부터 펼쳐 둘 칸(시험용 — 하네스가 **다 연 상태**를 그려야 가장 긴 경우를 본다).
  final Set<AlarmAddPanel>? initiallyOpen;

  /// 처음부터 「반복 선택」 화면을 보인다(시험용).
  final bool initiallyRepeat;

  @override
  State<BottomSheetAlarmAdd> createState() => _BottomSheetAlarmAddState();
}

/// 펼칠 수 있는 칸. 반복은 펼침이 아니라 하위 화면이다(09-24).
enum AlarmAddPanel { partner }

class _BottomSheetAlarmAddState extends State<BottomSheetAlarmAdd> {
  late final Set<AlarmAddPanel> _open = {...?widget.initiallyOpen};

  void _toggle(AlarmAddPanel p) =>
      setState(() => _open.contains(p) ? _open.remove(p) : _open.add(p));

  /// 「반복 선택」 하위 화면을 보이는 중인가.
  late bool _repeat = widget.initiallyRepeat;

  void _showRepeat(bool v) => setState(() => _repeat = v);

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final partnerName = widget.partners
        .firstWhere((p) => p.id == widget.partner,
            orElse: () => widget.partners.first)
        .name;
    return Container(
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 24),
        child: ContentColumn(
          gutter: 16,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.backgroundElevatedNormal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 본문 ↔ 「반복 선택」 — 같은 시트 안에서 밀어 넣고 뺀다(오른쪽→왼쪽, 250ms).
              // 높이는 각자 내용에 맞춘다(AnimatedSize). 시스템 뒤로는 시트를 닫지 않고 본문으로.
              Flexible(
                child: PopScope(
                  canPop: !_repeat,
                  onPopInvokedWithResult: (didPop, _) {
                    if (!didPop && _repeat) _showRepeat(false);
                  },
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    alignment: Alignment.topCenter,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      layoutBuilder: (current, previous) => Stack(
                        alignment: Alignment.topCenter,
                        children: [...previous, ?current],
                      ),
                      transitionBuilder: (child, animation) {
                        final rtl = Directionality.of(context) == TextDirection.rtl;
                        // 하위 화면은 끝 쪽에서 들어오고, 본문은 시작 쪽에서 돌아온다.
                        final fromEnd = child.key == const ValueKey('repeat');
                        final dx = (fromEnd ? 1.0 : -1.0) * (rtl ? -1 : 1);
                        return ClipRect(
                          child: SlideTransition(
                            position: Tween(begin: Offset(dx, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation, curve: Curves.easeOut)),
                            child: child,
                          ),
                        );
                      },
                      child: _repeat
                          ? KeyedSubtree(
                              key: const ValueKey('repeat'),
                              child: BottomSheetAlarmRepeat(
                                title: widget.repeatLabel,
                                doneText: widget.repeatDoneText,
                                backLabel: widget.repeatBackLabel,
                                dayNames: widget.dayNames,
                                days: widget.days,
                                onDayToggled: widget.onDayToggled,
                                onBack: () => _showRepeat(false),
                                onDone: () => _showRepeat(false),
                              ),
                            )
                          : KeyedSubtree(
                              key: const ValueKey('main'),
                              child: _main(context, partnerName),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 시트 본문 — 머리 · (휠 · 모드 · 설정) · 저장.
  Widget _main(BuildContext context, String partnerName) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          const SizedBox(height: 16),
          // 휠 + 모드 + 설정만 스크롤 — 머리(취소·제목)와 저장 버튼은 붙어 있다. 상대 펼침을
          // 열면 320dp·긴 로케일·큰 글꼴에서 화면보다 길다(모달 상한 = 화면 높이).
          // 짧으면 픽셀이 그대로다. 휠은 자체 스크롤이라 휠 위의 끌기는 휠이 받는다.
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TimeWheel(
                    hour24: widget.hour24,
                    minute: widget.minute,
                    onChanged: widget.onTimeChanged,
                  ),
                  const SizedBox(height: 16),
                  _callModes(),
                  const SizedBox(height: 16),
                  _settings(context, partnerName),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: widget.saveText,
            onPressed: widget.onSave,
          ),
        ],
      );

  /// 「취소 · 제목 · (빈칸)」 — 제목이 가운데 서도록 좌우를 같은 폭으로 둔다.
  Widget _header(BuildContext context) {
    final c = context.c;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      // 「취소」 칸은 **자기 글자 폭**만 쓰고 끝 쪽에 같은 폭을 비운다 — 제목은 행의 가운데.
      // 1:2:1 비율 분할은 「キャンセル」·「Отмена」 를 줄바꿈시키면서 오른쪽 빈칸 72~82px 를
      // 버렸다(09-24 전수조사 G). 제목은 길면 줄을 바꾼다(자르지 않는다).
      // ⛔ `Row`+`Flexible` 로 되돌리지 마라 — 제목이 「취소」 에 붙는다(2026-09-23 지적).
      child: CenteredTitleRow(
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onCancel,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              widget.cancelText,
              style: AppType.body2.r.copyWith(color: c.labelNeutral),
            ),
          ),
        ),
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: AppType.body1.b.copyWith(color: c.labelStrong),
        ),
      ),
    );
  }

  /// 통화 모드 카드 두 장 — Figma `CallMode` `6222:20794`: 시간 휠 아래 · 반복/통화 상대 위 ·
  /// VERTICAL gap 8 · 항상 보인다(접지 않는다). 카드 `6222:20795`(학습) · `6222:20796`(자유 대화).
  Widget _callModes() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardCallMode(
            icon: AppIcons.book,
            title: widget.learnModeTitle,
            subtitle: widget.learnModeSubtitle,
            selected: widget.callMode == AlarmCallMode.learn,
            onTap: () => widget.onCallModeChanged(AlarmCallMode.learn),
          ),
          const SizedBox(height: 8),
          CardCallMode(
            icon: AppIcons.chat,
            title: widget.chatModeTitle,
            subtitle: widget.chatModeSubtitle,
            selected: widget.callMode == AlarmCallMode.chat,
            onTap: () => widget.onCallModeChanged(AlarmCallMode.chat),
          ),
        ],
      );

  Widget _settings(BuildContext context, String partnerName) {
    final c = context.c;
    final partnerOpen = _open.contains(AlarmAddPanel.partner);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: c.backgroundNormalNormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 반복은 하위 화면으로 간다(펼치지 않는다) — 셰브런은 늘 오른쪽을 본다.
            _SettingRow(
              label: widget.repeatLabel,
              value: widget.daysSummary,
              open: false,
              onTap: () => _showRepeat(true),
            ),
            Divider(height: 1, thickness: 1, color: c.lineAlternative),
            _SettingRow(
              label: widget.partnerLabel,
              value: partnerName,
              open: partnerOpen,
              onTap: () => _toggle(AlarmAddPanel.partner),
            ),
            if (partnerOpen)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final p in widget.partners) ...[
                      if (p != widget.partners.first) const SizedBox(width: 16),
                      _PartnerOption(
                        partner: p,
                        selected: p.id == widget.partner,
                        onTap: () => widget.onPartnerChanged(p.id),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// `Row-Setting` (`6179:28625`) — 라벨 · 값 · 셰브런(펼치면 아래로).
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
    required this.open,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Semantics(
      button: true,
      expanded: open,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 라벨은 왼쪽 끝, 값·셰브런은 오른쪽 끝(Figma justify-between). 폭은 **글자
                // 폭대로** 나눈다(LabelValueRow) — `Flexible` 은 몫을 남겨 값이 가운데로 몰렸고
                // (09-23), `Expanded` 둘은 반반으로 갈라 「반복 / 월 · 수 · 금」 에서 100px 를
                // 버렸다(09-24 전수조사 E). 라벨·값 둘 다 자르지 않고 줄을 바꾼다.
                Expanded(
                  child: LabelValueRow(
                    gap: 12,
                    label: Text(label,
                        style: AppType.body2.r.copyWith(color: c.labelStrong)),
                    // 값은 식별자(요일 요약·캐릭터 이름)라 자르지 않는다 — 길면 줄을 바꾼다.
                    value: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: AppType.body2.r.copyWith(
                        color: open ? c.primaryNormal : c.labelAlternative,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: AppIcons.chevronRight(
                    size: 20,
                    color: open ? c.primaryNormal : c.labelAlternative,
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

/// `Option-Partner` (`6179:28637`) — 48 원형 얼굴 + 이름.
class _PartnerOption extends StatelessWidget {
  const _PartnerOption({
    required this.partner,
    required this.selected,
    required this.onTap,
  });

  final AlarmPartner partner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final img = partner.imageProvider;
    return Semantics(
      button: true,
      selected: selected,
      label: partner.name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 56,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.backgroundNormalAlternative,
                  image: img == null
                      ? null
                      : DecorationImage(image: img, fit: BoxFit.cover),
                  border: selected
                      ? Border.all(color: c.primaryNormal, width: 2)
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                partner.name,
                textAlign: TextAlign.center,
                style: (selected ? AppType.caption1.b : AppType.caption1.r)
                    .copyWith(color: selected ? c.primaryNormal : c.labelNeutral),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `Picker-Time` — 시·분 24시간 휠 두 개, 가운데 선택 띠(r10).
class _TimeWheel extends StatefulWidget {
  const _TimeWheel({
    required this.hour24,
    required this.minute,
    required this.onChanged,
  });

  final int hour24;
  final int minute;
  final void Function(int hour24, int minute) onChanged;

  @override
  State<_TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<_TimeWheel> {
  late final _h = FixedExtentScrollController(initialItem: widget.hour24);
  late final _m = FixedExtentScrollController(initialItem: widget.minute);

  /// 지금 가운데 칸 — 컨트롤러의 `selectedItem` 을 빌드 중에 읽으면 위치가 잡히기 전엔
  /// 던진다. 그래서 바뀔 때 받아 적어 둔다.
  late int _hSel = widget.hour24;
  late int _mSel = widget.minute;

  // Figma `Picker-Time`(6222:20710 안, 343×156): 보이는 칸은 **3개**(위·선택·아래)이고
  // 칸 중심 간격 36(07·08·09 중심 y 315·351·387). 시·분 열 중심 간격 65(x 155.5·220.5).
  // 예전 34·높이 156 전체였을 때는 5칸이 보이고 열이 96 벌어져 있었다(2026-09-23).
  static const double _extent = 36;
  static const double _colWidth = 56;
  static const double _colGap = 65 - _colWidth;

  @override
  void dispose() {
    _h.dispose();
    _m.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    Widget wheel(FixedExtentScrollController ctrl, int count, bool isHour) =>
        SizedBox(
          width: _colWidth,
          height: _extent * 3,
          child: ListWheelScrollView.useDelegate(
            controller: ctrl,
            itemExtent: _extent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.6,
            // 순환 목록이라 칸 번호가 0..n-1 을 넘는다 — 접어서 넘긴다.
            onSelectedItemChanged: (i) {
              setState(() => isHour ? _hSel = _wrap(i, 24) : _mSel = _wrap(i, 60));
              widget.onChanged(_hSel, _mSel);
            },
            childDelegate: ListWheelChildLoopingListDelegate(
              children: [
                for (var i = 0; i < count; i++)
                  Center(
                    child: _WheelLabel(
                      text: i.toString().padLeft(2, '0'),
                      selected: i == (isHour ? _hSel : _mSel),
                    ),
                  ),
              ],
            ),
          ),
        );
    return SizedBox(
      height: 156,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: c.backgroundNormalNormal,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wheel(_h, 24, true),
              const SizedBox(width: _colGap),
              wheel(_m, 60, false),
            ],
          ),
        ],
      ),
    );
  }
}

/// 휠 한 칸 — 가운데(선택)는 크고 진하게, 나머지는 작고 흐리게.
class _WheelLabel extends StatelessWidget {
  const _WheelLabel({required this.text, required this.selected});

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Text(
      text,
      style: (selected ? AppType.heading1.m : AppType.headline1.r).copyWith(
        color: selected ? c.labelStrong : c.labelAssistive,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// 순환 휠의 칸 번호(음수·n 이상 가능)를 0..n-1 로 접는다.
int _wrap(int i, int n) => ((i % n) + n) % n;
