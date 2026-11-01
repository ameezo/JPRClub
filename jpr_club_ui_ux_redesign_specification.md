# JPR Club — UI/UX Redesign & Frontend Implementation Spec

## 1. Project Identity & Design Philosophy
**JPR Club (Japanese Reading Club)** is a community-driven literature, manga, and language club—**not** a corporate SaaS product or generic web dashboard. Every page should feel like walking into an independent Japanese bookshop, opening a physical study notebook, or holding a stamped library card.

### Core Aesthetic: "Washi Paper, Ink & Bookshop Tactility"
1. **Warm Paper Over Stark White:** Replace cold `#FFFFFF` / `#F9FAFB` SaaS backgrounds with warm *washi* paper tones (`#FAF6EE` and `#FFFDF9`) that feel comfortable for long reading sessions.
2. **Crisp Ink Borders & Offset Shadows:** Replace blurry, diffuse drop-shadows (`box-shadow: 0 10px 25px rgba(0,0,0,0.05)`) with crisp `1.5px` or `2px` solid dark-ink borders (`#1C1917`) paired with solid offset shadows (`3px 3px 0px #1C1917` or `4px 4px 0px #1C1917`).
3. **Tactile Micro-Interactions:** Interactive cards, buttons, and filter chips should physically "lift" on hover (`transform: translate(-2px, -2px)`) while their solid offset shadow expands (`5px 5px 0px #1C1917`), and "press down" on click (`transform: translate(1px, 1px)`).
4. **Editorial & Bookish Details:** Incorporate physical stationery metaphors—book *obi* (belly-band) strips, rubber-stamp badges, lined study notebook sections, sticky-note book quotes, and interactive vocabulary flashcards.

---

## 2. Global Design Tokens (CSS Variables / Tailwind Configuration)

Define and apply these tokens globally in your main stylesheet (`index.css` / `globals.css`) and Tailwind config:

```css
:root {
  /* Paper & Surfaces */
  --bg-paper: #FAF6EE;          /* Main page background (Warm Washi Paper) */
  --bg-paper-alt: #F3ECE0;      /* Secondary section / subtle container background */
  --bg-card: #FFFDF9;           /* Card & modal surface */
  --bg-notebook: #FEFBF3;       /* Reading Studio summary notebook background */

  /* Ink & Typography */
  --ink-primary: #1C1917;       /* Crisp charcoal ink for headings, body, and borders */
  --ink-secondary: #57534E;     /* Muted ink for metadata and descriptions */
  --ink-muted: #8C857B;         /* Subtle captions and dividers */

  /* Brand & Category Accents */
  --accent-sakura: #D9385A;     /* Primary CTA Crimson / Deep Rose */
  --accent-sakura-soft: #FCE7EB;/* Soft pink highlight / tag fill */
  --accent-yuzu: #F59E0B;       /* Warm yellow for Misa Picks & sticky notes */
  --accent-Yuzu-soft: #FEF3C7;
  --accent-matcha: #10B981;     /* Mint/Matcha accent for beginner tags & cards */
  --accent-matcha-soft: #D1FAE5;
  --accent-indigo: #3B82F6;     /* Indigo accent for Essays / Grammar */
  --accent-indigo-soft: #DBEAFE;

  /* Borders & Tactile Shadows */
  --border-ink: 1.5px solid #1C1917;
  --border-ink-thick: 2px solid #1C1917;
  --shadow-tactile-sm: 2px 2px 0px #1C1917;
  --shadow-tactile: 4px 4px 0px #1C1917;
  --shadow-tactile-lg: 6px 6px 0px #1C1917;
  --shadow-tactile-pink: 4px 4px 0px #D9385A;
}
```

### Typography Pairing
* **Headings (EN):** Use an expressive, warm editorial serif or rounded display font (e.g., `'Fraunces'`, `'Playfair Display'`, or `'Plus Jakarta Sans'` at `700`/`800` weight) with tight tracking.
* **Body (EN):** Clean, highly legible humanist sans-serif (`'Inter'` or `'DM Sans'`).
* **Japanese Text (`ja`):** `'Noto Serif JP'` for literary titles/quotes and `'Noto Sans JP'` for UI/vocabulary.
* **Arabic Text (`ar` / RTL):** `'IBM Plex Sans Arabic'` or `'Readex Pro'` so Arabic subtitles in Resources, Journal posts, and RTL mode match the editorial weight of the English and Japanese type.

