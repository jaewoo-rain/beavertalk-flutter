import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/icons/app_icons.dart';
import '../../../components/layout/need_based_rows.dart';
import '../../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../../features/classroom/domain/entities/classroom_membership.dart';
import '../../../features/classroom/presentation/assignment_display.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import 'assignment_badge.dart';

// 숙제 탭 개편(2026-10-12 확정) 목록 부품 — Figma `8ZSZBmb5wFi6OMZhx8SBaN`
// 목록 `6677:18145` · 상세 머리 `6692:17037`.

/// 교사 이름이 이미 '선생님'으로 끝나는지(공백 무시).
///
/// 콘솔은 교사가 적은 값을 그대로 저장한다. '김 선생님'처럼 적으면 앱이 덧붙인 호칭과
/// 겹쳐 '김 선생님 선생님'·'Teacher 김 선생님'이 된다(2026-10-13 command center).
bool teacherNameHasTitle(String name) =>
    name.replaceAll(RegExp(r'\s'), '').endsWith('선생님');

/// 머리·상세에 쓰는 교사 표시 — 호칭이 이미 있으면 적힌 그대로 쓴다.
String teacherLabel(AppLocalizations l10n, String name) =>
    teacherNameHasTitle(name) ? name : l10n.hwTeacherName(name);

/// 반 정보 머리 — 아이콘 · 기관 · 반 이름 · 선생님 · 학기(`6677:18149`).
///
/// 기관·선생님·학기는 교사가 안 적었으면 없다. **빈 줄을 남기지 않는다** — 줄째
/// 숨긴다(인계 명세 §2-4).
///
/// 반이 둘 이상이면 [onPickClass] 가 들어온다 — 반 이름 오른쪽에 아래 방향 셰브런을
/// 붙이고, 반 이름 줄 전체를 누르면 반 선택 시트를 연다(2026-10-13 확정 §2-7 · `6703:63464`).
class HomeworkClassHeader extends StatelessWidget {
  /// 머리를 만든다.
  const HomeworkClassHeader({
    super.key,
    required this.classroom,
    this.onPickClass,
  });

  /// 보여 줄 반.
  final JoinedClassroom classroom;

  /// 반 바꾸기. null 이면 반이 하나라 셰브런이 없다.
  final VoidCallback? onPickClass;

