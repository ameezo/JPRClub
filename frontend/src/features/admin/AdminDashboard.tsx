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
  Calendar
} from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import Button from '@/components/ui/Button';

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
    if (!confirm(`Mark "${session.title}" as completed?`)) return;
    
    try {
      await apiClient.post(`/sessions/${session.id}/complete`);
      const wantsToDocument = confirm(
        'Session marked as completed! 🎉\n\nWould you like to document the Reading Studio notes, summary, and upload photos now?'
      );
      if (wantsToDocument) {
        navigate(`/admin/sessions/${session.id}/edit`);
      } else {
        fetchSessions();
      }
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

  const getStatusIcon = (status: string) => {
    switch(status) {
      case 'published': return <CheckCircle2 className="w-5 h-5 text-green-500" />;
      case 'draft': return <FileText className="w-5 h-5 text-gray-400" />;
      case 'cancelled': return <XCircle className="w-5 h-5 text-red-500" />;
      case 'completed': return <CheckCheck className="w-5 h-5 text-blue-500" />;
      default: return null;
    }
  };

  const filteredSessions = sessions.filter(s => {
    if (filter === 'all') return true;
    return s.status === filter;
  });

  const completedWithoutStudio = sessions.filter(
    s => s.status === 'completed' && (!s.studio_content && (!s.gallery_images || s.gallery_images.length === 0))
  );

  return (
    <div className="p-4 sm:p-8 max-w-7xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-display font-bold text-gray-900">Admin Dashboard</h1>
          <p className="text-sm text-gray-500 mt-1">
            Schedule reading sessions, document discussions, and upload gallery photos
          </p>
        </div>
        
        <Button as={Link} to="/admin/sessions/new" className="flex items-center gap-2 w-full sm:w-auto justify-center shadow-md">
          <Plus className="w-4 h-4" />
          Schedule New Session
        </Button>
      </div>

      {/* Post-Session Action Callout if there are completed sessions missing documentation */}
      {completedWithoutStudio.length > 0 && (
        <div className="bg-amber-50 border border-amber-200 rounded-2xl p-4 sm:p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center flex-shrink-0">
              <Camera className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-semibold text-amber-900 text-sm sm:text-base">
                {completedWithoutStudio.length} Completed {completedWithoutStudio.length === 1 ? 'Session Needs' : 'Sessions Need'} Studio Documentation
              </h3>
              <p className="text-xs sm:text-sm text-amber-700 mt-0.5">
                The session ended! Add summary points, vocabulary, and drag & drop photos from the event.
              </p>
            </div>
          </div>
          <Link
            to={`/admin/sessions/${completedWithoutStudio[0].id}/edit`}
            className="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white text-xs sm:text-sm font-semibold rounded-xl shadow-sm transition-colors whitespace-nowrap"
          >
            Document "{completedWithoutStudio[0].title.slice(0, 20)}..."
          </Link>
        </div>
      )}

      {/* Main Content Card */}
      <div className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
        {/* Filter Tabs */}
        <div className="px-6 py-4 border-b border-gray-200 bg-gray-50 flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-2 text-xs sm:text-sm font-medium overflow-x-auto pb-1 sm:pb-0">
            <button
              onClick={() => setFilter('all')}
              className={`px-3 py-1.5 rounded-lg transition-colors ${
                filter === 'all' ? 'bg-primary text-white font-semibold' : 'text-gray-600 hover:bg-gray-200'
              }`}
            >
              All ({sessions.length})
            </button>
            <button
              onClick={() => setFilter('published')}
              className={`px-3 py-1.5 rounded-lg transition-colors ${
                filter === 'published' ? 'bg-primary text-white font-semibold' : 'text-gray-600 hover:bg-gray-200'
              }`}
            >
              Upcoming ({sessions.filter(s => s.status === 'published').length})
            </button>
            <button
              onClick={() => setFilter('completed')}
              className={`px-3 py-1.5 rounded-lg transition-colors ${
                filter === 'completed' ? 'bg-primary text-white font-semibold' : 'text-gray-600 hover:bg-gray-200'
              }`}
            >
              Completed / Studio ({sessions.filter(s => s.status === 'completed').length})
            </button>
            <button
              onClick={() => setFilter('draft')}
              className={`px-3 py-1.5 rounded-lg transition-colors ${
                filter === 'draft' ? 'bg-primary text-white font-semibold' : 'text-gray-600 hover:bg-gray-200'
              }`}
            >
              Drafts ({sessions.filter(s => s.status === 'draft').length})
            </button>
          </div>
        </div>
        
        {loading ? (
          <div className="p-12 text-center text-gray-500 font-medium">Loading sessions...</div>
        ) : filteredSessions.length === 0 ? (
          <div className="p-12 text-center text-gray-500">
            <Calendar className="w-10 h-10 text-gray-300 mx-auto mb-3" />
            <p className="font-semibold text-gray-700">No sessions match this filter</p>
            <p className="text-xs text-gray-400 mt-1">Try selecting a different filter or create a new session.</p>
          </div>
        ) : (
          <div className="divide-y divide-gray-100">
            {filteredSessions.map(session => {
              const hasStudioContent = !!session.studio_content;
              const hasGallery = !!(session.gallery_images && session.gallery_images.length > 0);
              const isDocumented = hasStudioContent || hasGallery;

              return (
                <div 
                  key={session.id} 
                  className="p-4 sm:p-6 flex flex-col md:flex-row md:items-center justify-between gap-4 hover:bg-gray-50 transition-colors"
                >
                  <div className="flex items-start gap-3.5">
                    <div className="mt-1 flex-shrink-0">{getStatusIcon(session.status)}</div>
                    <div>
                      <div className="flex flex-wrap items-center gap-2 mb-1">
                        <h3 className="font-bold text-gray-900 text-base sm:text-lg">{session.title}</h3>
                        <span className={`px-2.5 py-0.5 rounded-full text-xs font-semibold uppercase tracking-wider ${
                          session.status === 'published' ? 'bg-green-100 text-green-700' :
                          session.status === 'completed' ? 'bg-blue-100 text-blue-700' :
                          session.status === 'cancelled' ? 'bg-red-100 text-red-700' :
                          'bg-gray-200 text-gray-700'
                        }`}>
                          {session.status}
                        </span>

                        {/* Studio Documentation Indicator */}
                        {session.status === 'completed' && (
                          isDocumented ? (
                            <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800">
                              <Sparkles className="w-3 h-3" /> Studio Documented
                            </span>
                          ) : (
                            <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                              <BookOpen className="w-3 h-3" /> Notes Pending
                            </span>
                          )
                        )}
                      </div>

                      <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs sm:text-sm text-gray-500">
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
                      </div>
                    </div>
                  </div>
                  
                  {/* Actions Bar */}
                  <div className="flex items-center flex-wrap gap-2 self-end md:self-center">
                    {/* Public Links */}
                    {session.status === 'completed' && (
                      <Link
                        to={`/studio/${session.id}`}
                        target="_blank"
                        rel="noreferrer"
                        className="px-3 py-1.5 text-xs text-gray-600 hover:text-gray-900 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors flex items-center gap-1"
                        title="View on Public Studio Page"
                      >
                        <ExternalLink className="w-3.5 h-3.5" />
                        <span>View Studio</span>
                      </Link>
                    )}

                    {session.status === 'published' && (
                      <Link
                        to={`/sessions`}
                        target="_blank"
                        rel="noreferrer"
                        className="px-3 py-1.5 text-xs text-gray-600 hover:text-gray-900 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors flex items-center gap-1"
                        title="View Public Sessions"
                      >
                        <ExternalLink className="w-3.5 h-3.5" />
                        <span>Public Page</span>
                      </Link>
                    )}

                    {/* Published Session Actions */}
                    {session.status === 'published' && (
                      <>
                        <button
                          onClick={() => handleCompleteSession(session)}
                          className="px-3 py-1.5 bg-green-50 text-green-700 hover:bg-green-100 rounded-lg transition-colors text-xs font-semibold flex items-center gap-1.5"
                          title="Mark this session as finished and document it"
                        >
                          <CheckCircle2 className="w-4 h-4 text-green-600" />
                          <span>Complete & Document</span>
                        </button>
                        <button
                          onClick={() => handleCancelSession(session)}
                          className="p-1.5 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                          title="Cancel Session"
                        >
                          <XCircle className="w-4 h-4" />
                        </button>
                      </>
                    )}

                    {/* Completed Session Quick Action */}
                    {session.status === 'completed' && !isDocumented && (
                      <Link
                        to={`/admin/sessions/${session.id}/edit`}
                        className="px-3 py-1.5 bg-primary text-white hover:bg-primary-dark rounded-lg transition-colors text-xs font-semibold flex items-center gap-1.5 shadow-sm"
                      >
                        <Camera className="w-3.5 h-3.5" />
                        <span>Add Studio Notes</span>
                      </Link>
                    )}

                    {/* Standard Edit */}
                    <Link 
                      to={`/admin/sessions/${session.id}/edit`}
                      className="px-3 py-1.5 text-gray-700 hover:text-primary hover:bg-primary/10 rounded-lg transition-colors text-xs font-medium flex items-center gap-1 border border-gray-200"
                      title="Edit Session"
                    >
                      <Edit2 className="w-3.5 h-3.5" />
                      <span>{session.status === 'completed' ? 'Edit Studio' : 'Edit'}</span>
                    </Link>
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

