# BeaverTalk Flutter — 프로젝트 규칙 (CLAUDE.md)

이 문서는 매 세션 로드되는 **프로젝트 작업 규칙**이다. 모든 작업은 아래 룰을 따른다.

## 작업 규칙 (RULES)

- **R1. 서버 파일 수정 절대 금지.**
  FastAPI 서버(`C:\Users\jaewoo\Desktop\coding\fastapi\SQLAlchemy`)의 어떤 파일도 수정/생성/삭제하지 않는다.
  서버 변경이 필요한 사안(예: CORS 미설정, refresh 토큰 부재)은 **클라이언트 측에서 해결을 시도하고, 불가하면 사용자에게 보고만** 한다. 서버 코드는 읽기(계약 파악) 전용.

- **R2. 착수 전 플랜 우선.**
  실제 구현에 들어가기 전, 관련 전문 에이전트를 소집해 **플랜을 먼저 수립**하고 `docs/`에 저장한 뒤 작업을 시작한다.

- **R3. docs 파일명 규칙.**
  `docs/` 안의 모든 문서 파일명은 **작업 날짜·시간으로 시작**한다. 형식: `YYYY-MM-DD_HHmm_<제목>.md`
  (예: `2026-06-23_2146_flutter-clean-architecture-plan.md`). 시각은 작업 시작 시점의 로컬 시간.

- **R4. CEO 오케스트레이터 전권.**
  CEO(오케스트레이터)가 모든 작업을 관리한다. 작업 분해·에이전트 소집·설계 결정·통합·검증·기록의 전권을 CEO에게 일임한다.

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
