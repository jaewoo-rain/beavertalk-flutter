import 'package:flutter/material.dart';

import '../../../../components/atoms/badge.dart' as bt;
import '../../../../components/atoms/pressable.dart';
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../theme/score_band.dart';
import '../../domain/entities/weak_sound_item.dart';
import '../../../../l10n/app_localizations.dart';

/// 취약 발음 목록의 카드 1장 — Figma `WeakSound/Card` (`6040:1496`).
///
/// 구조(실측 2026-09-22): 카드 r8 · padding 16 · 세로 gap 8
/// ```
/// Row(gap 12)  [Symbol 48×48 r8]  [이름 + 설명]
/// Meter(gap 6) [Bar 높이 8, r4 ─ 채움 + 목표 80 눈금]  [점수 13/11]
/// ```
/// 셰브런은 없다(09-22 디자인 확정) — 카드 전체가 눌리는 자리라 화살표가 중복이다.
///
/// 점수 색은 **W2 「구간 단색」**(09-24 사장님 확정 · 시안 `6387:3549`)이다 — 발음 결과 게이지와
/// 같은 다섯 구간(`scoreBand`, 20점씩). 바탕 = 구간 색 16% · 채움 = 구간 색 · 점수 글자 = 구간
/// 글자색. 옛 3단(80 이상 초록 · 60~79 주황 · 60 미만 빨강, `Status/*`)은 대체됐다.
class WeakSoundCard extends StatelessWidget {
  const WeakSoundCard({
    super.key,
    required this.item,
    this.recommended = false,
    this.showGoalLabel = false,
    this.onTap,
  });

  final WeakSoundItem item;

  /// 「추천」 배지. 목록당 1장에만 붙는다.
  final bool recommended;

  /// 「목표 80」 글자. 섹션의 **첫 카드에만** 붙인다 — 카드마다 반복하면 눈금이 글자에
  /// 묻혀 오히려 안 읽힌다(Figma 02번도 첫 장만 켜 뒀다).
  final bool showGoalLabel;

  final VoidCallback? onTap;

  /// 목표 점수 — 막대 눈금과 색 구간의 기준선.
  static const goal = 80;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: c.backgroundSurfaceAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ⛔ 점수를 이 줄에 같이 두지 마라. 이름·배지·점수 셋이 한 줄에서 폭을
            //   다투면 **이름이 가장 먼저 잘린다** — 「초성 ㄲ」이 「초…」가 됐다
            //   (2026-09-21 네팔어 실기기). 점수 문구는 언어마다 길이가 크게 다른데
            //   (「측정 전」 4자 vs `मापन भएको छैन` 14자) 이름은 어느 언어에서도
            //   줄일 수 없는 식별자다. 그래서 점수는 아래 줄로 내렸다.
            Row(
              children: [
                _Symbol(item: item),
                const SizedBox(width: AppSpacing.s12),
                Expanded(child: _Text(item: item, recommended: recommended)),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            // 점수와 막대를 **한 줄**에 둔다. 같은 값을 두 방식으로 보이는 것이라
            // 떨어뜨려 놓으면 카드 가운데가 비고 둘의 관계도 흐려진다.
            // ⚠ 여기서는 폭 다툼이 안 난다 — 막대가 Expanded 라 남는 폭을 먹을 뿐,
            //   점수를 밀어내지 않는다(제목 줄과 다른 점).
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _Bar(score: item.score, showGoalLabel: showGoalLabel),
                ),
                // Figma 실측 6px. AppSpacing 에 s6 토큰이 없어 raw 를 쓴다.
                const SizedBox(width: 6),
                _Score(score: item.score),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 왼쪽 48×48 타일 — 자모 한 글자, 규칙이면 기호.
class _Symbol extends StatelessWidget {
  const _Symbol({required this.item});

  final WeakSoundItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    // 규칙은 자모가 없다. `sound_key` 의 접두사를 떼어 「연음」 처럼 쓴다 — 서버가 주는
    // payload 의 symbol 은 목록 응답에 없고, 목록 때문에 과를 통째로 받아 올 수는 없다.
    final isRule = item.isRule;
    final glyph =
        isRule ? item.soundKey.replaceFirst('rule_', '') : (item.jamoTarget?.jamo ?? '');
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.primaryNormal10,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        glyph,
        style: (isRule ? AppType.label1 : AppType.title3)
            .b
            .copyWith(color: c.primaryForeground),
      ),
    );
  }
}

/// 이름 줄(+배지) + 설명 줄.
class _Text extends StatelessWidget {
  const _Text({required this.item, required this.recommended});

