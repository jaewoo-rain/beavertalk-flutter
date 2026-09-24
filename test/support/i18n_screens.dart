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
import 'package:beavertalk/components/molecules/card_study.dart';
import 'package:beavertalk/screens/home/analysis_loading.dart';
import 'package:beavertalk/components/organisms/home_gnb.dart';
import 'package:beavertalk/components/organisms/home_header_mode.dart';
import 'package:beavertalk/components/molecules/banner.dart' as bn;
import 'package:beavertalk/components/icons/app_icons.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_streak.dart';
import 'package:beavertalk/mock/mock_data.dart';
import 'package:beavertalk/screens/classroom/widgets/assignment_badge.dart';

import 'package:beavertalk/screens/alarm/alarm_add.dart';
import 'package:beavertalk/screens/alarm/alarm_days.dart';
import 'package:beavertalk/components/organisms/bottom_sheet_alarm_add.dart';
import 'package:beavertalk/components/organisms/bottom_sheet_alarm_settings.dart' show AlarmPartner;
import 'package:beavertalk/components/molecules/row_alarm.dart';
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
import 'package:beavertalk/screens/mypage/avatar.dart';
import 'package:beavertalk/screens/home/streak_calendar.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/presentation/streak_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/screens/mypage/edit_nickname.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:beavertalk/components/molecules/card_bookmark.dart';
import 'package:beavertalk/components/molecules/card_native.dart';
import 'package:beavertalk/components/organisms/dialog_basic.dart';
import 'package:beavertalk/features/alarm/domain/entities/alarm.dart';
import 'package:beavertalk/features/normalcall/domain/entities/daily_status.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/screens/mypage/subscription_manage.dart';
import 'package:beavertalk/screens/overlays/subscription_overlays.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:beavertalk/screens/plans/winback_survey.dart';
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
    // 🔴 알람 추가 시트는 **펼침 둘을 다 연 상태**가 가장 길다(검수 세션 요청 2026-09-22) —
    //    접힌 상태만 보면 시트가 화면 높이를 넘치는 경우를 못 본다. 화면 하네스는 캐릭터
    //    프로바이더가 없어 로딩만 그리므로 시트를 직접 띄운다.
    'AlarmAddSheetOpen': () => Builder(builder: (ctx) => _alarmSheet(ctx)),
    // 「반복 선택」 하위 화면(Figma `6180:4764`, 09-24) — 가장 긴 요일 이름(ru 「Воскресенье」)에
    // 체크가 붙도록 일요일을 켜 둔다.
    'AlarmRepeatSheet': () => Builder(builder: (ctx) => _alarmSheet(ctx, repeat: true)),
    // 알람 목록 줄 — 목록 화면도 하네스에서 데이터가 없어 줄을 안 그린다. 켜짐·꺼짐 둘.
    // 분석 대기 준비 카드(Figma `6330:13219` Card/Preparing, 09-23) — 두 단계 상태를 모두
    // 그린다(저장 중·대기 / 완료·만드는 중). 가장 긴 문구는 de·ru 단계 이름이다.
    'AnalysisPreparingCard': () => const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              AnalysisPreparingCard(saved: false),
              SizedBox(height: 12),
              AnalysisPreparingCard(saved: true),
            ],
          ),
        ),
    // 분석 화면 학습 카드 2장(Figma `Card/Study` `6332:1699`, 09-23) — 활성과 비활성을
    // 함께 그린다(둘 다 제목만). 분석 화면 자체는 결과 데이터가 필요해 미등록.
    'AnalysisStudyCards': () => Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardStudy.learn(
                    title: l10n.practicePronunciation,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  CardStudy.challenge(
                    title: l10n.challengeTitle,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  CardStudy.learn(
                    title: l10n.practicePronunciation,
                  ),
                  const SizedBox(height: 12),
                  CardStudy.challenge(
                    title: l10n.challengeTitle,
                  ),
                ],
              ),
            );
          },
        ),
    // 분석 화면 현지인 짝(서버 premium P0-3 · Figma `Pair/Expression` `6177:28976`) — 기본 카드 +
    // 연결선 + 짝 카드. 뉘앙스가 긴 경우(줄바꿈)를 같이 본다. 분석 화면 자체는 미등록이라 부품을 건다.
    'AnalysisNativePair': () => Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardBookmark(
                    korean: '배고파요',
                    native: 'I am hungry',
                    bookmarked: false,
                    actionText: l10n.practice,
                    onAction: () {},
                  ),
                  const SizedBox(height: 8),
                  NativePairRow(
                    card: CardNative(
                      label: l10n.analysisNativeLabel,
                      expression: '뱃가죽이 등에 붙을 것 같아요',
                      gloss: 'So hungry my stomach touches my back — a playful way '
                          'friends say they are starving',
                      bookmarked: true,
                      actionText: l10n.practice,
                      onAction: () {},
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    // 「레벨 테스트 다시하기」 확인(Figma `6353:13378` Dialog-Basic variant2 · 09-24) — 본문이
    // 가장 긴 다이얼로그 축이라 30개 로케일 넘침을 본다.
    'LevelRetakeConfirm': () => Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            return Center(
              child: DialogBasic(
                title: l10n.levelRetakeTitle,
                description: l10n.levelRetakeBody,
                variant: DialogBasicVariant.twoVertical,
                primary: DialogAction(label: l10n.levelRetakeKeep, onPressed: () {}),
                secondary: DialogAction(label: l10n.levelRetakeConfirm, onPressed: () {}),
              ),
            );
          },
        ),
    'AlarmRows': () => Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            final loc = Localizations.localeOf(ctx).toString();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RowAlarmGroup(children: [
                  RowAlarm(
                    partner: 'Baba',
                    time: '8:00',
                    summary: l10n.alarmRowSummary(AlarmDays.summary(const [false, true, true, true, true, true, false], l10n, loc), l10n.homeModeLearn),
                    active: true,
                    onChanged: (_) {},
                  ),
                  RowAlarm(
                    partner: 'Bibi',
                    time: '21:30',
                    summary: l10n.alarmRowSummary(AlarmDays.summary(const [false, true, false, true, false, true, false], l10n, loc), l10n.callModeFreeTalk),
                    active: false,
                    onChanged: (_) {},
                  ),
                ]),
              ),
            );
          },
        ),
    'AlarmEmpty': () => const AlarmEmptyScreen(),
    'AlarmList': () => const AlarmListScreen(),
    // 알람 로딩(Figma `3489:4550`, 09-24 개편) — 목록 줄과 같은 틀의 스켈레톤 세 줄.
    'AlarmListLoading': () => const AlarmListLoading(),
    'Login': () => const LoginScreen(),
    'LoginForm': () => const LoginFormScreen(),
    'PasswordCode': () => const PasswordCodeScreen(),
    'PasswordComplete': () => const PasswordCompleteScreen(),
    'PasswordMethod': () => const PasswordMethodScreen(),
    'PasswordNew': () => const PasswordNewScreen(),
    'Signup': () => const SignupScreen(),
    'CallFinish': () => const CallFinishScreen(),
    // 통화 평가 시트(Figma `6249:13158`) — 화면이 첫 프레임 뒤에 띄우므로 하네스가
    // 못 볼 수 있다. 직접 띄운다. 카드는 아이콘뿐이고 버튼 둘이 세로로 쌓인다.
    'CallRatingSheet': () => const Align(
          alignment: Alignment.bottomCenter,
          child: CallRatingSheet(),
        ),
    // 파트너 변경(09-22 개편) — 목록+상세를 합친 한 화면. 데이터가 필요해 프로바이더를
    // 덮어 띄운다. 최악 조합 둘: 할인(가격 줄 + 정가 취소선 + -N% + 떠 있는 배너 +
    // 「구매 가능」 배지) · 구독으로 열림(보라 배지가 가장 긴 문구).
    // 학습 달력 — 오늘부터 사흘 연속 + 끊긴 하루(히어로 · 지표 · 얼굴 달력 · 통화 줄 모두 그린다).
    'StreakCalendar': () => ProviderScope(
          overrides: [
            // 최고 기록은 현재 연속(3)보다 긴 값 — 줄이 그려지는 최악 폭(ru·de) 확인용.
            bestStreakProvider.overrideWith((ref) async => 128),
            // 구서버 경로(달력 API 없음) — 통화 목록으로 센다.
            monthCalendarProvider.overrideWith((ref) async => null),
            callHistoryProvider.overrideWith((ref) async {
              final now = DateTime.now();
              CallSummary c(int id, int ago, String summary) => CallSummary(
                    callId: id,
                    character: const CallCharacterBrief(characterId: 1, name: 'Baba'),
                    callDate: DateTime(now.year, now.month, now.day, 10)
                        .subtract(Duration(days: ago)),
                    totalTime: 600,
                    summary: summary,
                  );
              return [
                c(1, 0, 'Talked about weekend hiking plans and favourite music'),
                c(2, 1, 'Ordering food'),
                c(3, 2, 'Weekend plans'),
                c(4, 5, ''),
              ];
            }),
          ],
          child: const StreakCalendarScreen(),
        ),
    'AvatarScreenDiscount': () => _avatarHost(discount: true),
    'AvatarScreenSubscription': () => _avatarHost(discount: false),
    'MyPage': () => const MyPageScreen(),
    'MyPageSettings': () => const MyPageSettingsScreen(),
    // The subscription manage screen (P2 redesign). With no server data in
    // the harness it renders the Free state; its copy is confirmed-English in
    // every locale, but the layout still gets audited at 320×640.
    'SubscriptionManage': () => const SubscriptionManageScreen(),
    // 단일 티어(09-22) 다섯 상태 — 상태마다 붙는 문구 길이가 달라 전부 등록한다
    // (배너·배지·행 라벨·주석이 가장 긴 조합을 놓치지 않게).
    for (final st in [
      SubscriptionState.activeMax,
      SubscriptionState.ending,
      SubscriptionState.grace,
      SubscriptionState.onHold,
      SubscriptionState.trial,
    ])
      'SubscriptionManage_${st.name}': () => _manageHost(st),
    // Free 카드의 「오늘 통화 시간」 행 — 서버 daily-status 를 알 때만 그린다(09-23 하루 합산).
    'SubscriptionManage_free_budget': () => _manageHost(
          SubscriptionState.free,
          daily: const DailyStatus(budgetSec: 300, usedSec: 120, remainingSec: 180),
        ),
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
    // 구독 오버레이 전장 — 가격·날짜가 든 시트(잘린 금액·날짜는 빈 값보다 나쁘다)와 해지·환불·
    // 결제 실패처럼 돈을 잃었다고 느끼는 순간의 시트를 빠짐없이 그린다. 같은 부품이라도
    // 문구 길이가 시트마다 달라 전부 넣는다.
    for (final o in SubscriptionOverlay.values)
      'Overlay_${o.name}': () => Align(
            alignment: Alignment.bottomCenter,
            child: subscriptionOverlayForTest(
              o,
              expiresAt: DateTime(2026, 6, 20),
              usage: (used: '5:00', limit: '5:00'),
              avatar: const SizedBox.square(dimension: 40),
              characterName: 'Baba',
              lastTopic: 'Weekend plans',
            ),
          ),
    // Premium 15분 종료 시트의 「오늘 마지막 통화」 문구(P19) — 위 전장은 기본(더 남음) 문구다.
    'Overlay_premiumCallEnded_today': () => Align(
          alignment: Alignment.bottomCenter,
          child: subscriptionOverlayForTest(
            SubscriptionOverlay.premiumCallEnded,
            usage: (used: '15:00', limit: '15:00'),
            avatar: const SizedBox.square(dimension: 40),
            characterName: 'Baba',
            lastTopic: 'Weekend plans',
            lastCallToday: true,
          ),
        ),
    // Premium 구독자 — Premium 카드에 「Current」 배지가 붙고 CTA 가 빠진다.
    'PlansCompare_premium': () => ProviderScope(
          overrides: [
            subscriptionStatusProvider.overrideWithValue(SubscriptionStatus(
              state: SubscriptionState.activeMax,
              tier: SubscriptionTier.max,
              expiresAt: DateTime(2026, 6, 20),
            )),
          ],
          child: const PlansCompareScreen(),
        ),
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
    // 홈 대화 모드 블록 — 서버 값 없이 l10n 만으로 그린다.
    'HomeGnbTalk': () => const Center(child: HomeGnb(course: HomeCourse.talk)),
    // 홈 헤더 — 토글(아이콘만) · 연속일 칩(숫자만) · 프로필이 한 줄에 선다. 세 자리
    // 연속일이 칩이 가장 넓은 경우다.
    'HomeHeaderMode': () => Center(
          child: HomeHeaderMode(
            mode: HomeMode.talk,
            onModeChanged: (_) {},
            streak: const CallStreak(days: 128, state: StreakState.done),
            onProfileTap: () {},
          ),
        ),
    // 숙제 배너 tone5 — 앞 아이콘 + 제목 한 줄(보조 줄 없음).
    'HomeworkBannerElevated': () => Builder(
          builder: (ctx) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: bn.Banner(
                tone: bn.BannerTone.elevated,
                title: AppLocalizations.of(ctx).hwHomeBannerDueTomorrow(3),
                leading: AppIcons.duoHomework(),
                onTap: () {},
              ),
            ),
          ),
        ),
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

