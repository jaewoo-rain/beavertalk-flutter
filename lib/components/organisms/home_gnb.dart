import 'package:flutter/material.dart' hide Badge;

import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/badge.dart';
import '../atoms/skeleton.dart';

/// 홈 상단 학습 현황 — Figma `Home/GNB` 컴포넌트 세트 (`5925:26645`).
///
/// 헤더와 히어로 아바타 사이에 서서 **지금 무엇을 배우는 중인지**를 세 줄로
/// 말한다. 종전 홈은 비버 얼굴과 이름만 있어서, 통화를 걸기 전에는 이번 통화가
/// 무슨 단원인지 알 방법이 없었다.
///
/// ```
/// [A1-01] 표현학습                  ← 단원 배지 + 학습 종류
/// 처음 만난 반 친구와 이름과 나라 말하기   ← 주제
/// 자유 회화까지 표현 14개 남음          ← 진행 안내
/// ```
///
/// 변형 3종은 [HomeCourseKind] 가 가른다 — 세트의 `Property 1` 과 1:1이다.
/// 높이 92(패딩 8 + 내용 76)는 세 변형이 모두 같아서, 변형이 바뀌어도 아래
/// 히어로가 움직이지 않는다.
///
/// **좌우 여백을 `ContentColumn` 이 아니라 자체 32로 잡는다.** 정본이 `px-32`
/// 이고(헤더·숙제 배너의 20과 다르다), 세 줄 모두 가운데 정렬이라 넓은 폭에서도
/// 컬럼 밴드에 설 이유가 없다 — 글이 화면 한가운데 서는 편이 맞다.
class HomeGnb extends StatelessWidget {
  /// 학습 현황 블록을 만든다.
  const HomeGnb({super.key, required this.course});

  /// 그릴 내용. 지금은 전부 목이다([MockHomeCourse] 참조).
  final MockHomeCourse course;

  /// 정본 높이. 로딩 스켈레톤([HomeGnbSkeleton])과 같은 값을 써서 데이터가
  /// 늦게 와도 히어로가 튀지 않는다.
  static const double height = 92;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final noLevel = course.kind == HomeCourseKind.noLevel;

    // 2행(주제) — 레벨이 없으면 커리큘럼 위치가 없으니 안내 문구로 바뀐다.
    final title = noLevel ? l10n.homeNoLevelTitle : (course.topic ?? '');

    // 3행 — 변형마다 다른 말을 한다.
    final note = switch (course.kind) {
      HomeCourseKind.expression =>
        l10n.homeExpressionsLeft(course.expressionsLeft ?? 0),
      HomeCourseKind.freetalk => l10n.homeFreetalkNote,
      HomeCourseKind.noLevel => l10n.homeNoLevelNote,
    };

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 1행 — 배지 + 학습 종류 ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Badge(
                  // 레벨이 없으면 단원 코드 대신 상태를 말한다. 중립 톤인 것이
                  // 중요하다 — 민트는 「진행 중인 커리큘럼」의 색이라, 없는
                  // 단원에 쓰면 있는 것처럼 읽힌다.
                  tone: noLevel ? BadgeTone.neutral : BadgeTone.brand,
                  label: noLevel
                      ? l10n.homeLevelPending
                      : (course.unitCode ?? ''),
                ),
                // 레벨 미정에는 오른쪽 라벨이 없다(정본에서 hidden).
                if (!noLevel) ...[
                  const SizedBox(width: AppSpacing.s8),
                  Flexible(
                    child: Text(
                      course.kind == HomeCourseKind.freetalk
                          ? l10n.homeCourseFreetalk
                          : l10n.homeCourseExpression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.caption1.b
                          .copyWith(color: c.primaryNormal),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            // ── 2행 — 주제 ─────────────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.label2.b.copyWith(color: c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s8),
            // ── 3행 — 진행 안내 ────────────────────────────────────
            Text(
              note,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption1.r.copyWith(color: c.labelAlternative),
            ),
          ],
        ),
      ),
    );
  }
}

/// [HomeGnb] 의 로딩 자리표시 — Figma `skeleton/HomeGNB` (`5930:9109`).
///
/// 폭(55·46·215·151)과 높이(26·16·18·16)를 정본 그대로 쓴다. 실제 문구 길이와
/// 무관한 고정값이라, 데이터가 오면 자리가 바뀌긴 하지만 **블록 높이는 92로
/// 같아서** 히어로와 숙제 배너는 움직이지 않는다.
class HomeGnbSkeleton extends StatelessWidget {
  /// 자리표시를 만든다.
  const HomeGnbSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeGnb.height,
      child: SkeletonShimmer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeleton.pill(width: 55, height: 26),
                SizedBox(width: AppSpacing.s8),
                Skeleton.bar(width: 46, height: 16),
              ],
            ),
            SizedBox(height: AppSpacing.s8),
            Skeleton.bar(width: 215, height: 18),
            SizedBox(height: AppSpacing.s8),
            Skeleton.bar(width: 151, height: 16),
          ],
        ),
      ),
    );
  }
}
