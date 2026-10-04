import 'package:flutter/material.dart';

import '../../../../components/atoms/button.dart';
import '../../../../components/layout/need_based_rows.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../screens/home/learning_summary.dart';
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

/// `Card/RetryPack`(Figma `6564:15409`) — 리포트의 「자주 틀린 소리」 카드(A5 · M1).
///
/// 10-03 사용자: 「통화 분석 페이지에서 발음 학습을 마치고 나서, 해당 학습에서 여러번 틀린
/// 발음을 따로 모아서 학습할 수 있게 하고 싶어」(PM-DEC-333/341). 제목 · 설명 · 자모 타일
/// (최대 3) · 버튼. 빈 목록이면 부르는 쪽이 카드째 숨긴다.
class RetryPackCard extends StatelessWidget {
  /// Creates the retry-pack card.
  const RetryPackCard({super.key, required this.sounds, required this.onStart});

  /// 서버가 고른 소리(최대 3 · 비어 있지 않음).
  final List<RetrySound> sounds;

  /// 「모아서 연습하기」.
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.wsRetryPackTitle(sounds.length),
            style: AppType.headline1.b.copyWith(color: c.labelStrong),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            l10n.wsRetryPackBody,
            style: AppType.caption1.r.copyWith(color: c.labelNormal),
          ),
          const SizedBox(height: AppSpacing.s12),
          // 칸이 모두 FILL 인 균등 격자(Figma `6564:15412` Sounds · 자식 flex 1).
          FigmaEqualColumns(
            figmaNode: '6564:15412',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < sounds.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.s8),
                  Expanded(child: _SoundTile(sound: sounds[i])),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Button(
            type: BtnType.secondaryElevated,
            size: BtnSize.s60,
            text: l10n.wsRetryPackCta,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

/// `Sound/…`(Figma `6564:15413`) — 자모 칸 48 + 라벨.
class _SoundTile extends StatelessWidget {
  const _SoundTile({required this.sound});

  final RetrySound sound;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Primary/Normal-10 — 목록 카드(WeakSound/Card)의 자모 칸과 같은 면.
            color: c.primaryNormal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            retrySymbolOf(sound),
            style: AppType.title3.b.copyWith(color: c.primaryNormal),
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          sound.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppType.caption1.r.copyWith(color: c.labelNormal),
        ),
      ],
    );
  }
}

/// 타일에 그릴 글자 — `onset_ㅊ`·`coda_ㄹ` 은 자모, 그 밖(규칙 등)은 라벨 첫 글자.
String retrySymbolOf(RetrySound s) {
  for (final prefix in const ['onset_', 'coda_']) {
    if (s.soundKey.startsWith(prefix) && s.soundKey.length > prefix.length) {
      return s.soundKey.substring(prefix.length);
    }
  }
  return s.label.isEmpty ? '·' : s.label.characters.first;
}
