import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../layout/need_based_rows.dart';

/// Visual state of a [PronunciationResult].
///
/// Figma component set `2224:20999` (pronunciation_result), states
/// `active` / `inactive`.
enum PronunciationState {
  /// A real, scored result: filled gauge + center percent in the score band colour.
  active,

  /// No score yet: only the five band tracks (18%), no fill, center shows `-%`.
  inactive,
}

/// A single labelled metric shown in the footer (e.g. Pronunciation 96%).
class PronunciationMetric {
  const PronunciationMetric({
    required this.label,
    required this.value,
    this.score,
  });

  /// Caption label ([AppType.caption1]), e.g. "Pronunciation".
  final String label;

  /// Value text ([AppType.body1] SemiBold), e.g. "96%" — shown as-is when
  /// [score] is null (e.g. `-%`).
  final String value;

  /// 0–100. 있으면 값 글자를 이 점수의 구간 글자색(`Score/n Text`)으로 칠하고 0부터 센다.
  final num? score;
}

/// 점수 구간 1~5 — `min(5, floor(score/20)+1)`. 경계값 20 은 2구간, 100 은 5구간.
int pronunciationBand(num score) =>
    math.min(5, (score.clamp(0, 100) ~/ 20) + 1);

extension _ScoreColors on AppColorTokens {
  Color band(int n) => switch (n) {
        1 => score1,
        2 => score2,
        3 => score3,
        4 => score4,
        _ => score5,
      };

  Color bandText(int n) => switch (n) {
        1 => score1Text,
        2 => score2Text,
        3 => score3Text,
        4 => score4Text,
        _ => score5Text,
      };
}

/// PronunciationResult — a semicircle score gauge with a metrics footer.
///
/// Figma component set `2224:20999` (pronunciation_result) — **H4 「채움 + 구간 배경」**
/// (09-24 사장님 확정 · 엔드캡 없음 · 원장 P32):
/// - 반원 링 255×127.5 · 두께 18. 0–100 을 20점씩 다섯 조각으로 나누고 조각 양 끝을 0.4%씩
///   비운다(틈). 조각 배경 = 그 구간 색 18%, 채움 = 0부터 점수까지 **지나는 조각마다 그 조각의
///   구간 색**. 끝은 평평하다(butt).
/// - 가운데 점수([AppType.title1] Bold) = 전체 점수의 `Score/n Text`.
/// - 지표 3칸 값 = 각자 점수의 `Score/n Text` · 라벨 `Label/Normal`.
/// - 지표 패널 테두리 1px(안쪽) = 전체 점수의 `Score/n`.
/// - inactive = 조각 배경만 · 채움·테두리 없음 · `-%`.
/// - 채워지는 애니메이션(시안 `6364:3509`): 게이지 0→점수 900ms easeOutCubic · 가운데 숫자
///   같은 곡선으로 카운트업(색은 최종 구간색 고정) · 지표 3칸은 450ms 부터 100ms 간격으로 각
///   400ms. **처음 그려질 때 1회만.** 애니메이션 끄기(`MediaQuery.disableAnimations`)면 최종값만.
///   글로우 없음.
///
/// Presentation-only: pass [score] (0–100), [metrics], and [state].
class PronunciationResult extends StatefulWidget {
  const PronunciationResult({
    super.key,
    required this.score,
    required this.metrics,
    this.state = PronunciationState.active,
    this.hint,
  });

  /// Overall score 0–100, shown in the gauge center and driving the arc.
  /// Ignored visually when [state] is [PronunciationState.inactive].
  final double score;

  /// Footer metrics (Figma shows three: Pronunciation / Fluency / Rhythm).
  final List<PronunciationMetric> metrics;

  /// Whether the result is scored ([PronunciationState.active]) or empty.
  final PronunciationState state;

  /// One line under the metrics explaining *why* the gauge reads `-%`.
  ///
  /// **Injected by the caller, never hardcoded.** Three screens share this
  /// component and the reason differs in each: on analysis the score is missing
  /// because the user has not reviewed yet, on mypage because there is no
  /// pronunciation history at all. A single built-in string would be wrong on
  /// at least one of them.
  ///
  /// Null on the loading skeletons — a shimmering placeholder should not also
  /// assert why a value it is still fetching is absent.
  final String? hint;

  static const double _gaugeWidth = 255;
  static const double _gaugeHeight = 127.5;

