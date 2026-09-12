import 'package:flutter/material.dart' hide Badge;

import '../../features/normalcall/domain/entities/call_course.dart';
import '../../features/normalcall/domain/entities/cur_me.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/badge.dart';
import '../atoms/skeleton.dart';

/// 홈 상단이 무엇을 안내하고 있는가 — Figma 컴포넌트 세트 `Home/GNB` 의
/// `Property 1` 변형 3종에 1:1 대응한다.
enum HomeCourseKind {
  /// `GNB/표현학습` — 단원 배지 + 주제 + 「자유 회화까지 표현 N개 남음」.
  expression,

  /// `GNB/자유회화` — 단원 배지 + 주제 + 「배운 표현을 바탕으로…」.
  ///
  /// 표현을 다 익혀 카운트다운이 끝난 상태다. 배지·주제 줄은 표현학습과 같고
  /// 셋째 줄만 안내로 바뀐다.
  freetalk,

  /// `GNB/레벨미정` — 중립 배지 「레벨 미정」 + 「아직 레벨이 없어요」.
  ///
  /// 단원도 주제도 없다. 레벨이 정해지기 전에는 커리큘럼 위치 자체가 없어서다.
  noLevel,
}

/// [HomeGnb] 가 그리는 한 덩어리 — 서버 [CurMe] 의 화면용 축약.
///
/// 엔티티를 그대로 받지 않는 이유는 **변형 판정을 한 곳에 모으기 위해서**다.
/// 「레벨이 없다」는 `CurMe` 에 필드로 오지 않고 *차시가 비어 있는 것*으로만
/// 드러나는데(아래 [HomeCourse.fromCurMe] 참조), 그 해석이 위젯 빌드 안에
/// 흩어지면 세 줄이 각자 다른 판단을 하게 된다.
class HomeCourse {
  /// 학습 현황을 만든다.
  const HomeCourse({
    required this.kind,
    this.unitCode,
    this.topic,
    this.expressionsLeft,
  });

  /// 커리큘럼 위치가 아직 없는 회원 — 서버가 `/cur/me` 에 **404** 로 답하는
  /// 경우다. 응답 본문이 없으니 [fromCurMe] 로는 만들 수 없어 상수로 둔다.
  static const noLevel = HomeCourse(kind: HomeCourseKind.noLevel);

  /// 서버 응답에서 화면 값을 뽑는다.
  ///
  /// **레벨 미정 판정** — `CurMe` 에는 「레벨 없음」 플래그가 없다. 차시가 없으면
  /// `CurLesson.fromJson` 이 전 필드를 기본값(`code: ''` · `levelNo: 0`)으로
  /// 채우므로, 그 빈 차시가 곧 「아직 커리큘럼 위치가 없다」는 뜻이다.
  /// `LevelSummary.needsLevelTest` 로도 같은 판정이 되지만 요청이 하나 더 는다 —
  /// 홈이 그리는 것은 *커리큘럼 위치*이지 레벨 숫자가 아니라서 이쪽이 맞다.
  factory HomeCourse.fromCurMe(CurMe me) {
    final lesson = me.lesson;
    if (lesson.code.isEmpty || lesson.levelNo == 0) {
      return const HomeCourse(kind: HomeCourseKind.noLevel);
    }
    return HomeCourse(
      // ⚠ 서버 코드는 `A1-T01-1`(레벨-상황-순번)이고 Figma 배지는 `A1-01` 이다.
      //   둘을 잇는 규칙이 문서에 없어 **서버 값을 그대로 쓴다** — 자리수를
      //   맞추자고 규칙을 지어내면 순번이 상황번호로 읽히는 식으로 틀린다.
      unitCode: lesson.code,
      // `topic` 은 `cur_topic.name`, `situation` 은 상황 한 줄이다. 정본 2행이
      // 「처음 만난 반 친구와…」처럼 상황문에 가깝지만, 주제가 있으면 그쪽이
      // 차시를 더 정확히 가리킨다.
      topic: lesson.topic ?? lesson.situation,
      expressionsLeft: me.itemsLeft,
      kind: me.nextCourse == CallCourse.freetalk
          ? HomeCourseKind.freetalk
          : HomeCourseKind.expression,
    );
  }

  /// 어떤 변형을 그릴지.
  final HomeCourseKind kind;

  /// 단원 코드. [HomeCourseKind.noLevel] 에서는 null 이다 — 그 변형은 배지에
  /// 「레벨 미정」을 대신 넣는다.
  final String? unitCode;

  /// 이번 단원의 주제 한 줄. noLevel 에서는 null.
  final String? topic;

  /// 자유 회화까지 남은 표현 수. [HomeCourseKind.expression] 에서만 쓴다.
  final int? expressionsLeft;
}

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

  /// 그릴 내용. 화면이 [HomeCourse.fromCurMe] 로 서버 응답에서 뽑아 넘긴다.
  final HomeCourse course;

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
