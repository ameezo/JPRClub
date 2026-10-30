# Feature-to-Implementation Map

> **Status legend**: ✅ Exists | 🔲 Planned | ❌ Out of scope

## Homepage

| Feature | Status | Frontend Files | Backend Files | Notes |
|---|---|---|---|---|
| Hero with video background | ✅ Prototype | `features/home/Hero.tsx`, `styles/concept-a.css` | — | Migrate from `concept-a-photos.html` |
| Session panel (next session) | ✅ Prototype (hardcoded) | `features/home/Hero.tsx` | `api/sessions.py` → `GET /api/sessions/next` | Replace hardcoded data with API call |
| "Join Next Session" button | ✅ Prototype (nonfunctional) | `features/home/Hero.tsx` | — | Links to session detail page |
| Recent session cards (×3) | ✅ Prototype (hardcoded) | `components/SessionCard.tsx`, `features/home/RecentSessions.tsx` | `api/sessions.py` → `GET /api/sessions?limit=3&status=completed` | Replace hardcoded data |
| Community photo gallery | ✅ Prototype (placeholder images) | `components/PhotoGallery.tsx`, `features/home/Gallery.tsx` | `api/sessions.py` → session photos | Replace picsum.photos with real uploads |
| Language toggle (EN/AR) | ✅ Prototype | `components/LanguageToggle.tsx` | — | Migrate from `main.js` to react-i18next |

## Navigation

| Feature | Status | Frontend Files | Notes |
|---|---|---|---|
| Sessions link | ✅ Prototype (nonfunctional) | `components/Navbar.tsx` | Route to `/sessions` |
| Reading Studio link | ✅ Prototype (nonfunctional) | `components/Navbar.tsx` | Route to `/studio` |
| Resources link | ✅ Prototype (nonfunctional) | `components/Navbar.tsx` | Route to `/resources` |
| Journal link | ✅ Prototype (nonfunctional) | `components/Navbar.tsx` | Route to `/journal` |
| Mobile hamburger menu | 🔲 Planned | `components/Navbar.tsx` | Not in prototype |

## Sessions

| Feature | Status | Frontend Files | Backend Files |
|---|---|---|---|
| Session list (public) | 🔲 Planned | `features/sessions/SessionList.tsx` | `api/sessions.py` → `GET /api/sessions` |
| Session detail page | 🔲 Planned | `features/sessions/SessionDetail.tsx` | `api/sessions.py` → `GET /api/sessions/{id}` |
| Create session (admin) | 🔲 Planned | `features/management/SessionForm.tsx` | `api/sessions.py` → `POST /api/sessions` |
| Edit session (admin) | 🔲 Planned | `features/management/SessionForm.tsx` | `api/sessions.py` → `PATCH /api/sessions/{id}` |
| Publish session (admin) | 🔲 Planned | `features/management/SessionForm.tsx` | `api/sessions.py` → `POST /api/sessions/{id}/publish` |
| Cancel session (admin) | 🔲 Planned | `features/management/SessionList.tsx` | `api/sessions.py` → `POST /api/sessions/{id}/cancel` |

## Reading Studio

| Feature | Status | Frontend Files | Backend Files |
|---|---|---|---|
| Studio page per session | 🔲 Planned | `features/studio/StudioPage.tsx` | `api/sessions.py` (studio content attached to session) |
| Upload photos | 🔲 Planned | `features/studio/PhotoUpload.tsx` | `services/media.py` |
| Summary and notes | 🔲 Planned | `features/studio/SummaryEditor.tsx` | `api/sessions.py` |

## Journal

| Feature | Status | Frontend Files | Backend Files |
|---|---|---|---|
| Article listing | 🔲 Planned | `features/journal/JournalList.tsx` | `api/journal.py` → `GET /api/journal` |
| Article view | 🔲 Planned | `features/journal/ArticleView.tsx` | `api/journal.py` → `GET /api/journal/{id}` |
| Draft creation (verified member) | 🔲 Planned | `features/journal/ArticleEditor.tsx` | `api/journal.py` → `POST /api/journal` |
| Approval workflow | 🔲 Planned | `features/management/ReviewQueue.tsx` | `services/publishing.py` |

## Resources / About / Annual Reports / Connect

| Feature | Status | Frontend Files | Backend Files | Notes |
|---|---|---|---|---|
| Resources page | ✅ Implemented | `features/resources/ResourcesPage.tsx` | — | Language and grammar resources |
| About page | ✅ Implemented | `features/about/AboutPage.tsx` | — | Bilingual (AR default / EN), 5 compact sections per file5.md |
| Contact / Connect | ✅ Implemented | `features/about/AboutPage.tsx` (`#connect`), `components/Footer.tsx`, `lib/links.ts` | — | Anchor `/about#connect`, 4 official destinations (WhatsApp, Instagram, YouTube, Spotify) |
| Annual Reports (Public Archive & Online Viewer) | ✅ Implemented | `features/reports/ReportsPage.tsx`, `features/reports/ReportViewPage.tsx` | `api/reports.py` → `GET /api/reports`, `GET /api/reports/{year}` | Public listing with fixed navbar clearance, interactive snapshot viewer, downloadable vector PDFs, and archived legacy editions |
| Annual Reports Management & Publication Gate | ✅ Implemented | `features/admin/AdminReportsPage.tsx`, `layouts/AdminLayout.tsx` | `api/reports.py`, `services/report_engine.py`, `services/pdf_generator.py` | Missing-data quality audit checklist, deterministic draft engine, SHA-256 snapshot hashing, ReportLab vector PDF generator, manual publication gate |
| Post-Session Metrics & Feedback Entry | ✅ Implemented | `features/admin/SessionMetricsPanel.tsx`, `features/admin/SessionDocumentPage.tsx` | `models/session_metrics.py`, `api/session_metrics.py`, `schemas/session_metrics.py` | Attendance visits (null vs 0), modality split, counting method, feedback tallies, reviewed quotes, optimistic locking |

## Authentication & Permissions

| Feature | Status | Backend Files |
|---|---|---|
| Admin login (JWT) | 🔲 Planned | `api/auth.py`, `core/security.py` |
| Role-based permissions | 🔲 Planned | `core/dependencies.py`, `models/user.py` |
| Member verification | 🔲 Planned | `api/users.py`, `services/publishing.py` |
| Organizer assignment | 🔲 Planned | `api/users.py` |
| Request audit logging | 🔲 Planned | `main.py` (middleware) |
