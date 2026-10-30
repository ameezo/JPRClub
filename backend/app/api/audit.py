from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import Optional

from app.db.database import get_db
from app.core.dependencies import get_current_admin
from app.models.audit import AuditLog
from app.schemas.audit import AuditLogResponse

router = APIRouter(prefix="/audit", tags=["Audit"])

@router.get("", response_model=list[AuditLogResponse])
@router.get("/", response_model=list[AuditLogResponse], include_in_schema=False)
async def get_audit_logs(
    db: AsyncSession = Depends(get_db),
    admin = Depends(get_current_admin),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, le=500),
    method: Optional[str] = None,
    path_like: Optional[str] = None
):
    query = select(AuditLog).order_by(AuditLog.timestamp.desc())
    
    if method:
        query = query.where(AuditLog.method == method)
    if path_like:
        query = query.where(AuditLog.path.ilike(f"%{path_like}%"))
        
    query = query.offset(skip).limit(limit)
    
    result = await db.execute(query)
    logs = result.scalars().all()
    
    return logs