### Reusable Utility Classes
Create global utility classes for cards and buttons:
* `.tactile-card`: `background: var(--bg-card); border: var(--border-ink-thick); border-radius: 16px; box-shadow: var(--shadow-tactile); transition: transform 0.15s ease, box-shadow 0.15s ease;`
* `.tactile-card:hover`: `transform: translate(-2px, -2px); box-shadow: var(--shadow-tactile-lg);`
* `.tactile-btn`: `border: var(--border-ink-thick); border-radius: 9999px; box-shadow: var(--shadow-tactile-sm); font-weight: 700; transition: all 0.15s ease;`
* `.tactile-btn:hover`: `transform: translate(-2px, -2px); box-shadow: var(--shadow-tactile);`
* `.tactile-btn:active`: `transform: translate(1px, 1px); box-shadow: 1px 1px 0px #1C1917;`

---

## 3. Reusable Component: `<BookCoverFallback />` (For Missing Cover Photos)
Many sessions, studio notes, and journal entries do not have an uploaded cover image during development or when published quickly. **Never render a plain pink gradient rectangle with a generic icon.**

Build a reusable `<BookCoverFallback category={category} title={title} />` component that renders whenever `imageUrl` is null/empty. It should look like an intentional **Japanese Book Cover / Obi Strip Design**:
1. **Category-Specific Background & Kanji Watermark:**
   * `NOVEL`: Warm Terracotta/Rose fill (`#FDE2E4`), large subtle background Kanji watermark **`小説`** (Shōsetsu), small top-right stamp `文学 • LITERATURE`.
   * `MANGA`: Warm Mint/Matcha fill (`#D8F3DC`), large background Kanji watermark **`漫画`** (Manga), small top-right stamp `漫 • MANGA`.
   * `ESSAY`: Warm Amber/Yuzu fill (`#FEF3C7`), large background Kanji watermark **`随筆`** (Zuihitsu), small top-right stamp `随筆 • ESSAY`.
   * `ARTICLE` / Default: Soft Indigo/Lavender fill (`#E0E7FF`), large background Kanji watermark **`記事`** (Kiji), small top-right stamp `読物 • READING`.
2. **Visual Structure Inside the Fallback Box:**
   * A vertical or horizontal *obi* (book belly-band) strip across the lower third with a `1.5px solid #1C1917` top/bottom border and cream background (`#FFFDF9`) displaying the truncated session/article title in serif type.
   * Large decorative Japanese typography in the corner (`opacity: 0.14`, `font-size: 4.5rem`, `font-family: 'Noto Serif JP'`).
   * A bottom border (`1.5px solid #1C1917`) separating the cover area from the card body.

---

## 4. Page-by-Page Implementation Instructions

### A. Global Header & Navigation
1. **Navbar Container:** Make the top bar sit on `--bg-paper` (`#FAF6EE`) with a crisp bottom border (`1.5px solid #1C1917`).
2. **Logo Badge:** Give the pink `JPR` square icon a `1.5px solid #1C1917` border and a `2px 2px 0px #1C1917` offset shadow so it looks like an ink stamp (*hanko*).
3. **Nav Links (`Sessions`, `Reading Studio`, `Gallery`, `Resources`, `Journal`):**
   * Active route should display a hand-drawn-style wavy underline or a pill background (`#FCE7EB`) with a `1.5px solid #1C1917` border.
4. **Action Buttons (`Register` & `عربي`):**
   * Style both with `.tactile-btn` (`1.5px solid #1C1917` border + hard offset shadow).

### B. Global Footer & Marquee Divider
1. **Scrolling Editorial Marquee:** Right above the footer on every page, add a full-width horizontal marquee strip (`background: #1C1917; color: #FAF6EE; border-top: 2px solid #1C1917; border-bottom: 2px solid #1C1917; padding: 10px 0;`) that slowly scrolls club phrases separated by `✦` stars:
   * `✦ 読書クラブ • JAPANESE READING CLUB ✦ WEEKLY READING SESSIONS ✦ NOVELS • MANGA • ESSAYS ✦ CURATED BY LEARNERS FOR LEARNERS ✦ つづく (TO BE CONTINUED)`
2. **High-Contrast Ink Footer:**
   * Change the footer background to rich charcoal ink (`#141210`) with warm cream text (`#FAF6EE`).
   * Add a bold conversational callout at the top of the footer: **"Ready to read together? Pull up a chair at our next session."** alongside the navigation links and social icons encased in bordered circular pills.

