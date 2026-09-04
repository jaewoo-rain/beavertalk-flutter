/// 과제가 요구하는 활동 종류. 서버 `Activity` 리터럴과 1:1 이다.
enum AssignmentActivity {
  /// 발음 — `/learning/intro` 에서 문장을 읽는다.
  speaking('speaking'),

  /// 회화 — 통화로 목표 표현을 쓴다. 서버가 통화 분석으로 스스로 채운다.
  conversation('conversation'),

  /// 워크북 — 앱 밖 PDF 다.
  workbook('workbook');

  const AssignmentActivity(this.code);

  /// 서버가 쓰는 문자열.
  final String code;

  /// 서버 문자열을 enum 으로. 모르는 값이면 null 이다 —
  /// **서버가 활동을 추가해도 앱이 죽지 않는다.**
  static AssignmentActivity? fromCode(String? code) {
    for (final v in AssignmentActivity.values) {
      if (v.code == code) return v;
    }
    return null;
  }
}

/// 제출 상태. 서버 `submission.status` 체크 제약과 같다.
enum AssignmentStatus {
  /// 아직 손대지 않음. 제출 행 자체가 없을 때도 이 값이다.
  notStarted('not_started'),

  /// 하다 말았음.
  inProgress('in_progress'),

  /// 끝냈음. 기준은 시간이 아니라 증거 유무다(서버 주석).
  done('done');

  const AssignmentStatus(this.code);

  /// 서버가 쓰는 문자열.
  final String code;

  /// 서버 문자열을 enum 으로. 모르는 값은 [notStarted] 로 떨어뜨린다.
  static AssignmentStatus fromCode(String? code) {
    for (final v in AssignmentStatus.values) {
      if (v.code == code) return v;
    }
    return notStarted;
  }
}

/// 학습자가 보는 과제 1건 — `GET /classrooms/my/assignments` 의 한 원소.
///
/// **서버는 문안을 만들지 않는다.** 마감 표기·상태 배지는 전부 앱이 로케일로
/// 조립한다. 여기 담기는 것은 숫자와 코드뿐이다.
class ClassroomAssignment {
  /// 응답 1건을 담는다.
  const ClassroomAssignment({
    required this.assignmentId,
    required this.classroomName,
    this.classroomId,
    this.closedAt,
    this.workbookUrl,
    required this.grade,
    required this.chapter,
    required this.activities,
    required this.itemIds,
    required this.dueAt,
    required this.overdue,
    required this.status,
    this.speakingScored = 0,
    this.speakingPassed,
    this.speakingTotal,
    this.conversationMet,
    this.conversationTotal,
    this.workbookOpenedAt,
  });

