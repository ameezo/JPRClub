# Implementation Plan

## Overview
Each milestone produces a working increment. No milestone is started until the previous one is verified.

---

## Milestone 1: Design Foundation
**Goal**: Migrate the selected prototype to React + TypeScript, preserving the approved visual identity.

### Deliverables
- [x] Vite + React + TypeScript project in `frontend/`.
- [x] Design tokens and shared CSS migrated from prototype.
- [x] Reusable components: `Navbar`, `Footer`, `SessionCard`, `PhotoGallery`, `LanguageToggle`.
- [x] Homepage reproducing Concept A (photos) layout exactly.
- [x] React Router routes: `/` (home), `/sessions`, `/studio`, `/resources`, `/journal`, `/about`.
- [x] i18n with react-i18next: EN default, AR toggle with RTL.
- [x] Google Fonts loaded: Inter + Noto Naskh Arabic.
- [x] Responsive mobile layout with collapsible navigation.
- [x] All data still hardcoded (same fictional content from prototype).

### Verification
- Side-by-side comparison: React homepage vs. original prototype.
- AR toggle works with RTL layout.
- Mobile responsive behavior.
- All routes render placeholder pages.

### What Remains Mocked After This Milestone
- All session data is hardcoded.
- All links go to placeholder pages.
- No backend, no database, no authentication.

---

## Milestone 2: First Session Flow
**Goal**: Admin can sign in, create a session draft, publish it, and the homepage automatically shows the next upcoming published session.

### Deliverables
- [ ] FastAPI backend in `backend/` with PostgreSQL.
- [ ] Docker Compose: `frontend`, `backend`, `postgres` services.
- [ ] Database schema: `users`, `sessions` tables.
- [ ] Alembic migration for initial schema.
- [ ] API endpoints (see `api-contracts/sessions.md`):
  - `POST /api/auth/login` — Admin login (JWT).
  - `GET /api/sessions` — List published sessions (public).
  - `GET /api/sessions/{id}` — Session detail (public).
  - `POST /api/sessions` — Create draft (admin).
  - `PATCH /api/sessions/{id}` — Update session (admin).
  - `POST /api/sessions/{id}/publish` — Publish a draft (admin).
  - `GET /api/sessions/next` — Next upcoming published session (public, for homepage).
- [ ] Permission checks: only admin can create/publish.
- [ ] Homepage fetches next session from API instead of hardcoded data.
- [ ] Session detail page at `/sessions/{id}`.
- [ ] Sessions list page at `/sessions`.
- [ ] Date/timezone: store as UTC, display in user's local timezone.
- [ ] Concurrent-edit protection: `updated_at` optimistic locking.
- [ ] Duplicate-request protection: idempotency key on create.
- [ ] Seed script with one admin user.
- [ ] Handle "no upcoming session" state on homepage gracefully.

### Verification
- Admin logs in → creates session → publishes → it appears on homepage.
- Draft and cancelled sessions do NOT appear on homepage.
- Public session list shows only published sessions.
- Concurrent edit returns conflict error.
- Tests: API endpoints, permission checks.

### What Remains Mocked
- Session photos (still placeholder).
- Reading Studio, Journal, Resources pages are still placeholders.
- Member registration and verification not implemented.
- Photo gallery still uses placeholder images.

---

## Milestone 3: Session Management
**Goal**: Full session lifecycle — scheduling, cancellation, editing.

### Deliverables
- [ ] Session statuses: `draft`, `published`, `cancelled`, `completed`.
- [ ] Monthly scheduling support (recurring sessions).
- [ ] Admin can cancel a published session.
- [ ] Admin can mark a session as completed.
- [ ] Edit conflict handling (optimistic locking with version).
- [ ] Duplicate session protection (same date + same title check).
- [ ] Session management UI in admin dashboard.

---

## Milestone 4: Reading Studio
**Goal**: Document existing sessions with summaries, photos, and notes.

### Deliverables
- [ ] Studio page for each completed session.
- [ ] Photo upload for session documentation.
- [ ] Summary and notes editor.
- [ ] Recent-session cards on homepage link to real Studio pages.
- [ ] Photo gallery on homepage shows real session photos.

---

## Milestone 5: Journal Workflow (Current)
**Goal**: Member verification → draft submission → approval → public article.

