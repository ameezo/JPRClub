import asyncio
from sqlalchemy import select
from app.db.database import AsyncSessionLocal
from app.models.user import User
from app.core.security import get_password_hash
from app.core.config import settings

from datetime import datetime, timedelta, timezone
from app.models.session import Session, SessionStatus

async def init_db() -> None:
    async with AsyncSessionLocal() as session:
        result = await session.execute(select(User).where(User.email == settings.ADMIN_EMAIL))
        user = result.scalars().first()
        
        if not user:
            print(f"Creating initial admin user: {settings.ADMIN_EMAIL}")
            admin_user = User(
                email=settings.ADMIN_EMAIL,
                name="System Admin",
                hashed_password=get_password_hash(settings.ADMIN_PASSWORD),
                role="admin"
            )
            session.add(admin_user)
            await session.commit()
            await session.refresh(admin_user)
            current_admin = admin_user
        else:
            print(f"Admin user {settings.ADMIN_EMAIL} already exists.")
            current_admin = user

        # Check if sessions exist
        sess_result = await session.execute(select(Session))
        first_sess = sess_result.scalars().first()
        if not first_sess:
            print("Seeding initial sessions...")
            now = datetime.now(timezone.utc)
            sample_sessions = [
                Session(
                    title="Yotsuba&! Vol. 1 Ch 1-3",
                    title_ar="يوتسوبا! المجلد 1 الفصول 1-3",
                    description="Join us for a friendly, guided reading of Yotsuba&! chapters 1 through 3. Ideal for learners practicing everyday conversational grammar and vocabulary.",
                    description_ar="انضم إلينا في قراءة جماعية وممتعة للفصول 1 إلى 3 من مانجا يوتسوبا! مناسب لمتعلمي اللغة لممارسة المفردات اليومية والقواعد الأساسية.",
                    material_type="Manga",
                    chapters="Chapters 1-3",
                    level="Beginner (N5-N4)",
                    scheduled_at=now + timedelta(days=5),
                    duration_minutes=90,
                    status=SessionStatus.published,
                    published_at=now,
                    created_by=current_admin.id,
                ),
                Session(
                    title="Kitchen (Banana Yoshimoto)",
                    title_ar="مطبخ (بنانا يوشيموتو)",
                    description="Exploring themes of grief, comfort, and culinary healing in modern Japanese literature.",
                    description_ar="استكشاف مواضيع الحزن والسلوان والشفاء من خلال الطهي في الأدب الياباني الحديث.",
                    material_type="Novel",
                    chapters="Chapter 1",
                    level="Intermediate (N3)",
                    scheduled_at=now - timedelta(days=7),
                    duration_minutes=90,
                    status=SessionStatus.published,
                    published_at=now - timedelta(days=10),
                    created_by=current_admin.id,
                ),
            ]
            session.add_all(sample_sessions)
            await session.commit()
            print("Initial sessions seeded successfully.")

if __name__ == "__main__":
    asyncio.run(init_db())
