import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import BookCoverFallback from '@/components/BookCoverFallback';
import { Calendar, ArrowRight, BookOpen } from 'lucide-react';

function getCategoryBadgeStyle(category?: string | null) {
  const norm = (category || '').toLowerCase();
  if (norm.includes('novel') || norm.includes('رواية')) {
    return { bg: '#FDE2E4', color: '#9F1239' };
  }
  if (norm.includes('manga') || norm.includes('مانجا')) {
    return { bg: '#D8F3DC', color: '#065F46' };
  }
  if (norm.includes('essay') || norm.includes('مقال')) {
    return { bg: '#FEF3C7', color: '#92400E' };
  }
  return { bg: '#E0E7FF', color: '#3730A3' };
}

function StudioCardImage({ 
  src, 
  alt, 
  materialType 
}: { 
  src?: string | null; 
  alt: string; 
  materialType?: string; 
}) {
  const [hasError, setHasError] = useState(false);
  const showFallback = !src || hasError;
  const badgeStyle = getCategoryBadgeStyle(materialType);

  return (
    <div className="card-image-wrap" style={{ position: 'relative', overflow: 'hidden' }}>
      {showFallback ? (
        <BookCoverFallback category={materialType} title={alt} aspectRatio="16 / 10" />
      ) : (
        <img 
          src={src} 
          alt={alt} 
          className="card-image"
          onError={() => setHasError(true)} 
          style={{ width: '100%', height: '100%', objectFit: 'cover', borderBottom: '1.5px solid #1C1917' }}
        />
      )}
      {materialType && (
        <div 
          className="studio-category-pill"
          style={{
            position: 'absolute',
            top: '12px',
            backgroundColor: badgeStyle.bg,
            color: badgeStyle.color,
          }}
        >
          {materialType}
        </div>
      )}
    </div>
  );
}

export default function StudioPage() {
  const { t, i18n } = useTranslation();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCompletedSessions = async () => {
      try {
        const response = await apiClient.get('/sessions?status=completed');
        const items = Array.isArray(response.data?.items) ? response.data.items : [];
        const publishedSessions = items.filter((s: Session) =>
          s.documentation_status === 'published' || (!s.documentation_status && !!s.studio_content)
        );
        setSessions(publishedSessions);
      } catch (error) {
        console.error('Failed to fetch completed sessions:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchCompletedSessions();
  }, []);

  const isAr = i18n.language === 'ar';

  return (
    <div className="public-page-wrapper">
      <Container>
        <div className="studio-page-header">
          <div className="studio-header-hanko">
            <span className="studio-hanko-text">読書室</span>
          </div>
          <h1 className="studio-page-heading">{t('nav.studio') || 'Reading Studio'}</h1>
          <p className="studio-page-subheading">
            {isAr ? 'تصفح ملخصات جلساتنا السابقة، والملاحظات الدراسية، والمعرض التفاعلي.' : 'Explore session summaries, notebook vocabulary, and discussion insights from past reading circles.'}
          </p>
        </div>

        {loading ? (
          <div className="public-empty-state">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4" style={{ borderColor: 'var(--accent-sakura)' }}></div>
            <p>Loading Reading Studio...</p>
          </div>
        ) : sessions.length === 0 ? (
          <div className="public-empty-state">
            <BookOpen style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: '#1C1917' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 700, marginBottom: '8px', color: '#1C1917' }}>
              {isAr ? 'لا توجد جلسات مكتملة حتى الآن' : 'No completed sessions yet'}
            </h2>
            <p style={{ margin: 0, color: '#57534E' }}>
              {isAr ? 'تابعنا لاحقاً للاطلاع على الملخصات والملاحظات بعد انتهاء الجلسات القادمة.' : 'Check back later for session summaries and study notes.'}
            </p>
          </div>
        ) : (
          <div className="public-grid">
            {sessions.map(session => {
              const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
              const displayExcerpt = isAr && session.description_ar ? session.description_ar : session.description;
              const date = new Date(session.scheduled_at).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
                year: 'numeric', month: 'short', day: 'numeric'
              });
              const coverUrl = session.cover_image_url ? getMediaUrl(session.cover_image_url) : null;

              return (
                <Link 
                  to={`/studio/${session.id}`} 
                  key={session.id} 
                  className="tactile-card studio-card-item"
                >
                  <StudioCardImage 
                    src={coverUrl} 
                    alt={displayTitle} 
                    materialType={session.material_type} 
                  />
                  
                  <div className="studio-card-body">
                    <div className="studio-card-date">
                      <Calendar style={{ width: '14px', height: '14px', color: 'var(--accent-sakura)', flexShrink: 0 }} />
                      <span>{date}</span>
                    </div>
                    
                    <h3 className="studio-card-title">
                      {displayTitle}
                    </h3>
                    
                    <p className="studio-card-excerpt">
                      {displayExcerpt}
                    </p>
                    
                    <div className="studio-card-cta">
                      <span>{isAr ? 'اقرأ الملخص والمفردات' : 'Read Session Notes'}</span>
                      <ArrowRight size={15} className="studio-card-cta-arrow" />
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
