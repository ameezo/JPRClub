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

  // Only pages with dark hero header have dark navbar (white text); all other pages have light navbar (dark text)
  const isStudioDetail = location.pathname.startsWith('/studio/') && location.pathname.replace(/\/$/, '') !== '/studio';
  const isDarkHero = location.pathname === '/' || isStudioDetail;

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
        <NavLink to="/gallery" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.gallery')}
        </NavLink>
        <NavLink to="/resources" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.resources')}
        </NavLink>
        <NavLink to="/journal" className={({ isActive }) => isActive ? 'active' : ''}>
          {t('nav.journal')}
        </NavLink>
      </div>
      <div className="nav-actions controls">
        {isAuth ? (
          <Link 
            to={dashboardLink} 
            className="nav-register-btn nav-user-btn"
            title={`${currentUser.name || 'Member'} (${currentUser.role || 'member'})`}
          >
            <span style={{ fontSize: '0.9rem', marginRight: isAr ? 0 : '6px', marginLeft: isAr ? '6px' : 0 }}>👤</span>
            <span>{currentUser.name || (isAr ? 'لوحة التحكم' : 'Dashboard')}</span>
          </Link>
        ) : (
          <Link to="/register" className="nav-register-btn">
            {isAr ? 'التسجيل' : 'Register'}
          </Link>
        )}
        <LanguageToggle />
      </div>
    </nav>
  );
}
