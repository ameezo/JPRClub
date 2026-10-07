I have selected concept A with photos as the approved visual direction for JPR Club.

The next task is to prepare this prototype for real implementation.
Do not build all features yet.

1. INSPECT AND PRESERVE
Inspect the existing workspace and identify:
- The selected prototype's files and technology.
- Existing documentation.
- Mock data, placeholder media, and nonfunctional interactions.
- Reusable components and any current implementation problems.

Capture desktop/mobile screenshots of the selected prototype.
Preserve its approved visual identity.
Do not redesign it or combine it with rejected prototypes.

Propose a local Git checkpoint before substantial refactoring.
Do not delete alternative prototypes without asking.

2. DOCUMENT THE BASELINE
Update:
docs/INDEX.md
docs/PRODUCT.md
docs/DESIGN.md
docs/DECISIONS.md
docs/STATUS.md

Record confirmed requirements separately from proposals.
Document the selected typography, colors, spacing, hero, session cards, Arabic RTL layout, and English LTR layout.

3. PROPOSE THE ARCHITECTURE
Prefer one repository with frontend/ and backend/.
Retain the prototype's existing frontend framework unless there is a specific reason to change it.

My proposed backend is FastAPI with PostgreSQL.
Explain any proposed alternative before adopting it.

Create:
docs/ARCHITECTURE.md
docs/IMPLEMENTATION-PLAN.md
docs/FEATURE-MAP.md
docs/api-contracts/sessions.md

Clearly distinguish planned files/features from existing implementation.
Do not claim nonexistent features are complete.

4. PLAN THE FIRST WORKING FLOW
Administrator signs in.
Administrator creates a session draft and publishes it.
The session appears on its public detail page and sessions list.
The homepage automatically shows the next eligible published session.
Draft and cancelled sessions are not promoted.
Handle the case where no upcoming session exists.

Preserve the approved homepage design while replacing mock data.

Plan permission checks, persistent storage, date/timezone handling, concurrent-edit protection, and duplicate-request protection.

5. RESPECT THE PUBLISHING RULES
Normal members request verification.
Verified members may create drafts and submit them.
Neither normal nor verified members can publish directly.
An administrator or authorized organizer approves publication.
No organizers are appointed initially.
Administrators can verify members and assign/remove organizer permissions.

The joining mechanism remains unresolved.
Do not invent mandatory visitor registration or an email delivery system.
Keep participation configurable and record this open decision.

6. OPTIONAL CONTEXT TOOL
Inspect whether Repomix is already available.
Propose a project-local installation and configuration.
Show the package, version, and command before installing it.

Exclude secrets, private data, uploads, backups, large media, dependencies,
build output, and previous generated snapshots.
Keep security scanning enabled.
Do not upload repository content to another service.

7. STOP POINT
Present the inspection findings, proposed architecture, and first
milestone plan.
Do not implement production backend features until I approve the plan.



Read the main project brief and docs/INDEX.md before planning.
Resolve contradictions explicitly; do not silently choose between them.

Use:
- Repomix snapshots when broader repository context is needed.

Inspect the environment and propose installing/configuring Repomix
and Aider. Show installation commands before executing them.

Use Aider only to export the repository map for this workflow.
Do not launch a separate Aider coding session.

Keep generated REPO-MAP.md separate from the maintained FEATURE-MAP.md:
- REPO-MAP.md describes code structure.
- FEATURE-MAP.md connects product features to implementation files.

Regenerate structural context after significant implementation changes.
Verify relevant source files before editing; maps may be outdated.

Read and create the implementation plan first.
Wait for my approval before implementing features.