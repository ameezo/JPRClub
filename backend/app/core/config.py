from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    PROJECT_NAME: str = "JPR Club API"
    VERSION: str = "0.1.0"
    API_V1_STR: str = "/api"

    DATABASE_URL: str = "postgresql+asyncpg://jprclub:changeme@localhost:5432/jprclub"
    SECRET_KEY: str = "devsecretkey_not_for_production_min32chars!"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    BACKEND_CORS_ORIGINS: str = "http://localhost:5173,http://127.0.0.1:5173"

    ADMIN_EMAIL: str = "admin@jprclub.org"
    ADMIN_PASSWORD: str = "admin12345"

    MEDIA_ROOT: str = "media"

    @property
    def cors_origins(self) -> List[str]:
        return [origin.strip() for origin in self.BACKEND_CORS_ORIGINS.split(",") if origin.strip()]

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