  static String? _clean(String? v) =>
      (v == null || v.trim().isEmpty) ? null : v.trim();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final institution = _clean(classroom.institution);
    final teacher = _clean(classroom.teacherDisplayName);
    final term = _clean(classroom.term);
    final meta = AppType.caption1.m.copyWith(color: c.labelNeutral);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라이브러리 Size=36 변형을 72 로 키워 쓴다(시안 그대로).
        AppIcons.duoHomework(size: 72),
        const SizedBox(height: AppSpacing.s12),
        if (institution != null) ...[
          Text(institution, style: meta),
          const SizedBox(height: AppSpacing.s8),
        ],
        if (onPickClass == null)
          Text(
            classroom.name,
            style: AppType.title3.b.copyWith(color: c.labelStrong),
          )
        else
          Semantics(
            button: true,
            label: l10n.hwA11yClassPicker,
            child: GestureDetector(
              key: const ValueKey('hw-class-picker'),
              onTap: onPickClass,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      classroom.name,
                      style: AppType.title3.b.copyWith(color: c.labelStrong),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s4),
                  // 라이브러리에 아래 방향 셰브런이 없어 오른쪽 셰브런을 돌려 쓴다.
                  RotatedBox(
                    quarterTurns: 1,
                    child: AppIcons.chevronRight(size: 20, color: c.labelStrong),
                  ),
                ],
              ),
            ),
          ),
        if (teacher != null || term != null) ...[
          const SizedBox(height: AppSpacing.s8),
          // 좁은 폭·긴 이름이면 다음 줄로 내려간다. 한 줄에 우겨 넣지 않는다.
          Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s4,
            children: [
              if (teacher != null)
                _IconText(
                  icon: AppIcons.teacher(size: 16, color: c.labelNeutral),
                  text: teacherLabel(l10n, teacher),
                  style: meta,
                ),
              if (term != null)
                _IconText(
                  icon: AppIcons.calendar(size: 16, color: c.labelNeutral),
                  text: term,
                  style: meta,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 반 선택 시트(`6703:63542`). 고른 반 id 를 돌려준다 — 닫기만 하면 null.
Future<int?> showClassPickerSheet(
  BuildContext context, {
  required List<JoinedClassroom> classrooms,
  required int selectedId,
}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: context.c.materialDim,
    isScrollControlled: true,
    builder: (_) =>
        _ClassPickerSheet(classrooms: classrooms, selectedId: selectedId),
  );
}

class _ClassPickerSheet extends StatelessWidget {
  const _ClassPickerSheet({required this.classrooms, required this.selectedId});

  final List<JoinedClassroom> classrooms;
  final int selectedId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    // 모양은 `BottomSheet/Content` type=none 껍데기(손잡이·제목) — 본문 줄·버튼은 없다.
    return Container(
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: c.lineNormal,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.hwClassPickerTitle,
              textAlign: TextAlign.center,
              style: AppType.heading2.sb.copyWith(color: c.labelStrong),
            ),
            const SizedBox(height: AppSpacing.s16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final room in classrooms)
                      _ClassPickerRow(
                        room: room,
                        selected: room.classroomId == selectedId,
                        onTap: () =>
                            Navigator.of(context).pop(room.classroomId),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassPickerRow extends StatelessWidget {
  const _ClassPickerRow({
    required this.room,
    required this.selected,
    required this.onTap,
  });

  final JoinedClassroom room;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final institution = HomeworkClassHeader._clean(room.institution);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s20,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (institution != null) ...[
                      Text(
                        institution,
                        style: AppType.caption1.m.copyWith(color: c.labelNeutral),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                    ],
                    Text(
                      room.name,
                      style: (selected ? AppType.body1.b : AppType.body1.m)
                          .copyWith(color: c.labelStrong),
                    ),
                  ],
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.s8),
                AppIcons.check(size: 20, color: c.primaryNormal),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text, required this.style});

  final Widget icon;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: AppSpacing.s4),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}

/// 「미완료 · 완료」 밑줄 탭(`6677:18163`). 두 칸이 폭을 반씩 나눈다.
///
/// 탭 옆에 개수를 붙이지 않는다(사용자 확정 · 1-4 「넣지 않기로 한 것」).
class HomeworkTabs extends StatelessWidget {
  /// 탭 줄을 만든다.
  const HomeworkTabs({
    super.key,
    required this.labels,
    required this.activeIndex,
    required this.onChanged,
  });

  /// 탭 이름(왼쪽부터).
  final List<String> labels;

  /// 선택된 탭 번호.
  final int activeIndex;

  /// 누른 탭 번호.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return FigmaHalfTabs(
      children: [
        for (var i = 0; i < labels.length; i++)
          Semantics(
            button: true,
            selected: i == activeIndex,
            child: InkWell(
              onTap: () {
                if (i == activeIndex) return;
                HapticFeedback.selectionClick();
                onChanged(i);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s12,
                  horizontal: AppSpacing.s16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == activeIndex ? c.lineStrong : c.lineNeutral,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: (i == activeIndex ? AppType.label1.b : AppType.label1.r)
                      .copyWith(
                        color: i == activeIndex
                            ? c.labelStrong
                            : c.labelAlternative,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 탭 칸을 균등하게 나눈다 — Figma `탭` 두 칸 모두 FILL(`6679:18141`·`6679:18139`).
class FigmaHalfTabs extends StatelessWidget {
  /// 칸들을 받는다.
  const FigmaHalfTabs({super.key, required this.children});

  /// 칸.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // 균등 격자가 시안 의도다 — 「Offen」·「Erledigt」처럼 길이가 달라도 반반을 지킨다.
    return FigmaEqualColumns(
      figmaNode: '6677:18163',
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final w in children) Expanded(child: w)],
        ),
      ),
    );
  }
}

/// 상태 배지 + 달력 아이콘 + 마감일 한 줄(`6679:34185`). 목록 카드와 상세 머리가 같이 쓴다.
class HomeworkDueRow extends StatelessWidget {
  /// 줄을 만든다.
  const HomeworkDueRow({super.key, required this.assignment});