---

### C. Homepage (`/`)
1. **Hero Section & "Next Session" Event Ticket:**
   * Keep the atmospheric club video in the hero, framed nicely with a subtle warm tint overlay.
   * Transform the floating center white card (`NEXT SESSION`) into a tactile **Club Event Ticket / Bookmark Card**:
     * Apply a `2px solid #1C1917` border, warm cream background (`#FFFDF9`), and a deep offset shadow (`6px 6px 0px #1C1917`).
     * Add a top "ticket header" bar with a stamped badge (`● UPCOMING SESSION`) and a Japanese decorative stamp (`読書会`).
     * Include a dashed horizontal perforation line (`border-top: 2px dashed #1C1917`) with small semicircular ticket cutouts on the left and right edges between the session title/date and the `Join Next Session →` button.
2. **Community Stat Strip (New Section Directly Below Hero):**
   * Add a 4-column horizontal stat bar on the `--bg-paper` background with bold display numbers in `--accent-sakura` (`#D9385A`) and playful labels underneath:
     * **Sessions Held** (*e.g., `25+` — Cups of tea & chapters read*)
     * **Curated Resources** (*`102` — Handpicked tools & guides*)
     * **Reading Formats** (*`4` — Novels, Manga, Essays & Articles*)
     * **All Levels Welcome** (*`N5–N1` — From first Kana to literature*)
3. **"Past Sessions" Cards:**
   * Wrap each card in `.tactile-card`.
   * Replace the generic bottom link text `Reading Studio ->` with specific, inviting action copy: **`Read Session Notes →`** (where the arrow shifts `4px` right on hover).
4. **"Community Gallery" Strip:**
   * Frame each gallery thumbnail with a `2px solid #1C1917` border and hard shadow (`3px 3px 0px #1C1917`) so they look like physical Polaroid/print snapshots.

---

### D. Reading Studio List (`/studio`) & Session Summary Detail (`/studio/:id`)
1. **Reading Studio Grid (`/studio`):**
   * Apply `.tactile-card` to all session cards.
   * Style the top-left category pill (`NOVEL`, `MANGA`, `ESSAY`, `ARTICLE`) with `1.5px solid #1C1917` borders, distinct category background colors, and bold uppercase tracking.
   * Use `<BookCoverFallback />` whenever a session does not have a cover photo uploaded.
2. **Session Summary Detail (`/studio/:id` — e.g., *Kitchen by Banana Yoshimoto*):**
   * **Header Banner:** Replace the generic dark gray gradient banner with an editorial header card featuring a warm dark-ink background (`#1C1917`), a crisp border, a stamped date pill, and clean metadata pills (`NOVEL`, `CHAPTER 1`, `INTERMEDIATE (N3)`).
   * **Lined Study Notebook Container:** Style the main summary container like a physical study notebook (`background: var(--bg-notebook); border: 2px solid #1C1917; box-shadow: 6px 6px 0px #1C1917; border-radius: 18px;`) with a subtle left margin line or notebook ring binding accent at the top.
   * **Interactive Vocabulary Cards (`Key Vocabulary & Expressions`):**
     * Instead of plain bullet points (`• 台所 (だいどころ - daidokoro): Kitchen`), render each vocabulary item as an interactive **Tactile Vocabulary Card / Chip** in a responsive grid (or clickable flip-row):
     * Display the Kanji/Word prominently in `'Noto Serif JP'`, the reading (`だいどころ • daidokoro`) in a muted pill badge, and the English translation on the right or on card flip, with a small `Click to test / reveal` toggle option at the top of the vocabulary section so students can quiz themselves.
   * **Book Quotes as Pinned Sticky Notes:**
     * Style `<blockquote>` elements (like *"The place I like best in this world is the kitchen..."*) as a warm yellow/sakura **tactile note card** (`background: #FEF3C7; border: 1.5px solid #1C1917; box-shadow: 3px 3px 0px #1C1917;`) with a decorative quotation mark and subtle rotation (`transform: rotate(-0.5deg)`).
   * **Discussion Highlights:**
     * Style numbered list items (`1, 2, 3`) with custom circular ink badges (`24px x 24px`, `background: #D9385A`, `color: white`, `border: 1.5px solid #1C1917`) instead of default browser numbers.

---

