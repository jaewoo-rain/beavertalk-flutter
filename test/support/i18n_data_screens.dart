// 데이터가 **찬 상태**로 띄우는 화면들 — i18n · 레이아웃 게이트가 보는 목록([i18nScreens])에 합쳐진다.
//
// 왜 따로 두나(09-24 사용자 결정 「등록해서 오늘 같은 레이아웃 결함을 자동으로 잡아줘.」):
// 인자·데이터 없이 등록된 화면은 로딩 · 오류 · 빈 상태만 그려져, 데이터가 있어야 생기는 행
// (머리 행 부가 문구 · 목록 줄 · 카드 머리)이 게이트 밖이었다. 학습 결과 화면의 「음소 단위 ·
// N회 시도」 몰림이 그렇게 빠져나갔다(통합 담당 보고서 04).
//
// 가짜 데이터는 **실제로 길게 나오는 조건**으로 만든다 — 긴 이메일 · 닉네임 · 반 이름 · 요약,
// 부가 문구가 붙는 머리 행, 여러 줄 목록, 레벨 있는/없는 회원, Premium/Free 처럼 화면이 갈리는
// 상태를 각각 등록한다. 새로 만드는 데이터 화면도 여기에 데이터판을 함께 등록한다(R11).
import 'package:beavertalk/components/organisms/bottom_sheet_alarm_settings.dart' show Meridiem;
import 'package:beavertalk/features/alarm/domain/entities/alarm.dart';
import 'package:beavertalk/features/alarm/presentation/providers/alarm_list_controller.dart';
import 'package:beavertalk/features/alarm/presentation/providers/alarm_providers.dart';
import 'package:beavertalk/features/auth/domain/entities/accent_breakdown.dart';
import 'package:beavertalk/features/auth/domain/entities/level_summary.dart';
import 'package:beavertalk/features/auth/domain/entities/member.dart';
import 'package:beavertalk/features/auth/presentation/providers/auth_providers.dart' show signInProviderProvider;
import 'package:beavertalk/features/auth/presentation/providers/my_profile_provider.dart';
import 'package:beavertalk/features/auth/presentation/providers/signup_draft_provider.dart';
import 'package:beavertalk/features/character/data/models/character_dto.dart';
import 'package:beavertalk/features/character/presentation/providers/character_providers.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_assignment.dart';
import 'package:beavertalk/features/classroom/domain/entities/classroom_membership.dart';
import 'package:beavertalk/features/classroom/presentation/classroom_providers.dart';
import 'package:beavertalk/features/classroom/presentation/join_draft_provider.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/domain/entities/cur_me.dart';
import 'package:beavertalk/features/normalcall/domain/entities/pron_summary.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_providers.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/features/subscription/domain/subscription_status_resolver.dart';
import 'package:beavertalk/features/subscription/presentation/providers/subscription_state_providers.dart';
import 'package:beavertalk/features/weak_sound/domain/entities/weak_sound_item.dart';
import 'package:beavertalk/features/weak_sound/presentation/weak_sound_providers.dart';
import 'package:beavertalk/screens/alarm/alarm_add.dart';
import 'package:beavertalk/screens/alarm/alarm_list.dart';
import 'package:beavertalk/screens/alarm/alarm_models.dart';
import 'package:beavertalk/screens/classroom/assignment_list.dart';
import 'package:beavertalk/screens/classroom/join_consent.dart';
import 'package:beavertalk/screens/classroom/join_done.dart';
import 'package:beavertalk/screens/home/call_finish.dart';
import 'package:beavertalk/screens/mypage/edit_nickname.dart';
import 'package:beavertalk/screens/mypage/mypage.dart';
import 'package:beavertalk/screens/mypage/settings.dart';
import 'package:beavertalk/screens/onboarding/onboarding_reason.dart';
import 'package:beavertalk/screens/record/record_list.dart';
import 'package:beavertalk/screens/weak_sound/weak_sounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── 공용 가짜 데이터 ────────────────────────────────────────────────────────

/// 긴 값 — 이메일 · 닉네임 · 반 이름 · 요약은 실제로 이만큼 온다.
const _longEmail = 'bt.qa.international.student.0924@example-university.ac.kr';
const _longName = 'Maximilian-Alexander';
const _longClass = '전북대학교 언어교육원 한국어 중급 2반 (월·수·금 저녁)';

final _now = DateTime.now();

