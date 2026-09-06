# HANDOFF — 태블릿 적응형 레이아웃

- 저장소: `beavertalk-flutter-layout` (private)
- 브랜치: `feat/layout` (기준 `base` = 원본 `feat/server-emotion` `e07997d`)
- 커밋 2건 · 65파일 · +2,853 / −1,944
- 작업: 2026-09-01 ~ 09-02

---

## 1. 이 브랜치가 하는 일

- 태블릿 전용 화면을 만들지 않음.
- 기존 화면이 가용 폭에 따라 **연속적으로** 적응함.
- 정본: Figma `8ZSZBmb5wFi6OMZhx8SBaN` 페이지 `┗ Design · Tablet`(`5272:22731`).

## 2. 규칙은 하나다

```
여백 = max(20, (폭 − 캡) / 2)
```

| 폭 | 여백 | 콘텐츠 |
|---|---|---|
| 375 (폰 정본) | 20 | 335 |
| 640 (이음매) | 20 | 600 |
| 800 (에뮬 태블릿) | 100 | 600 |
| 810 (태블릿 정본) | 105 | 600 |

- 640에서 여백 20·콘텐츠 600이 되어 375~810 구간이 끊기지 않음.
- 그래서 **브레이크포인트 분기가 없음.** `isTablet` 류의 기기 판정을 두지 않음.
- 기기를 묻지 말고 **가용 폭**을 물을 것. 같은 규칙이 폰·태블릿·Split View·데스크탑 창에 그대로 적용됨.

### 캡은 넷

| 용도 | 캡 | 810에서의 여백 |
|---|---|---|
| 본문 | 600 | 105 |
| 법률 문서 | 700 | 55 |
| 안내문·다이얼로그·오버레이 | 480 | 165 |
| 하단 탭바 | 375 | 중앙 정렬 |

- **새 폭을 발명하지 말 것.** `test/tablet_band_test.dart` 가 이 넷 밖의 캡을 실패로 처리함.

## 3. 파일 지도

| 파일 | 역할 |
|---|---|
| `lib/app/adaptive.dart` | **여기부터 읽을 것.** `AppLayout` 상수·계산, `ContentColumn`, `AdaptiveTiles`, `CenteredCap` |
| `lib/app/app_scaffold.dart` | 셸. 폭 캡 없음(전폭) |
| `lib/components/organisms/gnb.dart` | 헤더. 배경 전폭, 내용만 컬럼 |
| `lib/components/organisms/bottom_nav_bar.dart` | 탭바 375 캡 + 중앙 정렬 |
| `lib/components/chrome/bottom_cta_bar.dart` | 하단 도킹 CTA |
| `lib/main.dart` | 세로 고정(런타임) + 바텀시트 테마 |
| `test/adaptive_layout_test.dart` | 규칙이 맞는가(17건) |
| `test/tablet_band_test.dart` | 화면이 그 규칙을 쓰는가(27장) |

### 쓰는 법

```dart
// 화면 본문 — 폰 여백 20, 태블릿 105
ContentColumn(child: ListView(padding: EdgeInsets.only(top: 24), children: [...]))

// 폰 여백이 20이 아닌 화면 — 그 값을 최소값으로 넘긴다
ContentColumn(gutter: AppSpacing.s40, child: ...)   // 로그인

// 세로 패딩은 padding 인자로 (위젯 트리를 더 깊게 만들지 않는다)
ContentColumn(padding: EdgeInsets.symmetric(vertical: 14), child: Row(...))

// 목록 — 폰 1열, 콘텐츠 600에서 2열 290+20+290
AdaptiveTiles(stackedGap: AppSpacing.s12, children: [...])
```

## 4. 가로 전환 차단 — 세 겹이 필요하다

| 겹 | 파일 | 덮는 범위 |
|---|---|---|
| 런타임 `setPreferredOrientations` | `lib/main.dart` | 폰, Android 15 이하 |
| `screenOrientation="portrait"` + `PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY` | `android/app/src/main/AndroidManifest.xml` | Android 16 대화면 |
| 가로 방향 제거 + `UIRequiresFullScreen` | `ios/Runner/Info.plist` | iPad |

- 한 겹으로는 안 됨. 셋을 같이 봐야 함.
- **`targetSdk = 36`(Android 16)은 600dp 이상 화면에서 방향 제한을 통째로 무시함.** 런타임 호출까지 같이 무시되어 정확히 태블릿만 빠져나감.
- iOS 는 `UIRequiresFullScreen` 이 없으면 앱을 멀티태스킹 지원으로 보고 방향 제한을 무시함. 배열에서 가로를 빼는 것과 이 키는 한 쌍임.

## 5. 다음 사람이 밟을 함정

1. **`ContentColumn` 을 `LayoutBuilder` 로 다시 짜지 말 것.**
   - 초판이 그랬고 「LayoutBuilder does not support returning intrinsic dimensions」로 로케일 30 × 화면 5 = 150건이 한꺼번에 죽었음.
   - 빈 상태·오류 화면이 세로 중앙 정렬에 `IntrinsicHeight` 를 쓰기 때문임.
   - 고유 크기 질의는 레이아웃 **전에** 오는데 `LayoutBuilder` 는 레이아웃 시점에야 자식을 만들어 답을 못 함.
   - 그래서 `RenderShiftedBox` 를 직접 구현했음. 회귀 테스트가 박혀 있음.

