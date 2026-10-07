import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

export default function Footer() {
  const { t } = useTranslation();

  return (
    <footer className="site-footer">
      <div className="footer-content">
        <p>© 2026 Japanese Reading Club</p>
        <div className="footer-links">
          <Link to="/about">{t('nav.about')}</Link>
          <Link to="/about#reports">{t('nav.reports')}</Link>
          <a href="#">{t('nav.contact')}</a>
        </div>
      </div>
    </footer>
  );
}
