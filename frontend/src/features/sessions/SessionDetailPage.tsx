import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import JoinDropdown from '@/components/JoinDropdown';
import { Calendar, Clock, BookOpen, ArrowLeft } from 'lucide-react';

export default function SessionDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchSession() {
      try {
        const response = await apiClient.get(`/sessions/${id}`);
        setSession(response.data);
      } catch (error) {
        console.error('Failed to fetch session:', error);
      } finally {
        setLoading(false);
      }
    }
    if (id) {
      fetchSession();
    }
  }, [id]);

  if (loading) {
    return (
      <div className="public-page-wrapper">
        <Container className="text-center" style={{ paddingTop: '5rem' }}>
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto" style={{ borderColor: 'var(--accent-sakura)' }}></div>
          <p style={{ marginTop: '1rem', color: 'var(--ink-secondary)' }}>Loading session details...</p>
        </Container>
      </div>
    );
  }

  if (!session) {
    return (
      <div className="public-page-wrapper">
        <Container className="text-center" style={{ paddingTop: '5rem' }}>
          <div className="tactile-card" style={{ maxWidth: '500px', margin: '0 auto', padding: '3rem 2rem' }}>
            <BookOpen size={48} style={{ color: 'var(--accent-sakura)', margin: '0 auto 1rem' }} />
            <h2 style={{ fontSize: '1.5rem', marginBottom: '0.5rem' }}>Session Not Found</h2>
            <Link to="/sessions" className="tactile-btn tactile-btn-primary">
              Return to Sessions
            </Link>
          </div>
        </Container>
      </div>
    );
  }

  const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
  const displayDesc = isAr && session.description_ar ? session.description_ar : session.description;
  const date = new Date(session.scheduled_at);

  return (
    <div className="public-page-wrapper" style={{ paddingTop: '2.5rem' }}>
      <Container>
        <div style={{ marginBottom: '1.5rem' }}>
          <Link to="/sessions" className="tactile-btn">
            <ArrowLeft style={{ width: '16px', height: '16px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
            <span>{t('nav.sessions') || "Back to Sessions"}</span>
          </Link>
        </div>
        
        {/* Main Session Detail Tactile Card */}
        <div className="tactile-card session-detail-card" style={{ maxWidth: '900px', margin: '0 auto', padding: '40px' }}>
          {/* Header row with status badge and Join dropdown */}
          <div className="session-detail-header-row">
            <div>
              <div className="tactile-stamp session-status-pill">
                <span>●</span>
                <span>{session.status.toUpperCase()}</span>
              </div>
              <h1 className="session-detail-title">
                {displayTitle}
              </h1>
            </div>
            
            <div className="session-detail-actions">
              <JoinDropdown nextSession={session} align="end" />
            </div>
          </div>

          {/* 3 Tactile Metadata Boxes */}
          <div className="session-metadata-grid">
            <div className="session-meta-box">
              <Calendar className="session-meta-icon" />
              <div className="session-meta-label">{isAr ? 'التاريخ' : 'Date'}</div>
              <div className="session-meta-value">
                {date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' })}
              </div>
            </div>
            
            <div className="session-meta-box">
              <Clock className="session-meta-icon" />
              <div className="session-meta-label">{isAr ? 'الوقت والمدة' : 'Time & Duration'}</div>
              <div className="session-meta-value">
                {date.toLocaleTimeString(isAr ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' })} • {session.duration_minutes} min
              </div>
            </div>
            
            <div className="session-meta-box">
              <BookOpen className="session-meta-icon" />
              <div className="session-meta-label">{isAr ? 'المادة المقروءة' : 'Material & Level'}</div>
              <div className="session-meta-value">
                <span>{session.material_type || 'Japanese Text'}</span>
                {session.chapters && <span className="session-meta-subvalue">{session.chapters}</span>}
              </div>
            </div>
          </div>

          {/* About Section */}
          <div className="session-detail-about-box">
            <h3 className="session-about-heading">{isAr ? 'عن هذه الجلسة' : 'About this Session'}</h3>
            <p className="session-about-desc">{displayDesc}</p>
          </div>
        </div>
      </Container>
    </div>
  );
}
