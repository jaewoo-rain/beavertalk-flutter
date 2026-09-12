import 'call_course.dart';

/// 내 커리큘럼 위치 한 장 — `GET /api/v1/cur/me`(커리큘럼 2단계).
///
/// 서버 `CurMeOut`(`domains/learning/schemas/curriculum.py`, a652cdc):
/// ```
/// { lesson: {no, code, level_no, situation?, topic?},
///   status: "learning" | "expression_done" | "freetalk_done",
///   items_total, items_drilled,
///   open: {expression: bool, freetalk: bool},
///   next_course: "expression" | "freetalk" }
/// ```
///
/// ⭐ [nextCourse] 가 **`auto` 로 걸면 서버가 정할 코스**다 — 표현학습을 다 드릴했으면
///   (`expression_done`) 프리토킹, 아니면 표현학습. 홈 «이번 통화» 카드가 그릴 값이고,
///   지금은 개발자 도구가 한 줄로 보여 준다.
/// ⚠ [open.freetalk] 이 false 인데 프리토킹을 명시로 걸면 서버가 `COURSE_LOCKED` 로 닫는다.
class CurMe {
  const CurMe({
    required this.lesson,
    required this.status,
    required this.itemsTotal,
    required this.itemsDrilled,
    required this.openExpression,
    required this.openFreetalk,
    required this.nextCourse,
  });

  final CurLesson lesson;

  /// `learning` · `expression_done` · `freetalk_done`. 모르는 값은 그대로 문자열로 둔다.
  final String status;

  /// 이 차시 항목 수(퇴출분 제외).
  final int itemsTotal;

  /// 그중 드릴까지 간 항목 수. 진행률 = [itemsDrilled] / [itemsTotal].
  final int itemsDrilled;

  /// 표현학습을 열 수 있나. 서버 주석: 언제나 true(복습 통화도 표현학습이다).
  final bool openExpression;

  /// 프리토킹을 열 수 있나 — 그 차시 표현학습이 끝났고 아직 프리토킹을 안 했을 때만.
  final bool openFreetalk;

  /// `auto` 로 걸면 서버가 정할 코스. 서버 Literal 밖의 값이면 null.
  final CallCourse? nextCourse;

  /// 아직 드릴 안 한 항목 수(음수 방어).
  int get itemsLeft => (itemsTotal - itemsDrilled).clamp(0, itemsTotal);

  factory CurMe.fromJson(Map<String, dynamic> json) {
    final lesson = json['lesson'];
    final open = json['open'];
    return CurMe(
      lesson: CurLesson.fromJson(
        lesson is Map<String, dynamic> ? lesson : const {},
      ),
      status: (json['status'] as String?) ?? '',
      itemsTotal: (json['items_total'] as num?)?.toInt() ?? 0,
      itemsDrilled: (json['items_drilled'] as num?)?.toInt() ?? 0,
      openExpression:
          open is Map<String, dynamic> && open['expression'] == true,
      openFreetalk: open is Map<String, dynamic> && open['freetalk'] == true,
      nextCourse: CallCourse.fromWire(json['next_course']),
    );
  }
}

/// 현재 차시.
class CurLesson {
  const CurLesson({
    required this.no,
    required this.code,
    required this.levelNo,
    this.situation,
    this.topic,
  });

  final int no;

  /// 예 `A1-T01-1`(레벨-상황-순번). 하네스·로그가 이걸로 차시를 식별한다.
  final String code;

  final int levelNo;

  /// 상황 한 줄. 없으면 null.
  final String? situation;

  /// 주제(`cur_topic.name`). 없으면 null.
  final String? topic;

  factory CurLesson.fromJson(Map<String, dynamic> json) => CurLesson(
        no: (json['no'] as num?)?.toInt() ?? 0,
        code: (json['code'] as String?) ?? '',
        levelNo: (json['level_no'] as num?)?.toInt() ?? 0,
        situation: json['situation'] as String?,
        topic: json['topic'] as String?,
      );
}
