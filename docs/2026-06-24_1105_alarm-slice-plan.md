# BeaverTalk Flutter — alarm 도메인 서버 연동 플랜 (2차)

- 작성: 2026-06-24 11:05 (CEO, 서버 실측 + 기존 UI 분석 기반)
- 전제: 1차 auth 슬라이스([2026-06-23 플랜](2026-06-23_2146_flutter-clean-architecture-plan.md))를 템플릿으로 동일 패턴 복제.
- 범위: `alarms` CRUD + 활성/비활성 실연동. 기존 `alarm_list`/`alarm_add` UI 재사용.

> R1: 서버 파일 수정 금지. character 부족 등은 클라이언트에서 해결/보고.

## 0. 서버 실측 (확정)

- `GET /alarms` → `list[AlarmOut]` (빈 경우 `[]`)
- `POST /alarms` (201) body `AlarmCreate`: `{character_id:int, time:datetime, is_activate:bool=true, days_of_week:[<MON..SUN>]}`
- `GET /alarms/{id}` → `AlarmOut`
- `PUT /alarms/{id}` body `AlarmUpdate`(부분): `{time?, character_id?, is_activate?, days_of_week?}`
- `DELETE /alarms/{id}` → 204
- `POST /alarms/{id}/activate` · `/deactivate` → `AlarmOut`
- **AlarmOut**: `{alarm_id:int, time:datetime?, is_activate:bool?, character:{character_id:int, name:str, image_url:str?}, days_of_week:list[str]}`
  - 실응답 예: `{"alarm_id":1,"time":"2026-06-24T07:30:00Z","is_activate":true,"character":{"character_id":1,"name":"비비","image_url":null},"days_of_week":["MON","WED","FRI"]}`
- `GET /characters?limit=` → `list[CharacterSummary]`. 현재 시드 **`{character_id:1, name:"비비"}` 1개뿐**.

## 1. 매핑 결정 (구현 계약)

### time ↔ hour/minute/meridiem
- 알람 시각은 **타임존 비종속 벽시계(wall clock)** 로 취급한다.
- **전송(POST/PUT)**: 12h→24h 변환 후 고정 기준일에 naive ISO로 보낸다 → `2000-01-01THH:MM:00` (Z 없음). 날짜부는 의미 없음(서버가 그대로 echo).
- **파싱(read)**: 서버가 보낸 값을 `DateTime.parse(...).toUtc()` 로 읽어 **hour/minute를 그대로** 취한다(서버는 우리가 보낸 벽시계에 Z만 붙여 돌려줌 → UTC 필드가 곧 벽시계). 로컬 타임존 변환 금지(시각 밀림 방지).
- 24h→(hour 1–12, meridiem) 변환: `meridiem = h<12 ? am : pm; hour12 = h%12==0 ? 12 : h%12`.

### days_of_week ↔ days[7]
- UI `days[7]` 는 **0=Sun … 6=Sat** (alarm_models.dart 주석 확정).
- 인덱스→코드 테이블: `['SUN','MON','TUE','WED','THU','FRI','SAT']`.
- 전송: `days[i]==true` 인 인덱스의 코드 배열. 파싱: 코드 집합으로 bool[7] 복원.

### character_id (필수 입력 — 핵심 이슈)
- 서버 POST는 `character_id` 필수인데, 기존 UI partnerId(`beaver`/`judi`)는 mock이라 서버와 무관.
- **이번 슬라이스 결정**: alarm data 계층에 **읽기 전용 `GET /characters` 조회**(`availableCharactersProvider`)를 추가해 실제 캐릭터로 picker를 채운다. 기본 선택 = 첫 캐릭터(또는 `members/me.character_id` 있으면 그것). 카드/리스트의 파트너 표시는 **서버가 돌려준 `character.name`** 사용.
- 현재 시드가 1개(비비)뿐이라 picker는 사실상 비비만 노출 → **알려진 제약으로 기록**. 다중 캐릭터 선택·구매는 추후 characters 슬라이스에서 확장.
- partner 이미지: 서버 `image_url`이 null이면 기존 `beaverImage` 등 정적 자산으로 폴백(표시 전용).

## 2. 파일 구조 (auth 패턴 복제)

