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
import '../../components/layout/need_based_rows.dart';

/// Onboarding — completion. Figma `screen/onborading_done` (`2291:21311`).
///
/// Reached after the final onboarding step ([OnboardingReasonScreen]) submits
/// the draft. A centered beaver avatar with a welcome heading + sub copy, and a
/// pinned two-button row: a secondary "Home" (drops to the now-onboarded home)
/// and a primary "Call now" (jumps straight into the call flow).
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
          // Figma `BottomSheet` two-button row: pt 12, px 20, gap 10.
          ContentColumn(
            padding: const EdgeInsets.only(top: AppSpacing.s12, bottom: AppSpacing.s12),
            // Figma `I3360:55;175:18146`: 같은 폭 두 버튼(FILL·FILL, gap 10). 긴 언어에서 한쪽이
            // 한 줄에 안 들어가면 세로로 쌓는다(주요 버튼 위) — 1:1 안에서 「지금 통화하기」 가
            // 줄을 바꾸고 옆 「홈」 은 87px 가 남았다(09-24 전수조사 H · app designer 합의).
            child: EqualButtonPair(
              secondary: Button(
                type: BtnType.secondaryOutline,
                size: BtnSize.s60,
                text: l10n.home,
                onPressed: () => _goHome(context),
              ),
              primary: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: l10n.callNow,
                onPressed: () => _startCall(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
