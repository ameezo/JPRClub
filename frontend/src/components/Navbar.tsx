import { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import LanguageToggle from './LanguageToggle';

export default function Navbar() {
  const { t } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);
  const location = useLocation();

  // Close menu when route changes
  useEffect(() => {
    setIsOpen(false);
  }, [location.pathname]);

  return (
    <nav className={`site-nav ${isOpen ? 'menu-open' : 'dark'}`}>
      <div className="nav-brand">
        <Link to="/">JPR Club</Link>
      </div>
      
      <button 
        className="mobile-menu-btn"
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Toggle menu"
      >
        {isOpen ? '✕' : '☰'}
      </button>
      
      <div className="nav-links">
        <Link to="/sessions">{t('nav.sessions')}</Link>
        <Link to="/studio">{t('nav.studio')}</Link>
        <Link to="/resources">{t('nav.resources')}</Link>
        <Link to="/journal">{t('nav.journal')}</Link>
      </div>
      <div className="nav-actions">
        <LanguageToggle />
      </div>
    </nav>
  );
}
