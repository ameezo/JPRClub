import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

interface SessionCardProps {
  id: string;
  date: string;
  title: string;
  titleAr?: string;
  excerpt: string;
  excerptAr?: string;
}

export default function SessionCard({ id, date, title, titleAr, excerpt, excerptAr }: SessionCardProps) {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const displayTitle = (isAr && titleAr) ? titleAr : title;
  const displayExcerpt = (isAr && excerptAr) ? excerptAr : excerpt;

  return (
    <article className="session-card">
      <div className="session-meta">
        <span className="session-date">{date}</span>
      </div>
      <h3 className="session-title">{displayTitle}</h3>
      <p className="session-excerpt">{displayExcerpt}</p>
      <Link to={`/sessions/${id}`} className="read-more">
        {t('home.readStudio')} <span>→</span>
      </Link>
    </article>
  );
}