  /// 게이지 채움 900ms, 지표는 450ms 부터 100ms 간격 · 각 400ms.
  static const int _gaugeMs = 900,
      _metricStartMs = 450,
      _metricStepMs = 100,
      _metricMs = 400;

  @override
  State<PronunciationResult> createState() => _PronunciationResultState();
}

class _PronunciationResultState extends State<PronunciationResult>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _started = false;

  bool get _active => widget.state == PronunciationState.active;

  int get _totalMs => math.max(
        PronunciationResult._gaugeMs,
        PronunciationResult._metricStartMs +
            PronunciationResult._metricStepMs *
                math.max<int>(0, widget.metrics.length - 1) +
            PronunciationResult._metricMs,
      );

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: Duration(milliseconds: _totalMs));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // 처음 그려질 때 1회만. 점수가 없거나 애니메이션을 끈 기기면 최종값만 보인다.
    if (!_active || MediaQuery.maybeDisableAnimationsOf(context) == true) {
      _anim.value = 1;
    } else {
      _anim.forward();
    }
  }

  @override
  void didUpdateWidget(PronunciationResult old) {
    super.didUpdateWidget(old);
    // 다시 재생하지 않는다 — 점수가 늦게 바뀌면 최종값으로 바로 간다.
    if (old.score != widget.score || old.state != widget.state) {
      _anim.value = 1;
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  double _phase(int startMs, int lengthMs) {
    final total = _totalMs.toDouble();
    return Interval(
      startMs / total,
      math.min(1, (startMs + lengthMs) / total),
      curve: Curves.easeOutCubic,
    ).transform(_anim.value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final double clamped = widget.score.clamp(0, 100).toDouble();
    final int band = pronunciationBand(clamped);

    // 폭은 부모(콘텐츠 컬럼)를 채운다 — 폰 335, 태블릿 600. 안의 게이지는
    // [_gaugeWidth] 고정이라 커지지 않고 가운데 선다.
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final gaugeT =
            _active ? _phase(0, PronunciationResult._gaugeMs) : 0.0;
        final shown = clamped * gaugeT;
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: PronunciationResult._gaugeWidth,
                height: PronunciationResult._gaugeHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(PronunciationResult._gaugeWidth,
                          PronunciationResult._gaugeHeight),
                      painter: _GaugePainter(
                        bands: [for (var i = 1; i <= 5; i++) c.band(i)],
                        progress: _active ? shown / 100 : 0,
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.65),
                      child: Text(
                        _active ? '${shown.round()}%' : '-%',
                        style: AppType.title1.b.copyWith(
                          // 숫자 색은 최종 구간색으로 고정 — 세는 동안 색이 바뀌지 않는다.
                          color:
                              _active ? c.bandText(band) : c.primaryNormal24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              _MetricsFooter(
                metrics: widget.metrics,
                active: _active,
                border: _active ? c.band(band) : null,
                progressOf: (i) => _active
                    ? _phase(
                        PronunciationResult._metricStartMs +
                            PronunciationResult._metricStepMs * i,
                        PronunciationResult._metricMs,
                      )
                    : 1,
              ),
              // Figma `Hint` (`Hint#4863:0`) — the component grows 218 → 258 with
              // it: 20 gap + a 20-tall line.
              if (widget.hint != null) ...[
                const SizedBox(height: AppSpacing.s20),
                Text(
                  widget.hint!,
                  textAlign: TextAlign.center,
                  style: AppType.label1.r.copyWith(color: c.labelNormal),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Three-column metrics footer with vertical dividers.
class _MetricsFooter extends StatelessWidget {
  const _MetricsFooter({
    required this.metrics,
    required this.active,
    required this.border,
    required this.progressOf,
  });

  final List<PronunciationMetric> metrics;
  final bool active;

  /// 패널 테두리(전체 점수의 구간 색) — inactive 면 없음.
  final Color? border;

  /// 칸 i 의 카운트업 진행(0~1).
  final double Function(int i) progressOf;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final children = <Widget>[];
    for (int i = 0; i < metrics.length; i++) {
      if (i > 0) {
        children.add(
          SizedBox(
            height: 36,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: c.lineNormal,
            ),
          ),
        );
      }
      final m = metrics[i];
      final score = active ? m.score : null;
      children.add(
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                m.label,
                // 지표 이름은 자르지 않는다 — 「발음」인지 「유창성」인지 모르면
                // 그 아래 점수가 무슨 점수인지 모른다(전수감사 20건).
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppType.caption1.r.copyWith(color: c.labelNormal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                score == null
                    ? m.value
                    : '${(score.clamp(0, 100) * progressOf(i)).round()}%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: score == null
                    ? AppType.body1.sb
                    : AppType.body1.sb
                        .copyWith(color: c.bandText(pronunciationBand(score))),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12, vertical: AppSpacing.s12),
      decoration: BoxDecoration(
        // `Background/Surface/Alternative`, which is what every
        // `pronunciation_result` instance in Figma binds here (verified on
        // 4085:30478 / 4080:24687 and the standalone component 3569:27508).
        //
        // It used to be `backgroundNormalAlternative`. The two are the same
        // #252932 in Dark, so the mistake was invisible there — but in Light
        // they diverge (#FFFFFF vs #F6F6F7), and the strip drew a grey box on
        // screens where the design has none. Note the strip is *meant* to melt
        // into its parent on surfaces that share this token (the MyPage card,
        // screen/learning_main__pronunciation): there it reads as bare text
        // with two dividers, exactly as Figma renders it.
        color: c.backgroundSurfaceAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      // 테두리는 **안쪽** 1px(Figma stroke inside) — `foregroundDecoration` 이라 칸 폭·높이가
      // 안 바뀐다. inactive ↔ active 로 바뀌어도 패널 크기가 그대로다.
      foregroundDecoration: border == null
          ? null
          : BoxDecoration(
              border: Border.all(color: border!),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
      // 지표 3칸은 균등 격자가 디자인이다 — Figma `pronunciation_result` `2224:20997` 지표 행
      // `2224:20974`: 칸 3개 모두 FILL(92) + 1px 구분선(09-24 app designer 실측).
      child: FigmaEqualColumns(
        figmaNode: '2224:20974',
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Paints the semicircle gauge — five 20-point band segments (H4).
///
/// Geometry: frame 255×127.5, a true half circle whose centre sits on the
/// bottom edge. Ring 18 thick (outer radius 127.5). The arc runs 180° from the
/// left (score 0) clockwise to the right (score 100). Butt caps — no end cap.
class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.bands, required this.progress});

  /// `Score/1`~`Score/5`, read from the theme by the caller — a painter has no context.
  final List<Color> bands;

  /// 0–1 fraction of the 180° arc to fill.
  final double progress;

  static const double _stroke = 18;

  /// 조각 양 끝의 틈 — 0–1 범위의 0.4%(반원 180° 의 0.72°).
  static const double _inset = 0.004;

  /// 배경 조각 투명도 — Figma 는 도형에 18% 를 걸었다(색 변수가 아니라).
  static const double _trackAlpha = 0.18;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2 - _stroke / 2;
    final Offset center = Offset(size.width / 2, size.height);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    Paint pen(Color color) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.butt
      ..color = color;

    void arc(double from, double to, Paint paint) {
      if (to <= from) return;
      canvas.drawArc(
          arcRect, math.pi + from * math.pi, (to - from) * math.pi, false, paint);
    }

    final p = progress.clamp(0.0, 1.0);
    for (var i = 0; i < 5; i++) {
      final start = i * 0.2 + _inset;
      final end = (i + 1) * 0.2 - _inset;
      arc(start, end, pen(bands[i].withValues(alpha: _trackAlpha)));
      if (p > start) arc(start, math.min(p, end), pen(bands[i]));
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress ||
      // The colours are theme-dependent; without this the gauge would keep the
      // previous mode's ring until the score happened to change.
      !listEquals(old.bands, bands);
}

/// Gallery demo exposing both [PronunciationResult] states.
class PronunciationResultDemo extends StatelessWidget {
  const PronunciationResultDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      PronunciationMetric(label: 'Pronunciation', value: '96%', score: 96),
      PronunciationMetric(label: 'Fluency', value: '71%', score: 71),
      PronunciationMetric(label: 'Rhythm', value: '52%', score: 52),
    ];
    const emptyMetrics = [
      PronunciationMetric(label: 'Pronunciation', value: '-%'),
      PronunciationMetric(label: 'Fluency', value: '-%'),
      PronunciationMetric(label: 'Rhythm', value: '-%'),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          PronunciationResult(
            score: 72,
            metrics: metrics,
            state: PronunciationState.active,
          ),
          SizedBox(height: AppSpacing.s24),
          PronunciationResult(
            score: 0,
            metrics: emptyMetrics,
            state: PronunciationState.inactive,
          ),
        ],
      ),
    );
  }
}
