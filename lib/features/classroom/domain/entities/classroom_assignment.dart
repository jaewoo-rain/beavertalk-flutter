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
    this.speakingPassed,
    this.speakingTotal,
    this.conversationMet,
    this.conversationTotal,
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
      workbookUrl: json['workbook_url'] as String?,
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
      speakingPassed: (json['speaking_passed'] as num?)?.toInt(),
      speakingTotal: (json['speaking_total'] as num?)?.toInt(),
      conversationMet: (json['conversation_met'] as num?)?.toInt(),
      conversationTotal: (json['conversation_total'] as num?)?.toInt(),
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

  /// 워크북 PDF 외부 링크. 교사가 넣지 않았으면 null 이다.
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

  /// 이 과제가 요구하는 활동 수 — 리스트 카드의 분모다.
  int get activityCount => activities.length;

  /// 끝난 활동 수 — 리스트 카드의 분자다.
  ///
  /// 워크북은 서버에 완료 신호가 없어 세지 않는다. 발음·회화만 증거로 판정한다.
  int get completedActivityCount {
    var done = 0;
    for (final a in activities) {
      switch (a) {
        case AssignmentActivity.speaking:
          final passed = speakingPassed;
          final total = speakingTotal;
          if (passed != null && total != null && total > 0 && passed >= total) {
            done++;
          }
        case AssignmentActivity.conversation:
          final met = conversationMet;
          final total = conversationTotal;
          if (met != null && total != null && total > 0 && met >= total) done++;
        case AssignmentActivity.workbook:
          break;
      }
    }
    return done;
  }
}
