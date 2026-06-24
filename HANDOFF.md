# HANDOFF — BeaverTalk Flutter

작업 기록 체크리스트. 룰은 [CLAUDE.md](CLAUDE.md) 참조.

---

## 📌 현재 상태 요약 (2026-06-24 기준)

**아키텍처**: feature-first 클린아키텍처 + Riverpod + dio + flutter_secure_storage. `core/{network,error,storage,di}` + `features/{auth,alarm,character}/{domain,data,presentation}`. usecase 생략, DTO 수기. domain 순수성 유지(검증됨). `flutter analyze` 항상 No issues, `flutter test` 현재 **34 passed**.

**서버 연동 상태**
| 도메인 | 표시 | 변이 | 비고 |
|---|---|---|---|
| auth(로그인/내정보) | ✅ | ✅ | 이메일 로그인(form), members/me, 로그아웃 |
| **회원가입(이메일 인증)** | — | ✅ | available→send-code→verify-code→signup `{email,password}` |
| **온보딩** | — | ✅ | `POST /members/me/onboarding {name,language,reasons[]}` |
| alarm | ✅ | ✅ CRUD/토글 | |
| character(아바타) | ✅ 표시 | ⬜ 구매 제외 | GET /characters, /members/me/characters |
| 구글 로그인 | 🟡 web GIS 구현 | — | 동의창 수동 e2e 보류 |
| calls·sentences·payment·subscription | ⬜ | ⬜ | 미착수 |

**baseUrl**: `flutter_dotenv`로 `.env`의 `API_BASE_URL` 우선 → dart-define → localhost 폴백. 현재 `.env`=`175.123.55.182:8000`(원격, 도달·CORS OK). 스킴 없으면 `http://` 보정.

**실행**: `flutter run -d chrome --web-port=5000` (dart-define 없이 → .env가 baseUrl 결정). 구글 로그인은 승인 JS 원본 `http://localhost:5000` 필요.

### ⚠ 미해결 / 외부 의존 (서버·환경, R1)
- **이메일 인증코드 미수신(Resend 403)**: 서버 `.env`에 `RESEND_API_KEY`+`MAIL_FROM` 설정돼 Resend 발송 시도 → 403 Forbidden(도메인 미verify 추정) → 코드 안 옴 + 콘솔 stub 폴백도 안 함. **해결**: dev는 `RESEND_API_KEY`/`MAIL_FROM` 한 줄 주석→재시작(콘솔 `[EMAIL stub]`에 코드 출력) / 실발송은 Resend 도메인 verify. (사용자 적용)
- **캐릭터 이름 깨짐**: 시드된 name이 손상 UTF-8 → 앱에서도 깨져 보임. UTF-8 재시드 필요(사용자). 가격/소유 등은 정상.
- **구글 로그인 수동 e2e 미완**: 인터랙티브 동의 필요. SNS는 사용자가 보류.
- **i18n 미구현**: 언어 선택은 흐름·캡처만. 언어별 문구 변경은 추후.
- **JWT refresh 없음**: 7일 만료 후 강제 재로그인(401 인터셉터 안전망).

---

## 2026-06-24 — 인증/온보딩 흐름 재정비 (3차, 서버 API 변경 대응)

서버가 회원가입/온보딩 API를 분리 + 이메일 인증 추가 → 클라 맞춤. UI 디자인 불변, 배선/순서만. SNS 보류.

