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
    this.exampleMeaning,
    this.isCore = false,
    this.score,
  });

  /// 응답 원소를 읽는다.
  factory AssignmentItem.fromJson(Map<String, dynamic> json) {
    return AssignmentItem(
      itemId: (json['item_id'] as num).toInt(),
      surface: json['surface'] as String? ?? '',
      seq: (json['seq'] as num?)?.toInt(),
      example: json['example'] as String?,
      meaning: json['meaning'] as String?,
      exampleMeaning: json['example_meaning'] as String?,
      isCore: json['is_core'] as bool? ?? false,
      score: json['score'] is Map<String, dynamic>
          ? AssignmentItemResult.fromJson(json['score'] as Map<String, dynamic>)
          : null,
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

  /// 요청 로케일의 **표제어** 뜻. 「사람 → person」.
  ///
  /// 🔴 이것을 예문 밑에 쓰지 마라. 「그 사람은 선생님이 아닙니다」 밑에 `person`
  /// 이 뜨던 어긋남이 그것이었다(2026-09-04). 축을 맞춘 값은 [readableMeaning].
  final String? meaning;

  /// **예문**의 번역. 비어 있을 수 있다(서버 적재 9,714 / 미적재 922).
  final String? exampleMeaning;

  /// 이미 받은 채점. 중간에 나갔다 들어와도 서버가 돌려준다. 없으면 미채점이다.
  final AssignmentItemResult? score;

  /// 핵심 어휘인지.
  final bool isCore;

  /// 읽을 텍스트 — 예문이 있으면 예문, 없으면 표제어.
  String get readable => _hasExample ? example!.trim() : surface;

  /// 읽는 텍스트에 **축이 맞는** 뜻.
  ///
  /// 예문을 읽으면 예문 번역을, 표제어를 읽으면 표제어 뜻을 준다. 한쪽이 없다고
  /// 다른 쪽으로 메우지 않는다 — 그게 문장 밑에 단어 뜻이 뜨던 원인이다.
  String? get readableMeaning => _hasExample ? exampleMeaning : meaning;

  bool get _hasExample => example != null && example!.trim().isNotEmpty;
}

/// 서버에 남아 있는 문장 1개의 채점 결과.
///
/// `GET .../items` 의 `score` 다. 앱이 들고 있던 값이 아니라 **서버가 저장한 값**
/// 이므로, 앱을 껐다 켜도·기기를 바꿔도 같은 값이 온다.
class AssignmentItemResult {
  /// 결과를 담는다.
  const AssignmentItemResult({
    required this.itemId,
    required this.passed,
    required this.totalScore,
    this.pronunciation = 0,
    this.fluency = 0,
    this.rhythm = 0,
  });

  /// 응답을 읽는다.
  factory AssignmentItemResult.fromJson(Map<String, dynamic> json) {
    final evaluation = json['evaluation'];
    int pick(String key) => evaluation is Map<String, dynamic>
        ? ((evaluation[key] as num?)?.toInt() ?? 0)
        : 0;
    return AssignmentItemResult(
      itemId: (json['item_id'] as num?)?.toInt() ?? 0,
      passed: json['passed'] as bool? ?? false,
      totalScore: pick('total_score'),
      pronunciation: pick('pronunciation'),
      fluency: pick('fluency'),
      rhythm: pick('rhythm'),
    );
  }

  /// 채점한 항목.
  final int itemId;

  /// **서버 판정**. 앱이 점수로 다시 재지 않는다.
  final bool passed;

  /// 총점.
  final int totalScore;

  /// 발음.
  final int pronunciation;

  /// 유창성.
  final int fluency;

  /// 리듬.
  final int rhythm;
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

/// 방금 채점한 결과 — `POST .../score` 의 응답.
///
/// 서버는 이 결과를 **저장한다**(2026-09-04~). 재진입 시에는 [AssignmentItem.score]
/// 로 돌아온다.
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
