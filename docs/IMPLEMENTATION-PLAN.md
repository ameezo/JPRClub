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

## Milestone 5: Journal Workflow
**Goal**: Member verification → draft submission → approval → public article.

### Deliverables
- [ ] Member registration (email + password).
- [ ] Member requests verification from admin.
- [ ] Verified member can create journal draft and submit it.
- [ ] Admin reviews and approves/rejects submissions.
- [ ] Published articles appear on Journal page.
- [ ] Articles stay in their original language.

---

## Milestone 6: Remaining Content
**Goal**: Resources, About, annual reports, downloadable PDFs.

### Deliverables
- [ ] Resources page with preparation guides.
- [ ] About page.
- [ ] Annual Reports page (web view + downloadable PDF).
- [ ] Contact section.

---

## Milestone 7: Deployment
**Goal**: Production deployment with persistent data, media storage, backups.

### Deliverables
- [ ] Production Docker Compose configuration.
- [ ] Caddy reverse proxy with TLS.
- [ ] Persistent PostgreSQL volume.
- [ ] Persistent media storage volume.
- [ ] Backup strategy documented.
- [ ] Deployment instructions in docs.
- [ ] Environment variable documentation.

---

## Per-Milestone Checklist
Each milestone must include:
- [ ] An implementation plan limited to that milestone.
- [ ] Working frontend and backend integration where applicable.
- [ ] Relevant tests and browser verification.
- [ ] Updated documentation.
- [ ] A clear statement of what works, what remains mocked, and what was not tested.
