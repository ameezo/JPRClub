from pydantic import BaseModel
from datetime import datetime
from uuid import UUID
from typing import Optional

class AuditLogResponse(BaseModel):
    id: int
    timestamp: datetime
    method: str
    path: str
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    status_code: int
    process_time: Optional[float] = None
    user_id: Optional[UUID] = None

    class Config:
        from_attributes = True
