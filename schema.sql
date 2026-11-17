-- 学校アンケート Cloud Edition: Supabase SQL Editorで実行
create extension if not exists pgcrypto;
create table if not exists public.surveys(
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 title text not null check(char_length(title) between 1 and 200),
 description text not null default '',
 questions jsonb not null default '[]'::jsonb,
 slug text not null unique,
 is_published boolean not null default false,
 created_at timestamptz not null default now()
);
create table if not exists public.responses(
 id uuid primary key default gen_random_uuid(),
 survey_id uuid not null references public.surveys(id) on delete cascade,
 answers jsonb not null,
 created_at timestamptz not null default now()
);
create index if not exists surveys_owner_idx on public.surveys(owner_id);
create index if not exists responses_survey_idx on public.responses(survey_id);
alter table public.surveys enable row level security;
alter table public.responses enable row level security;
revoke all on public.surveys from anon,authenticated;
revoke all on public.responses from anon,authenticated;
grant select on public.surveys to anon;
grant select,insert,update,delete on public.surveys to authenticated;
grant insert on public.responses to anon,authenticated;
grant select on public.responses to authenticated;
drop policy if exists "Public read published surveys" on public.surveys;
create policy "Public read published surveys" on public.surveys for select to anon using(is_published=true);
drop policy if exists "Owners manage own surveys" on public.surveys;
create policy "Owners manage own surveys" on public.surveys for all to authenticated
using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
drop policy if exists "Public submit to published surveys" on public.responses;
create policy "Public submit to published surveys" on public.responses for insert to anon,authenticated
with check(exists(select 1 from public.surveys s where s.id=survey_id and s.is_published=true));
drop policy if exists "Owners read own survey responses" on public.responses;
create policy "Owners read own survey responses" on public.responses for select to authenticated
using(exists(select 1 from public.surveys s where s.id=survey_id and s.owner_id=(select auth.uid())));
-- 学生（anon）は回答を読む/変更/削除できません。先生も回答内容の変更/削除はできない設定です。
