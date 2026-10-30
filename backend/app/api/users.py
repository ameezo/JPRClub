from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import Annotated
from uuid import UUID

from app.db.database import get_db
from app.models.user import User
from app.schemas.user import UserResponse
from app.core.dependencies import get_current_admin_or_organizer

router = APIRouter(prefix="/users", tags=["users"])

@router.get("", response_model=list[UserResponse])
async def list_users(
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000)
):
    result = await db.execute(select(User).offset(skip).limit(limit))
    return result.scalars().all()

@router.post("/{user_id}/verify", response_model=UserResponse)
async def verify_user(
    user_id: UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)]
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    if user.role == "member":
        user.role = "verified"
        await db.commit()
        await db.refresh(user)
    return user
