import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl } from '@/lib/api';
import Container from '@/components/ui/Container';
import { Calendar, ArrowLeft, User as UserIcon, BookOpen } from 'lucide-react';
import ArticleRenderer from '@/components/editor/ArticleRenderer';
import '@/styles/markdown.css';

interface JournalSubmission {
  id: string;
  title: string;
  title_ar?: string;
  content: string;
  content_ar?: string;
  cover_image_url?: string | null;
  content_language?: string;
  published_at?: string;
  created_at?: string;
  author_name?: string;
}

export default function JournalArticlePage() {
  const { id } = useParams();
  const { i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  const [article, setArticle] = useState<JournalSubmission | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    const fetchArticle = async () => {
      try {
        const response = await apiClient.get(`/journal/${id}`);
        setArticle(response.data);
      } catch (err) {
        console.error('Failed to fetch article', err);
        setError(true);
      } finally {
        setLoading(false);
      }
    };
    if (id) {
      fetchArticle();
    }
  }, [id]);

  if (loading) {
    return (
      <div className="public-page-wrapper">
        <Container style={{ textAlign: 'center', paddingTop: '5rem' }}>
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto" style={{ borderColor: 'var(--accent-sakura)' }}></div>
          <p style={{ marginTop: '1rem', color: 'var(--ink-secondary)' }}>Loading article...</p>
        </Container>
      </div>
    );
  }

  if (error || !article) {
    return (
      <div className="public-page-wrapper">
        <Container style={{ maxWidth: '600px', margin: '40px auto', textAlign: 'center' }}>
          <div className="tactile-card" style={{ padding: '48px 32px' }}>
            <BookOpen style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: 'var(--accent-sakura)' }} />
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, color: 'var(--ink-primary)', marginBottom: '12px' }}>
              {isAr ? 'المقال غير موجود' : 'Article Not Found'}
            </h2>
            <p style={{ color: 'var(--ink-secondary)', marginBottom: '24px' }}>
              {isAr ? 'لم نتمكن من العثور على المقال المطلوب.' : 'The article you are looking for does not exist or is no longer available.'}
            </p>
            <Link 
              to="/journal" 
              className="tactile-btn tactile-btn-primary"
            >
              <ArrowLeft style={{ width: '16px', height: '16px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
              <span>{isAr ? 'العودة إلى المجلة' : 'Return to Journal'}</span>
            </Link>
          </div>
        </Container>
      </div>
    );
  }

  const date = new Date(article.published_at || article.created_at || 0);
  const formattedDate = date.toLocaleDateString(isAr ? 'ar-SA' : 'en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  return (
    <div className="public-page-wrapper" style={{ paddingTop: '2.5rem' }}>
      <Container>
        {/* Navigation Back Link */}
        <div style={{ maxWidth: '760px', margin: '0 auto 1.5rem auto' }}>
          <Link 
            to="/journal" 
            className="tactile-btn"
          >
            <ArrowLeft style={{ width: '16px', height: '16px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
            <span>{isAr ? 'العودة إلى المجلة' : 'Back to Journal'}</span>
          </Link>
        </div>
        
        {/* Editorial Magazine Column Card */}
        <article className="tactile-card journal-editorial-column">
          {/* Top Stamp Header */}
          <div className="journal-reader-stamp-bar">
            <span className="tactile-stamp stamp-journal-header">
              読書誌 • JPR CLUB JOURNAL
            </span>
            <div className="journal-reader-date">
              <Calendar style={{ width: '14px', height: '14px', color: 'var(--accent-sakura)' }} />
              <span>{formattedDate}</span>
            </div>
          </div>

          {/* Cover Image Banner */}
          {article.cover_image_url && (
            <div className="journal-reader-cover-wrap">
              <img
                src={getMediaUrl(article.cover_image_url)}
                alt={article.title}
                className="journal-reader-cover-img"
              />
            </div>
          )}

          {/* Title Header */}
          <div className="journal-reader-title-area">
            <h1 className="journal-reader-title" dir="auto">
              {article.title}
            </h1>

            {article.title_ar && article.title !== article.title_ar && (
              <h2 className="journal-reader-subtitle" dir="rtl">
                {article.title_ar}
              </h2>
            )}

            {/* Author Library Borrower Stamp */}
            {article.author_name && (
              <div className="journal-reader-author-row">
                <span className="library-borrower-stamp">
                  <UserIcon size={12} style={{ display: 'inline', marginRight: '4px', verticalAlign: 'middle' }} />
                  {article.author_name}
                </span>
                <span className="journal-editorial-rule" aria-hidden="true" />
              </div>
            )}
          </div>

          {/* Article Main Body */}
          <div className="journal-reader-body">
            <ArticleRenderer
              content={article.content}
              dir={article.content_language === 'ar' ? 'rtl' : 'ltr'}
            />
          </div>

          {/* Dual Language Arabic Content Section */}
          {article.content_ar && (
            <div dir="rtl" className="journal-dual-lang-section">
              <div className="dual-lang-divider">
                <span>الترجمة العربية للنص</span>
              </div>
              <ArticleRenderer
                content={article.content_ar}
                dir="rtl"
              />
            </div>
          )}
        </article>
      </Container>
    </div>
  );
}
