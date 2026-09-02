/// 로그아웃 경계에서 **지울 것**과 **일부러 안 지울 것**의 목록.
///
/// ## 왜 목록을 코드로 빼놨나
///
/// 이 판정은 원래 `AuthController._clearUserScopedState()` 안에 손으로 나열돼 있었고,
/// 실패 방식이 언제나 같았다 — **새 provider 를 만들고 목록에 넣는 걸 잊는다.**
/// 두 번 났다:
///
///   `charactersProvider`  바로 옆의 `ownedCharactersProvider` 는 지우면서 이것만 빠져,
///                         B 가 A 의 소유·잠금해제 상태를 봤다
///   `myAccentProvider`    바로 아래 `myLevelProvider` 는 autoDispose 라 안전한데 이것만
///                         평범한 FutureProvider 라, B 의 마이페이지에 A 의 억양 통계가 떴다
///
/// 같은 사고가 두 번 났다는 건 손코딩 나열이 안 버틴다는 뜻이다. 그래서 목록을 여기로
/// 모아 **순회 가능한 상수**로 만들었다. 두 가지가 따라온다:
/// 1. provider 를 새로 만들 때 이 파일이 눈에 띈다
/// 2. `user_scoped_state_test.dart` 가 소스 파싱 없이 **심볼로** 검증한다
///
/// ## 새 provider 를 만들었다면
///
/// 아래 **둘 중 한 곳에** 넣어라. 안 넣으면 테스트가 실패한다 — 일부러 그렇게 해놨다.
/// 분류가 강제되므로 "잊고 지나가는" 경로가 없다.
///
/// 단, 아래 두 종류는 **분류 대상이 아니다**(테스트가 자동으로 건너뛴다):
/// - `.autoDispose` — 듣는 화면이 사라지면 같이 죽는다. 로그아웃 너머로 남지 않는다
/// - 순수 `Provider` / `Provider.family` — 파생이거나 공장(repository·dataSource·service)
///   이라 자기 캐시가 없다. 파생값은 원본이 무효화되면 **전이적으로** 다시 계산된다
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../alarm/presentation/providers/alarm_list_controller.dart';
import '../../../bookmark/presentation/providers/bookmark_providers.dart';
import '../../../bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../../character/presentation/providers/character_providers.dart';
import '../../../normalcall/presentation/normalcall_controller.dart';
import '../../../review/presentation/review_providers.dart';
import '../../../subscription/presentation/providers/subscription_state_providers.dart';
import '../../../../core/i18n/locale_controller.dart';
import '../../../alarm/presentation/providers/alarm_providers.dart';
import 'auth_controller.dart';
import 'language_sheet_provider.dart';
import 'my_profile_provider.dart';
import 'signup_draft_provider.dart';
import '../../../classroom/presentation/classroom_providers.dart';
import '../../../classroom/presentation/assignment_attempt_provider.dart';
import '../../../classroom/presentation/join_draft_provider.dart';



/// 로그아웃·계정삭제·401 만료 시 **버리는** 상태.
///
/// 판단 기준 하나: **다음 회원이 보면 안 되는 값을 담고 있는가.**
final List<ProviderOrFamily> userScopedProviders = <ProviderOrFamily>[
  // 회원 본인 정보. 안 지우면 B 화면에 A 의 이름·언어·대표 캐릭터가 남는다.
  myProfileProvider,
  // 억양(국가) 분석 결과. 마이페이지 억양 카드가 이걸 그린다.
  myAccentProvider,
  // A 의 알람 → B 의 폰이 울린다. InboundCallScheduler 가 타이머로 이 캐시를 읽는다.
  alarmListControllerProvider,
  // A 가 저장한 문장이 B 의 보관 탭에 보인다.
  bookmarkListProvider,
  // A 가 구매한 캐릭터가 B 의 아바타 화면에 보인다.
  ownedCharactersProvider,
  // ⚠ 카탈로그도 회원별이다. 목록 자체는 공용이지만 각 행의
  // is_owned / is_unlocked / unlock_source 는 조회한 회원 기준 계산값이다.
  charactersProvider,
  // A 가 이번 세션에 산 플랜이 B 의 구독 화면을 업그레이드해 보이게 한다.
  sessionEntitlementProvider,
  // A 의 언어·이름·사유가 B 의 온보딩에 프리필된다.
  signupDraftProvider,
  // A 가 속한 반의 숙제 목록이 B 에게 보인다. 반 이름·챕터·마감이 전부
  // 기관에서 받은 값이라 남기면 남의 수업이 그대로 노출된다.
  myAssignmentsProvider,
  // A 가 입력하던 참여 코드·반에서 쓸 이름이 B 의 참여 화면에 프리필된다.
  joinDraftProvider,
  // A 가 방금 친 발음 과제 점수가 B 의 숙제 상세에 그려진다. 서버가 보관하지
  // 않는 값이라 여기서 안 지우면 되돌릴 방법이 없다.
  assignmentAttemptProvider,
];

/// **일부러 안 지우는** 상태 — 지우면 오히려 깨지거나, 애초에 회원 스코프가 아니다.
///
/// ⛔ 여기 있는 것을 [userScopedProviders] 로 옮기기 전에 아래 이유를 읽어라.
/// 특히 [languageSheetShownProvider] 는 좋은 뜻으로 추가되기 쉽고, 추가하는 순간
/// 사용자에게 보이는 버그가 돌아온다.
final List<ProviderOrFamily> intentionallyNotUserScoped = <ProviderOrFamily>[
  // ⛔ 앱 실행 스코프다(회원 스코프가 아니다). 지우면 로그아웃 직후 새로 뜨는
  // 로그인 화면이 매번 "최초 진입"으로 착각해 언어 시트를 띄우고, 곧이어
  // logout() 의 _popToRoot() 가 그 라우트를 pop 해 **올라오다 마는 시트**가 보인다.
  // 사연은 language_sheet_provider.dart 에 그대로 적혀 있다.
  languageSheetShownProvider,
  // 기기 설정이다. SharedPreferences 에 저장돼 있어 지워도 곧바로 다시 hydrate 되고,
  // 앱 UI 언어가 로그아웃마다 초기화되는 편이 오히려 이상하다.
  localeControllerProvider,
  // charactersProvider 를 watch 하는 **파생**이다 — 원본이 무효화되면 같이 따라온다.
  // 여기 또 넣어도 틀리진 않지만, 파생을 일일이 나열하기 시작하면 목록이 원본과
  // 어긋나기 시작한다. 원본만 지운다.
  availableCharactersProvider,
  // 통화 중 상태. 로그아웃 시점에 통화가 살아 있을 일이 없고, 지우면 진행 중인
  // 소켓 정리 경로와 엉킨다.
  normalCallControllerProvider,
  // callId 로 자체 리셋한다(다른 통화를 열면 비운다). 통화 id 는 서버 전역이라
  // 다음 회원의 통화와 겹치지 않는다.
  reviewScoresProvider,
  // build 가 Future<void> — 담는 데이터가 없다. 토글 요청의 진행 상태일 뿐이다.
  bookmarkToggleControllerProvider,
  // 인증 상태 그 자체. 로그아웃 처리 중에 자기를 무효화하면 진행 중인 전이가 엉킨다.
  authControllerProvider,
];
