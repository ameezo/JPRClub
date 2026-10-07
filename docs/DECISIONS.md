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
| Footer: About, Annual Reports, Contact | 2026-10-05 | Per original brief |

### Architecture
| Decision | Date | Rationale |
|---|---|---|
| Monorepo: `frontend/` + `backend/` | 2026-10-07 | Per file2.md preference; simpler deployment |
| Backend: Python + FastAPI | 2026-10-07 | User proposed; accepted — fast async, OpenAPI auto-docs |
| Database: PostgreSQL | 2026-10-07 | User proposed; accepted — relational data, ACID compliance |
| Frontend: React + TypeScript (Vite) | 2026-10-07 | Migrate from plain HTML prototype; provides component architecture needed for i18n, routing, and state management |
| Deployment: Docker Compose | 2026-10-07 | User proposed; accepted |
| Media: separate persistent volume | 2026-10-07 | User proposed; keeps uploads outside container lifecycle |

### Content & Publishing
| Decision | Date | Rationale |
|---|---|---|
| English default, Arabic alternative | 2026-10-05 | Per original brief |
| No automatic translation | 2026-10-05 | Per original brief |
| User articles stay in original language | 2026-10-05 | Per original brief |
| Publishing requires admin/organizer approval | 2026-10-05 | Per publishing rules |
| No organizers initially | 2026-10-05 | Per original brief |

## Open Questions

| Question | Context | Proposed Default |
|---|---|---|
| Joining mechanism | WhatsApp vs email vs other flow | Click redirects to session detail page |
| Session recordings hosting | Where/whether to host full recordings | Defer; document as unresolved |
| Visitor registration | No mandatory registration invented | Keep optional; configurable |
| Arabic font loading | Currently system fallback only | Load Noto Naskh Arabic from Google Fonts |
| Mobile navigation | No hamburger menu currently | Implement collapsible nav in React migration |

## Explicitly Rejected
| Item | Reason |
|---|---|
| Concept B (Editorial Reading) | Not selected by user |
| Concept C (Session-First) | Not selected by user |
| Automatic content translation | Explicitly prohibited in brief |
| Placement tests, payments, sentence analyzer | Out of scope per brief |
| Mandatory visitor registration | Prohibited per file2.md |
