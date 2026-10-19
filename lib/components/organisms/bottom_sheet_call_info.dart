import 'dart:math' as math;

import '../chrome/sheet_bottom_inset.dart';
import 'package:flutter/material.dart';

import '../../features/normalcall/domain/entities/cur_me.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

// Figma 10·44·56 은 AppSpacing 토큰이 없다(Spacing/10 은 Figma 변수뿐) — 아래 상수로 둔다.
const double _s10 = 10;
const double _s44 = 44;
const double _s56 = 56;

/// 통화 i 안내 시트의 변형 — Figma `BottomSheet/CallInfo`(`6786:2244`) type 6종 중 탭을 뺀 5종.
///
/// 「차시 목록」(`type=lessons`)은 표현학습·회화학습 시트의 둘째 탭이다.
enum CallInfoType {
  /// 표현학습 — 이번 대화 | 차시 목록 · 제목(주제) · 표현 행.
  expression,

  /// 회화학습 — 이번 대화 | 차시 목록 · 제목(주제) · 상황·상대·나 행.
  conversation,

  /// 숙제 · 표현학습 — 탭 없음 · 과제 제목 · 표현 행.
  homework,

  /// 숙제 · 역할극 — 탭 없음 · 과제 제목 · 상황·상대·나 행.
  roleplay,

  /// 자유대화 — 탭·제목 없음 · `Card/FreeTalk`.
  free,
}

/// 표현 행 하나 — 굵은 표현 · 회색 뜻 · TTS.
class CallInfoExpression {
  const CallInfoExpression({required this.id, required this.surface, this.meaning});

  /// 소리를 부를 때 쓰는 id(차시 항목 id 또는 과제 항목 id).
  final int id;
  final String surface;

  /// 뜻 한 줄. 없으면 뜻 줄을 숨긴다.
  final String? meaning;
}

/// 통화 i 안내 시트 — Figma `04_통화` 정본(PM-DEC-760·780·785·793·794).
///
/// 맨 위 줄(손잡이 + 닫기)만 남긴 최소안이다. 닫기·딤 탭·아래로 내리기로 닫히고 통화는 계속된다.
/// 번역 줄은 값이 있을 때만 그린다 — 서버가 ko 회원에게는 번역을 주지 않으므로 ko 회원은 번역 줄이 없다.
class BottomSheetCallInfo extends StatefulWidget {
  const BottomSheetCallInfo({
    super.key,
    required this.type,
    this.title,
    this.titleTranslation,
    this.expressions,
    this.expressionsError = false,
    this.onPlay,
    this.situation,
    this.situationTranslation,
    this.partner,
    this.partnerTranslation,
    this.partnerImage,
    this.me,
    this.meTranslation,
    this.levelNo = 0,
    this.currentNo = 0,
    this.lessons,
    this.lessonsError = false,
    this.initialTab = 0,
  });

  final CallInfoType type;

  /// 제목(주제 · 과제 제목). 자유대화는 쓰지 않는다.
  final String? title;

  /// 제목 번역. 숙제는 넘기지 않는다(번역 줄 없음).
  final String? titleTranslation;

  /// 표현 행. null = 불러오는 중.
  final List<CallInfoExpression>? expressions;
  final bool expressionsError;

  /// 표현 소리. 실패(예외)하면 그 행의 버튼을 비활성으로 둔다 — 숨기지 않는다(PM-DEC-796).
  final Future<void> Function(CallInfoExpression)? onPlay;

  final String? situation;
  final String? situationTranslation;
  final String? partner;
  final String? partnerTranslation;
  final ImageProvider? partnerImage;
  final String? me;
  final String? meTranslation;

  /// 차시 목록 탭 — 레벨 · 지금 차시 · 그 레벨 목록(null = 불러오는 중).
  final int levelNo;
  final int currentNo;
  final List<CurLessonRow>? lessons;
  final bool lessonsError;

  /// 0 = 이번 대화 · 1 = 차시 목록(탭이 있는 변형만).
  final int initialTab;

  bool get hasTabs => type == CallInfoType.expression || type == CallInfoType.conversation;

  @override
  State<BottomSheetCallInfo> createState() => _BottomSheetCallInfoState();
}

/// 시트 최대 높이(Figma 612) · 차시 목록 탭은 이 높이로 고정.
const double kCallInfoSheetMaxHeight = 612;

/// 맨 위 줄 높이(손잡이 + 닫기).
const double _topBarHeight = 44;