### ✅ 완료 (검증됨, analyze 0 / test 34)
- [x] **캐릭터 표시 연동** ([plan](docs/2026-06-24_1214_character-display-plan.md)): `features/character/` 슬라이스(Character/OwnedCharacter, DTO 가격파싱, datasource, providers) + `avatar.dart` 개조(보유/한정할인/구매가능 섹션 서버화, ₩가격/무료, 구매 POST 제외). 구조검토 통과.
- [x] **구글 로그인(web)** ([plan](docs/2026-06-24_1147_google-social-login-plan.md)): `google_sign_in` + GIS `renderButton`(web만, idToken 안정 수급) → `socialLogin('google', idToken)`. `web/index.html` meta에 클라이언트 ID. 서버 `GOOGLE_CLIENT_ID` 설정됨(garbage→401 확인). conditional import로 VM/test 분리.
- [x] **이메일 인증 회원가입** ([plan](docs/2026-06-24_1426_email-verification-signup-plan.md)): `checkEmailAvailable`/`sendEmailCode`/`verifyEmailCode` + signup 다단계(이메일 인증→비번). 비번재설정 코드방식 `{email,code,new_password}` + password_code에 새 비번 입력 추가.
- [x] **signup/온보딩 분리** ([plan](docs/2026-06-24_1515_signup-onboarding-split-plan.md)): `POST /auth/signup`={email,password}만. 신규 `submitOnboarding({name,language,reasons})`→`POST /members/me/onboarding`. MemberDto에 `name`,`onboardingCompleted`,`reasons`.
- [x] **AuthGate onboarding_completed 게이팅**: unauthenticated→(draft.language null이면 언어선택, 아니면)LoginScreen / authenticated→members/me의 `onboarding_completed` true=Home, false=온보딩(이름→이유).
- [x] **언어/나라 선택을 로그인 전 맨 처음으로** + 캡처(draft). i18n 미구현(흐름만).
- [x] **학습 이유 다중 선택**: `selectedReasonIds:Set<String>`+`toggleReason`, 1개 이상 활성, `reasons[]` 전송.
- [x] **.env API_BASE_URL 우선**(flutter_dotenv): main에서 `dotenv.load` + Env 우선순위(.env→dart-define→폴백) + 스킴 보정. `.env`는 .gitignore 등록.
- [x] **로그아웃 즉시 전환 버그 수정**: `logout()`/`onSessionExpired()`에서 `appNavigatorKey.popUntil(isFirst)`로 스택 정리 → 로그아웃 즉시 로그인 화면(뒤로가기 불필요). 401도 동일.

### 흐름 (현재)
앱 시작 → **언어/나라 선택**(draft) → 로그인/가입 → 가입 시 이메일 인증→비번→`signup{email,password}`→자동로그인 → AuthGate가 members/me 확인 → 미완료면 **이름→이유(다중)**→`POST onboarding`→홈 / 완료면 홈. 로그아웃→즉시 로그인 화면.

### ⏭ 다음 (미착수)
- [ ] calls(통화 목록/결과) → record_list/analysis 화면 연동, sentences(북마크/복습), payment/subscription.
- [ ] 캐릭터 구매(POST) 연동(필요 시), i18n(언어별 문구), 구글 로그인 수동 e2e.

---

## 2026-06-24 — alarm 도메인 서버 실연동 (2차)

플랜: [docs/2026-06-24_1105_alarm-slice-plan.md](docs/2026-06-24_1105_alarm-slice-plan.md). auth 슬라이스 패턴 복제.

### ✅ 완료 (검증됨)
- [x] `lib/features/alarm/{domain,data,presentation}`: Alarm 엔티티(순수 Dart), AlarmDto(time/days 직렬화 전담), datasource(7개 호출 + GET /characters), repository_impl(DTO↔entity, DioException→AppException), `alarmListControllerProvider`(AsyncNotifier) + `availableCharactersProvider`.
- [x] 화면 개조(UI 무변경): `alarm_list.dart`(ConsumerStatefulWidget, CRUD/토글/요일/삭제 실연동, 빈목록 AlarmEmptyBody, 실패 스낵바), `alarm_add.dart`(파트너 소스→서버 캐릭터), `alarm_models.dart`(AlarmData에 id/characterId 추가, fromEntity/toEntity, partnersFromCharacters).
- [x] **time 매핑**: 벽시계 취급 — 전송 `2000-01-01THH:MM:00`(naive) → 서버 echo `...Z` → `.toUtc()` 시/분 그대로(타임존 밀림 없음). days `['SUN'..'SAT']` 양방향.

### ✅ 검증 결과
- `flutter analyze`: **No issues**(CEO 재확인). domain 순수성 0건. `flutter test`: **6 passed**(alarm_dto 라운드트립 포함).
- 라이브 e2e: characters→create(201)→list→deactivate(200)→PUT(200)→delete(204) 라운드트립 성공.
- 구조 검토(clean-architecture): 경계 6항목 **전부 통과**(위반 0).

### 🔻 후속 폴리시 (낮음, 비차단)
- P1: `AlarmCharacter`를 `domain/entities/alarm_character.dart`로 분리(추후 characters 슬라이스 승격 대비).
- P2: `partnersFromCharacters` picker 어댑터를 화면 옆 별도 파일로(파일 비대 시).
- alarm_dto time 파싱: 서버가 `Z` 없이 echo할 경우 로컬 해석으로 시각 밀림 가능 → 견고성 위해 파싱 시 강제 UTC 처리 점검(현재 서버는 항상 `Z` echo라 실동작 정상).

### 🖥 서버 변경 반영 (사용자 적용, R1)
- **CORS 미들웨어 적용됨**(allow_origins=["*"]) → 크롬 web 정상. run-web-chrome 스킬에서 dev 보안우회 제거.
- **캐릭터 4개 시드**(비비/주디/레오/미나) → alarm picker 자동 반영.

