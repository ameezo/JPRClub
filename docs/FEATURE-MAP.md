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

## Resources / About / Annual Reports

| Feature | Status | Frontend Files | Backend Files |
|---|---|---|---|
| Resources page | 🔲 Planned | `features/resources/ResourcesPage.tsx` | TBD |
| About page | 🔲 Planned | `features/about/AboutPage.tsx` | — (static content) |
| Annual Reports | 🔲 Planned | `features/about/AnnualReports.tsx` | — (PDF download) |
| Contact | 🔲 Planned | `components/Footer.tsx` | — |

## Authentication & Permissions

| Feature | Status | Backend Files |
|---|---|---|
| Admin login (JWT) | 🔲 Planned | `api/auth.py`, `core/security.py` |
| Role-based permissions | 🔲 Planned | `core/dependencies.py`, `models/user.py` |
| Member verification | 🔲 Planned | `api/users.py`, `services/publishing.py` |
| Organizer assignment | 🔲 Planned | `api/users.py` |
| Request audit logging | 🔲 Planned | `main.py` (middleware) |