### E. Gallery (`/gallery`) — Storybook Lightbox Modal
1. **Current Friction to Fix:** Currently, clicking a photo in the Gallery redirects the user away from the Gallery to the text summary page.
2. **New Behavior:**
   * Clicking any photo card in `/gallery` opens a **Storybook Lightbox Modal** right on the page:
     * Framed like an illustrated book page (`background: #FFFDF9; border: 2px solid #1C1917; box-shadow: 8px 8px 0px #1C1917; max-width: 900px;`).
     * Top bar shows the Session Title, Category Badge, Date, and Photo Counter (`Photo 1 of N`).
     * Bottom bar provides tactile **`← Previous`** and **`Next →`** buttons (plus full `ArrowLeft` / `ArrowRight` / `Escape` keyboard support) and a secondary **`Read Full Session Notes →`** button that navigates to `/studio/:id`.
   * Keep the `View Session →` link on the card footer for users who want to jump straight to the written summary.

---

### F. Resources & Guides (`/resources`)
1. **Filter & Search Bar:**
   * Give the search input, dropdowns (`All Categories`, `All Levels`), and category pills (`All`, `Podcast`, `Reading`, `YouTube`, `Websites`, `Grammar`, `Kana`) crisp `1.5px solid #1C1917` borders.
   * Active filter pills should have a solid offset shadow (`2px 2px 0px #1C1917`) and `--accent-sakura` or `--ink-primary` fill.
2. **View Mode Switcher (`Grid View` vs. `Compact Index Table`):**
   * Because there are `102+` resources, add a compact view toggle next to `Showing 102 of 102 resources`:
     * **Cards View (Default):** The 3-column tactile card grid.
     * **Index Table View ("The B-Sides" / Quick Directory):** A clean, numbered single-line table (`01`, `02`, `03`...) with crisp horizontal ink dividers showing **Number | Title (EN + AR) | Category Pill | Level Badge | ★ Misa Pick | `Open ↗`** so learners can scan all 102 resources in seconds.
3. **`★ Misa Pick` Stamp:**
   * Style the `★ Misa Pick` badge as a high-contrast gold stamp (`background: #FDE047; color: #1C1917; border: 1.5px solid #1C1917; box-shadow: 2px 2px 0px #1C1917; font-weight: 700;`).
4. **Bilingual EN/AR Alignment on Cards:**
   * Ensure the Arabic subtitle (`dir="rtl"`) sits cleanly in a dedicated meta row or bordered callout beneath the English title with proper line-height so Arabic characters never clip.

---

### G. Sessions (`/sessions` & `/sessions/:id`) & Journal (`/journal` & `/journal/:id`)
1. **Sessions Page (`/sessions`):**
   * Add a **" berakhir / つづく (To Be Continued)"** roadmap connector or clean status tabs (`Upcoming Sessions` vs `Past Archive`) so the page never feels empty when only 1 upcoming session is active.
   * On `/sessions/:id`, style the 3 metadata boxes (`Date`, `Time & Duration`, `Material`) with `1.5px solid #1C1917` borders, warm cream fills (`#FAF6EE`), and a small `3px 3px 0px #1C1917` offset shadow.
2. **Journal Page (`/journal` & `/journal/:id`):**
   * Apply `<BookCoverFallback />` for articles without cover images.
   * Style author badges (`System Admin`, member names) like library borrower stamps (`border: 1px solid #1C1917; background: #FCE7EB;`).
   * In the Journal Reader (`/journal/:id`), format the article body like an editorial magazine column (`max-width: 720px`, warm paper card, generous `1.8` line-height, and styled checklists/dividers).

---

## 5. Implementation Guardrails for the Coding Agent
* **Preserve All Data & Routing:** Do not alter backend API endpoints, database schemas, or existing React Router URLs (`/`, `/sessions`, `/sessions/:id`, `/studio`, `/studio/:id`, `/gallery`, `/resources`, `/journal`, `/journal/:id`).
* **Preserve Bilingual / RTL Support:** Ensure the `عربي` language switch and RTL layouts continue to work seamlessly; in RTL mode, flip offset shadows from `4px 4px 0px` to `-4px 4px 0px`.
* **Graceful Image Handling:** If an uploaded image URL exists (`Boolean(item.coverImage)`), render the `<img>` inside a crisp bottom-bordered frame (`border-bottom: 1.5px solid #1C1917`). If it is missing or fails to load (`onError`), automatically render `<BookCoverFallback />`.