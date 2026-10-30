import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { apiClient, getMediaUrl } from '@/lib/api';
import Container from '@/components/ui/Container';
import { Calendar, ArrowLeft, User as UserIcon, BookOpen } from 'lucide-react';
import ArticleRenderer from '@/components/editor/ArticleRenderer';
import '@/styles/public.css';
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
      <div className="public-page-wrapper bg-gray">
        <Container style={{ textAlign: 'center', paddingTop: '40px' }}>
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
          <p style={{ marginTop: '16px', color: '#6b7280' }}>Loading article...</p>
        </Container>
      </div>
    );
  }

  if (error || !article) {
    return (
      <div className="public-page-wrapper bg-gray">
        <Container style={{ maxWidth: '600px', margin: '40px auto', textAlign: 'center' }}>
          <div style={{
            backgroundColor: '#ffffff',
            borderRadius: '16px',
            padding: '48px 32px',
            border: '1px solid #e5e7eb',
            boxShadow: '0 1px 3px rgba(0,0,0,0.05)'
          }}>
            <BookOpen style={{ width: '48px', height: '48px', margin: '0 auto 16px', color: '#d1d5db' }} />
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, color: '#111827', marginBottom: '12px' }}>
              {isAr ? 'المقال غير موجود' : 'Article Not Found'}
            </h2>
            <p style={{ color: '#6b7280', marginBottom: '24px' }}>
              {isAr ? 'لم نتمكن من العثور على المقال المطلوب.' : 'The article you are looking for does not exist or is no longer available.'}
            </p>
            <Link 
              to="/journal" 
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '8px',
                color: '#ffffff',
                backgroundColor: '#e88599',
                padding: '10px 20px',
                borderRadius: '20px',
                fontWeight: 600,
                textDecoration: 'none'
              }}
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
    <div className="public-page-wrapper bg-gray">
      <Container style={{ maxWidth: '900px', margin: '0 auto' }}>
        {/* Navigation Back Link (Matching Sessions and Studio Detail) */}
        <Link 
          to="/journal" 
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '8px',
            color: '#e88599',
            fontWeight: 600,
            fontSize: '14px',
            textDecoration: 'none',
            marginBottom: '24px',
            transition: 'opacity 0.2s'
          }}
        >
          <ArrowLeft style={{ width: '16px', height: '16px', transform: isAr ? 'rotate(180deg)' : 'none' }} />
          <span>{isAr ? 'العودة إلى المجلة' : 'Back to Journal'}</span>
        </Link>
        
        {/* Main Article Normalized Card */}
        <div style={{
          backgroundColor: '#ffffff',
          borderRadius: '24px',
          padding: '48px',
          boxShadow: '0 4px 20px rgba(0, 0, 0, 0.05)',
          border: '1px solid #e5e7eb',
          position: 'relative',
          overflow: 'hidden',
          boxSizing: 'border-box'
        }}>
          {/* Decorative Top Accent Stripe */}
          <div style={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            height: '6px',
            background: 'linear-gradient(90deg, #f7a8b8 0%, #e88599 50%, #a3c1e2 100%)'
          }} />

          {/* Cover Image Banner */}
          {article.cover_image_url && (
            <div style={{
              margin: '-48px -48px 36px',
              aspectRatio: '21 / 9',
              maxHeight: '380px',
              overflow: 'hidden',
              backgroundColor: '#f9fafb',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center'
            }}>
              <img
                src={getMediaUrl(article.cover_image_url)}
                alt={article.title}
                style={{ width: '100%', height: '100%', objectFit: 'cover', objectPosition: 'center', display: 'block' }}
              />
            </div>
          )}

          {/* Metadata Header */}
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            flexWrap: 'wrap',
            gap: '12px',
            marginBottom: '28px',
            paddingBottom: '20px',
            borderBottom: '1px solid #f3f4f6'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#6b7280', fontSize: '14px' }}>
              <Calendar style={{ width: '16px', height: '16px', color: '#e88599' }} />
              <span>{formattedDate}</span>
            </div>

            {article.author_name && (
              <div style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                backgroundColor: 'rgba(232, 133, 153, 0.1)',
                color: '#e88599',
                padding: '6px 14px',
                borderRadius: '9999px',
                fontSize: '13px',
                fontWeight: 600
              }}>
                <UserIcon style={{ width: '14px', height: '14px' }} />
                <span>{article.author_name}</span>
              </div>
            )}
          </div>

          {/* Article Titles */}
          <h1 
            dir="auto"
            style={{
              fontSize: '2.5rem',
              fontWeight: 700,
              color: '#111827',
              lineHeight: 1.25,
              marginBottom: article.title_ar ? '12px' : '36px',
              marginTop: 0
            }}
          >
            {article.title}
          </h1>

          {article.title_ar && (
            <h2 dir="rtl" style={{
              fontSize: '1.75rem',
              fontWeight: 600,
              color: '#4b5563',
              marginBottom: '36px',
              marginTop: 0,
              lineHeight: 1.3
            }}>
              {article.title_ar}
            </h2>
          )}

          {/* Main Content */}
          <ArticleRenderer
            content={article.content}
            dir={article.content_language === 'ar' ? 'rtl' : 'ltr'}
          />

          {/* Arabic Content Section (if provided for legacy dual-language entries) */}
          {article.content_ar && (
            <div dir="rtl" style={{
              marginTop: '48px',
              paddingTop: '36px',
              borderTop: '2px dashed #f3f4f6'
            }}>
              <ArticleRenderer
                content={article.content_ar}
                dir="rtl"
              />
            </div>
          )}
        </div>
      </Container>
    </div>
  );
}
