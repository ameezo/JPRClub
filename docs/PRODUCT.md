# Product Requirements

## Overview
An independent multilingual reading community founded by Japanese learners. Participants include local readers, Japanese-language learners, and Japanese visitors/students learning Arabic.

The club reads and discusses Arabic, English, and Japanese material: graded readers, manga, short stories, novels, and news.

## Primary Homepage Purpose
Help visitors join the next session.

## Multilingual Support
* English is the default interface.
* Arabic is the alternative interface.
* User-written articles (journal entries) stay in their original language in both interface versions.
* **No automatic content translation.**

## Approved Site Structure
| Section | Description |
|---|---|
| Sessions | Upcoming and past session listings |
| Reading Studio | Session documentation organized by session (summaries, photos, notes) |
| Resources | Preparation guides, grammar sheets, vocabulary lists |
| Journal | Member-written articles, translations, and thoughts |
| About | Club history and information |
| Annual Reports | Yearly summaries (web page + downloadable PDF) |
| Management Area | Shared private area for administrators and organizers |

## Publishing Rules (Confirmed)
1. Normal members request verification.
2. Verified members may draft and submit content, but **cannot publish directly**.
3. An administrator or authorized organizer approves publication.
4. No organizers are appointed initially.
5. Administrators can verify members and assign/remove organizer permissions.
6. Safeguards required for concurrent edits and duplicate creation.

## Security Requirements (Confirmed for Later Implementation)
* SQL injection prevention (parameterized queries only).
* Only administrators can approve publication.
* Request logging with timestamps.
* Users cannot access other users' private data.

## Unresolved Items
* **Joining mechanism**: Currently a click action redirecting to session details. Alternatives include WhatsApp, email, or another approved flow. Must remain configurable.
* **Session recordings**: Whether full recordings will be hosted in the Reading Studio.
* No mandatory visitor registration or email delivery system will be invented.

## Out of Scope
* Reading placement tests
* Payments / Paid memberships
* Sentence analyzer
* Standalone photos-only route
