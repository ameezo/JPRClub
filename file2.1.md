steps

1. preserve the selected design

Before adding features, ask the agent to:

- Identify the selected prototype and its actual files.
- Save desktop and mobile screenshots of its current appearance.
- Record its typography, colors, spacing, navigation, hero composition, and session-card design in `docs/DESIGN.md`.
- Identify anything still using fictional content or nonfunctional buttons.
- Preserve the other prototypes as references without mixing them into the selected design.
- Create a local Git checkpoint if the project already uses Git, or propose initializing it first.
1. structure

| Part | Proposed choice | Responsibility |
| --- | --- | --- |
| Frontend | React + TypeScript; retain the existing build setup | Homepage, public pages, management interface, Arabic/English layouts |
| Backend | Python + FastAPI | Sessions, permissions, publishing approval, media metadata, API |
| Database | PostgreSQL | Persistent club content, users, permissions, and session records |
| Deployment | Docker Compose | Run the application and database on your server |
| Media storage | Separate persistent storage | Uploaded photos, videos, and report PDFs |

```bash
jpr-club/
├── frontend/
│   ├── src/
│   │   ├── components/       # Shared visual components
│   │   ├── features/         # Sessions, Studio, journal, management
│   │   ├── layouts/          # Public and management layouts
│   │   ├── api/              # Backend requests
│   │   ├── i18n/             # Arabic/English interface text
│   │   └── styles/           # Design tokens and shared styles
│   ├── public/               # Public brand assets
│   └── package.json
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── api/              # API endpoints
│   │   ├── core/             # Configuration and security
│   │   ├── models/           # Database models
│   │   ├── schemas/          # Request/response definitions
│   │   ├── services/         # Publishing and session logic
│   │   └── db/               # Database setup
│   ├── migrations/
│   ├── tests/
│   └── pyproject.toml
│
├── docs/
│   ├── INDEX.md
│   ├── PRODUCT.md
│   ├── DESIGN.md
│   ├── ARCHITECTURE.md
│   ├── FEATURE-MAP.md
│   ├── DECISIONS.md
│   ├── STATUS.md
│   ├── IMPLEMENTATION-PLAN.md
│   └── api-contracts/
│
├── references/               # Logo, screenshots, design references
├── docker/                   # Container/proxy configuration
├── compose.yml
├── .env.example              # Placeholder values, never real secrets
└── .gitignore
```

```bash
Admin creates a session in the management interface
                         ↓
Backend checks permission and saves it to PostgreSQL
                         ↓
Public frontend requests published sessions
                         ↓
Homepage displays the next session automatically
```

1. build complete features

| Milestone | What should work when finished |
| --- | --- |
| 1. Design foundation | Selected homepage preserved, reusable components, Arabic/English layout, mobile behavior |
| 2. First session flow | Admin sign-in → create draft → publish → public session details → automatic next-session display |
| 3. Session management | Monthly scheduling, cancellation, editing-conflict handling, duplicate protection |
| 4. Reading Studio | Document an existing session with summaries/photos; display it in the Studio and recent-session cards |
| 5. Journal workflow | Member verification → draft submission → approval → public article |
| 6. Remaining content | Resources, About, annual web reports, downloadable PDFs |
| 7. Deployment | Server setup, persistent data/media, backups, and deployment instructions |
- An implementation plan limited to that milestone.
- Working frontend and backend integration where applicable.
- Relevant tests and browser verification.
- Updated documentation.
- A clear statement of what works, what remains mocked, and what was not tested.

1. security

for later step , no user can :

- inject sql commands
- only admins can approve to publish blogs
- use time to make a log of the requested pages
- no user can access another users data