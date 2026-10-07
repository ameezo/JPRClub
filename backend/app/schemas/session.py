from pydantic import BaseModel, Field
from uuid import UUID
from datetime import datetime
from typing import Optional
from app.models.session import SessionStatus

class SessionBase(BaseModel):
    title: str
    title_ar: Optional[str] = None
    description: str
    description_ar: Optional[str] = None
    material_type: str
    chapters: Optional[str] = None
    level: Optional[str] = None
    scheduled_at: datetime
    duration_minutes: Optional[int] = None
    cover_image_url: Optional[str] = None
    studio_content: Optional[str] = None
    gallery_images: Optional[list[str]] = None

class SessionCreate(SessionBase):
    idempotency_key: Optional[str] = None

class SessionUpdate(BaseModel):
    title: Optional[str] = None
    title_ar: Optional[str] = None
    description: Optional[str] = None
    description_ar: Optional[str] = None
    material_type: Optional[str] = None
    chapters: Optional[str] = None
    level: Optional[str] = None
    scheduled_at: Optional[datetime] = None
    duration_minutes: Optional[int] = None
    cover_image_url: Optional[str] = None
    studio_content: Optional[str] = None
    gallery_images: Optional[list[str]] = None
    version: int  # Required for optimistic locking

class SessionResponse(SessionBase):
    id: UUID
    status: SessionStatus
    created_by: UUID
    created_at: datetime
    updated_at: datetime
    published_at: Optional[datetime] = None
    version: int

    class Config:
        from_attributes = True

class SessionList(BaseModel):
    items: list[SessionResponse]
    total: int
    limit: int
    offset: int

class NextSessionResponse(BaseModel):
    session: Optional[SessionResponse] = None

