import { useEffect, useState, useMemo } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import { extractSessionPhotos } from '@/lib/content-utils';
import Container from '@/components/ui/Container';
import { Calendar, ArrowLeft, Edit2, RotateCcw, Trash2 } from 'lucide-react';
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
    return <Container className="pt-32 pb-20 text-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div></Container>;
  }

  if (error || !session) {
    return <Container className="pt-32 pb-20 text-center text-red-500">Session not found.</Container>;
  }

  const isAr = i18n.language === 'ar';
  const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
  const date = new Date(session.scheduled_at).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
  });

  return (
    <article style={{ paddingBottom: '80px' }}>
      {/* Hero Section */}
      <div 
        style={{
          position: 'relative',
          minHeight: '380px',
          height: '45vh',
          backgroundColor: '#111827',
          overflow: 'hidden',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        {session.cover_image_url ? (
          <img 
            src={getMediaUrl(session.cover_image_url)} 
            alt={displayTitle} 
            style={{
              position: 'absolute',
              top: 0, left: 0, width: '100%', height: '100%',
              objectFit: 'cover',
              opacity: 0.55,
            }}
          />
        ) : (
          <div style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%', backgroundColor: 'rgba(247, 168, 184, 0.2)' }}></div>
        )}
        <div style={{
          position: 'absolute',
          top: 0, left: 0, right: 0, bottom: 0,
          background: 'linear-gradient(to top, rgba(17, 24, 39, 0.95) 0%, rgba(17, 24, 39, 0.45) 50%, rgba(17, 24, 39, 0.8) 100%)',
          pointerEvents: 'none',
        }}></div>
        
        <Container style={{ position: 'relative', zIndex: 10, textAlign: 'center', paddingTop: '40px' }}>
          <div style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '8px',
            color: 'rgba(255, 255, 255, 0.9)',
            marginBottom: '16px',
            backgroundColor: 'rgba(255, 255, 255, 0.15)',
            backdropFilter: 'blur(8px)',
            WebkitBackdropFilter: 'blur(8px)',
            padding: '6px 16px',
            borderRadius: '9999px',
            fontSize: '14px',
            fontWeight: 500,
          }}>
            <Calendar style={{ width: '16px', height: '16px' }} />
            {date}
          </div>
          <h1 style={{
            fontSize: '2.5rem',
            fontWeight: 700,
            color: '#ffffff',
            marginBottom: '16px',
            lineHeight: 1.25,
            textShadow: '0 2px 8px rgba(0,0,0,0.6)',
          }}>
            {displayTitle}
          </h1>
          <div style={{
            color: 'rgba(255, 255, 255, 0.9)',
            fontWeight: 500,
            letterSpacing: '0.05em',
            textTransform: 'uppercase',
            fontSize: '14px',
          }}>
            {session.material_type} {session.chapters && `• ${session.chapters}`} {session.level && `• ${session.level}`}
          </div>
        </Container>
      </div>

      <Container style={{ maxWidth: '900px', margin: '48px auto 0', padding: '0 24px' }}>
        {isAdmin && (
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            flexWrap: 'wrap',
            gap: '12px',
            backgroundColor: '#ffffff',
            border: '1px solid #fed7aa',
            borderRadius: '12px',
            padding: '12px 18px',
            marginBottom: '24px',
            boxShadow: '0 2px 8px rgba(0,0,0,0.03)',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#9a3412', fontWeight: 600, fontSize: '13px' }}>
              <span>Admin Controls</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
              <Link
                to={`/admin/sessions/${session.id}/document`}
                style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '6px',
                  backgroundColor: '#f0fdf4',
                  border: '1px solid #86efac',
                  color: '#16a34a',
                  fontSize: '13px',
                  fontWeight: 600,
                  textDecoration: 'none'
                }}
              >
                <Edit2 size={13} /> Edit Studio Doc
              </Link>
              <button
                type="button"
                onClick={handleUnpublish}
                style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '6px',
                  backgroundColor: '#fef3c7',
                  border: '1px solid #fcd34d',
                  color: '#92400e',
                  fontSize: '13px',
                  fontWeight: 600,
                  cursor: 'pointer'
                }}
              >
                <RotateCcw size={13} /> Unpublish to Draft
              </button>
              <button
                type="button"
                onClick={handleDelete}
                style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '6px',
                  backgroundColor: '#fef2f2',
                  border: '1px solid #fca5a5',
                  color: '#dc2626',
                  fontSize: '13px',
                  fontWeight: 600,
                  cursor: 'pointer'
                }}
              >
                <Trash2 size={13} /> Delete Session
              </button>
            </div>
          </div>
        )}

        <Link to="/studio" style={{
          display: 'inline-flex',
          alignItems: 'center',
          gap: '8px',
          color: '#e88599',
          fontWeight: 600,
          fontSize: '14px',
          textDecoration: 'none',
          marginBottom: '24px',
        }}>
          <ArrowLeft style={{ width: '16px', height: '16px', transform: isAr ? 'rotate(180deg)' : 'none' }} /> 
          {isAr ? 'العودة إلى الاستوديو' : 'Back to Studio'}
        </Link>

        <div style={{
          backgroundColor: '#ffffff',
          borderRadius: '16px',
          padding: '40px',
          boxShadow: '0 4px 20px rgba(0,0,0,0.04)',
          border: '1px solid #e5e7eb',
          boxSizing: 'border-box',
        }}>
          {session.studio_content ? (
            <div className="studio-article-content">
              <ArticleRenderer
                content={session.studio_content}
                dir={isAr ? 'rtl' : 'ltr'}
              />
            </div>
          ) : (
            <p style={{ color: '#6b7280', textAlign: 'center', fontStyle: 'italic', padding: '40px 0' }}>
              {isAr ? 'لا توجد ملاحظات لهذه الجلسة حتى الآن.' : 'No notes or summary available for this session yet.'}
            </p>
          )}

          {/* Session Gallery */}
          {studioGalleryPhotos.length > 0 && (
            <div style={{ marginTop: '48px', paddingTop: '48px', borderTop: '1px solid #e5e7eb' }}>
              <h3 style={{ fontSize: '20px', fontWeight: 700, color: '#111827', marginBottom: '24px', textAlign: 'center' }}>
                {isAr ? 'معرض الصور' : 'Session Gallery'}
              </h3>
              <div style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
                gap: '16px',
              }}>
                {studioGalleryPhotos.map((photo, idx) => (
                  <div key={idx} style={{
                    aspectRatio: '1 / 1',
                    backgroundColor: '#f3f4f6',
                    borderRadius: '12px',
                    overflow: 'hidden',
                    boxShadow: '0 1px 3px rgba(0,0,0,0.05)',
                  }}>
                    <img 
                      src={getMediaUrl(photo.url)} 
                      alt={`Gallery ${idx + 1}`} 
                      style={{
                        width: '100%',
                        height: '100%',
                        objectFit: 'cover',
                      }}
                      loading="lazy"
                    />
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </Container>
    </article>
  );
}
