import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/normalcall/domain/entities/cur_me.dart';
import '../../features/normalcall/domain/entities/homework_roleplay.dart';
import '../icons/app_icons.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../layout/need_based_rows.dart';

/// 회화학습 힌트 시트 — Figma `BottomSheet/CallLessonHint`(`6619:55429`).
///
/// 회화학습(`CallCourse.freetalk`) 통화에서 힌트 버튼을 누르면 뜬다. 문장 힌트 카드는 띄우지 않는다
/// (사용자 10-10 「회화학습에서는 시트만 띄우자」). 탭 두 개:
///
/// - 「이번 대화」(`tab=conversation` · 304) — 상황 카드 + 상대 줄(`Row/Role` who=partner). 「나」 칸 없음.
/// - 「차시 목록」(`tab=lessons` · 592) — 레벨명 + 차시 줄(`Row/Lesson`), 현재 차시만 강조.
///
/// 상대 줄은 [partner] 가 없으면(구서버 · 빈 차시) 통째로 숨긴다. 번역 줄도 없으면 숨긴다.
class BottomSheetCallLessonHint extends StatefulWidget {
  const BottomSheetCallLessonHint({
    super.key,
    required this.situation,
    required this.situationTranslation,
    required this.partner,
    required this.partnerTranslation,
    required this.partnerImage,
    required this.levelNo,
    required this.currentNo,
    required this.lessons,
    this.lessonsError = false,
    this.initialTab = 0,
  });

  final String? situation;
  final String? situationTranslation;
  final String? partner;
  final String? partnerTranslation;

  /// 통화 중 캐릭터 얼굴. 아직 모르면 null → 빈 원.
  final ImageProvider? partnerImage;

  /// 현재 차시 레벨(`level_no`) — 머리줄 레벨명.
  final int levelNo;

  /// 현재 차시 번호(`cur_lesson.no`) — 그 줄만 강조한다.
  final int currentNo;

  /// 그 레벨 차시 목록. null = 불러오는 중.
  final List<CurLessonRow>? lessons;

  /// 차시 목록을 못 불러왔다.
  final bool lessonsError;

  /// 0 = 이번 대화 · 1 = 차시 목록.
  final int initialTab;

  @override
  State<BottomSheetCallLessonHint> createState() =>
      _BottomSheetCallLessonHintState();
}

/// Figma 차시 목록 보기 영역 높이.
const double _lessonsViewport = 440;

/// 차시 줄 최소 높이(위아래 패딩 12 + 한 줄).
const double _lessonRowHeight = AppSpacing.s48;

