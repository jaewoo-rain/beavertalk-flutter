/// In-call learning sidecar payloads delivered over the call WebSocket as JSON
/// text control frames (NOT REST). Manual `fromJson` per project convention.
///
/// Server contract (`domains/learning/realtime/protocol.py`):
/// - `hint`          → [HintData]      (per beaver *question* turn; may never arrive)
/// - `teaching_plan` → [TeachingItem]s (once at call start, normal calls only)
library;

/// One example answer inside a [HintData] — a Korean sentence plus its
/// romanization and native-language gloss. `roman` may be null.
class HintExample {
  const HintExample({
    required this.korean,
    this.roman,
    required this.native,
    this.sentenceId,
  });

  /// The Korean example sentence (always present, non-empty).
  final String korean;

  /// Revised-Romanization of [korean]; null when the server omitted it.
  final String? roman;

  /// Native-language translation of [korean] (may be empty).
  final String native;

  /// Server sentence id — what `PATCH /sentences/{id}/bookmark` takes. Null
  /// when the server didn't send one, and then the hint card simply shows no
  /// bookmark control (there is nothing to bookmark against).
  final int? sentenceId;

  factory HintExample.fromJson(Map<String, dynamic> json) => HintExample(
        korean: (json['korean'] as String?)?.trim() ?? '',
        roman: (json['roman'] as String?)?.trim(),
        native: (json['native'] as String?)?.trim() ?? '',
        sentenceId: _asId(json['id']),
      );

  /// Reads an id that may arrive as int or as a numeric string.
  ///
  /// ⚠ **`as int?` 로 읽지 않는다** — 서버가 문자열로 보내면 TypeError 가 나고, 그건
  /// WS 스트림 핸들러까지 올라가 **통화를 죽인다**. `turn_id` 에서 이미 겪은 함정이다.
  /// 읽을 수 없으면 null 로 두고 북마크 버튼만 사라진다 — 통화는 그대로 간다.
  static int? _asId(Object? raw) {
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw.trim());
    return null;
  }
}

/// A dynamic hint for one beaver question turn: 1–3 [examples] the learner can
/// reveal if stuck. Keyed by [turnId] (the id of the question turn); a new hint
/// replaces the previous one.
class HintData {
  const HintData({required this.turnId, required this.examples});

  /// Id of the beaver question turn this hint answers.
  final String turnId;

  /// 1–3 example answers (server sends exactly 3 when possible; empty-Korean
  /// examples are dropped; the frame is not sent when none survive).
  final List<HintExample> examples;

  /// Parses a `hint` frame; returns null when it carries no usable example.
  ///
  /// ⚠ **왜 버렸는지 알아야 할 때는 [parse] 를 써라.** 이 함수는 이유를 삼킨다.
  static HintData? fromJson(Map<String, dynamic> json) => parse(json).hint;

  /// `hint` 프레임 파싱 — **버릴 때는 이유를 같이 돌려준다.**
  ///
  /// ⛔ 이게 필요한 이유: 서버는 힌트를 보냈는데(`hint[turn=b4]: 3개`) 앱에는 아무 흔적도
  /// 없던 통화가 있었다(2026-08-12). 형식이 조금만 어긋나면 **흔적 없이 사라진다** —
  /// 그러면 "서버가 안 보냈나 / 우리가 버렸나"를 아무도 못 가른다.
  ///
  /// ⚠ `turn_id` 를 `as String?` 로 읽지 않는다. 서버가 int 로 보내면 **TypeError 가 나고
  /// 그건 WS 스트림 핸들러까지 올라가 통화를 죽인다** — 같은 함정을 다른 자리에서 이미 겪었다.
  static ({HintData? hint, String? drop}) parse(Map<String, dynamic> json) {
    final rawTurn = json['turn_id'];
    final turnId = rawTurn is String
        ? rawTurn
        : (rawTurn is int ? '$rawTurn' : null);
    if (turnId == null || turnId.isEmpty) {
      return (hint: null, drop: 'turn_id 없음/형식오류(${rawTurn.runtimeType})');
    }
    final raw = json['examples'];
    if (raw is! List) {
      return (hint: null, drop: 'examples 가 배열이 아님(${raw.runtimeType})');
    }
    final maps = raw.whereType<Map<String, dynamic>>().toList(growable: false);
    final examples = maps
        .map(HintExample.fromJson)
        .where((e) => e.korean.isNotEmpty)
        .toList(growable: false);
    if (examples.isEmpty) {
      return (
        hint: null,
        drop: 'korean 이 있는 예시가 0개(원본 ${raw.length}개 중 '
            'Map ${maps.length}개)',
      );
    }
    return (hint: HintData(turnId: turnId, examples: examples), drop: null);
  }
}

/// One item of the `teaching_plan` (today's L1 study cards). Parsed and stored;
/// the in-call `screen/call_main` frames carry no teaching-card UI yet, so this
/// is retained for a later screen rather than rendered now.
class TeachingItem {
  const TeachingItem({
    required this.itemId,
    required this.ko,
    this.roman,
    this.meaning,
    this.example,
    required this.kind,
  });

  final int itemId;
  final String ko;
  final String? roman;
  final String? meaning;
  final String? example;

  /// Item type, e.g. `chunk` / `vocab`.
  final String kind;

  /// Parses a `teaching_plan` item; returns null when it has no [itemId].
  static TeachingItem? fromJson(Map<String, dynamic> json) {
    final itemId = json['item_id'];
    if (itemId is! int) return null;
    return TeachingItem(
      itemId: itemId,
      ko: (json['ko'] as String?) ?? '',
      roman: json['roman'] as String?,
      meaning: json['meaning'] as String?,
      example: json['example'] as String?,
      kind: (json['kind'] as String?) ?? '',
    );
  }
}
