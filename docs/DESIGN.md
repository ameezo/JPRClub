# Design Specification — Approved Direction

## Selected Concept
**Concept A: Cinematic Community (with photos)**
Selected on October 5, 2026.

Alternative prototypes (B: Editorial Reading, C: Session-First, and all non-photo variants) are preserved in `prototypes/` as references. Do not mix them into the selected design.

## Design Files (Current Prototype)
| File | Purpose |
|---|---|
| `prototypes/concept-a-photos.html` | Selected homepage HTML |
| `prototypes/css/shared.css` | Shared design tokens and components |
| `prototypes/css/concept-a.css` | Concept A–specific hero and layout |
| `prototypes/js/main.js` | Language toggle (EN/AR) |

## Color Palette
| Token | Value | Usage |
|---|---|---|
| `--brand-pink` | `#f7a8b8` | Primary accent, buttons, highlights |
| `--brand-pink-dark` | `#e88599` | Hover states, active links |
| `--brand-blue` | `#a3c1e2` | Secondary accent, session labels, badges |
| `--bg-color` | `#fdfdfd` | Page background |
| `--text-color` | `#1a1a1a` | Primary text (dark, readable) |
| `--text-muted` | `#666666` | Secondary text, excerpts |
| `--surface` | `#ffffff` | Card and footer backgrounds |
| `--surface-border` | `#eaeaea` | Card borders, section dividers |

## Typography
| Context | Font | Weight | Size |
|---|---|---|---|
| English body | Inter (system fallback: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto) | 400 | Base |
| Arabic body (RTL) | Noto Naskh Arabic (system fallback) | 400 | Base |
| Section titles | Inter | 700 | 2rem |
| Card titles | Inter | 700 | 1.25rem |
| Card labels | Inter | 700 | 0.85rem, uppercase, letter-spacing 0.05em |
| Hero title | Inter | — | 2.5rem, line-height 1.2 |
| Buttons | Inter | Bold | — |

## Layout & Spacing
| Element | Value |
|---|---|
| Page horizontal padding | 5% |
| Section vertical padding | 5rem top/bottom |
| Card padding | 2rem |
| Card border-radius | 12px |
| Button border-radius | 30px |
| Card grid gap | 2rem |
| Card grid columns | `repeat(auto-fit, minmax(300px, 1fr))` |
| Photo gallery grid | `repeat(auto-fit, minmax(200px, 1fr))`, gap 1.5rem |

## Hero Composition (Cinematic)
* Full-viewport height (`100vh`), black background.
* Background video with `opacity: 0.6`, `object-fit: cover`, centered with `translate(-50%, -50%)`.
* Gradient overlay: `linear-gradient(to bottom, rgba(0,0,0,0.4) 0%, rgba(0,0,0,0.1) 50%, rgba(0,0,0,0.8) 100%)`.
* Floating session panel: `background: rgba(255,255,255,0.95)`, `backdrop-filter: blur(10px)`, `border-radius: 16px`, `box-shadow: 0 20px 40px rgba(0,0,0,0.2)`, `max-width: 500px`, centered.
* Static fallback: `poster` attribute on the `<video>` element (logo.jpeg).

## Session Cards
* White surface, 1px border `#eaeaea`, 12px border-radius.
* Hover: `translateY(-4px)` + `box-shadow: 0 12px 24px rgba(0,0,0,0.05)`.
* Structure: date label (blue uppercase) → title → excerpt (muted) → "Reading Studio →" link (pink).

## Navigation
| Item | Link |
|---|---|
| Sessions | Planned |
| Reading Studio | Planned |
| Resources | Planned |
| Journal | Planned |

* Nav is absolute-positioned over the hero, `z-index: 100`.
* Dark variant (`.site-nav.dark`) uses white text for contrast over video.
* Language toggle button: pill-shaped, border 1px, transparent background.

## Arabic RTL Layout
* `html[dir="rtl"]` triggers `font-family: "Noto Naskh Arabic"`.
* Language visibility via `html[lang="en"] .lang-ar { display: none }` / `html[lang="ar"] .lang-en { display: none }`.
* Arrow direction in card links: `transform: scaleX(-1)` in RTL.

## Footer
* Links: About (`/about`), Annual Reports (`/reports`), Contact (`/about#connect`).
* Compact social row: WhatsApp, Instagram, YouTube, Spotify.
* Flexbox, `justify-content: space-between`, wraps cleanly on mobile.
* Top border `1px solid var(--surface-border)`.

## Page Layout & Header Clearance
* Navigation (`.site-nav`) is absolute-positioned over the top with `z-index: 100`.
* Public pages (Sessions, Studio, About, Resources, Reports) must use `.public-page-wrapper` or `.about-page-wrapper` with `padding-top: 7.5rem` (120px) on desktop and `6rem` (96px) on mobile to guarantee zero overlap between the header and page titles.
* Anchor sections (such as `#connect` on `/about`) must define `scroll-margin-top: 6.5rem` (5.5rem on mobile) so target sections clear the header when scrolled into view.

## About & Connect Page Specification
* Route: `/about` (with `/about#connect` for contact/social destinations).
* Language: Arabic default (RTL), English alternative (LTR).
* Structure:
  1. Compact hero introduction (Title, descriptor, 2 foundation paragraphs).
  2. "What happens here" (3 responsive activity cards).
  3. "What guides us" (compact principles card with 3 core beliefs).
  4. "Explore the club" (3 navigation cards pointing to `/sessions`, `/studio`, `/reports`).
  5. "Connect with us" (`#connect` anchor with 4 branded external action buttons).

## Community Gallery Section
* Photo grid with `figure` elements.
* Image height: 200px, `object-fit: cover`, 8px border-radius.
* Overlay caption at bottom: `background: rgba(0,0,0,0.6)`, `backdrop-filter: blur(2px)`.

## Known Issues in Current Prototype
| Issue | Details |
|---|---|
| All data is fictional | Session titles, dates, excerpts are hardcoded placeholder text |
| All links are `href="#"` | No pages exist for Sessions, Studio, Resources, Journal, About, Annual Reports, Contact |
| Photos use picsum.photos | External placeholder images, not real session photos |
| Video is test footage | `JPRClub_test_video.mp4` — not real session montage |
| No responsive nav | Navigation links don't collapse on mobile |
| No Google Fonts loaded | Inter and Noto Naskh Arabic rely on system fallback only |
| Resources/Journal section | Removed in photos variant (was present in non-photo Concept A) |
