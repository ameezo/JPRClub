import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Calendar, ArrowRight } from 'lucide-react';
import BookCoverFallback from './BookCoverFallback';
import { getMediaUrl } from '@/lib/api';

interface SessionCardProps {
  id: string;
  date: string;
  title: string;
  titleAr?: string;
  excerpt: string;
  excerptAr?: string;
  linkBase?: string;
  coverImageUrl?: string | null;
  category?: string | null;
}

export default function SessionCard({
  id,
  date,
  title,
  titleAr,
  excerpt,
  excerptAr,
  linkBase = '/studio',
  coverImageUrl,
  category,
}: SessionCardProps) {
  const { i18n } = useTranslation();
  const isAr = i18n.language === 'ar';
  const [imgError, setImgError] = useState(false);

  const displayTitle = isAr && titleAr ? titleAr : title;
  const displayExcerpt = isAr && excerptAr ? excerptAr : excerpt;

  const resolvedCoverUrl = coverImageUrl ? getMediaUrl(coverImageUrl) : null;
  const showCover = Boolean(resolvedCoverUrl && !imgError);

  return (
    <article className="tactile-card home-session-card">
      {/* Cover / Fallback Header */}
      <div className="home-session-card-cover">
        {showCover ? (
          <img
            src={resolvedCoverUrl!}
            alt={displayTitle}
            className="home-session-cover-img"
            onError={() => setImgError(true)}
          />
        ) : (
          <BookCoverFallback category={category} title={displayTitle} aspectRatio="16 / 9" />
        )}
        {category && (
          <span className="home-session-category-badge">
            {category}
          </span>
        )}
      </div>

      <div className="home-session-card-body">
        <div className="home-session-date-row">
          <Calendar size={14} className="home-session-date-icon" />
          <span>{date}</span>
        </div>

        <h4 className="home-session-title">
          <Link to={`${linkBase}/${id}`}>{displayTitle}</Link>
        </h4>

        <p className="home-session-excerpt">{displayExcerpt}</p>

        <Link to={`${linkBase}/${id}`} className="home-session-action-link">
          <span>{isAr ? 'قراءة ملاحظات الجلسة' : 'Read Session Notes'}</span>
          <ArrowRight size={16} className="card-action-arrow" />
        </Link>
      </div>
    </article>
  );
}
