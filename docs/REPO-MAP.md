# Repository Map

> Auto-generated structural overview. Regenerate after significant changes.
> Last generated: 2026-10-07

## Current File Structure

```
jpr-club/
├── .gitignore                  # Git ignore rules
├── repomix.config.yml          # Repomix context tool configuration
├── logo.jpeg                   # Club logo (pink/pale-blue identity)
├── JPRClub_test_video.mp4      # Test video for hero background
├── 42tokyo.mov                 # Reference video (design inspiration)
├── file.md                     # Original project brief
├── file2.md                    # Phase 2 instructions (architecture planning)
├── file2.1.md                  # Phase 2 supplementary (milestones, security)
│
├── docs/
│   ├── INDEX.md                # Documentation hub
│   ├── PRODUCT.md              # Product requirements
│   ├── DESIGN.md               # Visual specification (Concept A selected)
│   ├── ARCHITECTURE.md         # Technical stack and repository plan
│   ├── IMPLEMENTATION-PLAN.md  # 7-milestone phased plan
│   ├── FEATURE-MAP.md          # Product features → implementation files
│   ├── DECISIONS.md            # Confirmed decisions and open questions
│   ├── STATUS.md               # Current project state
│   ├── REPO-MAP.md             # This file
│   └── api-contracts/
│       └── sessions.md         # Session API endpoint specification
│
├── prototypes/                 # Static HTML/CSS/JS prototypes (reference)
│   ├── index.html              # Prototype selection hub
│   ├── concept-a.html          # Concept A: Cinematic (no photos)
│   ├── concept-a-photos.html   # ✅ SELECTED — Concept A with photo gallery
│   ├── concept-b.html          # Concept B: Editorial (reference)
│   ├── concept-b-photos.html   # Concept B with photos (reference)
│   ├── concept-c.html          # Concept C: Session-first (reference)
│   ├── concept-c-photos.html   # Concept C with photos (reference)
│   ├── css/
│   │   ├── shared.css          # Design tokens, cards, footer, gallery
│   │   ├── concept-a.css       # Hero cinematic layout
│   │   ├── concept-b.css       # Editorial split layout
│   │   └── concept-c.css       # Session-first layout
│   └── js/
│       └── main.js             # Language toggle (EN/AR)
│
├── Reading club /              # Real club materials (not in git)
│   ├── صور/                    # 13 real session photos
│   ├── Annual report /         # Annual report PDF
│   └── ...                     # Presentations, monthly booklets, proposals
│
└── platfrom/                   # Large reference videos (not in git)
    ├── 42tokyo.mov
    └── JPRClub_test_video.mp4
```

## Repomix Stats
* **Total tracked files**: 23
* **Total tokens**: ~19,600
* **Security check**: No suspicious files detected.
* **Tool version**: Repomix v1.18.1

## Notes
* `frontend/` and `backend/` directories do not exist yet — they are planned.
* `Reading club /` and `platfrom/` are excluded from git via `.gitignore`.
* Git checkpoint `7af183a` marks the end of the prototype phase.
