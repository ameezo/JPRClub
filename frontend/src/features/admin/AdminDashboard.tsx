import { useEffect, useState } from 'react';
import { apiClient, type Session } from '@/lib/api';
import { 
  Plus, 
  Edit2, 
  CheckCircle2, 
  XCircle, 
  FileText, 
  CheckCheck, 
  BookOpen, 
  ExternalLink,
  Sparkles,
  Camera,
  Calendar,
  Trash2,
  RotateCcw,
  Users
} from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';

export default function AdminDashboard() {
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<'all' | 'published' | 'completed' | 'draft'>('all');
  const navigate = useNavigate();

  const fetchSessions = async () => {
    setLoading(true);
    try {
      const response = await apiClient.get('/sessions?status=all');
      setSessions(response.data.items);
    } catch (error) {
      console.error('Failed to fetch sessions:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSessions();
  }, []);

  const handleCompleteSession = async (session: Session) => {
    if (!confirm(`Mark "${session.title}" as completed and open Studio documenter?`)) return;
    
    try {
      await apiClient.post(`/sessions/${session.id}/complete-and-document`);
      navigate(`/admin/sessions/${session.id}/document`);
    } catch (err) {
      alert('Failed to complete session');
    }
  };

  const handleCancelSession = async (session: Session) => {
    if (!confirm(`Cancel "${session.title}"?`)) return;
    try {
      await apiClient.post(`/sessions/${session.id}/cancel`);
      fetchSessions();
    } catch (err) {
      alert('Failed to cancel session');
    }
  };

  const handleDeleteSession = async (session: Session) => {
    if (!confirm(`Are you sure you want to permanently delete session "${session.title}"? This cannot be undone.`)) return;
    try {
      await apiClient.delete(`/sessions/${session.id}`);
      fetchSessions();
    } catch (err) {
      console.error('Delete session error:', err);
      alert('Failed to delete session.');
    }
  };

  const handleUnpublishStudio = async (session: Session) => {
    if (!confirm(`Unpublish Studio documentation for "${session.title}" back to draft? It will be removed from the public Reading Studio.`)) return;
    try {
      await apiClient.post(`/sessions/${session.id}/unpublish-studio`);
      fetchSessions();
    } catch (err) {
      console.error('Unpublish error:', err);
      alert('Failed to unpublish studio documentation.');
    }
  };

  const getStatusIcon = (status: string) => {
    switch(status) {
      case 'published': return <CheckCircle2 style={{ width: '18px', height: '18px', color: '#16a34a' }} />;
      case 'draft': return <FileText style={{ width: '18px', height: '18px', color: '#9ca3af' }} />;
      case 'cancelled': return <XCircle style={{ width: '18px', height: '18px', color: '#dc2626' }} />;
      case 'completed': return <CheckCheck style={{ width: '18px', height: '18px', color: '#2563eb' }} />;
      default: return null;
    }
  };

  const upcomingSessions = sessions.filter(s => s.status === 'published');
  const studioPublishedSessions = sessions.filter(s => s.status === 'completed' && s.documentation_status === 'published');
  const draftSessions = sessions.filter(s => s.status === 'draft' || s.documentation_status === 'draft');

  const filteredSessions = sessions.filter(s => {
    if (filter === 'all') return true;
    if (filter === 'published') return s.status === 'published';
    if (filter === 'completed') return s.status === 'completed' && s.documentation_status === 'published';
    if (filter === 'draft') return s.status === 'draft' || s.documentation_status === 'draft';
    return true;
  });

  const completedWithoutStudio = sessions.filter(
    s => s.status === 'completed' && s.documentation_status !== 'published'
  );

  return (
    <div>
      {/* Header */}
      <div className="admin-dashboard-header">
        <div className="admin-dashboard-title-group">
          <h1>Admin Dashboard</h1>
          <p>Schedule reading sessions, document discussions, and upload gallery photos</p>
        </div>
        
        <Link to="/admin/sessions/new" className="admin-btn-schedule">
          <Plus style={{ width: '16px', height: '16px' }} />
          <span>Schedule New Session</span>
        </Link>
      </div>

      {/* Post-Session Action Callout */}
      {completedWithoutStudio.length > 0 && (
        <div className="admin-info-box" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '16px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <Camera style={{ width: '22px', height: '22px', color: '#b45309', flexShrink: 0 }} />
            <div>
              <div style={{ fontWeight: 600, fontSize: '14px', color: '#92400e' }}>
                {completedWithoutStudio.length} Completed {completedWithoutStudio.length === 1 ? 'Session Needs' : 'Sessions Need'} Studio Documentation
              </div>
              <div style={{ fontSize: '13px', color: '#92400e', marginTop: '2px' }}>
                The session ended! Add summary points, vocabulary, and drag & drop photos from the event.
              </div>
            </div>
          </div>
          <Link
            to={`/admin/sessions/${completedWithoutStudio[0].id}/document`}
            className="admin-action-btn"
            style={{ backgroundColor: '#fef3c7', borderColor: '#fcd34d', color: '#92400e', fontWeight: 600 }}
          >
            Document "{completedWithoutStudio[0].title.slice(0, 20)}..."
          </Link>
        </div>
      )}

      {/* Main Content Card */}
      <div className="admin-list-card">
        {/* Filter Tabs */}
        <div className="admin-filter-tabs">
          <button
            onClick={() => setFilter('all')}
            className={`admin-filter-tab ${filter === 'all' ? 'active' : ''}`}
          >
            All ({sessions.length})
          </button>
          <button
            onClick={() => setFilter('published')}
            className={`admin-filter-tab ${filter === 'published' ? 'active' : ''}`}
          >
            Upcoming ({upcomingSessions.length})
          </button>
          <button
            onClick={() => setFilter('completed')}
            className={`admin-filter-tab ${filter === 'completed' ? 'active' : ''}`}
          >
            Completed / Studio ({studioPublishedSessions.length})
          </button>
          <button
            onClick={() => setFilter('draft')}
            className={`admin-filter-tab ${filter === 'draft' ? 'active' : ''}`}
          >
            Drafts ({draftSessions.length})
          </button>
        </div>
        
        {loading ? (
          <div style={{ padding: '48px', textAlign: 'center', color: '#6b7280', fontWeight: 500 }}>
            Loading sessions...
          </div>
        ) : filteredSessions.length === 0 ? (
          <div style={{ padding: '48px', textAlign: 'center', color: '#6b7280' }}>
            <Calendar style={{ width: '40px', height: '40px', color: '#d1d5db', margin: '0 auto 12px' }} />
            <div style={{ fontWeight: 600, color: '#374151', fontSize: '15px' }}>No sessions match this filter</div>
            <div style={{ fontSize: '13px', color: '#9ca3af', marginTop: '4px' }}>Try selecting a different filter or create a new session.</div>
          </div>
        ) : (
          <div>
            {filteredSessions.map(session => {
              const isPublishedDoc = session.documentation_status === 'published';
              const isDraftDoc = session.documentation_status === 'draft';

              return (
                <div key={session.id} className="admin-session-row">
                  <div className="admin-session-main">
                    <div className="admin-session-status-icon">
                      {getStatusIcon(session.status)}
                    </div>
                    <div className="admin-session-content">
                      <div className="admin-session-title-line">
                        <h3 className="admin-session-title">{session.title}</h3>
                        <span className={`admin-status-badge admin-status-${session.status}`}>
                          {session.status}
                        </span>

                        {session.status === 'completed' && (
                          isPublishedDoc ? (
                            <span className="admin-studio-badge">
                              <Sparkles style={{ width: '12px', height: '12px' }} /> Studio Published
                            </span>
                          ) : isDraftDoc ? (
                            <span className="admin-studio-badge-pending" style={{ backgroundColor: '#fef3c7', color: '#92400e' }}>
                              <BookOpen style={{ width: '12px', height: '12px' }} /> Doc Draft
                            </span>
                          ) : (
                            <span className="admin-studio-badge-pending">
                              <BookOpen style={{ width: '12px', height: '12px' }} /> Needs Doc
                            </span>
                          )
                        )}
                      </div>

                      <div className="admin-session-meta">
                        <span>{new Date(session.scheduled_at).toLocaleDateString(undefined, {
                          weekday: 'short',
                          year: 'numeric',
                          month: 'short',
                          day: 'numeric'
                        })}</span>
                        <span>•</span>
                        <span>{session.material_type}</span>
                        {session.chapters && (
                          <>
                            <span>•</span>
                            <span>{session.chapters}</span>
                          </>
                        )}
                        {session.exclude_from_reports && (
                          <>
                            <span>•</span>
                            <span style={{ color: '#b45309', backgroundColor: '#fef3c7', padding: '1px 6px', borderRadius: '4px', fontSize: '11px', fontWeight: 600 }}>
                              Excluded from Reports
                            </span>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  {/* Actions Bar */}
                  <div className="admin-row-actions">
                    {session.status === 'completed' && (
                      <>
                        <Link
                          to={`/admin/sessions/${session.id}/document`}
                          className="admin-action-btn-green"
                          title="Document or edit Studio notes"
                        >
                          <FileText style={{ width: '14px', height: '14px' }} />
                          <span>{session.documentation_status === 'published' ? 'Edit Studio Doc' : 'Document Studio'}</span>
                        </Link>
                        <Link
                          to={`/admin/sessions/${session.id}/document?tab=metrics`}
                          className="admin-action-btn"
                          title="Record Attendance & Feedback metrics"
                        >
                          <Users style={{ width: '14px', height: '14px', color: '#0284c7' }} />
                          <span>Attendance & Feedback</span>
                        </Link>
                        {session.documentation_status === 'published' && (
                          <>
                            <Link
                              to={`/studio/${session.id}`}
                              target="_blank"
                              rel="noreferrer"
                              className="admin-action-btn"
                              title="View on Public Studio Page"
                            >
                              <ExternalLink style={{ width: '14px', height: '14px' }} />
                              <span>View Studio</span>
                            </Link>
                            <button
                              onClick={() => handleUnpublishStudio(session)}
                              className="admin-action-btn"
                              title="Unpublish from Reading Studio back to draft"
                            >
                              <RotateCcw style={{ width: '14px', height: '14px' }} />
                              <span>Unpublish</span>
                            </button>
                          </>
                        )}
                      </>
                    )}

                    <Link 
                      to={`/admin/sessions/${session.id}/edit`}
                      className="admin-action-btn"
                      title="Edit Session Schedule / Details"
                    >
                      <Edit2 style={{ width: '14px', height: '14px' }} />
                      <span>Edit Details</span>
                    </Link>

                    {session.status === 'published' && (
                      <>
                        <Link
                          to={`/sessions`}
                          target="_blank"
                          rel="noreferrer"
                          className="admin-action-btn"
                          title="View Public Sessions"
                        >
                          <ExternalLink style={{ width: '14px', height: '14px' }} />
                          <span>Public Page</span>
                        </Link>
                        <button
                          onClick={() => handleCompleteSession(session)}
                          className="admin-action-btn-green"
                          title="Mark this session as finished and document it"
                        >
                          <CheckCircle2 style={{ width: '15px', height: '15px' }} />
                          <span>Complete & Document</span>
                        </button>
                        <button
                          onClick={() => handleCancelSession(session)}
                          className="admin-icon-btn-danger"
                          title="Cancel Session"
                          aria-label="Cancel Session"
                        >
                          <XCircle style={{ width: '16px', height: '16px' }} />
                        </button>
                      </>
                    )}

                    {/* Delete Session Button (Always available for admin) */}
                    <button
                      onClick={() => handleDeleteSession(session)}
                      className="admin-icon-btn-danger"
                      title="Delete Session"
                      aria-label="Delete Session"
                    >
                      <Trash2 style={{ width: '16px', height: '16px' }} />
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
