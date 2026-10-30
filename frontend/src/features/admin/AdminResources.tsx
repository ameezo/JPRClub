import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { 
  type Resource, 
  apiClient 
} from '@/lib/api';
import { 
  Plus, 
  Search, 
  Edit2, 
  Trash2, 
  ExternalLink, 
  Star, 
  FileSpreadsheet, 
  Eye, 
  CheckCircle,
  XCircle
} from 'lucide-react';
import { ResourceModal } from '../resources/ResourceModal';

export default function AdminResources() {
  const [resources, setResources] = useState<Resource[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [levelFilter, setLevelFilter] = useState('all');

  // Modal
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingResource, setEditingResource] = useState<Resource | null>(null);

  const fetchResources = async () => {
    try {
      setLoading(true);
      const res = await apiClient.get<{ items: Resource[]; total: number }>('/resources', {
        params: { limit: 300 }
      });
      setResources(res.data.items || []);
    } catch (err) {
      console.error('Failed to fetch resources in admin:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchResources();
  }, []);

  const handleDelete = async (id: string, title: string) => {
    if (!window.confirm(`Are you sure you want to delete "${title}"?`)) return;
    try {
      await apiClient.delete(`/resources/${id}`);
      fetchResources();
    } catch (err) {
      console.error('Failed to delete resource:', err);
      alert('Failed to delete resource.');
    }
  };

  const handleSyncExcel = async () => {
    if (!window.confirm('Import / sync podcasts from Japanese_Podcasts_N5_to_N1.xlsx?')) return;
    try {
      const res = await apiClient.post<{ message: string; count: number }>('/resources/seed-excel');
      alert(res.data.message);
      fetchResources();
    } catch (err) {
      console.error('Failed to sync Excel:', err);
      alert('Failed to sync from Excel.');
    }
  };

  const filtered = resources.filter((r) => {
    if (categoryFilter !== 'all' && r.category !== categoryFilter) return false;
    if (levelFilter !== 'all') {
      if (levelFilter === 'jlpt' && r.level !== 'jlpt' && !r.jlpt_sublevel) return false;
      if (levelFilter !== 'jlpt' && r.level !== levelFilter) return false;
    }
    if (search.trim()) {
      const q = search.toLowerCase();
      const match = 
        r.title.toLowerCase().includes(q) ||
        (r.title_ar && r.title_ar.toLowerCase().includes(q)) ||
        (r.description && r.description.toLowerCase().includes(q));
      if (!match) return false;
    }
    return true;
  });

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto', paddingBottom: '40px' }}>
      {/* Top Header */}
      <div className="admin-dashboard-header">
        <div className="admin-dashboard-title-group">
          <h1>Learning Resources & Guides</h1>
          <p>Curate Japanese podcasts, reading materials, YouTube lessons, grammar references, and syllabary guides</p>
        </div>

        <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
          <Link
            to="/resources"
            target="_blank"
            rel="noopener noreferrer"
            className="admin-action-btn"
            style={{ display: 'inline-flex', alignItems: 'center', gap: '6px', textDecoration: 'none' }}
          >
            <Eye style={{ width: '16px', height: '16px' }} />
            <span>Public View</span>
          </Link>

          <button
            type="button"
            className="admin-action-btn"
            onClick={handleSyncExcel}
            title="Import from Japanese_Podcasts_N5_to_N1.xlsx"
            style={{ display: 'inline-flex', alignItems: 'center', gap: '6px' }}
          >
            <FileSpreadsheet style={{ width: '16px', height: '16px', color: '#16a34a' }} />
            <span>Sync Excel</span>
          </button>

          <button
            type="button"
            className="admin-btn-schedule"
            onClick={() => {
              setEditingResource(null);
              setIsModalOpen(true);
            }}
          >
            <Plus style={{ width: '16px', height: '16px' }} />
            <span>Add Resource</span>
          </button>
        </div>
      </div>

      {/* Metrics / Summary Cards */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px', marginBottom: '24px' }}>
        <div style={{ background: '#ffffff', padding: '16px 20px', borderRadius: '14px', border: '1px solid #e2e8f0', boxShadow: '0 1px 3px rgba(0,0,0,0.03)' }}>
          <div style={{ fontSize: '13px', color: '#64748b', fontWeight: 600 }}>Total Resources</div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#0f172a', marginTop: '4px' }}>{resources.length}</div>
        </div>

        <div style={{ background: '#ffffff', padding: '16px 20px', borderRadius: '14px', border: '1px solid #e2e8f0', boxShadow: '0 1px 3px rgba(0,0,0,0.03)' }}>
          <div style={{ fontSize: '13px', color: '#64748b', fontWeight: 600 }}>Podcasts</div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#e11d48', marginTop: '4px' }}>
            {resources.filter(r => r.category === 'podcast').length}
          </div>
        </div>

        <div style={{ background: '#ffffff', padding: '16px 20px', borderRadius: '14px', border: '1px solid #e2e8f0', boxShadow: '0 1px 3px rgba(0,0,0,0.03)' }}>
          <div style={{ fontSize: '13px', color: '#64748b', fontWeight: 600 }}>Mais Recommended</div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#d97706', marginTop: '4px' }}>
            {resources.filter(r => r.is_recommended).length}
          </div>
        </div>

        <div style={{ background: '#ffffff', padding: '16px 20px', borderRadius: '14px', border: '1px solid #e2e8f0', boxShadow: '0 1px 3px rgba(0,0,0,0.03)' }}>
          <div style={{ fontSize: '13px', color: '#64748b', fontWeight: 600 }}>Other Categories</div>
          <div style={{ fontSize: '24px', fontWeight: 800, color: '#2563eb', marginTop: '4px' }}>
            {resources.filter(r => r.category !== 'podcast').length}
          </div>
        </div>
      </div>

      {/* Filter / Search Bar */}
      <div style={{ background: '#ffffff', padding: '16px 20px', borderRadius: '16px', border: '1px solid #e2e8f0', marginBottom: '24px', display: 'flex', gap: '12px', flexWrap: 'wrap', alignItems: 'center' }}>
        <div style={{ flex: '1 1 240px', position: 'relative' }}>
          <Search style={{ position: 'absolute', top: '50%', left: '12px', transform: 'translateY(-50%)', width: '16px', height: '16px', color: '#94a3b8' }} />
          <input
            type="text"
            placeholder="Search by title, description..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ width: '100%', padding: '9px 12px 9px 36px', borderRadius: '10px', border: '1px solid #cbd5e1', fontSize: '14px', outline: 'none' }}
          />
        </div>

        <select
          value={categoryFilter}
          onChange={(e) => setCategoryFilter(e.target.value)}
          style={{ padding: '9px 14px', borderRadius: '10px', border: '1px solid #cbd5e1', fontSize: '14px', background: '#ffffff', outline: 'none' }}
        >
          <option value="all">All Categories</option>
          <option value="podcast">Podcast</option>
          <option value="reading">Reading</option>
          <option value="youtube">YouTube</option>
          <option value="websites">Websites</option>
          <option value="grammar">Grammar</option>
          <option value="hiragana_katakana">Hiragana & Katakana</option>
        </select>

        <select
          value={levelFilter}
          onChange={(e) => setLevelFilter(e.target.value)}
          style={{ padding: '9px 14px', borderRadius: '10px', border: '1px solid #cbd5e1', fontSize: '14px', background: '#ffffff', outline: 'none' }}
        >
          <option value="all">All Levels</option>
          <option value="starter">Starter</option>
          <option value="jlpt">JLPT</option>
          <option value="all_levels">All Levels</option>
          <option value="arabic_learner">Arabic Learner</option>
        </select>
      </div>

      {/* Table */}
      {loading ? (
        <div style={{ padding: '60px', textAlign: 'center', color: '#64748b' }}>Loading resources...</div>
      ) : filtered.length === 0 ? (
        <div style={{ padding: '60px', textAlign: 'center', background: '#ffffff', borderRadius: '16px', border: '1px dashed #cbd5e1', color: '#64748b' }}>
          No resources found matching the criteria.
        </div>
      ) : (
        <div style={{ background: '#ffffff', borderRadius: '16px', border: '1px solid #e2e8f0', overflow: 'hidden', boxShadow: '0 1px 3px rgba(0,0,0,0.02)' }}>
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13.5px' }}>
              <thead>
                <tr style={{ background: '#f8fafc', borderBottom: '1px solid #e2e8f0', color: '#475569', fontWeight: 600 }}>
                  <th style={{ padding: '14px 18px' }}>Resource Title</th>
                  <th style={{ padding: '14px 18px' }}>Category</th>
                  <th style={{ padding: '14px 18px' }}>Level</th>
                  <th style={{ padding: '14px 18px' }}>Featured</th>
                  <th style={{ padding: '14px 18px' }}>Status</th>
                  <th style={{ padding: '14px 18px', textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((item) => (
                  <tr key={item.id} style={{ borderBottom: '1px solid #f1f5f9' }}>
                    <td style={{ padding: '14px 18px', maxWidth: '320px' }}>
                      <div style={{ fontWeight: 600, color: '#0f172a' }}>{item.title}</div>
                      {item.title_ar && (
                        <div style={{ fontSize: '12px', color: '#64748b', marginTop: '2px' }} dir="rtl">{item.title_ar}</div>
                      )}
                      {item.description && (
                        <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '3px', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                          {item.description}
                        </div>
                      )}
                    </td>
                    <td style={{ padding: '14px 18px' }}>
                      <span style={{ display: 'inline-block', padding: '3px 8px', borderRadius: '6px', fontSize: '11.5px', fontWeight: 600, textTransform: 'capitalize', background: '#f1f5f9', color: '#334155' }}>
                        {item.category.replace('_', ' ')}
                      </span>
                    </td>
                    <td style={{ padding: '14px 18px' }}>
                      <span style={{ display: 'inline-block', padding: '3px 8px', borderRadius: '6px', fontSize: '11.5px', fontWeight: 600, background: item.level === 'starter' ? '#ecfdf5' : '#eef2ff', color: item.level === 'starter' ? '#047857' : '#4338ca' }}>
                        {item.jlpt_sublevel || item.level}
                      </span>
                    </td>
                    <td style={{ padding: '14px 18px' }}>
                      {item.is_recommended ? (
                        <span style={{ display: 'inline-flex', alignItems: 'center', gap: '4px', color: '#b45309', fontWeight: 600, fontSize: '12px', background: '#fef3c7', padding: '2px 8px', borderRadius: '9999px' }}>
                          <Star style={{ width: '12px', height: '12px', fill: 'currentColor' }} /> Mais Pick
                        </span>
                      ) : (
                        <span style={{ color: '#94a3b8', fontSize: '12px' }}>—</span>
                      )}
                    </td>
                    <td style={{ padding: '14px 18px' }}>
                      <span style={{ display: 'inline-flex', alignItems: 'center', gap: '4px', fontSize: '12px', fontWeight: 600, color: item.status === 'published' ? '#16a34a' : '#94a3b8' }}>
                        {item.status === 'published' ? <CheckCircle style={{ width: '14px', height: '14px' }} /> : <XCircle style={{ width: '14px', height: '14px' }} />}
                        {item.status}
                      </span>
                    </td>
                    <td style={{ padding: '14px 18px', textAlign: 'right' }}>
                      <div style={{ display: 'inline-flex', alignItems: 'center', gap: '8px' }}>
                        <a
                          href={item.url}
                          target="_blank"
                          rel="noopener noreferrer"
                          title="Open Link"
                          style={{ padding: '6px', color: '#64748b', borderRadius: '6px', border: '1px solid #e2e8f0', display: 'inline-flex' }}
                        >
                          <ExternalLink style={{ width: '14px', height: '14px' }} />
                        </a>
                        <button
                          type="button"
                          onClick={() => {
                            setEditingResource(item);
                            setIsModalOpen(true);
                          }}
                          title="Edit"
                          style={{ padding: '6px', background: 'none', color: '#0284c7', border: '1px solid #e2e8f0', borderRadius: '6px', cursor: 'pointer', display: 'inline-flex' }}
                        >
                          <Edit2 style={{ width: '14px', height: '14px' }} />
                        </button>
                        <button
                          type="button"
                          onClick={() => handleDelete(item.id, item.title)}
                          title="Delete"
                          style={{ padding: '6px', background: 'none', color: '#dc2626', border: '1px solid #e2e8f0', borderRadius: '6px', cursor: 'pointer', display: 'inline-flex' }}
                        >
                          <Trash2 style={{ width: '14px', height: '14px' }} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Add / Edit Modal */}
      <ResourceModal
        isOpen={isModalOpen}
        initialResource={editingResource}
        onClose={() => setIsModalOpen(false)}
        onSuccess={fetchResources}
      />
    </div>
  );
}
