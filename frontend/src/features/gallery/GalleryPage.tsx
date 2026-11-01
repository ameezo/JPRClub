import { useEffect, useState, useMemo, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import { extractSessionPhotos, type SessionPhotoItem } from '@/lib/content-utils';
import Container from '@/components/ui/Container';
import { Camera, Calendar, ArrowRight, ChevronLeft, ChevronRight, X, BookOpen } from 'lucide-react';

export default function GalleryPage() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [failedUrls, setFailedUrls] = useState<Set<string>>(new Set());

  // Lightbox Modal State
  const [lightboxIndex, setLightboxIndex] = useState<number | null>(null);

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

  // Lightbox keyboard navigation
  const activePhoto = lightboxIndex !== null && photos[lightboxIndex] ? photos[lightboxIndex] : null;

  const handlePrev = useCallback(() => {
    if (lightboxIndex === null) return;
    setLightboxIndex(prev => (prev! > 0 ? prev! - 1 : photos.length - 1));
  }, [lightboxIndex, photos.length]);

  const handleNext = useCallback(() => {
    if (lightboxIndex === null) return;
    setLightboxIndex(prev => (prev! < photos.length - 1 ? prev! + 1 : 0));
  }, [lightboxIndex, photos.length]);

  const handleClose = useCallback(() => {
    setLightboxIndex(null);
  }, []);

  useEffect(() => {
    if (lightboxIndex === null) return;

    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        handleClose();
      } else if (e.key === 'ArrowLeft') {
        if (isAr) handleNext();
        else handlePrev();
      } else if (e.key === 'ArrowRight') {
        if (isAr) handlePrev();
        else handleNext();
      }
    };

    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [lightboxIndex, isAr, handleNext, handlePrev, handleClose]);

  return (
    <div className="public-page-wrapper">
      <Container>
        {/* Header */}
        <div className="studio-page-header">
          <div className="studio-header-hanko">
            <span className="studio-hanko-text">写真館</span>
          </div>
          <h1 className="studio-page-heading">
            {isAr ? 'معرض الصور وقصاصات النادي' : (t('nav.gallery') || 'Photo Gallery & Storybook')}
          </h1>
          <p className="studio-page-subheading">
            {isAr
              ? 'لقطات وذكريات ومناقشات مصورة من جلسات النادي. انقر على أي صورة لفتحها بالحجم الكامل أو تصفح ملخص جلستها.'
              : 'Glimpses, book discussions, and memories from our Reading Studio sessions. Click any photo to open the storybook lightbox.'}
          </p>
        </div>

        {/* Loading State */}
        {loading ? (
          <div className="public-empty-state">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4" style={{ borderColor: 'var(--accent-sakura)' }}></div>
            <p>Loading photo storybook...</p>
          </div>
        ) : photos.length === 0 ? (
          <div className="public-empty-state">
            <Camera style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: 'var(--ink-secondary)' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 700, marginBottom: '8px', color: 'var(--ink-primary)' }}>
              {isAr ? 'لا توجد صور في المعرض حتى الآن' : 'No studio gallery photos yet'}
            </h2>
            <p style={{ margin: 0, color: 'var(--ink-secondary)', fontSize: '14px' }}>
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
                <div
                  key={`${photo.sessionId}-${idx}`}
                  className="tactile-card gallery-polaroid-card"
                  style={{ cursor: 'pointer' }}
                  onClick={() => setLightboxIndex(idx)}
                >
                  {/* Photo Container */}
                  <div
                    style={{
                      position: 'relative',
                      width: '100%',
                      aspectRatio: '4 / 3',
                      backgroundColor: 'var(--bg-paper-alt)',
                      overflow: 'hidden',
                      borderBottom: '1.5px solid #1C1917',
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
                        e.currentTarget.style.transform = 'scale(1.04)';
                      }}
                      onMouseLeave={(e) => {
                        e.currentTarget.style.transform = 'scale(1)';
                      }}
                    />

                    {photo.materialType && (
                      <span
                        className="tactile-stamp"
                        style={{
                          position: 'absolute',
                          top: '12px',
                          left: isAr ? 'auto' : '12px',
                          right: isAr ? '12px' : 'auto',
                          backgroundColor: 'rgba(255, 253, 249, 0.95)',
                          color: '#1C1917',
                          fontSize: '10px',
                          textTransform: 'uppercase',
                        }}
                      >
                        {photo.materialType}
                      </span>
                    )}
                  </div>

                  {/* Card Body & Footer */}
                  <div style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    <div style={{
                      fontFamily: 'var(--font-heading)',
                      fontWeight: 700,
                      fontSize: '16px',
                      color: 'var(--ink-primary)',
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
                      color: 'var(--ink-secondary)',
                      marginTop: '4px',
                    }}>
                      {dateStr && (
                        <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                          <Calendar style={{ width: '13px', height: '13px', color: 'var(--accent-sakura)' }} />
                          {dateStr}
                        </span>
                      )}

                      {/* Direct jump to written summary */}
                      <Link
                        to={`/studio/${photo.sessionId}`}
                        onClick={(e) => e.stopPropagation()}
                        className="gallery-view-session-link"
                        style={{
                          display: 'inline-flex',
                          alignItems: 'center',
                          gap: '4px',
                          color: 'var(--accent-sakura)',
                          fontWeight: 700,
                          textDecoration: 'none',
                        }}
                      >
                        <span>{isAr ? 'عرض الجلسة' : 'View Session'}</span>
                        <ArrowRight style={{ width: '13px', height: '13px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
                      </Link>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Storybook Lightbox Modal */}
        {lightboxIndex !== null && activePhoto && (
          <div 
            className="storybook-lightbox-backdrop"
            onClick={handleClose}
          >
            <div 
              className="storybook-lightbox-modal"
              onClick={(e) => e.stopPropagation()}
              role="dialog"
              aria-modal="true"
            >
              {/* Modal Top Bar */}
              <div className="lightbox-top-bar">
                <div className="lightbox-header-info">
                  <span className="lightbox-hanko">図書</span>
                  <div className="lightbox-titles">
                    <h3 className="lightbox-session-title">
                      {isAr && activePhoto.sessionTitleAr ? activePhoto.sessionTitleAr : activePhoto.sessionTitle}
                    </h3>
                    <div className="lightbox-meta-pills">
                      {activePhoto.materialType && (
                        <span className="tactile-stamp lightbox-material-pill">
                          {activePhoto.materialType}
                        </span>
                      )}
                      {activePhoto.scheduledAt && (
                        <span className="lightbox-date-pill">
                          <Calendar size={13} />
                          {new Date(activePhoto.scheduledAt).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
                            year: 'numeric', month: 'short', day: 'numeric'
                          })}
                        </span>
                      )}
                    </div>
                  </div>
                </div>

                <div className="lightbox-top-right">
                  <span className="lightbox-counter-badge">
                    {isAr ? `صورة ${lightboxIndex + 1} من ${photos.length}` : `Photo ${lightboxIndex + 1} of ${photos.length}`}
                  </span>
                  <button
                    type="button"
                    className="tactile-btn lightbox-close-btn"
                    onClick={handleClose}
                    aria-label="Close lightbox"
                  >
                    <X size={18} />
                  </button>
                </div>
              </div>

              {/* Modal Center Image */}
              <div className="lightbox-image-stage">
                <img
                  src={getMediaUrl(activePhoto.url)}
                  alt={activePhoto.sessionTitle}
                  className="lightbox-main-img"
                />
              </div>

              {/* Modal Bottom Bar */}
              <div className="lightbox-bottom-bar">
                <div className="lightbox-nav-buttons">
                  <button
                    type="button"
                    className="tactile-btn lightbox-nav-btn"
                    onClick={handlePrev}
                    title={isAr ? 'الصورة التالية' : 'Previous Photo'}
                  >
                    <ChevronLeft size={16} />
                    <span>{isAr ? 'السابقة' : 'Previous'}</span>
                  </button>
                  <button
                    type="button"
                    className="tactile-btn lightbox-nav-btn"
                    onClick={handleNext}
                    title={isAr ? 'الصورة السابقة' : 'Next Photo'}
                  >
                    <span>{isAr ? 'التالية' : 'Next'}</span>
                    <ChevronRight size={16} />
                  </button>
                </div>

                {activePhoto.sessionId && (
                  <Link
                    to={`/studio/${activePhoto.sessionId}`}
                    className="tactile-btn tactile-btn-primary lightbox-read-notes-btn"
                  >
                    <BookOpen size={16} />
                    <span>{isAr ? 'قراءة ملخص الجلسة الكامل ←' : 'Read Full Session Notes →'}</span>
                  </Link>
                )}
              </div>
            </div>
          </div>
        )}
      </Container>
    </div>
  );
}
