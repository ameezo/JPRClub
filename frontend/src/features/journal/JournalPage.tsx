import { useEffect, useState } from 'react';
import { apiClient, getMediaUrl } from '@/lib/api';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Container from '@/components/ui/Container';
import BookCoverFallback from '@/components/BookCoverFallback';
import { FileText, Calendar, ArrowRight } from 'lucide-react';
import { extractTextSnippet } from '@/lib/content-utils';

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
  const showFallback = !src || hasError;

  return (
    <div className="card-image-wrap" style={{ aspectRatio: '16 / 9', position: 'relative', overflow: 'hidden' }}>
      {showFallback ? (
        <BookCoverFallback category="article" title={alt} aspectRatio="16 / 9" />
      ) : (
        <img
          src={src}
          alt={alt}
          className="card-image"
          onError={() => setHasError(true)}
          style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block', borderBottom: '1.5px solid #1C1917' }}
          loading="lazy"
        />
      )}
      <span className="tactile-stamp journal-format-badge">
        随筆 • ESSAY
      </span>
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
    <div className="public-page-wrapper">
      <Container>
        {/* Page Header */}
        <div className="studio-page-header">
          <div className="studio-header-hanko">
            <span className="studio-hanko-text">読書誌</span>
          </div>
          <h1 className="studio-page-heading">
            {t('nav.journal') || (isAr ? 'المجلة والمقالات' : 'JPR Club Journal')}
          </h1>
          <p className="studio-page-subheading">
            {isAr
              ? 'تأملات ورؤى ومراجعات أدبية كتبها أعضاء النادي ومراجعونا بعد كل رحلة قراءة.'
              : 'Read essays, reflections, and literary critiques penned by our members and circle moderators.'}
          </p>
        </div>

        {loading ? (
          <div className="public-empty-state">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-primary mx-auto mb-4" style={{ borderColor: 'var(--accent-sakura)' }}></div>
            <p>Loading journal articles...</p>
          </div>
        ) : articles.length === 0 ? (
          <div className="tactile-card public-empty-state" style={{ padding: '60px 20px', textAlign: 'center' }}>
            <FileText style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: 'var(--ink-secondary)' }} />
            <h2 style={{ fontSize: '1.25rem', fontWeight: 700, marginBottom: '8px', color: 'var(--ink-primary)' }}>
              {isAr ? 'لا توجد مقالات منشورة بعد' : 'No articles published yet'}
            </h2>
            <p style={{ color: 'var(--ink-secondary)', margin: 0 }}>
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
                  className="tactile-card journal-card-item"
                >
                  <JournalCardImage 
                    src={coverUrl} 
                    alt={displayTitle} 
                  />

                  {/* Card Body */}
                  <div className="journal-card-body">
                    <div className="journal-card-meta-top">
                      <div className="journal-date-badge">
                        <Calendar style={{ width: '13px', height: '13px', color: 'var(--accent-sakura)', flexShrink: 0 }} />
                        <span>{formattedDate}</span>
                      </div>

                      {/* Borrower Stamp Author Badge */}
                      {article.author_name && (
                        <span className="library-borrower-stamp">
                          {article.author_name}
                        </span>
                      )}
                    </div>

                    <h3 className="journal-card-title">
                      {displayTitle}
                    </h3>

                    {displaySubtitle && (
                      <div className="journal-card-subtitle">
                        {displaySubtitle}
                      </div>
                    )}

                    <p className="journal-card-excerpt">
                      {plainSnippet ? `${plainSnippet}...` : ''}
                    </p>

                    <div className="journal-card-action">
                      <span>{isAr ? 'قراءة المقال بالكامل' : 'Read Full Essay'}</span>
                      <ArrowRight size={15} className="card-action-arrow" />
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
