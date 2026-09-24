import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/score_gauge_painter.dart';
import '../../components/molecules/stacked_button_pair.dart';
import '../../components/organisms/gnb.dart' show GnbBackArrow;
import '../../features/pronunciation/domain/phoneme_diagram.dart';
import '../../features/weak_sound/domain/entities/sound_lesson.dart';
import '../../features/weak_sound/domain/entities/sound_result.dart';
import '../../features/weak_sound/presentation/weak_sound_providers.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/score_band.dart';
import '../../l10n/app_localizations.dart';

/// 학습 결과 — Figma `17 · learn/result` (`6118:12274`), 예외는 E5(하락)·E8(첫 측정).
///
/// 시안 B-1 확정본(2026-09-19): **양 끝 라벨을 단 막대 하나**로 학습 전 → 학습 후를
/// 보인다. 게이지·별점·Note 상자는 전부 폐기됐다.
///
/// 막대에 눈금이 둘이다 — 「학습 전」과 「목표 80」. 점수 하나만 크게 띄우면 좋아진 것인지
/// 알 수 없고, 목표가 없으면 84 가 잘한 건지 알 수 없다.
class LearnResultScreen extends ConsumerWidget {
  const LearnResultScreen({
    super.key,
    required this.soundKey,
    required this.result,
  });

  final String soundKey;
  final SoundResult result;

