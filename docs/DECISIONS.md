# Decisions Log

## Confirmed Decisions

### Design
| Decision | Date | Rationale |
|---|---|---|
| Selected Concept A (Cinematic Community) with photos | 2026-10-05 | User explicitly selected this direction |
| Pink/pale-blue brand identity from logo | 2026-10-05 | Per original brief: use logo colors thoughtfully |
| No splash screen or forced onboarding | 2026-10-05 | Per original brief |
| No video pause button | 2026-10-05 | User requested removal |
| Navigation: Sessions, Reading Studio, Resources, Journal | 2026-10-05 | User specified structure |
| Photo gallery included on homepage | 2026-10-05 | User chose photos variant |
| Footer: About, Annual Reports, Contact (`/about#connect`) + compact social icon row | 2026-10-10 | Per file5.md: compact, labeled row of 4 social channels |
| Fixed/absolute header spacing resolution | 2026-10-10 | Replaced uncompiled utility classes with standard public wrapper clearance (`7.5rem` desktop, `6rem` mobile) and `scroll-margin-top: 6.5rem` on `#connect` |

### Architecture
| Decision | Date | Rationale |
|---|---|---|
| Monorepo: `frontend/` + `backend/` | 2026-10-07 | Per file2.md preference; simpler deployment |
| Backend: Python + FastAPI | 2026-10-07 | User proposed; accepted — fast async, OpenAPI auto-docs |
| Database: PostgreSQL | 2026-10-07 | User proposed; accepted — relational data, ACID compliance |
| Frontend: React + TypeScript (Vite) | 2026-10-07 | Migrate from plain HTML prototype; provides component architecture needed for i18n, routing, and state management |
| Deployment: Docker Compose | 2026-10-07 | User proposed; accepted |
| Media: separate persistent volume | 2026-10-07 | User proposed; keeps uploads outside container lifecycle |
| Shared social links configuration (`frontend/src/lib/links.ts`) | 2026-10-10 | Single source of truth for WhatsApp, Instagram, YouTube, and Spotify destinations |

### Content & Publishing
| Decision | Date | Rationale |
|---|---|---|
| English default interface, Arabic alternative | 2026-10-10 | Confirmed by user: English is the default, with full Arabic alternative & RTL support |
| Automated Annual Reports | 2026-10-10 | Built inside application; deterministic calculations, no AI/LLM/n8n/Celery/Redis by default |
| Report Privacy & Storage | 2026-10-10 | Draft artifacts and private feedback scans kept outside publicly mounted media; public downloads only serve published revisions |
| Report Uniqueness & Default Lang | 2026-10-10 | Composite uniqueness on (year, language); English is default language |
| Session Eligibility & Exclusion | 2026-10-10 | Explicit exclusion flag for test/demo sessions (`exclude_from_reports`); configurable reporting timezone policy (`Asia/Amman`) |
| Partial Data Integrity | 2026-10-10 | Null/unknown preserved distinct from confirmed zero; incomplete feedback tallies allowed as drafts; reconciliation enforced when marked complete |
| Quote Permissions & Reviews | 2026-10-10 | Publication permission defaults to false; recorded review required before entering report; withdrawal supported |
| Vector PDF Generator via ReportLab | 2026-10-10 | Pure Python vector A4 generation via ReportLab with NumberedCanvas page numbering, running deterministically inside backend without heavy browser headless dependencies |
| Strict Manual Publication Gate | 2026-10-10 | Reports are never published automatically; explicit administrator review and confirmation required; draft downloads strictly isolated |
| Preservation of Historical Legacy PDFs | 2026-10-10 | 2024 and 2025 archived reports preserved as downloadable PDF editions alongside dynamic interactive web reports |
| No automatic translation | 2026-10-05 | Per original brief |
| User articles stay in original language | 2026-10-05 | Per original brief |
| Publishing requires admin/organizer approval | 2026-10-05 | Per publishing rules |
| No organizers initially | 2026-10-05 | Per original brief |
| Unified About & Contact page (`/about` & `/about#connect`) | 2026-10-10 | Compact 5-section layout: Intro, What happens here, What guides us, Explore the club, Connect with us |
| Official social destinations | 2026-10-10 | WhatsApp group, Instagram, YouTube, Spotify verified per owner brief |

## Open Questions

| Question | Context | Proposed Default |
|---|---|---|
| Session recordings hosting | Where/whether to host full recordings | Defer; document as unresolved |
| Visitor registration | No mandatory registration invented | Keep optional; configurable |
| Arabic font loading | Currently system fallback only | Load Noto Naskh Arabic from Google Fonts |
| Mobile navigation | Collapsible hamburger menu implemented | Verified in React app |

## Explicitly Rejected
| Item | Reason |
|---|---|
| Concept B (Editorial Reading) | Not selected by user |
| Concept C (Session-First) | Not selected by user |
| Automatic content translation | Explicitly prohibited in brief |
| Placement tests, payments, sentence analyzer | Out of scope per brief |
| Mandatory visitor registration | Prohibited per file2.md |
| Psychiatric / Jeddah identity & invented contact info | Incorrect draft content completely purged; club is Japanese Reading Club founded in Jordan |
| Standalone contact page / invented email inbox | Prohibited per file5.md; use `/about#connect` with WhatsApp group |
