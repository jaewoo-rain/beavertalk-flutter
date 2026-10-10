import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 발음 학습 결과 표(`learning_call_main` · 로딩 뼈대)의 고정 열 폭.
///
/// Figma 폭(36·40·48·52)은 한국어 머리 기준이라 긴 언어의 머리 낱말이 열보다 넓다 — 영어
/// 「Sentences」가 40 안에서 「Senten / ces」로 낱말 중간에서 끊겼다(09-24 실기기). 그래서 고정 열을
/// 머리의 **가장 긴 낱말 폭**까지 넓히되, 이름 열(유연)에 [nameMin] 을 남기는 만큼만 넓힌다.
/// 남는 폭이 모자라면 열마다 넓히려던 몫을 같은 비율로 줄인다 — 표가 행 밖으로 넘치지 않는다.
///
/// [spec] · [wanted] 는 열마다 같은 길이이고, 유연 열은 둘 다 null 이다.
List<double?> fitTableColumns({
  required List<double?> spec,
  required List<double?> wanted,
  required double innerWidth,
  required double gap,
  double nameMin = 72,
}) {
  final budget = innerWidth - gap * (spec.length - 1) - nameMin;
  var specSum = 0.0, wantSum = 0.0;
  for (var i = 0; i < spec.length; i++) {
    if (spec[i] == null) continue;
    specSum += spec[i]!;
    wantSum += math.max(spec[i]!, wanted[i] ?? spec[i]!);
  }
  if (!budget.isFinite || wantSum <= budget) {
    return [
      for (var i = 0; i < spec.length; i++)
        spec[i] == null ? null : math.max(spec[i]!, wanted[i] ?? spec[i]!),
    ];
  }
  if (specSum >= budget || wantSum == specSum) return spec;
  final k = (budget - specSum) / (wantSum - specSum);
  return [
    for (var i = 0; i < spec.length; i++)
      spec[i] == null
          ? null
          : spec[i]! +
                (math.max(spec[i]!, wanted[i] ?? spec[i]!) - spec[i]!) * k,
  ];
}

/// 글자의 가장 긴 낱말 폭(= 최소 고유 폭) — 이보다 좁으면 낱말 중간에서 줄이 바뀐다.
double longestWordWidth(BuildContext context, String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  final w = painter.minIntrinsicWidth.ceilToDouble();
  painter.dispose();
  return w;
}
