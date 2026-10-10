import 'package:flutter/widgets.dart';

import '../../../theme/app_color_tokens.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

/// 참여 흐름 각 단계의 제목 블록 — 제목 + 안내 한 줄, 간격 8.
///
/// 네 화면(A1~A4)이 같은 골격을 쓴다. 화면마다 손으로 짜면 줄간격이 어긋난다.
class JoinStepHeader extends StatelessWidget {
  /// 제목 블록을 만든다.
  const JoinStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  /// 단계 제목.
  final String title;

  /// 한 줄 안내.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppType.title3.b.copyWith(color: c.labelStrong)),
        const SizedBox(height: AppSpacing.s8),
        Text(subtitle, style: AppType.body1.r.copyWith(color: c.labelNormal)),
      ],
    );
  }
}