  /// 응답 원소를 읽는다.
  ///
  /// 진행 수치 4종은 **null 을 0 으로 뭉개지 않는다.** null 은 「아직 없음」이고
  /// 0 은 「0건 통과」다 — 화면이 둘을 다르게 그려야 한다.
  factory ClassroomAssignment.fromJson(Map<String, dynamic> json) {
    final rawActivities = json['activities'];
    return ClassroomAssignment(
      assignmentId: (json['assignment_id'] as num).toInt(),
      classroomName: json['classroom_name'] as String? ?? '',
      classroomId: (json['classroom_id'] as num?)?.toInt(),
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String).toLocal(),
      // 🔴 워크북은 과제가 아니라 **챕터**에 붙는 자산이라 중첩 객체로 온다
      // (급수·챕터 1권). 평평한 `workbook_url` 로 오던 초안은 폐기됐다.
      workbookUrl: json['workbook'] is Map
          ? (json['workbook'] as Map)['view_url'] as String?
          : null,
      grade: (json['grade'] as num?)?.toInt() ?? 0,
      chapter: (json['chapter'] as num?)?.toInt() ?? 0,
      activities: rawActivities is List
          ? rawActivities
                .map((e) => AssignmentActivity.fromCode(e as String?))
                .whereType<AssignmentActivity>()
                .toList(growable: false)
          : const <AssignmentActivity>[],
      itemIds: json['item_ids'] is List
          ? (json['item_ids'] as List)
                .map((e) => (e as num).toInt())
                .toList(growable: false)
          : const <int>[],
      dueAt: DateTime.parse(json['due_at'] as String).toLocal(),
      overdue: json['overdue'] as bool? ?? false,
      status: AssignmentStatus.fromCode(json['status'] as String?),
      speakingScored: (json['speaking_scored'] as num?)?.toInt() ?? 0,
      speakingPassed: (json['speaking_passed'] as num?)?.toInt(),
      speakingTotal: (json['speaking_total'] as num?)?.toInt(),
      conversationMet: (json['conversation_met'] as num?)?.toInt(),
      conversationTotal: (json['conversation_total'] as num?)?.toInt(),
      // 워크북은 서버가 「열었나」만 안다. 안 열었으면 아예 없는 값이다.
      workbookOpenedAt: json['workbook_opened_at'] is String
          ? DateTime.tryParse(json['workbook_opened_at'] as String)?.toLocal()
          : null,
    );
  }

  /// 과제 id. 제출·상세 조회에 쓴다.
  final int assignmentId;

  /// 반 이름 원문. 한 학습자가 여러 반에 속할 수 있어 목록에서 구분자가 된다.
  final String classroomName;

  /// 반 id.
  ///
  /// 🔴 **현재 서버 응답에 없다**(2026-09-02 `my/assignments` 실측). 반 나가기가
  /// `DELETE /classrooms/{id}/leave` 로 id 를 요구하는데 목록만 봐서는 알 수
  /// 없어, 참여 시점의 id 를 기기에 저장해 쓴다
  /// (`data/datasources/joined_class_store.dart`).
  ///
  /// 서버가 이 필드를 채우면 저장분보다 이쪽을 먼저 쓴다 — 그러면 재설치 후에도
  /// 나갈 수 있고, 반이 여럿일 때도 정확해진다.
  final int? classroomId;

  /// 과제가 닫힌 시각. null 이면 진행 중이다.
  ///
  /// **마감(`dueAt`)과 다르다.** 마감은 지나도 제출을 받지만 닫힌 과제는 받지
  /// 않는다 — 화면이 둘을 같은 색으로 그리면 학습자가 헛수고를 한다.
  final DateTime? closedAt;

  /// 워크북 PDF 외부 링크(`workbook.view_url`). 없으면 null 이다.
  ///
  /// 워크북은 **급수·챕터 단위 자산**이라 과제별로 다르지 않다. 활동에 워크북이
  /// 없거나 그 챕터의 PDF 가 아직 없으면 서버가 `workbook` 을 안 실어 준다.
  ///
  /// 앱 안에서 열지 않는다 — 뷰어를 들이면 30 로케일 폰트가 따라온다.
  final String? workbookUrl;

  /// 닫혀서 더 제출할 수 없는 과제인지.
  bool get isClosed => closedAt != null;

  /// 급수(1~6).
  final int grade;

  /// 챕터 번호.
  final int chapter;

  /// 요구 활동. 서버가 최소 1개를 보장한다.
  final List<AssignmentActivity> activities;

  /// 출제된 학습 항목 id 목록.
  final List<int> itemIds;

  /// 마감 시각(기기 시간대로 변환됨).
  final DateTime dueAt;

  /// 서버가 판정한 지각 여부.
  ///
  /// **마감이 제출을 막지는 않는다.** 서버는 지각 제출도 받는다 — 앱에서
  /// 마감으로 잠그면 안 된다.
  final bool overdue;

  /// 제출 상태.
  final AssignmentStatus status;

  /// **읽은** 문장 수. 통과 여부와 무관하다.
  ///
  /// 🔴 완료 판정은 이 값으로 한다. [speakingPassed] 로 판정하면 두 문장 틀린
  /// 학습자가 다 읽고도 영원히 「학습하기」를 본다(2026-09-04 실측 37/38).
  final int speakingScored;

  /// 발음 통과 문장 수. 아직 제출 전이면 null 이다.
  ///
  /// 🔴 **점수가 아니라 문장 수다.** 교사 화면이 「12 / 14 문장」으로 읽는다.
  final int? speakingPassed;

  /// 발음 출제 문장 수. 아직 제출 전이면 null 이다.
  final int? speakingTotal;

  /// 회화 달성 표현 수. 통화 분석이 채운다. 통화 전이면 null 이다.
  final int? conversationMet;

  /// 회화 목표 표현 수. 통화 전이면 null 이다.
  final int? conversationTotal;

  /// 워크북을 처음 연 시각. 안 열었으면 null 이다.
  ///
  /// ⚠ 「열었다」이지 「풀었다」가 아니다 — PDF 는 Google Drive 가 연다. 서버가 아는
  ///   것은 학습자가 「다운로드」를 눌렀다는 사실 하나뿐이고, 화면도 그 이상을
  ///   말하면 안 된다.
  final DateTime? workbookOpenedAt;

  /// 이 과제가 요구하는 활동 수 — 리스트 카드의 분모다.
  int get activityCount => activities.length;

  /// 활동 한 건이 끝났는지 — 칩의 체크·카드의 CTA·목록의 분자가 **모두 이걸 본다.**
  ///
  /// 🔴 판정을 두 벌 두지 마라. 예전에는 이 규칙이 두 곳에 있었고 발음이
  ///    한쪽은 **읽은 수**, 다른 쪽은 **맞힌 수**였다 — 37 / 38 을 읽은 학습자의
  ///    상세는 「완료」인데 목록 카드는 `0/3` 이었다(2026-09-04 실측).
  ///
  /// 워크북은 **연 시각**이 유일한 신호다. 앱이 「다운로드」를 누를 때 서버에 알린다.
  bool isActivityDone(AssignmentActivity activity) {
    return switch (activity) {
      // 🔴 **읽은 수**로 판정한다. 맞힌 수(`speakingPassed`)로 재면 두 문장 틀린
      //    학습자는 다 읽고도 완료가 안 된다 — 숙제는 점수가 아니라 수행이다.
      AssignmentActivity.speaking => _met(speakingScored, speakingTotal),
      // 🔴 **목표를 다 채우라는 뜻이 아니다**(2026-09-04 사용자 결정 — 「1개라도 쓰면
      //    수행」). `conversationMet` 은 통화가 이 과제에 귀속될 때 서버가 채우는
      //    값이라, **있다는 사실 자체**가 수행의 신호다. `met >= total` 로 재면 6분
      //    통화 한 판에 목표 10개를 다 끼워 넣어야 해서 사실상 완료가 불가능하다.
      //    n / 10 은 교사가 보는 **점수**이지 통과선이 아니다.
      AssignmentActivity.conversation => conversationMet != null,
      // 「다운로드」를 누르면 앱이 서버에 알린다(2026-09-04 사용자 지시).
      // 그 전까지는 판정할 근거가 없어 false 다.
      AssignmentActivity.workbook => workbookOpenedAt != null,
    };
  }

  /// 끝난 활동 수 — 리스트 카드의 분자다.
  int get completedActivityCount => activities.where(isActivityDone).length;

  static bool _met(int? done, int? total) =>
      done != null && total != null && total > 0 && done >= total;
}
