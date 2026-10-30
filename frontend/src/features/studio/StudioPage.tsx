import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import { BookOpen, Calendar } from 'lucide-react';

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
  const showPlaceholder = !src || hasError;

  return (
    <div className="card-image-wrap">
      {showPlaceholder ? (
        <div className="card-image-placeholder">
          <BookOpen style={{ width: '40px', height: '40px', color: '#f7a8b8', opacity: 0.8 }} />
        </div>
      ) : (
        <img 
          src={src} 
          alt={alt} 
          className="card-image"
          onError={() => setHasError(true)} 
        />
      )}
      {materialType && (
        <div className="card-material-badge">
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
          <h1 className="studio-page-heading">{t('nav.studio') || 'Reading Studio'}</h1>
          <p className="studio-page-subheading">
            {isAr ? 'تصفح ملخصات جلساتنا السابقة، والملاحظات، والمعرض.' : 'Explore summaries, notes, and photos from our past reading sessions.'}
          </p>
        </div>

        {loading ? (
          <div className="public-empty-state">Loading...</div>
        ) : sessions.length === 0 ? (
          <div className="public-empty-state">
            <BookOpen style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: '#d1d5db' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '8px', color: '#374151' }}>No completed sessions yet</h2>
            <p style={{ margin: 0, color: '#6b7280' }}>Check back later for session summaries and notes.</p>
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
                  className="public-card studio-card-item"
                >
                  <StudioCardImage 
                    src={coverUrl} 
                    alt={displayTitle} 
                    materialType={session.material_type} 
                  />
                  
                  <div className="studio-card-body">
                    <div className="studio-card-date">
                      <Calendar style={{ width: '15px', height: '15px', color: '#9ca3af', flexShrink: 0 }} />
                      <span>{date}</span>
                    </div>
                    
                    <h3 className="studio-card-title">
                      {displayTitle}
                    </h3>
                    
                    <p className="studio-card-excerpt">
                      {displayExcerpt}
                    </p>
                    
                    <div className="studio-card-cta">
                      <span>{isAr ? 'اقرأ الملخص' : 'Read Summary'}</span>
                      <span className="studio-card-cta-arrow">→</span>
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
