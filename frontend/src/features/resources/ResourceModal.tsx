import { useState, useEffect } from 'react';
import { type Resource, apiClient, uploadImage, getMediaUrl } from '@/lib/api';
import { X, Upload, Loader2 } from 'lucide-react';

interface ResourceModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  initialResource?: Resource | null;
}

export const ResourceModal: React.FC<ResourceModalProps> = ({
  isOpen,
  onClose,
  onSuccess,
  initialResource,
}) => {
  const [title, setTitle] = useState('');
  const [titleAr, setTitleAr] = useState('');
  const [category, setCategory] = useState('podcast');
  const [level, setLevel] = useState('starter');
  const [jlptSublevel, setJlptSublevel] = useState('');
  const [url, setUrl] = useState('');
  const [description, setDescription] = useState('');
  const [descriptionAr, setDescriptionAr] = useState('');
  const [coverImageUrl, setCoverImageUrl] = useState('');
  const [isRecommended, setIsRecommended] = useState(false);
  const [status, setStatus] = useState('published');

  const [uploading, setUploading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (initialResource) {
      setTitle(initialResource.title || '');
      setTitleAr(initialResource.title_ar || '');
      setCategory(initialResource.category || 'podcast');
      setLevel(initialResource.level || 'starter');
      setJlptSublevel(initialResource.jlpt_sublevel || '');
      setUrl(initialResource.url || '');
      setDescription(initialResource.description || '');
      setDescriptionAr(initialResource.description_ar || '');
      setCoverImageUrl(initialResource.cover_image_url || '');
      setIsRecommended(!!initialResource.is_recommended);
      setStatus(initialResource.status || 'published');
    } else {
      setTitle('');
      setTitleAr('');
      setCategory('podcast');
      setLevel('starter');
      setJlptSublevel('');
      setUrl('');
      setDescription('');
      setDescriptionAr('');
      setCoverImageUrl('');
      setIsRecommended(false);
      setStatus('published');
    }
    setError(null);
  }, [initialResource, isOpen]);

  if (!isOpen) return null;

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    try {
      setUploading(true);
      setError(null);
      const uploadedUrl = await uploadImage(file);
      setCoverImageUrl(uploadedUrl);
    } catch (err: any) {
      console.error('File upload failed:', err);
      setError(err?.response?.data?.detail || 'Failed to upload image. Please try again.');
    } finally {
      setUploading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !url.trim()) {
      setError('Title and URL are required.');
      return;
    }

    try {
      setSaving(false);
      setSaving(true);
      setError(null);

      const payload = {
        title: title.trim(),
        title_ar: titleAr.trim() || null,
        category,
        level,
        jlpt_sublevel: jlptSublevel.trim() || null,
        url: url.trim(),
        description: description.trim() || null,
        description_ar: descriptionAr.trim() || null,
        cover_image_url: coverImageUrl.trim() || null,
        is_recommended: isRecommended,
        status,
      };

      if (initialResource) {
        await apiClient.put(`/resources/${initialResource.id}`, payload);
      } else {
        await apiClient.post('/resources', payload);
      }

      onSuccess();
      onClose();
    } catch (err: any) {
      console.error('Save resource error:', err);
      setError(err?.response?.data?.detail || 'Failed to save resource.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="resource-modal-overlay" onClick={onClose}>
      <div className="resource-modal-dialog" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="resource-modal-header">
          <h2>{initialResource ? 'Edit Resource' : 'Add New Resource'}</h2>
          <button type="button" className="resource-modal-close" onClick={onClose}>
            <X style={{ width: '20px', height: '20px' }} />
          </button>
        </div>

        {/* Error Alert */}
        {error && (
          <div style={{ margin: '16px 28px 0 28px', padding: '12px 16px', background: '#fef2f2', border: '1px solid #fecaca', borderRadius: '10px', color: '#b91c1c', fontSize: '13px' }}>
            {error}
          </div>
        )}

        {/* Form Body */}
        <form onSubmit={handleSubmit}>
          <div className="resource-modal-body">
            {/* Title & Arabic Title */}
            <div className="form-group-row">
              <div>
                <label className="resource-form-label">Title / Name *</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Nihongo con Teppei"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="resource-form-input"
                />
              </div>
              <div>
                <label className="resource-form-label">Arabic Title (Optional)</label>
                <input
                  type="text"
                  dir="rtl"
                  placeholder="العنوان بالعربية"
                  value={titleAr}
                  onChange={(e) => setTitleAr(e.target.value)}
                  className="resource-form-input"
                />
              </div>
            </div>

            {/* Category & Level */}
            <div className="form-group-row">
              <div>
                <label className="resource-form-label">Category *</label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="resource-form-select"
                >
                  <option value="podcast">Podcast (بودكاست)</option>
                  <option value="reading">Reading (قراءة)</option>
                  <option value="youtube">YouTube (يوتيوب)</option>
                  <option value="websites">Websites (مواقع)</option>
                  <option value="grammar">Grammar (قواعد)</option>
                  <option value="hiragana_katakana">Hiragana & Katakana (هيراغانا وكاتاكانا)</option>
                </select>
              </div>

              <div>
                <label className="resource-form-label">Level *</label>
                <select
                  value={level}
                  onChange={(e) => setLevel(e.target.value)}
                  className="resource-form-select"
                >
                  <option value="starter">Starter (مبتدئ)</option>
                  <option value="jlpt">JLPT (اختبار الكفاءة)</option>
                  <option value="all_levels">All Levels (جميع المستويات)</option>
                  <option value="arabic_learner">Arabic Learner (للناطقين بالعربية)</option>
                </select>
              </div>
            </div>

            {/* JLPT Sub-level (if applicable) & Resource URL */}
            <div className="form-group-row">
              <div>
                <label className="resource-form-label">JLPT Sub-level / Tag (Optional)</label>
                <select
                  value={jlptSublevel}
                  onChange={(e) => setJlptSublevel(e.target.value)}
                  className="resource-form-select"
                >
                  <option value="">None / General</option>
                  <option value="N5">N5 (Beginner)</option>
                  <option value="N4">N4 (Upper Beginner)</option>
                  <option value="N3">N3 (Intermediate)</option>
                  <option value="N2">N2 (Upper Intermediate)</option>
                  <option value="N1">N1 (Advanced)</option>
                  <option value="N5–N4">N5–N4</option>
                  <option value="N3–N2">N3–N2</option>
                </select>
              </div>

              <div>
                <label className="resource-form-label">Resource URL / Link *</label>
                <input
                  type="url"
                  required
                  placeholder="https://..."
                  value={url}
                  onChange={(e) => setUrl(e.target.value)}
                  className="resource-form-input"
                />
              </div>
            </div>

            {/* Descriptions */}
            <div>
              <label className="resource-form-label">Description (English)</label>
              <textarea
                rows={2}
                placeholder="Brief summary or recommendation notes..."
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="resource-form-textarea"
              />
            </div>

            <div>
              <label className="resource-form-label">Description (Arabic - Optional)</label>
              <textarea
                rows={2}
                dir="rtl"
                placeholder="نبذة مختصرة أو نصائح مفيدة حول المحتوى..."
                value={descriptionAr}
                onChange={(e) => setDescriptionAr(e.target.value)}
                className="resource-form-textarea"
              />
            </div>

            {/* Cover Photo (Optional) */}
            <div>
              <label className="resource-form-label">
                Cover Photo (Optional)
              </label>
              <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                <input
                  type="text"
                  placeholder="Paste image URL or upload below..."
                  value={coverImageUrl}
                  onChange={(e) => setCoverImageUrl(e.target.value)}
                  className="resource-form-input"
                  style={{ flex: 1 }}
                />
                <label
                  style={{
                    display: 'inline-flex',
                    alignItems: 'center',
                    gap: '6px',
                    padding: '10px 14px',
                    backgroundColor: '#f1f5f9',
                    border: '1px solid #cbd5e1',
                    borderRadius: '10px',
                    fontSize: '13px',
                    fontWeight: 600,
                    color: '#334155',
                    cursor: uploading ? 'wait' : 'pointer',
                    whiteSpace: 'nowrap'
                  }}
                >
                  {uploading ? (
                    <Loader2 className="animate-spin" style={{ width: '16px', height: '16px' }} />
                  ) : (
                    <Upload style={{ width: '16px', height: '16px' }} />
                  )}
                  <span>{uploading ? 'Uploading...' : 'Upload Image'}</span>
                  <input
                    type="file"
                    accept="image/*"
                    style={{ display: 'none' }}
                    onChange={handleFileUpload}
                    disabled={uploading}
                  />
                </label>
              </div>

              {coverImageUrl && (
                <div style={{ marginTop: '10px', display: 'flex', alignItems: 'center', gap: '12px' }}>
                  <img
                    src={getMediaUrl(coverImageUrl)}
                    alt="Preview"
                    style={{ width: '60px', height: '40px', objectFit: 'cover', borderRadius: '6px', border: '1px solid #e2e8f0' }}
                  />
                  <button
                    type="button"
                    onClick={() => setCoverImageUrl('')}
                    style={{ background: 'none', border: 'none', color: '#ef4444', fontSize: '12px', cursor: 'pointer', padding: 0 }}
                  >
                    Remove image
                  </button>
                </div>
              )}
              <p style={{ margin: '4px 0 0 0', fontSize: '12px', color: '#94a3b8' }}>
                If no image is added, an artistic category vector graphic will be displayed automatically.
              </p>
            </div>

            {/* Recommended & Status */}
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 16px', backgroundColor: '#f8fafc', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
              <label style={{ display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer', fontSize: '13.5px', fontWeight: 600, color: '#1e293b' }}>
                <input
                  type="checkbox"
                  checked={isRecommended}
                  onChange={(e) => setIsRecommended(e.target.checked)}
                  style={{ width: '16px', height: '16px', accentColor: '#f59e0b' }}
                />
                <span>⭐ Mark as Recommended (Mais Recommended Pick)</span>
              </label>

              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span style={{ fontSize: '13px', color: '#64748b', fontWeight: 500 }}>Status:</span>
                <select
                  value={status}
                  onChange={(e) => setStatus(e.target.value)}
                  className="resource-form-select"
                  style={{ width: 'auto', padding: '6px 12px', fontSize: '13px' }}
                >
                  <option value="published">Published</option>
                  <option value="draft">Draft</option>
                </select>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="resource-modal-footer">
            <button
              type="button"
              className="btn-modal-cancel"
              onClick={onClose}
              disabled={saving}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn-modal-save"
              disabled={saving || uploading}
            >
              {saving ? 'Saving...' : initialResource ? 'Update Resource' : 'Publish Resource'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
