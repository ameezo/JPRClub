Refine the writing experience without redesigning the approved website.

First inspect the existing session, Studio, journal, editor, storage, and permission implementations. Report what currently exists.

GOAL
I want a clean visual writing experience, not a Markdown textarea. Use one reusable ArticleComposer for:
1. Session documentation.
2. Journal articles.

Prefer BlockNote core if no suitable editor integration already exists.
Avoid unnecessary paid/XL features.
If another editor is already substantially integrated, explain whether extending it is safer than replacing it.

SESSION WORKFLOW
Keep the existing scheduling form.
Move long-form documentation to a dedicated composer.

Separate session completion from Studio publication.
“Complete & Document” marks the session completed and opens its editor.
Saving documentation must not automatically publish it.
“Publish to Studio” explicitly publishes the documentation.
when the time ends , it should disappear from sessions page.

Keep one canonical session record.
Preserve the session title, date, reading details, cover, and existing media.
Published documentation appears in Studio and recent-session cards.
Unpublished documentation must not be returned by public APIs.
Support documenting older completed sessions.

EDITOR EXPERIENCE
Provide:
- Clean title and writing canvas.
- Cover image control.
- Headings, formatting, lists, quotes, and links.
- Inline image uploads with captions and alternative text.
- Optional gallery block.
- Code blocks.
- Approved video embeds.
- Simple block insertion controls.
- Public preview.
- Draft saving with accurate saving/saved/error indicators.

The editor and public renderer should use matching typography and spacing.
Validate Arabic RTL, mixed-language text, and LTR code blocks.

JOURNAL
Add “New journal entry” to Admin → Journal.
Use the same composer for administrators and verified members.

Administrators may save drafts and publish.
Verified members may save drafts and submit for review, never publish.
Authorized organizers may approve only when explicitly permitted.
Enforce these permissions in the backend.

Use one title and one body in the author's chosen content language.
Do not require English content for Arabic or Japanese articles.
Changing interface language must not translate or duplicate the article.

DATA AND SAFETY
Inspect current content storage before changing its format.
Preserve existing Markdown, photos, galleries, and published entries.
Provide a migration/compatibility plan before modifying existing data.
Validate uploads server-side and restrict unsafe links/embeds/content.
Do not allow arbitrary scripts or raw iframe insertion.
Ensure reloads preserve saved content and media.
Retain concurrent-edit safeguards.

IMPLEMENTATION PROCESS
Present a scoped plan first.
Implement session documentation and verify it before applying the shared
composer to journal writing.
Test save → reload → preview → publish, including Arabic and images.
Verify member publication restrictions through direct API requests.
Update the project documentation and feature map.
Do not deploy automatically.