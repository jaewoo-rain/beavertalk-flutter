# GA4 iOS 맥 빌드 체크리스트

- 작성일: 2026-09-26
- 대상 브랜치: `feat/ga4` (커밋 `635019c`, `e92aa24`)
- 범위: GA4(firebase_analytics) 적용 후 첫 iOS 빌드·실기기 검증
- 근거 코드: `lib/core/analytics/app_analytics.dart`
- 정본 문서: `claude_code/_shared/비버톡_GA4_계측_인수인계_2026-09-21.md`

---

## 1. 사전 준비

| 항목 | 값 |
|---|---|
| Firebase 프로젝트 | `bt-dev-web-01` |
| iOS 앱 ID | `1:333511894671:ios:e6acb87a8fff3f845932fa` |
| 번들 ID | `im.beavertalk.beavertalk` |
| GA 속성 | `544319612` (웹·Android·iOS 스트림 공용) |

### 1.1 브랜치 받기

```sh
git fetch origin
git checkout feat/ga4
git pull
```

- `feat/ga4`는 dev에 병합하지 않음(사용자 지시, 2026-09-26).

### 1.2 GoogleService-Info.plist 배치

- 이 파일은 `.gitignore` 대상이라 저장소에 없음.
- Xcode 프로젝트는 `ios/Runner/GoogleService-Info.plist`를 리소스로 참조함.
- **파일이 없으면 빌드가 실패함.**

```sh
firebase apps:sdkconfig IOS 1:333511894671:ios:e6acb87a8fff3f845932fa \
  --project bt-dev-web-01 --out ios/Runner/GoogleService-Info.plist
```

- Firebase CLI 로그인 계정에 `bt-dev-web-01` 접근 권한이 필요함.
- CLI가 없으면 Firebase 콘솔 → 프로젝트 설정 → 일반 → iOS 앱에서 내려받음.
- 확인: `plutil -p ios/Runner/GoogleService-Info.plist | grep BUNDLE_ID` 결과가 `im.beavertalk.beavertalk`임.

### 1.3 기타 gitignore 파일

- `.env`가 있어야 앱이 서버 주소를 읽음(`CLAUDE.md` R8).

---

## 2. 빌드 명령

### 2.1 광고 식별자(IDFA) 제외 환경변수

- 플러그인을 Swift Package(SPM)로 받으므로 Podfile 변수가 적용되지 않음.
- 빌드 셸에 `FIREBASE_ANALYTICS_WITHOUT_ADID=true`를 반드시 줌.
- 누락 시 IDFA 지원 변형(`FirebaseAnalytics`)이 링크됨.
- 근거: `firebase_analytics` 12.6.0 `ios/firebase_analytics/Package.swift` 13~16행.

### 2.2 수집 여부 스위치

| 빌드 목적 | `GA_COLLECT` | 결과 |
|---|---|---|
| 개발·QA·TestFlight 내부 테스트 | 넣지 않음 | 수집 0건 |
| DebugView 검증 | `true` | 수집 |
| App Store 운영 배포 | `true` | 수집 |

### 2.3 명령 예시

```sh
flutter clean
flutter pub get

# 검증용(실기기 실행)
FIREBASE_ANALYTICS_WITHOUT_ADID=true \
  flutter run --dart-define=GA_COLLECT=true

# 운영 배포용
FIREBASE_ANALYTICS_WITHOUT_ADID=true \
  flutter build ipa --dart-define=GA_COLLECT=true
```

- 환경변수를 바꾼 뒤에는 `flutter clean` 후 다시 빌드함.
- Xcode에서 직접 Run·Archive하면 이 환경변수가 전달되지 않을 수 있음(미검증).
- 운영 배포는 위 `flutter build ipa` 경로를 씀.

---

## 3. 빌드 산출물 점검

| 번호 | 점검 | 명령 | 기대 결과 |
|---|---|---|---|
| B1 | AdSupport 미링크 | `otool -L build/ios/iphoneos/Runner.app/Runner \| grep -i AdSupport` | 0줄 |
| B2 | AdSupport 문자열 부재 | `grep -rl "AdSupport" build/ios/iphoneos/Runner.app` | 0건 |
| B3 | plist 번들 포함 | `ls build/ios/iphoneos/Runner.app/GoogleService-Info.plist` | 파일 존재 |
| B4 | 수집 기본 끔 | `plutil -p build/ios/iphoneos/Runner.app/Info.plist \| grep FIREBASE_ANALYTICS_COLLECTION_ENABLED` | `0` |
| B5 | 자동 화면 보고 끔 | 같은 방법으로 `FirebaseAutomaticScreenReportingEnabled` | `0` |
| B6 | IDFA 수집 끔 | 같은 방법으로 `GOOGLE_ANALYTICS_ADID_COLLECTION_ENABLED` | `0` |

