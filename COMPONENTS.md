# BeaverTalk Flutter 컴포넌트 — 구현 가이드

> Figma fileKey `FQVUsRjcRjWlS8v1tmITXw`. 다크 테마, primary `#00FFB2`.
> 각 컴포넌트는 Figma 노드를 MCP로 **실측**해 1:1 구현. 이미지 추측 금지.

## 토큰 (반드시 사용)
- 색: `lib/theme/app_colors.dart` → `AppColors.primary/onPrimary/primary10/primary24/bg/surface/surface2/surfaceElevated/surfaceElevatedNormal/border/borderSubtle/lineStrong/scrim/text/textSecondary/textTertiary/textDisabled/accentLime/success/error/warning`
- 타이포: `lib/theme/app_typography.dart` → `AppType.body1.sb` 식 (`.r`=400 `.m`=500 `.sb`=600 `.b`=700). 색은 `.copyWith(color:)`로.
- 라운드: `lib/theme/app_radius.dart` → `AppRadius.pill/xs(8)/sm(12)/md(16)/lg(24)/xl(32)`.

## 파일/데모
- `lib/components/<group>/<snake_name>.dart` (group: atoms/molecules/organisms/chrome)
- 같은 파일에 `class <Name>Demo extends StatelessWidget` 포함(모든 variant/state 노출). 갤러리 등록은 CEO가 함 — `gallery_registry.dart` 건드리지 말 것.
- 검증: `flutter analyze lib/components/<group>` 에러 0.

## 컴포넌트 인벤토리 (이름 → Figma nodeId)

### atoms (01_Atoms 2045:1326)
| 위젯 | node | variants |
|---|---|---|
| Button | 45:45158 | type×7(primary_fill/primary_outline/primary_outline_white/secondary_fill/secondary_outline/secondary_white/disabled) × size×7(60·48·44·36·32·28·24) × left/right icon |
| IconButton | 176:13875 | selected/unselected |
| Checkbox | 175:11455 | size 22·20 × default/checked/disabled/checked-disabled × hasText |
| Toggle | 175:11388 | default/selected/disabled/selected-disabled (트랙52×28, 썸24, on=accentLime) |
| ThumbsUp | 170:9592 | active/inactive |
| SelectBox | 170:9634 | selected/unselected × regular/bold (한 글자 칩) |
| TranslateToggle | 170:9624 | active/inactive |
| ProgressBar | 175:12772 | label+percent+8px track(mint), 채움 끝 흰 노브 |
| Dim | 176:26363 | 풀스크린 scrim(#222531@40%, blur 4) |

### chrome (04_OS Chrome 2045:1329)
| StatusBar | 160:79547 | white-bg/black-bg/black-transparent/white-transparent (375×44) |
| HomeIndicator | 160:79588 | 위 4 + sub-transparent (375×34, 134×5 pill) |

### molecules (02_Molecules 2045:1327)
| InputField | 175:8234 | size 56·52·48·38 × default/hover/focus/typing/filled/disabled × leftIcon |
| TextArea | 175:11371 | box/underline |
| Dropdown | 175:10075 | size 56·52·48·36 × states + expanded 옵션패널 |
| CountrySelect | 176:9989 | selected/unselected (국기+이름, 국기는 이모지) |
| FieldValidation | 175:11301 | error/success/warning + helperText |
| SelectCard | 2291:21077 | Default/Variant2 (아이콘+제목+부제+체크박스) |
| CardLine | 176:15525 | payment/default/default-toggle |
| CardBox | 176:15524 | record/purchase/purchase-discount |
| CardAlarm | 176:20652 | active/inactive (요일칩 7개) |
| ChatBubble | 176:21728 | ai/user (비대칭 radius) |
| AvatarCard | 170:9627 | active/inactive |
| PronunciationResult | 2224:20999 | active/inactive (반원 게이지=CustomPainter) |

### organisms (03_Organisms 2045:1328)
| GNB | 162:46473 | main(뒤로+제목)/main-2(뒤로+진행바+n/total)/sub/sub-2(뒤로+제목+닫기) |
| BottomNavBar | 164:441 | 좌·중앙pill·우 3탭 |
| DialogBasic | 175:12790 | default/variant2/variant3 |
| DialogShareProfile | 2235:4652 | |
| BottomSheet | 175:18138 | single/single-sub/two-col/two-row (Dim+시트+HomeIndicator) |
| BottomSheetDocument | 175:18500 | min/normal/max |
| BottomSheetAvatar | 176:13383 | unowned-normal/-discount/owned-unused/-used — **은퇴. AvatarDetail로 대체됨** (호출부 0개, 갤러리 전용) |
| AvatarDetail | 4024:1090 | unowned-normal/-discount/owned-unused/-used — 전면 화면(375×812). `AvatarScreen`이 push |
| BottomSheetSubscription | 176:14577 | manage/change-plan/cancel |
| BottomSheetCountrySelect | 176:12212 | |
| BottomSheetAlarmSettings | 176:13983 | 타임피커+요일 |
| BottomSheetFeedback | 176:15420 | 👎/👍/😍 3옵션 |