final _character = CharacterDto.fromJson(const {
  'character_id': 10,
  'product_key': 'rara',
  'name': 'Rara',
  'price': '11.99',
  'effective_price': '11.99',
  'is_owned': true,
  'is_unlocked': true,
  'tags': ['Savage', 'Blunt', 'Tsundere'],
  'description': 'A sharp-tongued master.',
  'background_story': 'Rara, a beaver famous for her flawless dams.',
}).toEntity();

Member _member() => Member(
      memberId: 1,
      email: _longEmail,
      name: _longName,
      language: 'en',
      targetLanguage: 'ko',
      characterId: 10,
      onboardingCompleted: true,
      createdAt: DateTime(2026, 3, 1),
    );

CallSummary _call(int id, int ago, String summary, {int minutes = 12}) => CallSummary(
      callId: id,
      character: const CallCharacterBrief(characterId: 10, name: 'Rara'),
      callDate: DateTime(_now.year, _now.month, _now.day, 21, 40)
          .subtract(Duration(days: ago)),
      totalTime: minutes * 60 + 37,
      summary: summary,
    );

final _calls = [
  _call(101, 0, 'Talked about weekend hiking plans, favourite Korean dramas and how to order at a café'),
  _call(102, 0, 'Ordering food at a restaurant', minutes: 3),
  _call(103, 1, 'Asking for directions to the subway station near the university library'),
  _call(104, 3, ''),
  _call(105, 6, 'Job interview practice — introducing yourself politely'),
];

class _FakeCallList extends CallListNotifier {
  @override
  Future<CallListState> build() async =>
      CallListState(items: _calls, hasMore: false);
}

class _FakeAlarmList extends AlarmListController {
  @override
  Future<List<Alarm>> build() async => const [
        Alarm(id: 1, hour: 8, minute: 0, isAm: true, days: [false, true, true, true, true, true, false],
            characterId: 10, characterName: 'Rara', callMode: AlarmCallMode.learn),
        Alarm(id: 2, hour: 9, minute: 30, isAm: false, days: [true, false, false, false, false, false, true],
            characterId: 11, characterName: 'Dudu', callMode: AlarmCallMode.chat, active: false),
        Alarm(id: 3, hour: 12, minute: 15, isAm: false, days: [false, true, false, true, false, true, false],
            characterId: 12, characterName: 'Maximilian', callMode: AlarmCallMode.chat),
      ];
}

class _FakeSignupDraft extends SignupDraftNotifier {
  @override
  SignupDraft build() => const SignupDraft(
        language: 'de',
        name: _longName,
        selectedReasonIds: {'travel', 'career', 'exam', 'friends'},
      );
}

class _FakeJoinDraft extends JoinDraftNotifier {
  @override
  JoinDraft build() => const JoinDraft(
        code: 'ABCD1234',
        rosterName: _longName,
        studentNo: '2026-000123',
        consent: true,
      );
}

ClassroomAssignment _assignment(int id, String status, {int dueIn = 3, bool overdue = false, String? title}) =>
    ClassroomAssignment.fromJson({
      'assignment_id': id,
      'classroom_name': _longClass,
      'classroom_id': 7,
      'source': title == null ? 'curriculum' : 'manual',
      'title': ?title,
      'grade': 3,
      'chapter': 12,
      'activities': ['speaking', 'conversation', 'workbook'],
      'item_ids': [1, 2, 3, 4, 5],
      'due_at': _now.add(Duration(days: dueIn)).toUtc().toIso8601String(),
      'overdue': overdue,
      'status': status,
      'speaking_scored': 3,
      'speaking_passed': 2,
      'speaking_total': 5,
      'conversation_met': 1,
      'conversation_total': 2,
    });

final _assignments = [
  _assignment(1, 'in_progress'),
  _assignment(2, 'not_started', dueIn: -2, overdue: true),
  _assignment(3, 'done', title: '선생님이 직접 낸 과제: 주말 계획 말하기와 식당 주문 표현 복습'),
];

WeakSoundItem _sound(String key, String label, String desc, {int? score, int attempts = 0, int? share}) =>
    WeakSoundItem(
      soundKey: key,
      label: label,
      cardDesc: desc,
      type: 'coda',
      score: score,
      attempts: attempts,
      share: share,
    );

// ── 등록 ──────────────────────────────────────────────────────────────────

