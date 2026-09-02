import '../../../review/domain/entities/review_feedback.dart';

/// 과제가 출제한 문장 1개 — `GET /classrooms/assignments/{id}/items` 의 한 원소.
class AssignmentItem {
  /// 항목 하나를 담는다.
  const AssignmentItem({
    required this.itemId,
    required this.surface,
    this.seq,
    this.example,
    this.meaning,
    this.isCore = false,
  });

  /// 응답 원소를 읽는다.
  factory AssignmentItem.fromJson(Map<String, dynamic> json) {
    return AssignmentItem(
      itemId: (json['item_id'] as num).toInt(),
      surface: json['surface'] as String? ?? '',
      seq: (json['seq'] as num?)?.toInt(),
      example: json['example'] as String?,
      meaning: json['meaning'] as String?,
      isCore: json['is_core'] as bool? ?? false,
    );
  }

  /// 학습 항목 id. 채점·미통과 보고에 쓴다.
  final int itemId;

  /// 표제어.
  final String surface;

  /// 커리큘럼 순번.
  final int? seq;

  /// 읽을 예문.
  ///
  /// 🔴 서버가 `vocab_example()` 을 거친 값만 내려준다 — 문법 항목의 예문은
  /// 교재 저작물이라 오지 않는다. null 이면 표제어를 읽는다.
  final String? example;

  /// 요청 로케일의 뜻. **비어 있을 수 있다** — `meanings` 적재율이 0% 면 전부
  /// null 이다. 없다고 표제어로 메우지 마라(뜻 = 단어가 된다).
  final String? meaning;

  /// 핵심 어휘인지.
  final bool isCore;

  /// 읽을 텍스트 — 예문이 있으면 예문, 없으면 표제어.
  String get readable => (example != null && example!.trim().isNotEmpty)
      ? example!.trim()
      : surface;
}

/// 과제의 출제 문장 묶음.
class AssignmentItems {
  /// 묶음을 담는다.
  const AssignmentItems({
    required this.assignmentId,
    required this.grade,
    required this.chapter,
    required this.items,
    this.chapterRange = '',
    this.closed = false,
  });

  /// 응답을 읽는다.
  factory AssignmentItems.fromJson(Map<String, dynamic> json) {
    final raw = json['items'];
    return AssignmentItems(
      assignmentId: (json['assignment_id'] as num).toInt(),
      grade: (json['grade'] as num?)?.toInt() ?? 0,
      chapter: (json['chapter'] as num?)?.toInt() ?? 0,
      chapterRange: json['chapter_range'] as String? ?? '',
      closed: json['closed'] as bool? ?? false,
      items: raw is List
          ? raw
                .whereType<Map<String, dynamic>>()
                .map(AssignmentItem.fromJson)
                .toList(growable: false)
          : const <AssignmentItem>[],
    );
  }

  /// 과제 id.
  final int assignmentId;

  /// 급수.
  final int grade;

  /// 챕터 번호.
  final int chapter;

  /// `그림 ~ 남편` — 챕터의 어휘 범위. **어느 로케일에서도 한국어다**(학습 대상).
  final String chapterRange;

  /// 닫힌 과제인지. 닫혔으면 채점을 받지 않는다.
  final bool closed;

  /// 출제 순서 그대로의 문장들.
  final List<AssignmentItem> items;
}

/// 과제 문장 1개의 채점 결과.
///
/// 서버가 **아무것도 저장하지 않는다.** 통과 여부만 앱이 세고 마지막에 문장 수를
/// 한 번 올린다.
class AssignmentItemScore {
  /// 채점 결과를 담는다.
  const AssignmentItemScore({
    required this.itemId,
    required this.refText,
    required this.passed,
    required this.feedback,
  });

  /// 채점한 항목 id.
  final int itemId;

  /// 채점 기준이 된 텍스트.
  final String refText;

  /// **서버가 판정한** 통과 여부. 앱이 점수로 다시 판정하지 마라 — 경계가 두
  /// 곳에 생기면 교사 화면의 「n / m 문장」과 어긋난다.
  final bool passed;

  /// 화면이 그대로 그리는 채점 피드백.
  final ReviewFeedback feedback;
}
