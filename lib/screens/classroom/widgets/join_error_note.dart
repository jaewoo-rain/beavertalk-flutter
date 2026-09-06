import 'package:flutter/widgets.dart';

import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../components/icons/app_icons.dart';

/// 참여 실패 안내 — 코드 오타·만료·정원 초과.
///
/// **오류 화면을 따로 만들지 않는다.** 셋 다 학습자가 그 자리에서 고치거나
/// 선생님에게 물으면 끝나는 상황이라, 입력하던 화면을 유지한 채 이 블록만
/// 띄운다. 화면을 갈아끼우면 방금 친 코드가 사라진다.
///
/// 시안에 없던 요소다(2026-09-02 신설) — 참여 5화면에 오류 분기가 0 이었다.
class JoinErrorNote extends StatelessWidget {
  /// 안내 블록을 만든다.
  const JoinErrorNote({super.key, required this.title, required this.body});

  /// 무엇이 잘못됐는지.
  final String title;

  /// 무엇을 하면 되는지. 「확인해 주세요」처럼 다음 행동을 적는다.
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.statusNegative6,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcons.alert(size: 20, color: c.accentForegroundRed),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppType.label1.b.copyWith(
                    color: c.accentForegroundRed,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  body,
                  style: AppType.caption1.r.copyWith(color: c.labelNormal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