class _BottomSheetCallLessonHintState extends State<BottomSheetCallLessonHint> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    // 작은 화면에서는 목록 칸을 줄인다 — 시트 머리(손잡이·탭·레벨줄 ≈ 152)와 아래 34 를 빼고 남는 만큼.
    final screenH = MediaQuery.sizeOf(context).height;
    final viewport = math.max(
      _lessonRowHeight * 3,
      math.min(_lessonsViewport, screenH * 0.9 - 186),
    );
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.s20),
        ),
      ),
      padding: const EdgeInsets.only(
        bottom: 34,
      ), // Figma 아래 34(AppSpacing 토큰 없음)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              // `Sheet/Handle` = `Background/Elevated/Normal`(변수 실측 · 10-10).
              decoration: BoxDecoration(
                color: c.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FigmaEqualColumns(
                  figmaNode: '6619:55347',
                  child: Row(
                    children: [
                      Expanded(
                        child: _Tab(
                          label: l10n.callHintTabConversation,
                          selected: _tab == 0,
                          onTap: () => setState(() => _tab = 0),
                        ),
                      ),
                      Expanded(
                        child: _Tab(
                          label: l10n.callHintTabLessons,
                          selected: _tab == 1,
                          onTap: () => setState(() => _tab = 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                if (_tab == 0)
                  _ConversationTab(
                    situation: widget.situation,
                    situationTranslation: widget.situationTranslation,
                    partner: widget.partner,
                    partnerTranslation: widget.partnerTranslation,
                    partnerImage: widget.partnerImage,
                  )
                else
                  _LessonsTab(
                    levelNo: widget.levelNo,
                    currentNo: widget.currentNo,
                    lessons: widget.lessons,
                    error: widget.lessonsError,
                    viewport: viewport,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 역할극 숙제 통화 i 안내 시트 — Figma ko `6737:17682` · en `6737:18101`(PM-DEC-623 A안).
///
/// 회화학습 힌트 시트의 「이번 대화」 칸을 탭 없이 그대로 쓰고 「나」 줄을 더한다. 버튼은 없고
/// 딤 탭·아래로 내리기로 닫는다. 값은 교사가 쓴 한국어 원문, 번역 줄은 있을 때만 보인다.
class BottomSheetCallRoleplayInfo extends StatelessWidget {
  const BottomSheetCallRoleplayInfo({
    super.key,
    required this.roleplay,
    required this.partnerName,
    required this.partnerImage,
  });

  final HomeworkRoleplay roleplay;

  /// 상대 줄 라벨 — 통화 상대 캐릭터 이름(GNB 이름과 같은 값). 없으면 「상대」.
  final String? partnerName;

  final ImageProvider? partnerImage;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final name = partnerName?.trim();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.s20),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 34), // 힌트 시트와 같음
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: _ConversationTab(
              situation: roleplay.scene,
              situationTranslation: roleplay.situationTranslation,
              partner: roleplay.aiRole,
              partnerTranslation: roleplay.aiRoleTranslation,
              partnerImage: partnerImage,
              partnerLabel: (name == null || name.isEmpty) ? null : name,
              me: roleplay.learnerRole,
              meTranslation: roleplay.learnerRoleTranslation,
              meLabel: l10n.callRoleplayMe,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppType.body2.b.copyWith(
                color: selected ? c.labelStrong : c.labelAlternative,
              ),
            ),
            // Figma 글자 22 → 선 위쪽 32: 사이 10(AppSpacing 토큰 없음).
            const SizedBox(height: 10),
            Container(
              height: 2,
              color: selected ? c.labelStrong : c.lineAlternative,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTab extends StatelessWidget {
  const _ConversationTab({
    required this.situation,
    required this.situationTranslation,
    required this.partner,
    required this.partnerTranslation,
    required this.partnerImage,
    this.partnerLabel,
    this.me,
    this.meTranslation,
    this.meLabel,
  });

  final String? situation;
  final String? situationTranslation;
  final String? partner;
  final String? partnerTranslation;
  final ImageProvider? partnerImage;

  /// 상대 줄 라벨. null 이면 「상대」(회화학습 힌트).
  final String? partnerLabel;

  /// 「나」 줄(`Row/Role` who=me) — 역할극 숙제 안내에서만. 값이 없으면 줄째 숨긴다.
  final String? me;
  final String? meTranslation;
  final String? meLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 상황 카드(`Card/Situation`) ──
        Container(
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            color: c.backgroundElevatedAlternative,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.callHintSituation,
                style: AppType.caption1.m.copyWith(color: c.labelAlternative),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                situation ?? '',
                style: AppType.label1.m.copyWith(color: c.labelStrong),
              ),
              if (situationTranslation != null) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(
                  situationTranslation!,
                  style: AppType.caption1.r.copyWith(color: c.labelNeutral),
                ),
              ],
            ],
          ),
        ),
        // ── 상대 줄(`Row/Role` who=partner) — 상대역이 없으면 숨긴다 ──
        if (partner != null) ...[
          const SizedBox(height: AppSpacing.s16),
          _RoleRow(
            avatar: Container(
              width: AppSpacing.s40,
              height: AppSpacing.s40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.fillNormal,
                image: partnerImage == null
                    ? null
                    : DecorationImage(
                        image: partnerImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            label: partnerLabel ?? l10n.callHintPartner,
            value: partner!,
            translation: partnerTranslation,
          ),
        ],
        // ── 나 줄(`Row/Role` who=me) — 역할극 숙제 안내에서만 · 값이 없으면 숨긴다 ──
        if (me != null) ...[
          const SizedBox(height: AppSpacing.s16),
          _RoleRow(
            avatar: Container(
              width: AppSpacing.s40,
              height: AppSpacing.s40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.fillNormal,
              ),
              alignment: Alignment.center,
              child: AppIcons.user(size: AppSpacing.s20, color: c.labelNormal),
            ),
            label: meLabel ?? '',
            value: me!,
            translation: meTranslation,
          ),
        ],
      ],
    );
  }
}

/// `Row/Role` — 사진 40 + 라벨 · 값 · 번역(있을 때만).
class _RoleRow extends StatelessWidget {
  const _RoleRow({
    required this.avatar,
    required this.label,
    required this.value,
    required this.translation,
  });

  final Widget avatar;
  final String label;
  final String value;
  final String? translation;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s12,
        horizontal: AppSpacing.s16,
      ),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppType.caption1.r.copyWith(color: c.labelAlternative),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  value,
                  style: AppType.label1.m.copyWith(color: c.labelStrong),
                ),
                if (translation != null) ...[
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    translation!,
                    style: AppType.caption1.r.copyWith(color: c.labelNeutral),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonsTab extends StatefulWidget {
  const _LessonsTab({
    required this.levelNo,
    required this.currentNo,
    required this.lessons,
    required this.error,
    required this.viewport,
  });

  final int levelNo;
  final int currentNo;
  final List<CurLessonRow>? lessons;
  final bool error;
  final double viewport;

  @override
  State<_LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<_LessonsTab> {
  ScrollController? _scroll;

  /// 열 때 현재 차시가 보이게 — 그 줄을 보기 영역 가운데쯤에 둔다(줄 높이 48 가정).
  ScrollController _controllerFor(List<CurLessonRow> rows) {
    final existing = _scroll;
    if (existing != null) return existing;
    final i = rows.indexWhere((r) => r.no == widget.currentNo);
    final offset = i <= 0
        ? 0.0
        : math.max(
            0.0,
            i * _lessonRowHeight - (widget.viewport - _lessonRowHeight) / 2,
          );
    return _scroll = ScrollController(initialScrollOffset: offset);
  }

  @override
  void dispose() {
    _scroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final rows = widget.lessons;
    final Widget body;
    if (widget.error) {
      body = Center(
        child: Text(
          l10n.callHintLessonsLoadError,
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: c.labelNeutral),
        ),
      );
    } else if (rows == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        controller: _controllerFor(rows),
        padding: EdgeInsets.zero,
        itemCount: rows.length,
        itemBuilder: (context, i) =>
            _LessonRow(row: rows[i], current: rows[i].no == widget.currentNo),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          cefrLabelForLevel(widget.levelNo) ?? l10n.callHintLevelSurvival,
          style: AppType.label1.b.copyWith(color: c.labelStrong),
        ),
        const SizedBox(height: AppSpacing.s16),
        SizedBox(height: widget.viewport, child: body),
      ],
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.row, required this.current});

  final CurLessonRow row;
  final bool current;

  static String? _translation(CurLessonRow row) {
    final t = row.situationTranslation;
    return (t == null || t == row.situation) ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _lessonRowHeight),
      child: Padding(
        // Figma 한 줄 줄은 위아래 12 · 두 줄(44)은 2 — 최소 높이 48 이 한 줄을 받친다.
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
        child: Row(
          children: [
            // 원 24(Figma 한 자리 번호). 번호는 DB 전체 순번이라 491 까지 간다 — 원 안에서 잘리지
            // 않게 최소 24 로 두고 길면 가로로 늘어나는 알약이 된다(i18n_clip_test · 10-10).
            Container(
              constraints: const BoxConstraints(
                minWidth: AppSpacing.s24,
                minHeight: AppSpacing.s24,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                color: current ? c.primaryNormal10 : c.fillNormal,
              ),
              alignment: Alignment.center,
              child: Text(
                '${row.no}',
                style: (current ? AppType.caption1.b : AppType.caption1.m)
                    .copyWith(
                      color: current ? c.primaryForeground : c.labelAlternative,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    row.situation ?? '',
                    style: (current ? AppType.body2.b : AppType.body2.r)
                        .copyWith(
                      color: current ? c.labelStrong : c.labelNeutral,
                    ),
                  ),
                  // 서버 R2(2026-10-16 PM-DEC-674) — 회원 모국어 번역. 없거나 원문과 같으면(ko 회원) 줄을 숨긴다.
                  if (_translation(row) case final t?) ...[
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      t,
                      style:
                          AppType.caption1.r.copyWith(color: c.labelAlternative),
                    ),
                  ],
                ],
              ),
            ),
            if (current) ...[
              const SizedBox(width: AppSpacing.s12),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 3, // Figma 3(AppSpacing 토큰 없음)
                  horizontal: AppSpacing.s8,
                ),
                decoration: BoxDecoration(
                  color: c.primaryNormal10,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  l10n.callHintNowBadge,
                  style: AppType.caption1.b.copyWith(
                    color: c.primaryForeground,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
