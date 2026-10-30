import { useState, useEffect } from 'react';
import { Outlet, Navigate, Link, useNavigate, useLocation } from 'react-router-dom';
import { LogOut, LayoutDashboard, FileText } from 'lucide-react';
import { apiClient } from '@/lib/api';

export default function MemberLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const token = localStorage.getItem('token');
  const userStr = localStorage.getItem('user');
  
  useEffect(() => {
    document.documentElement.dir = 'ltr';
    document.documentElement.lang = 'en';
  }, []);

  if (!token || !userStr) {
    return <Navigate to="/login" replace />;
  }

  const [currentUser, setCurrentUser] = useState<any>(() => {
    return userStr ? JSON.parse(userStr) : null;
  });

  useEffect(() => {
    apiClient.get('/auth/me').then(res => {
      localStorage.setItem('user', JSON.stringify(res.data));
      setCurrentUser(res.data);
    }).catch(() => {});
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.dispatchEvent(new Event('storage'));
    navigate('/login');
  };

  const isDashboardActive = location.pathname === '/dashboard';
  const isJournalActive = location.pathname.startsWith('/dashboard/journal');
  const isVerified = currentUser?.role === 'verified' || currentUser?.role === 'admin' || currentUser?.role === 'organizer';

  return (
    <div className="admin-layout-container">
      {/* Sidebar (Reusing admin styles) */}
      <aside className="admin-sidebar">
        <div className="admin-sidebar-header">
          <Link to="/" className="admin-sidebar-brand font-display text-xl">
            JPR Club Member
          </Link>
        </div>
        
        <nav className="admin-sidebar-nav">
          <Link 
            to="/dashboard" 
            className={`admin-nav-item ${isDashboardActive ? 'active' : ''}`}
          >
            <LayoutDashboard style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Dashboard</span>
          </Link>
          {isVerified && (
            <Link 
              to="/dashboard/journal/new" 
              className={`admin-nav-item ${isJournalActive ? 'active' : ''}`}
            >
              <FileText style={{ width: '20px', height: '20px', flexShrink: 0 }} />
              <span>Submit Journal</span>
            </Link>
          )}
        </nav>
        
        <div className="admin-sidebar-footer">
          <button 
            onClick={handleLogout}
            className="admin-logout-btn"
          >
            <LogOut style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Logout</span>
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="admin-main-content">
        <div className="admin-page-container">
          <Outlet />
        </div>
      </main>
    </div>
  );
}