2. **카드 안쪽 패딩과 화면 여백을 가릴 것.**
   - 카드의 `horizontal: 20` 은 화면 여백이 아님. `ContentColumn` 으로 바꾸면 안 됨.
   - 실제로 두 번 잘못 바꿨다가 되돌렸음(`avatar_detail` 샘플 음성 카드, `bottom_sheet_avatar` 동일 카드).

3. **배경·보더는 전폭, 내용만 컬럼.**
   - 하단 셸프의 1px 보더, 안내 띠의 색 면, 바텀시트 표면, 히어로 이미지는 전폭이어야 함.
   - 정본 실측 근거: `depth/paywall_pro` 의 `Sticky-CTA x=0 width=810`, 그 안 `CTA x=105 width=600`.
   - 폭 제한을 `Material` **안**에 두면 배경만 전폭으로 칠해져 카드가 띠가 됨(다이얼로그에서 실제로 발생).

4. **Material 3 기본값이 시트를 640으로 캡함.**
   - `BottomSheetThemeData.constraints` 기본값이 `maxWidth: 640` 임.
   - 코드에서 캡을 다 걷어내도 이것 때문에 태블릿에서 시트만 좁아짐.
   - `lib/main.dart` 테마에서 빈 제약으로 덮어 뒀음. 테마를 손대면 같이 확인할 것.

5. **정본 노트와 실제 프레임이 갈리면 프레임을 믿을 것.**
   - 노트는 헤더를 「전폭 + 패딩 32」로 적었으나 그려진 프레임은 헤더 내용도 x=105 임.
   - 분할뷰도 노트에만 있고 그림엔 2열 그리드·단일 컬럼이라 구현하지 않았음.
   - 예외는 하단 탭바 하나임 — 정본 `main_home` 인스턴스가 810 폭인데 아이콘이 좌측 375에 머물러 있어 Figma 쪽 결손으로 판정하고 노트(375 중앙)를 따랐음.

## 6. 검증

### 게이트

```
flutter analyze                       # 무이슈
flutter test                          # 542건 그린
rm -rf build && dart run custom_lint  # 6건 — 전부 기존 코드, 신규 0
```

- `custom_lint` 는 `build/` 가 있으면 `PathNotFoundException` 으로 죽음. 반드시 지우고 돌릴 것.
- 이 저장소는 착수 시점부터 `dart format` clean 이 아님. 돌리면 무관한 파일이 통째로 바뀌어 diff 를 덮음.

### 검증은 세 층이다

- 하나만으로는 전부 놓침. 실제로 층마다 다른 결함이 나왔음.

| 층 | 무엇을 묻는가 | 여기서만 잡힌 것 |
|---|---|---|
| `adaptive_layout_test.dart` | 규칙이 맞는가 | 여백·캡·열 수 계산 |
| `tablet_band_test.dart` | 화면이 그 규칙을 쓰는가 | 변환에서 빠진 화면 9장 |
| 에뮬레이터 | 실제 경로에서 어떤가 | 시트 640 캡, 시트 안 335 고정폭 |

### 에뮬레이터 재현 절차

```
flutter emulators --launch beavertalk_tablet
adb shell wm size 1600x2560      # 세로 800×1280dp 로 만든다
adb shell wm density 320
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

- 끝나면 `adb shell wm size reset` · `wm density reset` 으로 되돌릴 것.
- 세로 고정된 앱이 최상단이면 OS 가 디스플레이를 돌리지 않음. `user_rotation` 대신 `wm size` 를 쓰는 이유임.
- 로그인 계정은 `docs/2026-07-15_QA_체크리스트_신규테스트폰.md` 에 있음. **이 파일에 옮겨 적지 말 것**(`docs/` 는 gitignore 임).
- 인증은 Supabase 로 이관됨. FastAPI `/auth/login` 은 404 임.

### 실기 실측 결과 (Android 16 태블릿, 800×1280dp)

| 화면 | 실측 (dp) |
|---|---|
| 홈 하단 내비 | 287~512, 중심 399.2 |
| 마이페이지 · 설정 · 구독 · 알람 | 100 ~ 700 |
| 이용약관 | 50 ~ 750 |
| 통화 기록 | 100~390 / 410~700 (290 + 20 + 290) |
| 아바타 변경 | 100 ~ 700, 구매 가능 2열 |
| 바텀시트 | 표면 0~800, 버튼 100~700 |

## 7. 남은 일

- **iOS 실기 확인 0건.** macOS 부재로 시뮬레이터를 못 띄웠음. `ios/Runner/Info.plist` 변경은 미검증임.
- **`PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY` 는 targetSdk 37 까지만 유효함.** 그 전에 가로 레이아웃을 그리거나 세로 고정을 포기하는 결정이 필요함.
- **이 브랜치를 원본 저장소에 어떻게 넣을지 미정.** 원본은 `jaewoo-rain/beavertalk-flutter` 이고 여기는 별도 저장소임. `base` 브랜치가 분기점이라 `base...feat/layout` 으로 diff 를 뽑을 수 있음.
- **발음챌린지 게임 씬** — 이미 `AspectRatio(9/16)` 중앙 정렬이라 폭에 맞춰 스스로 늘어남. 정본은 하단 정렬인데 코드는 중앙 정렬임. 차이를 남겨 뒀음.
- **`12_숙제` 제외.** 지시에 따름. 해당 코드가 저장소에 없어 자동으로 빠졌음(Figma 전용 섹션).

---

상세 기록은 `docs/2026-09-01_1945_태블릿-적응형-레이아웃-확장.md`(플랜)과 `docs/2026-09-01_2130_태블릿-적응형-레이아웃-결과.md`(결과)에 있음. 두 문서는 `docs/` 가 gitignore 라 원격에 없음.
