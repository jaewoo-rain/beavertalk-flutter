import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../components/molecules/banner.dart' as bn;
import '../../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../../features/classroom/presentation/assignment_display.dart';
import '../../../features/classroom/presentation/classroom_providers.dart';
import '../../../l10n/app_localizations.dart';

/// 홈의 숙제 진입 배너 — Figma `Banner/HomeworkEntry`(`5730:37940`).
///
/// **홈에서 숙제로 가는 유일한 길이다.** 하단 내비에 숙제 탭이 없어(구현계획
/// §2.4) 이 배너가 사라지면 남는 경로는 마이페이지 하나뿐이다.
///
/// 급한 것이 없으면 아무것도 그리지 않는다 — 늘 떠 있는 배너는 홈의 주인공인
/// 아바타를 밀어낸다.
class HomeworkHomeBanner extends ConsumerWidget {
  /// 배너를 만든다.
  const HomeworkHomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(myAssignmentsProvider).valueOrNull;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final open = items
        .where((a) => a.status != AssignmentStatus.done)
        .toList(growable: false);

    final int overdue = open.where((a) => a.overdue).length;
    final int dueSoon = open
        .where((a) => !a.overdue && daysUntilDue(a.dueAt, now) <= 1)
        .length;

    // 미제출이 있으면 그것부터 말한다. 마감 임박보다 급한 소식이다.
    final (String title, bn.BannerTone tone) = switch ((overdue, dueSoon)) {
      (final o, _) when o > 0 => (
        l10n.hwHomeBannerOverdue(o),
        bn.BannerTone.danger,
      ),
      (_, final d) when d > 0 => (
        l10n.hwHomeBannerDueTomorrow(d),
        bn.BannerTone.brand,
      ),
      _ => ('', bn.BannerTone.neutral),
    };
    if (title.isEmpty) return const SizedBox.shrink();

    return bn.Banner(
      tone: tone,
      title: title,
      // 시안의 배너는 한 줄이지만 공용 컴포넌트는 보조 줄을 요구한다. 새 문구를
      // 만들지 않고 목록으로 간다는 뜻의 기존 문안을 쓴다.
      sub: l10n.hwJoinDoneCta,
      onTap: () => Navigator.of(context).pushNamed(Routes.assignments),
    );
  }
}