- `flutter build ipa` 산출물은 `build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app`에서 같은 방법으로 봄.
- B1·B2 판정 방법은 이 저장소에서 미검증임. 결과를 이 문서에 기록함.

---

## 4. DebugView 실측

### 4.1 디버그 모드 켜기

- Xcode → Product → Scheme → Edit Scheme → Run → Arguments Passed On Launch에 `-FIRDebugEnabled` 추가.
- `flutter run`으로 실행할 때는 Xcode 스킴 설정이 적용되지 않을 수 있음(미검증).
- 이 경우 Xcode에서 Run하되 2.1 환경변수 미적용 가능성을 감안함.
- 끄기: `-FIRDebugDisabled`.

### 4.2 확인 항목

- Firebase 콘솔 → Analytics → DebugView에서 기기를 선택함.

| 번호 | 동작 | 기대 이벤트 | 파라미터 |
|---|---|---|---|
| D1 | 앱 실행·화면 이동 | `screen_view` | `firebase_screen` = 라우트 이름(`/home` 등) |
| D2 | 이메일·애플·구글·카카오 로그인 | `login` | `method` |
| D3 | 신규 가입 후 온보딩 제출 | `sign_up` | `method` |
| D4 | 통화 연결 | `call_started` | `course` |
| D5 | 통화 종료 | `call_ended` | `seconds` |
| D6 | 통화 분석 결과 화면 | `analysis_viewed` | 없음 |
| D7 | 발음 챌린지 결과 | `challenge_completed` | `score`, `ended_by` |
| D8 | 로그인 상태 | 사용자 속성 user_id | Supabase 사용자 UUID |
| D9 | `GA_COLLECT` 없이 빌드·실행 | 이벤트 없음 | — |

- 5분 구간 경계로 소켓이 다시 열려도 `call_started`는 통화당 1회여야 함.
- 이름 없는 화면(`MaterialPageRoute` 직접 push)은 `screen_view`가 나가지 않는 것이 정상임.

---

## 5. 회귀 점검 — 수신 전화·알림

- plist가 생기면 iOS에서 Firebase 초기화가 처음으로 성공함.
- 그 결과 `lib/app/push_bootstrap.dart`의 `_initFcm`과 `ios_fcm` 토큰 등록이 iOS에서 처음 실행됨.
- 이전에는 초기화 실패로 이 경로 전체가 건너뛰어졌음.

| 번호 | 점검 | 기대 결과 |
|---|---|---|
| R1 | 잠금 화면 상태에서 예약 전화(VoIP) 수신 | CallKit 수신 화면 표시, 수락 시 통화 연결 |
| R2 | 앱 종료 상태에서 예약 전화 수신 | R1과 동일 |
| R3 | 앱 실행 중 예약 전화 수신 | 수신 화면 1회만 표시 |
| R4 | 첫 실행 알림 권한 요청 | 권한 창 1회, 거부해도 앱 정상 동작 |
| R5 | 숙제 알림 수신 | 일반 알림 표시(`ios_fcm` 토큰 경로) |
| R6 | 서버 기기 등록 | `ios_voip`·`ios_fcm` 토큰 2종 등록 |
| R7 | 콜드스타트 수락 지연 | 수락 후 비버 첫 발화까지 지연이 기존과 같음 |

- R5·R6은 Firebase 콘솔 → Cloud Messaging에 APNs 인증 키가 등록돼 있어야 함.
- 키가 없으면 `getToken()`이 실패하고 `ios_fcm` 등록이 보류됨(앱은 계속 동작).
- APNs 키 등록 여부는 미확인임.

---

## 6. 스토어 신고

- App Store Connect 앱 개인정보 라벨에 아래 항목을 추가함.

| 데이터 유형 | 목적 | 사용자 연결 | 추적 |
|---|---|---|---|
| 사용 데이터(제품 상호작용) | 분석 | 예(user_id) | 아니요 |
| 진단 | 분석 | 예 | 아니요 |
| 식별자(사용자 ID) | 분석 | 예 | 아니요 |

- 광고 식별자는 수집하지 않으므로 「기기 ID(광고)」와 「추적」은 해당 없음.
- ATT(앱 추적 투명성) 권한 창은 필요 없음.

---

## 7. 결과 기록

| 번호 | 결과 | 확인일 | 확인자 |
|---|---|---|---|
| B1~B6 | | | |
| D1~D9 | | | |
| R1~R7 | | | |

- 실패 항목은 로그와 함께 `claude_code/11_앱서비스_하네스/_workspace/2026-09-26_앱GA4/HANDOFF.md`에 기록함.
