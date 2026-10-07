import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.core.config import settings

from app.api import auth, sessions, upload

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
)

# Ensure media directory exists
os.makedirs(settings.MEDIA_ROOT, exist_ok=True)
app.mount("/media", StaticFiles(directory=settings.MEDIA_ROOT), name="media")

# CORS setup
if settings.cors_origins:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(auth.router, prefix=settings.API_V1_STR)
app.include_router(sessions.router, prefix=settings.API_V1_STR)
app.include_router(upload.router, prefix=settings.API_V1_STR)

@app.get("/healthz")
async def health_check():
    return {"status": "ok", "version": settings.VERSION}
