import React, { useState, useEffect } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import { apiClient, type Session } from '@/lib/api';
import Button from '@/components/ui/Button';
import axios from 'axios';
import { ArrowLeft, Save, Send, ChevronDown, ChevronUp, Info } from 'lucide-react';
import MarkdownEditor from './MarkdownEditor';
import { CoverUploader, GalleryUploader } from './PhotoUploader';

export default function SessionForm() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isEditing = !!id;

  const getInitialDateTime = () => {
    const d = new Date();
    d.setDate(d.getDate() + 1);
    d.setHours(18, 0, 0, 0);
    return new Date(d.getTime() - d.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
  };

  const [loading, setLoading] = useState(isEditing);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  
  const [formData, setFormData] = useState({
    title: '',
    title_ar: '',
    description: '',
    description_ar: '',
    material_type: 'Manga',
    chapters: '',
    level: '',
    scheduled_at: getInitialDateTime(),
    duration_minutes: 90,
    recurrence_months: 1,
    cover_image_url: '',
    studio_content: '',
    gallery_images: [] as string[],
  });

  const [session, setSession] = useState<Session | null>(null);
  const [showStudioSection, setShowStudioSection] = useState(false);

  useEffect(() => {
    if (isEditing) {
      const fetchSession = async () => {
        try {
          const res = await apiClient.get(`/sessions/${id}`);
          setSession(res.data);
          
          // Format date for datetime-local input
          const d = new Date(res.data.scheduled_at);
          const formattedDate = !isNaN(d.getTime()) 
            ? new Date(d.getTime() - d.getTimezoneOffset() * 60000).toISOString().slice(0, 16)
            : getInitialDateTime();
          
          const hasStudioData = !!res.data.studio_content || (res.data.gallery_images && res.data.gallery_images.length > 0) || res.data.status === 'completed';
          setShowStudioSection(hasStudioData);

          setFormData({
            title: res.data.title || '',
            title_ar: res.data.title_ar || '',
            description: res.data.description || '',
            description_ar: res.data.description_ar || '',
            material_type: res.data.material_type || 'Manga',
            chapters: res.data.chapters || '',
            level: res.data.level || '',
            scheduled_at: formattedDate,
            duration_minutes: res.data.duration_minutes || 90,
            recurrence_months: 1,
            cover_image_url: res.data.cover_image_url || '',
            studio_content: res.data.studio_content || '',
            gallery_images: Array.isArray(res.data.gallery_images) ? res.data.gallery_images : [],
          });
        } catch (err) {
          setError('Failed to load session details.');
        } finally {
          setLoading(false);
        }
      };
      fetchSession();
    }
  }, [id, isEditing]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSave = async (e: React.FormEvent, publish: boolean = false) => {
    e.preventDefault();
    setError('');

    // Client-side validations
    if (!formData.title.trim()) {
      setError('Please enter a session title (English).');
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }
    if (!formData.description.trim()) {
      setError('Please enter a session description (English).');
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }
    if (!formData.scheduled_at) {
      setError('Please specify both a date and a time for the session.');
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }

    const scheduledDate = new Date(formData.scheduled_at);
    if (isNaN(scheduledDate.getTime())) {
      setError('Please provide a valid date and time.');
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }

    setSaving(true);
    
    try {
      const { recurrence_months, ...cleanFormData } = formData;
      const payload = {
        ...cleanFormData,
        duration_minutes: Number(formData.duration_minutes),
        scheduled_at: scheduledDate.toISOString(),
        gallery_images: formData.gallery_images,
      };

      if (isEditing && session) {
        // Update
        await apiClient.patch(`/sessions/${id}`, { ...payload, version: session.version });
        if (publish && session.status === 'draft') {
          await apiClient.post(`/sessions/${id}/publish`);
        }
      } else {
        // Create
        const monthsCount = Number(recurrence_months) || 1;
        
        for (let i = 0; i < monthsCount; i++) {
          const idempotency_key = `create_${Date.now()}_${i}`;
          
          // Add i months to the date
          const date = new Date(payload.scheduled_at);
          date.setMonth(date.getMonth() + i);
          
          const currentPayload = {
            ...payload,
            scheduled_at: date.toISOString()
          };
          
          const res = await apiClient.post('/sessions', { ...currentPayload, idempotency_key });
          if (publish) {
            await apiClient.post(`/sessions/${res.data.id}/publish`);
          }
        }
      }
      
      navigate('/admin');
    } catch (err: any) {
      if (axios.isAxiosError(err) && err.response) {
        const detail = err.response.data?.detail;
        if (Array.isArray(detail)) {
          const msgs = detail.map((d: any) => `${d.loc?.slice(-1)[0] || 'field'}: ${d.msg}`).join(', ');
          setError(msgs || 'Validation error');
        } else if (typeof detail === 'object' && detail?.message) {
          setError(detail.message);
        } else if (typeof detail === 'string') {
          setError(detail);
        } else if (err.response.status === 409) {
          setError('A session with this title is already scheduled for this day.');
        } else {
          setError(`Failed to save session (HTTP ${err.response.status})`);
        }
      } else if (err instanceof Error) {
        setError(err.message);
      } else {
        setError('An unexpected error occurred');
      }
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return <div className="p-8 text-gray-500">Loading session data...</div>;
  }

  return (
    <div className="p-4 sm:p-8 max-w-4xl mx-auto pb-24">
      <Link to="/admin" className="inline-flex items-center gap-2 text-primary hover:underline mb-6 font-medium">
        <ArrowLeft className="w-4 h-4" /> Back to Dashboard
      </Link>
      
      <div className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
        <div className="px-6 sm:px-8 py-5 border-b border-gray-200 bg-gray-50 flex flex-wrap justify-between items-center gap-4">
          <div>
            <h1 className="text-2xl font-bold font-display text-gray-900">
              {isEditing ? 'Edit Session' : 'Create New Session'}
            </h1>
            <p className="text-xs text-gray-500 mt-0.5">
              {isEditing ? 'Update session details or document past session results' : 'Schedule an upcoming reading session'}
            </p>
          </div>
          {session && (
            <span className={`px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider ${
              session.status === 'published' ? 'bg-green-100 text-green-700' :
              session.status === 'completed' ? 'bg-blue-100 text-blue-700' :
              'bg-gray-200 text-gray-700'
            }`}>
              {session.status}
            </span>
          )}
        </div>
        
        {error && (
          <div className="m-6 sm:m-8 mb-0 p-4 bg-red-50 text-red-700 rounded-xl text-sm font-medium border border-red-100 flex items-start gap-2">
            <span>⚠️</span>
            <div className="flex-1">{error}</div>
          </div>
        )}

        <form className="p-6 sm:p-8 space-y-8">
          {/* SECTION 1: MAIN SESSION DETAILS */}
          <div>
            <h2 className="text-lg font-bold text-gray-900 mb-4 pb-2 border-b border-gray-100 flex items-center gap-2">
              <span className="w-6 h-6 rounded-full bg-primary/10 text-primary text-xs flex items-center justify-center font-bold">1</span>
              Session Information & Schedule
            </h2>

            <div className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Title (English) *</label>
                  <input 
                    name="title" 
                    value={formData.title} 
                    onChange={handleChange} 
                    required 
                    placeholder="e.g. Kitchen Chapter 1"
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Title (Arabic)</label>
                  <input 
                    name="title_ar" 
                    value={formData.title_ar} 
                    onChange={handleChange} 
                    dir="rtl" 
                    placeholder="مثال: مطبخ الفصل الأول"
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Description (English) *</label>
                  <textarea 
                    name="description" 
                    value={formData.description} 
                    onChange={handleChange} 
                    required 
                    rows={3} 
                    placeholder="Brief description for attendees..."
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Description (Arabic)</label>
                  <textarea 
                    name="description_ar" 
                    value={formData.description_ar} 
                    onChange={handleChange} 
                    dir="rtl" 
                    rows={3} 
                    placeholder="وصف موجز للمشاركين..."
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 sm:gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Material Type *</label>
                  <select 
                    name="material_type" 
                    value={formData.material_type} 
                    onChange={handleChange} 
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all bg-white"
                  >
                    <option value="Manga">Manga</option>
                    <option value="Novel">Novel</option>
                    <option value="Article">Article</option>
                    <option value="Essay">Essay</option>
                    <option value="Short Story">Short Story</option>
                    <option value="Other">Other</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Chapters / Sections</label>
                  <input 
                    name="chapters" 
                    value={formData.chapters} 
                    onChange={handleChange} 
                    placeholder="e.g. Vol 1, Ch 1-3" 
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Level</label>
                  <input 
                    name="level" 
                    value={formData.level} 
                    onChange={handleChange} 
                    placeholder="e.g. Beginner (N5)" 
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 sm:gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Date & Time *</label>
                  <input 
                    type="datetime-local" 
                    name="scheduled_at" 
                    value={formData.scheduled_at} 
                    onChange={handleChange} 
                    required 
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Duration (minutes) *</label>
                  <input 
                    type="number" 
                    name="duration_minutes" 
                    value={formData.duration_minutes} 
                    onChange={handleChange} 
                    required 
                    min="1" 
                    className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all" 
                  />
                </div>
                {!isEditing && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">Recurrence</label>
                    <select 
                      name="recurrence_months" 
                      value={formData.recurrence_months} 
                      onChange={handleChange} 
                      className="w-full px-4 py-2.5 rounded-xl border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm transition-all bg-white"
                    >
                      <option value={1}>One-time (1 Month)</option>
                      <option value={2}>Repeat for 2 Months</option>
                      <option value={3}>Repeat for 3 Months</option>
                      <option value={6}>Repeat for 6 Months</option>
                      <option value={12}>Repeat for 12 Months</option>
                    </select>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* SECTION 2: READING STUDIO POST-SESSION DOCUMENTATION */}
          <div className="pt-6 border-t border-gray-200">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h2 className="text-lg font-bold text-gray-900 flex items-center gap-2">
                  <span className="w-6 h-6 rounded-full bg-primary/10 text-primary text-xs flex items-center justify-center font-bold">2</span>
                  Post-Session Documentation (Reading Studio)
                </h2>
                <p className="text-xs text-gray-500 mt-1">
                  Add photos, discussion highlights, vocabulary, and markdown notes for the Reading Studio page.
                </p>
              </div>

              {!isEditing && (
                <button
                  type="button"
                  onClick={() => setShowStudioSection(!showStudioSection)}
                  className="text-xs font-semibold text-primary hover:underline flex items-center gap-1 px-3 py-1.5 bg-primary/10 rounded-lg transition-colors"
                >
                  {showStudioSection ? (
                    <>Hide Details <ChevronUp className="w-3.5 h-3.5" /></>
                  ) : (
                    <>Add Studio Notes & Photos (Optional) <ChevronDown className="w-3.5 h-3.5" /></>
                  )}
                </button>
              )}
            </div>

            {/* Explanatory banner */}
            <div className="bg-amber-50/70 border border-amber-200/60 rounded-xl p-4 flex items-start gap-3 text-xs sm:text-sm text-amber-900 mb-6">
              <Info className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
              <div>
                <span className="font-semibold">When should you fill this out?</span>
                <p className="mt-0.5 text-amber-800">
                  Full session summaries and photo galleries are typically added <strong>after the session concludes</strong>. 
                  When scheduling an upcoming session, you can leave these blank and document them later from your admin dashboard!
                </p>
              </div>
            </div>

            {(showStudioSection || isEditing) && (
              <div className="space-y-6 pt-2">
                {/* Cover Image Upload */}
                <div>
                  <label className="block text-sm font-semibold text-gray-800 mb-2">
                    Studio Cover Photo
                  </label>
                  <p className="text-xs text-gray-500 mb-3">
                    Featured banner photo displayed at the top of the Studio detail page and on cards.
                  </p>
                  <CoverUploader 
                    coverUrl={formData.cover_image_url} 
                    onChange={(url) => setFormData(p => ({ ...p, cover_image_url: url }))} 
                  />
                </div>

                {/* Session Photo Gallery Upload */}
                <div className="pt-4 border-t border-gray-100">
                  <label className="block text-sm font-semibold text-gray-800 mb-2">
                    Session Photo Gallery (Multi-upload)
                  </label>
                  <p className="text-xs text-gray-500 mb-3">
                    Upload photos taken during the reading session (drag & drop from your laptop or select from your phone/tablet gallery).
                  </p>
                  <GalleryUploader 
                    images={formData.gallery_images} 
                    onChange={(imgs) => setFormData(p => ({ ...p, gallery_images: imgs }))} 
                  />
                </div>

                {/* Markdown Notes Editor */}
                <div className="pt-4 border-t border-gray-100">
                  <div className="flex items-center justify-between mb-2">
                    <label className="block text-sm font-semibold text-gray-800">
                      Studio Summary & Notes (Markdown)
                    </label>
                    <span className="text-xs text-gray-500">
                      Supports headings, quotes, bullet points, and live preview
                    </span>
                  </div>
                  <MarkdownEditor 
                    value={formData.studio_content} 
                    onChange={(content) => setFormData(p => ({ ...p, studio_content: content }))} 
                  />
                </div>
              </div>
            )}
          </div>

          {/* FORM ACTIONS */}
          <div className="pt-6 border-t border-gray-200 flex flex-wrap items-center justify-end gap-3 sm:gap-4">
            <Button type="button" variant="outline" onClick={() => navigate('/admin')}>
              Cancel
            </Button>
            
            {(!session || session.status === 'draft') && (
              <Button 
                type="button" 
                onClick={(e) => handleSave(e, false)} 
                disabled={saving} 
                className="bg-gray-800 hover:bg-gray-900 text-white border-none"
              >
                <Save className="w-4 h-4 mr-2" />
                {saving ? 'Saving...' : 'Save Draft'}
              </Button>
            )}
            
            {(!session || session.status === 'draft') ? (
               <Button type="button" onClick={(e) => handleSave(e, true)} disabled={saving}>
                 <Send className="w-4 h-4 mr-2" />
                 {saving ? 'Publishing...' : 'Save & Publish'}
               </Button>
            ) : (
               <Button type="button" onClick={(e) => handleSave(e, false)} disabled={saving}>
                 <Save className="w-4 h-4 mr-2" />
                 {saving ? 'Updating...' : 'Update Session'}
               </Button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
}
