import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import { Calendar, Clock, GraduationCap } from 'lucide-react';

export default function SessionsPage() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);

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

  return (
    <div className="public-page-wrapper bg-gray">
      <Container>
        <h1 className="public-page-heading">{t('nav.sessions') || "Sessions"}</h1>
        
        {loading ? (
          <div className="public-empty-state">Loading...</div>
        ) : sessions.length === 0 ? (
          <div className="public-empty-state">No sessions available.</div>
        ) : (
          <div className="public-grid">
            {sessions.map(session => {
              const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
              const displayDesc = isAr && session.description_ar ? session.description_ar : session.description;
              const date = new Date(session.scheduled_at);
              
              return (
                <Link to={`/sessions/${session.id}`} key={session.id} className="public-card session-card-item">
                  <h3 className="session-card-title">
                    {displayTitle}
                  </h3>
                  
                  <div className="session-card-meta">
                    <div className="session-card-meta-item">
                      <Calendar style={{ width: '16px', height: '16px', color: '#e88599', flexShrink: 0 }} />
                      <span>{date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', { month: 'long', day: 'numeric', year: 'numeric' })}</span>
                    </div>
                    <div className="session-card-meta-item">
                      <Clock style={{ width: '16px', height: '16px', color: '#e88599', flexShrink: 0 }} />
                      <span>{date.toLocaleTimeString(isAr ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' })}</span>
                    </div>
                    <div className="session-card-meta-item">
                      <GraduationCap style={{ width: '16px', height: '16px', color: '#e88599', flexShrink: 0 }} />
                      <span>{session.level || 'All Levels'}</span>
                    </div>
                  </div>
                  
                  <p className="session-card-desc">
                    {displayDesc}
                  </p>
                </Link>
              );
            })}
          </div>
        )}
      </Container>
    </div>
  );
}
