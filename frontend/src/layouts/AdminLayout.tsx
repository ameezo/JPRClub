import { useEffect } from 'react';
import { Outlet, Navigate, Link, useNavigate, useLocation } from 'react-router-dom';
import { LogOut, LayoutDashboard, Calendar, FileText, Users, Activity, UserPlus, BarChart3, BookMarked } from 'lucide-react';

export default function AdminLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const token = localStorage.getItem('token');

  useEffect(() => {
    document.documentElement.dir = 'ltr';
    document.documentElement.lang = 'en';
  }, []);

  let user: any = null;
  try {
    const raw = localStorage.getItem('user');
    user = raw ? JSON.parse(raw) : null;
  } catch {
    user = null;
  }

  if (!token || (user && user.role !== 'admin' && user.role !== 'organizer')) {
    return <Navigate to="/admin/login" replace />;
  }

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/admin/login');
  };

  const isDashboardActive = location.pathname === '/admin';
  const isSessionsActive = location.pathname.startsWith('/admin/sessions');
  const isInterestsActive = location.pathname.startsWith('/admin/interests');

  return (
    <div className="admin-layout-container">
      {/* Sidebar */}
      <aside className="admin-sidebar">
        <div className="admin-sidebar-header">
          <Link to="/" className="admin-sidebar-brand font-display">
            JPR Club Admin
          </Link>
        </div>
        
        <nav className="admin-sidebar-nav">
          <Link 
            to="/admin" 
            className={`admin-nav-item ${isDashboardActive ? 'active' : ''}`}
          >
            <LayoutDashboard style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Dashboard</span>
          </Link>
          <Link 
            to="/admin/sessions/new" 
            className={`admin-nav-item ${isSessionsActive ? 'active' : ''}`}
          >
            <Calendar style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Sessions</span>
          </Link>
          <Link 
            to="/admin/interests" 
            className={`admin-nav-item ${isInterestsActive ? 'active' : ''}`}
          >
            <UserPlus style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Join Requests</span>
          </Link>
          <Link 
            to="/admin/journal" 
            className={`admin-nav-item ${location.pathname.startsWith('/admin/journal') ? 'active' : ''}`}
          >
            <FileText style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Journal</span>
          </Link>
          <Link 
            to="/admin/reports" 
            className={`admin-nav-item ${location.pathname.startsWith('/admin/reports') ? 'active' : ''}`}
          >
            <BarChart3 style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Annual Reports</span>
          </Link>
          <Link 
            to="/admin/resources" 
            className={`admin-nav-item ${location.pathname.startsWith('/admin/resources') ? 'active' : ''}`}
          >
            <BookMarked style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Resources</span>
          </Link>
          <Link 
            to="/admin/users" 
            className={`admin-nav-item ${location.pathname.startsWith('/admin/users') ? 'active' : ''}`}
          >
            <Users style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Members</span>
          </Link>
          <Link 
            to="/admin/audit" 
            className={`admin-nav-item ${location.pathname.startsWith('/admin/audit') ? 'active' : ''}`}
          >
            <Activity style={{ width: '20px', height: '20px', flexShrink: 0 }} />
            <span>Audit Logs</span>
          </Link>
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