### Deliverables
- [x] Member registration (email + password).
- [x] Member requests verification from admin.
- [x] Verified member can create journal draft and submit it.
- [x] Admin reviews and approves/rejects submissions.
- [x] Published articles appear on Journal page.
- [x] Articles stay in their original language.

---

## Milestone 6: Remaining Content (Current)
**Goal**: Resources, About, annual reports, downloadable PDFs.

### Deliverables
- [x] Resources page with preparation guides.
- [x] About page.
- [x] Annual Reports page (web view + downloadable PDF).
- [x] Contact section.

---

## Milestone 7: Deployment (Current)
**Goal**: Production deployment with persistent data, media storage, backups.

### Deliverables
- [x] Production Docker Compose configuration.
- [x] Cloudflare Tunnel (`cloudflared`) integration (Replaced Caddy).
- [x] Persistent PostgreSQL volume.
- [x] Persistent media storage volume.
- [x] Backup strategy documented.
- [x] Deployment instructions in docs (`DEPLOYMENT.md`).
- [x] Environment variable documentation.

---

---

## Phase 2: Automated Annual Reports

### Milestone 2.1: Inspection & Plan Approval (Completed)
- [x] Baseline database, tests, migrations, and layout spacing inspected.
- [x] Database recovery checkpoint created (`checkpoint_before_milestone2.sql`).
- [x] Plan reviewed and approved with recorded corrections.

### Milestone 2.2: Post-Session Attendance & Feedback Entry (In Progress)
**Goal**: Admin can record structured post-session metrics, attendance visits (unknown vs zero), feedback card tallies, and reviewed anonymous quotes with explicit publication permissions.

#### Scope & Deliverables
- [ ] Database Schema & Alembic Migration:
  - `session_metrics` table with `attendance_visits`, `actual_date`, `actual_duration_minutes`, `attendance_in_person`, `attendance_online`, `counting_method`, `staff_included`, `feedback_cards_received`, 1-5 rating counts, `unrated_count`, `tally_completed`, `internal_notes`, `version`.
  - `feedback_quotes` table with `quote_text`, `source_language`, `source_type`, `permission_to_publish` (default `false`), `is_reviewed` (default `false`), `is_highlight`, `reviewed_by`, `reviewed_at`.
  - `exclude_from_reports` boolean column on `sessions` (default `false`) for explicit test/demo exclusion.
- [ ] Backend API (`app/api/session_metrics.py` & schemas):
  - `GET /api/sessions/{id}/metrics` (admin/organizer only)
  - `PUT /api/sessions/{id}/metrics` (optimistic locking with `version`, partial drafts permitted, tally reconciliation enforced when `tally_completed` is true)
  - `GET /api/sessions/{id}/quotes` (admin/organizer only)
  - `POST /api/sessions/{id}/quotes` (permission defaults to `false`, reviews recorded)
  - `PATCH /api/sessions/{id}/quotes/{quote_id}` (verifies quote belongs to session in URL)
  - `DELETE /api/sessions/{id}/quotes/{quote_id}` (verifies quote belongs to session in URL)
- [ ] Privacy & Data Integrity Rules:
  - Unknown vs confirmed zero: `null` preserved, never converted to 0.
  - Hybrid attendance split: in-person and online are optional.
  - Private notes & unreviewed/unpermitted quotes strictly excluded from public responses.
  - Concurrent-edit protection: version mismatch returns HTTP 409 Conflict.
- [ ] Frontend Admin UI:
  - Attendance & Feedback metrics panel in Session Documenter / Management.
  - Form validation with warning badges for tally discrepancies.
  - Reviewed quotes management with publication permission toggles.
- [ ] Testing & Verification:
  - Backend integration test suite covering save/reload, unknown vs 0, tally draft vs complete, quote permission defaults, URL path validation, privacy shielding, and optimistic lock conflicts.
  - Verification that existing session and Studio endpoints still pass.

---

## Per-Milestone Checklist
Each milestone must include:
- [ ] An implementation plan limited to that milestone.
- [ ] Working frontend and backend integration where applicable.
- [ ] Relevant tests and browser verification.
- [ ] Updated documentation.
- [ ] A clear statement of what works, what remains mocked, and what was not tested.
