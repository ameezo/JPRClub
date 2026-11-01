import { useState, useEffect } from 'react';
import { NavLink, Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import LanguageToggle from './LanguageToggle';

export default function Navbar() {
  const { t, i18n } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);
  const location = useLocation();

  // Close menu when route changes
  useEffect(() => {
    setIsOpen(false);
  }, [location.pathname]);

  const isAr = i18n.language === 'ar';

  const [currentUser, setCurrentUser] = useState<any>(() => {
    try {
      const u = localStorage.getItem('user');
      return u ? JSON.parse(u) : null;
    } catch {
      return null;
    }
  });

  useEffect(() => {
    const syncAuth = () => {
      try {
        const u = localStorage.getItem('user');
        setCurrentUser(u ? JSON.parse(u) : null);
      } catch {
        setCurrentUser(null);
      }
    };
    syncAuth();
    window.addEventListener('storage', syncAuth);
    return () => window.removeEventListener('storage', syncAuth);
  }, [location.pathname]);

  const token = localStorage.getItem('token');
  const isAuth = !!token && !!currentUser;
  const dashboardLink = currentUser?.role === 'admin' || currentUser?.role === 'organizer' ? '/admin' : '/dashboard';

  return (
    <header className="site-header-wrapper">
      <nav className={`site-nav ${isOpen ? 'menu-open' : ''}`}>
        {/* Brand Hanko Stamp Logo */}
        <div className="nav-brand">
          <Link to="/" className="nav-logo-link">
            <div className="logo-hanko">
              <img src="/logo.jpeg" alt="JPR Club Logo" />
            </div>
            <div className="logo-text">
              <span className="logo-title">JPR Club</span>
              <span className="logo-kanji">読書会</span>
            </div>
          </Link>
        </div>

        <button 
          className="mobile-menu-btn"
          onClick={() => setIsOpen(!isOpen)}
          aria-label="Toggle menu"
        >
          {isOpen ? '✕' : '☰'}
        </button>

        {/* Navigation Links */}
        <div className="nav-links">
          <NavLink 
            to="/sessions" 
            className={({ isActive }) => `nav-link-pill ${isActive ? 'active' : ''}`}
          >
            {t('nav.sessions')}
          </NavLink>
          <NavLink 
            to="/studio" 
            className={({ isActive }) => `nav-link-pill ${isActive ? 'active' : ''}`}
          >
            {t('nav.studio')}
          </NavLink>
          <NavLink 
            to="/gallery" 
            className={({ isActive }) => `nav-link-pill ${isActive ? 'active' : ''}`}
          >
            {t('nav.gallery')}
          </NavLink>
          <NavLink 
            to="/resources" 
            className={({ isActive }) => `nav-link-pill ${isActive ? 'active' : ''}`}
          >
            {t('nav.resources')}
          </NavLink>
          <NavLink 
            to="/journal" 
            className={({ isActive }) => `nav-link-pill ${isActive ? 'active' : ''}`}
          >
            {t('nav.journal')}
          </NavLink>
        </div>

        {/* Action Controls */}
        <div className="nav-actions controls">
          {isAuth ? (
            <Link 
              to={dashboardLink} 
              className="tactile-btn nav-btn-user"
              title={`${currentUser.name || 'Member'} (${currentUser.role || 'member'})`}
            >
              <span style={{ fontSize: '0.95rem' }}>👤</span>
              <span>{currentUser.name || (isAr ? 'لوحة التحكم' : 'Dashboard')}</span>
            </Link>
          ) : (
            <Link to="/register" className="tactile-btn tactile-btn-primary nav-btn-register">
              {isAr ? 'انضم إلينا' : 'Register'}
            </Link>
          )}
          <LanguageToggle />
        </div>
      </nav>
    </header>
  );
}
