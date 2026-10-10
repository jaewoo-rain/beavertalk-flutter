import 'dart:math' as math;
import 'dart:ui' show Color;

import 'app_color_tokens.dart';

/// 발음 점수 구간 1~5 — `min(5, floor(score/20)+1)`. 경계값 20 은 2구간, 100 은 5구간.
///
/// 발음 결과 게이지(H4 · `pronunciation_result` `2224:20999`)와 취약 발음 카드 막대
/// (W2 · `WeakSound/Card` `6040:1496`)가 같은 구간을 쓴다(09-24 사장님 확정).
int scoreBand(num score) => math.min(5, (score.clamp(0, 100) ~/ 20) + 1);

/// 구간 색 — Figma Semantics `Score/1`~`Score/5` · `Score/n Text`.
extension ScoreBandColors on AppColorTokens {
  /// `Score/n` — 채움 · 조각 배경(투명도는 쓰는 곳이 건다) · 테두리.
  Color scoreColor(int band) => switch (band) {
        1 => score1,
        2 => score2,
        3 => score3,
        4 => score4,
        _ => score5,
      };

  /// `Score/n Text` — 점수 글자.
  Color scoreTextColor(int band) => switch (band) {
        1 => score1Text,
        2 => score2Text,
        3 => score3Text,
        4 => score4Text,
        _ => score5Text,
      };
}
