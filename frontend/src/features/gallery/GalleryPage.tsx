import { useEffect, useState, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import { extractSessionPhotos, type SessionPhotoItem } from '@/lib/content-utils';
import Container from '@/components/ui/Container';
import { Camera, Calendar, ArrowRight } from 'lucide-react';

export default function GalleryPage() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [failedUrls, setFailedUrls] = useState<Set<string>>(new Set());

  useEffect(() => {
    const fetchStudioSessions = async () => {
      try {
        const response = await apiClient.get('/sessions?status=completed&limit=100');
        const items = Array.isArray(response.data?.items) ? response.data.items : [];
        const publishedSessions = items.filter((s: Session) =>
          s.documentation_status === 'published' || (!s.documentation_status && !!s.studio_content)
        );
        setSessions(publishedSessions);
      } catch (err) {
        console.error('Failed to fetch studio gallery sessions:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchStudioSessions();
  }, []);

  // Extract all photos from studio sessions
  const photos = useMemo(() => {
    const list: SessionPhotoItem[] = [];
    sessions.forEach(session => {
      const extracted = extractSessionPhotos(session);
      list.push(...extracted);
    });
    // Remove broken/failed URLs
    return list.filter(p => !failedUrls.has(p.url));
  }, [sessions, failedUrls]);

  const handleImageError = (url: string) => {
    setFailedUrls(prev => new Set(prev).add(url));
  };

  return (
    <div className="public-page-wrapper">
      <Container>
        {/* Header */}
        <div className="studio-page-header" style={{ textAlign: 'center', marginBottom: '40px' }}>
          <h1 className="studio-page-heading" style={{ fontSize: '2.5rem', fontWeight: 800, color: '#111827', marginBottom: '12px' }}>
            {isAr ? 'معرض الصور' : (t('nav.gallery') || 'Photo Gallery')}
          </h1>
          <p className="studio-page-subheading" style={{ color: '#6b7280', fontSize: '1.1rem', maxWidth: '640px', margin: '0 auto' }}>
            {isAr
              ? 'لقطات وذكريات ومناقشات من استوديو القراءة. انقر على أي صورة للانتقال إلى تفاصيل جلستها.'
              : 'Glimpses, book discussions, and memories from our Reading Studio sessions. Click any photo to view its session summary.'}
          </p>
        </div>

        {/* Loading State */}
        {loading ? (
          <div className="public-empty-state" style={{ padding: '64px 0', textAlign: 'center', color: '#6b7280' }}>
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4" style={{ borderColor: '#e88599' }}></div>
            <p>Loading photo gallery...</p>
          </div>
        ) : photos.length === 0 ? (
          <div className="public-empty-state" style={{ padding: '64px 0', textAlign: 'center' }}>
            <Camera style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: '#d1d5db' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '8px', color: '#374151' }}>
              {isAr ? 'لا توجد صور في المعرض حتى الآن' : 'No studio gallery photos yet'}
            </h2>
            <p style={{ margin: 0, color: '#6b7280', fontSize: '14px' }}>
              {isAr ? 'ستظهر هنا صور جلسات استوديو القراءة المكتملة.' : 'Photos added to completed Reading Studio sessions will appear here.'}
            </p>
          </div>
        ) : (
          /* Photo Grid */
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
              gap: '24px',
              paddingBottom: '80px',
            }}
          >
            {photos.map((photo, idx) => {
              const displayTitle = (isAr && photo.sessionTitleAr) ? photo.sessionTitleAr : photo.sessionTitle;
              const dateStr = photo.scheduledAt ? new Date(photo.scheduledAt).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
              }) : '';

              return (
                <Link
                  key={`${photo.sessionId}-${idx}`}
                  to={`/studio/${photo.sessionId}`}
                  style={{
                    textDecoration: 'none',
                    color: 'inherit',
                    display: 'block',
                    borderRadius: '16px',
                    overflow: 'hidden',
                    backgroundColor: '#ffffff',
                    boxShadow: '0 4px 16px rgba(0, 0, 0, 0.05)',
                    border: '1px solid #f3f4f6',
                    transition: 'transform 0.2s ease, box-shadow 0.2s ease',
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.transform = 'translateY(-4px)';
                    e.currentTarget.style.boxShadow = '0 12px 28px rgba(0, 0, 0, 0.12)';
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.transform = 'translateY(0)';
                    e.currentTarget.style.boxShadow = '0 4px 16px rgba(0, 0, 0, 0.05)';
                  }}
                  title={displayTitle}
                >
                  {/* Photo Container */}
                  <div
                    style={{
                      position: 'relative',
                      width: '100%',
                      aspectRatio: '4 / 3',
                      backgroundColor: '#f3f4f6',
                      overflow: 'hidden',
                    }}
                  >
                    <img
                      src={getMediaUrl(photo.url)}
                      alt={displayTitle}
                      loading="lazy"
                      onError={() => handleImageError(photo.url)}
                      style={{
                        width: '100%',
                        height: '100%',
                        objectFit: 'cover',
                        display: 'block',
                        transition: 'transform 0.3s ease',
                      }}
                      onMouseEnter={(e) => {
                        e.currentTarget.style.transform = 'scale(1.05)';
                      }}
                      onMouseLeave={(e) => {
                        e.currentTarget.style.transform = 'scale(1)';
                      }}
                    />

                    {photo.materialType && (
                      <span
                        style={{
                          position: 'absolute',
                          top: '12px',
                          left: isAr ? 'auto' : '12px',
                          right: isAr ? '12px' : 'auto',
                          backgroundColor: 'rgba(0, 0, 0, 0.65)',
                          backdropFilter: 'blur(4px)',
                          color: '#ffffff',
                          fontSize: '11px',
                          fontWeight: 600,
                          padding: '3px 8px',
                          borderRadius: '6px',
                          textTransform: 'uppercase',
                          letterSpacing: '0.04em',
                        }}
                      >
                        {photo.materialType}
                      </span>
                    )}
                  </div>

                  {/* Card Footer */}
                  <div style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    <div style={{
                      fontWeight: 700,
                      fontSize: '15px',
                      color: '#111827',
                      lineHeight: 1.3,
                      display: '-webkit-box',
                      WebkitLineClamp: 2,
                      WebkitBoxOrient: 'vertical',
                      overflow: 'hidden',
                    }}>
                      {displayTitle}
                    </div>

                    <div style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      fontSize: '12px',
                      color: '#6b7280',
                      marginTop: '4px',
                    }}>
                      {dateStr && (
                        <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                          <Calendar style={{ width: '13px', height: '13px', color: '#9ca3af' }} />
                          {dateStr}
                        </span>
                      )}

                      <span style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        gap: '4px',
                        color: '#e88599',
                        fontWeight: 600,
                      }}>
                        {isAr ? 'عرض الجلسة' : 'View Session'}
                        <ArrowRight style={{ width: '13px', height: '13px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
                      </span>
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        )}
      </Container>
    </div>
  );
}
