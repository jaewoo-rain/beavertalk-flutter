# HANDOFF — BeaverTalk Flutter

작업 기록 체크리스트. 룰은 [CLAUDE.md](CLAUDE.md) 참조.

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