```
lib/features/alarm/
├── domain/
│   ├── entities/alarm.dart            # Alarm 엔티티(순수 Dart): id, hour, minute, isAm, days(bool[7] Sun..Sat), characterId, characterName, imageUrl, active
│   └── repositories/alarm_repository.dart  # list/create/get/update/delete/activate/deactivate
├── data/
│   ├── models/alarm_dto.dart          # AlarmDto.fromJson + toEntity; CreateBody/UpdateBody 빌더(time/days 매핑은 여기)
│   ├── datasources/alarm_remote_data_source.dart  # dio 호출(7개)
│   └── repositories/alarm_repository_impl.dart     # DTO↔entity, DioException→AppException
└── presentation/
    ├── providers/alarm_providers.dart  # datasource/repository 배선 + availableCharactersProvider
    └── providers/alarm_list_controller.dart  # AsyncNotifier<List<Alarm>>: load/add/update/remove/toggleActive/toggleDay
```
- 캐릭터 조회는 alarm 슬라이스 내부에 최소 추가(`GET /characters` 단건). 추후 characters 슬라이스로 승격 시 이전.

## 3. 화면 개조 (UI 무변경, 배선만)

- `lib/screens/alarm/alarm_list.dart`: `StatefulWidget` → `ConsumerStatefulWidget`. 로컬 `_alarms` 시드 제거 → `ref.watch(alarmListControllerProvider)` (AsyncValue.when: loading/error/data). 
  - Dismissible 삭제 → `removeAt` 대신 `controller.remove(id)` (DELETE).
  - 카드 토글(onChanged) → `controller.toggleActive(id, v)` (activate/deactivate).
  - 카드 요일 토글(onDayChange) → `controller.toggleDay(id, idx, v)` (PUT).
  - 탭 편집(onTap) → 편집 시트 결과를 `controller.update(...)` (PUT).
  - "새 일정 추가" → 추가 시트 결과를 `controller.add(...)` (POST).
  - 빈 목록이면 기존 `alarm_empty.dart` 노출.
- `lib/screens/alarm/alarm_add.dart` + `bottom_sheet_alarm_settings.dart`: 저장 시 `AlarmData`(편집용 view-model, copy()로 스테이징 유지) ↔ 엔티티 변환. partner 선택 소스를 `kAlarmPartners`(mock)에서 **서버 캐릭터(availableCharactersProvider)**로 교체. `AlarmData`에 `id:int?`, `characterId:int` 추가(기존 `partnerId` 대체 또는 병행).
- 변환 매퍼는 presentation에 두되, time/days 직렬화는 data 계층(DTO)에서만.

## 4. 상태/동기화 전략

- `alarmListControllerProvider = AsyncNotifierProvider<AlarmListController, List<Alarm>>`.
- 최초 `build()` 에서 `GET /alarms` 로드.
- 변이(add/update/remove/toggle*)는 **API 호출 → 반환 AlarmOut 으로 상태 갱신**(낙관적 대신 서버 응답 신뢰). 실패 시 AppException → 스낵바, 상태 롤백/유지.
- 토글류는 즉시 반영이 UX상 중요 → 낙관적 업데이트 후 실패 시 되돌림(선택). 1차는 단순 await 후 갱신으로 시작.

## 5. 검증

- `flutter analyze` No issues 유지(riverpod_lint 포함).
- domain 순수성: `features/alarm/domain` 에 flutter/dio/riverpod import 0건.
- 단위: `alarm_dto` 의 time/days 라운드트립(07:30/AM·[Sun..] ↔ `2000-01-01T07:30`·[codes]) 테스트.
- e2e(크롬, run-web-chrome 스킬): 알람 생성→목록 표시→토글(activate/deactivate)→요일/시간 수정(PUT)→삭제(DELETE) 라운드트립을 콘솔 로그/화면으로 확인. 새로고침 후에도 서버에서 다시 로드되는지 확인.

## 6. 분담

| 단계 | 담당 | 산출 |
|---|---|---|
| alarm 슬라이스 구현 + 화면 배선 | `flutter-developer` | features/alarm/* + alarm_list/alarm_add 개조 |
| 구조/경계 검토 | `clean-architecture` | 의존성 방향·DTO 비누출 점검 |
| 통합·검증·기록 | CEO | analyze + 크롬 e2e + HANDOFF 갱신 |

## 7. 알려진 제약 / 보고 사항

- 서버 시드 캐릭터 1개(비비) → 알람 파트너 선택 폭 제한. 다중 캐릭터는 characters 슬라이스에서.
- web CORS: 서버 무수정(R1) → 크롬은 dev 보안우회로 검증(run-web-chrome 스킬).
- 알람 시각 타임존: 벽시계 취급으로 통일(서버 datetime의 tz 의미 부여 안 함).
