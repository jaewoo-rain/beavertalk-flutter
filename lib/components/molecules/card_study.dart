import 'package:flutter/widgets.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/pressable.dart';
import '../icons/app_icons.dart';

/// 분석 화면 학습 진입 카드 — Figma `Card/Study`(`6332:1699` 세트) 실측.
///
/// 335×**Hug**(68) · r16 · `Background/Surface/Alternative` · 패딩 16 · 간격 12.
/// [ duo 아이콘 36 ] [ 제목 Headline 2 Bold ] [ chevron 20 ] — 부제 없음(09-23 사장님: 활성·비활성 모두 삭제).
///
/// 2026-09-23 「복습하기」 채움 버튼과 「발음 챌린지 도전하기」 외곽선 버튼을 이 카드 둘로
/// 바꿨다(시안 A 채택 · 「발음 학습하기」 개명).
///
/// **[onTap] 이 null 이면 비활성이다**(`state=disabled`) — 글자·화살표는
/// `Label/Disabled`, 아이콘은 40% 로 낮춘다. 두 카드 모두 이번 통화의 새로 배운 표현이
/// 있어야 열린다.
///
/// **카드 전체가 탭 영역이다.** 우측 화살표는 장식이다.
/// 높이는 아이콘 36 + 패딩 32 = 68(Figma 두 변이 모두 Hug 68). 제목이 두 줄이면 자란다.
class CardStudy extends StatelessWidget {
  /// 카드를 만든다.
  const CardStudy({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  /// 발음 학습하기 — `duo-bubble`.
  factory CardStudy.learn({
    Key? key,
    required String title,
    VoidCallback? onTap,
  }) => CardStudy(
    key: key,
    icon: AppIcons.duoBubble(size: 36),
    title: title,
    onTap: onTap,
  );

  /// 발음 챌린지 — `duo-target`.
  factory CardStudy.challenge({
    Key? key,
    required String title,
    VoidCallback? onTap,
  }) => CardStudy(
    key: key,
    icon: AppIcons.duoTarget(size: 36),
    title: title,
    onTap: onTap,
  );

  /// 36 크기 duo 아이콘.
  final Widget icon;

  /// 제목.
  final String title;

  /// 카드 탭. null 이면 비활성.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            color: c.backgroundSurfaceAlternative,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Opacity(opacity: enabled ? 1 : 0.4, child: icon),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                // 줄바꿈 허용 — de·hi·ne·km 등은 1.1배 글꼴에서 한 줄에 안 들어간다
                // (clip 360 실측 24건). 제목을 자르지 않고 카드가 자란다.
                child: Text(
                  title,
                  style: AppType.headline2.b.copyWith(
                    color: enabled ? c.labelStrong : c.labelDisabled,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              AppIcons.arrowRight(
                size: 20,
                color: enabled ? c.labelNeutral : c.labelDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
