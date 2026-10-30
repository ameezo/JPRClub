import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useEffect, useState } from 'react';
import { apiClient, type Session } from '@/lib/api';

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
      
      <div className="session-panel-integrated">
        {currentUser?.name && (
          <div style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '8px',
            background: 'rgba(232, 133, 153, 0.12)',
            border: '1px solid rgba(232, 133, 153, 0.3)',
            color: '#d46f83',
            padding: '5px 14px',
            borderRadius: '20px',
            fontSize: '0.875rem',
            fontWeight: 600,
            marginBottom: '0.85rem'
          }}>
            <span>👋</span>
            <span>{isAr ? `مرحباً، ${currentUser.name}` : `Welcome, ${currentUser.name}!`}</span>
          </div>
        )}
        <div className="label">{t('home.nextSession')}</div>
        {loading ? (
          <div style={{ padding: '2rem 0', textAlign: 'center' }}>Loading...</div>
        ) : nextSession ? (
          <>
            <Link to={`/sessions/${nextSession.id}`} className="hero-session-title-link">
              <h2>{isAr && nextSession.title_ar ? nextSession.title_ar : nextSession.title}</h2>
            </Link>
            <div className="meta">
              {new Date(nextSession.scheduled_at).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
                weekday: 'long', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit'
              })}
            </div>
            {nextSession.description && (
              <p style={{ marginBottom: '1.5rem', color: 'var(--text-muted)' }}>
                {isAr && nextSession.description_ar ? nextSession.description_ar : nextSession.description}
              </p>
            )}
            <Link to={`/sessions/${nextSession.id}`} className="btn-primary">
              {t('home.joinNext')}
            </Link>
          </>
        ) : (
          <>
            <h2>{t('hero.title') || "Welcome to JPR Club"}</h2>
            <div className="meta">
              {t('hero.subtitle') || "Join us to read & learn together"}
            </div>
            <Link to="/sessions" className="btn-primary">
              {t('nav.sessions')}
            </Link>
          </>
        )}
      </div>
    </header>
  );
}
