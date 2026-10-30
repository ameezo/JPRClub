import time
import uuid
import logging
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from app.db.database import AsyncSessionLocal
from app.models.audit import AuditLog
import jwt
from app.core.config import settings

logger = logging.getLogger("audit_middleware")

class AuditLogMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        start_time = time.time()
        
        # Process the request first
        response = await call_next(request)
        
        process_time = time.time() - start_time
        
        # Do not log CORS preflight options or non-API paths
        if request.url.path.startswith("/api") and request.method != "OPTIONS":
            try:
                # Safely extract IP
                ip_address = (
                    request.headers.get("CF-Connecting-IP")
                    or request.headers.get("X-Forwarded-For", "").split(",")[0].strip()
                    or (request.client.host if request.client else "unknown")
                )
                
                user_agent = request.headers.get("user-agent", "")[:500]

                # Try to get user_id from token if present
                user_id = None
                auth_header = request.headers.get("Authorization")
                if auth_header and auth_header.startswith("Bearer "):
                    token = auth_header.split(" ")[1]
                    try:
                        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
                        sub = payload.get("sub")
                        if sub:
                            user_id = uuid.UUID(str(sub))
                    except Exception:
                        user_id = None

                # Save log entry safely without letting DB errors fail the response
                async with AsyncSessionLocal() as session:
                    log_entry = AuditLog(
                        method=request.method,
                        path=request.url.path[:250],
                        ip_address=(ip_address or "unknown")[:50],
                        user_agent=user_agent,
                        status_code=response.status_code,
                        process_time=process_time,
                        user_id=user_id
                    )
                    session.add(log_entry)
                    await session.commit()
            except Exception as e:
                logger.debug(f"Audit log write failed: {e}")
            
        return response
