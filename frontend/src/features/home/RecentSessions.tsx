import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import SessionCard from '../../components/SessionCard';
import { apiClient, type Session } from '@/lib/api';

export default function RecentSessions() {
  const { t, i18n } = useTranslation();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCompleted = async () => {
      try {
        const response = await apiClient.get('/sessions?status=completed&limit=3');
        setSessions(response.data.items);
      } catch (err) {
        console.error('Failed to fetch recent sessions', err);
      } finally {
        setLoading(false);
      }
    };
    fetchCompleted();
  }, []);

  if (loading || sessions.length === 0) return null;

  return (
    <section className="section recent-sessions">
      <div className="section-header">
        <h3 className="section-title">{t('home.pastSessions')}</h3>
        <p>{t('home.catchUp')}</p>
      </div>
      
      <div className="cards-grid">
        {sessions.map(session => {
          const dateStr = new Date(session.scheduled_at).toLocaleDateString(
            i18n.language === 'ar' ? 'ar-SA' : 'en-US',
            { weekday: 'long', month: 'short', day: 'numeric' }
          );
          
          return (
            <SessionCard 
              key={session.id} 
              id={session.id}
              date={dateStr}
              title={session.title}
              titleAr={session.title_ar}
              excerpt={session.description}
              excerptAr={session.description_ar}
              linkBase="/studio"
            />
          );
        })}
      </div>
    </section>
  );
}
