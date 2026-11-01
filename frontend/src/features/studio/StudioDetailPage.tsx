import { useEffect, useState, useMemo } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import { extractSessionPhotos } from '@/lib/content-utils';
import Container from '@/components/ui/Container';
import { Calendar, ArrowLeft, Edit2, RotateCcw, Trash2, BookOpen } from 'lucide-react';
import ArticleRenderer from '@/components/editor/ArticleRenderer';
import '@/styles/markdown.css';

export default function StudioDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { i18n } = useTranslation();
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [currentUser, setCurrentUser] = useState<any>(null);

  const studioGalleryPhotos = useMemo(() => extractSessionPhotos(session), [session]);

  useEffect(() => {
    try {
      const u = localStorage.getItem('user');
      setCurrentUser(u ? JSON.parse(u) : null);
    } catch {
      setCurrentUser(null);
    }
  }, []);

  const isAdmin = currentUser?.role === 'admin' || currentUser?.role === 'organizer';

  const handleUnpublish = async () => {
    if (!session) return;
    if (!confirm(`Unpublish Studio documentation for "${session.title}" back to draft? It will be removed from the public Reading Studio.`)) return;
    try {
      await apiClient.post(`/sessions/${session.id}/unpublish-studio`);
      alert('Session unpublished and moved to Drafts.');
      navigate('/admin');
    } catch (err) {
      alert('Failed to unpublish session.');
    }
  };

  const handleDelete = async () => {
    if (!session) return;
    if (!confirm(`Are you sure you want to permanently delete session "${session.title}"? This cannot be undone.`)) return;
    try {
      await apiClient.delete(`/sessions/${session.id}`);
      alert('Session successfully deleted.');
      navigate('/admin');
    } catch (err) {
      alert('Failed to delete session.');
    }
  };

  useEffect(() => {
    const fetchSession = async () => {
      try {
        const response = await apiClient.get(`/sessions/${id}`);
        setSession(response.data);
      } catch (err) {
        setError(true);
      } finally {
        setLoading(false);
      }
    };

    fetchSession();
  }, [id]);

  if (loading) {
    return (
      <div className="public-page-wrapper">
        <Container className="text-center" style={{ paddingTop: '5rem' }}>
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto" style={{ borderColor: 'var(--accent-sakura)' }}></div>
          <p style={{ marginTop: '1rem', color: 'var(--ink-secondary)' }}>Loading session summary...</p>
        </Container>
      </div>
    );
  }

  if (error || !session) {
    return (
      <div className="public-page-wrapper">
        <Container className="text-center" style={{ paddingTop: '5rem' }}>
          <div className="tactile-card" style={{ maxWidth: '500px', margin: '0 auto', padding: '3rem 2rem' }}>
            <BookOpen size={48} style={{ color: 'var(--accent-sakura)', margin: '0 auto 1rem' }} />
            <h2 style={{ fontSize: '1.5rem', marginBottom: '0.5rem' }}>Session Not Found</h2>
            <p style={{ color: 'var(--ink-secondary)', marginBottom: '1.5rem' }}>
              We could not find the reading studio summary for this session.
            </p>
            <Link to="/studio" className="tactile-btn tactile-btn-primary">
              Return to Reading Studio
            </Link>
          </div>
        </Container>
      </div>
    );
  }

  const isAr = i18n.language === 'ar';
  const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
  const date = new Date(session.scheduled_at).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
  });

  return (
    <div className="public-page-wrapper studio-detail-wrapper" style={{ paddingTop: '2.5rem' }}>
      <Container>
        {/* Navigation Breadcrumb */}
        <div style={{ marginBottom: '1.5rem' }}>
          <Link to="/studio" className="tactile-btn studio-back-btn">
            <ArrowLeft style={{ width: '16px', height: '16px', transform: isAr ? 'rotate(180deg)' : 'none' }} /> 
            <span>{isAr ? 'العودة إلى استوديو القراءة' : 'Back to Reading Studio'}</span>
          </Link>
        </div>

        {/* Admin Controls */}
        {isAdmin && (
          <div className="tactile-card admin-session-controls-bar">
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#9a3412', fontWeight: 700, fontSize: '13px' }}>
              <span>⚡ Admin Controls</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
              <Link
                to={`/admin/sessions/${session.id}/document`}
                className="tactile-btn"
                style={{ padding: '4px 10px', fontSize: '12px', background: '#F0FDF4', color: '#16A34A' }}
              >
                <Edit2 size={13} /> Edit Studio Doc
              </Link>
              <button
                type="button"
                onClick={handleUnpublish}
                className="tactile-btn"
                style={{ padding: '4px 10px', fontSize: '12px', background: '#FEF3C7', color: '#92400E' }}
              >
                <RotateCcw size={13} /> Unpublish to Draft
              </button>
              <button
                type="button"
                onClick={handleDelete}
                className="tactile-btn"
                style={{ padding: '4px 10px', fontSize: '12px', background: '#FEF2F2', color: '#DC2626' }}
              >
                <Trash2 size={13} /> Delete Session
              </button>
            </div>
          </div>
        )}

        {/* Editorial Header Banner */}
        <div className="studio-editorial-banner">
          {session.cover_image_url && (
            <img 
              src={getMediaUrl(session.cover_image_url)} 
              alt={displayTitle} 
              className="studio-editorial-banner-bg"
            />
          )}
          <div className="studio-editorial-banner-tint" />
          
          <div className="studio-editorial-banner-content">
            <div className="studio-editorial-date-pill">
              <Calendar size={14} />
              <span>{date}</span>
            </div>

            <h1 className="studio-editorial-title">
              {displayTitle}
            </h1>

            <div className="studio-editorial-meta-row">
              {session.material_type && (
                <span className="studio-meta-pill pill-category">
                  {session.material_type}
                </span>
              )}
              {session.chapters && (
                <span className="studio-meta-pill pill-chapter">
                  {session.chapters}
                </span>
              )}
              {session.level && (
                <span className="studio-meta-pill pill-level">
                  {session.level}
                </span>
              )}
            </div>
          </div>
        </div>

        {/* Lined Study Notebook Container */}
        <div className="notebook-study-container">
          {/* Ring Binding Accent */}
          <div className="notebook-spiral-binding" aria-hidden="true">
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
            <div className="spiral-ring" />
          </div>

          <div className="notebook-paper-content">
            {/* Red margin line visual cue */}
            <div className="notebook-margin-line" aria-hidden="true" />

            {session.studio_content ? (
              <div className="studio-article-content">
                <ArticleRenderer
                  content={session.studio_content}
                  dir={isAr ? 'rtl' : 'ltr'}
                />
              </div>
            ) : (
              <div style={{ color: 'var(--ink-secondary)', textAlign: 'center', padding: '60px 0', fontStyle: 'italic' }}>
                <p>{isAr ? 'لا توجد ملاحظات لهذه الجلسة حتى الآن.' : 'No notes or summary available for this session yet.'}</p>
              </div>
            )}

            {/* Session Gallery */}
            {studioGalleryPhotos.length > 0 && (
              <div className="studio-notebook-gallery">
                <div className="notebook-gallery-header">
                  <span className="gallery-hanko">写真</span>
                  <h3 className="notebook-gallery-title">
                    {isAr ? 'معرض صور الجلسة' : 'Session Polaroids & Artifacts'}
                  </h3>
                </div>

                <div className="notebook-gallery-grid">
                  {studioGalleryPhotos.map((photo, idx) => (
                    <div key={idx} className="notebook-polaroid-frame">
                      <img 
                        src={getMediaUrl(photo.url)} 
                        alt={`Session snapshot ${idx + 1}`} 
                        className="notebook-polaroid-img"
                        loading="lazy"
                      />
                      <div className="notebook-polaroid-caption">
                        <span>Snapshot #{idx + 1}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </Container>
    </div>
  );
}
