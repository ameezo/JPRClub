from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional
from app.models.journal import JournalStatus

class JournalSubmissionBase(BaseModel):
    title: str
    title_ar: Optional[str] = None
    content: str
    content_ar: Optional[str] = None
    cover_image_url: Optional[str] = None
    content_format: Optional[str] = "markdown"
    content_language: Optional[str] = "en"

class JournalSubmissionCreate(JournalSubmissionBase):
    status: Optional[JournalStatus] = JournalStatus.draft

class JournalSubmissionUpdate(BaseModel):
    title: Optional[str] = None
    title_ar: Optional[str] = None
    content: Optional[str] = None
    content_ar: Optional[str] = None
    cover_image_url: Optional[str] = None
    content_format: Optional[str] = None
    content_language: Optional[str] = None
    status: Optional[JournalStatus] = None
    version: Optional[int] = None

class JournalSubmissionResponse(JournalSubmissionBase):
    id: UUID
    status: JournalStatus
    author_id: UUID
    author_name: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    published_at: Optional[datetime] = None
    version: int

    class Config:
        from_attributes = True

class JournalSubmissionList(BaseModel):
    items: list[JournalSubmissionResponse]
    total: int
    limit: int
    offset: int
