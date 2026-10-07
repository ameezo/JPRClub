import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

interface SessionCardProps {
  id: string;
  date: string;
  title: string;
  titleAr?: string;
  excerpt: string;
  excerptAr?: string;
  linkBase?: string;
}

export default function SessionCard({ id, date, title, titleAr, excerpt, excerptAr, linkBase = '/sessions' }: SessionCardProps) {
  const { t, i18n } = useTranslation();
  const isAr = i18n.language === 'ar';

  const displayTitle = (isAr && titleAr) ? titleAr : title;
  const displayExcerpt = (isAr && excerptAr) ? excerptAr : excerpt;

  return (
    <article className="card">
      <div className="card-date">{date}</div>
      <h4 className="card-title">{displayTitle}</h4>
      <p className="card-excerpt">{displayExcerpt}</p>
      <Link to={`${linkBase}/${id}`} className="card-link">
        <span>{t('home.readStudio')}</span> <span>→</span>
      </Link>
    </article>
  );
}
