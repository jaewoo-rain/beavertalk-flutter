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
  });

  /// The Korean example sentence (always present, non-empty).
  final String korean;

  /// Revised-Romanization of [korean]; null when the server omitted it.
  final String? roman;

  /// Native-language translation of [korean] (may be empty).
  final String native;

  factory HintExample.fromJson(Map<String, dynamic> json) => HintExample(
        korean: (json['korean'] as String?)?.trim() ?? '',
        roman: (json['roman'] as String?)?.trim(),
        native: (json['native'] as String?)?.trim() ?? '',
      );
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
  static HintData? fromJson(Map<String, dynamic> json) {
    final turnId = json['turn_id'] as String?;
    if (turnId == null) return null;
    final raw = json['examples'];
    if (raw is! List) return null;
    final examples = raw
        .whereType<Map<String, dynamic>>()
        .map(HintExample.fromJson)
        .where((e) => e.korean.isNotEmpty)
        .toList(growable: false);
    if (examples.isEmpty) return null;
    return HintData(turnId: turnId, examples: examples);
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
