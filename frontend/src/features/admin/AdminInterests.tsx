import { useEffect, useState } from 'react';
import { 
  HandHeart, 
  Users, 
  Lightbulb, 
  MessageCircle, 
  Phone, 
  Mail, 
  Trash2, 
  Calendar, 
  Search, 
  Filter, 
  RefreshCw 
} from 'lucide-react';
import { apiClient, type SessionInterest } from '@/lib/api';

export default function AdminInterests() {
  const [allInterests, setAllInterests] = useState<SessionInterest[]>([]);
  const [loading, setLoading] = useState(true);
  const [typeFilter, setTypeFilter] = useState<string>('all');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedInterest, setSelectedInterest] = useState<SessionInterest | null>(null);

  const fetchInterests = async () => {
    setLoading(true);
    try {
      const res = await apiClient.get('/session-interests?limit=100');
      const items: SessionInterest[] = res.data.items || [];
      setAllInterests(items);
    } catch (error) {
      console.error('Failed to fetch session interests:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInterests();
  }, []);

  // Filter items in memory
  const filteredInterests = allInterests.filter((item) => {
    if (typeFilter !== 'all' && item.type !== typeFilter) return false;
    if (statusFilter !== 'all' && item.status !== statusFilter) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchName = item.full_name?.toLowerCase().includes(q);
      const matchEmail = item.email?.toLowerCase().includes(q);
      const matchPhone = item.phone?.toLowerCase().includes(q);
      const matchMsg = item.message?.toLowerCase().includes(q);
      if (!matchName && !matchEmail && !matchPhone && !matchMsg) return false;
    }
    return true;
  });

  const handleStatusChange = async (id: string, newStatus: string) => {
    try {
      await apiClient.patch(`/session-interests/${id}`, { status: newStatus });
      setAllInterests((prev) =>
        prev.map((item) => (item.id === id ? { ...item, status: newStatus } : item))
      );
      if (selectedInterest?.id === id) {
        setSelectedInterest((prev) => (prev ? { ...prev, status: newStatus } : null));
      }
    } catch (err) {
      console.error('Failed to update status:', err);
      alert('Failed to update submission status');
    }
  };

  const handleDelete = async (id: string, name: string) => {
    if (!confirm(`Are you sure you want to delete the submission from "${name}"?`)) return;
    try {
      await apiClient.delete(`/session-interests/${id}`);
      setAllInterests((prev) => prev.filter((item) => item.id !== id));
      if (selectedInterest?.id === id) {
        setSelectedInterest(null);
      }
    } catch (err) {
      console.error('Failed to delete submission:', err);
      alert('Failed to delete submission');
    }
  };

  const getTypeBadge = (type: string) => {
    switch (type) {
      case 'volunteer':
        return (
          <span className="admin-interest-badge badge-volunteer">
            <HandHeart style={{ width: '13px', height: '13px', marginInlineEnd: '4px' }} />
            Volunteer
          </span>
        );
      case 'team':
        return (
          <span className="admin-interest-badge badge-team">
            <Users style={{ width: '13px', height: '13px', marginInlineEnd: '4px' }} />
            Join Team
          </span>
        );
      case 'instructor':
        return (
          <span className="admin-interest-badge badge-instructor">
            <Lightbulb style={{ width: '13px', height: '13px', marginInlineEnd: '4px' }} />
            Instructor
          </span>
        );
      default:
        return (
          <span className="admin-interest-badge badge-attendance">
            <Users style={{ width: '13px', height: '13px', marginInlineEnd: '4px' }} />
            Attendance
          </span>
        );
    }
  };

  // Helper to format clean whatsapp link
  const getWhatsAppLink = (phone: string) => {
    const cleanDigits = phone.replace(/[^\d]/g, '');
    return `https://wa.me/${cleanDigits}`;
  };

  const countTotal = allInterests.length;
  const countNew = allInterests.filter((i) => i.status === 'new').length;
  const countVolunteer = allInterests.filter((i) => i.type === 'volunteer').length;
  const countTeam = allInterests.filter((i) => i.type === 'team').length;
  const countInstructor = allInterests.filter((i) => i.type === 'instructor').length;

  return (
    <div className="admin-interests-page">
      {/* Header */}
      <div className="admin-dashboard-header">
        <div className="admin-dashboard-title-group">
          <h1>Join Requests & Applications</h1>
          <p>Review volunteer submissions, core team applications, and speaker proposals</p>
        </div>
        <div className="admin-header-actions">
          <button 
            type="button" 
            onClick={fetchInterests} 
            className="admin-btn-secondary"
            title="Refresh submissions"
          >
            <RefreshCw style={{ width: '16px', height: '16px' }} />
            <span>Refresh</span>
          </button>
        </div>
      </div>

      {/* Stats Counter Bar */}
      <div className="admin-stats-grid">
        <div className="admin-stat-card">
          <div className="admin-stat-title">Total Submissions</div>
          <div className="admin-stat-value">{countTotal}</div>
        </div>
        <div className="admin-stat-card">
          <div className="admin-stat-title">New / Unread</div>
          <div className="admin-stat-value" style={{ color: '#e88599' }}>{countNew}</div>
        </div>
        <div className="admin-stat-card">
          <div className="admin-stat-title">Volunteers</div>
          <div className="admin-stat-value" style={{ color: '#3b82f6' }}>{countVolunteer}</div>
        </div>
        <div className="admin-stat-card">
          <div className="admin-stat-title">Core Team</div>
          <div className="admin-stat-value" style={{ color: '#a855f7' }}>{countTeam}</div>
        </div>
        <div className="admin-stat-card">
          <div className="admin-stat-title">Instructors</div>
          <div className="admin-stat-value" style={{ color: '#f59e0b' }}>{countInstructor}</div>
        </div>
      </div>

      {/* Filter & Search Bar */}
      <div className="admin-controls-card">
        {/* Type tabs */}
        <div className="admin-filter-tabs">
          {[
            { id: 'all', label: 'All Types', count: countTotal },
            { id: 'volunteer', label: 'Volunteers', count: countVolunteer },
            { id: 'team', label: 'Team', count: countTeam },
            { id: 'instructor', label: 'Instructors', count: countInstructor },
          ].map((tab) => (
            <button
              key={tab.id}
              type="button"
              className={`admin-filter-tab ${typeFilter === tab.id ? 'active' : ''}`}
              onClick={() => setTypeFilter(tab.id)}
            >
              <span>{tab.label}</span>
              <span className="tab-count">{tab.count}</span>
            </button>
          ))}
        </div>

        {/* Sub-filters & Search */}
        <div className="admin-filter-subrow">
          <div className="admin-search-box">
            <Search style={{ width: '16px', height: '16px', color: '#9ca3af' }} />
            <input
              type="text"
              placeholder="Search by name, email, phone, keyword..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>

          <div className="admin-status-filter-group">
            <Filter style={{ width: '15px', height: '15px', color: '#9ca3af' }} />
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="admin-select-filter"
            >
              <option value="all">All Statuses</option>
              <option value="new">New</option>
              <option value="contacted">Contacted</option>
              <option value="reviewed">Reviewed</option>
              <option value="archived">Archived</option>
            </select>
          </div>
        </div>
      </div>

      {/* Submissions List */}
      <div className="admin-list-card">
        {loading ? (
          <div className="admin-empty-state">Loading submissions...</div>
        ) : filteredInterests.length === 0 ? (
          <div className="admin-empty-state">
            No applications match the current filters.
          </div>
        ) : (
          <div className="admin-interests-table-wrapper">
            <table className="admin-interests-table">
              <thead>
                <tr>
                  <th>Applicant</th>
                  <th>Type</th>
                  <th>Contact Info</th>
                  <th>Target Session</th>
                  <th>Message / Idea</th>
                  <th>Submitted</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredInterests.map((item) => (
                  <tr key={item.id} className={`admin-table-row ${item.status === 'new' ? 'row-new' : ''}`}>
                    {/* Applicant */}
                    <td>
                      <div className="applicant-cell">
                        <strong>{item.full_name}</strong>
                      </div>
                    </td>

                    {/* Type */}
                    <td>{getTypeBadge(item.type)}</td>

                    {/* Contact Info with quick actions */}
                    <td>
                      <div className="contact-info-cell">
                        <a href={`mailto:${item.email}`} className="contact-link" title="Send email">
                          <Mail style={{ width: '13px', height: '13px' }} />
                          <span>{item.email}</span>
                        </a>
                        <div className="phone-actions-row">
                          <a href={`tel:${item.phone}`} className="contact-link" title="Call">
                            <Phone style={{ width: '13px', height: '13px' }} />
                            <span>{item.phone}</span>
                          </a>
                          <a
                            href={getWhatsAppLink(item.phone)}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="btn-quick-wa"
                            title="Chat on WhatsApp"
                          >
                            <MessageCircle style={{ width: '13px', height: '13px' }} />
                          </a>
                        </div>
                      </div>
                    </td>

                    {/* Target Session */}
                    <td>
                      {item.session_title ? (
                        <div className="target-session-pill">
                          <Calendar style={{ width: '12px', height: '12px' }} />
                          <span>{item.session_title}</span>
                        </div>
                      ) : (
                        <span className="text-muted-small">General</span>
                      )}
                    </td>

                    {/* Message / Idea */}
                    <td>
                      <div className="message-preview-cell">
                        {item.message ? (
                          <>
                            <p className="message-snippet">{item.message}</p>
                            <button
                              type="button"
                              className="btn-view-full-msg"
                              onClick={() => setSelectedInterest(item)}
                            >
                              View full
                            </button>
                          </>
                        ) : (
                          <span className="text-muted-small">—</span>
                        )}
                      </div>
                    </td>

                    {/* Submitted Date */}
                    <td>
                      <span className="submitted-date">
                        {new Date(item.created_at).toLocaleDateString(undefined, {
                          month: 'short',
                          day: 'numeric',
                          year: 'numeric',
                        })}
                      </span>
                    </td>

                    {/* Status Dropdown */}
                    <td>
                      <select
                        value={item.status}
                        onChange={(e) => handleStatusChange(item.id, e.target.value)}
                        className={`status-select-inline status-${item.status}`}
                      >
                        <option value="new">New</option>
                        <option value="contacted">Contacted</option>
                        <option value="reviewed">Reviewed</option>
                        <option value="archived">Archived</option>
                      </select>
                    </td>

                    {/* Actions */}
                    <td>
                      <div className="table-actions-cell">
                        <button
                          type="button"
                          className="btn-delete-row"
                          onClick={() => handleDelete(item.id, item.full_name)}
                          title="Delete submission"
                        >
                          <Trash2 style={{ width: '15px', height: '15px' }} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Modal for viewing full message */}
      {selectedInterest && (
        <div className="admin-modal-backdrop" onClick={() => setSelectedInterest(null)}>
          <div className="admin-modal-card" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <div className="modal-title-group">
                <h3>{selectedInterest.full_name}</h3>
                {getTypeBadge(selectedInterest.type)}
              </div>
              <button 
                type="button" 
                className="admin-modal-close"
                onClick={() => setSelectedInterest(null)}
              >
                ✕
              </button>
            </div>

            <div className="admin-modal-body">
              <div className="modal-meta-grid">
                <div>
                  <label>Email</label>
                  <p><a href={`mailto:${selectedInterest.email}`}>{selectedInterest.email}</a></p>
                </div>
                <div>
                  <label>Phone</label>
                  <p>
                    <a href={`tel:${selectedInterest.phone}`}>{selectedInterest.phone}</a>
                    <a 
                      href={getWhatsAppLink(selectedInterest.phone)} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="modal-wa-btn"
                    >
                      <MessageCircle style={{ width: '14px', height: '14px' }} />
                      WhatsApp
                    </a>
                  </p>
                </div>
                <div>
                  <label>Session</label>
                  <p>{selectedInterest.session_title || 'General'}</p>
                </div>
                <div>
                  <label>Submitted At</label>
                  <p>{new Date(selectedInterest.created_at).toLocaleString()}</p>
                </div>
              </div>

              <div className="modal-message-box">
                <label>Message / Idea / Bio:</label>
                <div className="modal-message-text">
                  {selectedInterest.message || 'No message provided.'}
                </div>
              </div>

              <div className="modal-status-row">
                <label>Update Status:</label>
                <select
                  value={selectedInterest.status}
                  onChange={(e) => handleStatusChange(selectedInterest.id, e.target.value)}
                  className="modal-status-select"
                >
                  <option value="new">New</option>
                  <option value="contacted">Contacted</option>
                  <option value="reviewed">Reviewed</option>
                  <option value="archived">Archived</option>
                </select>
              </div>
            </div>

            <div className="admin-modal-footer">
              <button
                type="button"
                className="btn-danger-light"
                onClick={() => handleDelete(selectedInterest.id, selectedInterest.full_name)}
              >
                Delete
              </button>
              <button
                type="button"
                className="admin-btn-secondary"
                onClick={() => setSelectedInterest(null)}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
