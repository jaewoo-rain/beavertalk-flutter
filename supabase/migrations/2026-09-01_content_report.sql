-- AI 생성 콘텐츠 신고 테이블.
--
-- 배경 — Google Play 생성형 AI 정책이 "사용자가 앱을 벗어나지 않고 불쾌한
-- 콘텐츠를 신고할 수 있는 기능"을 의무화한다. 비버톡은 AI 캐릭터와 음성으로
-- 대화하는 앱이라 정면 대상이고, 신고 경로가 없으면 첫 릴리스가 정책 반려된다.
--
-- 왜 앱 서버(FastAPI)가 아니라 Supabase인가 — 2026-09-01 라이브 OpenAPI를
-- 실측한 결과(경로 41종) 신고 엔드포인트가 없었다. 서버에 신설을 요청하면 그
-- 회신이 출시 임계경로에 얹힌다. 신고 경로는 첫 빌드에 반드시 들어가야 하는
-- 유일한 항목이라 서버 의존을 만들지 않았다.
--
-- ⚠ 이 테이블은 **앱 클라이언트 소유**다. 같은 Postgres를 서버의 alembic이
-- 관리하므로, autogenerate 가 이 테이블을 모르는 객체로 보고 DROP 을 제안할 수
-- 있다. 서버 쪽 alembic env 의 include_object 에서 제외하거나, 서버 모델로
-- 편입할 것.

create table if not exists public.content_report (
  id           bigint generated always as identity primary key,

  -- 신고자. 클라이언트가 보낸 값을 믿지 않고 세션에서 채운다.
  reporter_uid uuid        not null default auth.uid()
                           references auth.users (id) on delete cascade,

  -- 신고 대상 통화. 기록 목록에서 특정 통화를 지목하지 않고 신고하면 null.
  -- public.call 로 FK 를 걸지 않는다 — 그쪽은 alembic 소유라 결합을 만들지 않는다.
  call_id      bigint,

  -- 신고를 시작한 화면. ReportSource.code 와 1:1.
  source       text        not null
                           check (source in ('call_finish', 'record_list')),

  -- 신고 사유. ReportReason.code 와 1:1. **배포 후 코드값을 바꾸지 마라** —
  -- 이미 저장된 신고와 대조가 깨진다.
  reason       text        not null
                           check (reason in (
                             'sexual', 'hate', 'violence',
                             'self_harm', 'misinformation', 'other'
                           )),

  -- 자유 입력. 앱이 500자로 자르지만 DB 에서도 막는다.
  detail       text        check (detail is null or char_length(detail) <= 500),

  -- 신고 당시 표시 언어(BCP-47). 어떤 언어로 오간 대화인지가 검토에 필요하다.
  locale       text,

  -- 운영 처리 상태.
  status       text        not null default 'open'
                           check (status in ('open', 'reviewing', 'resolved', 'rejected')),

  created_at   timestamptz not null default now()
);

comment on table public.content_report is
  'AI 생성 콘텐츠 신고 (Google Play 생성형 AI 정책 대응). 앱 클라이언트 소유 — alembic autogenerate 제외 대상.';

-- 운영자가 미처리분을 최신순으로 본다.
create index if not exists content_report_open_idx
  on public.content_report (created_at desc)
  where status = 'open';

-- 같은 통화에 대한 신고를 모아 본다.
create index if not exists content_report_call_idx
  on public.content_report (call_id)
  where call_id is not null;

alter table public.content_report enable row level security;

-- 로그인한 사용자는 **자기 이름으로만** 신고를 넣을 수 있다.
drop policy if exists content_report_insert_own on public.content_report;
create policy content_report_insert_own
  on public.content_report
  for insert
  to authenticated
  with check (reporter_uid = auth.uid());

-- 자기가 넣은 신고만 읽는다. 남의 신고는 보이지 않는다.
drop policy if exists content_report_select_own on public.content_report;
create policy content_report_select_own
  on public.content_report
  for select
  to authenticated
  using (reporter_uid = auth.uid());

-- 수정·삭제 정책은 두지 않는다. RLS 가 켜져 있고 정책이 없으면 거부가 기본이라,
-- 접수된 신고는 클라이언트가 고치거나 지울 수 없다. 운영은 service_role 로 한다.
