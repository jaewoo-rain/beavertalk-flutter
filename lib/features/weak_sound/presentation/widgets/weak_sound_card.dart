import 'package:flutter/material.dart';

import '../../../../components/atoms/badge.dart' as bt;
import '../../../../components/atoms/pressable.dart';
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/entities/weak_sound_item.dart';

/// 취약 발음 목록의 카드 1장 — Figma `WeakSound/Card` (`6040:1496`).
///
/// 구조(실측): 카드 r8 · padding 16 · 세로 gap 18
/// ```
/// Row(gap 12)  [Symbol 48×48 r8]  [이름 + 설명]  [점수]  [chevron 20]
/// Bar(높이 6, r3)  ─ 채움 + 목표 80 눈금
/// ```
///
/// 점수 색은 **구간**이다([_level]): 80 이상 초록 · 60~79 주황 · 60 미만 빨강.
/// 80 이 기준선인 이유는 막대 위 「목표 80」 눈금과 같은 값이기 때문이다 — 두 값이 갈리면
/// 눈금 왼쪽인데 초록인 카드가 생긴다.
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
            Row(
              children: [
                _Symbol(item: item),
                const SizedBox(width: AppSpacing.s12),
                Expanded(child: _Text(item: item, recommended: recommended)),
                const SizedBox(width: AppSpacing.s12),
                _Score(score: item.score),
                const SizedBox(width: AppSpacing.s2),
                Icon(Icons.chevron_right, size: 20, color: c.labelAssistive),
              ],
            ),
            const SizedBox(height: 18),
            _Bar(score: item.score, showGoalLabel: showGoalLabel),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.body1.b.copyWith(color: c.labelStrong),
              ),
            ),
            if (item.isRule) ...[
              // Figma 실측 6px. AppSpacing 에 s6 토큰이 없어 raw 를 쓴다.
              const SizedBox(width: 6),
              const bt.Badge(tone: bt.BadgeTone.neutral, label: '규칙'),
            ],
            if (recommended) ...[
              const SizedBox(width: 6),
              const bt.Badge(tone: bt.BadgeTone.brand, label: '추천'),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          item.cardDesc,
          maxLines: 1,
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
    if (score == null) {
      // ⛔ 0 점으로 그리지 마라. 「아직 안 재 봤다」와 「재 봤더니 0점」은 다른 사실이다.
      return Text(
        '측정 전',
        style: AppType.label1.m.copyWith(color: c.labelAssistive),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('$score', style: AppType.headline1.b.copyWith(color: c.labelStrong)),
        const SizedBox(width: AppSpacing.s2),
        Text('점', style: AppType.label1.m.copyWith(color: c.labelNormal)),
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
    final c = context.c;
    final value = score;
    return SizedBox(
      // 막대 6 + 눈금이 위아래로 3씩 삐져나온다(눈금 높이 12). 고정 높이를 주지 않으면
      // 눈금이 잘리거나 카드 높이가 카드마다 달라진다.
      height: 12,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 3,
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
              if (value != null && value > 0)
                Positioned(
                  top: 3,
                  left: 0,
                  child: Container(
                    width: w * (value.clamp(0, 100) / 100),
                    height: 6,
                    decoration: BoxDecoration(
                      color: _levelColor(c, value),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
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
                    '목표 ${WeakSoundCard.goal}',
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

/// 점수 구간 색 — 눈금(80)과 같은 기준선을 쓴다.
Color _levelColor(AppColorTokens c, int score) {
  if (score >= WeakSoundCard.goal) return c.statusPositive;
  if (score >= 60) return c.statusCautionary;
  return c.statusNegative;
}
