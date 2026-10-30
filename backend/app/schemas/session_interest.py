from pydantic import BaseModel, EmailStr
from uuid import UUID
from datetime import datetime
from typing import Optional, Literal

class SessionInterestBase(BaseModel):
    type: Literal["attendance", "volunteer", "team", "instructor"]
    full_name: str
    email: EmailStr
    phone: str
    message: Optional[str] = ""
    session_id: Optional[UUID] = None

class SessionInterestCreate(SessionInterestBase):
    pass

class SessionInterestUpdate(BaseModel):
    status: Optional[str] = None # "new", "reviewed", "contacted", "archived"

class SessionInterestResponse(SessionInterestBase):
    id: UUID
    status: str
    session_title: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

class SessionInterestList(BaseModel):
    items: list[SessionInterestResponse]
    total: int
    limit: int
    offset: int
