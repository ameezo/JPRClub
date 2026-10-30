import os
import uuid
from typing import Annotated, Any
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, status
from app.core.config import settings
from app.core.dependencies import get_current_verified_user
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

def validate_image_bytes(content: bytes) -> bool:
    if len(content) < 8:
        return False
    # PNG: \x89PNG\r\n\x1a\n
    if content.startswith(b"\x89PNG\r\n\x1a\n"):
        return True
    # JPEG: \xff\xd8\xff
    if content.startswith(b"\xff\xd8\xff"):
        return True
    # GIF: GIF87a or GIF89a
    if content.startswith(b"GIF87a") or content.startswith(b"GIF89a"):
        return True
    # WebP: RIFF....WEBP
    if content.startswith(b"RIFF") and b"WEBP" in content[:16]:
        return True
    return False

@router.post("", status_code=201)
async def upload_single_file(
    file: UploadFile = File(...),
    current_user: Annotated[User, Depends(get_current_verified_user)] = None
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

    if not validate_image_bytes(content):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid image file format or corrupted image header."
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
    current_user: Annotated[User, Depends(get_current_verified_user)] = None
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

        if not validate_image_bytes(content):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"File '{file.filename}' is not a valid image file."
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
