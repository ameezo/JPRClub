from pydantic import BaseModel, HttpUrl
from uuid import UUID
from datetime import datetime
from typing import Optional

class ResourceBase(BaseModel):
    title: str
    title_ar: Optional[str] = None
    description: Optional[str] = None
    description_ar: Optional[str] = None
    category: str # podcast, reading, youtube, websites, grammar, hiragana_katakana
    level: str # starter, jlpt, all_levels, arabic_learner
    jlpt_sublevel: Optional[str] = None # N5, N4, N3, N2, N1
    url: str
    cover_image_url: Optional[str] = None
    status: Optional[str] = "published"
    is_recommended: Optional[bool] = False
    notes: Optional[str] = None
    order_index: Optional[int] = 0

class ResourceCreate(ResourceBase):
    pass

class ResourceUpdate(BaseModel):
    title: Optional[str] = None
    title_ar: Optional[str] = None
    description: Optional[str] = None
    description_ar: Optional[str] = None
    category: Optional[str] = None
    level: Optional[str] = None
    jlpt_sublevel: Optional[str] = None
    url: Optional[str] = None
    cover_image_url: Optional[str] = None
    status: Optional[str] = None
    is_recommended: Optional[bool] = None
    notes: Optional[str] = None
    order_index: Optional[int] = None

class ResourceResponse(ResourceBase):
    id: UUID
    created_by: Optional[UUID] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class ResourceListResponse(BaseModel):
    items: list[ResourceResponse]
    total: int