---

## 2026-06-23/24 — 클린 아키텍처 골격 + auth/members me 서버 실연동 (1차)

플랜: [docs/2026-06-23_2146_flutter-clean-architecture-plan.md](docs/2026-06-23_2146_flutter-clean-architecture-plan.md)
스택: Riverpod + dio + flutter_secure_storage, feature-first 클린아키텍처, usecase 생략, DTO 수기.

### ✅ 완료 (검증됨)
- [x] **의존성**: pubspec에 flutter_riverpod/dio/flutter_secure_storage(+ dev riverpod_lint/custom_lint). `flutter pub get` 정상.
- [x] **core/**: network(env/api_endpoints/dio_client/인터셉터 auth·logging), error(app_exception sealed + dio_error_mapper, detail Map/List/String 방어), storage(token_store `bt_access_token`), di(providers: dioProvider/tokenStoreProvider).
- [x] **features/auth/**: domain(Member/AuthToken entity + AuthRepository 인터페이스, 순수 Dart 확인), data(TokenDto/MemberDto fromJson+toEntity, AuthRemoteDataSource login=form/나머지 json, AuthRepositoryImpl DTO→entity + DioException→AppException + 토큰저장), presentation(auth_providers 배선, auth_controller `Notifier<AuthStatus>`, my_profile_provider FutureProvider<Member>).
- [x] **app/**: navigation(appNavigatorKey), auth_gate(unknown=스플래시/authenticated=Home/unauthenticated=온보딩 진입). main.dart ProviderScope + navigatorKey.
- [x] **화면 개조(UI 무변경, 배선만)**: login_form.dart(실제 login, form 인코딩), signup.dart(실제 signup), mypage.dart(myProfileProvider AsyncValue.when, logout 연결).
- [x] **Android**: INTERNET 권한 + debug cleartext(에뮬 HTTP).

### ✅ 검증 결과
- `flutter analyze`: **No issues found** (CEO 독립 재확인 + riverpod_lint/custom_lint 포함).
- `flutter test`: 1 passed.
- **실서버 e2e (localhost:8000, env=dev)**: signup 201 / login(form) access_token 발급 / GET members/me 200 / 오류 로그인 401 `{"detail":{"code","message"}}` → `UnauthorizedFailure` 매핑. DTO 필드 실응답과 일치.
- **구조 검토(clean-architecture)**: 경계 6개 항목 전부 통과(domain 순수성·DTO 비누출·의존성 방향·인터페이스 의존·에러 경계·화면 결합).

### ✅ 직전 마감 (검증됨)
- [x] **logout/onSessionExpired 시 `myProfileProvider` 무효화**(이전 사용자 프로필 캐시 노출 방지) — `auth_controller.dart` 두 경로에 `ref.invalidate(myProfileProvider)` 추가. analyze No issues 재확인.

### ⏭ 다음 작업 (동일 패턴 복제로 확장)
- [ ] 나머지 도메인 슬라이스: calls(통화 저장/목록/결과) → sentences(북마크/복습/채점) → alarm → character → payment → subscription. auth 슬라이스를 템플릿으로 복제.
- [ ] mock_data.dart 단계적 제거(플랜 6장): mockSentences/mockCallResult → datasource화 → dio 교체. 전역 `bookmarkedSentenceIds`(83-91행) → `Notifier<Set<int>>`.
- [ ] AuthGate unauthenticated 진입을 단순 로그인 화면으로 바꿀지 결정(현재 온보딩→로그인 UX 보존).
- [ ] 소셜 로그인: provider OAuth 토큰 획득 흐름 연결(`authController.socialLogin` 준비됨).
- [ ] 정적값 마감(관찰 A): mypage `beaverImage` 등 → core/constants 승격, mock import 제거.

### ⚠ 미해결 / 외부 의존 (코드로 못 닫음)
- **web CORS**: 서버 CORS 설정 종속(R1: 서버 수정 금지). web 빌드 막히면 Android 에뮬(`10.0.2.2`) 우선. 필요 시 서버측 CORSMiddleware 추가는 사용자 판단.
- **JWT refresh 없음**(서버 미구현): 7일 만료 후 강제 재로그인. 401 인터셉터가 안전망.
- **실기기 연동**: 서버 `uvicorn ... --host 0.0.0.0` 실행 + 방화벽 8000 인바운드 필요(서버 코드 아님).

### e2e 실행
```
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000   # web (CORS 주의)
flutter run -d emulator-5554                                             # Android 에뮬(10.0.2.2 자동 폴백)
```
