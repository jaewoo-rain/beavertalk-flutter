# BeaverTalk Flutter — 클린 아키텍처 & 서버 실연동 플랜 (1차)

- 작성: 2026-06-23 21:46 (CEO 오케스트레이션, 에이전트 소집 후 통합)
- 소집 에이전트: `clean-architecture`(계층/폴더 설계), `api-integration-expert`(네트워킹/인증 통합), `Explore`(현황 조사)
- 대상: `c:\Users\jaewoo\Desktop\beavertalkweb\beavertalk-flutter`
- 1차 범위: **클린 아키텍처 골격 + `auth`(signup/login/social/password-reset) + `members/me` 실연동.** 나머지 도메인(calls/sentences/alarm/character/payment/subscription)은 동일 패턴으로 확장.

> 절대 규칙(R1): FastAPI 서버 파일(`...\fastapi\SQLAlchemy`)은 절대 수정하지 않는다. 서버 변경 필요 사안은 보고만 한다.

---

## 0. 현황 (조사 결과)

- **Flutter**: UI/컴포넌트는 완성도 높음(atoms/molecules/organisms, theme, 9개 화면군). 네트워킹·상태관리 라이브러리 **전무**. 데이터는 전부 `lib/mock/mock_data.dart` 인메모리 mock + 전역 `ValueNotifier`/`setState`. 로그인은 `lib/screens/auth/login_form.dart`에서 `Navigator.pushNamed(Routes.home)`로 mock 성공 처리.
- **서버**: FastAPI + SQLAlchemy + Supabase(PostgreSQL). JWT Bearer. prefix `/api/v1`. 38개 엔드포인트. 실행 `uvicorn main:app --reload` (기본 8000).

핵심 결론: **기존 UI는 부수지 않는다.** "화면이 데이터를 얻는 경로"만 `provider → repository(인터페이스) → datasource(mock 또는 dio)`로 바꾼다.

---

## 1. 의존성 추가 (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^2.6.1       # 상태관리 + DI
  dio: ^5.7.0                    # HTTP
  flutter_secure_storage: ^9.2.4 # JWT 저장
dev_dependencies:
  riverpod_lint: ^2.6.1          # provider 실수 방지 lint (입문자 유용)
