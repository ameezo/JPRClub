import { Outlet, Navigate, Link, useNavigate } from 'react-router-dom';
import { LogOut, LayoutDashboard, Calendar } from 'lucide-react';

export default function AdminLayout() {
  const navigate = useNavigate();
  const token = localStorage.getItem('token');

  if (!token) {
    return <Navigate to="/admin/login" replace />;
  }

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/admin/login');
  };

  return (
    <div className="flex h-screen bg-gray-50">
      {/* Sidebar */}
      <aside className="w-64 bg-white border-r border-gray-200 flex flex-col">
        <div className="p-6 border-b border-gray-200">
          <Link to="/" className="text-xl font-bold font-display text-gray-900">
            JPR Club Admin
          </Link>
        </div>
        
        <nav className="flex-1 p-4 space-y-2">
          <Link to="/admin" className="flex items-center gap-3 px-4 py-3 text-gray-700 bg-gray-50 rounded-xl font-medium">
            <LayoutDashboard className="w-5 h-5 text-primary" />
            Dashboard
          </Link>
          <Link to="/admin/sessions" className="flex items-center gap-3 px-4 py-3 text-gray-700 hover:bg-gray-50 rounded-xl font-medium transition-colors">
            <Calendar className="w-5 h-5 text-gray-400" />
            Sessions
          </Link>
        </nav>
        
        <div className="p-4 border-t border-gray-200">
          <button 
            onClick={handleLogout}
            className="flex items-center gap-3 px-4 py-3 w-full text-left text-red-600 hover:bg-red-50 rounded-xl font-medium transition-colors"
          >
            <LogOut className="w-5 h-5" />
            Logout
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        <Outlet />
      </main>
    </div>
  );
}
