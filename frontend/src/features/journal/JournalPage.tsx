import { useEffect, useState } from 'react';
import { apiClient, getMediaUrl } from '@/lib/api';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Container from '@/components/ui/Container';
import { FileText, Calendar, ArrowRight, BookOpen } from 'lucide-react';
import { extractTextSnippet } from '@/lib/content-utils';
import '@/styles/public.css';

interface JournalSubmission {
  id: string;
  title: string;
  title_ar?: string;
  created_at: string;
  published_at?: string;
  content: string;
  content_ar?: string;
  cover_image_url?: string | null;
  author_name?: string;
}

function JournalCardImage({
  src,
  alt,
}: {
  src?: string | null;
  alt: string;
}) {
  const [hasError, setHasError] = useState(false);
  const showPlaceholder = !src || hasError;

  return (
    <div
      className="card-image-wrap"
      style={{
        aspectRatio: '16 / 9',
        backgroundColor: '#f9fafb',
        position: 'relative',
        overflow: 'hidden',
        width: '100%'
      }}
    >
      {showPlaceholder ? (
        <div
          className="card-image-placeholder"
          style={{
            background: 'linear-gradient(135deg, #fff5f5 0%, #fef2f2 40%, #fce7f3 100%)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '100%',
            height: '100%'
          }}
        >
          <BookOpen style={{ width: '40px', height: '40px', color: '#f7a8b8', opacity: 0.85 }} />
        </div>
      ) : (
        <img
          src={src}
          alt={alt}
          className="card-image"
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'cover',
            objectPosition: 'center',
            display: 'block'
          }}
          loading="lazy"
          onError={() => setHasError(true)}
        />
      )}
    </div>
  );
}

export default function JournalPage() {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  const [articles, setArticles] = useState<JournalSubmission[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchArticles = async () => {
      try {
        const response = await apiClient.get('/journal/public');
        setArticles(response.data.items || []);
      } catch (error) {
        console.error('Failed to fetch journal articles:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchArticles();
  }, []);

  return (
    <div className="public-page-wrapper bg-gray">
      <Container>
        {/* Page Header (Matching Reading Studio and Sessions) */}
        <div className="studio-page-header">
          <h1 className="studio-page-heading">
            {t('nav.journal') || (isAr ? 'المجلة' : 'JPR Club Journal')}
          </h1>
          <p className="studio-page-subheading">
            {isAr
              ? 'اقرأ المقالات والتأملات والرؤى المكتوبة من أعضائنا الموثقين ومراجعينا.'
              : 'Read articles, reflections, and insights written by our verified members and reviewers.'}
          </p>
        </div>

        {loading ? (
          <div className="public-empty-state">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto"></div>
            <div style={{ marginTop: '16px', color: '#6b7280' }}>Loading articles...</div>
          </div>
        ) : articles.length === 0 ? (
          <div className="public-empty-state">
            <FileText style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: '#d1d5db' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '8px', color: '#374151' }}>
              {isAr ? 'لا توجد مقالات منشورة بعد' : 'No articles published yet'}
            </h2>
            <p style={{ color: '#6b7280', margin: 0 }}>
              {isAr ? 'يرجى العودة لاحقاً للاطلاع على منشورات جديدة.' : 'Check back later for new member reflections and essays.'}
            </p>
          </div>
        ) : (
          <div className="public-grid">
            {articles.map((article) => {
              const displayTitle = isAr && article.title_ar ? article.title_ar : article.title;
              const displaySubtitle = isAr && article.title_ar && article.title !== article.title_ar ? article.title : (!isAr ? article.title_ar : null);
              const contentToSnippet = (isAr && article.content_ar ? article.content_ar : article.content) || '';
              const plainSnippet = extractTextSnippet(contentToSnippet, 160);
              
              const date = new Date(article.published_at || article.created_at);
              const formattedDate = date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
              });

              const coverUrl = article.cover_image_url ? getMediaUrl(article.cover_image_url) : null;

              return (
                <Link 
                  to={`/journal/${article.id}`} 
                  key={article.id} 
                  className="public-card studio-card-item"
                  style={{
                    display: 'flex',
                    flexDirection: 'column',
                    height: '100%',
                    textDecoration: 'none',
                    color: 'inherit',
                    borderRadius: '16px',
                    overflow: 'hidden'
                  }}
                >
                  {/* Uniform Centered Cover Header with Elegant Fallback */}
                  <JournalCardImage 
                    src={coverUrl} 
                    alt={displayTitle} 
                  />

                  {/* Card Body */}
                  <div style={{ padding: '22px', display: 'flex', flexDirection: 'column', flex: 1 }}>
                    <div style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      marginBottom: '12px',
                      gap: '8px'
                    }}>
                      <div className="session-card-meta-item" style={{ fontSize: '13px' }}>
                        <Calendar style={{ width: '15px', height: '15px', color: '#e88599', flexShrink: 0 }} />
                        <span>{formattedDate}</span>
                      </div>
                      {article.author_name && (
                        <span style={{
                          fontSize: '12px',
                          fontWeight: 600,
                          color: '#e88599',
                          backgroundColor: 'rgba(232, 133, 153, 0.12)',
                          padding: '2px 10px',
                          borderRadius: '9999px',
                          whiteSpace: 'nowrap'
                        }}>
                          {article.author_name}
                        </span>
                      )}
                    </div>

                    <h3 
                      className="session-card-title" 
                      dir="auto"
                      style={{
                        margin: '0 0 8px',
                        display: '-webkit-box',
                        WebkitLineClamp: 2,
                        WebkitBoxOrient: 'vertical',
                        overflow: 'hidden',
                        lineHeight: 1.35
                      }}
                    >
                      {displayTitle}
                    </h3>

                    {displaySubtitle && (
                      <div 
                        dir="auto"
                        style={{
                          fontSize: '13px',
                          color: '#6b7280',
                          marginBottom: '10px',
                          lineHeight: 1.4,
                          display: '-webkit-box',
                          WebkitLineClamp: 1,
                          WebkitBoxOrient: 'vertical',
                          overflow: 'hidden'
                        }}
                      >
                        {displaySubtitle}
                      </div>
                    )}

                    <p 
                      className="session-card-desc" 
                      dir="auto"
                      style={{
                        flexGrow: 1,
                        marginBottom: '20px',
                        unicodeBidi: 'plaintext',
                        textAlign: 'start',
                        display: '-webkit-box',
                        WebkitLineClamp: 3,
                        WebkitBoxOrient: 'vertical',
                        overflow: 'hidden'
                      }}
                    >
                      {plainSnippet ? `${plainSnippet}...` : ''}
                    </p>

                    <div style={{
                      marginTop: 'auto',
                      paddingTop: '14px',
                      borderTop: '1px solid #f3f4f6',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '6px',
                      color: '#e88599',
                      fontWeight: 600,
                      fontSize: '14px'
                    }}>
                      <span>{isAr ? 'قراءة المقال' : 'Read Article'}</span>
                      <ArrowRight style={{ width: '15px', height: '15px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
                    </div>
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
