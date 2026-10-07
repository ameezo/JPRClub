import { useState, useEffect } from 'react';
import { NavLink, Link, useLocation } from 'react-router-dom';
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

  // Only pages with dark hero header have dark navbar (white text); all other pages have light navbar (dark text)
  const isStudioDetail = location.pathname.startsWith('/studio/') && location.pathname.replace(/\/$/, '') !== '/studio';
  const isDarkHero = location.pathname === '/' || isStudioDetail;

  return (
    <nav className={`site-nav ${isDarkHero ? 'dark' : 'light'} ${isOpen ? 'menu-open' : ''}`}>
      <div className="logo">
        <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', textDecoration: 'none', color: 'inherit' }}>
          <img src="/logo.jpeg" alt="JPR Club Logo" />
          <span style={{ fontWeight: 700, fontSize: '1.1rem', letterSpacing: '0.02em', color: 'inherit' }}>JPR Club</span>
        </Link>
      </div>
      
      <button 
        className="mobile-menu-btn"
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Toggle menu"
      >
        {isOpen ? '✕' : '☰'}
      </button>
      
      <div className="nav-links">
        <NavLink to="/sessions" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.sessions')}
        </NavLink>
        <NavLink to="/studio" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.studio')}
        </NavLink>
        <NavLink to="/resources" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.resources')}
        </NavLink>
        <NavLink to="/journal" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.journal')}
        </NavLink>
      </div>
      <div className="nav-actions controls">
        <LanguageToggle />
      </div>
    </nav>
  );
}
