import os
import uuid
from typing import Annotated, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, or_, delete

from app.db.database import get_db
from app.models.resource import Resource
from app.models.user import User
from app.schemas.resource import ResourceCreate, ResourceUpdate, ResourceResponse, ResourceListResponse
from app.core.dependencies import get_current_admin_or_organizer, get_current_user_optional

router = APIRouter(prefix="/resources", tags=["resources"])

@router.get("", response_model=ResourceListResponse)
async def list_resources(
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[Optional[User], Depends(get_current_user_optional)] = None,
    category: Optional[str] = Query(None, description="Filter by category"),
    level: Optional[str] = Query(None, description="Filter by level"),
    jlpt_sublevel: Optional[str] = Query(None, description="Filter by JLPT sub-level (N1..N5)"),
    search: Optional[str] = Query(None, description="Text search in title or description"),
    recommended_only: Optional[bool] = Query(None, description="Only recommended items"),
    limit: int = Query(150, ge=1, le=300),
    offset: int = Query(0, ge=0),
):
    query = select(Resource)

    # For non-admins, only show published
    is_admin = current_user and current_user.role in ["admin", "organizer"]
    if not is_admin:
        query = query.where(Resource.status == "published")

    if category and category.lower() != "all":
        query = query.where(Resource.category == category.lower())

    if level and level.lower() != "all":
        lvl_lower = level.lower()
        if lvl_lower == "jlpt":
            query = query.where(or_(Resource.level == "jlpt", Resource.jlpt_sublevel.is_not(None)))
        elif lvl_lower == "starter":
            query = query.where(or_(Resource.level == "starter", Resource.jlpt_sublevel.ilike("%N5%")))
        else:
            query = query.where(Resource.level == lvl_lower)

    if jlpt_sublevel and jlpt_sublevel.lower() != "all":
        query = query.where(Resource.jlpt_sublevel.ilike(f"%{jlpt_sublevel}%"))

    if recommended_only:
        query = query.where(Resource.is_recommended == True)

    if search and search.strip():
        term = f"%{search.strip()}%"
        query = query.where(
            or_(
                Resource.title.ilike(term),
                Resource.title_ar.ilike(term),
                Resource.description.ilike(term),
                Resource.description_ar.ilike(term),
                Resource.notes.ilike(term),
            )
        )

    # Total count
    count_query = select(func.count()).select_from(query.subquery())
    total_result = await db.execute(count_query)
    total = total_result.scalar_one()

    # Ordering: recommended first, then order_index, then created_at desc
    query = query.order_by(
        Resource.is_recommended.desc(),
        Resource.order_index.asc(),
        Resource.created_at.desc()
    ).offset(offset).limit(limit)

    result = await db.execute(query)
    items = result.scalars().all()

    return {"items": items, "total": total}

@router.get("/{resource_id}", response_model=ResourceResponse)
async def get_resource(
    resource_id: uuid.UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
):
    result = await db.execute(select(Resource).where(Resource.id == resource_id))
    resource = result.scalars().first()
    if not resource:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resource not found")
    return resource

@router.post("", response_model=ResourceResponse, status_code=status.HTTP_201_CREATED)
async def create_resource(
    resource_in: ResourceCreate,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
):
    resource = Resource(
        **resource_in.model_dump(),
        created_by=current_user.id
    )
    db.add(resource)
    await db.commit()
    await db.refresh(resource)
    return resource

@router.put("/{resource_id}", response_model=ResourceResponse)
async def update_resource(
    resource_id: uuid.UUID,
    resource_in: ResourceUpdate,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
):
    result = await db.execute(select(Resource).where(Resource.id == resource_id))
    resource = result.scalars().first()
    if not resource:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resource not found")

    update_data = resource_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(resource, field, value)

    await db.commit()
    await db.refresh(resource)
    return resource

@router.delete("/{resource_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_resource(
    resource_id: uuid.UUID,
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
):
    result = await db.execute(select(Resource).where(Resource.id == resource_id))
    resource = result.scalars().first()
    if not resource:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Resource not found")

    await db.delete(resource)
    await db.commit()
    return None

@router.post("/seed-excel", status_code=status.HTTP_200_OK)
async def seed_from_excel(
    db: Annotated[AsyncSession, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)],
):
    from app.services.resource_seeder import seed_resources_from_excel_file
    count = await seed_resources_from_excel_file(db, user_id=current_user.id)
    return {"message": f"Successfully seeded {count} resources", "count": count}
