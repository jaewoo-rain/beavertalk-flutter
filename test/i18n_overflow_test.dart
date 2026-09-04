// Per-locale overflow audit: pumps text-dense screens in every supported locale
// at a narrow phone width (320dp) and fails if any RenderFlex/text overflow is
// reported during layout. This is the exhaustive guard for the "translation made
// text overflow" class of bugs — long endonyms/strings (de, fi, ru, mn, …) must
// wrap/ellipsize, never overflow.
//
// Scope note: covers screens that pump standalone without route args or
// persistent timers. Timer/stream-heavy live screens (call, call_loading,
// analysis_loading, home) are exercised structurally via the shared component
// hardening (Button/Gnb/CardBox/SegmentedTabs/… are all Flexible+ellipsis), not
// pumped here, to keep this audit deterministic.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/screens/classroom/assignment_detail.dart';
import 'package:beavertalk/screens/classroom/assignment_list.dart';
import 'package:beavertalk/screens/classroom/join_code.dart';
import 'package:beavertalk/screens/classroom/join_consent.dart';
import 'package:beavertalk/screens/classroom/join_done.dart';
import 'package:beavertalk/screens/classroom/join_profile.dart';
import 'package:beavertalk/components/molecules/card_homework.dart';
import 'package:beavertalk/screens/classroom/widgets/assignment_badge.dart';

import 'package:beavertalk/screens/alarm/alarm_add.dart';
import 'package:beavertalk/screens/alarm/alarm_empty.dart';
import 'package:beavertalk/screens/alarm/alarm_list.dart';
import 'package:beavertalk/screens/auth/login.dart';
import 'package:beavertalk/screens/auth/login_form.dart';
import 'package:beavertalk/screens/auth/password_code.dart';
import 'package:beavertalk/screens/auth/password_complete.dart';
import 'package:beavertalk/screens/auth/password_method.dart';
import 'package:beavertalk/screens/auth/password_new.dart';
import 'package:beavertalk/screens/auth/signup.dart';
import 'package:beavertalk/screens/home/call_finish.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/screens/mypage/avatar_detail.dart';
import 'package:beavertalk/screens/mypage/edit_nickname.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:beavertalk/screens/plans/plan_change.dart';
import 'package:beavertalk/screens/plans/plans_compare.dart';
import 'package:beavertalk/screens/plans/purchase_flow.dart';
import 'package:beavertalk/screens/onboarding/onboarding_done.dart';
import 'package:beavertalk/screens/onboarding/onboarding_language.dart';
import 'package:beavertalk/screens/onboarding/onboarding_name.dart';
import 'package:beavertalk/screens/onboarding/onboarding_reason.dart';
import 'package:beavertalk/screens/record/record_empty.dart';
import 'package:beavertalk/screens/home/learning_call_main.dart';
import 'package:beavertalk/screens/home/learning_call_main_loading.dart';
import 'package:beavertalk/screens/record/record_list.dart';
import 'package:beavertalk/screens/system/mic_denied.dart';
import 'package:beavertalk/screens/system/network_error.dart';
import 'package:beavertalk/screens/system/permission.dart';

