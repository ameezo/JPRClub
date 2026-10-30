from typing import Annotated, Any, Optional
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc, func

from app.db.database import get_db
from app.models.user import User
from app.models.session import Session
from app.models.session_interest import SessionInterest
from app.schemas.session_interest import (
    SessionInterestCreate,
    SessionInterestUpdate,
    SessionInterestResponse,
    SessionInterestList,
)
from app.core.dependencies import get_current_admin_or_organizer

router = APIRouter(prefix="/session-interests", tags=["session-interests"])

@router.post("", response_model=SessionInterestResponse, status_code=status.HTTP_201_CREATED)
async def create_session_interest(
    interest_in: SessionInterestCreate,
    db: Annotated[AsyncSession, Depends(get_db)],
) -> Any:
    # If session_id is provided, verify session exists
    if interest_in.session_id:
        session_result = await db.execute(select(Session).where(Session.id == interest_in.session_id))
        session_obj = session_result.scalars().first()
        if not session_obj:
            # If session id is invalid/not found, set to None rather than hard erroring out
            interest_in.session_id = None

    data = interest_in.model_dump()
    new_interest = SessionInterest(**data)
    db.add(new_interest)
    await db.commit()
    await db.refresh(new_interest)
    return new_interest

@router.get("", response_model=SessionInterestList)
async def list_session_interests(
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    type: Optional[str] = None,
    status: Optional[str] = None,
    session_id: Optional[UUID] = None,
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
) -> Any:
    query = select(SessionInterest)
    
    if type and type != "all":
        query = query.where(SessionInterest.type == type)
    if status and status != "all":
        query = query.where(SessionInterest.status == status)
    if session_id:
        query = query.where(SessionInterest.session_id == session_id)

    total_query = select(func.count()).select_from(query.subquery())
    total = await db.scalar(total_query) or 0

    query = query.order_by(desc(SessionInterest.created_at)).offset(offset).limit(limit)
    result = await db.execute(query)
    items = result.scalars().all()

    return {
        "items": items,
        "total": total,
        "limit": limit,
        "offset": offset,
    }

@router.get("/{id}", response_model=SessionInterestResponse)
async def get_session_interest(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
) -> Any:
    result = await db.execute(select(SessionInterest).where(SessionInterest.id == id))
    interest = result.scalars().first()
    if not interest:
        raise HTTPException(status_code=404, detail="Interest submission not found")
    return interest

@router.patch("/{id}", response_model=SessionInterestResponse)
async def update_session_interest(
    id: UUID,
    interest_update: SessionInterestUpdate,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
) -> Any:
    result = await db.execute(select(SessionInterest).where(SessionInterest.id == id))
    interest = result.scalars().first()
    if not interest:
        raise HTTPException(status_code=404, detail="Interest submission not found")

    if interest_update.status is not None:
        interest.status = interest_update.status

    await db.commit()
    await db.refresh(interest)
    return interest

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_session_interest(
    id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
) -> None:
    result = await db.execute(select(SessionInterest).where(SessionInterest.id == id))
    interest = result.scalars().first()
    if not interest:
        raise HTTPException(status_code=404, detail="Interest submission not found")

    await db.delete(interest)
    await db.commit()