/// 파트너 변경 화면을 데이터와 함께 띄운다. 무대에는 **미보유** 캐릭터(Rara)가 먼저 오르도록
/// 대표를 비워 둔다 — 첫 캐릭터가 무대에 선다.
Widget _avatarHost({required bool discount}) {
  Map<String, dynamic> row(int id, String name, {bool owned = false, bool sub = false}) => {
        'character_id': id,
        'product_key': name.toLowerCase(),
        'name': name,
        'price': '11.99',
        'effective_price': discount && !owned && !sub ? '5.99' : '11.99',
        'is_owned': owned,
        'is_unlocked': owned || sub,
        if (sub) 'unlock_source': 'subscription',
        if (discount && !owned && !sub)
          'active_discount': {
            'end_time': DateTime.now().toUtc().add(const Duration(days: 2, hours: 3)).toIso8601String(),
          },
        'tags': ['Savage', 'Blunt', 'Tsundere'],
        'description': 'A sharp-tongued master.',
        'background_story': 'Rara, a beaver famous for her flawless dams.',
      };
  final list = [
    for (final r in [
      row(10, 'Rara', sub: !discount),
      row(1, 'Baba', owned: true),
      row(11, 'Dudu'),
    ])
      CharacterDto.fromJson(r).toEntity(),
  ];
  return ProviderScope(
    overrides: [
      charactersProvider.overrideWith((ref) async => list),
      ownedCharactersProvider.overrideWith((ref) async => const []),
      myProfileProvider.overrideWith((ref) async => const Member(memberId: 1)),
    ],
    child: const AvatarScreen(),
  );
}