  /// 목표 점수 — 목록 카드의 눈금과 같은 값이어야 한다.
  static const goal = 80;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final lesson = ref.watch(soundLessonProvider(soundKey)).valueOrNull;
    // 뒤로가기는 **목록으로** 간다 — 화살표든 시스템 back 이든 같다.
    //
    // 막지 않으면 system back 이 한 칸만 pop 해서 방금 끝낸 문장 단계로 되돌아간다.
    // 평가를 마친 사람이 가고 싶은 곳은 갱신된 점수가 있는 목록이다.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _toList(context);
      },
      child: Scaffold(
        backgroundColor: c.backgroundSurfaceAlternative,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s20,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _toList(context),
                        child: GnbBackArrow(size: 28, color: c.labelStrong),
                      ),
                    ],
                  ),
                ),
              ),
              if (result.dropped || result.isFirstMeasure)
                Expanded(
                  child: _GaugeBody(lesson: lesson, result: result),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20,
                      AppSpacing.s16,
                      AppSpacing.s20,
                      AppSpacing.s24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          result.label,
                          textAlign: TextAlign.center,
                          style: AppType.label1.b.copyWith(
                            color: c.primaryForeground,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          l10n.wsLearnDone,
                          textAlign: TextAlign.center,
                          style: AppType.title2.b.copyWith(
                            color: c.labelStrong,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s24),
                        _ScoreLine(result: result),
                        const SizedBox(height: AppSpacing.s16),
                        _ProgressBar(result: result),
                        const SizedBox(height: AppSpacing.s28),
                        if (lesson != null) _SoundCard(lesson: lesson),
                        const SizedBox(height: AppSpacing.s24),
                        _Summary(lesson: lesson, result: result),
                      ],
                    ),
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s20,
                    AppSpacing.s8,
                    AppSpacing.s20,
                    AppSpacing.s8,
                  ),
                  // 버튼 쌍 세로(09-24 사장님 확정) — E5 · E8 · 17 모두 「다시 평가하기」 위 ·
                  // 「목록으로」 아래, 각자 전폭 · 간격 12.
                  child: StackedButtonPair(
                    top: Button(
                      type: BtnType.secondaryFill,
                      size: BtnSize.s60,
                      text: l10n.wsRetest,
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed(
                            Routes.weakSoundTest,
                            arguments: soundKey,
                          ),
                    ),
                    bottom: Button(
                      type: BtnType.primaryFill,
                      size: BtnSize.s60,
                      text: l10n.wsToList,
                      onPressed: () => _toList(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 목록까지 한 번에 돌아간다.
  ///
  /// 학습 4단계가 스택에 쌓여 있어 `pop` 한 번으로는 평가 화면으로 떨어진다. 방금 끝낸
  /// 단계로 되돌아가는 것은 아무도 원하지 않는다.
  void _toList(BuildContext context) => Navigator.of(
    context,
  ).popUntil((r) => r.settings.name == Routes.weakSounds || r.isFirst);
}

/// E5(점수 하락) · E8(첫 측정) — Figma Mobile `6040:36345` · `6044:36388` · Tablet `6278:43555` ·
/// `6278:43597`(09-24 사장님이 직접 다시 디자인 · 「이걸로 가자」).
///
/// 제목 묶음 → 반원 게이지(H4) → 한 일 3줄. 세로 **가운데** 정렬 · 간격 24 · 여백 위 8 · 좌우 20 ·
/// 아래 24. 17(점수 오름)의 B-1(점수 한 줄 + 학습 전→후 막대 + 조음 카드)과 달리 「+N」 알약 ·
/// 막대 · 목표 눈금 · 조음 카드가 **없다**.
class _GaugeBody extends StatelessWidget {
  const _GaugeBody({required this.lesson, required this.result});

  final SoundLesson? lesson;
  final SoundResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ContentColumn(
          gutter: AppSpacing.s20,
          padding: const EdgeInsets.only(
            top: AppSpacing.s8,
            bottom: AppSpacing.s24,
          ),
          child: ConstrainedBox(
            // 화면이 남으면 가운데, 모자라면 스크롤 — 여백 위 8 + 아래 24 를 뺀 높이.
            constraints: BoxConstraints(
              minHeight: math.max(
                0,
                box.maxHeight - AppSpacing.s8 - AppSpacing.s24,
              ),
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 제목 묶음(17 과 같은 글자) — 14 Bold Primary/Foreground · 6 · 28 Bold.
                  Text(
                    result.label,
                    textAlign: TextAlign.center,
                    style: AppType.label1.b.copyWith(
                      color: c.primaryForeground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.wsLearnDone,
                    textAlign: TextAlign.center,
                    style: AppType.title2.b.copyWith(color: c.labelStrong),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Center(child: _ResultGauge(score: result.after)),
                  const SizedBox(height: AppSpacing.s24),
                  _Summary(lesson: lesson, result: result),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 반원 게이지 240×132 — 링은 위 240×120, 숫자 묶음은 아래 끝(y 80~132)에 가로 가운데.
///
/// 숫자 40 Bold + 「점」 18 Bold · 간격 2 · 기준선 맞춤 · 둘 다 `Score/n Text`. 채워지는 애니메이션은
/// 발음 결과 게이지와 같다(900ms easeOutCubic · 0 부터 카운트업 · 처음 1회 · 애니메이션 끄기면
/// 최종값 · 숫자 색은 최종 구간색 고정).
class _ResultGauge extends StatefulWidget {
  const _ResultGauge({required this.score});

  final int score;

  @override
  State<_ResultGauge> createState() => _ResultGaugeState();
}

class _ResultGaugeState extends State<_ResultGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.maybeDisableAnimationsOf(context) == true) {
      _anim.value = 1;
    } else {
      _anim.forward();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final score = widget.score.clamp(0, 100);
    final text = c.scoreTextColor(scoreBand(score));
    // 숫자 40 — 앱 타이포에 40 이 없어 Title 1(32)을 Figma 크기 40 · 줄높이 52 로 늘린다.
    final numberStyle = AppType.title1.b.copyWith(
      fontSize: 40,
      height: 52 / 40,
      color: text,
    );
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_anim.value);
        final shown = score * t;
        return SizedBox(
          width: 240,
          height: 132,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: CustomPaint(
                  size: const Size(240, 120),
                  painter: ScoreGaugePainter(
                    bands: [for (var i = 1; i <= 5; i++) c.scoreColor(i)],
                    progress: shown / 100,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('${shown.round()}', style: numberStyle),
                    const SizedBox(width: 2),
                    Text(
                      l10n.wsPointsUnit,
                      style: AppType.headline1.b.copyWith(color: text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 「84 점 +22」.
class _ScoreLine extends StatelessWidget {
  const _ScoreLine({required this.result});

  final SoundResult result;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final delta = result.delta;
    final band = c.scoreTextColor(scoreBand(result.after));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // 숫자 · 「점」 = 점수 구간 글자색(09-24 사장님 · Figma 17 `6118:12274` 84 → Score/5 Text).
        Text(
          '${result.after}',
          style: AppType.display1.b.copyWith(color: band),
        ),
        const SizedBox(width: AppSpacing.s4),
        Text(
          l10n.wsPointsUnit,
          style: AppType.heading2.b.copyWith(color: band),
        ),
        if (delta != null && delta != 0) ...[
          const SizedBox(width: AppSpacing.s8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: AppSpacing.s2,
            ),
            decoration: BoxDecoration(
              // 하락(E5)도 숨기지 않는다. 숨기면 다음 번 점수가 왜 낮은지 설명할 길이 없다.
              color: delta > 0 ? c.primaryNormal14 : c.statusNegative6,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              delta > 0 ? '+$delta' : '$delta',
              style: AppType.label2.b.copyWith(
                color: delta > 0 ? c.primaryForeground : c.statusNegative,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 학습 전 → 학습 후 막대(시안 B-1). 눈금 둘 + 양 끝 라벨.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.result});

  final SoundResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final after = result.after.clamp(0, 100);
    final before = result.before;
    return Column(
      children: [
        SizedBox(
          height: 16,
          child: LayoutBuilder(
            builder: (context, box) {
              final w = box.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 5,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: c.fillAlternative,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 0,
                    child: Container(
                      width: w * (after / 100),
                      height: 6,
                      decoration: BoxDecoration(
                        // 채움 = 점수 구간 색(09-24 사장님 — 80 이상 statusPositive ·
                        // 미만 primaryNormal 규칙 폐기). 바탕 · 눈금 · 알약은 그대로.
                        color: c.scoreColor(scoreBand(after)),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // 학습 전 눈금. 첫 측정(E8)이면 그릴 것이 없다.
                  if (before != null)
                    _Tick(
                      left: w * (before.clamp(0, 100) / 100),
                      color: c.labelStrong,
                    ),
                  _Tick(
                    left: w * (LearnResultScreen.goal / 100),
                    color: c.labelAssistive,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // 첫 측정이면 「학습 전 —점」이 아니라 사실을 쓴다(Figma E8).
              before == null
                  ? l10n.wsFirstMeasure
                  : l10n.wsBeforePoints(before),
              style: AppType.label2.m.copyWith(color: c.labelNormal),
            ),
            Text(
              l10n.wsGoalPoints(LearnResultScreen.goal),
              style: AppType.label2.m.copyWith(color: c.labelNormal),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick({required this.left, required this.color});

  final double left;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned(
    top: 0,
    left: left - 1,
    child: Container(
      width: 2,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    ),
  );
}

/// 조음카드 — 방금 배운 소리를 한 번 더 붙잡아 둔다.
///
/// 규칙 항목은 도해가 없어 카드를 생략한다(빈 상자를 남기지 않는다).
class _SoundCard extends StatelessWidget {
  const _SoundCard({required this.lesson});

  final SoundLesson lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final target = lesson.jamoTarget;
    final diagram = target == null
        ? null
        : diagramForJamo(target.jamo, isCoda: target.isCoda);
    if (diagram == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.s8),
            child: Image.asset(diagram.asset, width: 88, fit: BoxFit.contain),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.wsSoundOf(lesson.label),
                  style: AppType.body1.b.copyWith(color: c.labelStrong),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  l10n.wsResultTip(lesson.cardDesc),
                  style: AppType.label2.r.copyWith(color: c.labelNormal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 이번 학습에서 한 일 — 연습 단계는 점수가 아니라 **완료 여부**다.
class _Summary extends StatelessWidget {
  const _Summary({required this.lesson, required this.result});

  final SoundLesson? lesson;
  final SoundResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final words = lesson?.words.length ?? 0;
    final chunks = lesson?.sentence.chunks.length ?? 0;
    return Column(
      children: [
        if (words > 0) _Row(label: l10n.wsWordsRepeated(words), done: true),
        if (chunks > 0) _Row(label: l10n.wsChunksRepeated(chunks), done: true),
        _Row(label: l10n.wsFinalTest, value: l10n.wsPoints(result.after)),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, this.done = false, this.value});

  final String label;
  final bool done;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppType.body2.r.copyWith(color: c.labelNormal),
            ),
          ),
          if (value != null)
            Text(value!, style: AppType.body1.b.copyWith(color: c.labelStrong))
          else if (done)
            Row(
              children: [
                Icon(Icons.check, size: 16, color: c.primaryForeground),
                const SizedBox(width: AppSpacing.s4),
                Text(
                  l10n.wsDone,
                  style: AppType.label2.b.copyWith(color: c.primaryForeground),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
