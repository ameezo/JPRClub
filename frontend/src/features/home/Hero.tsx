import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useEffect, useState } from 'react';
import { apiClient, type Session } from '@/lib/api';
import { Calendar, Clock, ArrowRight } from 'lucide-react';

export default function Hero() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const [nextSession, setNextSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  const [currentUser, setCurrentUser] = useState<any>(() => {
    try {
      const u = localStorage.getItem('user');
      return u ? JSON.parse(u) : null;
    } catch {
      return null;
    }
  });

  useEffect(() => {
    const syncAuth = () => {
      try {
        const u = localStorage.getItem('user');
        setCurrentUser(u ? JSON.parse(u) : null);
      } catch {
        setCurrentUser(null);
      }
    };
    window.addEventListener('storage', syncAuth);
    return () => window.removeEventListener('storage', syncAuth);
  }, []);

  useEffect(() => {
    async function fetchNextSession() {
      try {
        const response = await apiClient.get('/sessions/next');
        setNextSession(response.data.session);
      } catch (error) {
        console.error('Failed to fetch next session:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchNextSession();
  }, []);

  const scheduledDate = nextSession ? new Date(nextSession.scheduled_at) : null;
  const dateStr = scheduledDate ? scheduledDate.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
    weekday: 'long', month: 'short', day: 'numeric'
  }) : '';
  const timeStr = scheduledDate ? scheduledDate.toLocaleTimeString(isAr ? 'ar-SA' : 'en-US', {
    hour: '2-digit', minute: '2-digit'
  }) : '';

  return (
    <header className="hero-cinematic">
      <video 
        id="hero-video"
        className="video-bg"
        autoPlay 
        muted 
        loop 
        playsInline 
        poster="/logo.jpeg"
      >
        <source src="/JPRClub_test_video.mp4" type="video/mp4" />
      </video>
      <div className="hero-warm-overlay" />
      
      {/* Club Event Ticket / Bookmark Card */}
      <div className="event-ticket-card">
        {currentUser?.name && (
          <div className="ticket-welcome-badge">
            <span>👋</span>
            <span>{isAr ? `أهلاً بك، ${currentUser.name}` : `Welcome back, ${currentUser.name}!`}</span>
          </div>
        )}

        {/* Ticket Header Bar */}
        <div className="ticket-header-row">
          <div className="ticket-status-stamp">
            <span className="ticket-status-dot">●</span>
            <span>{isAr ? 'الجلسة القادمة' : 'UPCOMING SESSION'}</span>
          </div>
          <div className="ticket-hanko-stamp">
            <span>読書会</span>
          </div>
        </div>

        {loading ? (
          <div style={{ padding: '2.5rem 0', textAlign: 'center', color: 'var(--ink-secondary)' }}>
            Loading next session...
          </div>
        ) : nextSession ? (
          <>
            <div className="ticket-body-content">
              <Link to={`/sessions/${nextSession.id}`} className="ticket-title-link">
                <h2 className="ticket-title">
                  {isAr && nextSession.title_ar ? nextSession.title_ar : nextSession.title}
                </h2>
              </Link>

              <div className="ticket-meta-row">
                <span className="ticket-meta-pill">
                  <Calendar size={14} />
                  <span>{dateStr}</span>
                </span>
                <span className="ticket-meta-pill">
                  <Clock size={14} />
                  <span>{timeStr}</span>
                </span>
                {nextSession.material_type && (
                  <span className="ticket-meta-pill ticket-meta-material">
                    {nextSession.material_type}
                  </span>
                )}
              </div>

              {nextSession.description && (
                <p className="ticket-excerpt">
                  {isAr && nextSession.description_ar ? nextSession.description_ar : nextSession.description}
                </p>
              )}
            </div>

            {/* Perforation Line with Semicircular Ticket Cutouts */}
            <div className="ticket-perforation-wrapper">
              <div className="ticket-cutout ticket-cutout-left" />
              <div className="ticket-perforation-line" />
              <div className="ticket-cutout ticket-cutout-right" />
            </div>

            {/* Ticket Footer Action */}
            <div className="ticket-footer-action">
              <Link 
                to={`/sessions/${nextSession.id}`} 
                className="tactile-btn tactile-btn-primary ticket-cta-btn"
              >
                <span>{t('home.joinNext') || (isAr ? 'الانضمام للجلسة القادمة' : 'Join Next Session')}</span>
                <ArrowRight size={16} className="ticket-arrow-icon" />
              </Link>
            </div>
          </>
        ) : (
          <>
            <div className="ticket-body-content">
              <h2 className="ticket-title">
                {t('hero.title') || (isAr ? 'مرحباً بك في نادي القراءة اليابانية' : 'Welcome to JPR Club')}
              </h2>
              <p className="ticket-excerpt">
                {t('hero.subtitle') || (isAr ? 'انضم إلينا للقراءة والتعلم معاً في جلسات أسبوعية تفاعلية.' : 'Join our weekly community sessions to read novels, manga, and essays together.')}
              </p>
            </div>

            <div className="ticket-perforation-wrapper">
              <div className="ticket-cutout ticket-cutout-left" />
              <div className="ticket-perforation-line" />
              <div className="ticket-cutout ticket-cutout-right" />
            </div>

            <div className="ticket-footer-action">
              <Link to="/sessions" className="tactile-btn tactile-btn-primary ticket-cta-btn">
                <span>{t('nav.sessions') || (isAr ? 'تصفح الجلسات' : 'Explore Sessions')}</span>
                <ArrowRight size={16} className="ticket-arrow-icon" />
              </Link>
            </div>
          </>
        )}
      </div>
    </header>
  );
}