class _BottomSheetCallInfoState extends State<BottomSheetCallInfo> {
  late int _tab = widget.hasTabs ? widget.initialTab : 0;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final screenH = MediaQuery.sizeOf(context).height;
    final maxH = math.min(kCallInfoSheetMaxHeight, screenH * 0.9);
    final lessonsTab = widget.hasTabs && _tab == 1;
    final body = Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.s20, AppSpacing.s4, AppSpacing.s20, 0),
      child: Column(
        mainAxisSize: lessonsTab ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.hasTabs) ...[
            _Tabs(selected: _tab, onSelect: (i) => setState(() => _tab = i)),
            const SizedBox(height: AppSpacing.s16),
          ],
          if (lessonsTab)
            Expanded(
              child: _LessonsTab(
                levelNo: widget.levelNo,
                currentNo: widget.currentNo,
                lessons: widget.lessons,
                error: widget.lessonsError,
              ),
            )
          else
            Flexible(child: SingleChildScrollView(child: _content(context))),
        ],
      ),
    );
    return Container(
      width: double.infinity,
      height: lessonsTab ? maxH : null,
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.s20)),
      ),
      // 아래 = max(34, OS 인셋) — 3버튼 내비(48)에서 행이 내비 뒤로 숨지 않게(PM-DEC-798).
      padding: EdgeInsets.only(top: AppSpacing.s4, bottom: SheetBottomInset.of(context)),
      child: Column(
        mainAxisSize: lessonsTab ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TopBar(),
          if (lessonsTab) Expanded(child: body) else Flexible(child: body),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final w = widget;
    switch (w.type) {
      case CallInfoType.free:
        return const _FreeTalkCard();
      case CallInfoType.expression:
      case CallInfoType.homework:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Title(title: w.title, translation: w.titleTranslation),
            const SizedBox(height: AppSpacing.s16),
            _ExpressionsCard(items: w.expressions, error: w.expressionsError, onPlay: w.onPlay),
          ],
        );
      case CallInfoType.conversation:
      case CallInfoType.roleplay:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Title(title: w.title, translation: w.titleTranslation),
            const SizedBox(height: AppSpacing.s16),
            _RolesCard(
              situation: w.situation,
              situationTranslation: w.situationTranslation,
              partner: w.partner,
              partnerTranslation: w.partnerTranslation,
              partnerImage: w.partnerImage,
              me: w.me,
              meTranslation: w.meTranslation,
            ),
          ],
        );
    }
  }
}

/// `Sheet/TopBar` — 손잡이 36×4(가운데 · y 8) + 닫기 X 28(44 터치 · 오른쪽 12).
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SizedBox(
      height: _topBarHeight,
      child: Stack(
        children: [
          Positioned(
            top: AppSpacing.s8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: c.backgroundElevatedNormal,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            end: AppSpacing.s12,
            child: Semantics(
              button: true,
              label: MaterialLocalizations.of(context).closeButtonLabel,
              child: InkResponse(
                radius: 22,
                onTap: () => Navigator.of(context).maybePop(),
                child: SizedBox(
                  width: _topBarHeight,
                  height: _topBarHeight,
                  child: Center(child: AppIcons.close(size: 28, color: c.labelStrong)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `Sheet/Tabs` — 2칸 균등 · 선택 굵게 + 밑줄 2.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        for (final (i, label) in [l10n.callHintTabConversation, l10n.callHintTabLessons].indexed)
          Expanded(child: _Tab(label: label, selected: selected == i, onTap: () => onSelect(i))),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (selected ? AppType.body2.b : AppType.body2.r)
                  .copyWith(color: selected ? c.labelStrong : c.labelAlternative),
            ),
            const SizedBox(height: _s10),
            Container(height: 2, color: selected ? c.labelStrong : c.lineAlternative),
          ],
        ),
      ),
    );
  }
}

/// `Sheet/Title` — 제목 16 + 번역 14(있을 때만) · 좌우 4.
class _Title extends StatelessWidget {
  const _Title({required this.title, required this.translation});

  final String? title;
  final String? translation;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = translation;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppType.body1.m.copyWith(color: c.labelStrong),
          ),
          if (t != null && t != title) ...[
            const SizedBox(height: AppSpacing.s4),
            Text(
              t,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppType.label1.r.copyWith(color: c.labelNeutral),
            ),
          ],
        ],
      ),
    );
  }
}

/// 흰 카드 + 행 사이 1px 구분선(`Card/Expressions`).
class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, w) in children.indexed) ...[
            if (i > 0) Container(height: 1, color: c.lineNeutral),
            w,
          ],
        ],
      ),
    );
  }
}

