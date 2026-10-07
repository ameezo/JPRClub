import os
import uuid
from typing import Annotated, Any
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, status
from app.core.config import settings
from app.core.dependencies import get_current_admin_or_organizer
from app.models.user import User

router = APIRouter(prefix="/upload", tags=["upload"])

ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".gif"}
MAX_FILE_SIZE = 15 * 1024 * 1024  # 15 MB

def get_safe_extension(filename: str | None) -> str:
    if not filename:
        return ".jpg"
    _, ext = os.path.splitext(filename.lower())
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Unsupported file type '{ext}'. Allowed types: {', '.join(sorted(ALLOWED_EXTENSIONS))}"
        )
    return ext

@router.post("", status_code=201)
async def upload_single_file(
    file: UploadFile = File(...),
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)] = None
) -> Any:
    ext = get_safe_extension(file.filename)
    os.makedirs(settings.MEDIA_ROOT, exist_ok=True)
    
    unique_filename = f"{uuid.uuid4().hex}{ext}"
    destination_path = os.path.join(settings.MEDIA_ROOT, unique_filename)
    
    content = await file.read()
    if len(content) > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"File exceeds maximum allowed size of {MAX_FILE_SIZE // (1024 * 1024)}MB"
        )
        
    with open(destination_path, "wb") as f:
        f.write(content)
        
    return {
        "url": f"/media/{unique_filename}",
        "filename": unique_filename,
        "original_name": file.filename,
        "size": len(content)
    }

@router.post("/multiple", status_code=201)
async def upload_multiple_files(
    files: list[UploadFile] = File(...),
    current_user: Annotated[User, Depends(get_current_admin_or_organizer)] = None
) -> Any:
    if not files:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No files provided")
        
    os.makedirs(settings.MEDIA_ROOT, exist_ok=True)
    uploaded = []
    
    for file in files:
        ext = get_safe_extension(file.filename)
        unique_filename = f"{uuid.uuid4().hex}{ext}"
        destination_path = os.path.join(settings.MEDIA_ROOT, unique_filename)
        
        content = await file.read()
        if len(content) > MAX_FILE_SIZE:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"File '{file.filename}' exceeds maximum allowed size of {MAX_FILE_SIZE // (1024 * 1024)}MB"
            )
            
        with open(destination_path, "wb") as f:
            f.write(content)
            
        uploaded.append({
            "url": f"/media/{unique_filename}",
            "filename": unique_filename,
            "original_name": file.filename,
            "size": len(content)
        })
        
    return {
        "items": uploaded,
        "urls": [item["url"] for item in uploaded]
    }
