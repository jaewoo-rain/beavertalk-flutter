# BeaverTalk Flutter — 프로젝트 규칙 (CLAUDE.md)

이 문서는 매 세션 로드되는 **프로젝트 작업 규칙**이다. 모든 작업은 아래 룰을 따른다.

## 작업 규칙 (RULES)

- **R1. 서버 파일은 CEO가 직접 수정하지 않는다 (제안→사용자 적용).**
  FastAPI 서버(`C:\Users\jaewoo\Desktop\coding\fastapi\SQLAlchemy`)의 파일을 CEO/에이전트가 직접 수정/생성/삭제하지 않는다(읽기=계약 파악은 허용).
  서버 변경이 필요하면 **먼저 클라이언트 측 해결을 시도**하고, 클라이언트로 못 푸는 사안은 **정확한 변경안(파일·코드 스니펫)을 사용자에게 제안**한다. 사용자가 "내가 바꿔줄게"라고 한 경우, 변경은 **사용자가 직접 적용**한다.

- **R2. 착수 전 플랜 우선.**
  실제 구현에 들어가기 전, 관련 전문 에이전트를 소집해 **플랜을 먼저 수립**하고 `docs/`에 저장한 뒤 작업을 시작한다.

- **R3. 플랜은 docs에 저장하고, 파일명은 "작업일시 + 간략한 내용".**
  플랜을 세울 때는 반드시 `docs/` 폴더에 문서로 저장한다. 파일명은 **맨 앞에 작업하는 날짜·시간**을 쓰고, **그 뒤에 작업 내용을 간략히** 붙인다.
  형식: `YYYY-MM-DD_HHmm_<간략한-내용>.md` (예: `2026-06-23_2146_flutter-clean-architecture-plan.md`). 시각은 작업 시작 시점의 로컬 시간.

- **R4. CEO 오케스트레이터 전권.**
  CEO(오케스트레이터)가 모든 작업을 관리한다. 작업 분해·에이전트 소집·설계 결정·통합·검증·기록의 전권을 CEO에게 일임한다.

- **R5. 보고 규약 — 결론은 네가 위로 올려야 한다 (pull 아님, push다).**
  판넬/탭으로 나뉜 에이전트는 **자기 판넬에 입력이 들어와야 도는 구조**다. 상위 에이전트는 너를 감시하지 못하고, 네가 결론을 내도 자동으로 전달되지 않는다. **네가 상위를 깨워야 한다.**

  - **대상**: 너에게 일을 지시한 에이전트. 명령은 `herdr agent prompt <상위이름> "<보고>"`.
    상위가 누구인지 모르면 추측하지 말고 물어라. 이름은 세션마다 달라질 수 있다(`herdr agent list`로 확인).
  - **보고하는 경우 — 이 3가지만**
    1. **게이트급 결론 — 즉시.** 판단이 필요한 숫자·판정이 나온 순간. 나머지를 끝내고 모아 보내지 마라. 늦으면 다른 탭이 틀린 전제로 계속 간다
    2. **막혔을 때** — 상위의 결정이 필요해 더 못 갈 때. 혼자 추측해서 밀고 나가지 마라
    3. **맡은 일이 끝났을 때**
  - **보고하지 않는 것**: 중간 진행 중계("파일 3개 읽었다", "이제 시작한다"), 이미 받은 지시의 복창. 노이즈다.
  - **형식 — 짧게**
    ```
    [내이름] 한 줄 결론
    근거: (숫자면 숫자, 판정이면 판정)
    문서: docs/... (있으면)
    필요한 결정: (있으면. 없으면 "없음")
    ```
  - **주의**
    - 상위에 보고했다고 사장님께 보고된 게 아니다. 취합해서 올리는 건 상위의 몫이다
    - **보고하고 답을 기다리며 멈추지 마라.** 답 없이 진행 가능한 일이 남았으면 계속하라. 진짜로 막혔을 때만 멈춰라
    - 네가 하위 에이전트를 소환했다면 **이 규약을 그대로 아래로 내려라**

