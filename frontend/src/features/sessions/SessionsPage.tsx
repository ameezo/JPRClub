import { useEffect, useState, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import BookCoverFallback from '@/components/BookCoverFallback';
import { Calendar, Clock, GraduationCap, ArrowRight, Sparkles } from 'lucide-react';

function SessionItemCover({
  coverUrl,
  displayTitle,
  materialType,
  isPast,
  isAr,
}: {
  coverUrl: string | null;
  displayTitle: string;
  materialType?: string;
  isPast: boolean;
  isAr: boolean;
}) {
  const [imgError, setImgError] = useState(false);
  const showCover = Boolean(coverUrl && !imgError);

  return (
    <div className="session-card-cover-wrap">
      {showCover ? (
        <img 
          src={coverUrl!} 
          alt={displayTitle} 
          className="session-cover-img"
          onError={() => setImgError(true)}
        />
      ) : (
        <BookCoverFallback category={materialType} title={displayTitle} aspectRatio="16 / 9" />
      )}
      <div className="session-cover-badges">
        <span className={`tactile-stamp session-status-badge ${isPast ? 'status-past' : 'status-upcoming'}`}>
          {isPast ? (isAr ? 'مكتملة' : 'PAST ARCHIVE') : (isAr ? 'قادمة' : 'UPCOMING')}
        </span>
        {materialType && (
          <span className="tactile-stamp session-material-badge">
            {materialType}
          </span>
        )}
      </div>
    </div>
  );
}

export default function SessionsPage() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'all' | 'upcoming' | 'past'>('all');

  useEffect(() => {
    async function fetchSessions() {
      try {
        const response = await apiClient.get('/sessions');
        setSessions(Array.isArray(response.data?.items) ? response.data.items : []);
      } catch (error) {
        console.error('Failed to fetch sessions:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchSessions();
  }, []);

  const now = new Date();

  const { upcomingSessions, pastSessions } = useMemo(() => {
    const upcoming: Session[] = [];
    const past: Session[] = [];

    sessions.forEach(session => {
      const isPast = session.status === 'completed' || new Date(session.scheduled_at) < now;
      if (isPast) {
        past.push(session);
      } else {
        upcoming.push(session);
      }
    });

    return { upcomingSessions: upcoming, pastSessions: past };
  }, [sessions, now]);

  const displayedSessions = useMemo(() => {
    if (activeTab === 'upcoming') return upcomingSessions;
    if (activeTab === 'past') return pastSessions;
    return sessions;
  }, [activeTab, sessions, upcomingSessions, pastSessions]);

  return (
    <div className="public-page-wrapper">
      <Container>
        {/* Page Header */}
        <div className="studio-page-header">
          <div className="studio-header-hanko">
            <span className="studio-hanko-text">読書会</span>
          </div>
          <h1 className="studio-page-heading">{t('nav.sessions') || "Sessions"}</h1>
          <p className="studio-page-subheading">
            {isAr
              ? 'جلساتنا الأسبوعية لقراءة ومناقشة الروايات والمانجا والمقالات اليابانية. اختر جلستك وانضم إلينا.'
              : 'Weekly reading sessions exploring Japanese literature, manga, and essays together. Join us in person or online.'}
          </p>

          {/* Status Tabs Switcher */}
          <div className="sessions-tab-bar" style={{ display: 'inline-flex', gap: '8px', marginTop: '1.5rem', flexWrap: 'wrap' }}>
            <button
              type="button"
              className={`tactile-btn ${activeTab === 'all' ? 'tactile-btn-primary' : ''}`}
              onClick={() => setActiveTab('all')}
            >
              <span>{isAr ? `كل الجلسات (${sessions.length})` : `All Sessions (${sessions.length})`}</span>
            </button>
            <button
              type="button"
              className={`tactile-btn ${activeTab === 'upcoming' ? 'tactile-btn-primary' : ''}`}
              onClick={() => setActiveTab('upcoming')}
            >
              <Sparkles size={14} />
              <span>{isAr ? `القادمة (${upcomingSessions.length})` : `Upcoming (${upcomingSessions.length})`}</span>
            </button>
            <button
              type="button"
              className={`tactile-btn ${activeTab === 'past' ? 'tactile-btn-primary' : ''}`}
              onClick={() => setActiveTab('past')}
            >
              <span>{isAr ? `الأرشيف السابقة (${pastSessions.length})` : `Past Archive (${pastSessions.length})`}</span>
            </button>
          </div>
        </div>
        
        {loading ? (
          <div className="public-empty-state">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4" style={{ borderColor: 'var(--accent-sakura)' }}></div>
            <p>Loading reading sessions...</p>
          </div>
        ) : displayedSessions.length === 0 ? (
          <div className="tactile-card public-empty-state" style={{ padding: '60px 20px', textAlign: 'center' }}>
            <Calendar style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: 'var(--ink-secondary)' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 700, marginBottom: '8px', color: 'var(--ink-primary)' }}>
              {isAr ? 'لا توجد جلسات في هذا القسم حالياً' : 'No sessions found in this category'}
            </h2>
            <p style={{ margin: 0, color: 'var(--ink-secondary)' }}>
              {isAr ? 'تابعنا لمعرفة مواعيد الجلسات القادمة أو تصفح الأرشيف.' : 'Check back soon for newly scheduled sessions or view the past archive.'}
            </p>
          </div>
        ) : (
          <div className="public-grid">
            {displayedSessions.map(session => {
              const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
              const displayDesc = isAr && session.description_ar ? session.description_ar : session.description;
              const date = new Date(session.scheduled_at);
              const coverUrl = session.cover_image_url ? getMediaUrl(session.cover_image_url) : null;
              const isPast = session.status === 'completed' || date < now;
              
              return (
                <div key={session.id} className="tactile-card session-card-item">
                  <SessionItemCover
                    coverUrl={coverUrl}
                    displayTitle={displayTitle}
                    materialType={session.material_type}
                    isPast={isPast}
                    isAr={isAr}
                  />

                  <div className="session-card-body-content">
                    <h3 className="session-card-title">
                      <Link to={`/sessions/${session.id}`}>{displayTitle}</Link>
                    </h3>
                    
                    <div className="session-card-meta">
                      <div className="session-card-meta-item">
                        <Calendar style={{ width: '14px', height: '14px', color: 'var(--accent-sakura)', flexShrink: 0 }} />
                        <span>{date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', { month: 'short', day: 'numeric', year: 'numeric' })}</span>
                      </div>
                      <div className="session-card-meta-item">
                        <Clock style={{ width: '14px', height: '14px', color: 'var(--accent-sakura)', flexShrink: 0 }} />
                        <span>{date.toLocaleTimeString(isAr ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' })}</span>
                      </div>
                      <div className="session-card-meta-item">
                        <GraduationCap style={{ width: '14px', height: '14px', color: 'var(--accent-sakura)', flexShrink: 0 }} />
                        <span>{session.level || 'All Levels'}</span>
                      </div>
                    </div>
                    
                    <p className="session-card-desc">
                      {displayDesc}
                    </p>

                    <div className="session-card-footer-action">
                      <Link to={`/sessions/${session.id}`} className="tactile-btn session-action-btn">
                        <span>{isPast ? (isAr ? 'عرض تفاصيل الجلسة' : 'View Session Details') : (isAr ? 'احجز مقعدك' : 'Join Session')}</span>
                        <ArrowRight size={15} className="card-action-arrow" />
                      </Link>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Roadmap Connector Banner: "つづく (To Be Continued)" */}
        <div className="tactile-card sessions-roadmap-connector">
          <div className="roadmap-kanji-stamp">つづく</div>
          <div className="roadmap-text-content">
            <h4 className="roadmap-heading">
              {isAr ? 'رحلة القراءة مستمرة • TO BE CONTINUED' : 'The Reading Circle Continues • TO BE CONTINUED'}
            </h4>
            <p className="roadmap-desc">
              {isAr
                ? 'فصول جديدة وكتب وروايات مختارة قيد الإعداد من قبل منسقي النادي. احرص على متابعة تحديثاتنا الأسبوعية.'
                : 'Next chapters, literary books, and community circles are constantly curated by club members. Stay tuned for the upcoming announcements.'}
            </p>
          </div>
        </div>
      </Container>
    </div>
  );
}
