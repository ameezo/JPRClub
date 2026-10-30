import axios from 'axios';

const rawBaseUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000/api';
const baseURL = rawBaseUrl.endsWith('/api') ? rawBaseUrl : `${rawBaseUrl.replace(/\/$/, '')}/api`;

export const apiClient = axios.create({
  baseURL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export interface Session {
  id: string;
  title: string;
  title_ar?: string;
  description: string;
  description_ar?: string;
  material_type: string;
  chapters?: string;
  level?: string;
  scheduled_at: string;
  duration_minutes?: number;
  cover_image_url?: string;
  studio_content?: string;
  studio_content_format?: 'markdown' | 'blocknote';
  documentation_status?: 'none' | 'draft' | 'published';
  gallery_images?: string[];
  status: 'draft' | 'published' | 'cancelled' | 'completed';
  version: number;
  exclude_from_reports?: boolean;
}

export interface SessionMetrics {
  id: string;
  session_id: string;
  actual_date?: string | null;
  actual_duration_minutes?: number | null;
  attendance_visits?: number | null;
  attendance_in_person?: number | null;
  attendance_online?: number | null;
  attendance_counting_method?: string | null;
  staff_included: boolean;
  feedback_cards_received?: number | null;
  rating_1_count: number;
  rating_2_count: number;
  rating_3_count: number;
  rating_4_count: number;
  rating_5_count: number;
  unrated_count: number;
  tally_completed: boolean;
  internal_notes?: string | null;
  version: number;
  ratings_sum: number;
  tally_reconciled: boolean;
  tally_difference: number;
  updated_by?: string | null;
  created_at: string;
  updated_at: string;
}

export interface FeedbackQuote {
  id: string;
  session_id: string;
  quote_text: string;
  source_language: string;
  source_type: string;
  permission_to_publish: boolean;
  is_reviewed: boolean;
  is_highlight: boolean;
  reviewed_by?: string | null;
  reviewed_at?: string | null;
  created_at: string;
  updated_at: string;
}

export interface ReportYearSummary {
  year: number;
  language: string;
  status: string;
  has_draft: boolean;
  has_published: boolean;
  draft_revision_number?: number | null;
  published_revision_number?: number | null;
  last_generated_at?: string | null;
  published_at?: string | null;
}

export interface MissingDataChecklist {
  year: number;
  reporting_timezone: string;
  total_completed_sessions: number;
  excluded_sessions_count: number;
  excluded_sessions: Array<{ id: string; title: string; date: string }>;
  missing_attendance_count: number;
  missing_attendance_sessions: Array<{ id: string; title: string; date: string }>;
  missing_actual_duration_count: number;
  missing_actual_duration_sessions: Array<{ id: string; title: string; date: string; planned_duration?: number }>;
  missing_studio_documentation_count: number;
  missing_studio_sessions: Array<{ id: string; title: string; date: string }>;
  incomplete_tallies_count: number;
  incomplete_tallies_sessions: Array<{ id: string; title: string; date: string; cards_received?: number }>;
  is_ready_for_generation: boolean;
}

export interface ReportRevision {
  id: string;
  report_id: string;
  year: number;
  language: string;
  revision_number: number;
  generated_at: string;
  period_start: string;
  period_end: string;
  as_of_date: string;
  is_year_to_date: boolean;
  schema_version: string;
  snapshot_data: any;
  content_hash: string;
  pdf_path?: string | null;
  pdf_file_size?: number | null;
  generation_status: string;
  error_message?: string | null;
  created_by?: string | null;
  published_at?: string | null;
  published_by?: string | null;
  created_at: string;
}

export interface PublicReportListItem {
  year: number;
  language: string;
  title: string;
  description: string;
  is_legacy: boolean;
  is_year_to_date: boolean;
  as_of_date: string;
  has_web_report: boolean;
  has_pdf_download: boolean;
  download_url: string;
  web_url?: string | null;
  published_at?: string | null;
}

export { CLUB_SOCIAL_LINKS, WHATSAPP_GROUP_URL } from './links';

export interface SessionInterest {
  id: string;
  type: 'attendance' | 'volunteer' | 'team' | 'instructor';
  full_name: string;
  email: string;
  phone: string;
  message?: string;
  session_id?: string | null;
  session_title?: string | null;
  status: string;
  created_at: string;
}

export interface Resource {
  id: string;
  title: string;
  title_ar?: string | null;
  description?: string | null;
  description_ar?: string | null;
  category: 'podcast' | 'reading' | 'youtube' | 'websites' | 'grammar' | 'hiragana_katakana' | string;
  level: 'starter' | 'jlpt' | 'all_levels' | 'arabic_learner' | string;
  jlpt_sublevel?: string | null;
  url: string;
  cover_image_url?: string | null;
  status: 'published' | 'draft' | string;
  is_recommended: boolean;
  notes?: string | null;
  order_index: number;
  created_by?: string | null;
  created_at: string;
  updated_at: string;
}

const apiOrigin = baseURL.replace(/\/api\/?$/, '');

export function getMediaUrl(url?: string | null): string {
  if (!url) return '';
  if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('blob:') || url.startsWith('data:')) {
    return url;
  }
  if (url.startsWith('/')) {
    return `${apiOrigin}${url}`;
  }
  return `${apiOrigin}/${url}`;
}

export async function uploadImage(file: File): Promise<string> {
  const formData = new FormData();
  formData.append('file', file);
  const response = await apiClient.post<{ url: string }>('/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return response.data.url;
}

export async function uploadMultipleImages(files: File[]): Promise<string[]> {
  const formData = new FormData();
  files.forEach(file => {
    formData.append('files', file);
  });
  const response = await apiClient.post<{ urls: string[] }>('/upload/multiple', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return response.data.urls;
}