void main() {
  final screens = <String, Widget Function()>{
    'AlarmAdd': () => const AlarmAddScreen(),
    'AlarmEmpty': () => const AlarmEmptyScreen(),
    'AlarmList': () => const AlarmListScreen(),
    'Login': () => const LoginScreen(),
    'LoginForm': () => const LoginFormScreen(),
    'PasswordCode': () => const PasswordCodeScreen(),
    'PasswordComplete': () => const PasswordCompleteScreen(),
    'PasswordMethod': () => const PasswordMethodScreen(),
    'PasswordNew': () => const PasswordNewScreen(),
    'Signup': () => const SignupScreen(),
    'CallFinish': () => const CallFinishScreen(),
    // Worst case for the detail screen's name row: name + the long
    // "Available to purchase" badge + a "-N%" marker, all on one line.
    'AvatarDetailDiscount': () => const AvatarDetailScreen(
          state: AvatarDetailState.unownedDiscount,
          name: 'Baba',
          tags: ['Savage', 'Blunt', 'Tsundere'],
          summary: 'A sharp-tongued master.',
          description: 'Baba, a beaver famous for his flawless dams.',
          price: '₩4,900',
          discountPrice: '₩2,450',
          discountPercent: 50,
        ),
    // 구독 축의 최악 케이스: 이름 + "Included with Max"(소유 배지보다 길다) + "-N%"
    // 마커가 한 줄에, 푸터에는 버튼이 둘. 소유 상태는 배지 하나에 버튼도 하나라
    // 여기서 안 걸린다.
    'AvatarDetailSubscription': () => const AvatarDetailScreen(
          state: AvatarDetailState.subscriptionUnused,
          name: 'Baba',
          tags: ['Savage', 'Blunt', 'Tsundere'],
          summary: 'A sharp-tongued master.',
          description: 'Baba, a beaver famous for his flawless dams.',
          price: '₩4,900',
          discountPrice: '₩2,450',
          discountPercent: 50,
        ),
    'AvatarDetailOwned': () => const AvatarDetailScreen(
          state: AvatarDetailState.ownedUnused,
          name: 'Baba',
          tags: ['Savage', 'Blunt', 'Tsundere'],
          summary: 'A sharp-tongued master.',
          description: 'Baba, a beaver famous for his flawless dams.',
        ),
    'MyPage': () => const MyPageScreen(),
    'MyPageSettings': () => const MyPageSettingsScreen(),
    // The subscription manage screen (P2 redesign). With no server data in
    // the harness it renders the Free state; its copy is confirmed-English in
    // every locale, but the layout still gets audited at 320×640.
    'SubscriptionManage': () => const SubscriptionManageScreen(),
    // P3 conversion screens (this run's l10n pass). PurchaseProcessing is
    // excluded (it fires the mock purchase and navigates by named route);
    // the Pro success screen is excluded too — its one-time-offer timer
    // (Future.delayed 800ms) is exactly the timer-heavy case the scope note
    // rules out, and the Max variant covers the identical layout.
    'PaywallPro': () => const PaywallScreen(variant: PaywallVariant.pro),
    'PaywallProLimit': () =>
        const PaywallScreen(variant: PaywallVariant.proLimit),
    'PaywallMax': () => const PaywallScreen(variant: PaywallVariant.max),
    'PlansCompare': () => const PlansCompareScreen(),
    'PlanChangeUpgrade': () =>
        const PlanChangeScreen(direction: PlanChangeDirection.upgrade),
    'PlanChangeDowngrade': () =>
        const PlanChangeScreen(direction: PlanChangeDirection.downgrade),
    'PurchaseSuccessMax': () =>
        const PurchaseSuccessScreen(tier: SubscriptionTier.max),
    'PlansError': () => const PlansErrorScreen(),
    'WinbackSurvey': () => const WinbackSurveyScreen(),
    'EditNickname': () => const EditNicknameScreen(),
    'OnboardingDone': () => const OnboardingDoneScreen(),
    'OnboardingLanguage': () => const OnboardingLanguageScreen(),
    'OnboardingName': () => const OnboardingNameScreen(),
    'OnboardingReason': () => const OnboardingReasonScreen(),
    'RecordEmpty': () => const RecordEmptyScreen(),
    'RecordList': () => const RecordListScreen(),
    'RecordArchiveTab': () => const RecordListScreen(initialTab: 1),
    // Densest screen in the app — three tables and a chart, all fixed-width
    // number columns. Narrow locales break here first.
    'LearningCallMain': () => const LearningCallMainScreen(),
    'LearningCallMainLoading': () => const LearningCallMainLoadingScreen(),
    'MicDenied': () => const MicDeniedScreen(),
    'NetworkError': () => const NetworkErrorScreen(),
    'Permission': () => const PermissionScreen(),
    // 숙제 — 참여 흐름과 목록·상세. 문안이 새로 들어온 영역이라 독일어에서
    // 가장 먼저 깨진다(구현계획 §3.4 「폭 검수 기준 언어 = 독일어」).
    'HwJoinCode': () => const JoinCodeScreen(),
    'HwJoinProfile': () => const JoinProfileScreen(),
    'HwJoinConsent': () => const JoinConsentScreen(),
    'HwJoinDone': () => const JoinDoneScreen(),
    'HwAssignmentList': () => const AssignmentListScreen(),
    'HwAssignmentDetail': () => AssignmentDetailScreen(
      assignment: _assignment(status: AssignmentStatus.notStarted),
    ),
    // 🔴 **끝낸 과제도 본다.** 미수행 상태만 검사하면 완료 배지·수치·체크 칩이
    //    한 번도 안 그려진다 — 2026-09-04 오버플로가 정확히 그 상태에서 났다.
    'HwAssignmentDetailDone': () => AssignmentDetailScreen(
      assignment: _assignment(status: AssignmentStatus.done, done: true),
    ),
    // 🔴 목록 화면은 이 하네스에서 **데이터가 없어 카드를 안 그린다.** 카드를 직접
    //    띄워야 검사가 성립한다 — 활동 이름이 로케일마다 크게 다른 곳이 여기다
    //    (ko 「발음」 2자 ↔ de 「Aussprache」 10자).
    'HwHomeworkCard': () => Builder(
      builder: (ctx) {
        final a = _assignment(status: AssignmentStatus.done, done: true);
        return Center(
          child: CardHomework(
            chapterLabel: AppLocalizations.of(ctx).hwChapterLabel('03'),
            title: a.classroomName,
            dimmed: true,
            badge: assignmentBadge(ctx, a),
            countLabel: '${a.completedActivityCount}/${a.activityCount}',
            chips: [
              for (final act in a.activities)
                HomeworkCardChip(
                  activityLabel(ctx, act),
                  done: a.isActivityDone(act),
                ),
            ],
          ),
        );
      },
    ),
  };

  // Narrow phone (iPhone SE / small Android). Horizontal overflow surfaces here.
  //
  // Height is a REAL phone's, not a tall canvas. It used to be 1400, which is
  // nearly twice any handset: anything that grew vertically simply fit, so this
  // audit only ever proved the horizontal half of its own claim. 640 is the
  // iPhone SE class logical height.
  const narrow = Size(320, 640);

  testWidgets('no text overflow across all 30 locales @ 320×640', (tester) async {
    tester.view.physicalSize = narrow;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final overflows = <String>[];

    for (final locale in AppLocalizations.supportedLocales) {
      for (final entry in screens.entries) {
        // Capture layout-time overflow errors (they're reported via
        // FlutterError.onError, not thrown), while ignoring unrelated render
        // errors from missing route args / providers in this harness.
        final captured = <String>[];
        final prev = FlutterError.onError;
        FlutterError.onError = (details) {
          final s = details.toString();
          if (s.contains('overflowed') || s.contains('RenderFlex')) {
            // The banner line says nothing useful; the line that names the
            // direction and pixel count is what tells you whether this is a
            // width problem (translation too long) or a height problem
            // (content taller than the phone).
            final detail = s
                .split('\n')
                .firstWhere((l) => l.contains('overflowed'),
                    orElse: () => s.split('\n').first)
                .trim();
            captured.add(detail);
          }
        };
        try {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: entry.value(),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 32));
        } catch (_) {
          // Non-overflow render error (route args/plugins/providers) — ignore;
          // this audit only cares about layout overflow.
        } finally {
          FlutterError.onError = prev;
        }
        // Drain any thrown exception so it doesn't fail the test for non-overflow
        // reasons; overflow is tracked via `captured` above.
        tester.takeException();
        if (captured.isNotEmpty) {
          overflows.add('${locale.toLanguageTag()} · ${entry.key}: '
              '${captured.first}');
        }
        // Clear the tree between cases.
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }

    if (overflows.isNotEmpty) {
      fail('Overflow in ${overflows.length} (locale × screen) case(s):\n'
          '${overflows.join('\n')}');
    }
  });
}

/// 검사용 과제 1건. 활동 셋을 다 담는다 — 칩이 가장 많이 붙는 경우다.
ClassroomAssignment _assignment({
  required AssignmentStatus status,
  bool done = false,
}) {
  return ClassroomAssignment(
    assignmentId: 1,
    classroomName: 'TOPIK 1 A',
    grade: 1,
    chapter: 3,
    activities: const [
      AssignmentActivity.speaking,
      AssignmentActivity.conversation,
      AssignmentActivity.workbook,
    ],
    itemIds: const [],
    dueAt: DateTime(2026, 12, 31),
    overdue: false,
    status: status,
    speakingScored: done ? 38 : 0,
    speakingPassed: done ? 37 : null,
    speakingTotal: done ? 38 : null,
    conversationMet: done ? 0 : null,
    conversationTotal: done ? 10 : null,
    workbookOpenedAt: done ? DateTime(2026, 9, 4) : null,
  );
}
