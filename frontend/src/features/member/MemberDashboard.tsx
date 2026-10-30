import { useEffect, useState } from 'react';
import { apiClient } from '@/lib/api';
import { FileText, Edit2, AlertCircle } from 'lucide-react';
import { Link } from 'react-router-dom';

interface JournalSubmission {
  id: string;
  title: string;
  status: string;
  created_at: string;
}

export default function MemberDashboard() {
  const [submissions, setSubmissions] = useState<JournalSubmission[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentUser, setCurrentUser] = useState<any>(() => {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  });

  const isVerified = currentUser?.role === 'verified' || currentUser?.role === 'admin' || currentUser?.role === 'organizer';

  useEffect(() => {
    // Refresh user profile in background
    apiClient.get('/auth/me').then(res => {
      localStorage.setItem('user', JSON.stringify(res.data));
      setCurrentUser(res.data);
    }).catch(() => {});
  }, []);

  useEffect(() => {
    if (!isVerified) {
      setLoading(false);
      return;
    }
    const fetchSubmissions = async () => {
      try {
        const response = await apiClient.get('/journal');
        setSubmissions(response.data.items || []);
      } catch (error) {
        console.error('Failed to fetch journal submissions:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchSubmissions();
  }, [isVerified]);

  return (
    <div>
      <div className="admin-dashboard-header">
        <div className="admin-dashboard-title-group">
          <h1>Welcome, {currentUser?.name || 'Member'}</h1>
          <p>Manage your journal submissions</p>
        </div>
        {isVerified && (
          <Link to="/dashboard/journal/new" className="admin-btn-schedule">
            <span>New Submission</span>
          </Link>
        )}
      </div>

      {!isVerified && (
        <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
          <div className="flex">
            <div className="flex-shrink-0">
              <AlertCircle className="h-5 w-5 text-yellow-400" />
            </div>
            <div className="ml-3">
              <p className="text-sm text-yellow-700">
                Your account is pending verification by an admin. You will be able to submit journal entries once verified.
              </p>
            </div>
          </div>
        </div>
      )}

      {isVerified && (
        <div className="admin-list-card">
          <div className="p-4 border-b border-gray-100 font-semibold text-gray-700">
            My Submissions
          </div>
          {loading ? (
            <div className="p-8 text-center text-gray-500">Loading...</div>
          ) : submissions.length === 0 ? (
            <div className="p-8 text-center text-gray-500">
              You haven't submitted any journal entries yet.
            </div>
          ) : (
            <div>
              {submissions.map((sub) => (
                <div key={sub.id} className="admin-session-row">
                  <div className="admin-session-main">
                    <div className="admin-session-status-icon">
                      <FileText style={{ width: '18px', height: '18px', color: '#9ca3af' }} />
                    </div>
                    <div className="admin-session-content">
                      <div className="admin-session-title-line">
                        <h3 className="admin-session-title">{sub.title}</h3>
                        <span className={`admin-status-badge admin-status-${sub.status}`}>
                          {sub.status}
                        </span>
                      </div>
                      <div className="admin-session-meta">
                        <span>Submitted on {new Date(sub.created_at).toLocaleDateString()}</span>
                      </div>
                    </div>
                  </div>
                  <div className="admin-row-actions">
                    <Link to={`/dashboard/journal/${sub.id}/edit`} className="admin-action-btn">
                      <Edit2 style={{ width: '14px', height: '14px' }} />
                      <span>Edit</span>
                    </Link>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
