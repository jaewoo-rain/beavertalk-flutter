import 'package:flutter/material.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../features/normalcall/domain/entities/call_course.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../components/atoms/button.dart';
import '../../components/molecules/stacked_button_pair.dart';

/// Onboarding — completion. Figma `screen/onborading_done` (`2291:21311`).
///
/// Reached after the final onboarding step ([OnboardingReasonScreen]) submits
/// the draft. A centered beaver avatar with a welcome heading + sub copy, and a
/// pinned stacked button pair: a secondary "Home" on top (drops to the now-onboarded
/// home) and a primary 「레벨 테스트」 below (jumps straight into the call flow — a new
/// member has no level, so the server routes this call to the level test).
class OnboardingDoneScreen extends StatelessWidget {
  /// Creates the onboarding completion screen.
  const OnboardingDoneScreen({super.key});

  /// Reveals the home view behind this screen (AuthGate now shows home since
  /// onboarding is complete).
  void _goHome(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);

  /// Jumps straight into the call flow, clearing this screen from the stack.
  ///
  /// ⭐ 홈 전화 버튼과 같이 **`auto` 코스**다(사장님 결정 2026-09-13) — 서버가 진도로
  ///   코스를 정한다. 제품 진입점은 전부 auto 로 모은다; 옛 경로(call_type 미전송)는
  ///   개발자 도구 «일반 통화» 와 수신·레벨테스트만 쓴다.
  void _startCall(BuildContext context) => Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.callLoading,
        (r) => r.isFirst,
        arguments: const CourseCallRequest(CallCourse.auto),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ContentColumn.narrow(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Beaver avatar — Figma 120px circle.
                  Container(
                    width: AppSpacing.s120,
                    height: AppSpacing.s120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: beaverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Figma: avatar → text frame gap = 20px (ds-space-screen-x).
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    l10n.onboardingDoneTitle,
                    textAlign: TextAlign.center,
                    style: AppType.heading2.sb.copyWith(color: context.c.labelStrong),
                  ),
                  // Figma: heading → sub copy gap = 8px (ds-space-xs).
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    l10n.onboardingDoneSubtitle,
                    textAlign: TextAlign.center,
                    style: AppType.label1.r
                        .copyWith(color: context.c.labelNormal),
                  ),
                ],
              ),
            ),
          ),
          // Figma `BottomSheet` 두 버튼(Mobile `3360:48` · Tablet `5281:1142`): pt 12, px 20.
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: AppSpacing.s12),
            // 버튼 쌍은 항상 세로(09-24 사장님 확정) — 「홈」 위 · 「레벨 테스트」 아래, 각자 전폭 ·
            // 간격 12. 옛 가로 1:1 에서는 긴 언어가 반 폭 안에서 줄을 바꿨다(전수조사 H).
            child: StackedButtonPair(
              top: Button(
                type: BtnType.secondaryOutline,
                size: BtnSize.s60,
                text: l10n.home,
                onPressed: () => _goHome(context),
              ),
              bottom: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                // 사용자 지시(09-24): 「'비버와 통화하기'도 '레벨 테스트'로」 — P30(「지금 통화하기」)
                // 번복. 가입 직후 회원은 레벨이 없어 이 통화가 서버에서 레벨테스트로 라우팅된다.
                text: l10n.onboardingLevelTestCta,
                onPressed: () => _startCall(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
