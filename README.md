# Vakantie-planner

A single-file vacation planner (Dutch UI). Plan holidays, drag activities onto a day/segment grid, organise a backlog, and filter by category.

The whole app is one static file — `index.html` — with no build step. It runs in any modern browser.

## Storage

State is kept in two places:

- **localStorage** — instant, offline, per-device cache.
- **Supabase** — a single shared row (`planner_state` table) so the plan syncs across devices and browsers. Last write wins. No login.

Supabase config lives in the `CLOUD` block near the top of the `<script>` in `index.html` (project URL + anon public key — both safe to ship in client code).

## Setup

1. Run [`supabase_setup.sql`](./supabase_setup.sql) once in the Supabase dashboard (SQL Editor → New query → Run). This creates the table and the anon read/write RLS policies.
2. Make sure the `CLOUD` block in `index.html` has your project URL and anon key.

## Deploy

Hosted on Vercel as a static site. Pushing to `main` triggers an automatic deploy — there's no build command (output is `index.html` at the repo root).
