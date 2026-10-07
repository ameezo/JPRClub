import axios from 'axios';

const rawBaseUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000/api';
const baseURL = rawBaseUrl.endsWith('/api') ? rawBaseUrl : `${rawBaseUrl.replace(/\/$/, '')}/api`;

export const apiClient = axios.create({
  baseURL,
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
  gallery_images?: string[];
  status: 'draft' | 'published' | 'cancelled' | 'completed';
  version: number;
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
