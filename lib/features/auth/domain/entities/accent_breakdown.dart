/// The member's accent (nationality) breakdown — the classification result
/// shown on MyPage: which nationalities the learner's Korean accent sounds like,
/// with percentages. Comes from `GET /members/me/profile` (`speak_country`).
class AccentStat {
  const AccentStat({required this.label, required this.percent});

  /// Country/nationality name (server value, e.g. "United States").
  final String label;

  /// 0–100 share for this nationality.
  final int percent;
}

/// Top nationalities (highest first). Empty when the member has no accent
/// classification yet (통화 후 국적분석 전).
class AccentBreakdown {
  const AccentBreakdown(this.stats);

  /// 1st/2nd/3rd nationality, highest percent first. Empty = not analyzed.
  final List<AccentStat> stats;

  bool get isEmpty => stats.isEmpty;

  /// The dominant nationality label, or null when not analyzed.
  String? get top => stats.isEmpty ? null : stats.first.label;
}