- **R6. 하위 에이전트의 보고를 검증 없이 위로 올리지 마라.**
  특히 **코드에 관한 사실 주장**(어느 파일에 어느 필드가 있다/없다, 무엇이 어떻게 동작한다, 어느 브랜치에 무엇이 들어있다)은 **네 눈으로 1차 자료를 확인한 뒤** 올린다. 하위가 유능해도 예외 없다.
  **이유**: 중계된 오류는 상위에서 안 걸리면 **그대로 설계 결정이 된다.** 실제 사례(2026-08-05) — 하위가 "서버가 `turn_id` 를 안 보낸다"고 보고했고 검증 없이 백엔드에 올렸는데, 서버는 예전부터 필수 필드로 보내고 있었고 **클라가 안 읽고 있었을 뿐**이었다. 백엔드가 `protocol.py` 를 직접 안 열어봤다면 불필요한 서버 변경과 프로토콜 오염으로 갔다.
  같은 규칙이 **문서에서 옮겨 적은 숫자**에도 적용된다 — 원가·공수·상수는 1차 자료(코드/실측)를 확인하고 인용한다. 이 세션에서 `_cushionMaxBytes` 를 주석에 남은 과거 값(1800ms)으로 보고했다가 실제 값(1200ms)으로 정정한 사례가 있다.
  확인 못 한 것은 **"확인 못 했다"고 명시**해서 올린다. 추측으로 채우지 않는다.

- **R7. Claude 에이전트는 항상 `--dangerously-skip-permissions` 로 띄운다.**
  herdr 로 새 Claude 를 소환할 때 네이티브 인자를 `--` 뒤에 붙인다:
  ```
  herdr agent start <이름> --kind claude --pane <pane_id> -- --dangerously-skip-permissions
  ```
  `--` 를 빠뜨리면 herdr 자신의 플래그로 파싱돼 실패한다. 판넬을 직접 열어 수동으로 띄울 때도 `claude --dangerously-skip-permissions` 를 쓴다.

- **R8. gitignore 된 파일은 워크트리에 따라오지 않는다 — 새 워크트리를 파면 직접 챙겨라.**
  - **`docs/`** (.gitignore:53) — 워크트리를 새로 만들거나 브랜치를 갈아타도 **문서가 따라오지 않는다.** 다른 탭/워크트리에 읽히려면 **절대경로로 알려주거나 직접 복사**해야 한다. 워크트리에서 고쳐도 git 으로 병합되지 않으니 수동 동기화가 필요하다.
  - **`.env`** (.gitignore:54) — 없으면 **테스트가 아예 안 돈다** (`No file or variants found for asset: .env`).
  - **`android/app/google-services.json`** (.gitignore:58) — 없으면 **APK 빌드가 깨진다** (`Execution failed for task ':app:processDebugGoogleServices' > File google-services.json is missing`).
    ⚠ **`flutter analyze` 와 `flutter test` 는 이걸 안 탄다** — 위젯테스트는 Dart VM 에서 돌아 Android 빌드 경로를 거치지 않는다. 그래서 **analyze·test 가 전부 그린인데 APK 만 안 나오는** 상태가 만들어진다(2026-08-05 실제 발생). 실기기 검증 직전에야 발견된다.
  ```
  # 새 워크트리를 판 직후 반드시
  cp -r <main-worktree>/docs/. <new-worktree>/docs/
  cp <main-worktree>/.env <new-worktree>/.env
  cp <main-worktree>/android/app/google-services.json <new-worktree>/android/app/
  # 그리고 test 만 믿지 말고 한 번은 빌드까지 돌려볼 것
  flutter build apk --debug
  ```

