import 'package:flutter/material.dart';

import '../../../../components/organisms/gnb.dart' show GnbBackArrow;
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// 학습 4단계 공통 헤더 — Figma `Learn/Header` (`6040:34651`), 실측 높이 89.
///
/// 닫기 + 제목 한 줄, 그 아래 4칸 스텝퍼(이해·단어·문장·평가). 사용자 지시로 단계 표시를
/// GNB 안에 넣었다 — 본문에 「2단계 단어 학습」 같은 제목을 또 두면 같은 말이 두 번 나온다.
///
/// 스텝퍼는 **막대 + 글자**다. 지나온 단계와 현재 단계를 같은 Primary 로 칠하고(지나온
/// 길은 켜진 채로 남는다) 앞으로 올 단계만 회색이다.
class LearnHeader extends StatelessWidget implements PreferredSizeWidget {
  const LearnHeader({
    super.key,
    required this.title,
    required this.step,
    this.onBack,
  });

  /// 소리 이름 — 「받침 ㄹ」.
  final String title;

  /// 1~4.
  final int step;

  /// 뒤로 가기. null 이면 그냥 pop 한다.
  ///
  /// ⛔ 예전엔 X(닫기)였다. 누르면 **학습 전체가 닫히는 것처럼 보이는데 실제로는 한 단계
  ///    뒤로 갈 뿐**이라 아이콘이 거짓말을 하고 있었다(2026-09-21 사용자 지적).
  final VoidCallback? onBack;

  /// 단계 이름 4개. 언어에 따라 달라지므로 **const 로 둘 수 없다** — build 에서 만든다.
  static List<String> _labels(AppLocalizations l10n) => [
        l10n.wsStepUnderstand,
        l10n.wsStepWords,
        l10n.wsStepSentence,
        l10n.wsStepTest,
      ];

  @override
  Size get preferredSize => const Size.fromHeight(89);

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final labels = _labels(AppLocalizations.of(context));
    return Container(
      color: c.backgroundSurfaceAlternative,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: GnbBackArrow(size: 28, color: c.labelStrong),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.body1.b.copyWith(color: c.labelStrong),
                    ),
                  ),
                  // 제목을 가운데 두기 위한 균형추. 숨김 처리하면 오토레이아웃이 무너진다.
                  const SizedBox(width: 28, height: 28),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: Row(
              children: [
                for (var i = 0; i < labels.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _Step(
                      label: labels[i],
                      active: i + 1 <= step,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: active ? c.primaryNormal : c.fillNormal,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: AppType.caption2.m.copyWith(
            color: active ? c.primaryForeground : c.labelNormal,
          ),
        ),
      ],
    );
  }
}