/// 행 글자 묶음 — 값 14 Medium + 번역 12(있을 때만) · 각 최대 2줄.
class _RowText extends StatelessWidget {
  const _RowText({required this.value, this.translation, this.valueStyle});

  final String value;
  final String? translation;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = translation;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: valueStyle ?? AppType.label1.m.copyWith(color: c.labelStrong),
        ),
        if (t != null && t.isNotEmpty && t != value) ...[
          const SizedBox(height: AppSpacing.s2),
          Text(
            t,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppType.caption1.r.copyWith(color: c.labelNeutral),
          ),
        ],
      ],
    );
  }
}

class _ExpressionsCard extends StatefulWidget {
  const _ExpressionsCard({required this.items, required this.error, required this.onPlay});

  final List<CallInfoExpression>? items;
  final bool error;
  final Future<void> Function(CallInfoExpression)? onPlay;

  @override
  State<_ExpressionsCard> createState() => _ExpressionsCardState();
}

class _ExpressionsCardState extends State<_ExpressionsCard> {
  /// 소리를 못 받은 행 — 버튼을 비활성으로 둔다(숨기지 않는다).
  final Set<int> _failed = {};
  int? _playing;

  Future<void> _play(CallInfoExpression e) async {
    final onPlay = widget.onPlay;
    if (onPlay == null || _playing != null) return;
    setState(() => _playing = e.id);
    try {
      await onPlay(e);
    } catch (_) {
      // 소리 실패는 그 행만 비활성 — 시트·통화는 그대로(PM-DEC-796).
      if (mounted) setState(() => _failed.add(e.id));
    } finally {
      if (mounted) setState(() => _playing = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final items = widget.items;
    if (widget.error || items == null) {
      return _Card(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
          child: Center(
            child: widget.error
                ? Text(
                    AppLocalizations.of(context).callHintLessonsLoadError,
                    textAlign: TextAlign.center,
                    style: AppType.label1.r.copyWith(color: c.labelNeutral),
                  )
                : const SizedBox(
                    width: AppSpacing.s24,
                    height: AppSpacing.s24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
        ),
      ]);
    }
    return _Card(children: [
      for (final e in items)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: _s10),
          child: Row(
            children: [
              Expanded(child: _RowText(value: e.surface, translation: e.meaning)),
              const SizedBox(width: AppSpacing.s8),
              _TtsButton(
                enabled: widget.onPlay != null && !_failed.contains(e.id),
                busy: _playing == e.id,
                // 행 글자와 겹치지 않게 「표준 발음 듣기」 + 표현(화면 낭독기가 버튼임을 알게).
                semanticLabel: '${AppLocalizations.of(context).listenStandard} ${e.surface}',
                onTap: () => _play(e),
              ),
            ],
          ),
        ),
    ]);
  }
}

/// 표현 행 TTS — 44 터치 · 원 32(선 `Line/Neutral`) · `volume` 20.
class _TtsButton extends StatelessWidget {
  const _TtsButton({required this.enabled, required this.busy, required this.semanticLabel, required this.onTap});

  final bool enabled;
  final bool busy;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: InkResponse(
        radius: 22,
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: _s44,
          height: _s44,
          child: Center(
            child: Container(
              width: AppSpacing.s32,
              height: AppSpacing.s32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.lineNeutral),
              ),
              alignment: Alignment.center,
              child: AppIcons.volume(
                size: AppSpacing.s20,
                color: !enabled
                    ? c.labelDisabled
                    : busy
                        ? c.labelAlternative
                        : c.labelStrong,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 상황 · 상대 · 나 행 카드(회화학습·역할극 숙제) — 라벨 없음.
class _RolesCard extends StatelessWidget {
  const _RolesCard({
    required this.situation,
    required this.situationTranslation,
    required this.partner,
    required this.partnerTranslation,
    required this.partnerImage,
    required this.me,
    required this.meTranslation,
  });

  final String? situation;
  final String? situationTranslation;
  final String? partner;
  final String? partnerTranslation;
  final ImageProvider? partnerImage;
  final String? me;
  final String? meTranslation;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final s = situation;
    final p = partner;
    final m = me;
    return _Card(children: [
      if (s != null && s.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: _s10),
          child: _RowText(value: s, translation: situationTranslation),
        ),
      if (p != null && p.isNotEmpty)
        _AvatarRow(
          avatar: Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.fillNormal,
              image: partnerImage == null ? null : DecorationImage(image: partnerImage!, fit: BoxFit.cover),
            ),
          ),
          value: p,
          translation: partnerTranslation,
        ),
      if (m != null && m.isNotEmpty)
        _AvatarRow(
          avatar: Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c.fillNormal),
            alignment: Alignment.center,
            child: AppIcons.user(size: AppSpacing.s20, color: c.labelNormal),
          ),
          value: m,
          translation: meTranslation,
        ),
    ]);
  }
}