  /// 과제.
  final ClassroomAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Row(
      children: [
        // 배지가 남는 폭을 맡는다 — 좁은 폭·긴 로케일에서는 배지가 말줄임으로 접히고
        // 마감일은 잘리지 않는다(320 · vi·th 실측 넘침).
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: assignmentBadge(context, assignment),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        AppIcons.calendarCheck(size: 16, color: c.labelNeutral),
        const SizedBox(width: AppSpacing.s4),
        Text(
          formatDueDate(assignment.dueAt),
          style: AppType.caption1.r.copyWith(color: c.labelNeutral),
        ),
      ],
    );
  }
}

/// 과제 제목 — 낱말 단위로 줄을 바꾼다.
///
/// Figma 는 글자 단위로 끊겨 보이지만 구현은 keep-all 이다(인계 명세 §2-3). 한글
/// 낱말 사이 공백을 기준으로만 꺾이도록 낱말 안 글자 사이에 줄바꿈 금지 문자를 넣는다.
class HomeworkTitleText extends StatelessWidget {
  /// 제목을 만든다.
  const HomeworkTitleText(this.text, {super.key});

  /// 제목.
  final String text;

  /// 한글 낱말 안의 글자 사이에 U+2060(WORD JOINER)을 끼운다.
  ///
  /// 라틴 글자 낱말은 원래 공백에서만 꺾이므로 건드리지 않는다(「Chapter 09」 그대로).
  static String keepAll(String s) => s
      .split(' ')
      .map((w) => _hangul.hasMatch(w) ? w.characters.join('⁠') : w)
      .join(' ');

  static final RegExp _hangul = RegExp('[ᄀ-ᇿ㄰-㆏가-힯]');

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Text(
      keepAll(text),
      style: AppType.headline1.b.copyWith(color: c.labelStrong),
    );
  }
}

/// 숙제 목록 카드 — 배지·마감일 / 제목 / 활동 아이콘(`6679:34183`).
///
/// 반 이름·`n/N`·화살표는 카드에서 뺐다(2026-10-12 확정).
class HomeworkListCard extends StatelessWidget {
  /// 카드를 만든다.
  const HomeworkListCard({super.key, required this.assignment, this.onTap});

  /// 과제.
  final ClassroomAssignment assignment;

  /// 누르면 상세로.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final a = assignment;
    final radius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: c.backgroundElevatedAlternative,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeworkDueRow(assignment: a),
              const SizedBox(height: AppSpacing.s12),
              HomeworkTitleText(assignmentTitleOf(a, l10n.hwChapterLabel)),
              const SizedBox(height: AppSpacing.s12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < a.activities.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.s12),
                    HomeworkActivityIcon(
                      activity: a.activities[i],
                      // 완료 과제는 전부 Primary(§2-5) — 서버가 done 이라고 했으면 끝난 것이다.
                      done:
                          a.status == AssignmentStatus.done ||
                          activityDone(a, a.activities[i]),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 활동 아이콘 20 — 미수행 `Icon/Assistive` 선 · 수행 `Primary/Normal` 선(채움 없음).
///
/// 아이콘만 있으므로 스크린리더 라벨을 반드시 단다(「발음 완료」).
class HomeworkActivityIcon extends StatelessWidget {
  /// 아이콘을 만든다.
  const HomeworkActivityIcon({
    super.key,
    required this.activity,
    required this.done,
  });

  /// 활동.
  final AssignmentActivity activity;

  /// 끝냈나.
  final bool done;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final color = done ? c.primaryNormal : c.labelAssistive;
    final name = activityLabel(context, activity);
    final icon = switch (activity) {
      // 목록 발음 아이콘은 「말하는 사람」(`6679:34216`) — 상세 카드 머리는 음파 그대로.
      AssignmentActivity.speaking => AppIcons.speak(size: 20, color: color),
      AssignmentActivity.conversation => AppIcons.chat(size: 20, color: color),
      AssignmentActivity.workbook => AppIcons.book(size: 20, color: color),
    };
    return Semantics(
      label: done ? l10n.hwA11yActivityDone(name) : l10n.hwA11yActivityTodo(name),
      excludeSemantics: true,
      child: icon,
    );
  }
}
