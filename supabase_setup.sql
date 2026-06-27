-- Vakantie-planner: Supabase schema + RLS
-- Run this once in the Supabase dashboard → SQL Editor → New query → Run.
-- Safe to re-run (idempotent).

-- 1. Single-row table that stores the whole app state as JSON.
create table if not exists public.planner_state (
  id          text primary key,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

-- 2. Enable Row Level Security.
alter table public.planner_state enable row level security;

-- 3. Policies: allow the public (anon) key to read and write the shared row.
--    No login is used, so the planner is shared by anyone with the URL.
drop policy if exists "anon read planner_state"   on public.planner_state;
drop policy if exists "anon insert planner_state" on public.planner_state;
drop policy if exists "anon update planner_state" on public.planner_state;

create policy "anon read planner_state"
  on public.planner_state for select
  using (true);

create policy "anon insert planner_state"
  on public.planner_state for insert
  with check (true);

create policy "anon update planner_state"
  on public.planner_state for update
  using (true) with check (true);

-- 4. Seed the shared row so the first load has something to read.
insert into public.planner_state (id, data)
values ('shared', '{}'::jsonb)
on conflict (id) do nothing;
