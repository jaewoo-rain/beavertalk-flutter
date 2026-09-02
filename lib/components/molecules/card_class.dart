import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/homework_chip.dart';
import '../icons/app_icons.dart';
import 'homework_progress_ring.dart';

/// 마이페이지의 수업 카드 — Figma `숙제/ClassCard`(`5670:5235`) 실측.
///
/// r**8** · 패딩 20/20/24/20 · 간격 16 · `Background/Elevated/Alternative`.
/// 형제 카드(`Dialog-ShareProfile`)를 따라간 값이라 숙제 카드들의 r12 와 다르다
/// — 의도된 차이다.
///
/// 두 모습이 있다. 참여 전([CardClass.empty])은 아이콘 + 안내 + 「참여 코드
/// 입력」, 참여 중([CardClass.active])은 진행 링 + 챕터 + 칩 + 「이어서 하기」다.
class CardClass extends StatelessWidget {
  /// 참여 전 — 반이 없다.
  const CardClass.empty({
    super.key,
    required this.headerLabel,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.ctaLabel,
    this.onCta,
  }) : institution = null,
       badge = null,
       chapterLabel = null,
       chapterTitle = null,
       chips = const [],
       completed = 0,
       total = 0;

  /// 참여 중 — 진행 중인 숙제를 보여준다.
  const CardClass.active({
    super.key,
    required this.headerLabel,
    required this.institution,
    required this.badge,
    required this.chapterLabel,
    required this.chapterTitle,
    required this.chips,
    required this.completed,
    required this.total,
    required this.ctaLabel,
    this.onCta,
  }) : emptyTitle = null,
       emptySubtitle = null;

  /// 카드 머리말(`나의 수업`). 민트로 그린다.
  final String headerLabel;

  /// 기관명. 참여 중일 때만 오른쪽에 붙는다.
  final String? institution;

  /// 마감 배지.
  final Widget? badge;

  /// 챕터 표기.
  final String? chapterLabel;

  /// 챕터 이름.
  final String? chapterTitle;

  /// 활동 칩.
  final List<HomeworkChip> chips;

  /// 끝낸 활동 수.
  final int completed;

  /// 전체 활동 수.
  final int total;

  /// 참여 전 제목.
  final String? emptyTitle;

  /// 참여 전 안내.
  final String? emptySubtitle;

  /// CTA 문안.
  final String ctaLabel;

  /// CTA 탭.
  final VoidCallback? onCta;

  /// 참여 전 상태인지.
  bool get _isEmpty => emptyTitle != null;

  @override
  Widget build(BuildContext context) {
    final c = context.c;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s20,
        AppSpacing.s20,
        AppSpacing.s24,
      ),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                headerLabel,
                style: AppType.label1.m.copyWith(color: c.primaryForeground),
              ),
              if (institution != null)
                Flexible(
                  child: Text(
                    institution!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppType.label2.r.copyWith(color: c.labelNeutral),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          if (_isEmpty) _emptyBody(context) else _activeBody(context),
          const SizedBox(height: AppSpacing.s16),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: ctaLabel,
            onPressed: onCta,
          ),
        ],
      ),
    );
  }

  /// 참여 전 — 58 원형 아이콘 + 두 줄 안내.
  Widget _emptyBody(BuildContext context) {
    final c = context.c;
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.fillNormal,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: AppIcons.plus(size: 24, color: c.labelAlternative),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emptyTitle!,
                style: AppType.body2.r.copyWith(color: c.labelStrong),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                emptySubtitle!,
                style: AppType.label2.r.copyWith(color: c.labelNeutral),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 참여 중 — 진행 링 + 배지 + 챕터 + 칩.
  Widget _activeBody(BuildContext context) {
    final c = context.c;
    return Column(
      children: [
        HomeworkProgressRing(completed: completed, total: total),
        const SizedBox(height: AppSpacing.s12),
        if (badge != null) ...[badge!, const SizedBox(height: 10)],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (chapterLabel != null)
              Flexible(
                child: Text(
                  chapterLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body2.m.copyWith(color: c.labelStrong),
                ),
              ),
            if (chapterLabel != null && chapterTitle != null)
              const SizedBox(width: AppSpacing.s8),
            if (chapterTitle != null)
              Flexible(
                child: Text(
                  chapterTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body2.m.copyWith(color: c.labelStrong),
                ),
              ),
          ],
        ),
        if (chips.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final (i, chip) in chips.take(4).indexed) ...[
                if (i > 0) const SizedBox(width: AppSpacing.s4),
                chip,
              ],
            ],
          ),
        ],
      ],
    );
  }
}
