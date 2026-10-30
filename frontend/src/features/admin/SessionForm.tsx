import React, { useState, useEffect } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import { apiClient, type Session } from '@/lib/api';
import { ArrowLeft, Save, Send, Info } from 'lucide-react';

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
  });

  const [session, setSession] = useState<Session | null>(null);

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
      const payload: any = {
        title: formData.title.trim(),
        title_ar: formData.title_ar.trim() || null,
        description: formData.description.trim(),
        description_ar: formData.description_ar.trim() || null,
        material_type: formData.material_type,
        chapters: formData.chapters.trim() || null,
        level: formData.level.trim() || null,
        scheduled_at: scheduledDate.toISOString(),
        duration_minutes: Number(formData.duration_minutes) || 90,
      };

      if (!isEditing) {
        payload.recurrence_months = Number(formData.recurrence_months) || 1;
        payload.publish_immediately = publish;
        const res = await apiClient.post('/sessions', payload);
        if (publish && res?.data?.id && res?.data?.status !== 'published') {
          await apiClient.post(`/sessions/${res.data.id}/publish`);
        }
      } else {
        if (session?.version !== undefined) {
          payload.version = session.version;
        }
        await apiClient.patch(`/sessions/${id}`, payload);
        if (publish && session?.status !== 'published') {
          await apiClient.post(`/sessions/${id}/publish`);
        }
      }

      navigate('/admin');
    } catch (err: any) {
      console.error('Save error:', err);
      const detail = err?.response?.data?.detail;
      if (Array.isArray(detail)) {
        setError(detail.map(d => d.msg).join(', '));
      } else if (typeof detail === 'string') {
        setError(detail);
      } else {
        setError('An error occurred while saving the session.');
      }
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return <div style={{ padding: '32px', color: '#6b7280' }}>Loading session data...</div>;
  }

  return (
    <div>
      <Link to="/admin" className="admin-back-link">
        <ArrowLeft style={{ width: '16px', height: '16px' }} />
        <span>Back to Dashboard</span>
      </Link>
      
      <div className="admin-form-card">
        <div className="admin-card-header">
          <div>
            <h1 className="admin-card-title">
              {isEditing ? 'Edit Session' : 'Create New Session'}
            </h1>
            <p className="admin-card-subtitle">
              {isEditing ? 'Update session details or document past session results' : 'Schedule an upcoming reading session'}
            </p>
          </div>
          {session && (
            <span className={`admin-status-badge admin-status-${session.status}`}>
              {session.status}
            </span>
          )}
        </div>
        
        {error && (
          <div style={{ padding: '12px 16px', backgroundColor: '#fef2f2', border: '1px solid #fee2e2', borderRadius: '8px', color: '#dc2626', fontSize: '14px', marginBottom: '24px', display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span>⚠️</span>
            <span>{error}</span>
          </div>
        )}

        <form onSubmit={(e) => e.preventDefault()}>
          {/* SECTION 1: MAIN SESSION DETAILS */}
          <div>
            <div className="admin-section-header">
              <span className="admin-section-badge">1</span>
              <h2 className="admin-section-title">Session Information & Schedule</h2>
            </div>

            <div>
              <div className="admin-form-grid-2">
                <div className="admin-field-group">
                  <label className="admin-label">Title (English) *</label>
                  <input 
                    name="title" 
                    value={formData.title} 
                    onChange={handleChange} 
                    required 
                    placeholder="e.g. Kitchen Chapter 1"
                    className="admin-input" 
                  />
                </div>
                <div className="admin-field-group">
                  <label className="admin-label">Title (Arabic)</label>
                  <input 
                    name="title_ar" 
                    value={formData.title_ar} 
                    onChange={handleChange} 
                    dir="rtl" 
                    placeholder="مثال: مطبخ الفصل الأول"
                    className="admin-input" 
                  />
                </div>
              </div>
              
              <div className="admin-form-grid-2">
                <div className="admin-field-group">
                  <label className="admin-label">Description (English) *</label>
                  <textarea 
                    name="description" 
                    value={formData.description} 
                    onChange={handleChange} 
                    required 
                    rows={3} 
                    placeholder="Brief description for attendees..."
                    className="admin-textarea" 
                  />
                </div>
                <div className="admin-field-group">
                  <label className="admin-label">Description (Arabic)</label>
                  <textarea 
                    name="description_ar" 
                    value={formData.description_ar} 
                    onChange={handleChange} 
                    dir="rtl" 
                    rows={3} 
                    placeholder="وصف موجز للمشاركين..."
                    className="admin-textarea" 
                  />
                </div>
              </div>

              <div className="admin-form-grid-3">
                <div className="admin-field-group">
                  <label className="admin-label">Material Type *</label>
                  <select 
                    name="material_type" 
                    value={formData.material_type} 
                    onChange={handleChange} 
                    className="admin-select"
                  >
                    <option value="Manga">Manga</option>
                    <option value="Novel">Novel</option>
                    <option value="Article">Article</option>
                    <option value="Essay">Essay</option>
                    <option value="Short Story">Short Story</option>
                    <option value="Other">Other</option>
                  </select>
                </div>
                <div className="admin-field-group">
                  <label className="admin-label">Chapters / Sections</label>
                  <input 
                    name="chapters" 
                    value={formData.chapters} 
                    onChange={handleChange} 
                    placeholder="e.g. Vol 1, Ch 1-3" 
                    className="admin-input" 
                  />
                </div>
                <div className="admin-field-group">
                  <label className="admin-label">Level</label>
                  <input 
                    name="level" 
                    value={formData.level} 
                    onChange={handleChange} 
                    placeholder="e.g. Beginner (N5)" 
                    className="admin-input" 
                  />
                </div>
              </div>

              <div className="admin-form-grid-3">
                <div className="admin-field-group">
                  <label className="admin-label">Date & Time *</label>
                  <input 
                    type="datetime-local" 
                    name="scheduled_at" 
                    value={formData.scheduled_at} 
                    onChange={handleChange} 
                    required 
                    className="admin-input" 
                  />
                </div>
                <div className="admin-field-group">
                  <label className="admin-label">Duration (minutes) *</label>
                  <input 
                    type="number" 
                    name="duration_minutes" 
                    value={formData.duration_minutes} 
                    onChange={handleChange} 
                    required 
                    min="1" 
                    className="admin-input" 
                  />
                </div>
                {!isEditing && (
                  <div className="admin-field-group">
                    <label className="admin-label">Recurrence</label>
                    <select 
                      name="recurrence_months" 
                      value={formData.recurrence_months} 
                      onChange={handleChange} 
                      className="admin-select"
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

          {/* SECTION 2: READING STUDIO DOCUMENTATION */}
          <div style={{ marginTop: '36px' }}>
            <div className="admin-section-header">
              <span className="admin-section-badge">2</span>
              <h2 className="admin-section-title">Reading Studio Documentation</h2>
            </div>

            <p style={{ fontSize: '13px', color: '#6b7280', margin: '-10px 0 16px' }}>
              Document session takeaways, vocabulary, photo galleries, and video embeds for the public Reading Studio.
            </p>

            <div className="admin-info-box">
              <div className="admin-info-header">
                <Info style={{ width: '18px', height: '18px', flexShrink: 0 }} />
                <span>Dedicated Studio Documenter</span>
              </div>
              <p className="admin-info-content" style={{ margin: '8px 0 12px' }}>
                Session documentation is written in the visual <strong>Studio Canvas Documenter</strong> once the reading session has concluded.
              </p>

              {isEditing && id ? (
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '12px', marginTop: '16px', paddingTop: '16px', borderTop: '1px solid #fed7aa' }}>
                  <div style={{ fontSize: '13px', color: '#92400e' }}>
                    Documentation Status:{' '}
                    <strong>
                      {session?.documentation_status === 'published'
                        ? 'Studio Published'
                        : session?.documentation_status === 'draft'
                        ? 'Draft in Progress'
                        : 'Not Documented Yet'}
                    </strong>
                  </div>
                  <Link
                    to={`/admin/sessions/${id}/document`}
                    className="admin-action-btn-green"
                    style={{ textDecoration: 'none', display: 'inline-flex', alignItems: 'center', gap: '8px' }}
                  >
                    <span>Open Studio Documenter</span>
                    <span>→</span>
                  </Link>
                </div>
              ) : (
                <p style={{ fontSize: '12px', color: '#92400e', margin: 0 }}>
                  Once you schedule this session, click <strong>Complete & Document</strong> on the dashboard when the meeting finishes to write and publish your studio notes!
                </p>
              )}
            </div>
          </div>

          {/* FOOTER ACTION BUTTONS */}
          <div className="admin-form-footer">
            <button 
              type="button" 
              onClick={() => navigate('/admin')}
              className="admin-btn-secondary"
            >
              Cancel
            </button>
            
            {(!session || session.status === 'draft') && (
              <button 
                type="button" 
                onClick={(e) => handleSave(e, false)} 
                disabled={saving} 
                className="admin-btn-secondary"
              >
                <Save style={{ width: '16px', height: '16px' }} />
                <span>{saving ? 'Saving...' : 'Save Draft'}</span>
              </button>
            )}
            
            {(!session || session.status === 'draft') ? (
              <button 
                type="button" 
                onClick={(e) => handleSave(e, true)} 
                disabled={saving}
                className="admin-btn-save-publish"
              >
                <Send style={{ width: '16px', height: '16px' }} />
                <span>{saving ? 'Publishing...' : 'Save & Publish'}</span>
              </button>
            ) : (
              <button 
                type="button" 
                onClick={(e) => handleSave(e, false)} 
                disabled={saving}
                className="admin-btn-save-publish"
              >
                <Save style={{ width: '16px', height: '16px' }} />
                <span>{saving ? 'Updating...' : 'Update Session'}</span>
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
}
