import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../features/normalcall/domain/entities/call_streak.dart';
import '../../features/normalcall/domain/entities/home_mode.dart';

export '../../features/normalcall/domain/entities/home_mode.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../atoms/pressable.dart';
import '../atoms/skeleton.dart';
import '../icons/app_icons.dart';

/// 홈 헤더 — Figma `Home/Header-Mode` (`6177:29151`). 높이 56.
///
/// ```
/// [📖|💬]                         [🔥 12] (👤)
///  모드 토글(아이콘만)             연속일 칩  프로필
/// ```
/// 좌우 여백은 [ContentColumn] — 같은 화면의 숙제 배너와 한 밴드에 선다.
class HomeHeaderMode extends StatelessWidget {
  /// 헤더를 만든다.
  const HomeHeaderMode({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.streak,
    required this.onProfileTap,
    this.showStreak = true,
    this.onStreakTap,
  });

  /// 지금 모드.
  final HomeMode mode;

  /// 토글을 눌렀을 때.
  final ValueChanged<HomeMode> onModeChanged;

  /// 연속일. null 이면 로딩(`Chip-Streak` state=loading).
  final CallStreak? streak;

  /// false 면 칩 자리를 비운다(조회 실패).
  final bool showStreak;

  /// 칩을 눌렀을 때(학습 달력). null 이면 누를 수 없다.
  final VoidCallback? onStreakTap;

  /// 프로필 → 마이페이지.
  final VoidCallback onProfileTap;

  /// 정본 높이.
  static const double height = 56;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    return ConstrainedBox(
      // 최소 56 — 칩의 숫자는 글자라 배율이 크면 자란다. 고정 높이는 그걸 자른다.
      constraints: const BoxConstraints(minHeight: height),
      child: ContentColumn(
        child: Row(
          children: [
            _ModeToggle(mode: mode, onChanged: onModeChanged),
            const Spacer(),
            if (showStreak) ...[
              _StreakChip(streak: streak, onTap: onStreakTap),
              const SizedBox(width: 10),
            ],
            Semantics(
              button: true,
              label: l10n.myPage,
              child: Pressable(
                onTap: onProfileTap,
                child: Container(
                  width: AppSpacing.s28,
                  height: AppSpacing.s28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.backgroundNormalAlternative,
                  ),
                  child: AppIcons.profile(size: 20, color: c.labelAssistive),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `Toggle-Mode/Expand` (`6225:4315`) — 88×34 알약, 칸 40×28 둘. **아이콘만** 있다
/// (사용자 지시: 글자 없음). 그래서 각 칸의 이름은 스크린리더에만 준다.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final HomeMode mode;
  final ValueChanged<HomeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    Widget seg(HomeMode m, AppIconBuilder icon, String label) {
      final on = mode == m;
      return Semantics(
        button: true,
        selected: on,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: on ? null : () => onChanged(m),
          child: Container(
            width: 40,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on ? c.primaryNormal : null,
              borderRadius: BorderRadius.circular(999),
            ),
            child: icon(
              size: 16,
              // Figma `Icon/Alternative` — 앱에 icon 토큰이 없어 같은 값의 label 토큰으로 붙인다.
              color: on ? c.primaryOnPrimary : c.labelAlternative,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.backgroundNormalAlternative,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          seg(HomeMode.learn, AppIcons.book, l10n.homeModeLearn),
          const SizedBox(width: 2),
          seg(HomeMode.talk, AppIcons.chat, l10n.homeModeTalk),
        ],
      ),
    );
  }
}

/// `Chip-Streak` (`6177:29119`) — 불꽃 + 연속일 숫자. 변형 넷:
/// done(오늘 함) · pending(어제까지 이어짐) · broken(끊김) · loading.
///
/// 숫자만 보인다. 「12일 연속」 같은 문장은 [Semantics] 로 준다 — 칩에 문장을 넣으면
/// 언어마다 폭이 크게 달라져 헤더 한 줄에서 토글과 다툰다.
class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak, this.onTap});

  final CallStreak? streak;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final s = streak;
    if (s == null) {
      // state=loading — 칩 모양 그대로 셔머. 폭은 두 자리 숫자 기준(56).
      return const SkeletonShimmer(child: Skeleton.pill(width: 56, height: 30));
    }
    final (Color face, Color flame, Color count) = switch (s.state) {
      StreakState.done => (
        c.accentStreakSurface,
        c.accentStreak,
        c.accentStreak,
      ),
      StreakState.pending => (c.fillNormal, c.accentStreak, c.labelAlternative),
      StreakState.broken => (c.fillNormal, c.labelAssistive, c.labelAssistive),
    };
    final chip = Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 11, 5),
      decoration: BoxDecoration(
        color: face,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcons.flameFill(size: 16, color: flame),
          const SizedBox(width: AppSpacing.s4),
          Text(
            '${s.days}',
            style: AppType.label1.b.copyWith(
              color: count,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
    return Semantics(
      button: onTap != null,
      label: AppLocalizations.of(context).homeStreakDays(s.days),
      excludeSemantics: true,
      child: onTap == null ? chip : Pressable(onTap: onTap, child: chip),
    );
  }
}
