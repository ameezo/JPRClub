import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { apiClient, getMediaUrl, type Session } from '@/lib/api';
import Container from '@/components/ui/Container';
import { Calendar, ArrowLeft } from 'lucide-react';
import '@/styles/markdown.css'; // We'll need to create this for styling the rendered MD

export default function StudioDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { i18n } = useTranslation();
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    const fetchSession = async () => {
      try {
        const response = await apiClient.get(`/sessions/${id}`);
        setSession(response.data);
      } catch (err) {
        setError(true);
      } finally {
        setLoading(false);
      }
    };

    fetchSession();
  }, [id]);

  if (loading) {
    return <Container className="pt-32 pb-20 text-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div></Container>;
  }

  if (error || !session) {
    return <Container className="pt-32 pb-20 text-center text-red-500">Session not found.</Container>;
  }

  const isAr = i18n.language === 'ar';
  const displayTitle = isAr && session.title_ar ? session.title_ar : session.title;
  const date = new Date(session.scheduled_at).toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
  });

  return (
    <article className="pb-20">
      {/* Hero Section */}
      <div className="relative h-[60vh] min-h-[400px] bg-gray-900 overflow-hidden flex items-center justify-center">
        {session.cover_image_url ? (
          <img 
            src={getMediaUrl(session.cover_image_url)} 
            alt={displayTitle} 
            className="absolute inset-0 w-full h-full object-cover opacity-50"
          />
        ) : (
          <div className="absolute inset-0 bg-primary/20"></div>
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-gray-900 to-transparent"></div>
        
        <Container className="relative z-10 text-center pt-20">
          <div className="inline-flex items-center gap-2 text-white/80 mb-6 bg-white/10 backdrop-blur-md px-4 py-2 rounded-full text-sm font-medium">
            <Calendar className="w-4 h-4" />
            {date}
          </div>
          <h1 className="text-4xl md:text-6xl font-display font-bold text-white mb-6 leading-tight max-w-4xl mx-auto">
            {displayTitle}
          </h1>
          <div className="text-white/90 font-medium tracking-wider uppercase text-sm">
            {session.material_type} {session.chapters && `• ${session.chapters}`} {session.level && `• ${session.level}`}
          </div>
        </Container>
      </div>

      <Container className="mt-12 max-w-4xl mx-auto">
        <Link to="/studio" className="inline-flex items-center gap-2 text-primary font-bold hover:underline mb-10 transition-colors">
          <ArrowLeft className={`w-4 h-4 ${isAr ? 'rotate-180' : ''}`} /> 
          {isAr ? 'العودة إلى الاستوديو' : 'Back to Studio'}
        </Link>

        <div className="bg-white rounded-3xl p-8 md:p-12 shadow-xl border border-gray-100">
          {session.studio_content ? (
            <div className="markdown-content" dir={isAr ? 'rtl' : 'ltr'}>
              <ReactMarkdown remarkPlugins={[remarkGfm]}>
                {session.studio_content}
              </ReactMarkdown>
            </div>
          ) : (
            <p className="text-gray-500 text-center italic py-10">
              {isAr ? 'لا توجد ملاحظات لهذه الجلسة حتى الآن.' : 'No notes or summary available for this session yet.'}
            </p>
          )}

          {/* Photo Gallery */}
          {session.gallery_images && session.gallery_images.length > 0 && (
            <div className="mt-16 pt-16 border-t border-gray-200">
              <h3 className="text-2xl font-bold font-display text-gray-900 mb-8 text-center">
                {isAr ? 'معرض الصور' : 'Session Gallery'}
              </h3>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                {session.gallery_images.map((imgUrl, idx) => (
                  <div key={idx} className="aspect-square bg-gray-100 rounded-xl overflow-hidden shadow-sm group">
                    <img 
                      src={getMediaUrl(imgUrl)} 
                      alt={`Gallery ${idx + 1}`} 
                      className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                      loading="lazy"
                    />
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </Container>
    </article>
  );
}
