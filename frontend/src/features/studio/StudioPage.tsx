import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import { BookOpen, Calendar } from 'lucide-react';

export default function StudioPage() {
  const { t, i18n } = useTranslation();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCompletedSessions = async () => {
      try {
        const response = await apiClient.get('/sessions?status=completed');
        setSessions(response.data.items);
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
    <Container className="pt-32 pb-20">
      <div className="text-center mb-12">
        <h1 className="text-5xl font-display font-bold text-gray-900 mb-4">{t('nav.studio') || 'Reading Studio'}</h1>
        <p className="text-xl text-gray-600 max-w-2xl mx-auto">
          {isAr ? 'تصفح ملخصات جلساتنا السابقة، والملاحظات، والمعرض.' : 'Explore summaries, notes, and photos from our past reading sessions.'}
        </p>
      </div>

      {loading ? (
        <div className="text-center py-20 text-gray-500">Loading...</div>
      ) : sessions.length === 0 ? (
        <div className="text-center py-20 text-gray-500 bg-gray-50 rounded-2xl border border-gray-200">
          <BookOpen className="w-12 h-12 mx-auto text-gray-300 mb-4" />
          <h2 className="text-xl font-semibold mb-2">No completed sessions yet</h2>
          <p>Check back later for session summaries and notes.</p>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {sessions.map(session => {
            const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
            const displayExcerpt = isAr && session.description_ar ? session.description_ar : session.description;
            const date = new Date(session.scheduled_at).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
              year: 'numeric', month: 'short', day: 'numeric'
            });

            return (
              <Link to={`/studio/${session.id}`} key={session.id} className="group flex flex-col bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-xl transition-all">
                <div className="aspect-[4/3] bg-gray-100 overflow-hidden relative">
                  {session.cover_image_url ? (
                    <img 
                      src={getMediaUrl(session.cover_image_url)} 
                      alt={displayTitle} 
                      className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" 
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center bg-primary/10 text-primary">
                      <BookOpen className="w-12 h-12 opacity-50" />
                    </div>
                  )}
                  <div className="absolute top-4 left-4 bg-white/90 backdrop-blur-sm px-3 py-1.5 rounded-full text-xs font-bold text-gray-900 tracking-wider uppercase">
                    {session.material_type}
                  </div>
                </div>
                
                <div className="p-6 flex flex-col flex-1">
                  <div className="flex items-center gap-2 text-sm text-gray-500 mb-3">
                    <Calendar className="w-4 h-4" />
                    {date}
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 mb-3 group-hover:text-primary transition-colors line-clamp-2">
                    {displayTitle}
                  </h3>
                  <p className="text-gray-600 line-clamp-3 mb-6 flex-1">
                    {displayExcerpt}
                  </p>
                  
                  <div className="text-primary font-bold inline-flex items-center gap-2">
                    {isAr ? 'اقرأ الملخص' : 'Read Summary'} <span className={isAr ? 'rotate-180' : ''}>→</span>
                  </div>
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </Container>
  );
}
