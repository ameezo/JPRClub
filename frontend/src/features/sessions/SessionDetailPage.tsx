import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import Button from '@/components/ui/Button';
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
    return <div className="pt-32 pb-20 min-h-screen bg-gray-50 flex justify-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div></div>;
  }

  if (!session) {
    return <div className="pt-32 pb-20 min-h-screen bg-gray-50 text-center">Session not found.</div>;
  }

  const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
  const displayDesc = isAr && session.description_ar ? session.description_ar : session.description;
  const date = new Date(session.scheduled_at);

  return (
    <div className="pt-32 pb-20 min-h-screen bg-gray-50">
      <Container>
        <Link to="/sessions" className="inline-flex items-center gap-2 text-primary hover:underline mb-8">
          <ArrowLeft className={`w-4 h-4 ${isAr ? 'rotate-180' : ''}`} />
          {t('nav.sessions') || "Back to Sessions"}
        </Link>
        
        <div className="bg-white rounded-3xl p-8 md:p-12 shadow-xl border border-gray-100 max-w-4xl mx-auto relative overflow-hidden">
          <div className="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-primary to-accent" />
          
          <div className="flex flex-col md:flex-row gap-8 justify-between items-start mb-10">
            <div>
              <div className="inline-block px-4 py-1.5 rounded-full bg-primary/10 text-primary font-medium text-sm mb-4">
                {session.status.toUpperCase()}
              </div>
              <h1 className="text-4xl md:text-5xl font-display font-bold text-gray-900 leading-tight">
                {displayTitle}
              </h1>
            </div>
            
            <Button size="lg">{t('home.joinNext') || "Register Now"}</Button>
          </div>

          <div className="grid sm:grid-cols-3 gap-4 mb-12">
            <div className="p-5 bg-gray-50 rounded-2xl border border-gray-100 flex flex-col items-center justify-center text-center">
              <Calendar className="w-8 h-8 text-primary mb-3" />
              <div className="text-sm text-gray-500 mb-1">Date</div>
              <div className="font-semibold text-gray-900">
                {date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', { weekday: 'long', month: 'long', day: 'numeric' })}
              </div>
            </div>
            
            <div className="p-5 bg-gray-50 rounded-2xl border border-gray-100 flex flex-col items-center justify-center text-center">
              <Clock className="w-8 h-8 text-primary mb-3" />
              <div className="text-sm text-gray-500 mb-1">Time & Duration</div>
              <div className="font-semibold text-gray-900">
                {date.toLocaleTimeString(isAr ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' })} • {session.duration_minutes} min
              </div>
            </div>
            
            <div className="p-5 bg-gray-50 rounded-2xl border border-gray-100 flex flex-col items-center justify-center text-center">
              <BookOpen className="w-8 h-8 text-primary mb-3" />
              <div className="text-sm text-gray-500 mb-1">Material</div>
              <div className="font-semibold text-gray-900 flex flex-col">
                <span>{session.material_type}</span>
                <span className="text-sm text-gray-600">{session.chapters}</span>
              </div>
            </div>
          </div>

          <div className="prose prose-lg max-w-none text-gray-700">
            <h3 className="text-2xl font-bold font-display text-gray-900 mb-4">About this Session</h3>
            <p className="whitespace-pre-wrap">{displayDesc}</p>
          </div>
        </div>
      </Container>
    </div>
  );
}
