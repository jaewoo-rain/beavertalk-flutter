// 로케일 검사용 **공용 화면 목록**.
//
// 두 시험이 같은 목록을 본다 — `i18n_overflow_test`(넘침)와
// `i18n_clip_test`(잘림). 목록이 갈라지면 한쪽만 보는 화면이 생기고, 그 화면은
// 아무도 안 보는 화면이 된다(2026-09-21 「초성 ㄲ → 초…」 가 정확히 그랬다).
// 화면을 추가할 곳은 **여기 한 곳뿐이다.**
import 'package:flutter/material.dart';

import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/screens/classroom/assignment_detail.dart';
import 'package:beavertalk/screens/classroom/assignment_list.dart';
import 'package:beavertalk/screens/classroom/join_code.dart';
import 'package:beavertalk/screens/classroom/join_consent.dart';
import 'package:beavertalk/screens/classroom/join_done.dart';
import 'package:beavertalk/screens/classroom/join_profile.dart';
import 'package:beavertalk/components/molecules/card_homework.dart';
import 'package:beavertalk/components/organisms/home_gnb.dart';
import 'package:beavertalk/mock/mock_data.dart';
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
import 'package:beavertalk/screens/weak_sound/weak_sounds.dart';
import 'package:beavertalk/features/weak_sound/presentation/sound_key_arg.dart';
import 'package:beavertalk/features/weak_sound/domain/entities/weak_sound_item.dart';
import 'package:beavertalk/features/weak_sound/presentation/widgets/weak_sound_card.dart';
import 'package:beavertalk/components/organisms/bottom_sheet.dart' show SheetAction;
import 'package:beavertalk/components/organisms/bottom_sheet_content.dart';

/// 로케일 검사 대상 화면 전량.
Map<String, Widget Function()> i18nScreens() {
  final screens = <String, Widget Function()>{
    // 취약 발음 — 2026-09-21 까지 이 목록에 없었다. 그래서 「초성 ㄲ」이
    // 「초…」로 잘리는 동안 이 시험은 한 번도 그 화면을 보지 않았다.
    'WeakSounds': () => const WeakSoundsScreen(),
    'MissingSoundKey': () => const MissingSoundKey(),
    // 🔴 목록 화면은 이 하네스에서 데이터가 없어 **카드를 안 그린다.** 카드를 직접 띄운다.
    //    최악 조합: 규칙 + 추천 배지 + 목표 글자(측정됨) / 「측정 전」(언어마다 길이 차가 가장 크다).
    'WeakSoundCards': () => const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              WeakSoundCard(
                item: WeakSoundItem(
                  soundKey: 'rule_비음화',
                  label: '비음화',
                  cardDesc: '받침 ㄱ·ㄷ·ㅂ 뒤에 ㄴ·ㅁ이 오면 ㅇ·ㄴ·ㅁ으로 바뀌어요',
                  type: 'rule',
                  score: 62,
                ),
                recommended: true,
                showGoalLabel: true,
              ),
              SizedBox(height: 8),
              WeakSoundCard(
                item: WeakSoundItem(
                  soundKey: 'onset_ㄲ',
                  label: '초성 ㄲ',
                  cardDesc: '목을 조이고 세게 터뜨려요',
                  type: 'sound',
                ),
              ),
            ],
          ),
        ),
    // E6 — 평가 단계 마이크 권한 시트(Figma `6093:14239`). 버튼 둘이 세로로 쌓인다.
    'WsMicPermissionSheet': () => Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            return Align(
              alignment: Alignment.bottomCenter,
              child: BottomSheetContent(
                title: l10n.micPermissionNeededTitle,
                body: l10n.wsMicPermissionBody,
                primaryAction: SheetAction(label: l10n.openSettings, onPressed: () {}),
                secondaryAction: SheetAction(label: l10n.ctaNotNow, onPressed: () {}),
              ),
            );
          },
        ),
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
    // 🔴 홈 학습 현황은 **한 줄로 잘리는 텍스트가 셋**이라 로케일 길이에 가장
    //    민감하다. 화면(HomeScreen)은 이 하네스에서 프로바이더가 없어 못 그리니
    //    블록을 직접 띄운다 — 세 변형 전부. 문구가 변형마다 다르기 때문이다.
    'HomeGnbExpression': () =>
        const Center(child: HomeGnb(course: mockHomeCourse)),
    'HomeGnbFreetalk': () =>
        const Center(child: HomeGnb(course: mockHomeCourseFreetalk)),
    'HomeGnbNoLevel': () =>
        const Center(child: HomeGnb(course: mockHomeCourseNoLevel)),
  };
  return screens;
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