```

`main.dart` → `runApp(const ProviderScope(child: BeaverTalkApp()))` 로 감싼다(Riverpod 활성화 전제).

---

## 2. 계층 정의 (Flutter + Riverpod)

의존은 **항상 안쪽(domain)으로만**.

- **domain** (순수 Dart, flutter/dio/riverpod import 금지)
  - `entities/`: 앱 모델 (`Member`, `AuthToken`). 서버 JSON 키 모름.
  - `repositories/`: 인터페이스 (`abstract AuthRepository`). 능력 선언만.
- **data** (dio/storage를 아는 계층)
  - `models/`: DTO (`MemberDto`, `TokenDto`) — 서버 JSON과 1:1, `toEntity()` 보유. **DTO는 data 밖으로 안 샌다.**
  - `datasources/`: `AuthRemoteDataSource` — dio 직접 호출, 전송 세부(form vs json) 캡슐화, DTO 반환.
  - `repositories/`: `AuthRepositoryImpl` — DTO→entity 변환, dio 에러→`AppException` 변환, 토큰 저장. (data↔domain 봉합선)
- **presentation** (UI)
  - `providers/`: Riverpod (`authControllerProvider`, `myProfileProvider`) — repository 호출·상태 노출.
  - `screens/`: 기존 화면을 `ConsumerWidget`/`ConsumerStatefulWidget`으로 개조. provider 너머는 모름.

> 한 줄 규칙: **screen은 provider만, provider는 repository(인터페이스)만, repository impl은 datasource만 안다. 화살표는 거꾸로 가지 않는다.**

검증: `rg "package:(dio|flutter)" lib/features/*/domain` 는 0건이어야 한다.

---

## 3. 폴더 구조 (feature-first 확정)

```
lib/
├── main.dart                      # ProviderScope로 감쌈
├── app/
│   ├── app.dart / routes.dart     # 라우팅(1차 유지) + AuthGate 진입
│   └── auth_gate.dart             # (신규) 토큰 상태 → home/login 분기
├── core/                          # 횡단 공통 (도메인 종속 없음)
│   ├── network/
│   │   ├── env.dart               # Env.apiBaseUrl (--dart-define + 플랫폼 폴백)
│   │   ├── dio_client.dart        # buildDio()
│   │   ├── api_endpoints.dart     # 경로 상수
│   │   └── interceptors/          # auth(Bearer/401) · logging · error
│   ├── error/
│   │   ├── app_exception.dart     # sealed AppException 계층
│   │   └── dio_error_mapper.dart  # {detail:{code,message}} 파싱 + 매핑
│   ├── storage/
│   │   └── token_store.dart       # flutter_secure_storage 래퍼
│   └── di/
│       └── providers.dart         # dioProvider, tokenStoreProvider
├── features/
│   └── auth/
│       ├── domain/{entities,repositories}
│       ├── data/{models,datasources,repositories}
│       └── presentation/{providers,screens}
│   # 나머지 도메인은 auth 완성 후 동일 패턴으로 복제(미리 빈 폴더 만들지 않음)
└── (기존) screens/ components/ theme/   # 1차엔 위치 유지, shared/ 이동은 별도 커밋
```

> **CEO 결정**: auth repository는 `features/auth/data/`에 둔다(통합 에이전트의 `core/auth/` 제안 대신). `core/`는 도메인 비종속 공통만 보유. `auth_controller`/`AuthGate`는 auth presentation 소속.

마이그레이션 마찰 최소화: `theme/`·`components/`는 1차에 **기존 위치 유지**(대량 import 변경 회피). 새 코드만 `core/`·`features/`에 추가.

---

## 4. auth vertical slice (시그니처 수준)

- `domain/entities/member.dart`: `Member{memberId,email,language,loginMethod,isAutoPayment,speakCountryId?,characterId?}` (순수 Dart)
- `domain/entities/auth_token.dart`: `AuthToken{accessToken, tokenType}`
- `domain/repositories/auth_repository.dart`: `login/signup/socialLogin/requestPasswordReset/confirmPasswordReset/getMe` — 반환은 entity, 에러는 `AppException` throw.
- `data/models/token_dto.dart` / `member_dto.dart`: `fromJson` + `toEntity()`.
- `data/datasources/auth_remote_data_source.dart`: dio 호출. **login만 form-urlencoded**, 나머지 JSON. 반환 DTO.
- `data/repositories/auth_repository_impl.dart`: DTO→entity, `DioException`→`AppException`, 로그인 성공 시 토큰 저장.
- `presentation/providers/auth_providers.dart`: DI 배선 (`authRemoteDataSourceProvider`→`authRepositoryProvider`).
- `presentation/providers/auth_controller.dart`: `Notifier<AuthStatus>` — `bootstrap/login/logout/onSessionExpired`.
- `presentation/screens/`: 기존 `login_form.dart`/`signup.dart`를 Consumer로 개조, mock 네비게이션 제거.

---

## 5. 네트워킹/인증 통합 (core)

- **baseUrl**: `--dart-define=API_BASE_URL=...` + 미주입 시 플랫폼별 폴백. 최종 `<host>/api/v1`.
  - Android 에뮬: `http://10.0.2.2:8000` · iOS/web: `http://localhost:8000` · 실기기: `http://<PC LAN IP>:8000`(서버 `--host 0.0.0.0`).
  - Android `usesCleartextTraffic="true"`(개발), iOS `NSAllowsLocalNetworking`(개발) — **클라이언트 파일이므로 허용**.
- **인터셉터**: (a) Bearer 자동 첨부(`skipAuth` extra로 로그인 제외), (b) 401 → 토큰 삭제 + 세션만료 신호 → `navigatorKey`로 로그인 이동(**refresh 없음**), (c) dev 로깅(Authorization/비번 마스킹), (d) 에러 매핑.
- **토큰 수명주기**: 부팅 시 토큰 있으면 낙관적 home 진입(첫 401에 로그인으로). 로그아웃 시 `clear()`.
- **에러 모델**: `sealed AppException` → `NetworkFailure/UnauthorizedFailure/NotFoundFailure/ConflictFailure/ValidationFailure(fieldErrors)/ServerFailure/UnknownFailure`. DioException 타입·status별 매핑표는 통합 설계 참조. 422 `detail`이 Map/List 양쪽 방어 파싱.
- **로그인 인코딩**: `data: {'username': email, 'password': pwd}` + `Options(contentType: Headers.formUrlEncodedContentType)`. **FormData(multipart) 사용 금지**(OAuth2PasswordRequestForm 비호환). `username` 키 고정.
- **CORS(R1 준수)**: web 빌드만 영향. `curl -i -X OPTIONS .../auth/login`로 허용 여부 점검 → 막히면 모바일 에뮬 우회 또는 사용자 보고(서버 수정 금지).

---

## 6. mock_data.dart 단계적 제거

1. 엔티티로 모양 승격(순수 Dart). 2. mock을 `XxxDataSource` 구현으로 격하해 provider 뒤로 숨김(화면에서 `import mock_data` 제거). 3. 전역 mutable `bookmarkedSentenceIds`(83-91행) → `Notifier<Set<int>>`로 이전. 4. **datasource만 dio로 교체(provider override 한 줄)** → 화면/엔티티 무변경. 5. 정적값(`mockLanguages`/`mockReasons`)은 `core/constants`로 승격 후 파일 삭제.

> 규칙: **mock은 datasource 구현 중 하나일 뿐.** 항상 provider override 뒤에 있어야 교체가 1줄로 끝난다.

---

## 7. 1차 실행 순서 (구현 단계)

1. pubspec 의존성 + `main.dart` ProviderScope/navigatorKey.
2. `core/network`(env, dio_client, api_endpoints, 인터셉터) + `core/error` + `core/storage/token_store` + `core/di/providers`.
3. `features/auth` vertical slice 전체.
4. `app/auth_gate.dart` + `routes.dart` 진입 연결.
5. 화면 개조: `login_form.dart` → 실제 login, `signup.dart` → 실제 signup.
6. `members/me`: `getMe()` + `myProfileProvider` → `mypage.dart` 회원 데이터 연결.
7. 검증: 정적 게이트(`flutter analyze`) + 서버 띄우고 로그인/내정보 e2e 수동 확인.

---

## 8. 검증 계획

- 정적: `flutter analyze` (riverpod_lint 포함) 통과.
- 단위/통합: `voice-api-tester`(또는 flutter test)로 `dio_error_mapper`, `AuthRepositoryImpl`(mock dio) 테스트.
- e2e 수동: 서버 기동 → 회원가입 → 로그인(폼 인코딩) → `members/me` 표시 → 401 강제 시 로그인 복귀.

## 9. 남은 의존/리스크

- refresh 토큰 부재 → 7일 후 강제 재로그인(설계 반영). 
- web CORS는 서버 설정 종속(R1로 수정 불가) → 모바일 우선 권장.
- 실기기 연동 시 서버 `--host 0.0.0.0` 실행·방화벽 8000 인바운드 필요(서버 코드 아님, 실행 설정).
- 422 detail 형태 실측 1회 필요.

---

## 10. 작업 분담 (다음 단계)

| 단계 | 담당 에이전트 | 산출 |
|---|---|---|
| core/network·error·storage 구현 | `flutter-developer` (+`api-integration-expert` 계약) | dio_client, 인터셉터, token_store, error |
| features/auth slice 구현 | `flutter-developer` | entity/dto/datasource/repo/provider/화면 개조 |
| 구조 검토 | `clean-architecture` | 의존성 방향·경계 위반 점검 |
| 테스트 | `voice-api-tester` | mapper·repository 단위 테스트 |
| 통합·검증·보고 | CEO | flutter analyze + e2e 수동 + HANDOFF 기록 |