/// 구독 관리 화면을 한 상태로 띄운다. 날짜 행이 모두 값으로 차도록 세 날짜를 다 준다.
Widget _manageHost(SubscriptionState state, {DailyStatus? daily}) =>
    ProviderScope(
      overrides: [
        dailyStatusProvider.overrideWith((ref) async => daily),
        subscriptionStatusProvider.overrideWithValue(SubscriptionStatus(
          state: state,
          tier: SubscriptionTier.max,
          expiresAt: DateTime(2026, 6, 20),
          retryingUntil: DateTime(2026, 6, 25),
          pausedSince: DateTime(2026, 6, 26),
        )),
      ],
      child: const SubscriptionManageScreen(),
    );

/// 알람 추가 시트를 실제 모달과 같은 세로 제약으로 띄운다.
///
/// ⛔ `SingleChildScrollView` 로 감싸지 마라 — 세로 제약이 풀려 **넘칠 수가 없게** 된다.
///   실제 모달(`isScrollControlled: true`)은 화면 높이가 상한이다. 예전엔 감싸 두어서 요일
///   칩이 세로로 쌓여 88px 넘친 것을 시험이 못 잡았다(실기기 1보).
/// 본문은 **상대 펼침을 연 상태**가 가장 길다(검수 세션 요청 2026-09-22).
Widget _alarmSheet(BuildContext ctx, {bool repeat = false}) {
  final l10n = AppLocalizations.of(ctx);
  final loc = Localizations.localeOf(ctx).toString();
  final days = repeat
      ? const [true, true, false, true, false, true, false]
      : const [false, true, false, true, false, true, false];
  return Align(
    alignment: Alignment.bottomCenter,
    child: BottomSheetAlarmAdd(
      title: l10n.alarmAdd,
      cancelText: l10n.cancel,
      saveText: l10n.save,
      repeatLabel: l10n.repeat,
      partnerLabel: l10n.callPartner,
      hour24: 8,
      minute: 0,
      onTimeChanged: (_, _) {},
      days: days,
      dayNames: AlarmDays.fullNames(loc),
      repeatDoneText: l10n.selectComplete,
      repeatBackLabel: l10n.back,
      daysSummary: AlarmDays.summary(days, l10n, loc),
      onDayToggled: (_, _) {},
      partners: const [
        AlarmPartner(id: '1', name: 'Baba'),
        AlarmPartner(id: '2', name: 'Bibi'),
        AlarmPartner(id: '3', name: 'Popo'),
        AlarmPartner(id: '4', name: 'Rara'),
        AlarmPartner(id: '5', name: 'Dudu'),
      ],
      partner: '1',
      onPartnerChanged: (_) {},
      onSave: () {},
      onCancel: () {},
      initiallyOpen: const {AlarmAddPanel.partner},
      initiallyRepeat: repeat,
      // 모드 카드 두 장(Figma CallMode 6222:20794) — 자유 대화 선택 상태.
      callMode: AlarmCallMode.chat,
      onCallModeChanged: (_) {},
      learnModeTitle: l10n.homeModeLearn,
      learnModeSubtitle: l10n.alarmModeLearnSub,
      chatModeTitle: l10n.callModeFreeTalk,
      chatModeSubtitle: l10n.alarmModeChatSub,
    ),
  );
}