/// 데이터판 화면 — 이름 뒤에 상태를 붙인다(`MyPageLevel` · `MyPageNoLevel` …).
Map<String, Widget Function()> i18nDataScreens() => {
      // 취약 발음 목록 — 국적 섹션(점유율 붙은 카드) + 내 소리(측정 · 측정 전 섞임) + 추천.
      'WeakSoundsData': () => ProviderScope(
            overrides: [
              weakSoundListProvider.overrideWith((ref) async => WeakSoundList(
                    national: NationalWeakSounds(country: 'United States of America', items: [
                      _sound('rieul_coda', '받침 ㄹ', '혀끝을 윗잇몸에 대고 소리를 끝까지 이어요', score: 44, attempts: 3, share: 62),
                      _sound('ssang_giyeok', '초성 ㄲ', '목에 힘을 주고 짧게 터뜨려요', share: 48),
                      _sound('eo_o', 'ㅓ와 ㅗ 구별', '입술을 둥글게 내밀지 않고 턱을 내려요', score: 91, attempts: 5, share: 37),
                    ]),
                    mine: [
                      _sound('tteu', '초성 ㄸ', '혀끝에 힘을 주고 터뜨려요', score: 76, attempts: 2),
                      _sound('jieut', '초성 ㅈ', '혀 앞쪽을 입천장에 붙였다 떼요', score: 12, attempts: 1),
                      _sound('nieun_coda', '받침 ㄴ', '혀끝을 윗잇몸에 붙인 채로 소리를 내요'),
                    ],
                    recommended: 'rieul_coda',
                  )),
            ],
            child: const WeakSoundsScreen(),
          ),

      // 알람 목록 — 세 줄(학습 · 자유 대화 · 꺼짐 · 긴 상대 이름).
      'AlarmListData': () => ProviderScope(
            overrides: [alarmListControllerProvider.overrideWith(_FakeAlarmList.new)],
            child: const AlarmListScreen(),
          ),

      // 알람 추가 · 수정 — 캐릭터 5명(긴 이름 포함) · 수정은 기존 알람을 인자로.
      'AlarmAddData': () => _alarmAddHost(edit: false),
      'AlarmEditData': () => _alarmAddHost(edit: true),

      // 통화 종료 — 12분 37초 · 캐릭터 있음.
      'CallFinishData': () => ProviderScope(
            overrides: [selectedCharacterProvider.overrideWithValue(_character)],
            child: _withArgs(
              (callId: '101', elapsedSec: 757),
              const CallFinishScreen(),
            ),
          ),

      // 마이페이지 — 레벨 있는 Premium 회원(상위 % · 억양 · 발음 요약 · 진도) / 레벨 없는 회원.
      'MyPageLevel': () => _myPageHost(level: true),
      'MyPageNoLevel': () => _myPageHost(level: false),

      // 설정 — 긴 이메일 · 닉네임 · Premium / Free.
      'MyPageSettingsPremium': () => _settingsHost(premium: true),
      'MyPageSettingsFree': () => _settingsHost(premium: false),

      // 닉네임 수정 — 긴 닉네임이 입력칸에 찬 상태.
      'EditNicknameData': () => ProviderScope(
            overrides: [myProfileProvider.overrideWith((ref) async => _member())],
            child: const EditNicknameScreen(),
          ),

      // 가입 이유 — 넷을 고른 상태(버튼 켜짐).
      'OnboardingReasonSelected': () => ProviderScope(
            overrides: [signupDraftProvider.overrideWith(_FakeSignupDraft.new)],
            child: const OnboardingReasonScreen(),
          ),

      // 통화 기록 — 다섯 통화(긴 요약 · 빈 요약 · 같은 날 둘).
      'RecordListData': () => ProviderScope(
            overrides: [callListProvider.overrideWith(_FakeCallList.new)],
            child: const RecordListScreen(),
          ),

      // 반 참여 동의 — 동의 체크된 상태(버튼 켜짐).
      'HwJoinConsentChecked': () => ProviderScope(
            overrides: [joinDraftProvider.overrideWith(_FakeJoinDraft.new)],
            child: const JoinConsentScreen(),
          ),

      // 반 참여 완료 — 긴 반 이름 · 과제 셋.
      'HwJoinDoneData': () => ProviderScope(
            overrides: [myAssignmentsProvider.overrideWith((ref) async => _assignments)],
            child: const JoinDoneScreen(
              membership: ClassroomMembership(
                classroomMemberId: 3,
                classroomId: 7,
                classroomName: _longClass,
                rosterName: _longName,
              ),
            ),
          ),

      // 과제 목록 — 진행 중 · 마감 지남 · 완료(직접 출제 긴 제목).
      'HwAssignmentListData': () => ProviderScope(
            overrides: [myAssignmentsProvider.overrideWith((ref) async => _assignments)],
            child: const AssignmentListScreen(),
          ),
    };

