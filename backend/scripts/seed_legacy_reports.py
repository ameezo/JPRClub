import asyncio
from app.db.database import AsyncSessionLocal
from app.models.report import AnnualReport
from sqlalchemy import select

async def seed_legacy_reports():
    async with AsyncSessionLocal() as db:
        # 2024 Legacy Report
        stmt_2024 = select(AnnualReport).where(AnnualReport.year == 2024, AnnualReport.language == "en")
        existing_2024 = (await db.execute(stmt_2024)).scalars().first()
        if not existing_2024:
            report_2024 = AnnualReport(
                year=2024,
                language="en",
                status="archived",
                is_legacy=True,
                legacy_pdf_url="/media/reports/legacy/annual_report_2024.pdf"
            )
            db.add(report_2024)
            print("Added 2024 legacy report.")
        else:
            print("2024 legacy report already exists.")

        # 2025 Legacy Report
        stmt_2025 = select(AnnualReport).where(AnnualReport.year == 2025, AnnualReport.language == "en")
        existing_2025 = (await db.execute(stmt_2025)).scalars().first()
        if not existing_2025:
            report_2025 = AnnualReport(
                year=2025,
                language="en",
                status="archived",
                is_legacy=True,
                legacy_pdf_url="/media/reports/legacy/annual_report_2025.pdf"
            )
            db.add(report_2025)
            print("Added 2025 legacy report.")
        else:
            print("2025 legacy report already exists.")

        await db.commit()
        print("Legacy reports seeded successfully.")

if __name__ == "__main__":
    asyncio.run(seed_legacy_reports())