- **R9. `flutter analyze` 가 `riverpod_lint` 를 태운다고 믿지 마라 — "analyze 무이슈"는 반쪽 보고일 수 있다.**
  `analysis_options.yaml:15` 가 `custom_lint` 플러그인을 켜고 `pubspec.yaml` 이 `riverpod_lint` 를 걸어 뒀지만, **`flutter analyze` 결과에 그 플러그인 지적이 들어온다는 보장이 없다.** `dart run custom_lint` 를 **별도 게이트로** 돌려야 한다.
  **실측(2026-08-07)** — `flutter analyze` 를 여러 번 돌렸다. 대부분(내 3회 + 담당 5회)은 **~4초 만에 "No issues found"** 로 끝났고 riverpod_lint 지적이 안 나왔다. 그런데 **딱 한 번 46.2초가 걸리며 "8 issues found" 로 그 지적을 포함해 냈다.** 재현 조건은 **찾지 못했고**, 그 8건의 내역도 **확인 못 했다**(플러그인 로딩이 붙느냐 마느냐로 갈리는 것으로 보이나 미확인).
  ⛔ **그래서 결론이 약해지는 게 아니라 세진다 — 간헐적으로만 보이는 검사는 초록이어도 의미가 없다.** 한 번의 실행 결과로 판정하지 마라.
  같은 시기에 `dart run custom_lint` 로 돌리니 `avoid_public_notifier_properties` 7건이 나왔다. Riverpod provider 를 직접 만진 작업일수록 이 구멍이 정확히 그 영역을 비껴간다.
  ⚠ **`build/` 가 있으면 `PathNotFoundException` 으로 죽는다** — flutter_local_notifications 의 gradle transform 경로에 와일드카드가 들어가 있어서다. **"잔재"가 아니라 방금 성공한 빌드가 만든 `build/` 로도 즉시 죽는다**(2026-08-07 실측 재현). 그래서 **두 게이트는 순서가 강제된다**:
  ```
  build/ 삭제  →  dart run custom_lint  →  flutter build apk --debug
  ```
  빌드가 먼저면 린트를 못 돌리고, 린트를 다시 돌리려면 APK 를 또 날려야 한다. **실기기 검증용 APK 가 필요하면 반드시 이 순서로** — 린트 먼저, 빌드 나중.
  ⚠ 그 경로는 **260자를 넘어 `Remove-Item` 으로 안 지워진다**(열지를 못한다). `robocopy /MIR` 로 빈 폴더를 덮어써서 지운다.
  지적이 나오면 **내가 넣은 것과 원래 있던 것을 가른다.** 내 몫은 되도록 `ignore` 로 덮지 말고 구조로 푼다(예: public getter 3개 → 메서드 1개). 기존 것은 손대지 말고 건수·파일만 보고한다.

## 기술 스택 결정 (확정)

- **상태관리: Riverpod** (`flutter_riverpod`) — Flutter 입문자 친화 목적.
- **HTTP: dio** / **토큰 저장: flutter_secure_storage**.
- **아키텍처: 클린 아키텍처 (feature-first)** — `features/<도메인>/{domain,data,presentation}` + 횡단 공통 `core/{network,error,storage,di}`.
- **usecase 계층: 1차 생략** (단일 동작은 provider→repository 직접 호출). 다중 repository 조합 등 복잡성이 생기면 그때 도입.
- **DTO 직렬화: 1차 수기 fromJson/toJson** (freezed/codegen은 도메인이 늘면 도입 검토).

## 서버 연동 핵심 계약 (참조)

- Base URL: `http(s)://<host>/api/v1`. 인증: `Authorization: Bearer <access_token>` (JWT, 만료 7일, refresh 없음).
- 로그인 `POST /auth/login` 은 **OAuth2 form (x-www-form-urlencoded, username=email, password)** → `{access_token, token_type}`. 그 외는 JSON.
- 에러 바디: `{"detail":{"code","message"}}` (단, FastAPI 422 검증은 `detail`이 배열일 수 있어 양쪽 방어 파싱).
- 로컬 접속: Android 에뮬레이터 `10.0.2.2:8000`, iOS/web `localhost:8000`, 실기기 `<PC LAN IP>:8000`(서버를 `--host 0.0.0.0`로 실행).

## 팀 / 오케스트레이션

`.claude/skills/beavertalk-dev` (CEO 스킬) 참조. 에이전트는 `.claude/agents/` 에 정의. Flutter 구현은 `flutter-developer`, 구조 검토는 `clean-architecture`, 통합 신뢰성은 `api-integration-expert`.