/// 라우트 인자를 읽는 화면을 인자와 함께 띄운다.
Widget _withArgs(Object args, Widget screen) => Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        settings: RouteSettings(arguments: args),
        builder: (_) => screen,
      ),
    );

Widget _alarmAddHost({required bool edit}) {
  const characters = [
    AlarmCharacter(characterId: 10, name: 'Rara'),
    AlarmCharacter(characterId: 11, name: 'Dudu'),
    AlarmCharacter(characterId: 12, name: 'Maximilian'),
    AlarmCharacter(characterId: 1, name: 'Baba'),
    AlarmCharacter(characterId: 2, name: 'Bibi'),
  ];
  final screen = const AlarmAddScreen();
  return ProviderScope(
    overrides: [availableCharactersProvider.overrideWith((ref) async => characters)],
    child: edit
        ? _withArgs(
            AlarmData(
              id: 3,
              hour: 12,
              minute: 15,
              meridiem: Meridiem.pm,
              days: [false, true, false, true, false, true, false],
              characterId: 12,
              characterName: 'Maximilian',
              callMode: AlarmCallMode.chat,
            ),
            screen,
          )
        : screen,
  );
}

/// 마이페이지 데이터판 — 억양 없음(`accent: false`)은 공유 아이콘 비활성 시험(QA F020)이,
/// [accentStats] 는 국적 이름 현지화 시험(QA F001)이 쓴다.
Widget myPageDataHost({
  required bool level,
  bool accent = true,
  List<AccentStat>? accentStats,
}) =>
    _myPageHost(level: level, accent: accent, accentStats: accentStats);

Widget _myPageHost({
  required bool level,
  bool accent = true,
  List<AccentStat>? accentStats,
}) => ProviderScope(
      overrides: [
        myProfileProvider.overrideWith((ref) async => _member()),
        selectedCharacterProvider.overrideWithValue(_character),
        callListProvider.overrideWith(_FakeCallList.new),
        myLevelProvider.overrideWith((ref) async => level
            ? const LevelSummary(level: 7, topPercent: 12)
            : const LevelSummary()),
        myAccentProvider.overrideWith((ref) async => accentStats != null
            ? AccentBreakdown(accentStats)
            : accent
            ? const AccentBreakdown([
                AccentStat(label: 'United States of America', percent: 64),
                AccentStat(label: 'United Kingdom of Great Britain', percent: 21),
                AccentStat(label: 'Philippines', percent: 15),
              ])
            : const AccentBreakdown([])),
        pronunciationSummaryProvider.overrideWith((ref) async => level
            ? const PronSummary(
                sessions: 5, sentenceCount: 38, totalScore: 72, pronunciation: 81, fluency: 64, rhythm: 58)
            : const PronSummary(sessions: 0, sentenceCount: 0)),
        curMeProvider.overrideWith((ref) async => CurMe.fromJson({
              'lesson': {'no': 42, 'code': 'A2-07-03', 'level_no': 7, 'situation': '식당에서 주문하기', 'topic': '음식'},
              'status': 'in_progress',
              'items_total': 17,
              'items_drilled': 9,
              'open': {'expression': true, 'freetalk': level},
              'next_course': 'expression',
            })),
        subscriptionStatusProvider.overrideWithValue(level
            ? SubscriptionStatus(
                state: SubscriptionState.activeMax,
                tier: SubscriptionTier.max,
                expiresAt: DateTime(2026, 10, 20),
              )
            : const SubscriptionStatus(state: SubscriptionState.free, tier: SubscriptionTier.free)),
      ],
      child: const MyPageScreen(),
    );

/// 설정 데이터판 — 버전 표기 시험(QA F031)이 쓴다.
Widget settingsDataHost({required bool premium}) => _settingsHost(premium: premium);

Widget _settingsHost({required bool premium}) => ProviderScope(
      overrides: [
        myProfileProvider.overrideWith((ref) async => _member()),
        signInProviderProvider.overrideWithValue('google'),
        subscriptionStatusProvider.overrideWithValue(premium
            ? SubscriptionStatus(
                state: SubscriptionState.activeMax,
                tier: SubscriptionTier.max,
                expiresAt: DateTime(2026, 10, 20),
              )
            : const SubscriptionStatus(state: SubscriptionState.free, tier: SubscriptionTier.free)),
      ],
      child: const MyPageSettingsScreen(),
    );
