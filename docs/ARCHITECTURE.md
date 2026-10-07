# Technical Architecture

## Stack

| Layer | Technology | Version | Rationale |
|---|---|---|---|
| Frontend | React + TypeScript | React 19, TS 5.x | Component architecture for reusable UI, i18n, routing |
| Build tool | Vite | Latest | Fast dev server, HMR, modern bundling |
| Styling | Vanilla CSS (design tokens) | — | Preserves existing prototype styles; maximum control |
| i18n | react-i18next | Latest | Established React i18n library with RTL support |
| Routing | React Router | v7 | Client-side routing for SPA |
| Backend | Python + FastAPI | Python 3.12+, FastAPI 0.115+ | Async, auto-generated OpenAPI docs, type safety with Pydantic |
| Database | PostgreSQL | 16+ | ACID compliance, JSONB for flexible metadata, full-text search |
| ORM | SQLAlchemy 2.0 + Alembic | Latest | Async support, migration management |
| Auth | fastapi-users or custom JWT | — | Session/token-based admin authentication |
| Deployment | Docker Compose | — | Reproducible multi-container setup |
| Reverse proxy | Caddy or Nginx | — | TLS termination, static file serving |
| Media storage | Docker volume / host bind mount | — | Persistent storage for uploaded files |

## Repository Structure

```
jpr-club/
├── frontend/
│   ├── src/
│   │   ├── components/          # Shared visual components
│   │   │   ├── Navbar.tsx
│   │   │   ├── Footer.tsx
│   │   │   ├── SessionCard.tsx
│   │   │   ├── PhotoGallery.tsx
│   │   │   └── LanguageToggle.tsx
│   │   ├── features/
│   │   │   ├── home/            # Homepage (hero, recent sessions, gallery)
│   │   │   ├── sessions/        # Session list, detail, management
│   │   │   ├── studio/          # Reading Studio pages
│   │   │   ├── journal/         # Journal listing, article view
│   │   │   ├── resources/       # Resources page
│   │   │   └── management/      # Admin/organizer dashboard
│   │   ├── layouts/
│   │   │   ├── PublicLayout.tsx  # Public-facing layout (nav + footer)
│   │   │   └── ManagementLayout.tsx
│   │   ├── api/                 # API client functions
│   │   ├── i18n/
│   │   │   ├── en.json          # English translations
│   │   │   └── ar.json          # Arabic translations
│   │   ├── styles/
│   │   │   ├── tokens.css       # Design tokens from prototype
│   │   │   ├── shared.css       # Shared component styles
│   │   │   └── concept-a.css    # Hero-specific styles
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── public/
│   │   └── logo.jpeg
│   ├── index.html
│   ├── package.json
│   ├── tsconfig.json
│   └── vite.config.ts
│
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py              # FastAPI app, CORS, middleware
│   │   ├── api/
│   │   │   ├── __init__.py
│   │   │   ├── sessions.py      # Session CRUD endpoints
│   │   │   ├── auth.py          # Login, token management
│   │   │   ├── users.py         # User management, verification
│   │   │   └── journal.py       # Journal article endpoints
│   │   ├── core/
│   │   │   ├── config.py        # Settings from environment
│   │   │   ├── security.py      # JWT, password hashing
│   │   │   └── dependencies.py  # Common FastAPI dependencies
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   ├── user.py          # User, roles, permissions
│   │   │   ├── session.py       # Reading session model
│   │   │   └── journal.py       # Journal article model
│   │   ├── schemas/
│   │   │   ├── session.py       # Pydantic request/response models
│   │   │   ├── user.py
│   │   │   └── journal.py
│   │   ├── services/
│   │   │   ├── session_service.py
│   │   │   ├── publishing.py    # Approval workflow logic
│   │   │   └── media.py         # File upload handling
│   │   └── db/
│   │       ├── database.py      # Engine, session factory
│   │       └── init_db.py       # Initial data seeding
│   ├── migrations/              # Alembic migration files
│   │   ├── env.py
│   │   └── versions/
│   ├── tests/
│   │   ├── test_sessions.py
│   │   └── test_auth.py
│   ├── pyproject.toml
│   └── alembic.ini
│
├── docs/                        # Project documentation
├── prototypes/                  # Preserved static prototypes (reference)
├── references/                  # Logo, screenshots, design references
│
├── docker/
│   ├── frontend.Dockerfile
│   ├── backend.Dockerfile
│   └── caddy/
│       └── Caddyfile
├── compose.yml
├── .env.example
├── .gitignore
└── repomix.config.yml
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        Browser                              │
│  React SPA (Vite) — renders pages, calls API                │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP (JSON)
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  Caddy / Nginx (reverse proxy)                               │
│  - Serves frontend static build                              │
│  - Proxies /api/* → FastAPI backend                          │
│  - TLS termination                                           │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  FastAPI Backend                                             │
│  - REST API endpoints                                        │
│  - JWT authentication                                        │
│  - Permission checks (admin, organizer, verified, normal)    │
│  - Pydantic validation (prevents injection)                  │
│  - Request logging with timestamps                           │
└──────────────────────────┬───────────────────────────────────┘
                           │ SQLAlchemy (async)
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  PostgreSQL                                                  │
│  - Users, roles, permissions                                 │
│  - Sessions (with status: draft/published/cancelled)         │
│  - Journal articles (with approval workflow)                 │
│  - Studio content, resources metadata                        │
│  - Audit log (request timestamps)                            │
└──────────────────────────────────────────────────────────────┘

         ┌─────────────────┐
         │  Media Volume    │
         │  (persistent)    │
         │  Photos, videos, │
         │  report PDFs     │
         └─────────────────┘
```

## Security Plan (Later Milestones)

| Threat | Mitigation |
|---|---|
| SQL injection | SQLAlchemy ORM with parameterized queries; Pydantic input validation |
| Unauthorized publishing | Role-based permission checks: only admin/organizer can approve |
| Cross-user data access | Row-level filtering by user ID; admin-only endpoints gated by role |
| Request logging | Middleware records timestamp, path, user ID, and IP for every request |
| XSS | React auto-escapes; Content-Security-Policy headers via Caddy |
| CSRF | SameSite cookies + CORS restriction to allowed origins |

## Why React + TypeScript Instead of Plain HTML

The prototype is plain HTML/CSS/JS with no build tooling. This works for static mockups but cannot scale to:
- Dynamic data from a backend API.
- Client-side routing between Sessions, Studio, Resources, Journal, and Management.
- Component reuse (session cards, nav, footer appear everywhere).
- Internationalization (EN/AR toggle affecting all text).
- State management for authentication and form workflows.

The migration preserves all CSS design tokens and component styles from the prototype. The visual result will be identical.