class _AvatarRow extends StatelessWidget {
  const _AvatarRow({required this.avatar, required this.value, required this.translation});

  final Widget avatar;
  final String value;
  final String? translation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _s10),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: AppSpacing.s12),
          Expanded(child: _RowText(value: value, translation: translation)),
        ],
      ),
    );
  }
}

/// `Card/FreeTalk` — 아이콘 원 56 + 라벨 + 문구 · 가운데 정렬.
class _FreeTalkCard extends StatelessWidget {
  const _FreeTalkCard();

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _s56,
            height: _s56,
            decoration: BoxDecoration(shape: BoxShape.circle, color: c.fillNormal),
            alignment: Alignment.center,
            child: AppIcons.chat(size: AppSpacing.s24, color: c.labelStrong),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            l10n.callModeFreeTalk,
            textAlign: TextAlign.center,
            style: AppType.caption1.r.copyWith(color: c.labelNeutral),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            l10n.callInfoFreeTalkBody,
            textAlign: TextAlign.center,
            style: AppType.label1.m.copyWith(color: c.labelStrong),
          ),
        ],
      ),
    );
  }
}

/// 차시 목록 탭 — 레벨 + 차시 행 카드(지금 차시만 강조 · 배지 없음) · 본문 스크롤.
class _LessonsTab extends StatefulWidget {
  const _LessonsTab({required this.levelNo, required this.currentNo, required this.lessons, required this.error});

  final int levelNo;
  final int currentNo;
  final List<CurLessonRow>? lessons;
  final bool error;

  @override
  State<_LessonsTab> createState() => _LessonsTabState();
}

/// 차시 행 최소 높이(위아래 10 + 한 줄 20 + 구분선 1).
const double _lessonRowMin = 41;

class _LessonsTabState extends State<_LessonsTab> {
  ScrollController? _scroll;

  /// 열 때 지금 차시가 보이게 — 그 줄을 위에서 몇 줄 아래에 둔다(줄 높이 41 가정).
  ScrollController _controllerFor(List<CurLessonRow> rows) {
    final existing = _scroll;
    if (existing != null) return existing;
    final i = rows.indexWhere((r) => r.no == widget.currentNo);
    final offset = i <= 2 ? 0.0 : (i - 2) * _lessonRowMin;
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
          style: AppType.label1.r.copyWith(color: c.labelNeutral),
        ),
      );
    } else if (rows == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = Container(
        decoration: BoxDecoration(
          color: c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          controller: _controllerFor(rows),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
          itemCount: rows.length,
          separatorBuilder: (_, _) => Container(height: 1, color: c.lineNeutral),
          itemBuilder: (context, i) => _LessonRow(row: rows[i], current: rows[i].no == widget.currentNo),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          child: Text(
            cefrLabelForLevel(widget.levelNo) ?? l10n.callHintLevelSurvival,
            style: AppType.body1.m.copyWith(color: c.labelStrong),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Expanded(child: body),
      ],
    );
  }
}

/// `Row/CallInfo` type=lesson | lesson-current — 번호 원 24 · 지금 차시만 번호 강조 + 값 Medium.
class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.row, required this.current});

  final CurLessonRow row;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = row.situationTranslation;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _s10),
      child: Row(
        children: [
          // 번호는 DB 전체 순번(491 까지) — 원 24 를 최소로 두고 길면 가로로 늘어나는 알약.
          Container(
            constraints: const BoxConstraints(minWidth: AppSpacing.s24, minHeight: AppSpacing.s24),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              color: current ? c.primaryNormal10 : c.fillNormal,
            ),
            alignment: Alignment.center,
            child: Text(
              '${row.no}',
              style: (current ? AppType.caption1.b : AppType.caption1.m)
                  .copyWith(color: current ? c.primaryForeground : c.labelAlternative),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: _RowText(
              value: row.situation ?? '',
              translation: (t == null || t == row.situation) ? null : t,
              valueStyle: (current ? AppType.label1.m : AppType.label1.r).copyWith(color: c.labelStrong),
            ),
          ),
        ],
      ),
    );
  }
}
