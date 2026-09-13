import 'package:flutter/material.dart' hide Badge;

import '../../features/normalcall/domain/entities/call_course.dart';
import '../../features/normalcall/domain/entities/cur_me.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
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

  /// 학습 언어에 **커리큘럼이 아직 없다**(`/cur/me`.`available == false`) —
  /// 「{언어} 커리큘럼은 준비 중이에요 · 일반 표현학습으로 통화해요」.
  ///
  /// [noLevel] 과 다르다: 그쪽은 *이 회원*의 위치가 없는 것이고, 이쪽은 *그 언어*에
  /// 위치라는 게 아직 없는 것이다. 첫 통화를 해도 안 생긴다 — 안내가 달라야 한다.
  unavailable,
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
    this.language,
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
    // 언어에 커리큘럼이 없다 — 차시가 비어 있는 것과 겉모습은 같지만 뜻이 다르다.
    // 이 판정을 먼저 두는 이유: 아래 «빈 차시 = 레벨 미정» 과 겹치기 때문이다.
    if (!me.available) {
      return HomeCourse(kind: HomeCourseKind.unavailable, language: me.language);
    }
    final lesson = me.lesson;
    if (lesson.code.isEmpty || lesson.levelNo == 0) {
      return const HomeCourse(kind: HomeCourseKind.noLevel);
    }
    return HomeCourse(
      unitCode: badgeCode(lesson.code),
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

  /// 배지에 찍을 차시 코드 — 서버 코드에서 **상황 칸을 뺀다.**
  ///
  /// 서버는 `A1-T01-1`(레벨-상황-순번)로 차시를 식별하지만, 배지는 26px 알약
  /// 하나라 세 칸을 다 담으면 길다. 학습자에게 의미 있는 것은 **레벨과 순번**
  /// 이고 상황 번호(`T01`)는 내부 식별자다 — 그것만 떨어뜨린다.
  ///
  /// ```
  /// A1-T01-1  →  A1-1
  /// A1-T03-12 →  A1-12
  /// ```
  ///
  /// 칸이 셋이 아니면 **손대지 않는다.** 서버가 코드 모양을 바꿨을 때 엉뚱한
  /// 조각을 이어 붙이느니 원문을 보이는 편이 낫다 — 틀린 차시 번호는 맞는
  /// 긴 번호보다 나쁘다.
  static String badgeCode(String code) {
    final parts = code.split('-');
    if (parts.length != 3) return code;
    return '${parts.first}-${parts.last}';
  }

  /// 어떤 변형을 그릴지.
  final HomeCourseKind kind;

  /// 단원 코드. [HomeCourseKind.noLevel] 에서는 null 이다 — 그 변형은 배지에
  /// 「레벨 미정」을 대신 넣는다.
  final String? unitCode;

  /// 이번 단원의 주제 한 줄. noLevel 에서는 null.
  final String? topic;

  /// 커리큘럼이 없는 학습 언어(ISO 639-1). [HomeCourseKind.unavailable] 에서만 쓴다.
  final String? language;

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

  /// 정본 높이 — **최소값이다, 고정이 아니다.**
  ///
  /// 로딩 스켈레톤([HomeGnbSkeleton])과 같은 값을 써서 데이터가 늦게 와도
  /// 히어로가 튀지 않는다. 다만 고정으로 두면 안 된다: 내용이 26+8+18+8+16=76
  /// 에 패딩 16 을 더해 **정확히 92** 라 여유가 0이고, 사용자가 시스템 글자
  /// 크기를 키우면 그대로 넘쳤다(실측: 배율 1.3 에서 10px · 2.0 에서 40px).
  static const double height = 92;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    // 「위치 없음」 계열 둘 — 레벨 미정·언어 준비 중. 배지가 중립이고 오른쪽 라벨이
    // 없는 모양은 같고, 세 줄의 말만 다르다.
    final noLevel = course.kind == HomeCourseKind.noLevel ||
        course.kind == HomeCourseKind.unavailable;

    // 2행(주제) — 위치가 없으면 커리큘럼 위치가 없으니 안내 문구로 바뀐다.
    final title = switch (course.kind) {
      HomeCourseKind.noLevel => l10n.homeNoLevelTitle,
      HomeCourseKind.unavailable =>
        l10n.homeCurriculumPendingTitle(languageLabel(course.language)),
      _ => course.topic ?? '',
    };

    // 3행 — 변형마다 다른 말을 한다.
    final note = switch (course.kind) {
      HomeCourseKind.expression =>
        l10n.homeExpressionsLeft(course.expressionsLeft ?? 0),
      HomeCourseKind.freetalk => l10n.homeFreetalkNote,
      HomeCourseKind.noLevel => l10n.homeNoLevelNote,
      HomeCourseKind.unavailable => l10n.homeCurriculumPendingNote,
    };

    return ConstrainedBox(
      // 최소 92 — 평소엔 정확히 그 높이라 히어로가 안 움직이고, 글자 배율이
      // 크면 넘치는 대신 **자란다.**
      constraints: const BoxConstraints(minHeight: height),
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
            //
            // `Row` 가 아니라 [Wrap] 이다. **배지는 내용만큼(hug)** 잡아야 하고
            // (`Flexible` 로 줄이면 `A1-1` 같은 짧은 코드가 잘릴 수 있다),
            // 그러면 좁은 화면·큰 글자 배율에서 한 줄에 못 들어갈 수 있다.
            // 그때 잘라 내는 대신 **다음 줄로 흘린다.**
            //
            // 배지 자체는 내용만큼만 잡는다([Badge] 의 `widthFactor: 1`).
            // 그래도 폭이 모자라면 배지 **안의 글자**가 줄바꿈한다 — 어느
            // 단계에서도 잘라 내지 않는다.
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.s8,
              // 줄이 넘어갔을 때의 줄 간격. 가로 간격(8)보다 좁게 둬야 두 줄이
              // 한 덩어리로 읽힌다.
              runSpacing: AppSpacing.s4,
              children: [
                // 레벨이 없으면 단원 코드 대신 상태를 말한다. 중립 톤인 것이
                // 중요하다 — 민트는 「진행 중인 커리큘럼」의 색이라, 없는
                // 단원에 쓰면 있는 것처럼 읽힌다.
                Badge(
                  tone: noLevel ? BadgeTone.neutral : BadgeTone.brand,
                  // 원격이 `unavailable`(커리큘럼 준비 중)을 더했다 — 그쪽을
                  // 살린다. 내 변경은 배지를 **감싸는 방식**이지 라벨이 아니다.
                  label: switch (course.kind) {
                    HomeCourseKind.noLevel => l10n.homeLevelPending,
                    HomeCourseKind.unavailable =>
                      l10n.homeCurriculumPendingBadge,
                    _ => course.unitCode ?? '',
                  },
                ),
                // 레벨 미정에는 오른쪽 라벨이 없다(정본에서 hidden).
                if (!noLevel)
                  Text(
                    course.kind == HomeCourseKind.freetalk
                        ? l10n.homeCourseFreetalk
                        : l10n.homeCourseExpression,
                    style:
                        AppType.caption1.b.copyWith(color: c.primaryNormal),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            // ── 2행 — 주제 ─────────────────────────────────────────
            //
            // **글자가 길어지면 줄바꿈한다 — 자르지 않는다.**
            //
            // 주제는 서버 문자열이라 길이를 앱이 통제하지 못한다. 한 줄로 자르면
            // 어느 단원인지 못 읽는 경우가 생긴다. `maxLines` 를 안 거는 것이
            // `Text` 의 기본이고, 블록은 [HomeGnb.height] 를 **최소**로만 쓰므로
            // 줄이 늘면 그만큼 자란다.
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.label2.b.copyWith(color: c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s8),
            // ── 3행 — 진행 안내 ────────────────────────────────────
            Text(
              note,
              textAlign: TextAlign.center,
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
    return ConstrainedBox(
      // 본체와 같은 규칙 — 최소 92. 셔머는 글자가 아니라 안 자라지만, 두 상태가
      // 같은 제약을 쓰는 편이 나중에 어긋나지 않는다.
      constraints: const BoxConstraints(minHeight: HomeGnb.height),
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

/// ISO 639-1 코드 → 화면에 쓸 언어 이름(그 언어의 자기 이름). 목록에 없거나 null 이면
/// 코드를 대문자로 그대로(«EN») — 지어내지 않는다.
///
/// 설정 화면의 학습 언어 선택지([mockLanguages])와 같은 표를 본다 — 두 화면이 한 언어를
/// 다르게 부르면 안 된다.
String languageLabel(String? code) {
  if (code == null || code.isEmpty) return '';
  final id = code.split('-').first.toLowerCase();
  // 목록 id 가 `ko-KR` 처럼 BCP-47 인 항목이 있어 양쪽 다 첫 서브태그로 맞춘다.
  for (final l in mockLanguages) {
    if (l.id.split('-').first.toLowerCase() == id) return l.name;
  }
  return id.toUpperCase();
}
