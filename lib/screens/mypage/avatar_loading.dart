import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/organisms/gnb.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';

/// AvatarLoading — 캐릭터가 오기 전 `AvatarScreen`, Figma
/// `screen/main_change_avatar_loading` (`6255:13815`, 09-22 개편).
///
/// 새 배치(로스터 고정 · 무대 · 샘플 음성 · 이야기)를 **같은 자리에서** 막대로 든다 —
/// 데이터가 오면 막대만 글자로 바뀌고 아무것도 움직이지 않게.
/// GNB 제목(「아바타 변경」)은 서버 값이 아니라 그대로 쓴다.
/// CTA 는 그리지 않는다 — 무엇을 할지(사용·구매)는 캐릭터를 알아야 정해진다.
class AvatarLoading extends StatelessWidget {
  /// Creates the change-avatar loading screen.
  const AvatarLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
              title: l10n.changeAvatar,
              onBack: () => Navigator.maybePop(context)),
          Expanded(
            child: SkeletonShimmer(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Roster/Fixed — 타일 56·r14 다섯 개(정본 개수 — 주장이 아니다).
                    // 가로 스크롤 안에 둔다 — 실제 로스터와 같다. 다섯 개 + 여백은 360 이라
                    // 320dp 에서 그냥 Row 면 40px 넘친다(렌더 시험이 잡았다).
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                      child: Row(
                        children: [
                          for (var i = 0; i < 5; i++) ...[
                            if (i > 0) const SizedBox(width: 10),
                            const Skeleton.box(width: 56, height: 56),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Skeleton.circle(size: 140),
                    const SizedBox(height: 6),
                    const Skeleton.bar(width: 96, height: 20),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Skeleton.pill(width: 52, height: 24),
                        SizedBox(width: 6),
                        Skeleton.pill(width: 56, height: 24),
                        SizedBox(width: 6),
                        Skeleton.pill(width: 52, height: 24),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Skeleton.bar(width: 260, height: 14),
                    const SizedBox(height: 8),
                    const Skeleton.bar(width: 200, height: 14),
                    const SizedBox(height: 36),
                    ContentColumn(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SampleVoice — 카드 틀은 그대로, 안의 글자만 막대.
                          Container(
                            height: 48,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: context.c.backgroundElevatedAlternative,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Skeleton.circle(size: 24),
                                SizedBox(width: 10),
                                Skeleton.bar(width: 130, height: 14),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 이야기 네 줄 — 폭 null = 칸 가득.
                          const Skeleton.bar(height: 14),
                          const SizedBox(height: 8),
                          const Skeleton.bar(height: 14),
                          const SizedBox(height: 8),
                          const Skeleton.bar(height: 14),
                          const SizedBox(height: 8),
                          const Skeleton.bar(width: 200, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
