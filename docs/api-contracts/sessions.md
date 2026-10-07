# Sessions API Contract

## Data Model

### Session

```json
{
  "id": "uuid",
  "title": "string",
  "title_ar": "string | null",
  "description": "string",
  "description_ar": "string | null",
  "material_type": "manga | novel | short_story | news | graded_reader | other",
  "chapters": "string | null",
  "level": "string | null",
  "scheduled_at": "ISO 8601 datetime (UTC)",
  "duration_minutes": "integer | null",
  "status": "draft | published | cancelled | completed",
  "cover_image_url": "string | null",
  "created_by": "uuid",
  "created_at": "ISO 8601 datetime (UTC)",
  "updated_at": "ISO 8601 datetime (UTC)",
  "published_at": "ISO 8601 datetime (UTC) | null",
  "version": "integer"
}
```

### Session Status Flow

```
draft → published → completed
  │         │
  │         └→ cancelled
  └→ (deleted, admin only)
```

Only `published` sessions with `scheduled_at` in the future are candidates for the homepage "next session."

---

## Public Endpoints (No Authentication Required)

### GET /api/sessions

List published sessions, ordered by `scheduled_at` descending.

**Query Parameters:**
| Param | Type | Default | Description |
|---|---|---|---|
| `status` | string | `published` | Filter by status |
| `limit` | integer | 20 | Max results |
| `offset` | integer | 0 | Pagination offset |
| `upcoming` | boolean | false | If true, only future sessions |

**Response:** `200 OK`
```json
{
  "items": [Session],
  "total": 42,
  "limit": 20,
  "offset": 0
}
```

### GET /api/sessions/next

Return the single next upcoming published session (earliest `scheduled_at` in the future).

**Response:** `200 OK`
```json
{
  "session": Session | null
}
```

Returns `null` when no upcoming session exists. The frontend must handle this gracefully.

### GET /api/sessions/{id}

Return a single session by ID. Only published, completed, or cancelled sessions are visible publicly.

**Response:** `200 OK`
```json
Session
```

**Response:** `404 Not Found` — if session doesn't exist or is in draft status.

---

## Admin Endpoints (JWT Required, Admin or Organizer Role)

### POST /api/sessions

Create a new session draft.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "title": "Yotsuba&! Vol. 1",
  "title_ar": "يوتسوبا! المجلد 1",
  "description": "Chapters 1-3. Everyday Japanese life and lighthearted comedy.",
  "description_ar": "الفصول 1-3. الحياة اليومية اليابانية.",
  "material_type": "manga",
  "chapters": "Ch 1-3",
  "level": "Beginner / N5-N4",
  "scheduled_at": "2026-10-15T15:00:00Z",
  "duration_minutes": 90,
  "idempotency_key": "uuid"
}
```

**Duplicate protection:** If `idempotency_key` matches an existing session, return the existing session instead of creating a duplicate.

**Response:** `201 Created`
```json
Session
```

**Response:** `403 Forbidden` — if user is not admin/organizer.

### PATCH /api/sessions/{id}

Update a session (draft or published).

**Headers:** `Authorization: Bearer <token>`

**Request Body:** Partial session fields.

**Concurrent edit protection:** Include `version` in the request. If the version doesn't match the current database version, return `409 Conflict`.

```json
{
  "title": "Updated title",
  "version": 3
}
```

**Response:** `200 OK` — Updated Session (version incremented).

**Response:** `409 Conflict`
```json
{
  "detail": "Session has been modified by another user. Please reload and try again.",
  "current_version": 4
}
```

### POST /api/sessions/{id}/publish

Publish a draft session. Only drafts can be published.

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK` — Updated Session with `status: "published"`.

**Response:** `400 Bad Request` — if session is not in draft status.

### POST /api/sessions/{id}/cancel

Cancel a published session.

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK` — Updated Session with `status: "cancelled"`.

### POST /api/sessions/{id}/complete

Mark a published session as completed (after it has occurred).

**Headers:** `Authorization: Bearer <token>`

**Response:** `200 OK` — Updated Session with `status: "completed"`.

### DELETE /api/sessions/{id}

Permanently delete a draft session. Only drafts can be deleted.

**Headers:** `Authorization: Bearer <token>`

**Response:** `204 No Content`.

**Response:** `400 Bad Request` — if session is not in draft status.

---

## Authentication Endpoints

### POST /api/auth/login

**Request Body:**
```json
{
  "email": "admin@jprclub.org",
  "password": "string"
}
```

**Response:** `200 OK`
```json
{
  "access_token": "jwt-string",
  "token_type": "bearer",
  "user": {
    "id": "uuid",
    "email": "string",
    "name": "string",
    "role": "admin | organizer | verified | member"
  }
}
```

**Response:** `401 Unauthorized` — invalid credentials.

---

## Date/Timezone Handling

* All dates stored and transmitted in **UTC** (ISO 8601 format).
* Frontend converts to user's local timezone for display.
* `scheduled_at` determines whether a session is "upcoming" (compare against current UTC time).
