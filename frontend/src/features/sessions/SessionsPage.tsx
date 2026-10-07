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
        setSessions(response.data.items);
      } catch (error) {
        console.error('Failed to fetch sessions:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchSessions();
  }, []);

  return (
    <div className="pt-32 pb-20 min-h-screen bg-gray-50">
      <Container>
        <h1 className="text-4xl font-display font-bold text-gray-900 mb-8">{t('nav.sessions') || "Sessions"}</h1>
        
        {loading ? (
          <div className="text-center py-20 text-gray-500">Loading...</div>
        ) : sessions.length === 0 ? (
          <div className="text-center py-20 text-gray-500">No sessions available.</div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {sessions.map(session => {
              const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
              const displayDesc = isAr && session.description_ar ? session.description_ar : session.description;
              const date = new Date(session.scheduled_at);
              
              return (
                <Link to={`/sessions/${session.id}`} key={session.id} className="block group">
                  <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 transition-all hover:shadow-xl hover:border-primary/20 hover:-translate-y-1">
                    <h3 className="text-xl font-bold font-display text-gray-900 mb-3 group-hover:text-primary transition-colors">
                      {displayTitle}
                    </h3>
                    
                    <div className="flex flex-col gap-2 mb-4">
                      <div className="flex items-center gap-2 text-sm text-gray-600">
                        <Calendar className="w-4 h-4 text-primary" />
                        <span>{date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', { month: 'long', day: 'numeric', year: 'numeric' })}</span>
                      </div>
                      <div className="flex items-center gap-2 text-sm text-gray-600">
                        <Clock className="w-4 h-4 text-primary" />
                        <span>{date.toLocaleTimeString(isAr ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' })}</span>
                      </div>
                      <div className="flex items-center gap-2 text-sm text-gray-600">
                        <GraduationCap className="w-4 h-4 text-primary" />
                        <span>{session.level || 'All Levels'}</span>
                      </div>
                    </div>
                    
                    <p className="text-gray-600 line-clamp-3 text-sm">
                      {displayDesc}
                    </p>
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
