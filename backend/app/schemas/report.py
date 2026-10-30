from pydantic import BaseModel, Field, ConfigDict
from uuid import UUID
from datetime import datetime, date
from typing import Optional, List, Dict, Any

class ReportYearSummary(BaseModel):
    year: int
    language: str = "en"
    status: str # "not_generated", "draft", "published", "archived"
    report_id: Optional[UUID] = None
    active_draft_revision_id: Optional[UUID] = None
    published_revision_id: Optional[UUID] = None
    is_legacy: bool = False
    legacy_pdf_url: Optional[str] = None
    is_year_to_date: bool = False
    completed_sessions_count: int = 0
    updated_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)

class MissingDataChecklist(BaseModel):
    year: int
    reporting_timezone: str
    total_completed_sessions: int
    excluded_sessions_count: int
    excluded_sessions: List[Dict[str, Any]]
    missing_attendance_count: int
    missing_attendance_sessions: List[Dict[str, Any]]
    missing_actual_duration_count: int
    missing_actual_duration_sessions: List[Dict[str, Any]]
    missing_studio_documentation_count: int
    missing_studio_sessions: List[Dict[str, Any]]
    incomplete_tallies_count: int
    incomplete_tallies_sessions: List[Dict[str, Any]]
    is_ready_for_generation: bool

class ReportDraftGenerateRequest(BaseModel):
    language: str = "en"

class ReportPublishRequest(BaseModel):
    revision_id: UUID

class ReportRevisionResponse(BaseModel):
    id: UUID
    report_id: UUID
    year: int
    language: str
    revision_number: int
    generated_at: datetime
    period_start: date
    period_end: date
    as_of_date: date
    is_year_to_date: bool
    schema_version: str
    snapshot_data: Dict[str, Any]
    content_hash: str
    pdf_path: Optional[str] = None
    pdf_file_size: Optional[int] = None
    generation_status: str
    error_message: Optional[str] = None
    created_by: UUID
    published_at: Optional[datetime] = None
    published_by: Optional[UUID] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class PublicReportListItem(BaseModel):
    year: int
    language: str
    title: str
    description: str
    is_legacy: bool
    is_year_to_date: bool
    as_of_date: date
    has_web_report: bool
    has_pdf_download: bool
    download_url: str
    web_url: Optional[str] = None
    published_at: Optional[datetime] = None
