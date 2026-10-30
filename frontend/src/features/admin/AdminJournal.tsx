import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { apiClient } from '@/lib/api';
import { FileText, CheckCircle, XCircle, Plus, Edit2, ExternalLink, Trash2, Send } from 'lucide-react';
import ArticleRenderer from '@/components/editor/ArticleRenderer';

interface JournalSubmission {
  id: string;
  title: string;
  title_ar?: string;
  content: string;
  content_ar?: string;
  content_language?: 'en' | 'ar';
  cover_image_url?: string | null;
  status: 'draft' | 'pending' | 'approved' | 'rejected';
  created_at: string;
  author_id: string;
  author_name?: string;
}

export default function AdminJournal() {
  const [submissions, setSubmissions] = useState<JournalSubmission[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<'all' | 'pending' | 'draft' | 'approved' | 'rejected'>('all');
  const [allSubmissions, setAllSubmissions] = useState<JournalSubmission[]>([]);

  const fetchSubmissions = async () => {
    setLoading(true);
    try {
      // Fetch all submissions to compute accurate tab counts
      const resAll = await apiClient.get('/journal?status=all&limit=100');
      const items: JournalSubmission[] = resAll.data.items || [];
      setAllSubmissions(items);

      if (filter === 'all') {
        setSubmissions(items);
      } else {
        setSubmissions(items.filter(s => s.status === filter));
      }
    } catch (error) {
      console.error('Failed to fetch journal submissions:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSubmissions();
  }, [filter]);

  const handleAction = async (id: string, action: 'approve' | 'reject') => {
    try {
      await apiClient.post(`/journal/${id}/${action}`);
      fetchSubmissions();
    } catch (error) {
      console.error(`Failed to ${action} journal:`, error);
      alert(`Failed to ${action} journal entry.`);
    }
  };

  const handleDelete = async (id: string, title: string) => {
    if (!confirm(`Are you sure you want to permanently delete "${title}"?`)) return;
    try {
      await apiClient.delete(`/journal/${id}`);
      fetchSubmissions();
    } catch (error) {
      console.error('Failed to delete journal entry:', error);
      alert('Failed to delete journal entry.');
    }
  };

  const pendingCount = allSubmissions.filter(s => s.status === 'pending').length;
  const draftCount = allSubmissions.filter(s => s.status === 'draft').length;
  const approvedCount = allSubmissions.filter(s => s.status === 'approved').length;
  const rejectedCount = allSubmissions.filter(s => s.status === 'rejected').length;

  return (
    <div>
      <div className="admin-dashboard-header">
        <div className="admin-dashboard-title-group">
          <h1>Journal Management</h1>
          <p>Review member submissions, write drafts, and publish journal articles</p>
        </div>
        <Link to="/admin/journal/new" className="admin-btn-schedule">
          <Plus style={{ width: '16px', height: '16px' }} />
          <span>New Journal Entry</span>
        </Link>
      </div>

      <div className="admin-list-card">
        {/* Filter Tabs */}
        <div className="admin-filter-tabs">
          <button
            onClick={() => setFilter('all')}
            className={`admin-filter-tab ${filter === 'all' ? 'active' : ''}`}
          >
            All ({allSubmissions.length})
          </button>
          <button
            onClick={() => setFilter('pending')}
            className={`admin-filter-tab ${filter === 'pending' ? 'active' : ''}`}
          >
            Pending Review ({pendingCount})
          </button>
          <button
            onClick={() => setFilter('draft')}
            className={`admin-filter-tab ${filter === 'draft' ? 'active' : ''}`}
          >
            Drafts ({draftCount})
          </button>
          <button
            onClick={() => setFilter('approved')}
            className={`admin-filter-tab ${filter === 'approved' ? 'active' : ''}`}
          >
            Approved ({approvedCount})
          </button>
          <button
            onClick={() => setFilter('rejected')}
            className={`admin-filter-tab ${filter === 'rejected' ? 'active' : ''}`}
          >
            Rejected ({rejectedCount})
          </button>
        </div>

        {loading ? (
          <div style={{ padding: '48px', textAlign: 'center', color: '#6b7280' }}>
            Loading journal entries...
          </div>
        ) : submissions.length === 0 ? (
          <div style={{ padding: '48px', textAlign: 'center', color: '#6b7280' }}>
            <FileText style={{ width: '40px', height: '40px', color: '#d1d5db', margin: '0 auto 12px' }} />
            <div style={{ fontWeight: 600, color: '#374151', fontSize: '15px' }}>
              No {filter === 'all' ? '' : filter} journal entries found
            </div>
            <div style={{ fontSize: '13px', color: '#9ca3af', marginTop: '4px' }}>
              {filter === 'draft'
                ? 'When you save an article as a draft, it will be kept safely here.'
                : 'Entries will appear here as they are authored or submitted for review.'}
            </div>
          </div>
        ) : (
          <div>
            {submissions.map((sub) => {
              const isArabic = sub.content_language === 'ar';
              return (
                <div key={sub.id} className="admin-session-row" style={{ alignItems: 'flex-start' }}>
                  <div className="admin-session-main">
                    <div className="admin-session-status-icon">
                      <FileText style={{ width: '18px', height: '18px', color: '#9ca3af' }} />
                    </div>
                    <div className="admin-session-content">
                      <div className="admin-session-title-line">
                        <h3 className="admin-session-title" dir="auto">{sub.title}</h3>
                        <span className={`admin-status-badge admin-status-${sub.status}`}>
                          {sub.status.toUpperCase()}
                        </span>
                        {sub.content_language && (
                          <span style={{ fontSize: '11px', fontWeight: 600, color: '#6b7280', backgroundColor: '#f3f4f6', padding: '1px 8px', borderRadius: '4px' }}>
                            {sub.content_language.toUpperCase()}
                          </span>
                        )}
                      </div>

                      {sub.title_ar && <p dir="rtl" className="text-gray-600 font-arabic mb-2">{sub.title_ar}</p>}

                      <div className="admin-session-meta" style={{ marginBottom: '12px' }}>
                        <span>
                          By <strong>{sub.author_name || 'Admin'}</strong>
                        </span>
                        <span>•</span>
                        <span>{new Date(sub.created_at).toLocaleDateString(undefined, {
                          year: 'numeric',
                          month: 'short',
                          day: 'numeric'
                        })}</span>
                      </div>

                      {/* Snippet Preview */}
                      <div
                        style={{
                          backgroundColor: '#f9fafb',
                          border: '1px solid #f3f4f6',
                          borderRadius: '8px',
                          padding: '12px 16px',
                          maxHeight: '180px',
                          overflowY: 'auto',
                          marginBottom: '12px'
                        }}
                      >
                        <ArticleRenderer
                          content={sub.content}
                          dir={isArabic ? 'rtl' : 'auto'}
                        />
                      </div>

                      {sub.content_ar && (
                        <div
                          dir="rtl"
                          style={{
                            backgroundColor: '#f9fafb',
                            border: '1px solid #f3f4f6',
                            borderRadius: '8px',
                            padding: '12px 16px',
                            maxHeight: '180px',
                            overflowY: 'auto',
                            marginBottom: '12px'
                          }}
                        >
                          <ArticleRenderer content={sub.content_ar} dir="rtl" />
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Harmonized Action Buttons */}
                  <div className="admin-row-actions" style={{ flexWrap: 'wrap', gap: '8px', alignSelf: 'flex-start' }}>
                    <Link
                      to={`/admin/journal/${sub.id}/edit`}
                      className="admin-action-btn"
                      title="Edit in Visual Composer"
                    >
                      <Edit2 style={{ width: '14px', height: '14px' }} />
                      <span>Edit</span>
                    </Link>

                    {sub.status === 'pending' && (
                      <>
                        <button
                          type="button"
                          onClick={() => handleAction(sub.id, 'approve')}
                          className="admin-action-btn-green"
                          title="Approve and Publish to Journal"
                        >
                          <CheckCircle style={{ width: '14px', height: '14px' }} />
                          <span>Approve</span>
                        </button>
                        <button
                          type="button"
                          onClick={() => handleAction(sub.id, 'reject')}
                          className="admin-action-btn-danger"
                          title="Reject Submission"
                        >
                          <XCircle style={{ width: '14px', height: '14px' }} />
                          <span>Reject</span>
                        </button>
                      </>
                    )}

                    {sub.status === 'draft' && (
                      <>
                        <button
                          type="button"
                          onClick={() => handleAction(sub.id, 'approve')}
                          className="admin-action-btn-green"
                          title="Publish Draft to Journal"
                        >
                          <Send style={{ width: '14px', height: '14px' }} />
                          <span>Publish</span>
                        </button>
                        <button
                          type="button"
                          onClick={() => handleDelete(sub.id, sub.title)}
                          className="admin-icon-btn-danger"
                          title="Delete Draft"
                          aria-label="Delete Draft"
                        >
                          <Trash2 style={{ width: '15px', height: '15px' }} />
                        </button>
                      </>
                    )}

                    {sub.status === 'approved' && (
                      <Link
                        to={`/journal/${sub.id}`}
                        target="_blank"
                        rel="noreferrer"
                        className="admin-action-btn"
                        title="View Public Journal Article"
                      >
                        <ExternalLink style={{ width: '14px', height: '14px' }} />
                        <span>View</span>
                      </Link>
                    )}

                    {sub.status === 'rejected' && (
                      <button
                        type="button"
                        onClick={() => handleDelete(sub.id, sub.title)}
                        className="admin-icon-btn-danger"
                        title="Delete Rejected Entry"
                        aria-label="Delete Rejected Entry"
                      >
                        <Trash2 style={{ width: '15px', height: '15px' }} />
                      </button>
                    )}
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