  final WeakSoundItem item;
  final bool recommended;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 가 아니라 Wrap 이다 — 폭이 모자라면 배지가 **다음 줄로 내려가고**
        // 이름은 안 잘린다. Row 였을 때는 배지가 자리를 먼저 차지해 이름이 잘렸다.
        // Figma 실측 간격 6px. AppSpacing 에 s6 토큰이 없어 raw 를 쓴다.
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              item.label,
              // 이름은 식별자라 줄이지 않는다. 한 줄에 안 들어가면 두 줄로 쓴다.
              maxLines: 2,
              style: AppType.body1.b.copyWith(color: c.labelStrong),
            ),
            if (item.isRule)
              bt.Badge(tone: bt.BadgeTone.neutral, label: l10n.wsRule),
            if (recommended)
              bt.Badge(tone: bt.BadgeTone.brand, label: l10n.wsRecommended),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          item.cardDesc,
          // 「소리 내는 법」이라 끝까지 읽혀야 뜻이 산다. 한 줄로 자르면 언어에 따라
          // 「혀끝을 윗잇몸에…」에서 끊긴다. 두 줄까지 주고 그래도 넘치면 줄인다.
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          // Figma 는 여기에 `Label/Caption`(Light #505050)을 쓴다. 앱에는 그 토큰이 없고
          // `labelNormal`(Light #333333)이 한 단계 진하다 — 대비가 더 나은 쪽으로 붙인다.
          style: AppType.label2.r.copyWith(color: c.labelNormal),
        ),
      ],
    );
  }
}

/// 오른쪽 점수 — 표본이 없으면 「측정 전」.
class _Score extends StatelessWidget {
  const _Score({required this.score});

  final int? score;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    if (score == null) {
      // ⛔ 0 점으로 그리지 마라. 「아직 안 재 봤다」와 「재 봤더니 0점」은 다른 사실이다.
      return Text(
        l10n.wsNotMeasured,
        style: AppType.label2.b.copyWith(color: c.labelAssistive),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // 점수는 막대 옆에 **작게** 둔다(Figma `MO/Label 2/Bold` + `MO/Caption 2/Medium`).
        // 같은 값을 막대가 이미 보여 주므로 숫자가 카드의 주인공이 되면 안 된다.
        // 값 · 「점」 모두 구간 글자색(`Score/n Text`, W2).
        Text('$score',
            style: AppType.label2.b
                .copyWith(color: c.scoreTextColor(scoreBand(score!)))),
        const SizedBox(width: 1),
        Text(l10n.wsPointsUnit,
            style: AppType.caption2.m
                .copyWith(color: c.scoreTextColor(scoreBand(score!)))),
      ],
    );
  }
}

/// 점수 막대 + 목표 눈금.
class _Bar extends StatelessWidget {
  const _Bar({required this.score, required this.showGoalLabel});

  final int? score;
  final bool showGoalLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final value = score;
    // 측정 전이면 바탕만 `Fill/Alternative` · 채움 없음. 재 봤으면 바탕 = 구간 색 16%.
    final band = value == null ? null : c.scoreColor(scoreBand(value));
    return SizedBox(
      // 막대 8 + 눈금이 위아래로 2씩 삐져나온다(눈금 높이 12). 고정 높이를 주지 않으면
      // 눈금이 잘리거나 카드 높이가 카드마다 달라진다.
      height: 12,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 2,
                left: 0,
                right: 0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: band == null
                        ? c.fillAlternative
                        : band.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              if (value != null && value > 0)
                Positioned(
                  top: 2,
                  left: 0,
                  child: Container(
                    // 길이 = 폭 × 점수/100(Figma 는 그라디언트로 근사 — 코드는 점수 그대로).
                    width: w * (value.clamp(0, 100) / 100),
                    height: 8,
                    decoration: BoxDecoration(
                      color: band,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              // 목표 눈금 2×12 · `Label/Assistive` · 폭의 80% 위치(Figma 모바일 269 폭 x=214 ·
              // 09-24 정정 — 예전 Figma 는 x=241 로 잘못 놓여 있었다). 막대와 세로 가운데.
              Positioned(
                top: 0,
                left: w * (WeakSoundCard.goal / 100) - 1,
                child: Container(
                  width: 2,
                  height: 12,
                  decoration: BoxDecoration(
                    color: c.labelAssistive,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              if (showGoalLabel)
                Positioned(
                  top: 14,
                  left: w * (WeakSoundCard.goal / 100) - 18,
                  child: Text(
                    l10n.wsGoalOnly(WeakSoundCard.goal),
                    style: AppType.caption2.m.copyWith(color: c.labelNormal),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

