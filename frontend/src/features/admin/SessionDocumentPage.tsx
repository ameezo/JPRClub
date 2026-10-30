import { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import { apiClient, type Session } from '@/lib/api';
import ArticleComposer, { type ArticleComposerData } from '@/components/editor/ArticleComposer';
import SessionMetricsPanel from './SessionMetricsPanel';
import { Loader2, BookOpen, Users, ArrowLeft } from 'lucide-react';

export default function SessionDocumentPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const currentTab = searchParams.get('tab') === 'metrics' ? 'metrics' : 'studio';

  const [session, setSession] = useState<Session | null>(null);
  const sessionRef = useRef<Session | null>(null);
  sessionRef.current = session;

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchSession = async () => {
      try {
        const res = await apiClient.get<Session>(`/sessions/${id}`);
        setSession(res.data);
        sessionRef.current = res.data;
      } catch (err: any) {
        setError(err?.response?.data?.detail || 'Failed to load session');
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchSession();
    }
  }, [id]);

  if (loading) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', gap: '16px' }}>
        <Loader2 size={32} className="animate-spin text-primary" style={{ color: '#e88599' }} />
        <p style={{ color: '#6b7280', fontSize: '14px' }}>Loading session documenter...</p>
      </div>
    );
  }

  if (error || !session) {
    return (
      <div style={{ textAlign: 'center', padding: '64px 20px' }}>
        <h2 style={{ fontSize: '1.25rem', color: '#dc2626', marginBottom: '8px' }}>Error Loading Session</h2>
        <p style={{ color: '#6b7280', marginBottom: '24px' }}>{error || 'Session not found.'}</p>
        <button
          type="button"
          onClick={() => navigate('/admin')}
          className="btn-composer-secondary"
        >
          Back to Dashboard
        </button>
      </div>
    );
  }

  const handleSaveDraft = async (data: ArticleComposerData) => {
    const s = sessionRef.current || session;
    if (!s) return;
    const payload = {
      title: data.title || s.title,
      studio_content: data.content,
      studio_content_format: 'blocknote',
      cover_image_url: data.coverImageUrl,
      documentation_status: 'draft',
      version: s.version,
    };

    const res = await apiClient.patch<Session>(`/sessions/${s.id}/documentation`, payload);
    setSession(res.data);
    sessionRef.current = res.data;
  };

  const handleManualSaveDraft = async (data: ArticleComposerData) => {
    await handleSaveDraft(data);
    navigate('/admin');
  };

  const handlePublishStudio = async (data: ArticleComposerData) => {
    const s = sessionRef.current || session;
    if (!s) return;
    const payload = {
      title: data.title || s.title,
      studio_content: data.content,
      studio_content_format: 'blocknote',
      cover_image_url: data.coverImageUrl,
      documentation_status: 'draft',
      version: s.version,
    };

    const res = await apiClient.patch<Session>(`/sessions/${s.id}/documentation`, payload);
    sessionRef.current = res.data;
    
    const pubRes = await apiClient.post<Session>(`/sessions/${s.id}/publish-studio`);
    setSession(pubRes.data);
    sessionRef.current = pubRes.data;

    const goToStudio = confirm(
      'Session documentation successfully published to the Reading Studio! 🎉\n\nWould you like to view the public Studio page now?'
    );
    if (goToStudio) {
      navigate(`/studio/${s.id}`);
    } else {
      navigate('/admin');
    }
  };

  const isPublished = session.documentation_status === 'published';
  const statusBadge = isPublished ? 'Published' : 'Draft';

  return (
    <div>
      {/* Top Documenter Tab Switcher */}
      <div style={{
        backgroundColor: '#ffffff',
        borderBottom: '1px solid #e5e7eb',
        padding: '12px 24px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        position: 'sticky',
        top: 0,
        zIndex: 20
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <button
            type="button"
            onClick={() => navigate('/admin')}
            style={{
              background: 'none',
              border: 'none',
              color: '#6b7280',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              fontSize: '14px',
              fontWeight: 500,
              padding: '6px 10px',
              borderRadius: '6px'
            }}
          >
            <ArrowLeft size={16} />
            <span>Dashboard</span>
          </button>
          <span style={{ color: '#d1d5db' }}>|</span>
          <span style={{ fontSize: '15px', fontWeight: 600, color: '#111827' }}>
            {session.title}
          </span>
        </div>

        {/* Tab Buttons */}
        <div style={{ display: 'flex', gap: '8px', backgroundColor: '#f3f4f6', padding: '4px', borderRadius: '10px' }}>
          <button
            type="button"
            onClick={() => setSearchParams({ tab: 'studio' })}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '6px 14px',
              borderRadius: '8px',
              border: 'none',
              fontSize: '13px',
              fontWeight: 600,
              cursor: 'pointer',
              backgroundColor: currentTab === 'studio' ? '#ffffff' : 'transparent',
              color: currentTab === 'studio' ? '#111827' : '#6b7280',
              boxShadow: currentTab === 'studio' ? '0 1px 3px rgba(0,0,0,0.1)' : 'none',
              transition: 'all 0.15s ease'
            }}
          >
            <BookOpen size={15} style={{ color: currentTab === 'studio' ? '#e88599' : '#9ca3af' }} />
            <span>Studio Story & Recap</span>
          </button>

          <button
            type="button"
            onClick={() => setSearchParams({ tab: 'metrics' })}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '6px 14px',
              borderRadius: '8px',
              border: 'none',
              fontSize: '13px',
              fontWeight: 600,
              cursor: 'pointer',
              backgroundColor: currentTab === 'metrics' ? '#ffffff' : 'transparent',
              color: currentTab === 'metrics' ? '#111827' : '#6b7280',
              boxShadow: currentTab === 'metrics' ? '0 1px 3px rgba(0,0,0,0.1)' : 'none',
              transition: 'all 0.15s ease'
            }}
          >
            <Users size={15} style={{ color: currentTab === 'metrics' ? '#0284c7' : '#9ca3af' }} />
            <span>Attendance & Feedback</span>
          </button>
        </div>
      </div>

      {/* Main Tab Content */}
      {currentTab === 'studio' ? (
        <ArticleComposer
          initialTitle={session.title}
          initialContent={session.studio_content}
          initialCoverImage={session.cover_image_url}
          initialLanguage={session.title_ar ? 'ar' : 'en'}
          onSaveDraft={handleSaveDraft}
          onManualSaveDraft={handleManualSaveDraft}
          onPublish={handlePublishStudio}
          mode="session"
          statusBadge={statusBadge}
          backUrl="/admin"
          titlePlaceholder="Document Session: Notes, summaries, and key points..."
          canPublishDirectly={true}
        />
      ) : (
        <SessionMetricsPanel 
          session={session} 
          onSessionUpdated={(updated) => {
            setSession(updated);
            sessionRef.current = updated;
          }} 
        />
      )}
    </div>
  );
}
